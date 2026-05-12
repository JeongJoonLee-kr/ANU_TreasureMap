extends Control

const LOGO_FONT := preload("res://resources/font/CourierPrime-BoldItalic.ttf")
const DESIGN_SIZE := Vector2(600.0, 340.0)
const GREEN_LIGHT := Color(0.4, 0.733333, 0.415686, 1.0)
const GREEN_DARK := Color(0.262745, 0.627451, 0.278431, 1.0)
const ORANGE := Color(1.0, 0.654902, 0.14902, 1.0)
const ORANGE_LIGHT := Color(1.0, 0.717647, 0.301961, 1.0)
const BLUE := Color(0.258824, 0.647059, 0.960784, 1.0)
const BLUE_LIGHT := Color(0.392157, 0.709804, 0.964706, 1.0)
const TITLE_LIGHT := Color.WHITE
const TITLE_OUTLINE := Color(0.168627, 0.443137, 0.184314, 1.0)
const PINK := Color(0.92549, 0.25098, 0.478431, 1.0)
const LETTER_BOX_SIZE := Vector2(122.0, 122.0)
const LETTER_BOX_TOP := 18.0

var _intro_alpha: float = 0.0
var _intro_offset_y: float = 28.0
var _letter_a_progress: float = 0.0
var _letter_n_progress: float = 0.0
var _letter_u_progress: float = 0.0
var _underline_reveal: float = 0.0
var _pin_reveal: float = 0.0
var _time: float = 0.0

var _draw_origin: Vector2 = Vector2.ZERO
var _draw_scale: float = 1.0


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_start_intro_animation()


func _process(delta: float) -> void:
	_time += delta
	queue_redraw()


func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		pivot_offset = size * 0.5
		queue_redraw()


func _draw() -> void:
	if size.x <= 0.0 or size.y <= 0.0:
		return

	_update_draw_transform()
	_draw_letter_box(
		Vector2(90.0, LETTER_BOX_TOP), GREEN_DARK, GREEN_LIGHT, "A", _letter_a_progress
	)
	_draw_letter_box(Vector2(239.0, LETTER_BOX_TOP), ORANGE, ORANGE_LIGHT, "N", _letter_n_progress)
	_draw_letter_box(Vector2(388.0, LETTER_BOX_TOP), BLUE, BLUE_LIGHT, "U", _letter_u_progress)
	_draw_treasure_map_text()
	_draw_underline()
	_draw_pin_markers()


func _start_intro_animation() -> void:
	_intro_alpha = 0.0
	_intro_offset_y = 28.0
	_letter_a_progress = 0.0
	_letter_n_progress = 0.0
	_letter_u_progress = 0.0
	_underline_reveal = 0.0
	_pin_reveal = 0.0

	var tween: Tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "_intro_alpha", 1.0, 0.8).set_trans(Tween.TRANS_SINE).set_ease(
		Tween.EASE_OUT
	)
	tween.tween_property(self, "_intro_offset_y", 0.0, 1.1).set_trans(Tween.TRANS_QUINT).set_ease(
		Tween.EASE_OUT
	)
	(
		tween
		. tween_property(self, "_letter_a_progress", 1.0, 0.75)
		. set_delay(0.18)
		. set_trans(Tween.TRANS_BACK)
		. set_ease(Tween.EASE_OUT)
	)
	(
		tween
		. tween_property(self, "_letter_n_progress", 1.0, 0.75)
		. set_delay(0.42)
		. set_trans(Tween.TRANS_BACK)
		. set_ease(Tween.EASE_OUT)
	)
	(
		tween
		. tween_property(self, "_letter_u_progress", 1.0, 0.75)
		. set_delay(0.66)
		. set_trans(Tween.TRANS_BACK)
		. set_ease(Tween.EASE_OUT)
	)
	(
		tween
		. tween_property(self, "_underline_reveal", 1.0, 0.65)
		. set_delay(1.15)
		. set_trans(Tween.TRANS_CUBIC)
		. set_ease(Tween.EASE_OUT)
	)
	(
		tween
		. tween_property(self, "_pin_reveal", 1.0, 0.75)
		. set_delay(1.45)
		. set_trans(Tween.TRANS_BACK)
		. set_ease(Tween.EASE_OUT)
	)


func _update_draw_transform() -> void:
	_draw_scale = min(size.x / DESIGN_SIZE.x, size.y / DESIGN_SIZE.y)
	var scaled_size: Vector2 = DESIGN_SIZE * _draw_scale
	_draw_origin = (size - scaled_size) * 0.5
	_draw_origin.y += _intro_offset_y * _draw_scale


func _design_point(point: Vector2) -> Vector2:
	return _draw_origin + point * _draw_scale


func _design_rect(rect: Rect2) -> Rect2:
	return Rect2(_design_point(rect.position), rect.size * _draw_scale)


func _draw_letter_box(
	origin: Vector2, top_color: Color, bottom_color: Color, letter: String, progress: float
) -> void:
	var eased: float = _ease_out_back(clamp(progress, 0.0, 1.0))
	var box_size: Vector2 = LETTER_BOX_SIZE
	var center: Vector2 = origin + box_size * 0.5
	var scale_factor: float = lerp(0.82, 1.0, eased)
	var lift: float = (1.0 - eased) * 20.0
	var rect: Rect2 = Rect2(
		center - box_size * scale_factor * 0.5 + Vector2(0.0, lift), box_size * scale_factor
	)
	var screen_rect: Rect2 = _design_rect(rect)
	var alpha: float = _intro_alpha * eased

	var shadow_rect: Rect2 = screen_rect
	shadow_rect.position += Vector2(0.0, 12.0) * _draw_scale
	_draw_gradient_round_rect(
		shadow_rect, 12.0 * _draw_scale, Color(0, 0, 0, 0.18), Color(0, 0, 0, 0.02), alpha
	)
	_draw_gradient_round_rect(screen_rect, 12.0 * _draw_scale, top_color, bottom_color, alpha)
	_draw_letter_box_details(screen_rect, alpha)
	_draw_centered_string(
		letter,
		_design_point(center + Vector2(2.0, 31.0 + lift)),
		82.0 * _draw_scale * scale_factor,
		_fade(Color(0, 0, 0, 0.22), alpha)
	)
	_draw_centered_string(
		letter,
		_design_point(center + Vector2(0.0, 29.0 + lift)),
		82.0 * _draw_scale * scale_factor,
		_fade(Color.WHITE, alpha)
	)


func _draw_letter_box_details(rect: Rect2, alpha: float) -> void:
	var inner_rect: Rect2 = rect.grow(-7.0 * _draw_scale)
	var line_width: float = 2.0 * _draw_scale
	var white_soft: Color = _fade(Color(1, 1, 1, 0.24), alpha)
	var white_bright: Color = _fade(Color(1, 1, 1, 0.36), alpha)

	_draw_rounded_rect_outline(inner_rect, 9.0 * _draw_scale, white_soft, line_width)
	draw_line(
		rect.position + Vector2(18.0, 14.0) * _draw_scale,
		rect.position + Vector2(rect.size.x - 28.0 * _draw_scale, 48.0 * _draw_scale),
		_fade(Color(1, 1, 1, 0.12), alpha),
		9.0 * _draw_scale,
		true
	)

	var route_points: Array[Vector2] = [
		rect.position + Vector2(24.0, 94.0) * _draw_scale,
		rect.position + Vector2(52.0, 82.0) * _draw_scale,
		rect.position + Vector2(82.0, 98.0) * _draw_scale,
		rect.position + Vector2(104.0, 78.0) * _draw_scale,
	]
	for i in range(route_points.size() - 1):
		draw_line(
			route_points[i],
			route_points[i + 1],
			_fade(Color(1, 1, 1, 0.18), alpha),
			line_width,
			true
		)
	for point in route_points:
		draw_circle(point, 3.0 * _draw_scale, white_bright)

	var bracket_length: float = 18.0 * _draw_scale
	var inset: float = 13.0 * _draw_scale
	var top_left: Vector2 = rect.position + Vector2(inset, inset)
	var bottom_right: Vector2 = rect.position + rect.size - Vector2(inset, inset)
	draw_line(top_left, top_left + Vector2(bracket_length, 0.0), white_bright, line_width, true)
	draw_line(top_left, top_left + Vector2(0.0, bracket_length), white_bright, line_width, true)
	draw_line(
		bottom_right, bottom_right - Vector2(bracket_length, 0.0), white_bright, line_width, true
	)
	draw_line(
		bottom_right, bottom_right - Vector2(0.0, bracket_length), white_bright, line_width, true
	)


func _draw_treasure_map_text() -> void:
	var baseline: Vector2 = _design_point(Vector2(300.0, 205.0))
	var shadow_offset: Vector2 = Vector2(-1.5, 3.0) * _draw_scale
	var font_size: float = 43.0 * _draw_scale
	var tracking: float = 8.5 * _draw_scale
	var alpha: float = _intro_alpha * clamp(_underline_reveal + 0.25, 0.0, 1.0)
	var outline_offsets: Array[Vector2] = [
		Vector2(-3.0, 0.0),
		Vector2(3.0, 0.0),
		Vector2(0.0, -3.0),
		Vector2(0.0, 3.0),
		Vector2(-2.0, -2.0),
		Vector2(2.0, -2.0),
		Vector2(-2.0, 2.0),
		Vector2(2.0, 2.0),
	]

	for offset in outline_offsets:
		_draw_tracking_text(
			"TREASURE MAP",
			baseline + offset * _draw_scale,
			font_size,
			tracking,
			_fade(TITLE_OUTLINE, alpha * 0.95)
		)
	_draw_tracking_text(
		"TREASURE MAP",
		baseline + shadow_offset * 1.25,
		font_size,
		tracking,
		_fade(Color(1.0, 0.6549, 0.149, 0.85), alpha)
	)
	_draw_tracking_text("TREASURE MAP", baseline, font_size, tracking, _fade(TITLE_LIGHT, alpha))


func _draw_underline() -> void:
	var reveal: float = clamp(_underline_reveal, 0.0, 1.0)
	if reveal <= 0.0:
		return

	var rect: Rect2 = _design_rect(Rect2(62.0, 219.0, 476.0 * reveal, 6.0))
	_draw_horizontal_gradient_round_rect(
		rect,
		3.0 * _draw_scale,
		[
			GREEN_DARK,
			ORANGE,
			BLUE,
		],
		_intro_alpha
	)

	var shine_x: float = rect.position.x + fmod(_time * 50.0 * _draw_scale, max(rect.size.x, 1.0))
	var shine_rect: Rect2 = Rect2(
		shine_x - 18.0 * _draw_scale, rect.position.y, 24.0 * _draw_scale, rect.size.y
	)
	draw_rect(shine_rect, Color(1, 1, 1, 0.22 * _intro_alpha), true)


func _draw_pin_markers() -> void:
	var colors: Array[Color] = [GREEN_DARK, ORANGE, BLUE, PINK]
	var centers: Array[Vector2] = [
		Vector2(186.0, 296.0),
		Vector2(262.0, 296.0),
		Vector2(338.0, 296.0),
		Vector2(414.0, 296.0),
	]
	var reveal: float = clamp(_pin_reveal, 0.0, 1.0)
	for i in range(centers.size()):
		var phase: float = _time * 1.6 + float(i) * 0.55
		var pulse: float = 1.0 + sin(phase) * 0.045
		var pop: float = _ease_out_back(clamp(reveal - float(i) * 0.08, 0.0, 1.0))
		var center: Vector2 = _design_point(centers[i] + Vector2(0.0, (1.0 - pop) * 16.0))
		var radius: float = 20.0 * _draw_scale * pulse * pop
		if radius <= 0.0:
			continue

		draw_circle(center, radius, _fade(colors[i], _intro_alpha * pop))
		_draw_location_pin(center, _intro_alpha * pop, radius)


func _draw_location_pin(center: Vector2, alpha: float, marker_radius: float) -> void:
	var color: Color = _fade(Color.WHITE, alpha)
	var pin_radius: float = marker_radius * 0.42
	var circle_center: Vector2 = center + Vector2(0.0, -marker_radius * 0.12)
	var point: Vector2 = center + Vector2(0.0, marker_radius * 0.54)
	var left: Vector2 = circle_center + Vector2(-pin_radius * 0.86, pin_radius * 0.45)
	var right: Vector2 = circle_center + Vector2(pin_radius * 0.86, pin_radius * 0.45)
	draw_circle(circle_center, pin_radius, color)
	draw_colored_polygon([left, right, point], color)


func _draw_centered_string(
	text: String, baseline_center: Vector2, font_size: float, color: Color
) -> void:
	var size_px: int = int(round(font_size))
	var text_size: Vector2 = LOGO_FONT.get_string_size(
		text, HORIZONTAL_ALIGNMENT_LEFT, -1.0, size_px
	)
	draw_string(
		LOGO_FONT,
		Vector2(baseline_center.x - text_size.x * 0.5, baseline_center.y),
		text,
		HORIZONTAL_ALIGNMENT_LEFT,
		-1.0,
		size_px,
		color
	)


func _draw_tracking_text(
	text: String, baseline_center: Vector2, font_size: float, tracking: float, color: Color
) -> void:
	var size_px: int = int(round(font_size))
	var total_width: float = 0.0
	for i in range(text.length()):
		var character: String = text.substr(i, 1)
		total_width += (
			LOGO_FONT.get_string_size(character, HORIZONTAL_ALIGNMENT_LEFT, -1.0, size_px).x
		)
		if i < text.length() - 1:
			total_width += tracking

	var x: float = baseline_center.x - total_width * 0.5
	for i in range(text.length()):
		var character: String = text.substr(i, 1)
		draw_string(
			LOGO_FONT,
			Vector2(x, baseline_center.y),
			character,
			HORIZONTAL_ALIGNMENT_LEFT,
			-1.0,
			size_px,
			color
		)
		x += (
			LOGO_FONT.get_string_size(character, HORIZONTAL_ALIGNMENT_LEFT, -1.0, size_px).x
			+ tracking
		)


func _draw_gradient_circle(
	center: Vector2, radius: float, top_color: Color, bottom_color: Color, alpha: float
) -> void:
	var diameter: int = max(1, int(ceil(radius * 2.0)))
	for index in range(diameter):
		var local_y: float = -radius + float(index)
		var half_width: float = sqrt(max(radius * radius - local_y * local_y, 0.0))
		var t: float = (local_y + radius) / max(radius * 2.0, 1.0)
		var color: Color = _fade(top_color.lerp(bottom_color, t), alpha)
		draw_line(
			center + Vector2(-half_width, local_y),
			center + Vector2(half_width, local_y),
			color,
			max(1.0, _draw_scale),
			true
		)


func _draw_gradient_round_rect(
	rect: Rect2, radius: float, top_color: Color, bottom_color: Color, alpha: float
) -> void:
	var height: int = max(1, int(ceil(rect.size.y)))
	for index in range(height):
		var y: float = float(index)
		var inset: float = _rounded_rect_inset(y, rect.size.y, radius)
		var t: float = y / max(rect.size.y - 1.0, 1.0)
		var color: Color = _fade(top_color.lerp(bottom_color, t), alpha)
		draw_line(
			rect.position + Vector2(inset, y),
			rect.position + Vector2(rect.size.x - inset, y),
			color,
			max(1.0, _draw_scale),
			true
		)


func _draw_horizontal_gradient_round_rect(
	rect: Rect2, radius: float, colors: Array[Color], alpha: float
) -> void:
	var width: int = max(1, int(ceil(rect.size.x)))
	for index in range(width):
		var x: float = float(index)
		var t: float = x / max(rect.size.x - 1.0, 1.0)
		var color: Color = _sample_three_color_gradient(colors, t)
		var inset: float = _rounded_rect_inset(x, rect.size.x, radius)
		draw_line(
			rect.position + Vector2(x, inset),
			rect.position + Vector2(x, rect.size.y - inset),
			_fade(color, alpha),
			max(1.0, _draw_scale),
			true
		)


func _draw_rounded_rect_outline(rect: Rect2, radius: float, color: Color, width: float) -> void:
	var left: float = rect.position.x
	var right: float = rect.position.x + rect.size.x
	var top: float = rect.position.y
	var bottom: float = rect.position.y + rect.size.y
	draw_line(Vector2(left + radius, top), Vector2(right - radius, top), color, width, true)
	draw_line(Vector2(left + radius, bottom), Vector2(right - radius, bottom), color, width, true)
	draw_line(Vector2(left, top + radius), Vector2(left, bottom - radius), color, width, true)
	draw_line(Vector2(right, top + radius), Vector2(right, bottom - radius), color, width, true)
	draw_arc(Vector2(left + radius, top + radius), radius, PI, PI * 1.5, 16, color, width, true)
	draw_arc(Vector2(right - radius, top + radius), radius, PI * 1.5, TAU, 16, color, width, true)
	draw_arc(
		Vector2(right - radius, bottom - radius), radius, 0.0, PI * 0.5, 16, color, width, true
	)
	draw_arc(Vector2(left + radius, bottom - radius), radius, PI * 0.5, PI, 16, color, width, true)


func _rounded_rect_inset(axis_pos: float, axis_size: float, radius: float) -> float:
	if radius <= 0.0:
		return 0.0
	if axis_pos < radius:
		var dy: float = radius - axis_pos
		return radius - sqrt(max(radius * radius - dy * dy, 0.0))
	if axis_pos > axis_size - radius:
		var dy: float = axis_pos - (axis_size - radius)
		return radius - sqrt(max(radius * radius - dy * dy, 0.0))
	return 0.0


func _sample_three_color_gradient(colors: Array[Color], t: float) -> Color:
	var clamped_t: float = clamp(t, 0.0, 1.0)
	if clamped_t <= 0.5:
		return colors[0].lerp(colors[1], clamped_t * 2.0)
	return colors[1].lerp(colors[2], (clamped_t - 0.5) * 2.0)


func _fade(color: Color, alpha: float) -> Color:
	var faded: Color = color
	faded.a *= clamp(alpha, 0.0, 1.0)
	return faded


func _ease_out_back(value: float) -> float:
	var c1: float = 1.70158
	var c3: float = c1 + 1.0
	var shifted: float = value - 1.0
	return 1.0 + c3 * shifted * shifted * shifted + c1 * shifted * shifted
