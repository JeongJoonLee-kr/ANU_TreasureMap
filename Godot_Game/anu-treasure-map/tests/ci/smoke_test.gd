extends SceneTree

const SCENE_PATHS := [
	"res://Start.tscn",
	"res://map.tscn",
	"res://locations.tscn",
]

const SCRIPT_PATHS := [
	"res://control.gd",
	"res://global.gd",
	"res://locations.gd",
	"res://map.gd",
	"res://map_event_panel.gd.gd",
	"res://ui_layer.gd",
]

const LOCATION_DATA_PATH := "res://data/locations.json"


func _init() -> void:
	var failures: Array[String] = []

	_check_project_settings(failures)
	_check_scripts(failures)
	_check_scenes(failures)
	_check_locations_data(failures)

	if failures.is_empty():
		print("Smoke test passed")
		quit(0)
		return

	for failure in failures:
		push_error(failure)

	quit(1)


func _check_project_settings(failures: Array[String]) -> void:
	var main_scene := ProjectSettings.get_setting("application/run/main_scene", "") as String
	if main_scene.is_empty():
		failures.append("Main scene is not configured in project settings")
	elif not ResourceLoader.exists(main_scene):
		failures.append("Configured main scene does not exist: %s" % main_scene)


func _check_scripts(failures: Array[String]) -> void:
	for script_path in SCRIPT_PATHS:
		if not ResourceLoader.exists(script_path):
			failures.append("Missing script: %s" % script_path)
			continue

		var script := load(script_path)
		if script == null:
			failures.append("Failed to load script: %s" % script_path)


func _check_scenes(failures: Array[String]) -> void:
	for scene_path in SCENE_PATHS:
		if not ResourceLoader.exists(scene_path):
			failures.append("Missing scene: %s" % scene_path)
			continue

		var packed_scene := load(scene_path) as PackedScene
		if packed_scene == null:
			failures.append("Failed to load packed scene: %s" % scene_path)
			continue

		var instance := packed_scene.instantiate()
		if instance == null:
			failures.append("Failed to instantiate scene: %s" % scene_path)
			continue

		instance.queue_free()


func _check_locations_data(failures: Array[String]) -> void:
	var file := FileAccess.open(LOCATION_DATA_PATH, FileAccess.READ)
	if file == null:
		failures.append("Failed to open %s" % LOCATION_DATA_PATH)
		return

	var parsed := JSON.parse_string(file.get_as_text())
	file.close()

	if typeof(parsed) != TYPE_DICTIONARY:
		failures.append("Location data must parse to a dictionary")
		return

	var locations := parsed as Dictionary
	if locations.is_empty():
		failures.append("Location data must contain at least one location")
		return

	for location_id in locations.keys():
		var location := locations[location_id] as Dictionary
		var image_path := location.get("image_path", "") as String
		var texts := location.get("texts", []) as Array

		if image_path.is_empty() or not ResourceLoader.exists(image_path):
			failures.append("Missing image for location %s: %s" % [location_id, image_path])

		if texts.is_empty():
			failures.append("Location %s must provide at least one text entry" % location_id)
