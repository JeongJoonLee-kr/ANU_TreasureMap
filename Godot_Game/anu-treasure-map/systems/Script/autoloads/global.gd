extends Node

# Store the currently selected location id.
# This value is used to pass location information
# from the map scene to the shared location scene.
var current_location_id: String = "lab_cafe"
var selected_location_id: String = "lab_cafe"
var player_location_id: String = "lab_cafe"

var time: int = 24
var money: int = 50
var travel_time_per_edge: int = 1
