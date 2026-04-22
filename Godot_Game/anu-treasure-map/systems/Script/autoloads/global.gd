extends Node

# ========== GAME STATE VARIABLES ==========
# Store the currently selected location id.
# This value is used to pass location information
# from the map scene to the shared location scene.
var current_location_id: String = "chifley_marie_reay"
var selected_location_id: String = "chifley_marie_reay"
var player_location_id: String = "chifley_marie_reay"

var stamina: int = 100
var current_week: int = 1
var current_week_tag: String = "week1"
var max_time_per_week: int = 8
var max_week: int = 16
var time: int = 8
var money: int = 50

var travel_time_per_edge: int = 1

var unlocked_clues: Array[String] = []

# ========== CACHED DATA ==========
# Loaded once in _ready(), consumed by ins.gd etc.
var characters_data: Dictionary = {}
var posts_data: Array = []

# ========== PLAYER DYNAMIC DATA ==========
var player_data = {"name": "Unknown", "major": "", "homebase": ""}

# ========== SAVE FILE CONFIGURATION ==========
# user:// is the designated folder on the player's OS for save files
const SAVE_PATH: String = "user://player_save.json"

@warning_ignore("UNUSED_SIGNAL")  # emitted from post_item.gd
signal clue_discovered(clue_id: String)
signal resources_changed(time_value: int, money_value: int)


func _ready() -> void:
	_load_characters()
	_load_posts()
	normalize_legacy_ids()


func notify_resources_changed() -> void:
	resources_changed.emit(time, money)


func refresh_week_tag() -> void:
	current_week_tag = "week%d" % current_week


func normalize_location_id(location_id: String) -> String:
	match location_id:
		"lab_cafe":
			return "chifley_marie_reay"
		"lake", "griffin_lake":
			return "lodges"
		_:
			return location_id


func normalize_legacy_ids() -> void:
	current_location_id = normalize_location_id(current_location_id)
	selected_location_id = normalize_location_id(selected_location_id)
	player_location_id = normalize_location_id(player_location_id)

	var homebase := str(player_data.get("homebase", ""))
	player_data["homebase"] = normalize_location_id(homebase)


# ========== DATA LOADING METHODS ==========
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


# ========== PERSISTENCE (SAVE/LOAD) METHODS ==========
func save_game() -> void:
	# Open the file in WRITE mode
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		var save_data := {
			"player_data": player_data,
			"progress":
			{
				"current_location_id": current_location_id,
				"selected_location_id": selected_location_id,
				"player_location_id": player_location_id,
				"current_week": current_week,
				"current_week_tag": current_week_tag,
				"max_time_per_week": max_time_per_week,
				"max_week": max_week,
				"time": time,
				"money": money
			}
		}
		# Convert the save data dictionary into a formatted JSON string (using tabs)
		var json_string = JSON.stringify(save_data, "\t")
		file.store_string(json_string)
		file.close()
		print(
			"Game saved successfully! JSON file created at: ",
			ProjectSettings.globalize_path(SAVE_PATH)
		)
	else:
		print("Error: Could not save the game file!")


func load_game() -> void:
	# Check if the save file exists before trying to read it
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		var json_string = file.get_as_text()
		file.close()

		# Parse the JSON string back into a Dictionary
		var parsed_data = JSON.parse_string(json_string)
		if typeof(parsed_data) == TYPE_DICTIONARY:
			if parsed_data.has("player_data"):
				player_data = parsed_data.get("player_data", player_data)

			var progress = parsed_data.get("progress", {})
			if progress is Dictionary:
				current_location_id = normalize_location_id(
					str(progress.get("current_location_id", current_location_id))
				)
				selected_location_id = normalize_location_id(
					str(progress.get("selected_location_id", selected_location_id))
				)
				player_location_id = normalize_location_id(
					str(progress.get("player_location_id", player_location_id))
				)
				current_week = int(progress.get("current_week", current_week))
				current_week_tag = str(progress.get("current_week_tag", current_week_tag))
				max_time_per_week = int(progress.get("max_time_per_week", max_time_per_week))
				max_week = int(progress.get("max_week", max_week))
				time = int(progress.get("time", time))
				money = int(progress.get("money", money))
			elif parsed_data.has("name") or parsed_data.has("major") or parsed_data.has("homebase"):
				# Backward compatibility with the old save structure.
				player_data = parsed_data

			normalize_legacy_ids()

			if current_week_tag == "":
				refresh_week_tag()

			print("Game loaded successfully. Current player data: ", player_data)
	else:
		print("No save file found. Using default player data.")
