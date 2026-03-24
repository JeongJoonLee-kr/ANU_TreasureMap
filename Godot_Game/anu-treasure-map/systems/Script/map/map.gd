extends Control

# Store all location data loaded from locations.json.
var location_data: Dictionary = {}

# References to the popup panel and location icons on the map.
@onready var event_panel: Panel = $EventPanel
@onready var cafe_icon: Control = $CafeIcon
@onready var lake_icon: Control = $LakeIcon

@onready var stamina_label = $"../HUD/Topbar/StaminaLabel"
@onready var time_label = $"../HUD/Topbar/TimeLabel"
@onready var money_label = $"../HUD/Topbar/MoneyLabel"




func _ready() -> void:
	# Hide the popup when the map scene starts.
	event_panel.hide()
	update_resource_ui()
	load_location_data()
# Load the resource UI.
func update_resource_ui() -> void:
	stamina_label.text = "Stamina: " + str(Global.stamina)
	time_label.text = "Time: " + str(Global.time)
	money_label.text = "Money: $" + str(Global.money)
# Test，press P to change the number
func test_change_resources() -> void:
	Global.stamina -= 10
	Global.time += 1
	Global.money += 20
	update_resource_ui()
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("test_resource"):
		test_change_resources()
# Test End
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
	open_location("cafe", cafe_icon)


# Called when the lake icon is pressed.
func _on_lake_icon_pressed() -> void:
	open_location("lake", lake_icon)
