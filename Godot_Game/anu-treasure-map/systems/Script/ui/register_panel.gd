extends Control

signal auth_completed

# ========== NODE REFERENCES ==========
# Referencing the exact names from your Scene Tree
@onready var comp_btn: Button = $MarginContainer/VBoxContainer/MajorButtons/BtnComp
@onready var hist_btn: Button = $MarginContainer/VBoxContainer/MajorButtons/BtnHist
@onready var griffin_lake_btn: Button = $MarginContainer/VBoxContainer/BaseButtons/BtnLake
@onready var lab_cafe_btn: Button = $MarginContainer/VBoxContainer/BaseButtons/BtnCafe
@onready var auth_btn: TextureButton = $MarginContainer/VBoxContainer/AuthButton
@onready var mind_terminal: RichTextLabel = $MarginContainer/VBoxContainer/MindTerminal

# ========== STATE VARIABLES ==========
var current_major: String = ""
var current_homebase: String = ""

# Track the current tween so we can kill it if the player clicks another button quickly
var terminal_tween: Tween

# ========== DISCO ELYSIUM STYLE DESCRIPTIONS ==========
# Order: Objective/Game mechanics first (Regular), Atmosphere/Psychology second (Italics)
const DESCRIPTIONS = {
	"comp":
	"Your academic background grants heightened intuition for digital artifacts and computation-based puzzles.\n[i]You perceive the world not as stone and glass, but as an intricate topology of nodes and edges waiting to be deciphered.[/i]",
	"hist":
	"Your focus provides deeper insights into archival relics, unlocking hidden narrative branches from historical anomalies.\n[i]The ghosts of the past whisper through the cracked concrete, eager to tell tales of what once was.[/i]",
	"lab_cafe":
	"This location serves as your initial deployment zone and primary rest area to recover morale between expeditions.\n[i]A solitary sanctuary amidst the campus chaos, where the exhausted mind unravels its gathered threads.[/i]",
	"griffin_lake":
	"Starting here grants a calm mindset, offering a slight edge in resisting psychological stress during your first encounters.\n[i]The gentle ripples of the water reflect a mind seeking clarity in the depths of reflection.[/i]"
}


func _ready():
	# 1. Initialize Auth Button (Disabled and grayed out)
	auth_btn.disabled = true
	auth_btn.modulate = Color(0.3, 0.3, 0.3, 1)

	# Optional: Slightly dim all option buttons initially to show they are unselected
	_reset_button_colors()

	# 2. Connect Major Buttons
	comp_btn.pressed.connect(_on_comp_pressed)
	hist_btn.pressed.connect(_on_hist_pressed)

	# 3. Connect HomeBase Buttons
	griffin_lake_btn.pressed.connect(_on_griffin_lake_pressed)
	lab_cafe_btn.pressed.connect(_on_lab_cafe_pressed)

	# 4. Connect Auth Button
	auth_btn.button_down.connect(_on_auth_button_down)
	auth_btn.button_up.connect(_on_auth_button_up)
	auth_btn.pressed.connect(_on_auth_button_pressed)

	# 5. Clear terminal text & ensure BBCode is enabled for italics
	mind_terminal.text = ""
	mind_terminal.bbcode_enabled = true


# ========== HELPER FOR VISUAL FEEDBACK ==========
func _reset_button_colors():
	# Make all buttons slightly dim by default (70% brightness)
	comp_btn.modulate = Color(0.7, 0.7, 0.7, 1)
	hist_btn.modulate = Color(0.7, 0.7, 0.7, 1)
	griffin_lake_btn.modulate = Color(0.7, 0.7, 0.7, 1)
	lab_cafe_btn.modulate = Color(0.7, 0.7, 0.7, 1)


# ========== MAJOR BUTTON HANDLERS ==========
func _on_comp_pressed():
	current_major = "comp"
	# Highlight selected, dim the other
	comp_btn.modulate = Color(1.0, 1.0, 1.0, 1)
	hist_btn.modulate = Color(0.4, 0.4, 0.4, 1)

	update_mind_terminal(DESCRIPTIONS["comp"])
	check_auth_status()


func _on_hist_pressed():
	current_major = "hist"
	# Highlight selected, dim the other
	hist_btn.modulate = Color(1.0, 1.0, 1.0, 1)
	comp_btn.modulate = Color(0.4, 0.4, 0.4, 1)

	update_mind_terminal(DESCRIPTIONS["hist"])
	check_auth_status()


# ========== HOMEBASE BUTTON HANDLERS ==========
func _on_griffin_lake_pressed():
	current_homebase = "griffin_lake"
	# Highlight selected, dim the other
	griffin_lake_btn.modulate = Color(1.0, 1.0, 1.0, 1)
	lab_cafe_btn.modulate = Color(0.4, 0.4, 0.4, 1)

	update_mind_terminal(DESCRIPTIONS["griffin_lake"])
	check_auth_status()


func _on_lab_cafe_pressed():
	current_homebase = "lab_cafe"
	# Highlight selected, dim the other
	lab_cafe_btn.modulate = Color(1.0, 1.0, 1.0, 1)
	griffin_lake_btn.modulate = Color(0.4, 0.4, 0.4, 1)

	update_mind_terminal(DESCRIPTIONS["lab_cafe"])
	check_auth_status()


# ========== CORE LOGIC ==========
func check_auth_status():
	# Enable Auth Button ONLY if both fields have a valid selection
	if current_major != "" and current_homebase != "":
		auth_btn.disabled = false
		var tween = create_tween()
		# Smoothly transition Auth button color back to normal
		tween.tween_property(auth_btn, "modulate", Color(1, 1, 1, 1), 0.3)


func update_mind_terminal(new_text: String):
	# If a typing animation is already running, stop it
	if terminal_tween and terminal_tween.is_running():
		terminal_tween.kill()

	mind_terminal.text = new_text
	mind_terminal.visible_characters = 0

	var text_length = mind_terminal.get_total_character_count()

	# Set typing speed (0.01 seconds per character)
	var duration = text_length * 0.01

	terminal_tween = create_tween()
	terminal_tween.tween_property(mind_terminal, "visible_characters", text_length, duration)


# ========== AUTH BUTTON ANIMATIONS & SUBMIT ==========
func _on_auth_button_down():
	if auth_btn.disabled:
		return
	var tween = create_tween()
	# Physical press feedback (shrink slightly)
	tween.tween_property(auth_btn, "scale", Vector2(0.95, 0.95), 0.05)
	auth_btn.modulate = Color(0.8, 0.8, 0.8, 1)


func _on_auth_button_up():
	if auth_btn.disabled:
		return
	var tween = create_tween()
	# Bounce back on release
	tween.tween_property(auth_btn, "scale", Vector2(1.0, 1.0), 0.1).set_trans(Tween.TRANS_BOUNCE)
	auth_btn.modulate = Color(1, 1, 1, 1)


func _on_auth_button_pressed():
	# 1. save data
	Global.player_data["major"] = current_major
	Global.player_data["homebase"] = current_homebase

	# 2. Write JSON to local archive
	Global.save_game()

	# 3. Transmit signal!
	auth_completed.emit()
