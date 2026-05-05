extends Control

@onready var _background: TextureRect = $TextureRect
@onready var _title_label: Label = $Label
@onready var _start_button: TextureButton = $Button
@onready var _start_label: Label = $Button/StartLabel
@onready var _continue_button: TextureButton = $ContinueButton
@onready var _continue_label: Label = $ContinueButton/ContinueLabel
@onready var _settings_button: TextureButton = $SettingsButton
@onready var _settings_label: Label = $SettingsButton/SettingsLabel

const _TITLE_HEIGHT: float = 150.0
const _TITLE_TOP_RATIO: float = 0.25
const _BUTTON_SIZE: Vector2 = Vector2(400.0, 60.0)
const _BUTTON_GAP: float = 15.0
const _BUTTON_GROUP_TOP_RATIO: float = 0.68

## Matches Figma normal/hover label (#5E6C84) and selected/pressed text (#EF5350).
const _START_TEXT_NEUTRAL: Color = Color(0.3686, 0.4235, 0.5176, 1.0)
const _START_TEXT_ACTIVE: Color = Color(0.937, 0.325, 0.313, 1.0)

## Continue: active = #42A5F5 (Figma selected text).
const _CONTINUE_TEXT_NEUTRAL: Color = Color(0.3686, 0.4235, 0.5176, 1.0)
const _CONTINUE_TEXT_ACTIVE: Color = Color(0.2588, 0.6471, 0.9608, 1.0)

## Settings: active = #66BB6A.
const _SETTINGS_TEXT_NEUTRAL: Color = Color(0.3686, 0.4235, 0.5176, 1.0)
const _SETTINGS_TEXT_ACTIVE: Color = Color(0.4, 0.7333, 0.4157, 1.0)

var _start_pointer_held: bool = false
var _continue_pointer_held: bool = false
var _settings_pointer_held: bool = false


func _ready() -> void:
	_layout_start_screen()
	_update_start_label_color()
	_update_continue_label_color()
	_update_settings_label_color()
	_start_button.button_down.connect(_on_start_button_button_down)
	_start_button.button_up.connect(_on_start_button_button_up)
	_start_button.focus_entered.connect(_on_start_button_focus_in)
	_start_button.focus_exited.connect(_on_start_button_focus_out)
	_continue_button.button_down.connect(_on_continue_button_button_down)
	_continue_button.button_up.connect(_on_continue_button_button_up)
	_continue_button.focus_entered.connect(_on_continue_button_focus_in)
	_continue_button.focus_exited.connect(_on_continue_button_focus_out)
	_settings_button.button_down.connect(_on_settings_button_button_down)
	_settings_button.button_up.connect(_on_settings_button_button_up)
	_settings_button.focus_entered.connect(_on_settings_button_focus_in)
	_settings_button.focus_exited.connect(_on_settings_button_focus_out)


func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED and is_node_ready():
		_layout_start_screen()


func _layout_start_screen() -> void:
	var viewport_size: Vector2 = get_viewport_rect().size
	if viewport_size.x <= 0.0 or viewport_size.y <= 0.0:
		return

	_background.set_anchors_preset(Control.PRESET_FULL_RECT)
	_background.offset_left = 0.0
	_background.offset_top = 0.0
	_background.offset_right = 0.0
	_background.offset_bottom = 0.0
	_background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_background.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED

	var title_width: float = viewport_size.x * 0.9
	_title_label.position = Vector2(
		(viewport_size.x - title_width) * 0.5, viewport_size.y * _TITLE_TOP_RATIO
	)
	_title_label.size = Vector2(title_width, _TITLE_HEIGHT)
	_title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_title_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

	var button_x: float = (viewport_size.x - _BUTTON_SIZE.x) * 0.5
	var button_group_height: float = _BUTTON_SIZE.y * 3.0 + _BUTTON_GAP * 2.0
	var button_y: float = min(
		viewport_size.y * _BUTTON_GROUP_TOP_RATIO, viewport_size.y - button_group_height - 48.0
	)
	_position_button(_start_button, Vector2(button_x, button_y))
	_position_button(_continue_button, Vector2(button_x, button_y + _BUTTON_SIZE.y + _BUTTON_GAP))
	_position_button(
		_settings_button, Vector2(button_x, button_y + (_BUTTON_SIZE.y + _BUTTON_GAP) * 2.0)
	)


func _position_button(button: TextureButton, target_position: Vector2) -> void:
	button.position = target_position
	button.size = _BUTTON_SIZE
	button.custom_minimum_size = _BUTTON_SIZE


func _on_start_button_button_down() -> void:
	_start_pointer_held = true
	_update_start_label_color()


func _on_start_button_button_up() -> void:
	_start_pointer_held = false
	_update_start_label_color()


func _on_start_button_focus_in() -> void:
	_update_start_label_color()


func _on_start_button_focus_out() -> void:
	_update_start_label_color()


func _update_start_label_color() -> void:
	if _start_label == null:
		return
	var active := _start_pointer_held or _start_button.has_focus()
	_start_label.add_theme_color_override(
		"font_color", _START_TEXT_ACTIVE if active else _START_TEXT_NEUTRAL
	)


func _on_continue_button_button_down() -> void:
	_continue_pointer_held = true
	_update_continue_label_color()


func _on_continue_button_button_up() -> void:
	_continue_pointer_held = false
	_update_continue_label_color()


func _on_continue_button_focus_in() -> void:
	_update_continue_label_color()


func _on_continue_button_focus_out() -> void:
	_update_continue_label_color()


func _update_continue_label_color() -> void:
	if _continue_label == null:
		return
	var active := _continue_pointer_held or _continue_button.has_focus()
	_continue_label.add_theme_color_override(
		"font_color", _CONTINUE_TEXT_ACTIVE if active else _CONTINUE_TEXT_NEUTRAL
	)


func _on_settings_button_button_down() -> void:
	_settings_pointer_held = true
	_update_settings_label_color()


func _on_settings_button_button_up() -> void:
	_settings_pointer_held = false
	_update_settings_label_color()


func _on_settings_button_focus_in() -> void:
	_update_settings_label_color()


func _on_settings_button_focus_out() -> void:
	_update_settings_label_color()


func _update_settings_label_color() -> void:
	if _settings_label == null:
		return
	var active := _settings_pointer_held or _settings_button.has_focus()
	_settings_label.add_theme_color_override(
		"font_color", _SETTINGS_TEXT_ACTIVE if active else _SETTINGS_TEXT_NEUTRAL
	)


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")


func _on_continue_button_pressed() -> void:
	Global.load_game()
	get_tree().change_scene_to_file("res://main.tscn")


func _on_settings_button_pressed() -> void:
	print("TODO")

#func _on_button_pressed() -> void:
#pass # Replace with function body.
