extends CanvasLayer


# 1. var
@onready var pause_menu: Control = $PauseMenu
@onready var menu_button: Button = $MenuButton

@onready var continue_btn = %ResumeOption
@onready var retry_btn = %RetryOption
@onready var setting_btn = %SettingsOption
@onready var exit_btn = %ExitOption

const CYAN_BRIGHT = Color("#5CE1E6")
const CYAN_DIM = Color("#5CE1E6", 0.4)

# 2. Initialize
func _ready() -> void:
	
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	pause_menu.hide()
	

	# 1. menu button
	if menu_button:
		menu_button.pressed.connect(_on_menu_button_pressed)

	# 2. potions logic and interaction
	setup_btn_interaction(continue_btn, _on_continue_pressed)
	setup_btn_interaction(retry_btn, _on_home_pressed)
	setup_btn_interaction(setting_btn, _on_settings_pressed)
	setup_btn_interaction(exit_btn, _on_quit_pressed)


# 3. core logic
func setup_btn_interaction(btn: Control, callback: Callable):
	if btn == null: return
	
	# Ensure that the pivot point remains centered when the nodes are resized
	btn.item_rect_changed.connect(func():
		btn.pivot_offset = btn.size / 2
	)
	btn.pivot_offset = btn.size / 2
	
	# Mouse Filter
	btn.mouse_filter = Control.MOUSE_FILTER_STOP
	
	# lines
	var line = btn.find_child("*Line*", true, false)
	if line:
		line.self_modulate = CYAN_DIM
	
	# A. interactions
	btn.mouse_entered.connect(func():
		if line: line.self_modulate = CYAN_BRIGHT
		# Pivot Offset at centre
		var tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween.tween_property(btn, "scale", Vector2(1.05, 1.05), 0.2)
	)
	
	btn.mouse_exited.connect(func():
		if line: line.self_modulate = CYAN_DIM
		var tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween.tween_property(btn, "scale", Vector2(1.0, 1.0), 0.2)
	)
	
	# C. click
	if btn is BaseButton:
		btn.pressed.connect(func():
			callback.call()
		)
	else:
		btn.gui_input.connect(func(event):
			if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
				callback.call()
		)

# 4. Logic Functions

# pause
func _on_menu_button_pressed() -> void:
	pause_menu.show()
	get_tree().paused = true

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

# Exit
func _on_quit_pressed() -> void:
	get_tree().quit()
