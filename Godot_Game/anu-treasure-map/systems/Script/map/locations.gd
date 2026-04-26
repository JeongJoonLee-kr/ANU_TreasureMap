extends Node2D

@export var map_scene_path: String = "res://map.tscn"

const RANDOM_EVENT_PANEL_SCENE = preload("res://random_event_panel.tscn")

var location_id: String = ""
var location_data: Dictionary = {}
var texts: Array[String] = []
var text_index: int = 0
var text_finished: bool = false

var _event_panel_instance: Panel = null
var _event_canvas_layer: CanvasLayer = null
var _exhaustion_toast: Panel = null

@onready var background: TextureRect = $TextureRect
@onready var description: Label = $Control/Description
@onready var event_panel: Control = $Control/EventPanel
@onready var back_button: Button = $Control/BackButton
@onready var options_component: OptionsComponent = $OptionsComponent
@onready var options_container: VBoxContainer = $Control/EventPanel/OptionsContainer


func _ready() -> void:
	location_id = (
		Global.selected_location_id
		if Global.selected_location_id != ""
		else Global.current_location_id
	)
	back_button.pressed.connect(_on_back_button_pressed)
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
	description.hide()
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
		description.text = texts[text_index]
		description.show()
		event_panel.show()
	else:
		description.hide()
		show_interactive_options()


func _on_back_button_pressed() -> void:
	var current_scene := get_tree().current_scene
	if current_scene != null and current_scene.has_method("show_map"):
		current_scene.show_map()
	else:
		get_tree().change_scene_to_file(map_scene_path)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		show_next_text()


func show_next_text() -> void:
	if text_finished:
		return

	if text_index < texts.size() - 1:
		text_index += 1
		description.text = texts[text_index]
	else:
		text_finished = true
		description.hide()
		show_interactive_options()


func show_interactive_options() -> void:
	event_panel.show()
	options_container.show()

	for child in options_container.get_children():
		child.queue_free()

	if options_component.has_option("coffee_cost"):
		var coffee_cost: int = int(options_component.get_option("coffee_cost"))
		var coffee_button := Button.new()
		coffee_button.text = "Buy Coffee (-%d Gold)" % coffee_cost
		coffee_button.pressed.connect(_on_buy_coffee.bind(coffee_cost))
		options_container.add_child(coffee_button)

	if options_component.has_option("meal_cost"):
		var meal_cost: int = int(options_component.get_option("meal_cost"))
		var meal_button := Button.new()
		meal_button.custom_minimum_size = Vector2(0, 40)
		meal_button.text = "Order Meal Combo (-%d Gold)" % meal_cost
		meal_button.pressed.connect(_on_buy_meal.bind(meal_cost))
		options_container.add_child(meal_button)

	if options_component.get_option("can_leave", true):
		var leave_button := Button.new()
		leave_button.custom_minimum_size = Vector2(0, 40)
		leave_button.text = "Leave"
		leave_button.pressed.connect(_on_back_button_pressed)
		options_container.add_child(leave_button)


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

	description.text = texts[text_index]
	description.show()


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

	description.text = texts[text_index]
	description.show()


func try_spend_money(cost: int) -> bool:
	if Global.money < cost:
		description.text = "You need %d Gold, but only have %d." % [cost, Global.money]
		description.show()
		event_panel.show()
		return false

	Global.money -= cost
	Global.notify_resources_changed()
	return true
