extends CanvasLayer

@onready var pause_menu: Control = $PauseMenu
@onready var menu_button: Button = $MenuButton

@onready var _pause_resume_btn: TextureButton = %PauseResume
@onready var _pause_retry_btn: TextureButton = %PauseRetry
@onready var _pause_settings_btn: TextureButton = %PauseSettings
@onready var _pause_profile_btn: TextureButton = %PauseProfile
@onready var _pause_exit_btn: TextureButton = %PauseExit

const _PAUSE_TEXT_NEUTRAL: Color = Color(0.3686, 0.4235, 0.5176, 1.0)
const _RESUME_ACTIVE: Color = Color(0.2588, 0.6471, 0.9608, 1.0)  # 42A5F5
const _RETRY_ACTIVE: Color = Color(0.937, 0.325, 0.313, 1.0)  # EF5350
const _SETTINGS_ACTIVE: Color = Color(0.4, 0.7333, 0.4157, 1.0)  # 66BB6A
const _PROFILE_ACTIVE: Color = Color(1.0, 0.6549, 0.149, 1.0)  # FFA726
const _EXIT_ACTIVE: Color = Color(0.925, 0.302, 0.478, 1.0)  # EC407A

var _pause_held: Dictionary = {}


func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	pause_menu.hide()
	set_process_unhandled_input(true)

	if menu_button:
		menu_button.pressed.connect(_on_menu_button_pressed)

	_connect_pause_row(_pause_resume_btn, "ResumeLabel", _RESUME_ACTIVE, _on_continue_pressed)
	_connect_pause_row(_pause_retry_btn, "RetryLabel", _RETRY_ACTIVE, _on_home_pressed)
	_connect_pause_row(_pause_settings_btn, "SettingsLabel", _SETTINGS_ACTIVE, _on_settings_pressed)
	_connect_pause_row(_pause_profile_btn, "ProfileLabel", _PROFILE_ACTIVE, _on_profile_pressed)
	_connect_pause_row(_pause_exit_btn, "ExitLabel", _EXIT_ACTIVE, _on_quit_pressed)


func _unhandled_input(event: InputEvent) -> void:
	if not pause_menu.visible:
		return
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		_on_continue_pressed()


func _connect_pause_row(
	btn: TextureButton, label_node: String, active: Color, callback: Callable
) -> void:
	if not is_instance_valid(btn):
		return
	var label: Label = btn.get_node(label_node) as Label
	if not is_instance_valid(label):
		return
	btn.mouse_filter = Control.MOUSE_FILTER_STOP
	_pause_held[btn] = false
	var update_pause_state := func():
		var o: bool = bool(_pause_held.get(btn, false))
		var a: bool = o or btn.has_focus()
		label.add_theme_color_override("font_color", active if a else _PAUSE_TEXT_NEUTRAL)
	update_pause_state.call()
	btn.button_down.connect(
		func():
			_pause_held[btn] = true
			update_pause_state.call()
	)
	btn.button_up.connect(
		func():
			_pause_held[btn] = false
			update_pause_state.call()
	)
	btn.focus_entered.connect(func(): update_pause_state.call())
	btn.focus_exited.connect(func(): update_pause_state.call())
	btn.pressed.connect(func(): callback.call())


# pause
func _on_menu_button_pressed() -> void:
	pause_menu.show()
	get_tree().paused = true
	if is_instance_valid(_pause_resume_btn):
		_pause_resume_btn.call_deferred("grab_focus")


# Resume
func _on_continue_pressed() -> void:
	pause_menu.hide()
	get_tree().paused = false


# Home / Retry
func _on_home_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Start.tscn")


# Settings
func _on_settings_pressed() -> void:
	print("TODO")


# Profile
func _on_profile_pressed() -> void:
	pause_menu.hide()
	get_tree().paused = false

	var current_scene := get_tree().current_scene
	if current_scene != null and current_scene.has_method("open_profile"):
		current_scene.open_profile()


# Exit
func _on_quit_pressed() -> void:
	get_tree().quit()
