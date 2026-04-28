extends Node2D

@export var map_scene_path: String = "res://map.tscn"

const RANDOM_EVENT_PANEL_SCENE = preload("res://random_event_panel.tscn")
const PROGRESS_DOT_TEX := preload("res://resources/ui/location_dialogue/progress_dot.svg")
const PROGRESS_DOT_ACTIVE_TEX := preload("res://resources/ui/location_dialogue/progress_dot_active.svg")
const _OPTION_TEXT_COLOR := Color(0.2588, 0.6471, 0.9608, 1.0)
const _OPTION_TEXT_PRESSED := Color(0.12, 0.45, 0.74, 1.0)

var location_id: String = ""
var location_data: Dictionary = {}
var texts: Array[String] = []
var text_index: int = 0
var text_finished: bool = false

var _event_panel_instance: Panel = null
var _event_canvas_layer: CanvasLayer = null
var _exhaustion_toast: Panel = null

@onready var background: TextureRect = $TextureRect
@onready var dialogue_panel: Control = $DialogueLayer/DialoguePanel
@onready var dialogue_label: Label = $DialogueLayer/DialoguePanel/MainMargin/MainVBox/DialogueLabel
@onready var progress_dots: HBoxContainer = $DialogueLayer/DialoguePanel/MainMargin/MainVBox/BottomRow/ProgressDots
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

	# Connect EventManager's not_enough_ap signal for exhaustion toast
	if not EventManager.not_enough_ap.is_connected(_on_not_enough_ap):
		EventManager.not_enough_ap.connect(_on_not_enough_ap)

	# Try to trigger a random event before showing normal location content
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
		var tr := TextureRect.new()
		tr.mouse_filter = Control.MOUSE_FILTER_IGNORE
		tr.texture = PROGRESS_DOT_ACTIVE_TEX if i == text_index else PROGRESS_DOT_TEX
		tr.custom_minimum_size = Vector2(24, 8) if i == text_index else Vector2(8, 8)
		tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		progress_dots.add_child(tr)


func _try_random_event() -> void:
	var triggered_event: Variant = EventManager.try_trigger_event(location_id)
	if triggered_event != null and triggered_event is Dictionary:
		_show_random_event(triggered_event)
	else:
		show_location()


func _show_random_event(ev: Dictionary) -> void:
	# Show the location background behind the event overlay
	if location_data.has(location_id):
		var data: Dictionary = location_data[location_id] as Dictionary
		var image_path: String = data.get("image_path", "") as String
		if image_path != "":
			background.texture = load(image_path)

	# Hide normal location UI
	dialogue_panel.hide()
	event_panel.hide()

	# Create a CanvasLayer so the Panel overlay gets a proper Control context
	_event_canvas_layer = CanvasLayer.new()
	_event_canvas_layer.name = "EventCanvasLayer"
	_event_canvas_layer.layer = 10
	add_child(_event_canvas_layer)

	# Instantiate the event dialogue panel inside the CanvasLayer
	_event_panel_instance = RANDOM_EVENT_PANEL_SCENE.instantiate()
	_event_panel_instance.setup(ev)
	_event_panel_instance.event_completed.connect(_on_random_event_completed)
	_event_canvas_layer.add_child(_event_panel_instance)


func _on_random_event_completed(event_id: String, choice_key: String) -> void:
	EventManager.complete_event(event_id, choice_key)

	# Remove the CanvasLayer (which also frees the panel)
	if is_instance_valid(_event_canvas_layer):
		_event_canvas_layer.queue_free()
		_event_canvas_layer = null
		_event_panel_instance = null

	# Now show the normal location content
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

	var data: Dictionary = location_data[location_id] as Dictionary

	var image_path: String = data.get("image_path", "") as String
	if image_path != "":
		background.texture = load(image_path)

	texts = Array(data.get("texts", []), TYPE_STRING, "", null)
	text_index = 0
	text_finished = false

	options_container.hide()
	for child in options_container.get_children():
		child.queue_free()

	var config_file_path = "res://resources/Location/" + location_id + "_options.tres"
	if ResourceLoader.exists(config_file_path):
		var loaded_options = load(config_file_path)
		options_component.base_options = loaded_options
		options_component._ready()

	if texts.size() > 0:
		dialogue_label.text = texts[text_index]
		dialogue_panel.show()
		_refresh_dialogue_progress()
		event_panel.hide()
	else:
		dialogue_panel.hide()
		show_interactive_options()


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
	else:
		text_finished = true
		dialogue_panel.hide()
		show_interactive_options()


func show_interactive_options() -> void:
	dialogue_panel.hide()
	event_panel.show()
	options_container.show()

	for child in options_container.get_children():
		child.queue_free()

	if options_component.has_option("coffee_cost"):
		var coffee_cost: int = int(options_component.get_option("coffee_cost"))
		var coffee_button := Button.new()
		_style_option_button(coffee_button)
		coffee_button.text = "Buy Coffee (-%d Gold)" % coffee_cost
		coffee_button.pressed.connect(_on_buy_coffee.bind(coffee_cost))
		options_container.add_child(coffee_button)

	if options_component.has_option("meal_cost"):
		var meal_cost: int = int(options_component.get_option("meal_cost"))
		var meal_button := Button.new()
		_style_option_button(meal_button)
		meal_button.text = "Order Meal Combo (-%d Gold)" % meal_cost
		meal_button.pressed.connect(_on_buy_meal.bind(meal_cost))
		options_container.add_child(meal_button)

	if options_component.get_option("can_leave", true):
		var leave_button := Button.new()
		_style_option_button(leave_button)
		leave_button.text = "Leave"
		leave_button.pressed.connect(_on_back_button_pressed)
		options_container.add_child(leave_button)


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

	options_container.hide()
	texts = [
		"You spent %d Gold and enjoyed a hot coffee!" % cost,
		"You now have %d Gold left." % Global.money
	]
	text_index = 0
	text_finished = false

	dialogue_label.text = texts[text_index]
	dialogue_panel.show()
	_refresh_dialogue_progress()


func _on_buy_meal(cost: int) -> void:
	if not try_spend_money(cost):
		return

	options_container.hide()
	texts = [
		"You spent %d Gold and had a hearty meal!" % cost,
		"You now have %d Gold left." % Global.money
	]
	text_index = 0
	text_finished = false

	dialogue_label.text = texts[text_index]
	dialogue_panel.show()
	_refresh_dialogue_progress()


func try_spend_money(cost: int) -> bool:
	if Global.money < cost:
		dialogue_label.text = "You need %d Gold, but only have %d." % [cost, Global.money]
		dialogue_panel.show()
		event_panel.hide()
		_refresh_dialogue_progress()
		return false

	Global.money -= cost
	Global.notify_resources_changed()
	return true
