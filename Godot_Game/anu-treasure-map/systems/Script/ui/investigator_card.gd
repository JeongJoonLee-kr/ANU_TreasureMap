extends Control

const InsShader = preload("res://ins.gdshader")

# ========== NODE REFERENCES ==========
@onready var bg_mask = $BackgroundMask
@onready var shadow_pivot = $ShadowPivot
@onready var shadow_panel = $ShadowPivot/ShadowPanel
@onready var card_pivot = $CardPivot
@onready var card_body = $CardPivot/CardBody

@onready var left_zone = $CardPivot/LeftZone
@onready var right_zone = $CardPivot/RightZone

# IMPORTANT: Make sure this path correctly points to the RegisterPanel you dragged into the LeftZone!
@onready var register_panel: Control = $CardPivot/LeftZone/RegisterPanel

# (Optional) If you have a specific QR code button, reference it here.
# If the QR code is just the LeftZone itself, we will handle that in _on_click_zone.
# @onready var qr_code_btn: BaseButton = $CardPivot/LeftZone/QRCodeButton

# ========== ANIMATION VARIABLES ==========
var fall_duration: float = 0.8
var start_scale: float = 3.0
var start_rotation: float = -35.0

# Base states to keep track of the card's status
var base_rotation: float = 0.0
var is_active: bool = false
var current_state: String = "idle"  # "idle", "hover_left", "hover_right", "zoomed_left", "zoomed_right"

# Context flags for dynamic UX behavior
var is_opened_from_phone: bool = true
var is_first_time_setup: bool = false  # Triggers auto-zoom to the registration half
var open_read_only_panel: bool = false
## After drop-in: "left" = dossier / registration, "right" = COLLECTION half of id card texture.
var zoom_target_on_open: String = "left"

# Global Tween reference to prevent animation conflicts (Tween fighting)
var active_tween: Tween

# Rest position from center anchors
var card_home: Vector2
var shadow_home: Vector2


func _ready():
	modulate.a = 0.0
	hide()

	# ========== BACKGROUND SETUP ==========
	# bg_mask uses PRESET_FULL_RECT in the .tscn and the root Control is
	# also FULL_RECT, so the mask covers the entire viewport automatically.
	bg_mask.color = Color(1, 1, 1, 1)
	bg_mask.mouse_filter = Control.MOUSE_FILTER_STOP

	if not bg_mask.material:
		var mat = ShaderMaterial.new()
		mat.shader = InsShader
		bg_mask.material = mat

	# [KEY] Hand over the semi-transparent darkening effect to the shader's tint_color parameter
	bg_mask.material.set_shader_parameter("tint_color", Color(0, 0, 0, 0.4))

	# Initialization: completely transparent and unblurred at the start
	bg_mask.modulate.a = 0.0
	bg_mask.material.set_shader_parameter("lod", 0.0)

	# Bind background click signal to exit logic
	bg_mask.gui_input.connect(_on_bg_click)

	# ========== RECORD REST POSITIONS ==========
	card_home = card_pivot.position
	shadow_home = card_home + Vector2(12, 18)

	# ========== CONNECT ZONE SIGNALS ==========
	left_zone.mouse_entered.connect(_on_hover_zone.bind("left"))
	right_zone.mouse_entered.connect(_on_hover_zone.bind("right"))
	left_zone.mouse_exited.connect(_on_unhover)
	right_zone.mouse_exited.connect(_on_unhover)

	# Bind click signals for the interactive zones
	left_zone.gui_input.connect(_on_click_zone.bind("left"))
	right_zone.gui_input.connect(_on_click_zone.bind("right"))

	# ========== CONNECT REGISTER PANEL SIGNAL ==========
	# Listen for the signal from the register panel indicating registration is complete
	if register_panel:
		register_panel.auth_completed.connect(_on_register_auth_completed)
		if register_panel.has_method("set_profile_mode"):
			register_panel.set_profile_mode(open_read_only_panel)
		# Initially hide it until the left zone is clicked/zoomed
		register_panel.hide()

	get_tree().create_timer(0.2).timeout.connect(drop_in)


# ========== ANIMATION: DROP IN ==========
func drop_in():
	show()
	modulate.a = 1.0

	var rand_start_rot = randf_range(start_rotation - 10, start_rotation + 10)
	var card_start_pos = card_home + Vector2(900, -700)
	var shadow_start_pos = card_home + Vector2(300, 300)
	card_pivot.scale = Vector2(start_scale, start_scale)
	card_pivot.rotation_degrees = rand_start_rot
	card_pivot.position = card_start_pos

	# Apply initial heavy blur using the DOF shader to the card itself
	if card_body.material:
		card_body.material.set_shader_parameter("blur_amount", 10.0)

	# Initialize shadow properties
	shadow_pivot.scale = Vector2(start_scale + 0.2, start_scale + 0.2)
	shadow_pivot.rotation_degrees = rand_start_rot
	shadow_pivot.position = shadow_start_pos
	shadow_panel.modulate.a = 0.0

	# Randomize the resting rotation slightly for a natural physical look
	base_rotation = randf_range(-3.0, 3.0)

	if active_tween and active_tween.is_valid():
		active_tween.kill()
	active_tween = create_tween().set_parallel(true)

	var target_lod = 1.5 if is_opened_from_phone else 3.0
	if bg_mask.material:
		(
			active_tween
			. tween_property(bg_mask.material, "shader_parameter/lod", target_lod, fall_duration)
			. set_trans(Tween.TRANS_QUINT)
			. set_ease(Tween.EASE_OUT)
		)
	(
		active_tween
		. tween_property(bg_mask, "modulate:a", 1.0, fall_duration)
		. set_trans(Tween.TRANS_QUINT)
		. set_ease(Tween.EASE_OUT)
	)

	# --- Card Drop-in Animation ---
	(
		active_tween
		. tween_property(card_pivot, "scale", Vector2.ONE, fall_duration)
		. set_trans(Tween.TRANS_QUINT)
		. set_ease(Tween.EASE_OUT)
	)
	(
		active_tween
		. tween_property(card_pivot, "rotation_degrees", base_rotation, fall_duration)
		. set_trans(Tween.TRANS_QUINT)
		. set_ease(Tween.EASE_OUT)
	)
	(
		active_tween
		. tween_property(card_pivot, "position", card_home, fall_duration)
		. set_trans(Tween.TRANS_QUINT)
		. set_ease(Tween.EASE_OUT)
	)

	# Gradually bring the card into focus
	if card_body.material:
		(
			active_tween
			. tween_property(
				card_body.material, "shader_parameter/blur_amount", 0.0, fall_duration * 0.4
			)
			. set_trans(Tween.TRANS_QUINT)
			. set_ease(Tween.EASE_OUT)
		)

	# --- Shadow Drop-in Animation ---
	(
		active_tween
		. tween_property(shadow_pivot, "scale", Vector2.ONE, fall_duration)
		. set_trans(Tween.TRANS_QUINT)
		. set_ease(Tween.EASE_OUT)
	)
	(
		active_tween
		. tween_property(shadow_pivot, "rotation_degrees", base_rotation, fall_duration)
		. set_trans(Tween.TRANS_QUINT)
		. set_ease(Tween.EASE_OUT)
	)
	(
		active_tween
		. tween_property(shadow_pivot, "position", shadow_home, fall_duration)
		. set_trans(Tween.TRANS_QUINT)
		. set_ease(Tween.EASE_OUT)
	)
	active_tween.tween_property(shadow_panel, "modulate:a", 0.6, fall_duration * 0.8)

	# Setup post-animation logic
	active_tween.chain().tween_callback(
		func():
			is_active = true

			if is_first_time_setup or open_read_only_panel or zoom_target_on_open == "right":
				get_tree().create_timer(0.6).timeout.connect(_auto_zoom_after_drop_in)
	)


func _auto_zoom_after_drop_in() -> void:
	if is_first_time_setup:
		_execute_zoom("left")
		return
	if zoom_target_on_open == "right":
		_execute_zoom("right")
		return
	if open_read_only_panel:
		_execute_zoom("left")


# ========== INTERACTION: HOVER EFFECTS ==========
func _on_hover_zone(zone: String):
	if is_first_time_setup:
		return
	if not is_active or current_state.begins_with("zoomed"):
		return
	current_state = "hover_" + zone

	if active_tween and active_tween.is_valid():
		active_tween.kill()
	active_tween = create_tween().set_parallel(true)

	# Slightly scale up to indicate focus
	(
		active_tween
		. tween_property(card_pivot, "scale", Vector2(1.08, 1.08), 0.3)
		. set_trans(Tween.TRANS_SINE)
		. set_ease(Tween.EASE_OUT)
	)
	(
		active_tween
		. tween_property(shadow_pivot, "scale", Vector2(1.08, 1.08), 0.3)
		. set_trans(Tween.TRANS_SINE)
		. set_ease(Tween.EASE_OUT)
	)

	# Tilt left or right depending on the hovered zone
	var target_rot = 3.0 if zone == "left" else -3.0

	(
		active_tween
		. tween_property(card_pivot, "rotation_degrees", base_rotation + target_rot, 0.4)
		. set_trans(Tween.TRANS_BACK)
		. set_ease(Tween.EASE_OUT)
	)
	(
		active_tween
		. tween_property(shadow_pivot, "rotation_degrees", base_rotation + target_rot, 0.4)
		. set_trans(Tween.TRANS_BACK)
		. set_ease(Tween.EASE_OUT)
	)


func _on_unhover():
	if not is_active or current_state.begins_with("zoomed"):
		return
	current_state = "idle"

	if active_tween and active_tween.is_valid():
		active_tween.kill()
	active_tween = create_tween().set_parallel(true)

	# Revert scale, position, and rotation back to their resting states
	(
		active_tween
		. tween_property(card_pivot, "scale", Vector2.ONE, 0.4)
		. set_trans(Tween.TRANS_BACK)
		. set_ease(Tween.EASE_OUT)
	)
	(
		active_tween
		. tween_property(card_pivot, "position:x", card_home.x, 0.4)
		. set_trans(Tween.TRANS_BACK)
		. set_ease(Tween.EASE_OUT)
	)
	(
		active_tween
		. tween_property(card_pivot, "rotation_degrees", base_rotation, 0.4)
		. set_trans(Tween.TRANS_BACK)
		. set_ease(Tween.EASE_OUT)
	)

	(
		active_tween
		. tween_property(shadow_pivot, "scale", Vector2.ONE, 0.4)
		. set_trans(Tween.TRANS_BACK)
		. set_ease(Tween.EASE_OUT)
	)
	(
		active_tween
		. tween_property(shadow_pivot, "position:x", shadow_home.x, 0.4)
		. set_trans(Tween.TRANS_BACK)
		. set_ease(Tween.EASE_OUT)
	)
	(
		active_tween
		. tween_property(shadow_pivot, "rotation_degrees", base_rotation, 0.4)
		. set_trans(Tween.TRANS_BACK)
		. set_ease(Tween.EASE_OUT)
	)


# ========== INTERACTION: CLICK ZONES ==========
func _on_click_zone(event: InputEvent, zone: String):
	if is_first_time_setup:
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# --- NEW: Check if clicking the Left Zone (QR Code) when already registered ---
		if zone == "left" and Global.player_data["major"] != "":
			print("Player has already registered. Cannot open registration panel again.")
			# Optional: Play a "denied" sound effect here.
			return

		# Proceed to zoom into the zone
		_execute_zoom(zone)


# ========== ANIMATION: ZOOM IN ==========
func _execute_zoom(zone: String):
	if not is_active or current_state.begins_with("zoomed"):
		return
	current_state = "zoomed_" + zone

	if active_tween and active_tween.is_valid():
		active_tween.kill()
	active_tween = create_tween().set_parallel(true)

	var scale_val = 2.2
	var target_scale = Vector2(scale_val, scale_val)
	# Calculate exact X offset to perfectly center the clicked half on the screen
	var target_x = (304.5 * scale_val) if zone == "left" else (-145.5 * scale_val)

	(
		active_tween
		. tween_property(card_pivot, "scale", target_scale, 0.5)
		. set_trans(Tween.TRANS_QUART)
		. set_ease(Tween.EASE_OUT)
	)
	(
		active_tween
		. tween_property(card_pivot, "rotation_degrees", 0.0, 0.5)
		. set_trans(Tween.TRANS_QUART)
		. set_ease(Tween.EASE_OUT)
	)
	(
		active_tween
		. tween_property(card_pivot, "position", Vector2(card_home.x + target_x, card_home.y), 0.5)
		. set_trans(Tween.TRANS_QUART)
		. set_ease(Tween.EASE_OUT)
	)

	# Sync shadow animations perfectly with the card's movement and easing
	(
		active_tween
		. tween_property(shadow_pivot, "scale", target_scale * 1.1, 0.5)
		. set_trans(Tween.TRANS_QUART)
		. set_ease(Tween.EASE_OUT)
	)
	(
		active_tween
		. tween_property(shadow_pivot, "rotation_degrees", 0.0, 0.5)
		. set_trans(Tween.TRANS_QUART)
		. set_ease(Tween.EASE_OUT)
	)
	(
		active_tween
		. tween_property(
			shadow_pivot, "position", Vector2(card_home.x + target_x + 40, card_home.y + 60), 0.5
		)
		. set_trans(Tween.TRANS_QUART)
		. set_ease(Tween.EASE_OUT)
	)

	# Fade the shadow out slightly to simulate light scattering when close
	(
		active_tween
		. tween_property(shadow_panel, "modulate:a", 0.2, 0.5)
		. set_trans(Tween.TRANS_QUART)
		. set_ease(Tween.EASE_OUT)
	)

	# --- NEW: Show the Register Panel after zooming into the left zone ---
	if zone == "left" and register_panel:
		# Use chain() so the panel appears AFTER the zoom animation finishes
		active_tween.chain().tween_callback(func(): register_panel.show())


# ========== REGISTRATION COMPLETED HANDLER ==========
func _on_register_auth_completed():
	print("Investigator Card received auth_completed signal. Exiting card...")

	# Allow input handlers to work again so exit_card can proceed
	is_first_time_setup = false

	# Hide the register panel immediately before animating the card away
	if register_panel:
		register_panel.hide()

	# Call the exit_card function, which will handle the animation and then free the scene
	exit_card()


# ========== INPUT HANDLERS ==========
func _on_bg_click(event: InputEvent):
	if is_first_time_setup:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if is_active:
			# Hide panel if clicking away
			if register_panel and register_panel.visible:
				register_panel.hide()
			exit_card()


func _input(event):
	if is_first_time_setup:
		return
	# Trigger exit when hitting the ESC key (mapped to "ui_cancel" by default in Godot)
	if event.is_action_pressed("ui_cancel"):
		if is_active and visible:
			if register_panel and register_panel.visible:
				register_panel.hide()
			exit_card()


# ========== ANIMATION: EXIT CARD ==========
func exit_card():
	is_active = false
	current_state = "exiting"

	if active_tween and active_tween.is_valid():
		active_tween.kill()
	active_tween = create_tween().set_parallel(true)

	# --- Background Mask Exit (Dissipate Blur and Dim) ---
	if bg_mask.material:
		(
			active_tween
			. tween_property(bg_mask.material, "shader_parameter/lod", 0.0, 0.4)
			. set_trans(Tween.TRANS_SINE)
			. set_ease(Tween.EASE_IN_OUT)
		)
	(
		active_tween
		. tween_property(bg_mask, "modulate:a", 0.0, 0.4)
		. set_trans(Tween.TRANS_SINE)
		. set_ease(Tween.EASE_IN_OUT)
	)

	# --- Cinematic Exit: Drop down heavily and tilt backwards ---
	(
		active_tween
		. tween_property(card_pivot, "position:y", card_home.y + 600, 0.5)
		. set_trans(Tween.TRANS_BACK)
		. set_ease(Tween.EASE_IN)
	)
	(
		active_tween
		. tween_property(card_pivot, "rotation_degrees", base_rotation - 15.0, 0.5)
		. set_trans(Tween.TRANS_BACK)
		. set_ease(Tween.EASE_IN)
	)
	(
		active_tween
		. tween_property(shadow_pivot, "position:y", card_home.y + 660, 0.5)
		. set_trans(Tween.TRANS_BACK)
		. set_ease(Tween.EASE_IN)
	)

	# Fade out the entire UI layer with a slight delay
	active_tween.tween_property(self, "modulate:a", 0.0, 0.3).set_delay(0.2)

	# Safely hide the UI node (or queue_free if you prefer to destroy it) after tweens complete
	active_tween.chain().tween_callback(
		func():
			# The card lives inside a CanvasLayer(100) which sits on top of everything.
			# The Ins phone (another CanvasLayer) may also be beneath us.
			# We just need to free our CanvasLayer wrapper; the map scene below
			# will become visible and interactive automatically.
			var card_canvas = get_parent()  # the CanvasLayer(100) from post_item.gd

			# Also close the Ins phone if it still exists
			var ins_phone = get_tree().current_scene.find_child("Ins", true, false)
			if is_opened_from_phone and ins_phone and ins_phone is CanvasLayer:
				ins_phone.queue_free()

			if card_canvas is CanvasLayer:
				card_canvas.queue_free()
			else:
				queue_free()
	)
