@tool
class_name LocationMarker
extends Control

signal preview_requested(location_id: String, image_path: String, anchor: Control)
signal preview_hidden
signal selected(location_id: String, anchor: Control)

const ROOT_SIZE := Vector2(220, 90)

@export var location_id: String = ""
@export var display_name_override: String = ""
@export var preview_image_path_override: String = ""

@onready var name_label: Label = $NameLabel
@onready var dot_button: Button = $DotButton

var preview_image_path: String = ""


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	size = ROOT_SIZE
	custom_minimum_size = ROOT_SIZE
	name_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	dot_button.focus_mode = Control.FOCUS_NONE

	if not dot_button.mouse_entered.is_connected(_on_dot_mouse_entered):
		dot_button.mouse_entered.connect(_on_dot_mouse_entered)
	if not dot_button.mouse_exited.is_connected(_on_dot_mouse_exited):
		dot_button.mouse_exited.connect(_on_dot_mouse_exited)
	if not dot_button.pressed.is_connected(_on_dot_pressed):
		dot_button.pressed.connect(_on_dot_pressed)

	_refresh_editor_preview()
	set_process(Engine.is_editor_hint())


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		_refresh_editor_preview()


func _refresh_editor_preview() -> void:
	if not is_instance_valid(name_label):
		return

	if display_name_override != "":
		name_label.text = display_name_override
		return

	if location_id != "":
		name_label.text = _format_location_name(location_id)
		return

	name_label.text = "Location"


func _format_location_name(raw_location_id: String) -> String:
	var words := raw_location_id.split("_", false)
	for i in range(words.size()):
		words[i] = String(words[i]).capitalize()
	return " ".join(words)


func configure_from_data(data: Dictionary) -> void:
	var display_name := display_name_override
	if display_name == "":
		display_name = str(data.get("map_label", data.get("title", location_id)))
	name_label.text = display_name

	preview_image_path = preview_image_path_override
	if preview_image_path == "":
		preview_image_path = str(data.get("preview_image_path", data.get("image_path", "")))


func get_anchor_control() -> Control:
	return dot_button


func _on_dot_mouse_entered() -> void:
	preview_requested.emit(location_id, preview_image_path, dot_button)


func _on_dot_mouse_exited() -> void:
	preview_hidden.emit()


func _on_dot_pressed() -> void:
	selected.emit(location_id, dot_button)
