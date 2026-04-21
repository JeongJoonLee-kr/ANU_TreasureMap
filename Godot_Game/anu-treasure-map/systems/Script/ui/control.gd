extends Control


func _ready() -> void:
	pass


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")

#func _on_button_pressed() -> void:
#pass # Replace with function body.
