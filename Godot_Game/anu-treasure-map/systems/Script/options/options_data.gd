class_name GameOptionsData
extends Resource


@export var data: Dictionary = {}


func duplicate_data() -> Dictionary:
	var copied_data = {}
	for key in data.keys():
		copied_data[key] = data[key]
	return copied_data
