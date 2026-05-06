extends Node2D

@export var map_scene_path: String = "res://map.tscn"

const CHOICE_PANEL_SCENE = preload("res://choice_panel.tscn")
const TREASURE_POPUP_SCENE = preload("res://treasure_popup.tscn")
const PROGRESS_DOT_TEX := preload("res://resources/ui/location_dialogue/progress_dot.svg")
const PROGRESS_DOT_ACTIVE_TEX := preload(
	"res://resources/ui/location_dialogue/progress_dot_active.svg"
)
const _OPTION_TEXT_COLOR := Color(0.2588, 0.6471, 0.9608, 1.0)
const _OPTION_TEXT_PRESSED := Color(0.12, 0.45, 0.74, 1.0)
const _EVENT_IMAGE_CHOICE_STAGES := {
	"A": "choice_a_success",
	"B": "choice_b_miss",
	"C": "choice_c_hint",
}

enum TextFlow { NONE, EVENT_NARRATIVE, EVENT_OUTCOME, LOCATION_TEXT, LOCATION_FEEDBACK }

var location_id: String = ""
var location_data: Dictionary = {}
var texts: Array[String] = []
var text_index: int = 0
var text_finished: bool = false

var _active_text_flow: int = TextFlow.NONE
var _active_event: Dictionary = {}
var _selected_event_choice_key: String = ""
var _selected_event_choice: Dictionary = {}
var _choice_canvas_layer: CanvasLayer = null
var _choice_panel_instance: Control = null
var _treasure_canvas_layer: CanvasLayer = null
var _treasure_popup_instance: Control = null
var _exhaustion_toast: Panel = null
var _event_scene_stage: String = ""

const _PORTRAIT_W := 280.0
const _PORTRAIT_H := 650.0
const _PORTRAIT_ACTIVE_SHIFT := 28.0
const _PORTRAIT_BOTTOM_GAP := 214.0
const _PORTRAIT_COLOR_ACTIVE := Color(1.0, 1.0, 1.0, 1.0)
const _PORTRAIT_COLOR_INACTIVE := Color(0.65, 0.65, 0.65, 0.78)

var _portrait_canvas_layer: CanvasLayer = null
var _portrait_nodes: Dictionary = {}
var _portrait_home_x: Dictionary = {}
var _portrait_active_x: Dictionary = {}
var _speakers: Array[String] = []

@onready var background: TextureRect = $TextureRect
@onready var dialogue_panel: Control = $DialogueLayer/DialoguePanel
@onready var dialogue_label: Label = $DialogueLayer/DialoguePanel/MainMargin/MainVBox/DialogueLabel
@onready
var progress_dots: HBoxContainer = $DialogueLayer/DialoguePanel/MainMargin/MainVBox/BottomRow/ProgressDots
@onready var event_panel: Control = $DialogueLayer/EventPanel
@onready var options_component: OptionsComponent = $OptionsComponent
@onready var options_container: VBoxContainer = $DialogueLayer/EventPanel/OptionsContainer


func _ready() -> void:
	location_id = (
		Global.selected_location_id
		if Global.selected_location_id != ""
		else Global.current_location_id
	)
	load_location_data()

	if not EventManager.not_enough_ap.is_connected(_on_not_enough_ap):
		EventManager.not_enough_ap.connect(_on_not_enough_ap)

	_try_random_event()


func load_location_data() -> void:
	var file: FileAccess = FileAccess.open("res://data/locations.json", FileAccess.READ)
	if file == null:
		push_error("Failed to open locations.json!")
		return

	var json_text: String = file.get_as_text()
	file.close()

	var parsed: Variant = JSON.parse_string(json_text)
	if parsed == null:
		push_error("Failed to parse locations.json!")
		return

	location_data = parsed as Dictionary


func _refresh_dialogue_progress() -> void:
	for c in progress_dots.get_children():
		c.queue_free()

	var n := texts.size()
	if n <= 0:
		return

	for i in n:
		var dot_rect := TextureRect.new()
		dot_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		dot_rect.texture = PROGRESS_DOT_ACTIVE_TEX if i == text_index else PROGRESS_DOT_TEX
		dot_rect.custom_minimum_size = Vector2(24, 8) if i == text_index else Vector2(8, 8)
		dot_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		dot_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		progress_dots.add_child(dot_rect)


func _try_random_event() -> void:
	_apply_location_background()

	var triggered_event: Variant = EventManager.try_trigger_event(location_id)
	if triggered_event != null and triggered_event is Dictionary:
		_start_random_event(triggered_event as Dictionary)
	else:
		show_location()


func _start_random_event(ev: Dictionary) -> void:
	_active_event = ev
	_selected_event_choice_key = ""
	_selected_event_choice = {}
	_hide_choice_panel()
	_hide_legacy_options_panel()

	_setup_portraits(ev)
	_speakers = _to_string_array(ev.get("speakers", []))

	var narrative := _to_string_array(ev.get("narrative", []))
	_show_text_sequence(narrative, TextFlow.EVENT_NARRATIVE)


func _show_event_choices() -> void:
	var choices: Dictionary = _active_event.get("choices", {})
	if choices.is_empty():
		_complete_current_event_and_show_location()
		return

	_update_portraits("narrator")
	_set_event_scene_stage("investigation")
	_show_choice_panel(_normalize_event_choices(choices), _on_event_choice_selected)


func _on_event_choice_selected(choice_key: String) -> void:
	_hide_choice_panel()
	_selected_event_choice_key = choice_key

	var choices: Dictionary = _active_event.get("choices", {})
	_selected_event_choice = choices.get(choice_key, {})
	_set_event_scene_stage(str(_EVENT_IMAGE_CHOICE_STAGES.get(choice_key, "")))

	_speakers = _to_string_array(_selected_event_choice.get("outcome_speakers", []))

	var outcome_texts := _to_string_array(_selected_event_choice.get("outcome_texts", []))
	_show_text_sequence(outcome_texts, TextFlow.EVENT_OUTCOME)


func _finish_event_outcome() -> void:
	if _selected_event_choice.get("treasure_found", false):
		_show_treasure_popup()
	else:
		_complete_current_event_and_show_location()


func _show_treasure_popup() -> void:
	_clear_portraits()
	_hide_treasure_popup()

	var treasure_name := str(_selected_event_choice.get("treasure_name", "Unknown Treasure"))
	var image_path := str(_active_event.get("treasure_image_path", ""))

	_treasure_canvas_layer = CanvasLayer.new()
	_treasure_canvas_layer.name = "TreasureCanvasLayer"
	_treasure_canvas_layer.layer = 10
	add_child(_treasure_canvas_layer)

	_treasure_popup_instance = TREASURE_POPUP_SCENE.instantiate()
	_treasure_popup_instance.setup(treasure_name, image_path)
	_treasure_popup_instance.choice_made.connect(_on_treasure_popup_choice_made)
	_treasure_canvas_layer.add_child(_treasure_popup_instance)


func _on_treasure_popup_choice_made(action: String) -> void:
	_hide_treasure_popup()
	_complete_current_event_and_show_location(action)


func _update_event_scene_for_text() -> void:
	match _active_text_flow:
		TextFlow.EVENT_NARRATIVE:
			var pivot := int(ceil(float(texts.size()) * 0.5))
			if pivot < 1:
				pivot = 1
			_set_event_scene_stage("intro" if text_index < pivot else "investigation")
		TextFlow.EVENT_OUTCOME:
			_set_event_scene_stage(
				str(_EVENT_IMAGE_CHOICE_STAGES.get(_selected_event_choice_key, ""))
			)
		_:
			_clear_event_scene_stage()


func _set_event_scene_stage(stage: String) -> void:
	if stage == "":
		_clear_event_scene_stage()
		return

	if _event_scene_stage == stage:
		return

	var image_path := _get_event_scene_image_path(stage)
	if image_path == "":
		_clear_event_scene_stage()
		return

	var texture := _load_texture(image_path)
	if texture == null:
		_clear_event_scene_stage()
		return

	_event_scene_stage = stage
	background.texture = texture


func _get_event_scene_image_path(stage: String) -> String:
	var paths: Dictionary = _active_event.get("event_image_paths", {})
	if paths.is_empty():
		return ""
	return str(paths.get(stage, ""))


func _clear_event_scene_stage() -> void:
	_event_scene_stage = ""


func _complete_current_event_and_show_location(treasure_action: String = "collect") -> void:
	var event_id := str(_active_event.get("id", ""))
	EventManager.complete_event(event_id, _selected_event_choice_key, treasure_action)
	_active_event = {}
	_selected_event_choice_key = ""
	_selected_event_choice = {}
	_clear_portraits()
	_clear_event_scene_stage()
	show_location()


func _on_not_enough_ap() -> void:
	_show_exhaustion_toast()


func _show_exhaustion_toast() -> void:
	if is_instance_valid(_exhaustion_toast):
		return

	_exhaustion_toast = Panel.new()
	_exhaustion_toast.set_anchors_preset(Control.PRESET_CENTER)
	_exhaustion_toast.custom_minimum_size = Vector2(700, 160)
	_exhaustion_toast.size = Vector2(700, 160)
	_exhaustion_toast.position = Vector2(-350, -80)

	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.15, 0.1, 0.1, 0.95)
	style.corner_radius_top_left = 12
	style.corner_radius_top_right = 12
	style.corner_radius_bottom_left = 12
	style.corner_radius_bottom_right = 12
	style.border_width_top = 2
	style.border_width_bottom = 2
	style.border_width_left = 2
	style.border_width_right = 2
	style.border_color = Color(0.8, 0.3, 0.3, 0.7)
	_exhaustion_toast.add_theme_stylebox_override("panel", style)

	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 24)
	margin.add_theme_constant_override("margin_right", 24)
	margin.add_theme_constant_override("margin_top", 16)
	margin.add_theme_constant_override("margin_bottom", 16)
	_exhaustion_toast.add_child(margin)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 12)
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	margin.add_child(vbox)

	var msg := Label.new()
	msg.text = EventManager.EXHAUSTED_MESSAGE
	msg.add_theme_font_size_override("font_size", 18)
	msg.add_theme_color_override("font_color", Color(1.0, 0.85, 0.7))
	msg.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	msg.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(msg)

	var ok_btn := Button.new()
	ok_btn.text = "OK"
	ok_btn.custom_minimum_size = Vector2(120, 36)
	ok_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	ok_btn.pressed.connect(
		func():
			if is_instance_valid(_exhaustion_toast):
				_exhaustion_toast.queue_free()
				_exhaustion_toast = null
	)
	vbox.add_child(ok_btn)

	add_child(_exhaustion_toast)


func show_location() -> void:
	if not location_data.has(location_id):
		return

	_hide_choice_panel()
	_hide_legacy_options_panel()
	_clear_event_scene_stage()
	_apply_location_background()
	_load_location_options_config()

	var data: Dictionary = location_data[location_id] as Dictionary
	var location_texts := _to_string_array(data.get("texts", []))
	_show_text_sequence(location_texts, TextFlow.LOCATION_TEXT)


func _apply_location_background() -> void:
	if not location_data.has(location_id):
		return
	var data: Dictionary = location_data[location_id] as Dictionary
	var image_path: String = data.get("image_path", "") as String
	if image_path != "":
		background.texture = load(image_path)


func _load_location_options_config() -> void:
	var config_file_path = "res://resources/Location/" + location_id + "_options.tres"
	if ResourceLoader.exists(config_file_path):
		var loaded_options: GameOptionsData = load(config_file_path)
		options_component.base_options = loaded_options
		options_component.load_from_dict(loaded_options.duplicate_data())
	else:
		options_component.base_options = null
		options_component.load_from_dict({})


func _show_text_sequence(next_texts: Array[String], flow: int) -> void:
	_hide_choice_panel()
	_hide_legacy_options_panel()

	texts = next_texts
	text_index = 0
	text_finished = false
	_active_text_flow = flow

	if texts.is_empty():
		_finish_text_sequence()
		return

	dialogue_label.text = texts[text_index]
	dialogue_panel.show()
	_refresh_dialogue_progress()
	_update_portraits_for_index(0)
	_update_event_scene_for_text()


func _finish_text_sequence() -> void:
	text_finished = true
	dialogue_panel.hide()

	match _active_text_flow:
		TextFlow.EVENT_NARRATIVE:
			_show_event_choices()
		TextFlow.EVENT_OUTCOME:
			_finish_event_outcome()
		TextFlow.LOCATION_TEXT:
			show_interactive_options()
		TextFlow.LOCATION_FEEDBACK:
			show_interactive_options()
		_:
			pass

	_active_text_flow = TextFlow.NONE


func _on_back_button_pressed() -> void:
	var current_scene := get_tree().current_scene
	if current_scene != null and current_scene.has_method("show_map"):
		current_scene.show_map()
	else:
		get_tree().change_scene_to_file(map_scene_path)


func _on_dialogue_continue_pressed() -> void:
	show_next_text()


func _unhandled_input(event: InputEvent) -> void:
	if not dialogue_panel.visible or text_finished:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		show_next_text()


func show_next_text() -> void:
	if text_finished:
		return

	if text_index < texts.size() - 1:
		text_index += 1
		dialogue_label.text = texts[text_index]
		_refresh_dialogue_progress()
		_update_portraits_for_index(text_index)
		_update_event_scene_for_text()
	else:
		_finish_text_sequence()


func show_interactive_options() -> void:
	dialogue_panel.hide()
	_hide_legacy_options_panel()

	var choices: Dictionary = {}
	var order := 0

	if options_component.has_option("coffee_cost"):
		var coffee_cost: int = int(options_component.get_option("coffee_cost"))
		choices["coffee"] = {
			"label": "Buy Coffee (-%d Gold)" % coffee_cost, "display_key": "", "_order": order
		}
		order += 1

	if options_component.has_option("meal_cost"):
		var meal_cost: int = int(options_component.get_option("meal_cost"))
		choices["meal"] = {
			"label": "Order Meal Combo (-%d Gold)" % meal_cost, "display_key": "", "_order": order
		}
		order += 1

	if options_component.get_option("can_leave", true):
		choices["leave"] = {"label": "Leave", "display_key": "", "_order": order}

	if choices.is_empty():
		return

	_show_choice_panel(choices, _on_location_choice_selected)


func _on_location_choice_selected(choice_key: String) -> void:
	_hide_choice_panel()

	match choice_key:
		"coffee":
			var coffee_cost: int = int(options_component.get_option("coffee_cost"))
			_on_buy_coffee(coffee_cost)
		"meal":
			var meal_cost: int = int(options_component.get_option("meal_cost"))
			_on_buy_meal(meal_cost)
		"leave":
			_on_back_button_pressed()


func _show_choice_panel(choices: Dictionary, handler: Callable) -> void:
	_hide_choice_panel()

	_choice_canvas_layer = CanvasLayer.new()
	_choice_canvas_layer.name = "ChoiceCanvasLayer"
	_choice_canvas_layer.layer = 8
	add_child(_choice_canvas_layer)

	_choice_panel_instance = CHOICE_PANEL_SCENE.instantiate()
	_choice_panel_instance.setup(choices)
	_choice_panel_instance.choice_selected.connect(handler)
	_choice_canvas_layer.add_child(_choice_panel_instance)


func _hide_choice_panel() -> void:
	if is_instance_valid(_choice_canvas_layer):
		_choice_canvas_layer.queue_free()
	_choice_canvas_layer = null
	_choice_panel_instance = null


func _hide_treasure_popup() -> void:
	if is_instance_valid(_treasure_canvas_layer):
		_treasure_canvas_layer.queue_free()
	_treasure_canvas_layer = null
	_treasure_popup_instance = null


func _hide_legacy_options_panel() -> void:
	event_panel.hide()
	options_container.hide()
	for child in options_container.get_children():
		child.queue_free()


func _normalize_event_choices(choices: Dictionary) -> Dictionary:
	var normalized: Dictionary = {}
	var keys := choices.keys()
	keys.sort()

	var order := 0
	for raw_key in keys:
		var key := str(raw_key)
		var choice_data: Dictionary = choices.get(raw_key, {})
		normalized[key] = {
			"label": str(choice_data.get("label", "...")), "display_key": key, "_order": order
		}
		order += 1

	return normalized


func _style_option_button(btn: Button) -> void:
	btn.custom_minimum_size = Vector2(0, 52)
	btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	btn.add_theme_font_override("font", load("res://resources/font/AlegreyaSans-Regular.ttf"))
	btn.add_theme_font_size_override("font_size", 20)
	btn.add_theme_color_override("font_color", _OPTION_TEXT_COLOR)
	btn.add_theme_color_override("font_hover_color", _OPTION_TEXT_COLOR)
	btn.add_theme_color_override("font_pressed_color", _OPTION_TEXT_PRESSED)

	var normal := StyleBoxFlat.new()
	normal.bg_color = Color(0.95, 0.98, 1.0, 1.0)
	normal.border_color = Color(0.35, 0.53, 0.94, 0.55)
	normal.border_width_left = 2
	normal.border_width_top = 2
	normal.border_width_right = 2
	normal.border_width_bottom = 2
	normal.corner_radius_top_left = 8
	normal.corner_radius_top_right = 8
	normal.corner_radius_bottom_left = 8
	normal.corner_radius_bottom_right = 8
	btn.add_theme_stylebox_override("normal", normal)

	var hover := normal.duplicate() as StyleBoxFlat
	hover.bg_color = Color(0.9, 0.96, 1.0, 1.0)
	hover.border_color = Color(0.26, 0.56, 0.94, 0.9)
	btn.add_theme_stylebox_override("hover", hover)

	var pressed := normal.duplicate() as StyleBoxFlat
	pressed.bg_color = Color(0.85, 0.93, 1.0, 1.0)
	pressed.border_color = Color(0.2, 0.5, 0.88, 1.0)
	btn.add_theme_stylebox_override("pressed", pressed)

	var focus := normal.duplicate() as StyleBoxFlat
	focus.bg_color = Color(0.9, 0.96, 1.0, 1.0)
	focus.border_color = Color(0.2, 0.5, 0.88, 1.0)
	btn.add_theme_stylebox_override("focus", focus)


func _on_buy_coffee(cost: int) -> void:
	if not try_spend_money(cost):
		return

	_show_text_sequence(
		[
			"You spent %d Gold and enjoyed a hot coffee!" % cost,
			"You now have %d Gold left." % Global.money
		],
		TextFlow.LOCATION_FEEDBACK
	)


func _on_buy_meal(cost: int) -> void:
	if not try_spend_money(cost):
		return

	_show_text_sequence(
		[
			"You spent %d Gold and had a hearty meal!" % cost,
			"You now have %d Gold left." % Global.money
		],
		TextFlow.LOCATION_FEEDBACK
	)


func try_spend_money(cost: int) -> bool:
	if Global.money < cost:
		_show_text_sequence(
			["You need %d Gold, but only have %d." % [cost, Global.money]],
			TextFlow.LOCATION_FEEDBACK
		)
		return false

	Global.money -= cost
	Global.notify_resources_changed()
	return true


func _load_texture(image_path: String) -> Texture2D:
	if image_path == "":
		return null

	if ResourceLoader.exists(image_path):
		var resource: Variant = load(image_path)
		if resource is Texture2D:
			return resource as Texture2D

	var file := FileAccess.open(image_path, FileAccess.READ)
	if file == null:
		return null

	var bytes := file.get_buffer(file.get_length())
	file.close()

	var img := Image.new()
	var decode_result := img.load_jpg_from_buffer(bytes)
	if decode_result != OK:
		img = Image.new()
		decode_result = img.load_png_from_buffer(bytes)
	if decode_result != OK:
		img = Image.new()
		decode_result = img.load_webp_from_buffer(bytes)
	if decode_result == OK:
		return ImageTexture.create_from_image(img)

	return null


func _to_string_array(value: Variant) -> Array[String]:
	var result: Array[String] = []
	if value is Array:
		for item in value:
			result.append(str(item))
	elif value != null:
		result.append(str(value))
	return result


func _setup_portraits(event: Dictionary) -> void:
	_clear_portraits()
	var config: Dictionary = event.get("portrait_config", {}) as Dictionary
	if config.is_empty():
		return

	_portrait_canvas_layer = CanvasLayer.new()
	_portrait_canvas_layer.layer = 2
	add_child(_portrait_canvas_layer)

	var vp_size := get_viewport().get_visible_rect().size

	for char_id in config:
		var cfg: Dictionary = config[char_id] as Dictionary
		var path := str(cfg.get("path", ""))
		if path == "":
			continue

		var tex := load(path) as Texture2D
		if tex == null:
			var img := Image.load_from_file(path)
			if img != null:
				tex = ImageTexture.create_from_image(img)
		if tex == null:
			continue

		var pw: float = float(cfg.get("w", _PORTRAIT_W))
		var ph: float = float(cfg.get("h", _PORTRAIT_H))
		var pgap: float = float(cfg.get("gap", _PORTRAIT_BOTTOM_GAP))

		var portrait := TextureRect.new()
		portrait.texture = tex
		portrait.size = Vector2(pw, ph)
		portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		portrait.mouse_filter = Control.MOUSE_FILTER_IGNORE
		portrait.modulate = _PORTRAIT_COLOR_INACTIVE

		var side := str(cfg.get("side", "left"))
		var home_x: float
		var active_x: float
		if side == "right":
			home_x = vp_size.x - pw - 380.0
			active_x = home_x - _PORTRAIT_ACTIVE_SHIFT
		else:
			home_x = 30.0
			active_x = home_x + _PORTRAIT_ACTIVE_SHIFT

		portrait.position = Vector2(home_x, vp_size.y - ph - pgap)
		_portrait_home_x[char_id] = home_x
		_portrait_active_x[char_id] = active_x
		_portrait_nodes[char_id] = portrait
		_portrait_canvas_layer.add_child(portrait)


func _update_portraits(speaker_id: String) -> void:
	for char_id in _portrait_nodes:
		var portrait := _portrait_nodes[char_id] as TextureRect
		var active: bool = char_id == speaker_id
		var target_x: float = _portrait_active_x[char_id] if active else _portrait_home_x[char_id]
		var target_color: Color = _PORTRAIT_COLOR_ACTIVE if active else _PORTRAIT_COLOR_INACTIVE
		var tw := portrait.create_tween().set_parallel(true).set_trans(Tween.TRANS_SINE).set_ease(
			Tween.EASE_OUT
		)
		tw.tween_property(portrait, "position:x", target_x, 0.25)
		tw.tween_property(portrait, "modulate", target_color, 0.25)


func _update_portraits_for_index(idx: int) -> void:
	if _portrait_nodes.is_empty():
		return
	var speaker := _speakers[idx] if idx < _speakers.size() else "narrator"
	_update_portraits(speaker)


func _clear_portraits() -> void:
	_portrait_nodes.clear()
	_portrait_home_x.clear()
	_portrait_active_x.clear()
	_speakers = []
	if is_instance_valid(_portrait_canvas_layer):
		_portrait_canvas_layer.queue_free()
	_portrait_canvas_layer = null
