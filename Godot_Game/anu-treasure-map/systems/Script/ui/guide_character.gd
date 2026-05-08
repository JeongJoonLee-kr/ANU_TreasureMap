class_name GuideCharacter
extends Control

const HAPPY_IMG := "res://resources/ui/tutorial_guide/guide_character_happy.png"
const HINT_IMG := "res://resources/ui/tutorial_guide/guide_character_hint.png"
const BUBBLE_SVG := "res://resources/ui/tutorial_guide/speech_bubble.svg"

# Bear
const BEAR_SIZE := Vector2(260, 260)

# Bubble SVG native size: 320x100 (body 320x84 + tail 16px at bottom center)
const BUBBLE_SIZE := Vector2(320, 100)
const BUBBLE_BODY_H := 84.0
const LABEL_MARGIN := Vector2(42, 16)  # left/right from rounded corners, top/bottom

var _canvas: CanvasLayer
var _bear: TextureRect
var _bubble_bg: TextureRect
var _label: Label
var _timer: Timer
var _happy_tex: Texture2D
var _hint_tex: Texture2D
var _bubble_tex: Texture2D
var _is_happy := true
var _tween: Tween


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	set_anchors_preset(Control.PRESET_FULL_RECT)
	_happy_tex = load(HAPPY_IMG)
	_hint_tex = load(HINT_IMG)
	_bubble_tex = load(BUBBLE_SVG)
	_build_ui()
	hide()


func _build_ui() -> void:
	_canvas = CanvasLayer.new()
	_canvas.name = "GuideCanvas"
	_canvas.layer = 80
	add_child(_canvas)

	# Bubble: above the bear, centered horizontally
	_bubble_bg = TextureRect.new()
	_bubble_bg.name = "BubbleBg"
	_bubble_bg.texture = _bubble_tex
	_bubble_bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_bubble_bg.stretch_mode = TextureRect.STRETCH_KEEP
	_bubble_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_bubble_bg.size = BUBBLE_SIZE
	_canvas.add_child(_bubble_bg)

	_label = Label.new()
	_label.name = "Text"
	_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_label.add_theme_font_size_override("font_size", 15)
	_label.add_theme_color_override("font_color", Color(0.15, 0.18, 0.28, 1.0))
	_bubble_bg.add_child(_label)

	# Bear: below the bubble
	_bear = TextureRect.new()
	_bear.name = "Bear"
	_bear.texture = _happy_tex
	_bear.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_bear.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_bear.custom_minimum_size = BEAR_SIZE
	_bear.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_bear.size = BEAR_SIZE
	_canvas.add_child(_bear)

	_timer = Timer.new()
	_timer.name = "AnimTimer"
	_timer.wait_time = 0.40
	_timer.timeout.connect(_toggle_bear)
	add_child(_timer)


func show_tutorial(text: String) -> void:
	_label.text = text
	_place_all()
	_timer.start()
	show()

	if _tween and _tween.is_valid():
		_tween.kill()
	modulate.a = 0.0
	_bear.modulate.a = 0.0
	_bubble_bg.modulate.a = 0.0

	_tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	_tween.tween_property(self, "modulate:a", 1.0, 0.25)
	_tween.tween_property(_bear, "modulate:a", 1.0, 0.35)
	_tween.tween_property(_bubble_bg, "modulate:a", 1.0, 0.35)


func hide_tutorial() -> void:
	_timer.stop()
	if _tween and _tween.is_valid():
		_tween.kill()
	_tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	_tween.tween_property(self, "modulate:a", 0.0, 0.2)
	_tween.tween_callback(hide)


func set_bear_position(pos: Vector2) -> void:
	_bear.position = pos
	_place_all()


func _toggle_bear() -> void:
	_is_happy = not _is_happy
	_bear.texture = _happy_tex if _is_happy else _hint_tex


func _place_all() -> void:
	var vp := get_viewport_rect().size

	# Default bear position: bottom-right, above phone
	if _bear.position == Vector2.ZERO:
		_bear.position = Vector2(1580, 590)

	# Center bubble horizontally above the bear
	var bubble_x := _bear.position.x + (_bear.size.x - BUBBLE_SIZE.x) / 2.0
	var bubble_y := _bear.position.y - BUBBLE_SIZE.y + 14.0

	# Clamp to viewport
	bubble_x = clampf(bubble_x, 12.0, vp.x - BUBBLE_SIZE.x - 12.0)
	bubble_y = clampf(bubble_y, 12.0, vp.y - BUBBLE_SIZE.y - _bear.size.y - 12.0)

	_bubble_bg.position = Vector2(bubble_x, bubble_y)

	# Label inside the bubble body (above the tail)
	_label.position = Vector2(LABEL_MARGIN.x, LABEL_MARGIN.y)
	_label.size = Vector2(BUBBLE_SIZE.x - LABEL_MARGIN.x * 2, BUBBLE_BODY_H - LABEL_MARGIN.y * 2)
