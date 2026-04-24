@tool
class_name LocationMarker
extends Control

signal preview_requested(location_id: String, image_path: String, anchor: Control)
signal preview_hidden
signal selected(location_id: String, anchor: Control)

const ROOT_SIZE := Vector2(220, 90)
const ACTIVE_DOT_MODULATE := Color(1, 1, 1, 1)

@export var location_id: String = ""
@export var display_name_override: String = ""
@export var preview_image_path_override: String = ""

@onready var name_label: Label = $NameLabel
@onready var dot_button: Button = $DotButton

var preview_image_path: String = ""
var is_active: bool = true
var active_normal_style: StyleBox
var active_hover_style: StyleBox
var inactive_style: StyleBoxFlat


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	size = ROOT_SIZE
	custom_minimum_size = ROOT_SIZE
	name_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	dot_button.focus_mode = Control.FOCUS_NONE
	_cache_button_styles()

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

	name_label.visible = true
	dot_button.disabled = false
	dot_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	dot_button.modulate = ACTIVE_DOT_MODULATE
	_apply_button_style(true)

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
	is_active = bool(data.get("active", true))
	name_label.visible = is_active
	dot_button.disabled = not is_active
	dot_button.mouse_default_cursor_shape = (
		Control.CURSOR_POINTING_HAND if is_active else Control.CURSOR_ARROW
	)
	dot_button.modulate = ACTIVE_DOT_MODULATE
	_apply_button_style(is_active)

	preview_image_path = preview_image_path_override
	if preview_image_path == "":
		preview_image_path = str(data.get("preview_image_path", data.get("image_path", "")))


func get_is_active() -> bool:
	return is_active


func _cache_button_styles() -> void:
	active_normal_style = dot_button.get_theme_stylebox("normal")
	active_hover_style = dot_button.get_theme_stylebox("hover")

	inactive_style = active_normal_style.duplicate() as StyleBoxFlat
	if inactive_style != null:
		inactive_style.bg_color = Color(0.52, 0.52, 0.52, 1)
		inactive_style.border_color = Color(0.78, 0.78, 0.78, 0.95)
		inactive_style.shadow_color = Color(0, 0, 0, 0.1)


func _apply_button_style(active: bool) -> void:
	if active:
		dot_button.add_theme_stylebox_override("normal", active_normal_style)
		dot_button.add_theme_stylebox_override("hover", active_hover_style)
		dot_button.add_theme_stylebox_override("pressed", active_hover_style)
		dot_button.add_theme_stylebox_override("focus", active_hover_style)
		dot_button.add_theme_stylebox_override("disabled", active_normal_style)
		return

	if inactive_style == null:
		return

	dot_button.add_theme_stylebox_override("normal", inactive_style)
	dot_button.add_theme_stylebox_override("hover", inactive_style)
	dot_button.add_theme_stylebox_override("pressed", inactive_style)
	dot_button.add_theme_stylebox_override("focus", inactive_style)
	dot_button.add_theme_stylebox_override("disabled", inactive_style)


func get_anchor_control() -> Control:
	return dot_button


func _on_dot_mouse_entered() -> void:
	if not is_active:
		return
	preview_requested.emit(location_id, preview_image_path, dot_button)


func _on_dot_mouse_exited() -> void:
	preview_hidden.emit()


func _on_dot_pressed() -> void:
	if not is_active:
		return
	selected.emit(location_id, dot_button)
