extends Control

@onready var _start_button: TextureButton = $Button
@onready var _start_label: Label = $Button/StartLabel
@onready var _continue_button: TextureButton = $ContinueButton
@onready var _continue_label: Label = $ContinueButton/ContinueLabel
@onready var _settings_button: TextureButton = $SettingsButton
@onready var _settings_label: Label = $SettingsButton/SettingsLabel

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
