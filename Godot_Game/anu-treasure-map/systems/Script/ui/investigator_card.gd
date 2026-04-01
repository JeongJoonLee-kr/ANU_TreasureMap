extends Control

@onready var shadow_pivot = $ShadowPivot
@onready var shadow_panel = $ShadowPivot/ShadowPanel
@onready var card_pivot = $CardPivot

var fall_duration: float = 1.0 
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
	
	# card initial
	card_pivot.scale = Vector2(start_scale, start_scale)
	card_pivot.rotation_degrees = rand_start_rot
	card_pivot.modulate.a = 0.0
	
	# shadow initial
	shadow_pivot.scale = Vector2(start_scale + 0.2, start_scale + 0.2) 
	shadow_pivot.rotation_degrees = rand_start_rot
	var light_offset_high = Vector2(180, 220) 
	shadow_pivot.position = light_offset_high
	shadow_panel.modulate.a = 0.0 
	
	# ============================
	# droping
	# ============================
	var tween = create_tween().set_parallel(true)
	var end_rot = randf_range(-3.0, 3.0) 
	
	
	tween.tween_property(card_pivot, "scale", Vector2.ONE, fall_duration)\
		.set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_property(card_pivot, "rotation_degrees", end_rot, fall_duration)\
		.set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT) 
	tween.tween_property(card_pivot, "modulate:a", 1.0, fall_duration * 0.4)
	

	tween.tween_property(shadow_pivot, "scale", Vector2.ONE, fall_duration)\
		.set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_property(shadow_pivot, "rotation_degrees", end_rot, fall_duration)\
		.set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	

	var light_offset_low = Vector2(12, 18) 
	tween.tween_property(shadow_pivot, "position", light_offset_low, fall_duration)\
		.set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		
	tween.tween_property(shadow_panel, "modulate:a", 0.6, fall_duration * 0.8)
