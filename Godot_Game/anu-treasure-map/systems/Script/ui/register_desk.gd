extends Node2D

@onready var card = $Card
@onready var blur_overlay = $BlurOverlay

var target_pos: Vector2
var target_rot: float


func _ready():
	# 1. 既然你在编辑器里已经把 Pivot 设好了，我们就直接读取它！
	# 获取你在截图里设置的那个极其完美的 (-150, -225) 作为落点
	target_pos = Vector2(-150, -225)

	# 最终停下时稍微倾斜一点点
	target_rot = deg_to_rad(-2.0)

	card.hide()
	blur_overlay.material.set_shader_parameter("lod", 4.0)

	await get_tree().create_timer(0.5).timeout
	play_slam_animation()


func play_slam_animation():
	# 从屏幕正上方掉落
	card.global_position = target_pos + Vector2(0, -800)
	card.rotation = deg_to_rad(45.0)
	card.scale = Vector2(3.0, 3.0)
	card.modulate = Color(1, 1, 1, 0)
	card.show()

	var tween = create_tween().set_parallel(true)
	var drop_time = 0.6

	# 下落、缩放、旋转、显影动画
	(
		tween
		. tween_property(card, "global_position", target_pos, drop_time)
		. set_trans(Tween.TRANS_EXPO)
		. set_ease(Tween.EASE_IN)
	)
	(
		tween
		. tween_property(card, "scale", Vector2(1.0, 1.0), drop_time)
		. set_trans(Tween.TRANS_EXPO)
		. set_ease(Tween.EASE_IN)
	)
	(
		tween
		. tween_property(card, "rotation", target_rot, drop_time)
		. set_trans(Tween.TRANS_CUBIC)
		. set_ease(Tween.EASE_IN_OUT)
	)
	tween.tween_property(card, "modulate", Color(1, 1, 1, 1), drop_time * 0.8).set_trans(
		Tween.TRANS_SINE
	)

	# 摄像机自动对焦 (Focus Pull)
	(
		tween
		. tween_property(blur_overlay.material, "shader_parameter/lod", 0.0, drop_time)
		. set_trans(Tween.TRANS_SINE)
		. set_ease(Tween.EASE_IN_OUT)
	)

	# 落地微回弹
	tween.chain().tween_property(card, "scale", Vector2(1.02, 0.98), 0.08)
	tween.chain().tween_property(card, "scale", Vector2(1.0, 1.0), 0.15).set_trans(
		Tween.TRANS_SPRING
	)
