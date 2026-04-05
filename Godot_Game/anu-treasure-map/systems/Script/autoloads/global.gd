extends Node

# ========== GAME STATE VARIABLES ==========
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

# ========== CACHED DATA ==========
# Loaded once in _ready(), consumed by ins.gd etc.
var characters_data: Dictionary = {}
var posts_data: Array = []

# ========== PLAYER DYNAMIC DATA ==========
var player_data = {
	"name": "Unknown",
	"major": "",
	"homebase": ""
}

# ========== SAVE FILE CONFIGURATION ==========
# user:// is the designated folder on the player's OS for save files
const SAVE_PATH: String = "user://player_save.json"

@warning_ignore("UNUSED_SIGNAL")   # emitted from post_item.gd
signal clue_discovered(clue_id: String)

func _ready() -> void:
	_load_characters()
	_load_posts()

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
		# Convert the player_data dictionary into a formatted JSON string (using tabs)
		var json_string = JSON.stringify(player_data, "\t")
		file.store_string(json_string)
		file.close()
		print("Game saved successfully! JSON file created at: ", ProjectSettings.globalize_path(SAVE_PATH))
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
			player_data = parsed_data
			print("Game loaded successfully. Current player data: ", player_data)
	else:
		print("No save file found. Using default player data.")
