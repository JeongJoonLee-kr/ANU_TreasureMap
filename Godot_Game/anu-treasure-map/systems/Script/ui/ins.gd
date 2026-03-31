extends Control

const POST_SCENE = preload("res://post_item.tscn")

# 1. 根据你最新的节点树，重新绑定这4个节点
@onready var bg_blur = $BG_Blur
@onready var phone_screen = $PhoneScreen
@onready var phone_frame = $PhoneFrame
@onready var feed_list = $PhoneScreen/ScrollContainer/FeedList

# 记录屏幕和手机壳原本在中间的位置
@onready var target_screen_pos = phone_screen.position
@onready var target_frame_pos = phone_frame.position

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# 2. 设置缩放中心点为各自的中心
	phone_screen.pivot_offset = phone_screen.size / 2
	phone_frame.pivot_offset = phone_frame.size / 2
	
	# 3. 设置初始状态：缩到最小，藏在屏幕右下角
	var screen_size = get_viewport_rect().size
	var start_pos = Vector2(screen_size.x, screen_size.y) # 右下角坐标
	
	phone_screen.scale = Vector2(0.05, 0.05)
	phone_frame.scale = Vector2(0.05, 0.05)
	phone_screen.position = start_pos
	phone_frame.position = start_pos
	
	bg_blur.modulate.a = 0.0 # 背景全透明

	# 4. 加载帖子数据
	load_posts()

	# 5. 执行飞入展开动画
	var tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	
	# 手机屏幕和外壳一起飞回原来的中心位置
	tween.tween_property(phone_screen, "position", target_screen_pos, 0.6)
	tween.tween_property(phone_frame, "position", target_frame_pos, 0.6)
	
	# 手机屏幕和外壳一起放大到 100%
	tween.tween_property(phone_screen, "scale", Vector2(1.0, 1.0), 0.6)
	tween.tween_property(phone_frame, "scale", Vector2(1.0, 1.0), 0.6)
	
	# 背景逐渐变暗/模糊
	tween.tween_property(bg_blur, "modulate:a", 1.0, 0.4)

func load_posts() -> void:
	# 1. 先读取角色数据
	var characters_data: Dictionary = {}
	var char_file = FileAccess.open("res://data/characters.json", FileAccess.READ)
	if char_file:
		var parsed = JSON.parse_string(char_file.get_as_text())
		if typeof(parsed) == TYPE_DICTIONARY:
			characters_data = parsed

	# 2. 读取帖子数据
	var file = FileAccess.open("res://data/ins_posts.json", FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		var json = JSON.new()
		if json.parse(json_string) == OK:
			var posts = json.data
			for post_data in posts:
				var post = POST_SCENE.instantiate()
				feed_list.add_child(post)
				if post.has_method("setup_post"):
					# 注意这里：我们把角色数据(characters_data)也传给了 setup_post
					post.setup_post(post_data, characters_data)

# 退场动画及销毁
func close_phone() -> void:
	var tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	var screen_size = get_viewport_rect().size
	var end_pos = Vector2(screen_size.x, screen_size.y)
	
	# 一起飞回右下角并缩小
	tween.tween_property(phone_screen, "position", end_pos, 0.4)
	tween.tween_property(phone_frame, "position", end_pos, 0.4)
	tween.tween_property(phone_screen, "scale", Vector2(0.05, 0.05), 0.4)
	tween.tween_property(phone_frame, "scale", Vector2(0.05, 0.05), 0.4)
	tween.tween_property(bg_blur, "modulate:a", 0.0, 0.3)
	
	# 动画结束后销毁自己
	tween.chain().tween_callback(queue_free)

# 处理点击背景退出
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		close_phone()
		
# 允许按 ESC 退出
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		close_phone()
		get_viewport().set_input_as_handled()
