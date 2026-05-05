extends CanvasLayer

const POST_SCENE = preload("res://post_item.tscn")
const _APP_ICON_TEXTURES := {
	"AppProfileButton":
	{
		"normal": preload("res://resources/icon/profile.png"),
		"pressed": preload("res://resources/icon/profile1.png"),
	},
	"AppCollectionButton":
	{
		"normal": preload("res://resources/icon/collection.png"),
		"pressed": preload("res://resources/icon/collection1.png"),
	},
	"AppInsButton":
	{
		"normal": preload("res://resources/icon/ins.png"),
		"pressed": preload("res://resources/icon/ins1.png"),
	},
	"AppMenuButton":
	{
		"normal": preload("res://resources/icon/menu.png"),
		"pressed": preload("res://resources/icon/menu1.png"),
	},
}
const _APP_NAMES := {
	"AppProfileButton": "Profile",
	"AppCollectionButton": "Collection Book",
	"AppInsButton": "ANU Ins",
	"AppMenuButton": "Menu",
}

const _APP_BTN_PATH := "PhoneScreen/MainMargin/MainVBox/HomeScreen/AppsSlot/AppsCenter/AppGrid/"

@onready var bg_blur = $BG_Blur
@onready var phone_screen = $PhoneScreen
@onready var phone_frame = $PhoneFrame
@onready var home_screen: Control = $PhoneScreen/MainMargin/MainVBox/HomeScreen
@onready
var phone_title_label: Label = $PhoneScreen/MainMargin/MainVBox/HomeScreen/LabelBarSlot/TitleCenter/TitleStrip/PhoneTitleLabel
@onready var ins_app_screen: Control = $PhoneScreen/MainMargin/MainVBox/InsAppScreen
@onready
var feed_scroll: ScrollContainer = $PhoneScreen/MainMargin/MainVBox/InsAppScreen/ScrollContainer
@onready
var feed_list = $PhoneScreen/MainMargin/MainVBox/InsAppScreen/ScrollContainer/ContentVBox/FeedList

# Record scene rest positions for the phone + bezel (unchanged from editor layout).
@onready var target_screen_pos = phone_screen.position
@onready var target_frame_pos = phone_frame.position


func _ready() -> void:
	# Key point: Complete physical state initialization instantaneously before any logic begins

	# This way, in the frame of `add_child`, it will be transparent and shrunk, without any "flash".
	bg_blur.modulate.a = 0.0
	bg_blur.material.set_shader_parameter("lod", 0.0)

	var screen_size = get_viewport().get_visible_rect().size

	# lock the initial position firmly outside the screen/bottom right corner.
	var start_pos = Vector2(screen_size.x - 20, screen_size.y - 20)
	phone_screen.position = start_pos
	phone_frame.position = start_pos
	phone_screen.scale = Vector2(0.01, 0.01)
	phone_frame.scale = Vector2(0.01, 0.01)

	# Here we connect the signal and load the data.
	if not bg_blur.gui_input.is_connected(_on_bg_blur_gui_input):
		bg_blur.gui_input.connect(_on_bg_blur_gui_input)

	load_posts()
	_wire_app_icon_feedback()

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


func _wire_app_icon_feedback() -> void:
	for button_name in [
		"AppProfileButton",
		"AppCollectionButton",
		"AppInsButton",
		"AppMenuButton",
	]:
		var btn := get_node_or_null(_APP_BTN_PATH + button_name) as BaseButton
		if btn == null:
			continue
		if not btn.button_down.is_connected(_on_app_btn_down.bind(btn)):
			btn.button_down.connect(_on_app_btn_down.bind(btn))
		if not btn.button_up.is_connected(_on_app_btn_up.bind(btn)):
			btn.button_up.connect(_on_app_btn_up.bind(btn))
		if not btn.mouse_entered.is_connected(_on_app_btn_hovered.bind(btn)):
			btn.mouse_entered.connect(_on_app_btn_hovered.bind(btn))
		if not btn.mouse_exited.is_connected(_reset_phone_title):
			btn.mouse_exited.connect(_reset_phone_title)
	call_deferred("_refresh_app_button_pivots")


func _refresh_app_button_pivots() -> void:
	for button_name in [
		"AppProfileButton",
		"AppCollectionButton",
		"AppInsButton",
		"AppMenuButton",
	]:
		var btn := get_node_or_null(_APP_BTN_PATH + button_name) as BaseButton
		if btn == null:
			continue
		btn.pivot_offset = btn.size * 0.5


func _on_app_btn_down(btn: BaseButton) -> void:
	btn.pivot_offset = btn.size * 0.5
	var tw := create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tw.tween_property(btn, "scale", Vector2(0.9, 0.9), 0.07)
	var icon := btn.get_node_or_null("Icon") as CanvasItem
	if icon != null:
		icon.modulate = Color(0.92, 0.92, 0.92, 1.0)
	var icon_rect := btn.get_node_or_null("Icon") as TextureRect
	if icon_rect != null and _APP_ICON_TEXTURES.has(btn.name):
		icon_rect.texture = _APP_ICON_TEXTURES[btn.name]["pressed"]


func _on_app_btn_up(btn: BaseButton) -> void:
	var tw := create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tw.tween_property(btn, "scale", Vector2(1.0, 1.0), 0.22)
	var icon := btn.get_node_or_null("Icon") as CanvasItem
	if icon != null:
		icon.modulate = Color(1, 1, 1, 1)
	var icon_rect := btn.get_node_or_null("Icon") as TextureRect
	if icon_rect != null and _APP_ICON_TEXTURES.has(btn.name):
		icon_rect.texture = _APP_ICON_TEXTURES[btn.name]["normal"]


func _on_app_btn_hovered(btn: BaseButton) -> void:
	if _APP_NAMES.has(btn.name):
		phone_title_label.text = _APP_NAMES[btn.name]


func _reset_phone_title() -> void:
	phone_title_label.text = "Phone"


func load_posts() -> void:
	# Use cached data from Global (loaded once at startup)
	for post_data in Global.posts_data:
		var post = POST_SCENE.instantiate()
		feed_list.add_child(post)
		if post.has_method("setup_post"):
			post.setup_post(post_data, Global.characters_data)


func _on_app_profile_pressed() -> void:
	var main_node := get_tree().current_scene
	close_phone()
	if main_node != null and main_node.has_method("open_profile"):
		main_node.call_deferred("open_profile", false, true, false)


func _on_app_collection_pressed() -> void:
	var main_node := get_tree().current_scene
	close_phone()
	if main_node != null and main_node.has_method("open_profile"):
		main_node.call_deferred("open_profile", false, true, true)


func _on_app_ins_pressed() -> void:
	if not is_instance_valid(ins_app_screen) or not is_instance_valid(home_screen):
		return
	home_screen.hide()
	ins_app_screen.show()
	feed_scroll.scroll_vertical = 0


func _on_ins_back_pressed() -> void:
	if not is_instance_valid(ins_app_screen) or not is_instance_valid(home_screen):
		return
	ins_app_screen.hide()
	home_screen.show()
	_reset_phone_title()


func _on_app_menu_pressed() -> void:
	var main_node := get_tree().current_scene
	queue_free()
	if main_node != null and main_node.has_method("_on_hud_menu_button_pressed"):
		main_node.call_deferred("_on_hud_menu_button_pressed")


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

	# 3. At the same time, reduce transparency to ensure that the node eventually disappears completely.
	tween.tween_property(bg_blur, "modulate:a", 0.0, duration)

	tween.chain().tween_callback(queue_free)


func _on_bg_blur_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		close_phone()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if is_instance_valid(ins_app_screen) and ins_app_screen.visible:
			_on_ins_back_pressed()
			get_viewport().set_input_as_handled()
			return
		close_phone()
		get_viewport().set_input_as_handled()
