extends Node

# Store the currently selected location id.
# This value is used to pass location information
# from the map scene to the shared location scene.
var current_location_id: String = "lab_cafe"
var selected_location_id: String = "lab_cafe"
var player_location_id: String = "lab_cafe"

var stamina: int = 100
var time: int = 8
var money: int = 50

var travel_time_per_edge: int = 1

var unlocked_clues: Array[String] = []

# Cached data — loaded once in _ready(), consumed by ins.gd etc.
var characters_data: Dictionary = {}
var posts_data: Array = []

@warning_ignore("UNUSED_SIGNAL")   # emitted from post_item.gd
signal clue_discovered(clue_id: String)


func _ready() -> void:
	_load_characters()
	_load_posts()


func _load_characters() -> void:
	var file = FileAccess.open("res://data/characters.json", FileAccess.READ)
	if file:
		var parsed = JSON.parse_string(file.get_as_text())
		if typeof(parsed) == TYPE_DICTIONARY:
			characters_data = parsed


func _load_posts() -> void:
	var file = FileAccess.open("res://data/ins_posts.json", FileAccess.READ)
	if file:
		var json = JSON.new()
		if json.parse(file.get_as_text()) == OK:
			if typeof(json.data) == TYPE_ARRAY:
				posts_data = json.data
