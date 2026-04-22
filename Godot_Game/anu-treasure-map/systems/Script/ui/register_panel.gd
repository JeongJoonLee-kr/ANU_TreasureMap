extends Control

signal auth_completed

# ========== NODE REFERENCES ==========
# Referencing the exact names from your Scene Tree
@onready var name_input: LineEdit = $MarginContainer/VBoxContainer/NameInput
@onready var comp_btn: Button = $MarginContainer/VBoxContainer/MajorButtons/BtnComp
@onready var hist_btn: Button = $MarginContainer/VBoxContainer/MajorButtons/BtnHist
@onready var griffin_lake_btn: Button = $MarginContainer/VBoxContainer/BaseButtons/BtnLake
@onready var lab_cafe_btn: Button = $MarginContainer/VBoxContainer/BaseButtons/BtnCafe
@onready var auth_btn: TextureButton = $MarginContainer/VBoxContainer/AuthButton
@onready var mind_terminal: RichTextLabel = $MarginContainer/VBoxContainer/MindTerminal

# ========== STATE VARIABLES ==========
var current_major: String = ""
var current_homebase: String = ""
var profile_mode: bool = false

# Track the current tween so we can kill it if the player clicks another button quickly
var terminal_tween: Tween

# ========== DISCO ELYSIUM STYLE DESCRIPTIONS ==========
# Order: Objective/Game mechanics first (Regular), Atmosphere/Psychology second (Italics)
const DESCRIPTIONS = {
	"comp":
	"Your academic background grants heightened intuition for digital artifacts and computation-based puzzles.\n[i]You perceive the world not as stone and glass, but as an intricate topology of nodes and edges waiting to be deciphered.[/i]",
	"hist":
	"Your focus provides deeper insights into archival relics, unlocking hidden narrative branches from historical anomalies.\n[i]The ghosts of the past whisper through the cracked concrete, eager to tell tales of what once was.[/i]",
	"lodges":
	"Starting here grants a calm mindset, offering a slight edge in resisting psychological stress during your first encounters.\n[i]The gentle ripples of the water reflect a mind seeking clarity in the depths of reflection.[/i]"
}


func _ready():
	name_input.placeholder_text = "ENTER CODENAME..."

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

	# 4. Connect Auth Button
	auth_btn.button_down.connect(_on_auth_button_down)
	auth_btn.button_up.connect(_on_auth_button_up)
	auth_btn.pressed.connect(_on_auth_button_pressed)

	# 5. Clear terminal text & ensure BBCode is enabled for italics
	mind_terminal.text = ""
	mind_terminal.bbcode_enabled = true

	if profile_mode:
		apply_profile_mode()
	else:
		apply_registration_mode()


# ========== HELPER FOR VISUAL FEEDBACK ==========
func _reset_button_colors():
	# Make all buttons slightly dim by default (70% brightness)
	comp_btn.modulate = Color(0.7, 0.7, 0.7, 1)
	hist_btn.modulate = Color(0.7, 0.7, 0.7, 1)
	griffin_lake_btn.modulate = Color(0.7, 0.7, 0.7, 1)
	lab_cafe_btn.modulate = Color(0.7, 0.7, 0.7, 1)


func set_profile_mode(enabled: bool) -> void:
	profile_mode = enabled
	if is_node_ready():
		if profile_mode:
			apply_profile_mode()
		else:
			apply_registration_mode()


func prefill_from_player_data() -> void:
	var player_name := str(Global.player_data.get("name", ""))
	if player_name != "" and player_name != "Unknown":
		name_input.text = player_name
	else:
		name_input.text = ""


func apply_registration_mode() -> void:
	current_major = ""
	current_homebase = "lodges"

	name_input.editable = true
	prefill_from_player_data()

	comp_btn.disabled = false
	hist_btn.disabled = false
	griffin_lake_btn.disabled = true
	lab_cafe_btn.hide()
	auth_btn.show()
	auth_btn.disabled = true
	auth_btn.modulate = Color(0.3, 0.3, 0.3, 1)

	_reset_button_colors()
	griffin_lake_btn.modulate = Color(1.0, 1.0, 1.0, 1)
	update_mind_terminal(DESCRIPTIONS["lodges"])


func apply_profile_mode() -> void:
	current_major = str(Global.player_data.get("major", ""))
	current_homebase = str(Global.player_data.get("homebase", ""))

	var player_name := str(Global.player_data.get("name", "Unknown"))
	name_input.text = player_name
	name_input.editable = false

	comp_btn.disabled = true
	hist_btn.disabled = true
	griffin_lake_btn.disabled = true
	lab_cafe_btn.disabled = true
	lab_cafe_btn.hide()
	auth_btn.hide()

	_reset_button_colors()
	highlight_current_selection()
	update_mind_terminal(build_profile_summary())


func highlight_current_selection() -> void:
	if current_major == "comp":
		comp_btn.modulate = Color(1.0, 1.0, 1.0, 1)
		hist_btn.modulate = Color(0.4, 0.4, 0.4, 1)
	elif current_major == "hist":
		hist_btn.modulate = Color(1.0, 1.0, 1.0, 1)
		comp_btn.modulate = Color(0.4, 0.4, 0.4, 1)

	if current_homebase == "lodges":
		griffin_lake_btn.modulate = Color(1.0, 1.0, 1.0, 1)
		lab_cafe_btn.modulate = Color(0.4, 0.4, 0.4, 1)


func build_profile_summary() -> String:
	var codename := str(Global.player_data.get("name", "Unknown"))
	var major_text := (
		"Computing"
		if current_major == "comp"
		else ("History" if current_major == "hist" else "Unregistered")
	)
	var homebase_text := (
		"Lodges"
		if current_homebase == "lodges"
		else ("Chifley & Marie Reay" if current_homebase == "chifley_marie_reay" else "Unassigned")
	)

	return (
		"[b]Codename:[/b] %s\n[b]Major:[/b] %s\n[b]Homebase:[/b] %s"
		% [codename, major_text, homebase_text]
	)


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
	current_homebase = "lodges"
	# Highlight selected, dim the other
	griffin_lake_btn.modulate = Color(1.0, 1.0, 1.0, 1)
	lab_cafe_btn.modulate = Color(0.4, 0.4, 0.4, 1)

	update_mind_terminal(DESCRIPTIONS["lodges"])
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
	var entered_name := name_input.text.strip_edges()
	if entered_name == "":
		entered_name = "Unknown"

	var current_scene := get_tree().current_scene
	if current_scene != null and current_scene.has_method("set_player_location"):
		current_scene.set_player_location("lodges")
	else:
		Global.current_location_id = "lodges"
		Global.selected_location_id = "lodges"
		Global.player_location_id = "lodges"

	# 1. save data
	Global.player_data["name"] = entered_name
	Global.player_data["major"] = current_major
	Global.player_data["homebase"] = current_homebase

	Global.notify_resources_changed()

	# 2. Write JSON to local archive
	Global.save_game()

	# 3. Transmit signal!
	auth_completed.emit()
