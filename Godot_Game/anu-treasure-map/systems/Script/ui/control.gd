extends Control

const START_BGM := "res://resources/music/first.mp3"
const SETTINGS_PANEL_SCRIPT = preload("res://systems/Script/ui/settings_panel.gd")

@onready var _background: TextureRect = $TextureRect
@onready var _title_logo: Control = $StartLogo
@onready var _start_button: TextureButton = $Button
@onready var _start_label: Label = $Button/StartLabel
@onready var _continue_button: TextureButton = $ContinueButton
@onready var _continue_label: Label = $ContinueButton/ContinueLabel
@onready var _settings_button: TextureButton = $SettingsButton
@onready var _settings_label: Label = $SettingsButton/SettingsLabel
@onready var _exit_button: TextureButton = $ExitButton
@onready var _exit_label: Label = $ExitButton/ExitLabel

const _TITLE_LOGO_ASPECT: float = 600.0 / 340.0
const _TITLE_TOP_RATIO: float = 0.115
const _TITLE_MAX_WIDTH: float = 760.0
const _TITLE_BOTTOM_GAP: float = 72.0
const _BUTTON_SIZE: Vector2 = Vector2(400.0, 60.0)
const _BUTTON_GAP: float = 15.0
const _BUTTON_GROUP_TOP_RATIO: float = 0.64

## Matches Figma normal/hover label (#5E6C84) and selected/pressed text (#EF5350).
const _START_TEXT_NEUTRAL: Color = Color(0.3686, 0.4235, 0.5176, 1.0)
const _START_TEXT_ACTIVE: Color = Color(0.937, 0.325, 0.313, 1.0)

## Continue: active = #42A5F5 (Figma selected text).
const _CONTINUE_TEXT_NEUTRAL: Color = Color(0.3686, 0.4235, 0.5176, 1.0)
const _CONTINUE_TEXT_ACTIVE: Color = Color(0.2588, 0.6471, 0.9608, 1.0)

## Settings: active = #66BB6A.
const _SETTINGS_TEXT_NEUTRAL: Color = Color(0.3686, 0.4235, 0.5176, 1.0)
const _SETTINGS_TEXT_ACTIVE: Color = Color(0.4, 0.7333, 0.4157, 1.0)

## Exit: active = #7C4DFF (distinct from Start).
const _EXIT_TEXT_NEUTRAL: Color = Color(0.3686, 0.4235, 0.5176, 1.0)
const _EXIT_TEXT_ACTIVE: Color = Color(0.486, 0.302, 1.0, 1.0)

var _start_pointer_held: bool = false
var _continue_pointer_held: bool = false
var _settings_pointer_held: bool = false
var _exit_pointer_held: bool = false
var _main_scene_preloaded := false


func _ready() -> void:
	_layout_start_screen()
	AudioManager.play_bgm(START_BGM)
	_update_start_label_color()
	_update_continue_label_color()
	_update_settings_label_color()
	_update_exit_label_color()
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
	_exit_button.button_down.connect(_on_exit_button_button_down)
	_exit_button.button_up.connect(_on_exit_button_button_up)
	_exit_button.focus_entered.connect(_on_exit_button_focus_in)
	_exit_button.focus_exited.connect(_on_exit_button_focus_out)
	# Start preloading main.tscn in the background while the intro plays.
	ResourceLoader.load_threaded_request("res://main.tscn", "", true)


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

	var button_x: float = (viewport_size.x - _BUTTON_SIZE.x) * 0.5
	var button_group_height: float = _BUTTON_SIZE.y * 4.0 + _BUTTON_GAP * 3.0
	var button_y: float = min(
		viewport_size.y * _BUTTON_GROUP_TOP_RATIO, viewport_size.y - button_group_height - 48.0
	)
	var logo_top: float = max(24.0, viewport_size.y * _TITLE_TOP_RATIO)
	var logo_width: float = min(viewport_size.x * 0.62, _TITLE_MAX_WIDTH)
	var max_logo_height: float = max(120.0, button_y - logo_top - _TITLE_BOTTOM_GAP)
	var logo_height: float = min(logo_width / _TITLE_LOGO_ASPECT, max_logo_height)
	logo_width = logo_height * _TITLE_LOGO_ASPECT
	_title_logo.position = Vector2((viewport_size.x - logo_width) * 0.5, logo_top)
	_title_logo.size = Vector2(logo_width, logo_height)

	_position_button(_start_button, Vector2(button_x, button_y))
	_position_button(_continue_button, Vector2(button_x, button_y + _BUTTON_SIZE.y + _BUTTON_GAP))
	_position_button(
		_settings_button, Vector2(button_x, button_y + (_BUTTON_SIZE.y + _BUTTON_GAP) * 2.0)
	)
	_position_button(
		_exit_button, Vector2(button_x, button_y + (_BUTTON_SIZE.y + _BUTTON_GAP) * 3.0)
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


func _on_exit_button_button_down() -> void:
	_exit_pointer_held = true
	_update_exit_label_color()


func _on_exit_button_button_up() -> void:
	_exit_pointer_held = false
	_update_exit_label_color()


func _on_exit_button_focus_in() -> void:
	_update_exit_label_color()


func _on_exit_button_focus_out() -> void:
	_update_exit_label_color()


func _update_exit_label_color() -> void:
	if _exit_label == null:
		return
	var active := _exit_pointer_held or _exit_button.has_focus()
	_exit_label.add_theme_color_override(
		"font_color", _EXIT_TEXT_ACTIVE if active else _EXIT_TEXT_NEUTRAL
	)


func _on_start_button_pressed() -> void:
	# Full reset for a fresh game — clear all progress and delete saves.
	Global.player_data["major"] = ""
	Global.player_data["homebase"] = ""
	Global.current_week = 1
	Global.refresh_week_tag()
	Global.time = Global.max_time_per_week
	Global.money = 50
	Global.current_location_id = "chifley_marie_reay"
	Global.selected_location_id = "chifley_marie_reay"
	Global.player_location_id = "chifley_marie_reay"
	Global.unlocked_clues.clear()
	Global.unlocked_treasures.clear()
	Global.shared_treasure_records.clear()
	Global._rebuild_posts_data()
	if Engine.has_singleton("EventManager") or get_node_or_null("/root/EventManager") != null:
		var em := get_node_or_null("/root/EventManager")
		if em != null and em.has_method("reset_for_new_run"):
			em.reset_for_new_run()
	# Delete the save file so "Continue" won't find stale data.
	if FileAccess.file_exists(Global.SAVE_PATH):
		DirAccess.remove_absolute(Global.SAVE_PATH)
	AudioManager.play_default_bgm()
	_do_start_transition()


func _on_continue_button_pressed() -> void:
	Global.load_game()
	AudioManager.play_default_bgm()
	_do_start_transition()


func _on_settings_button_pressed() -> void:
	_open_settings_panel()


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _open_settings_panel() -> void:
	var existing := get_tree().root.get_node_or_null("SettingsPanel")
	if existing != null:
		return

	var settings_panel := SETTINGS_PANEL_SCRIPT.new()
	settings_panel.name = "SettingsPanel"
	get_tree().root.add_child(settings_panel)


func _do_start_transition() -> void:
	# Use the preloaded scene if background loading has completed.
	var status := ResourceLoader.load_threaded_get_status("res://main.tscn")
	if status == ResourceLoader.THREAD_LOAD_LOADED:
		var packed_scene := ResourceLoader.load_threaded_get("res://main.tscn")
		if packed_scene is PackedScene:
			get_tree().change_scene_to_packed(packed_scene)
			return
	get_tree().change_scene_to_file("res://main.tscn")

#func _on_button_pressed() -> void:
#pass # Replace with function body.
