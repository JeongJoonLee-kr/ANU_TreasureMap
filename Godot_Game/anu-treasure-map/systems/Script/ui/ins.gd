extends CanvasLayer

const POST_SCENE = preload("res://post_item.tscn")

@onready var bg_blur = $BG_Blur
@onready var phone_screen = $PhoneScreen
@onready var phone_frame = $PhoneFrame
@onready var feed_list = $PhoneScreen/ScrollContainer/FeedList

# Record the original position of the screen and phone case in the middle.
@onready var target_screen_pos = phone_screen.position
@onready var target_frame_pos = phone_frame.position


func _ready() -> void:
	# Key point: Complete physical state initialization instantaneously before any logic begins

	# This way, in the frame of `add_child`, it will be transparent and shrunk, without any "flash".
	bg_blur.modulate.a = 0.0
	bg_blur.material.set_shader_parameter("lod", 0.0)

	# lock the initial position firmly outside the screen/bottom right corner.
	var screen_size = get_viewport().get_visible_rect().size
	var start_pos = Vector2(screen_size.x - 20, screen_size.y - 20)
	phone_screen.position = start_pos
	phone_frame.position = start_pos
	phone_screen.scale = Vector2(0.01, 0.01)
	phone_frame.scale = Vector2(0.01, 0.01)

	# Here we connect the signal and load the data.
	if not bg_blur.gui_input.is_connected(_on_bg_blur_gui_input):
		bg_blur.gui_input.connect(_on_bg_blur_gui_input)

	load_posts()

	# Achieve the most breathable start using TRANS_SINE + EASE_OUT
	var duration = 0.3
	var tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_SINE).set_ease(
		Tween.EASE_OUT
	)

	# The background and phone synchronization begin to change.
	tween.tween_property(bg_blur, "modulate:a", 1.0, duration)
	tween.tween_method(func(v): bg_blur.material.set_shader_parameter("lod", v), 0.0, 2.5, duration)

	tween.tween_property(phone_screen, "position", target_screen_pos, duration)
	tween.tween_property(phone_frame, "position", target_frame_pos, duration)
	tween.tween_property(phone_screen, "scale", Vector2(1.0, 1.0), duration)
	tween.tween_property(phone_frame, "scale", Vector2(1.0, 1.0), duration)


func load_posts() -> void:
	# Use cached data from Global (loaded once at startup)
	for post_data in Global.posts_data:
		var post = POST_SCENE.instantiate()
		feed_list.add_child(post)
		if post.has_method("setup_post"):
			post.setup_post(post_data, Global.characters_data)


# Exit animation and destruction
func close_phone() -> void:
	# Use the TRANS_SINE curve
	var tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_SINE).set_ease(
		Tween.EASE_IN_OUT
	)

	var screen_size = get_viewport().get_visible_rect().size
	var end_pos = Vector2(screen_size.x - 30, screen_size.y - 30)
	var duration = 0.4

	# 1. Mobile phone displacement and zoom synchronization
	tween.tween_property(phone_screen, "position", end_pos, duration)
	tween.tween_property(phone_frame, "position", end_pos, duration)
	tween.tween_property(phone_screen, "scale", Vector2(0.01, 0.01), duration)
	tween.tween_property(phone_frame, "scale", Vector2(0.01, 0.01), duration)

	# 2. [Core Modification] Dynamically Adjust Shader Blur Values

	# Smoothly reduce the blur level from the current blur (e.g., 2.5) to 0.0 (completely clear).
	tween.tween_method(
		func(value): bg_blur.material.set_shader_parameter("lod", value), 2.5, 0.0, duration
	)

	# 3. Reduce transparency so the node fully disappears.
	tween.tween_property(bg_blur, "modulate:a", 0.0, duration)

	tween.chain().tween_callback(queue_free)


func _on_bg_blur_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		close_phone()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		close_phone()
		get_viewport().set_input_as_handled()
