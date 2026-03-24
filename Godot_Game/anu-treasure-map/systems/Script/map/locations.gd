extends Node2D

# --- State Variables ---
@export var map_scene_path: String = "res://map.tscn"
var location_id: String = ""
var location_data: Dictionary = {}
var texts: Array[String] = []
var text_index: int = 0
var text_finished: bool = false

# --- UI References ---
@onready var background: TextureRect = $TextureRect
@onready var title_label: Label = $TitleLabel
@onready var description: Label = $Control/Description
@onready var event_panel: Control = $Control/EventPanel
@onready var back_button: Button = $Control/BackButton

# add the options components
# --- Custom Components ---
@onready var options_component: OptionsComponent = $OptionsComponent
@onready var options_container: VBoxContainer = $Control/EventPanel/OptionsContainer

func _ready() -> void:
	location_id = Global.current_location_id
	back_button.pressed.connect(_on_back_button_pressed)
	load_location_data()
	show_location()

## Fetches location metadata from the local JSON database
func load_location_data() -> void:
	var file: FileAccess = FileAccess.open("res://data/locations.json", FileAccess.READ)
	if file:
		var json_text: String = file.get_as_text()
		var parsed: Variant = JSON.parse_string(json_text)
		if parsed:
			location_data = parsed as Dictionary
	file.close()

## Updates the UI with background images, titles, and initiates dialogue
func show_location() -> void:
	if not location_data.has(location_id):
		return

	var data: Dictionary = location_data[location_id] as Dictionary
	title_label.text = data.get("title", "Unknown Location")
	
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

# --- Navigation Logic ---
func _on_back_button_pressed() -> void:
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


# the core logic of options interactive
func show_interactive_options() -> void:
	event_panel.show()
	options_container.show()
	
	# 1. if the coffee price is setted
	if options_component.has_option("coffee_cost"):
		var btn = Button.new()
		#btn.custom_minimum_size = Vector2(0, 40)
		var cost = options_component.get_option("coffee_cost")
		btn.text = "Buy Coffee (-" + str(cost) + " Gold)"
		btn.pressed.connect(_on_buy_coffee.bind(cost))
		options_container.add_child(btn)
		
	# 2. if the meal price is setted
	if options_component.has_option("meal_cost"):
		var btn = Button.new()
		btn.custom_minimum_size = Vector2(0, 40) # 防止压扁
		var cost = options_component.get_option("meal_cost")
		btn.text = "Order Meal Combo (-" + str(cost) + " Gold)"
		btn.pressed.connect(_on_buy_meal.bind(cost))
		options_container.add_child(btn)
		
	# 3. default, just leave
	if options_component.get_option("can_leave", true):
		var btn = Button.new()
		btn.custom_minimum_size = Vector2(0, 40) # 防止压扁
		btn.text = "Leave"
		btn.pressed.connect(_on_back_button_pressed)
		options_container.add_child(btn)

# --- the events ---
func _on_buy_coffee(cost: int) -> void:
	print("You spend $", cost, " and get one coffee!")
	# TODO
	
func _on_buy_meal(cost: int) -> void:
	print("You spend $", cost, " and have a good meal!")
	# TODO
