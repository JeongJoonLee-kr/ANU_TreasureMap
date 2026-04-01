extends Control

const InsShader = preload("res://ins.gdshader")

@onready var bg_mask = $BackgroundMask
@onready var shadow_pivot = $ShadowPivot
@onready var shadow_panel = $ShadowPivot/ShadowPanel
@onready var card_pivot = $CardPivot
@onready var card_body = $CardPivot/CardBody

@onready var left_zone = $CardPivot/LeftZone
@onready var right_zone = $CardPivot/RightZone

# Animation configuration
var fall_duration: float = 0.8 
var start_scale: float = 3.0
var start_rotation: float = -35.0 

# Base states to keep track of the card's status
var base_rotation: float = 0.0
var is_active: bool = false
var current_state: String = "idle" # "idle", "hover_left", "hover_right", "zoomed_left", "zoomed_right"

# Context flags for dynamic UX behavior
var is_opened_from_phone: bool = true 
var is_first_time_setup: bool = false # Triggers auto-zoom to the registration half

# Global Tween reference to prevent animation conflicts (Tween fighting)
var active_tween: Tween 

func _ready():
	modulate.a = 0.0
	hide()
	
	# Force the background mask to cover the entire viewport securely
	bg_mask.global_position = Vector2.ZERO
	bg_mask.size = get_viewport_rect().size
	
	# [FIX] The node's base color MUST be pure white so modulate.a animation works properly
	bg_mask.color = Color(1, 1, 1, 1) 
	
	# Ensure the shader material is attached programmatically if forgotten in the editor
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
	
	# Bind mouse hover and exit signals for the interactive zones
	left_zone.mouse_entered.connect(_on_hover_zone.bind("left"))
	right_zone.mouse_entered.connect(_on_hover_zone.bind("right"))
	left_zone.mouse_exited.connect(_on_unhover)
	right_zone.mouse_exited.connect(_on_unhover)
	
	# Bind click signals for the interactive zones
	left_zone.gui_input.connect(_on_click_zone.bind("left"))
	right_zone.gui_input.connect(_on_click_zone.bind("right"))
	
	# Delay the drop-in animation slightly for better pacing
	get_tree().create_timer(0.2).timeout.connect(drop_in)

func drop_in():
	show()
	modulate.a = 1.0 
	
	var rand_start_rot = randf_range(start_rotation - 10, start_rotation + 10)
	
	# Initial positions (far top-right for the card, closer for the shadow)
	var card_start_pos = Vector2(1200, -400)
	var shadow_start_pos = Vector2(600, 300)
	
	# Initialize card properties
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
	
	# --- Background Mask Animation (Blur and Dim) ---
	# Use lighter blur if stacking on top of the phone UI to prevent muddy visuals
	var target_lod = 1.5 if is_opened_from_phone else 3.0
	if bg_mask.material:
		active_tween.tween_property(bg_mask.material, "shader_parameter/lod", target_lod, fall_duration).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	active_tween.tween_property(bg_mask, "modulate:a", 1.0, fall_duration).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	
	# --- Card Drop-in Animation ---
	active_tween.tween_property(card_pivot, "scale", Vector2.ONE, fall_duration).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	active_tween.tween_property(card_pivot, "rotation_degrees", base_rotation, fall_duration).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT) 
	active_tween.tween_property(card_pivot, "position", Vector2.ZERO, fall_duration).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		
	# Gradually bring the card into focus
	if card_body.material:
		active_tween.tween_property(card_body.material, "shader_parameter/blur_amount", 0.0, fall_duration * 0.4).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	
	# --- Shadow Drop-in Animation ---
	active_tween.tween_property(shadow_pivot, "scale", Vector2.ONE, fall_duration).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	active_tween.tween_property(shadow_pivot, "rotation_degrees", base_rotation, fall_duration).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	active_tween.tween_property(shadow_pivot, "position", Vector2(12, 18), fall_duration).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	active_tween.tween_property(shadow_panel, "modulate:a", 0.6, fall_duration * 0.8)
	
	# Setup post-animation logic
	active_tween.chain().tween_callback(func(): 
		is_active = true
		
		# Auto-frame the left side if this is the player's first time setting up the ID
		if is_first_time_setup:
			get_tree().create_timer(0.6).timeout.connect(func(): _execute_zoom("left"))
	)

# ==========================================
# Interaction: Hover (3D Tilt Effect)
# ==========================================
func _on_hover_zone(zone: String):
	if is_first_time_setup: return
	if not is_active or current_state.begins_with("zoomed"): return
	current_state = "hover_" + zone
	
	if active_tween and active_tween.is_valid():
		active_tween.kill()
	active_tween = create_tween().set_parallel(true)
	
	# Slightly scale up to indicate focus
	active_tween.tween_property(card_pivot, "scale", Vector2(1.08, 1.08), 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	active_tween.tween_property(shadow_pivot, "scale", Vector2(1.08, 1.08), 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	# Tilt left or right depending on the hovered zone
	var target_rot = 3.0 if zone == "left" else -3.0 
	
	active_tween.tween_property(card_pivot, "rotation_degrees", base_rotation + target_rot, 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	active_tween.tween_property(shadow_pivot, "rotation_degrees", base_rotation + target_rot, 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _on_unhover():
	if not is_active or current_state.begins_with("zoomed"): return
	current_state = "idle"
	
	if active_tween and active_tween.is_valid():
		active_tween.kill()
	active_tween = create_tween().set_parallel(true)
	
	# Revert scale, position, and rotation back to their resting states
	active_tween.tween_property(card_pivot, "scale", Vector2.ONE, 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	active_tween.tween_property(card_pivot, "position:x", 0.0, 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	active_tween.tween_property(card_pivot, "rotation_degrees", base_rotation, 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	active_tween.tween_property(shadow_pivot, "scale", Vector2.ONE, 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	active_tween.tween_property(shadow_pivot, "position:x", 12.0, 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	active_tween.tween_property(shadow_pivot, "rotation_degrees", base_rotation, 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

# ==========================================
# Interaction: Click (Zoom & Center)
# ==========================================
func _on_click_zone(event: InputEvent, zone: String):
	if is_first_time_setup: return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_execute_zoom(zone)

func _execute_zoom(zone: String):
	if not is_active or current_state.begins_with("zoomed"): return
	current_state = "zoomed_" + zone
	
	if active_tween and active_tween.is_valid():
		active_tween.kill()
	active_tween = create_tween().set_parallel(true)
	
	var scale_val = 2.2
	var target_scale = Vector2(scale_val, scale_val) 
	# Calculate exact X offset to perfectly center the clicked half on the screen
	var target_x = (304.5 * scale_val) if zone == "left" else (-145.5 * scale_val) 
	
	# Zoom in, snap rotation to 0 (flat), and translate to center
	active_tween.tween_property(card_pivot, "scale", target_scale, 0.5).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	active_tween.tween_property(card_pivot, "rotation_degrees", 0.0, 0.5).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	active_tween.tween_property(card_pivot, "position", Vector2(target_x, 0), 0.5).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	
	# Sync shadow animations perfectly with the card's movement and easing
	active_tween.tween_property(shadow_pivot, "scale", target_scale * 1.1, 0.5).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	active_tween.tween_property(shadow_pivot, "rotation_degrees", 0.0, 0.5).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	active_tween.tween_property(shadow_pivot, "position", Vector2(target_x + 40, 60), 0.5).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	
	# Fade the shadow out slightly to simulate light scattering when close
	active_tween.tween_property(shadow_panel, "modulate:a", 0.2, 0.5).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)

# ==========================================
# Interaction: Background Click & ESC (Exit)
# ==========================================
func _on_bg_click(event: InputEvent):
	if is_first_time_setup: return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if is_active:
			exit_card()

func _input(event):
	if is_first_time_setup: return
	# Trigger exit when hitting the ESC key (mapped to "ui_cancel" by default in Godot)
	if event.is_action_pressed("ui_cancel"):
		if is_active and visible:
			exit_card()

func exit_card():
	is_active = false
	current_state = "exiting"
	
	if active_tween and active_tween.is_valid():
		active_tween.kill()
	active_tween = create_tween().set_parallel(true)
	
	# --- Background Mask Exit (Dissipate Blur and Dim) ---
	if bg_mask.material:
		active_tween.tween_property(bg_mask.material, "shader_parameter/lod", 0.0, 0.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	active_tween.tween_property(bg_mask, "modulate:a", 0.0, 0.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	# --- Cinematic Exit: Drop down heavily and tilt backwards ---
	active_tween.tween_property(card_pivot, "position:y", 600, 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	active_tween.tween_property(card_pivot, "rotation_degrees", base_rotation - 15.0, 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	active_tween.tween_property(shadow_pivot, "position:y", 660, 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	
	# Fade out the entire UI layer with a slight delay
	active_tween.tween_property(self, "modulate:a", 0.0, 0.3).set_delay(0.2) 
	
	# Safely hide the UI node (or queue_free if you prefer to destroy it) after tweens complete
	active_tween.chain().tween_callback(func():
		var parent = get_parent()
		if parent is CanvasLayer:
			parent.queue_free()
		else:
			queue_free()
	)
