extends Node2D

# Path back to the main map scene.
@export var map_scene_path: String = "res://map.tscn"

# Store the current location id passed from the map scene.
var location_id: String = ""

# References to the UI elements in the shared location scene.
@onready var background: TextureRect = $TextureRect
@onready var title_label: Label = $TitleLabel
@onready var description: Label = $Control/Description
@onready var event_panel: Control = $Control/EventPanel
@onready var back_button: Button = $Control/BackButton

# Store loaded location data and dialogue state.
var location_data := {}
var texts: Array = []
var text_index: int = 0
var text_finished: bool = false

func _ready() -> void:
	# Read the selected location id from the global script.
	location_id = Global.current_location_id

	# Connect the Back button.
	back_button.pressed.connect(_on_back_button_pressed)

	# Load all location data and show the current location.
	load_location_data()
	show_location()

# Read and parse the location data file.
func load_location_data() -> void:
	var file = FileAccess.open("res://data/locations.json", FileAccess.READ)
	if file == null:
		push_error("Failed to open locations.json")
		return

	var json_text = file.get_as_text()
	file.close()

	var parsed = JSON.parse_string(json_text)
	if parsed == null:
		push_error("Failed to parse locations.json")
		return

	location_data = parsed

# Show the selected location using data from locations.json.
func show_location() -> void:
	if not location_data.has(location_id):
		push_error("Unknown location id: " + location_id)
		return

	var data = location_data[location_id]

	# Show the location title.
	title_label.text = data.get("title", "Unknown Location")

	# Load and show the background image.
	var image_path = data.get("image_path", "")
	if image_path != "":
		background.texture = load(image_path)

	# Load dialogue text list and reset text state.
	texts = data.get("texts", [])
	text_index = 0
	text_finished = false

	# Show the first text if available.
	if texts.size() > 0:
		description.text = texts[text_index]
		description.show()
		event_panel.show()
	else:
		description.hide()
		event_panel.hide()

# Return to the map scene.
func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file(map_scene_path)

# Listen for left mouse clicks to move to the next text.
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		show_next_text()

# Show the next text in the list.
# After the last text, hide the text panel.
func show_next_text() -> void:
	if text_finished:
		return

	if text_index < texts.size() - 1:
		text_index += 1
		description.text = texts[text_index]
	else:
		text_finished = true
		description.hide()
		event_panel.hide()
