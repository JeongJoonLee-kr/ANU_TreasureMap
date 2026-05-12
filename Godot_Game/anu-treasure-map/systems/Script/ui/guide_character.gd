class_name GuideCharacter
extends Control

signal step_advanced
signal phone_zone_clicked

const HAPPY_IMG := "res://resources/ui/tutorial_guide/guide_character_happy.png"
const HINT_IMG := "res://resources/ui/tutorial_guide/guide_character_hint.png"
const SPOTLIGHT_SHADER := "res://systems/Shader/spotlight_overlay.gdshader"

const BEAR_SIZE := Vector2(260, 260)
const BUBBLE_LABEL_MIN_W := 280.0

const OVERLAY_NONE := 0
const OVERLAY_FLAT := 1
const OVERLAY_SPOTLIGHT := 2

var _canvas: CanvasLayer
var _bear: TextureRect
var _bubble_bg: PanelContainer
var _bubble_tail: ColorRect
var _label: Label
var _timer: Timer
var _happy_tex: Texture2D
var _hint_tex: Texture2D
var _is_happy := true
var _tween: Tween

var _overlay_canvas: CanvasLayer
var _overlay: ColorRect
var _overlay_mat: ShaderMaterial

var _tap_canvas: CanvasLayer
var _tap_overlay: ColorRect

var _has_spotlight_rect := false
var _spotlight_rect := Rect2()
var _pending_overlay_mode := OVERLAY_NONE

var _tap_blocked := false
var _tap_block_timer: Timer

var _phone_zone := Rect2()
var _phone_zone_active := false

var _bear_desired_pos: Vector2 = Vector2.ZERO


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	set_anchors_preset(Control.PRESET_FULL_RECT)
	_happy_tex = load(HAPPY_IMG)
	_hint_tex = load(HINT_IMG)
	_build_ui()
	hide()


func _build_ui() -> void:
	# ── Spotlight overlay — layer 84 (above GoalPanelLayer 82) ──────────────
	_overlay_canvas = CanvasLayer.new()
	_overlay_canvas.name = "SpotlightCanvas"
	_overlay_canvas.layer = 84
	add_child(_overlay_canvas)

	_overlay_mat = ShaderMaterial.new()
	_overlay_mat.shader = load(SPOTLIGHT_SHADER)

	_overlay = ColorRect.new()
	_overlay.name = "SpotlightOverlay"
	_overlay.color = Color.WHITE
	_overlay.material = _overlay_mat
	_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	_overlay.gui_input.connect(_on_overlay_gui_input)
	_overlay.hide()
	_overlay_canvas.add_child(_overlay)

	# ── Bear + bubble canvas — layer 85 (above overlay 84) ──────────────────
	_canvas = CanvasLayer.new()
	_canvas.name = "GuideCanvas"
	_canvas.layer = 85
	add_child(_canvas)

	_bear = TextureRect.new()
	_bear.name = "Bear"
	_bear.texture = _happy_tex
	_bear.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_bear.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_bear.custom_minimum_size = BEAR_SIZE
	_bear.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_bear.size = BEAR_SIZE
	_canvas.add_child(_bear)
	_bear.hide()

	_bubble_tail = ColorRect.new()
	_bubble_tail.name = "BubbleTail"
	_bubble_tail.color = Color(0.98, 0.99, 1.0, 0.96)
	_bubble_tail.size = Vector2(22.0, 22.0)
	_bubble_tail.pivot_offset = Vector2(11.0, 11.0)
	_bubble_tail.rotation = PI / 4.0
	_bubble_tail.mouse_filter = Control.MOUSE_FILTER_IGNORE

	_bubble_bg = PanelContainer.new()
	_bubble_bg.name = "BubbleBg"
	_bubble_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.98, 0.99, 1.0, 0.96)
	style.corner_radius_top_left = 14
	style.corner_radius_top_right = 14
	style.corner_radius_bottom_left = 14
	style.corner_radius_bottom_right = 14
	style.border_color = Color(0.78, 0.82, 0.92, 0.55)
	style.border_width_left = 1
	style.border_width_top = 1
	style.border_width_right = 1
	style.border_width_bottom = 1
	style.shadow_color = Color(0.0, 0.0, 0.0, 0.14)
	style.shadow_size = 8
	style.content_margin_left = 18
	style.content_margin_right = 18
	style.content_margin_top = 14
	style.content_margin_bottom = 14
	_bubble_bg.add_theme_stylebox_override("panel", style)
	_canvas.add_child(_bubble_bg)
	_bubble_bg.hide()
	# Tail is added after bubble_bg so it renders on top, forming a seamless speech-bubble point.
	_canvas.add_child(_bubble_tail)
	_bubble_tail.hide()
	# Re-place tail whenever the bubble resizes (e.g. after text layout settles).
	_bubble_bg.resized.connect(
		func() -> void:
			if _bubble_bg.visible:
				_place_all()
	)

	_label = Label.new()
	_label.name = "Text"
	_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_label.add_theme_font_size_override("font_size", 15)
	_label.add_theme_color_override("font_color", Color(0.15, 0.18, 0.28, 1.0))
	_label.custom_minimum_size = Vector2(BUBBLE_LABEL_MIN_W, 0)
	_bubble_bg.add_child(_label)

	_timer = Timer.new()
	_timer.name = "AnimTimer"
	_timer.wait_time = 0.40
	_timer.timeout.connect(_toggle_bear)
	add_child(_timer)

	_tap_block_timer = Timer.new()
	_tap_block_timer.name = "TapBlockTimer"
	_tap_block_timer.one_shot = true
	_tap_block_timer.wait_time = 1.2
	_tap_block_timer.timeout.connect(func() -> void: _tap_blocked = false)
	add_child(_tap_block_timer)

	# ── Tap overlay — layer 86 (above all guide layers, so taps still advance the tutorial) ──
	_tap_canvas = CanvasLayer.new()
	_tap_canvas.name = "TapCanvas"
	_tap_canvas.layer = 86
	add_child(_tap_canvas)

	_tap_overlay = ColorRect.new()
	_tap_overlay.name = "TapOverlay"
	_tap_overlay.color = Color(0.0, 0.0, 0.0, 0.0)
	_tap_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	_tap_overlay.gui_input.connect(_on_tap_input)
	_tap_overlay.hide()
	_tap_canvas.add_child(_tap_overlay)


func _on_tap_input(event: InputEvent) -> void:
	if _tap_blocked:
		return
	if event is InputEventMouseButton and (event as InputEventMouseButton).pressed:
		step_advanced.emit()


# Fires only on the phone step (tap overlay hidden, overlay is STOP).
# If the click lands inside the registered phone zone, emits phone_zone_clicked.
func _on_overlay_gui_input(event: InputEvent) -> void:
	if not (event is InputEventMouseButton):
		return
	var mb := event as InputEventMouseButton
	if mb.pressed and _phone_zone_active and _phone_zone.has_point(mb.position):
		phone_zone_clicked.emit()


# ── Input blocking ────────────────────────────────────────────────────────────


# Block all input immediately (transparent overlay) before the guide fades in.
func block_input() -> void:
	var vp_size := get_viewport_rect().size
	_overlay.size = vp_size
	_overlay.position = Vector2.ZERO
	_overlay.material = null
	_overlay.color = Color.TRANSPARENT
	_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	_overlay.modulate.a = 1.0
	_overlay.show()
	show()


# ── Phone zone ────────────────────────────────────────────────────────────────


func set_phone_zone(rect: Rect2) -> void:
	_phone_zone = rect
	_phone_zone_active = true


func clear_phone_zone() -> void:
	_phone_zone_active = false


# ── Onboarding step API ───────────────────────────────────────────────────────


func show_step(
	text: String,
	bear_pos: Vector2,
	overlay_mode: int,
	allow_tap: bool,
	overlay_passthrough: bool = false,
	keep_overlay: bool = false,
) -> void:
	_has_spotlight_rect = false
	_phone_zone_active = false
	_pending_overlay_mode = overlay_mode

	var apply := func() -> void:
		_label.text = text
		_bear.position = bear_pos
		_bear_desired_pos = bear_pos
		_timer.start()

		match overlay_mode:
			OVERLAY_SPOTLIGHT:
				_overlay.material = _overlay_mat
				_overlay.color = Color.WHITE
				_overlay.mouse_filter = (
					Control.MOUSE_FILTER_IGNORE
					if overlay_passthrough
					else Control.MOUSE_FILTER_STOP
				)
				if not keep_overlay:
					_overlay.modulate.a = 0.0
				_overlay.show()
			OVERLAY_FLAT:
				_overlay.material = null
				_overlay.color = Color(0.04, 0.05, 0.14, 0.80)
				_overlay.mouse_filter = (
					Control.MOUSE_FILTER_IGNORE
					if overlay_passthrough
					else Control.MOUSE_FILTER_STOP
				)
				if not keep_overlay:
					_overlay.modulate.a = 0.0
				_overlay.show()
			_:
				_overlay.hide()

		var vp_size := get_viewport_rect().size
		_tap_overlay.visible = allow_tap
		_tap_overlay.size = vp_size
		_tap_overlay.position = Vector2.ZERO

		_bear.show()
		_bubble_bg.show()
		_bubble_tail.show()
		_bear.modulate.a = 0.0
		_bubble_bg.modulate.a = 0.0
		_bubble_tail.modulate.a = 0.0
		_tap_blocked = true
		_tap_block_timer.start()
		show()
		call_deferred("_do_fade_in")

	if _tween and _tween.is_valid():
		_tween.kill()
	# Snap overlay to fully opaque when keeping it — prevents flash if tween was mid-animation.
	if keep_overlay and _overlay.visible:
		_overlay.modulate.a = 1.0

	if visible and _bear.modulate.a > 0.05:
		_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
		_tween.tween_property(_bear, "modulate:a", 0.0, 0.15)
		_tween.parallel().tween_property(_bubble_bg, "modulate:a", 0.0, 0.15)
		_tween.parallel().tween_property(_bubble_tail, "modulate:a", 0.0, 0.15)
		if not keep_overlay:
			_tween.parallel().tween_property(_overlay, "modulate:a", 0.0, 0.15)
		_tween.tween_callback(apply)
	else:
		apply.call()


func _do_fade_in() -> void:
	_place_all()
	# Re-place tail one deferred frame later so layout has settled before the tail becomes visible.
	call_deferred("_reposition_tail")
	if _tween and _tween.is_valid():
		_tween.kill()
	_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	var overlay_needs_fade := (
		_pending_overlay_mode != OVERLAY_NONE and _overlay.visible and _overlay.modulate.a < 0.99
	)
	if _pending_overlay_mode == OVERLAY_FLAT and overlay_needs_fade:
		# Gray overlay fades in first, then bear appears on top.
		_tween.tween_property(_overlay, "modulate:a", 1.0, 0.30)
		_tween.tween_property(_bear, "modulate:a", 1.0, 0.30)
		_tween.parallel().tween_property(_bubble_bg, "modulate:a", 1.0, 0.30)
		_tween.parallel().tween_property(_bubble_tail, "modulate:a", 1.0, 0.30)
	else:
		_tween.tween_property(_bear, "modulate:a", 1.0, 0.30)
		_tween.parallel().tween_property(_bubble_bg, "modulate:a", 1.0, 0.30)
		_tween.parallel().tween_property(_bubble_tail, "modulate:a", 1.0, 0.30)
		if overlay_needs_fade:
			_tween.parallel().tween_property(_overlay, "modulate:a", 1.0, 0.35)


func _reposition_tail() -> void:
	if not (_bubble_bg.visible and _bubble_bg.size.y > 20.0):
		return
	_bubble_tail.position = Vector2(
		_bubble_bg.position.x + _bubble_bg.size.x * 0.5 - 11.0,
		_bubble_bg.position.y + _bubble_bg.size.y - 11.0,
	)


func set_spotlight_rect(rect: Rect2) -> void:
	_has_spotlight_rect = true
	_spotlight_rect = rect
	# Don't move the spotlight mid-fade-out — _place_all in _do_fade_in will pick it up.
	if not (_tween and _tween.is_valid()):
		_update_spotlight(get_viewport_rect().size)


# ── Legacy single-message API ─────────────────────────────────────────────────


func show_tutorial(text: String) -> void:
	_label.text = text
	_has_spotlight_rect = false
	_phone_zone_active = false
	_pending_overlay_mode = OVERLAY_SPOTLIGHT
	_bear.modulate.a = 0.0
	_bubble_bg.modulate.a = 0.0
	_bubble_tail.modulate.a = 0.0
	_overlay.modulate.a = 0.0
	_overlay.material = _overlay_mat
	_overlay.color = Color.WHITE
	_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	_overlay.show()
	_timer.start()
	show()
	call_deferred("_do_fade_in")


func hide_tutorial() -> void:
	_timer.stop()
	_tap_overlay.hide()
	_phone_zone_active = false
	if _tween and _tween.is_valid():
		_tween.kill()
	_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	_tween.tween_property(_bear, "modulate:a", 0.0, 0.2)
	_tween.parallel().tween_property(_bubble_bg, "modulate:a", 0.0, 0.2)
	_tween.parallel().tween_property(_bubble_tail, "modulate:a", 0.0, 0.2)
	_tween.parallel().tween_property(_overlay, "modulate:a", 0.0, 0.2)
	_tween.tween_callback(hide)
	_tween.tween_callback(_overlay.hide)


func set_bear_position(pos: Vector2) -> void:
	_bear.position = pos
	_bear_desired_pos = pos
	_place_all()


# ── Internal ──────────────────────────────────────────────────────────────────


func _toggle_bear() -> void:
	_is_happy = not _is_happy
	_bear.texture = _happy_tex if _is_happy else _hint_tex


func _place_all() -> void:
	var vp := get_viewport_rect().size

	# Always start from the intended position so repeated calls (e.g. from the
	# resized callback) give the same result regardless of previous push-downs.
	if _bear_desired_pos == Vector2.ZERO:
		_bear_desired_pos = Vector2(1580, 590)
	_bear.position = _bear_desired_pos

	var bubble_s := _bubble_bg.size
	if bubble_s.x < 20.0:
		bubble_s = _bubble_bg.get_combined_minimum_size()
	if bubble_s.x < 20.0:
		bubble_s = Vector2(BUBBLE_LABEL_MIN_W + 36.0, 64.0)

	var bubble_x := _bear.position.x + (BEAR_SIZE.x - bubble_s.x) * 0.5
	var bubble_y := _bear.position.y - bubble_s.y - 20.0

	bubble_x = clampf(bubble_x, 12.0, vp.x - bubble_s.x - 12.0)
	bubble_y = clampf(bubble_y, 12.0, vp.y - bubble_s.y - BEAR_SIZE.y - 12.0)

	# Keep the bear below the bubble + tail tip so they never overlap.
	_bear.position.y = maxf(_bear.position.y, bubble_y + bubble_s.y + 20.0)
	_bear.position.y = minf(_bear.position.y, vp.y - BEAR_SIZE.y - 12.0)

	_bubble_bg.position = Vector2(bubble_x, bubble_y)

	# Center the 22×22 diamond (pivot = 11,11) at the bottom-centre of the bubble so
	# its top half merges seamlessly into the bubble and its bottom tip is the arrow.
	# Skip placement when bubble hasn't been laid out yet to prevent mid-bubble flicker
	# during rapid step transitions.
	if _bubble_bg.size.y > 20.0:
		_bubble_tail.position = Vector2(
			bubble_x + bubble_s.x * 0.5 - 11.0,
			bubble_y + bubble_s.y - 11.0,
		)

	_update_spotlight(vp)


func _update_spotlight(vp: Vector2) -> void:
	_overlay.size = vp
	_overlay.position = Vector2.ZERO

	# Always write shader params so they are ready when material is later assigned.
	var aspect := vp.x / vp.y
	var content_center: Vector2
	var rect_half: Vector2
	var feather := 0.06

	if _has_spotlight_rect:
		content_center = _spotlight_rect.get_center()
		var pad := 16.0
		rect_half = Vector2(
			(_spotlight_rect.size.x * 0.5 + pad) / vp.x * aspect,
			(_spotlight_rect.size.y * 0.5 + pad) / vp.y
		)
	else:
		var bubble_s := _bubble_bg.size
		if bubble_s.x < 20.0:
			bubble_s = Vector2(BUBBLE_LABEL_MIN_W + 36.0, 64.0)
		var combined := Rect2(_bear.position, BEAR_SIZE).merge(Rect2(_bubble_bg.position, bubble_s))
		content_center = combined.get_center()
		feather = 0.08
		var pad := 30.0
		rect_half = Vector2(
			(combined.size.x * 0.5 + pad) / vp.x * aspect, (combined.size.y * 0.5 + pad) / vp.y
		)

	_overlay_mat.set_shader_parameter("center_uv", content_center / vp)
	_overlay_mat.set_shader_parameter("rect_half_size", rect_half)
	_overlay_mat.set_shader_parameter("feather", feather)
	_overlay_mat.set_shader_parameter("aspect_ratio", aspect)
