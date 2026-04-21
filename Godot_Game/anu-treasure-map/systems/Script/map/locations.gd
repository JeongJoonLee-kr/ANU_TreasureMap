extends Node2D

@export var map_scene_path: String = "res://map.tscn"

var location_id: String = ""
var location_data: Dictionary = {}
var texts: Array[String] = []
var text_index: int = 0
var text_finished: bool = false

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
	show_location()


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
