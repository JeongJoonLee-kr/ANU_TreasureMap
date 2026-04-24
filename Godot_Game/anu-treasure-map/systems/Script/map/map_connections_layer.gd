class_name MapConnectionsLayer
extends Control

const LINE_COLOR := Color(1, 1, 1, 0.72)
const LINE_WIDTH := 2.0

var location_data: Dictionary = {}
var location_markers: Dictionary = {}


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE


func refresh_connections(new_location_data: Dictionary, new_location_markers: Dictionary) -> void:
	location_data = new_location_data
	location_markers = new_location_markers
	queue_redraw()


func _draw() -> void:
	var drawn_edges: Dictionary = {}

	for location_id_variant in location_markers.keys():
		var location_id := String(location_id_variant)
		var marker := location_markers.get(location_id) as LocationMarker
		if marker == null:
			continue
		if not _is_location_active(location_id, marker):
			continue

		var data := location_data.get(location_id, {}) as Dictionary
		var neighbors = data.get("neighbors", [])

		for neighbor_variant in neighbors:
			if neighbor_variant is not String:
				continue

			var neighbor_id := String(neighbor_variant)
			var edge_key := _make_edge_key(location_id, neighbor_id)
			if drawn_edges.has(edge_key):
				continue

			var neighbor_marker := location_markers.get(neighbor_id) as LocationMarker
			if neighbor_marker == null:
				continue
			if not _is_location_active(neighbor_id, neighbor_marker):
				continue

			draw_line(
				_get_anchor_center(marker),
				_get_anchor_center(neighbor_marker),
				LINE_COLOR,
				LINE_WIDTH,
				true
			)
			drawn_edges[edge_key] = true


func _get_anchor_center(marker: LocationMarker) -> Vector2:
	var anchor := marker.get_anchor_control()
	if anchor == null:
		return Vector2.ZERO

	var anchor_rect := anchor.get_global_rect()
	var global_center := anchor_rect.position + anchor_rect.size / 2.0
	var local_transform: Transform2D = get_global_transform_with_canvas().affine_inverse()
	return local_transform * global_center


func _make_edge_key(a: String, b: String) -> String:
	if a < b:
		return "%s|%s" % [a, b]
	return "%s|%s" % [b, a]


func _is_location_active(location_id: String, marker: LocationMarker) -> bool:
	if marker != null and not marker.get_is_active():
		return false

	var data := location_data.get(location_id, {}) as Dictionary
	return bool(data.get("active", true))
