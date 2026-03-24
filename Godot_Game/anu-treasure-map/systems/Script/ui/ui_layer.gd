extends CanvasLayer

# ==========================================
# 1. claim the varibles
# ==========================================
@onready var pause_menu = $PauseMenu
@onready var menu_button = $MenuButton
@onready var continue_button = $PauseMenu/MenuBox/VBoxContainer/ContinueButton
@onready var home_button = $PauseMenu/MenuBox/VBoxContainer/HomeButton
@onready var settings_button = $PauseMenu/MenuBox/VBoxContainer/SettingsButton
@onready var quit_button = $PauseMenu/MenuBox/VBoxContainer/QuitButton

# ==========================================
# 2. initialize
# ==========================================
func _ready():
	# hide the menu layer when the game start
	pause_menu.hide()
	
	menu_button.pressed.connect(_on_menu_button_pressed)
	continue_button.pressed.connect(_on_continue_button_pressed)
	home_button.pressed.connect(_on_home_button_pressed)
	settings_button.pressed.connect(_on_settings_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)

# ==========================================
# 3. function: logic of buttons
# ==========================================

# click Menu button -> pause the game and show the menu layer
func _on_menu_button_pressed():
	pause_menu.show()
	get_tree().paused = true 

# Continue Game button -> hide the menu and go back to game
func _on_continue_button_pressed():
	pause_menu.hide()
	get_tree().paused = false 

# Back to Home button -> back the start
func _on_home_button_pressed():
	get_tree().paused = false # cancle the pause status
	get_tree().change_scene_to_file("res://Start.tscn")

# Settings -> empty now
func _on_settings_button_pressed():
	print("click the settings button") # just for testing, no settings now.

# Exit Game button -> quit the game
func _on_quit_button_pressed():
	get_tree().quit()
