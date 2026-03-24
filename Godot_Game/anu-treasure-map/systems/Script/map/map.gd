extends Control

# Store all location data loaded from locations.json.
var location_data: Dictionary = {}

# References to the popup panel and location icons on the map.
@onready var event_panel: Panel = $EventPanel
@onready var cafe_icon: Control = $CafeIcon
@onready var lake_icon: Control = $LakeIcon


func _ready() -> void:
	# Hide the popup when the map scene starts.
	event_panel.hide()
	load_location_data()


# Read and parse the location data file.
func load_location_data() -> void:
	var file: FileAccess = FileAccess.open("res://data/locations.json", FileAccess.READ)
	if file == null:
		push_error("Failed to open locations.json")
		return

	var json_text: String = file.get_as_text()
	file.close()

	var parsed: Variant = JSON.parse_string(json_text)
	if parsed == null:
		push_error("Failed to parse locations.json")
		return

	location_data = parsed as Dictionary


# Open a location popup using loaded data.
# location_id: id of the selected location
# icon: the clicked icon on the map
func open_location(location_id: String, icon: Control) -> void:
	if not location_data.has(location_id):
		push_error("Unknown location id: " + location_id)
		return

	var data: Dictionary = location_data[location_id] as Dictionary

	event_panel.open_popup(data.get("title", ""), data.get("description", ""), icon, location_id)


# Called when the cafe icon is pressed.
func _on_cafe_icon_pressed() -> void:
	open_location("lab_cafe", cafe_icon)


# Called when the lake icon is pressed.
func _on_lake_icon_pressed() -> void:
	open_location("lake", lake_icon)
