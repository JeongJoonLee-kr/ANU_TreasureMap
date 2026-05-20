class_name TreasurePopup
extends Control

signal closed
signal choice_made(action: String)

const FONT_PATH := "res://resources/font/AlegreyaSans-Regular.ttf"

var treasure_name := ""
var treasure_image_path := ""

var _background: ColorRect
var _content_panel: Panel
var _image: TextureRect
var _title_label: Label
var _share_button: Button
var _collect_button: Button
var _font: FontFile


func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	if ResourceLoader.exists(FONT_PATH):
		_font = load(FONT_PATH)
	_build_ui()
	_apply_data()
	get_viewport().size_changed.connect(_update_layout)


func setup(new_treasure_name: String, image_path: String) -> void:
	treasure_name = new_treasure_name
	treasure_image_path = image_path
	if is_node_ready():
		_apply_data()


func _build_ui() -> void:
	_background = ColorRect.new()
	_background.name = "Background"
	_background.color = Color(0.0, 0.0, 0.0, 0.72)
	_background.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(_background)

	_content_panel = Panel.new()
	_content_panel.name = "ContentPanel"
	_content_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	_content_panel.add_theme_stylebox_override("panel", _make_card_style())
	add_child(_content_panel)

	_image = TextureRect.new()
	_image.name = "TreasureImage"
	_image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	_image.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_content_panel.add_child(_image)

	var title_bar := Panel.new()
	title_bar.name = "TitleBar"
	title_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	title_bar.add_theme_stylebox_override("panel", _make_title_bar_style())
	_content_panel.add_child(title_bar)

	var title_margin := MarginContainer.new()
	title_margin.name = "TitleMargin"
	title_margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	title_margin.add_theme_constant_override("margin_left", 24)
	title_margin.add_theme_constant_override("margin_right", 24)
	title_margin.add_theme_constant_override("margin_top", 12)
	title_margin.add_theme_constant_override("margin_bottom", 12)
	title_bar.add_child(title_margin)

	_title_label = Label.new()
	_title_label.name = "TitleLabel"
	_title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_title_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_title_label.add_theme_font_size_override("font_size", 28)
	_title_label.add_theme_color_override("font_color", Color(1.0, 0.86, 0.35, 1.0))
	if _font != null:
		_title_label.add_theme_font_override("font", _font)
	title_margin.add_child(_title_label)

	_share_button = Button.new()
	_share_button.name = "ShareButton"
	_share_button.text = "Share"
	_share_button.custom_minimum_size = Vector2(170, 46)
	_share_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	_share_button.add_theme_font_size_override("font_size", 18)
	_share_button.add_theme_stylebox_override(
		"normal", _make_button_style(Color(0.2, 0.42, 0.65, 0.92))
	)
	_share_button.add_theme_stylebox_override(
		"hover", _make_button_style(Color(0.28, 0.52, 0.78, 0.96))
	)
	_share_button.add_theme_stylebox_override(
		"pressed", _make_button_style(Color(0.16, 0.34, 0.55, 0.96))
	)
	_share_button.pressed.connect(_on_share_pressed)
	_content_panel.add_child(_share_button)

	_collect_button = Button.new()
	_collect_button.name = "CollectButton"
	_collect_button.text = "Collect"
	_collect_button.custom_minimum_size = Vector2(170, 46)
	_collect_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	_collect_button.add_theme_font_size_override("font_size", 18)
	_collect_button.add_theme_stylebox_override(
		"normal", _make_button_style(Color(0.25, 0.5, 0.35, 0.92))
	)
	_collect_button.add_theme_stylebox_override(
		"hover", _make_button_style(Color(0.32, 0.62, 0.43, 0.96))
	)
	_collect_button.add_theme_stylebox_override(
		"pressed", _make_button_style(Color(0.19, 0.4, 0.28, 0.96))
	)
	_collect_button.pressed.connect(_on_collect_pressed)
	_content_panel.add_child(_collect_button)

	_update_layout()


func _update_layout() -> void:
	var viewport_size := get_viewport_rect().size
	_background.position = Vector2.ZERO
	_background.size = viewport_size

	var card_size := Vector2(
		minf(viewport_size.x * 0.62, 900.0), minf(viewport_size.y * 0.62, 620.0)
	)
	card_size.x = maxf(card_size.x, 620.0)
	card_size.y = maxf(card_size.y, 420.0)
	_content_panel.position = (viewport_size - card_size) / 2.0
	_content_panel.size = card_size

	_image.position = Vector2(2.0, 2.0)
	_image.size = card_size - Vector2(4.0, 4.0)

	var title_bar: Panel = _content_panel.get_node("TitleBar")
	title_bar.position = Vector2(2.0, card_size.y - 112.0)
	title_bar.size = Vector2(card_size.x - 4.0, 110.0)

	_share_button.position = Vector2(28.0, card_size.y - 72.0)
	_share_button.size = Vector2(170.0, 46.0)
	_collect_button.position = Vector2(card_size.x - 198.0, card_size.y - 72.0)
	_collect_button.size = Vector2(170.0, 46.0)


func _apply_data() -> void:
	if _title_label != null:
		_title_label.text = treasure_name
	if _image != null:
		_image.texture = _load_texture(treasure_image_path)


func _on_share_pressed() -> void:
	AudioManager.play_collect()
	choice_made.emit("share")


func _on_collect_pressed() -> void:
	AudioManager.play_collect()
	closed.emit()
	choice_made.emit("collect")


func lock_buttons() -> void:
	if is_instance_valid(_share_button):
		_share_button.disabled = true
	if is_instance_valid(_collect_button):
		_collect_button.disabled = true


func unlock_buttons() -> void:
	if is_instance_valid(_share_button):
		_share_button.disabled = false
	if is_instance_valid(_collect_button):
		_collect_button.disabled = false


func get_share_button_global_rect() -> Rect2:
	if is_instance_valid(_share_button):
		return _share_button.get_global_rect()
	return Rect2()


func get_collect_button_global_rect() -> Rect2:
	if is_instance_valid(_collect_button):
		return _collect_button.get_global_rect()
	return Rect2()


func _make_card_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.12, 0.12, 0.18, 0.95)
	style.corner_radius_top_left = 16
	style.corner_radius_top_right = 16
	style.corner_radius_bottom_left = 16
	style.corner_radius_bottom_right = 16
	style.border_width_top = 2
	style.border_width_bottom = 2
	style.border_width_left = 2
	style.border_width_right = 2
	style.border_color = Color(0.35, 0.55, 0.85, 0.6)
	style.shadow_color = Color(0.0, 0.0, 0.0, 0.5)
	style.shadow_size = 12
	return style


func _make_title_bar_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.05, 0.06, 0.1, 0.78)
	style.corner_radius_bottom_left = 14
	style.corner_radius_bottom_right = 14
	return style


func _make_button_style(bg_color: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = bg_color
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8
	style.content_margin_left = 16
	style.content_margin_right = 16
	style.content_margin_top = 10
	style.content_margin_bottom = 10
	return style


func _load_texture(image_path: String) -> Texture2D:
	if image_path == "":
		return null

	var resource := load(image_path)
	if resource is Texture2D:
		return resource as Texture2D
	if resource is Image:
		return ImageTexture.create_from_image(resource as Image)

	if not FileAccess.file_exists(image_path):
		return null

	var img := Image.new()
	if img.load(image_path) == OK:
		return ImageTexture.create_from_image(img)

	return null
