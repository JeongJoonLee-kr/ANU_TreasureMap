extends CanvasLayer

signal sequence_started

var config: Dictionary = {}
var treasures: Array[Dictionary] = []

var _root: Control
var _gray_background: ColorRect
var _film_root: Control
var _strip: HBoxContainer
var _empty_treasure_label: Label
var _credits_root: Control
var _credits_ready := false
var _sequence_started := false


func setup(goal_config: Dictionary, collected_treasures: Array[Dictionary]) -> void:
	config = goal_config
	treasures = collected_treasures
	if is_node_ready():
		_rebuild_treasure_strip()
		_start_sequence.call_deferred()


func _ready() -> void:
	layer = 500
	_build_ui()
	_start_sequence.call_deferred()


func _build_ui() -> void:
	_root = Control.new()
	_root.name = "EndGameRoot"
	_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	_root.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(_root)

	_gray_background = ColorRect.new()
	_gray_background.name = "GrayBackground"
	_gray_background.set_anchors_preset(Control.PRESET_FULL_RECT)
	_gray_background.color = Color(0.0, 0.0, 0.0, 0.62)
	_root.add_child(_gray_background)

	_film_root = Control.new()
	_film_root.name = "FilmstripRoot"
	_film_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	_root.add_child(_film_root)

	var title := Label.new()
	title.name = "TreasureTitle"
	title.set_anchors_preset(Control.PRESET_TOP_WIDE)
	title.offset_top = 72.0
	title.offset_bottom = 132.0
	title.add_theme_font_size_override("font_size", 42)
	title.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0, 1.0))
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	var ending_config: Dictionary = config.get("ending", {})
	title.text = str(ending_config.get("treasure_title", "Collected Treasures"))
	_film_root.add_child(title)

	_strip = HBoxContainer.new()
	_strip.name = "TreasureStrip"
	_strip.add_theme_constant_override("separation", 28)
	_strip.position = Vector2(0.0, 300.0)
	_film_root.add_child(_strip)

	_empty_treasure_label = Label.new()
	_empty_treasure_label.name = "EmptyTreasureLabel"
	_empty_treasure_label.add_theme_font_size_override("font_size", 30)
	_empty_treasure_label.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0, 0.9))
	_empty_treasure_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_empty_treasure_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_empty_treasure_label.hide()
	_film_root.add_child(_empty_treasure_label)

	_build_treasure_cards()
	_build_credits()
	get_viewport().size_changed.connect(_layout)
	_layout()


func _build_treasure_cards() -> void:
	_empty_treasure_label.hide()
	if treasures.is_empty():
		var ending_config: Dictionary = config.get("ending", {})
		_empty_treasure_label.text = str(
			ending_config.get("empty_treasure_text", "No treasures collected yet")
		)
		_empty_treasure_label.show()
		return

	for entry in treasures:
		var texture := _load_texture(str(entry.get("image_path", "")))
		if texture == null:
			continue

		var frame := PanelContainer.new()
		frame.custom_minimum_size = Vector2(244.0, 244.0)
		frame.add_theme_stylebox_override("panel", _make_treasure_frame_style())
		_strip.add_child(frame)

		var margin := MarginContainer.new()
		margin.add_theme_constant_override("margin_left", 12)
		margin.add_theme_constant_override("margin_right", 12)
		margin.add_theme_constant_override("margin_top", 12)
		margin.add_theme_constant_override("margin_bottom", 12)
		frame.add_child(margin)

		var image := TextureRect.new()
		image.custom_minimum_size = Vector2(220.0, 220.0)
		image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		image.texture = texture
		margin.add_child(image)

	if _strip.get_child_count() == 0:
		var ending_config: Dictionary = config.get("ending", {})
		_empty_treasure_label.text = str(
			ending_config.get("empty_treasure_text", "No treasures collected yet")
		)
		_empty_treasure_label.show()


func _rebuild_treasure_strip() -> void:
	if _strip == null or _empty_treasure_label == null:
		return
	for child in _strip.get_children():
		child.queue_free()
	_build_treasure_cards()
	_layout()


func _build_credits() -> void:
	_credits_root = Control.new()
	_credits_root.name = "CreditsRoot"
	_credits_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	_credits_root.mouse_filter = Control.MOUSE_FILTER_STOP
	_credits_root.modulate.a = 0.0
	_credits_root.hide()
	_credits_root.gui_input.connect(_on_credits_gui_input)
	_root.add_child(_credits_root)

	var black := ColorRect.new()
	black.name = "BlackBackground"
	black.set_anchors_preset(Control.PRESET_FULL_RECT)
	black.color = Color.BLACK
	_credits_root.add_child(black)

	var center := VBoxContainer.new()
	center.name = "CreditsList"
	center.set_anchors_preset(Control.PRESET_CENTER)
	center.add_theme_constant_override("separation", 18)
	_credits_root.add_child(center)

	var title := Label.new()
	title.add_theme_font_size_override("font_size", 44)
	title.add_theme_color_override("font_color", Color.WHITE)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	var ending_config: Dictionary = config.get("ending", {})
	title.text = str(ending_config.get("credits_title", "Thanks for Playing"))
	center.add_child(title)

	var credits_config: Dictionary = config.get("credits", {})
	var members: Array = credits_config.get("members", [])
	for credit in members:
		if not (credit is Dictionary):
			continue
		var line := Label.new()
		line.add_theme_font_size_override("font_size", 26)
		line.add_theme_color_override("font_color", Color.WHITE)
		line.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		line.text = "%s - %s" % [str(credit.get("name", "")), str(credit.get("role", ""))]
		center.add_child(line)

	var hint := Label.new()
	hint.add_theme_font_size_override("font_size", 18)
	hint.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0, 0.72))
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint.text = str(ending_config.get("credits_hint", "Click anywhere to return to Start"))
	center.add_child(hint)


func _layout() -> void:
	if _strip == null:
		return
	var viewport_size := get_viewport().get_visible_rect().size
	_strip.position.y = max(240.0, viewport_size.y * 0.42)
	if _empty_treasure_label != null:
		_empty_treasure_label.size = Vector2(min(720.0, viewport_size.x * 0.82), 120.0)
		_empty_treasure_label.position = (viewport_size - _empty_treasure_label.size) * 0.5

	var center := _credits_root.get_node_or_null("CreditsList") as VBoxContainer
	if center != null:
		center.size = Vector2(min(920.0, viewport_size.x * 0.9), 520.0)
		center.position = (viewport_size - center.size) * 0.5


func _start_sequence() -> void:
	if not is_node_ready() or _strip == null:
		return
	if _sequence_started:
		return
	_sequence_started = true

	sequence_started.emit()
	await get_tree().process_frame
	_layout()

	var viewport_width := get_viewport().get_visible_rect().size.x
	var strip_width: float = maxf(_strip.get_combined_minimum_size().x, _strip.size.x)

	var ending_config: Dictionary = config.get("ending", {})
	var seconds := float(ending_config.get("filmstrip_seconds", 2.6))
	if _strip.get_child_count() == 0:
		await get_tree().create_timer(maxf(seconds * 0.55, 0.9)).timeout
		_show_credits()
		return

	_strip.position.x = viewport_width + 80.0
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(_strip, "position:x", -strip_width - 80.0, seconds)
	await tween.finished
	_show_credits()


func _show_credits() -> void:
	var ending_config: Dictionary = config.get("ending", {})
	var fade_seconds := float(ending_config.get("fade_seconds", 0.55))
	var tween := create_tween()
	tween.tween_property(_film_root, "modulate:a", 0.0, fade_seconds)
	await tween.finished
	_film_root.hide()
	_gray_background.hide()
	_credits_root.show()

	var fade_in := create_tween()
	fade_in.tween_property(_credits_root, "modulate:a", 1.0, fade_seconds)
	await fade_in.finished
	_credits_ready = true


func _on_credits_gui_input(event: InputEvent) -> void:
	if not _credits_ready:
		return
	if event is InputEventMouseButton and (event as InputEventMouseButton).pressed:
		get_tree().change_scene_to_file(str(config.get("start_menu_scene", "res://Start.tscn")))


func _load_texture(image_path: String) -> Texture2D:
	if image_path == "":
		return null
	var resource := load(image_path)
	if resource is Texture2D:
		return resource as Texture2D
	if resource is Image:
		return ImageTexture.create_from_image(resource as Image)
	return null


func _make_treasure_frame_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(1.0, 1.0, 1.0, 0.94)
	style.border_width_left = 2
	style.border_width_top = 2
	style.border_width_right = 2
	style.border_width_bottom = 2
	style.border_color = Color(1.0, 0.86, 0.35, 0.9)
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8
	style.shadow_color = Color(0.0, 0.0, 0.0, 0.35)
	style.shadow_size = 10
	return style
