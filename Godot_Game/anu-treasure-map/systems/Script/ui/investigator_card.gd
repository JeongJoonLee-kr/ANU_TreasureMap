extends Control

@onready var shadow_pivot = $ShadowPivot
@onready var shadow_panel = $ShadowPivot/ShadowPanel
@onready var card_pivot = $CardPivot
@onready var card_body = $CardPivot/CardBody

var fall_duration: float = 0.8 
var start_scale: float = 3.0
var start_rotation: float = -35.0 

func _ready():
	modulate.a = 0.0
	hide()
	get_tree().create_timer(0.5).timeout.connect(drop_in)

func drop_in():
	show()
	modulate.a = 1.0 
	
	var rand_start_rot = randf_range(start_rotation - 10, start_rotation + 10)
	
	# ============================
	# origin status
	# ============================
	

	var card_start_pos = Vector2(1200, -400)
	
	var shadow_start_pos = Vector2(600, 300)
	
	
	card_pivot.scale = Vector2(start_scale, start_scale)
	card_pivot.rotation_degrees = rand_start_rot
	card_pivot.position = card_start_pos
	card_pivot.modulate.a = 1.0
	
	
	if card_body.material:
		card_body.material.set_shader_parameter("blur_amount", 10.0)
	
	
	shadow_pivot.scale = Vector2(start_scale + 0.2, start_scale + 0.2) 
	shadow_pivot.rotation_degrees = rand_start_rot
	shadow_pivot.position = shadow_start_pos
	shadow_panel.modulate.a = 0.0 
	
	# ============================
	# drop animation
	# ============================
	var tween = create_tween().set_parallel(true)
	var end_rot = randf_range(-3.0, 3.0) 
	

	tween.tween_property(card_pivot, "scale", Vector2.ONE, fall_duration)\
		.set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)

	tween.tween_property(card_pivot, "rotation_degrees", end_rot, fall_duration)\
		.set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT) 

	tween.tween_property(card_pivot, "position", Vector2.ZERO, fall_duration)\
		.set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		

	if card_body.material:
		tween.tween_property(card_body.material, "shader_parameter/blur_amount", 0.0, fall_duration * 0.4)\
			.set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	

	tween.tween_property(shadow_pivot, "scale", Vector2.ONE, fall_duration)\
		.set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_property(shadow_pivot, "rotation_degrees", end_rot, fall_duration)\
		.set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	

	var light_offset_low = Vector2(12, 18) 
	tween.tween_property(shadow_pivot, "position", light_offset_low, fall_duration)\
		.set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		
	tween.tween_property(shadow_panel, "modulate:a", 0.6, fall_duration * 0.8)
