extends Control

# Store all location data loaded from locations.json.
var location_data: Dictionary = {}
var location_markers: Dictionary = {}

const _PREVIEW_TITLE_DEFAULT_COLOR := Color(0.2588, 0.6471, 0.9608, 1.0)
const _CURRENT_MARKER_OFFSET := Vector2(0.0, -64.0)
const _PREVIEW_TITLE_COLORS := {
	LocationMarker.MedalRibbon.BLUE: Color(0.118, 0.533, 0.898, 1.0),
	LocationMarker.MedalRibbon.GREEN: Color(0.263, 0.627, 0.412, 1.0),
	LocationMarker.MedalRibbon.ORANGE: Color(0.984, 0.549, 0.0, 1.0),
	LocationMarker.MedalRibbon.PINK: Color(0.847, 0.106, 0.376, 1.0),
	LocationMarker.MedalRibbon.PURPLE: Color(0.369, 0.208, 0.694, 1.0),
	LocationMarker.MedalRibbon.CYAN: Color(0.0, 0.592, 0.655, 1.0),
}

# References to the popup panel and editor-placed location markers.
@onready var event_panel: Control = $EventPanel
@onready var markers_layer: Control = $MarkersLayer
@onready var connections_layer: MapConnectionsLayer = $MarkersLayer/ConnectionsLayer
@onready var current_location_marker: TextureRect = $CurrentLocationMarker
@onready var hover_preview: Panel = $HoverPreview
@onready var hover_preview_image: TextureRect = $HoverPreview/PreviewImage
@onready var hover_preview_title: Label = $HoverPreview/PreviewTitle


func _ready() -> void:
	event_panel.hide()
	hover_preview.hide()
	hover_preview_title.add_theme_font_size_override("font_size", 22)
	var bold_font_path := "res://resources/font/AlegreyaSans-Bold.ttf"
	if ResourceLoader.exists(bold_font_path):
		hover_preview_title.add_theme_font_override("font", load(bold_font_path))
	load_location_data()
	bind_location_markers()
	await get_tree().process_frame
	refresh_connection_lines()
	update_current_location_marker()


func test_change_resources() -> void:
	Global.time += 1
	Global.money += 20
	Global.notify_resources_changed()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("test_resource"):
		test_change_resources()


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


func bind_location_markers() -> void:
	location_markers.clear()

	for child in markers_layer.get_children():
		if child is not LocationMarker:
			continue

		var marker: LocationMarker = child
		if marker.location_id == "":
			push_warning("Location marker '%s' is missing location_id." % marker.name)
			continue

		if not location_data.has(marker.location_id):
			push_warning(
				(
					"Location marker '%s' points to unknown location id: %s"
					% [marker.name, marker.location_id]
				)
			)
			continue

		var data: Dictionary = location_data[marker.location_id] as Dictionary
		marker.configure_from_data(data)
		marker.preview_requested.connect(_on_location_preview_requested)
		marker.preview_hidden.connect(hide_location_preview)
		marker.selected.connect(_on_location_marker_selected)
		location_markers[marker.location_id] = marker


func refresh_connection_lines() -> void:
	if connections_layer == null:
		return
	connections_layer.refresh_connections(location_data, location_markers)


func update_current_location_marker() -> void:
	if Global.player_location_id == "":
		current_location_marker.hide()
		return

	var anchor := get_location_anchor(Global.player_location_id)
	if anchor == null:
		current_location_marker.hide()
		return

	var anchor_rect := anchor.get_global_rect()
	var anchor_center := anchor_rect.position + anchor_rect.size / 2.0
	var local_anchor_center := to_parent_local_point(current_location_marker, anchor_center)
	current_location_marker.position = (
		local_anchor_center + _CURRENT_MARKER_OFFSET - current_location_marker.size / 2.0
	)
	current_location_marker.show()


func get_location_anchor(location_id: String) -> Control:
	var marker = location_markers.get(location_id)
	if marker == null:
		return null
	return marker.get_anchor_control()


func open_location(location_id: String, anchor: Control) -> void:
	if not location_data.has(location_id):
		push_error("Unknown location id: " + location_id)
		return

	if not is_location_active(location_id):
		return

	var data: Dictionary = location_data[location_id] as Dictionary
	var travel_time := get_travel_time(Global.player_location_id, location_id)
	var can_travel := can_travel_to_location(location_id)
	var title := str(data.get("title", location_id))
	var prompt := str(data.get("travel_prompt", "Travel to %s?" % title))

	event_panel.open_popup(title, prompt, anchor, location_id, travel_time, can_travel)


func try_move_to_location(target_location_id: String) -> void:
	var travel_time := get_travel_time(Global.player_location_id, target_location_id)

	if travel_time < 0:
		event_panel.show_travel_status("Travel Time: Unreachable", false)
		return

	if Global.time < travel_time:
		event_panel.show_travel_status("Travel Time: %d (Not enough)" % travel_time, false)
		return

	var current_scene := get_tree().current_scene
	if current_scene != null and current_scene.has_method("spend_time"):
		if not current_scene.spend_time(travel_time):
			event_panel.show_travel_status("Travel Time: %d (Not enough)" % travel_time, false)
			return
	else:
		Global.time -= travel_time
		if Global.time <= 0:
			Global.current_week += 1
			Global.refresh_week_tag()
			Global.time = Global.max_time_per_week
		Global.notify_resources_changed()

	Global.current_location_id = target_location_id
	Global.selected_location_id = target_location_id
	Global.player_location_id = target_location_id
	update_current_location_marker()

	if current_scene != null and current_scene.has_method("show_location"):
		current_scene.show_location(target_location_id)
	else:
		get_tree().change_scene_to_file("res://locations.tscn")


func can_travel_to_location(target_location_id: String) -> bool:
	if not is_location_active(target_location_id):
		return false
	var travel_time := get_travel_time(Global.player_location_id, target_location_id)
	return travel_time >= 0 and Global.time >= travel_time


func get_travel_time(from_location_id: String, to_location_id: String) -> int:
	if from_location_id == "" or to_location_id == "":
		return -1

	if not location_data.has(from_location_id) or not location_data.has(to_location_id):
		return -1

	if not is_location_active(to_location_id):
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
				return next_distance * Global.travel_time_per_edge

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
		if neighbor is String and is_location_active(String(neighbor)):
			result.append(neighbor)

	return result


func is_location_active(location_id: String) -> bool:
	if not location_data.has(location_id):
		return false

	var data: Dictionary = location_data[location_id] as Dictionary
	return bool(data.get("active", true))


func to_parent_local_point(node: CanvasItem, global_point: Vector2) -> Vector2:
	var parent_canvas: CanvasItem = node.get_parent() as CanvasItem
	if parent_canvas == null:
		return global_point

	var parent_transform: Transform2D = (
		parent_canvas.get_global_transform_with_canvas().affine_inverse()
	)
	return parent_transform * global_point


func show_location_preview(image_path: String, title: String, title_color: Color, anchor: Control) -> void:
	if image_path == "" or not ResourceLoader.exists(image_path):
		hide_location_preview()
		return

	hover_preview_image.texture = load(image_path)
	hover_preview_title.text = title
	hover_preview_title.add_theme_color_override("font_color", title_color)
	hover_preview.show()
	await get_tree().process_frame

	var anchor_rect := anchor.get_global_rect()
	var anchor_center := anchor_rect.position + anchor_rect.size / 2.0
	var desired_global_pos := Vector2(
		anchor_center.x - hover_preview.size.x / 2.0,
		anchor_rect.position.y - hover_preview.size.y - 16.0
	)

	var viewport_size := get_viewport_rect().size
	var local_pos: Vector2 = to_parent_local_point(hover_preview, desired_global_pos)

	local_pos.x = clampf(local_pos.x, 16.0, viewport_size.x - hover_preview.size.x - 16.0)
	local_pos.y = clampf(local_pos.y, 16.0, viewport_size.y - hover_preview.size.y - 16.0)

	hover_preview.position = local_pos


func hide_location_preview() -> void:
	hover_preview.hide()
	hover_preview_image.texture = null
	hover_preview_title.text = ""


func _on_location_preview_requested(
	location_id: String, image_path: String, anchor: Control
) -> void:
	var title := location_id
	if location_data.has(location_id):
		var data := location_data[location_id] as Dictionary
		title = str(data.get("map_label", data.get("title", location_id)))
	var title_color := _PREVIEW_TITLE_DEFAULT_COLOR
	var marker := location_markers.get(location_id) as LocationMarker
	if marker != null and _PREVIEW_TITLE_COLORS.has(marker.medal_ribbon):
		title_color = _PREVIEW_TITLE_COLORS[marker.medal_ribbon]
	show_location_preview(image_path, title, title_color, anchor)


func _on_location_marker_selected(location_id: String, anchor: Control) -> void:
	hide_location_preview()
	open_location(location_id, anchor)
