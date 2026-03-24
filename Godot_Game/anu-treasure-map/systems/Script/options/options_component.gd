class_name OptionsComponent
extends Node

## when options changed
signal option_changed(key: String, new_value: Variant)
signal options_reset

## drag the .tre file to inspecter
@export var base_options: GameOptionsData

var _current_options: Dictionary = {}


func _ready() -> void:
	# initilize
	if base_options:
		_current_options = base_options.duplicate_data()


## get data
func get_option(key: String, default_value: Variant = null) -> Variant:
	return _current_options.get(key, default_value)


## set data
func set_option(key: String, value: Variant) -> void:
	if not _current_options.has(key) or _current_options[key] != value:
		_current_options[key] = value
		option_changed.emit(key, value)


## check if the option has a key?
func has_option(key: String) -> bool:
	return _current_options.has(key)


## export the state
func export_to_dict() -> Dictionary:
	return _current_options.duplicate()


## read the laod
func load_from_dict(saved_data: Dictionary) -> void:
	_current_options = saved_data.duplicate()
	options_reset.emit()
