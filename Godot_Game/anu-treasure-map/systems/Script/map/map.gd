extends Control

# Store all location data loaded from locations.json.
var location_data: Dictionary = {}

# References to the popup panel and location icons on the map.
@onready var event_panel = $EventPanel
@onready var cafe_icon: Control = $CafeIcon
@onready var lake_icon: Control = $LakeIcon
@onready var current_location_marker: TextureRect = $CurrentLocationMarker

@onready var stamina_label = $"../HUD/Topbar/StaminaLabel"
@onready var time_label = $"../HUD/Topbar/TimeLabel"
@onready var money_label = $"../HUD/Topbar/MoneyLabel"


func _ready() -> void:
	# Hide the popup when the map scene starts.
	event_panel.hide()
	load_location_data()
	update_resource_ui()
	await get_tree().process_frame
	update_current_location_marker()


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


# Test End
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("test_resource"):
		test_change_resources()


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


func update_current_location_marker() -> void:
	if Global.player_location_id == "":
		current_location_marker.hide()
		return

	var icon: Control = get_location_icon(Global.player_location_id)
	if icon == null:
		current_location_marker.hide()
		return

	var icon_visual_size := Vector2(icon.size.x * icon.scale.x, icon.size.y * icon.scale.y)
	current_location_marker.position = Vector2(
		icon.position.x + icon_visual_size.x - current_location_marker.size.x,
		icon.position.y + icon_visual_size.y - current_location_marker.size.y
	)
	current_location_marker.show()


func get_location_icon(location_id: String) -> Control:
	match location_id:
		"lab_cafe":
			return cafe_icon
		"lake":
			return lake_icon
		_:
			return null


# Open a location popup using loaded data.
# location_id: id of the selected location
# icon: the clicked icon on the map
func open_location(location_id: String, icon: Control) -> void:
	if not location_data.has(location_id):
		push_error("Unknown location id: " + location_id)
		return

	var data: Dictionary = location_data[location_id] as Dictionary
	var travel_cost := get_travel_cost(Global.player_location_id, location_id)
	var can_travel := can_travel_to_location(location_id)

	event_panel.open_popup(
		data.get("title", ""),
		data.get("description", ""),
		icon,
		location_id,
		travel_cost,
		can_travel
	)


func try_move_to_location(target_location_id: String) -> void:
	var travel_cost := get_travel_cost(Global.player_location_id, target_location_id)

	if travel_cost < 0:
		event_panel.show_travel_status("Travel Cost: Unreachable", false)
		return

	if Global.stamina < travel_cost:
		event_panel.show_travel_status("Travel Cost: %d Stamina (Not enough)" % travel_cost, false)
		return

	Global.stamina -= travel_cost
	Global.current_location_id = target_location_id
	Global.selected_location_id = target_location_id
	Global.player_location_id = target_location_id
	update_resource_ui()
	update_current_location_marker()
	get_tree().change_scene_to_file("res://locations.tscn")


func can_travel_to_location(target_location_id: String) -> bool:
	var travel_cost := get_travel_cost(Global.player_location_id, target_location_id)
	return travel_cost >= 0 and Global.stamina >= travel_cost


func get_travel_cost(from_location_id: String, to_location_id: String) -> int:
	if from_location_id == "" or to_location_id == "":
		return -1

	if not location_data.has(from_location_id) or not location_data.has(to_location_id):
		return -1

	if from_location_id == to_location_id:
		return 0

	var visited: Dictionary = {from_location_id: true}
	var queue: Array[Dictionary] = [{"id": from_location_id, "distance": 0}]

	while not queue.is_empty():
		var current: Dictionary = queue.pop_front()
		var current_id: String = current["id"]
		var current_distance: int = current["distance"]

		for neighbor_id in get_neighbors(current_id):
			if visited.has(neighbor_id):
				continue

			var next_distance := current_distance + 1
			if neighbor_id == to_location_id:
				return next_distance

			visited[neighbor_id] = true
			queue.push_back({"id": neighbor_id, "distance": next_distance})

	return -1


func get_neighbors(location_id: String) -> Array[String]:
	if not location_data.has(location_id):
		return Array([], TYPE_STRING, "", null)

	var data: Dictionary = location_data[location_id] as Dictionary
	var neighbors = data.get("neighbors", [])
	var result: Array[String] = []

	for neighbor in neighbors:
		if neighbor is String:
			result.append(neighbor)

	return result


# Called when the cafe icon is pressed.
func _on_cafe_icon_pressed() -> void:
	open_location("lab_cafe", cafe_icon)


# Called when the lake icon is pressed.
func _on_lake_icon_pressed() -> void:
	open_location("lake", lake_icon)
