@tool
class_name LocationMarker
extends Control

signal preview_requested(location_id: String, image_path: String, anchor: Control)
signal preview_hidden
signal selected(location_id: String, anchor: Control)

enum MedalRibbon { BLUE, GREEN, ORANGE, PINK, PURPLE, CYAN }

const ROOT_SIZE := Vector2(220, 90)
const MEDAL_MARKER_SIZE := Vector2(220, 156)

const ACTIVE_DOT_MODULATE := Color(1, 1, 1, 1)

const _CLASSIC_DOT_POS := Vector2(100.0, 48.0)
const _CLASSIC_DOT_SIZE := Vector2(20.0, 20.0)

## Horizontal center of MedalVisual in marker coords (offset_left/right in location_marker.tscn).
const _MEDAL_CENTER_X := 110.0
## Narrow plate under the pin so labels don't stretch toward neighbouring markers.
const _MEDAL_PLATE_WIDTH := 118.0
const _MEDAL_PLATE_HEIGHT := 54.0

## Covers medal + bottom name plate (reference layout).
const _MEDAL_HIT_POS := Vector2(52.0, 4.0)
const _MEDAL_HIT_SIZE := Vector2(116.0, 148.0)

const _MEDAL_PLATE_POS := Vector2(_MEDAL_CENTER_X - _MEDAL_PLATE_WIDTH * 0.5, 97.0)
const _MEDAL_PLATE_SIZE := Vector2(_MEDAL_PLATE_WIDTH, _MEDAL_PLATE_HEIGHT)

const _CLASSIC_PLATE_RECT := Rect2(-1.0, -1.0, 220.0, 40.0)

const _RIBBON_TEX: Dictionary = {
	MedalRibbon.BLUE: preload("res://resources/ui/map_badges/badge_ribbon.svg"),
	MedalRibbon.GREEN: preload("res://resources/ui/map_badges/badge_ribbon_green.svg"),
	MedalRibbon.ORANGE: preload("res://resources/ui/map_badges/badge_ribbon_orange.svg"),
	MedalRibbon.PINK: preload("res://resources/ui/map_badges/badge_ribbon_pink.svg"),
	MedalRibbon.PURPLE: preload("res://resources/ui/map_badges/badge_ribbon_purple.svg"),
	MedalRibbon.CYAN: preload("res://resources/ui/map_badges/badge_ribbon_cyan.svg"),
}

const _RING_TEX: Dictionary = {
	MedalRibbon.BLUE: preload("res://resources/ui/map_badges/badge_circle.svg"),
	MedalRibbon.GREEN: preload("res://resources/ui/map_badges/badge_circle_green.svg"),
	MedalRibbon.ORANGE: preload("res://resources/ui/map_badges/badge_circle_orange.svg"),
	MedalRibbon.PINK: preload("res://resources/ui/map_badges/badge_circle_pink.svg"),
	MedalRibbon.PURPLE: preload("res://resources/ui/map_badges/badge_circle_purple.svg"),
	MedalRibbon.CYAN: preload("res://resources/ui/map_badges/badge_circle_cyan.svg"),
}

## Label color on white plate (ribbon "dark" accent for readability).
const _MEDAL_NAME_COLORS: Dictionary = {
	MedalRibbon.BLUE: Color(0.118, 0.533, 0.898, 1.0),
	MedalRibbon.GREEN: Color(0.263, 0.627, 0.412, 1.0),
	MedalRibbon.ORANGE: Color(0.984, 0.549, 0.0, 1.0),
	MedalRibbon.PINK: Color(0.847, 0.106, 0.376, 1.0),
	MedalRibbon.PURPLE: Color(0.369, 0.208, 0.694, 1.0),
	MedalRibbon.CYAN: Color(0.0, 0.592, 0.655, 1.0),
}

const _PHOTO_CLIP_SHADER := preload("res://resources/shaders/map_badge_photo_clip.gdshader")
const _MEDAL_PHOTO_CLIP_RADIUS := 20.0 / 48.0

const _MEDAL_FX_HOVER_SCALE := Vector2(1.075, 1.075)
const _MEDAL_FX_PRESS_SCALE := Vector2(0.94, 0.94)
const _MEDAL_FX_DURATION := 0.11
const _MEDAL_PLATE_HOVER_LIFT := 3.0

@export var location_id: String = ""
@export var display_name_override: String = ""
@export var preview_image_path_override: String = ""

## Trial / optional: medal UI instead of the dot (enable per marker in the map).
@export var use_medal_visual: bool = false
@export var medal_ribbon: MedalRibbon = MedalRibbon.BLUE
@export var medal_photo: Texture2D

@onready var name_plate: Panel = $NamePlate
@onready var name_label: Label = $NamePlate/NameLabel
@onready var dot_button: Button = $DotButton
@onready var medal_visual: Control = $MedalVisual
@onready var medal_ribbon_rect: TextureRect = $MedalVisual/Ribbon
@onready var medal_photo_rect: TextureRect = $MedalVisual/PhotoSlot
@onready var medal_circle_rect: TextureRect = $MedalVisual/CircleRing

var preview_image_path: String = ""
var is_active: bool = true
var active_normal_style: StyleBox
var active_hover_style: StyleBox
var inactive_style: StyleBoxFlat

var _medal_hit_style: StyleBoxFlat
var _medal_plate_style: StyleBoxFlat
var _classic_plate_clear_style: StyleBoxFlat

var _medal_hovering: bool = false
var _medal_pressed: bool = false
var _medal_fx_tween: Tween


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	custom_minimum_size = ROOT_SIZE
	size = ROOT_SIZE
	name_plate.mouse_filter = Control.MOUSE_FILTER_IGNORE
	name_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	dot_button.focus_mode = Control.FOCUS_NONE

	_medal_hit_style = StyleBoxFlat.new()
	_medal_hit_style.bg_color = Color(1, 1, 1, 0)

	_medal_plate_style = StyleBoxFlat.new()
	_medal_plate_style.bg_color = Color(1, 1, 1, 1)
	_medal_plate_style.corner_radius_top_left = 5
	_medal_plate_style.corner_radius_top_right = 5
	_medal_plate_style.corner_radius_bottom_right = 5
	_medal_plate_style.corner_radius_bottom_left = 5
	_medal_plate_style.shadow_color = Color(0, 0, 0, 0.16)
	_medal_plate_style.shadow_size = 5
	_medal_plate_style.shadow_offset = Vector2(0, 2)
	_medal_plate_style.content_margin_left = 6
	_medal_plate_style.content_margin_top = 5
	_medal_plate_style.content_margin_right = 6
	_medal_plate_style.content_margin_bottom = 5

	_classic_plate_clear_style = StyleBoxFlat.new()
	_classic_plate_clear_style.bg_color = Color(0, 0, 0, 0)
	_classic_plate_clear_style.border_width_left = 0
	_classic_plate_clear_style.border_width_top = 0
	_classic_plate_clear_style.border_width_right = 0
	_classic_plate_clear_style.border_width_bottom = 0

	_cache_button_styles()

	if not dot_button.mouse_entered.is_connected(_on_dot_mouse_entered):
		dot_button.mouse_entered.connect(_on_dot_mouse_entered)
	if not dot_button.mouse_exited.is_connected(_on_dot_mouse_exited):
		dot_button.mouse_exited.connect(_on_dot_mouse_exited)
	if not dot_button.pressed.is_connected(_on_dot_pressed):
		dot_button.pressed.connect(_on_dot_pressed)
	if not dot_button.button_down.is_connected(_on_dot_button_down):
		dot_button.button_down.connect(_on_dot_button_down)
	if not dot_button.button_up.is_connected(_on_dot_button_up):
		dot_button.button_up.connect(_on_dot_button_up)

	_ensure_medal_photo_clip()
	_apply_visual_mode()
	_refresh_editor_preview()
	set_process(Engine.is_editor_hint())


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		_refresh_editor_preview()


func _apply_visual_mode() -> void:
	if not is_node_ready():
		return

	if use_medal_visual:
		custom_minimum_size = MEDAL_MARKER_SIZE
		size = MEDAL_MARKER_SIZE
		medal_visual.visible = true
		dot_button.flat = true
		dot_button.position = _MEDAL_HIT_POS
		dot_button.size = _MEDAL_HIT_SIZE
		if medal_ribbon_rect and _RIBBON_TEX.has(medal_ribbon):
			medal_ribbon_rect.texture = _RIBBON_TEX[medal_ribbon]
		if medal_circle_rect and _RING_TEX.has(medal_ribbon):
			medal_circle_rect.texture = _RING_TEX[medal_ribbon]
		_refresh_medal_photo()
		_reset_medal_interaction_state()
	else:
		custom_minimum_size = ROOT_SIZE
		size = ROOT_SIZE
		medal_visual.visible = false
		dot_button.flat = false
		dot_button.position = _CLASSIC_DOT_POS
		dot_button.size = _CLASSIC_DOT_SIZE
		_reset_medal_interaction_state()

	_apply_name_plate_layout()


func _apply_name_plate_layout() -> void:
	if not is_instance_valid(name_plate) or not is_instance_valid(name_label):
		return

	if use_medal_visual:
		name_plate.position = _MEDAL_PLATE_POS
		name_plate.size = _MEDAL_PLATE_SIZE
		name_plate.clip_contents = true
		name_plate.add_theme_stylebox_override("panel", _medal_plate_style)
		var name_col: Color = (
			_MEDAL_NAME_COLORS[medal_ribbon]
			if _MEDAL_NAME_COLORS.has(medal_ribbon)
			else Color(0.259, 0.647, 0.961, 1.0)
		)
		name_label.add_theme_color_override("font_color", name_col)
		name_label.add_theme_constant_override("outline_size", 0)
		name_label.add_theme_font_size_override("font_size", 12)
		name_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		name_label.max_lines_visible = 3
		name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		name_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	else:
		name_plate.clip_contents = false
		name_plate.position = _CLASSIC_PLATE_RECT.position
		name_plate.size = _CLASSIC_PLATE_RECT.size
		name_plate.add_theme_stylebox_override("panel", _classic_plate_clear_style)
		name_label.add_theme_color_override("font_color", Color(1, 1, 1, 1))
		name_label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 1))
		name_label.add_theme_constant_override("outline_size", 5)
		name_label.add_theme_font_size_override("font_size", 24)
		name_label.autowrap_mode = TextServer.AUTOWRAP_OFF
		name_label.max_lines_visible = -1


func _ensure_medal_photo_clip() -> void:
	if not is_instance_valid(medal_photo_rect):
		return
	var mat := medal_photo_rect.material as ShaderMaterial
	if mat == null:
		mat = ShaderMaterial.new()
		mat.shader = _PHOTO_CLIP_SHADER
		medal_photo_rect.material = mat
	mat.set_shader_parameter("clip_radius", _MEDAL_PHOTO_CLIP_RADIUS)


func _refresh_medal_photo() -> void:
	if not use_medal_visual or not is_instance_valid(medal_photo_rect):
		return
	var tex: Texture2D = medal_photo
	if tex == null and preview_image_path != "" and ResourceLoader.exists(preview_image_path):
		tex = load(preview_image_path) as Texture2D
	medal_photo_rect.texture = tex
	medal_photo_rect.visible = tex != null


func _medal_base_modulate() -> Color:
	if not use_medal_visual:
		return Color.WHITE
	return Color(1, 1, 1, 1) if is_active else Color(0.72, 0.72, 0.72, 1)


func _reset_medal_interaction_state() -> void:
	_medal_hovering = false
	_medal_pressed = false
	if _medal_fx_tween != null:
		_medal_fx_tween.kill()
		_medal_fx_tween = null
	if not is_instance_valid(medal_visual):
		return
	medal_visual.scale = Vector2.ONE
	if use_medal_visual:
		medal_visual.modulate = _medal_base_modulate()
	if is_instance_valid(name_plate) and use_medal_visual:
		name_plate.position = _MEDAL_PLATE_POS


func _medal_fx_targets() -> Dictionary:
	if not use_medal_visual or not is_active:
		return {
			"scale": Vector2.ONE, "modulate": _medal_base_modulate(), "plate_pos": _MEDAL_PLATE_POS
		}
	var scale := Vector2.ONE
	var mod := _medal_base_modulate()
	var plate_pos := _MEDAL_PLATE_POS
	if _medal_pressed:
		scale = _MEDAL_FX_PRESS_SCALE
		mod = _medal_base_modulate() * Color(0.93, 0.93, 0.96, 1.0)
		plate_pos = Vector2(_MEDAL_PLATE_POS.x, _MEDAL_PLATE_POS.y - 1.0)
	elif _medal_hovering:
		scale = _MEDAL_FX_HOVER_SCALE
		mod = _medal_base_modulate() * Color(1.07, 1.07, 1.1, 1.0)
		plate_pos = Vector2(_MEDAL_PLATE_POS.x, _MEDAL_PLATE_POS.y - _MEDAL_PLATE_HOVER_LIFT)
	return {"scale": scale, "modulate": mod, "plate_pos": plate_pos}


func _tween_medal_interaction_fx() -> void:
	if not use_medal_visual or not is_instance_valid(medal_visual):
		return
	if _medal_fx_tween != null:
		_medal_fx_tween.kill()
	var targets := _medal_fx_targets()
	_medal_fx_tween = create_tween()
	_medal_fx_tween.set_parallel(true)
	_medal_fx_tween.set_trans(Tween.TRANS_CUBIC)
	_medal_fx_tween.set_ease(Tween.EASE_OUT)
	_medal_fx_tween.tween_property(medal_visual, "scale", targets.scale, _MEDAL_FX_DURATION)
	_medal_fx_tween.tween_property(medal_visual, "modulate", targets.modulate, _MEDAL_FX_DURATION)
	if is_instance_valid(name_plate):
		_medal_fx_tween.tween_property(
			name_plate, "position", targets.plate_pos, _MEDAL_FX_DURATION
		)


func _refresh_editor_preview() -> void:
	if not is_instance_valid(name_label):
		return

	name_label.visible = true
	name_plate.visible = not use_medal_visual
	dot_button.disabled = false
	dot_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	dot_button.modulate = ACTIVE_DOT_MODULATE

	if use_medal_visual:
		_apply_medal_hit_style_overrides()
	else:
		_apply_button_style(is_active)

	if display_name_override != "":
		name_label.text = display_name_override
	elif location_id != "":
		name_label.text = _format_location_name(location_id)
	else:
		name_label.text = "Location"


func _format_location_name(raw_location_id: String) -> String:
	var words := raw_location_id.split("_", false)
	for i in range(words.size()):
		words[i] = String(words[i]).capitalize()
	return " ".join(words)


func configure_from_data(data: Dictionary) -> void:
	var display_name := display_name_override
	if display_name == "":
		display_name = str(data.get("map_label", data.get("title", location_id)))
	name_label.text = display_name
	is_active = bool(data.get("active", true))
	name_label.visible = is_active and not use_medal_visual
	name_plate.visible = is_active and not use_medal_visual
	dot_button.disabled = not is_active
	dot_button.mouse_default_cursor_shape = (
		Control.CURSOR_POINTING_HAND if is_active else Control.CURSOR_ARROW
	)
	dot_button.modulate = ACTIVE_DOT_MODULATE

	preview_image_path = preview_image_path_override
	if preview_image_path == "":
		preview_image_path = str(data.get("preview_image_path", data.get("image_path", "")))

	if use_medal_visual:
		_apply_medal_hit_style_overrides()
		_refresh_medal_photo()
		_reset_medal_interaction_state()
		_apply_name_plate_layout()
		name_plate.modulate = Color(1, 1, 1, 1) if is_active else Color(0.88, 0.88, 0.88, 1)
	else:
		name_plate.modulate = Color(1, 1, 1, 1)
		_apply_button_style(is_active)


func get_is_active() -> bool:
	return is_active


func _cache_button_styles() -> void:
	active_normal_style = dot_button.get_theme_stylebox("normal")
	active_hover_style = dot_button.get_theme_stylebox("hover")

	inactive_style = active_normal_style.duplicate() as StyleBoxFlat
	if inactive_style != null:
		inactive_style.bg_color = Color(0.52, 0.52, 0.52, 1)
		inactive_style.border_color = Color(0.78, 0.78, 0.78, 0.95)
		inactive_style.shadow_color = Color(0, 0, 0, 0.1)


func _apply_medal_hit_style_overrides() -> void:
	for state in ["normal", "hover", "pressed", "focus", "disabled"]:
		dot_button.add_theme_stylebox_override(state, _medal_hit_style)


func _apply_button_style(active: bool) -> void:
	if use_medal_visual:
		_apply_medal_hit_style_overrides()
		return

	if active:
		dot_button.add_theme_stylebox_override("normal", active_normal_style)
		dot_button.add_theme_stylebox_override("hover", active_hover_style)
		dot_button.add_theme_stylebox_override("pressed", active_hover_style)
		dot_button.add_theme_stylebox_override("focus", active_hover_style)
		dot_button.add_theme_stylebox_override("disabled", active_normal_style)
		return

	if inactive_style == null:
		return

	dot_button.add_theme_stylebox_override("normal", inactive_style)
	dot_button.add_theme_stylebox_override("hover", inactive_style)
	dot_button.add_theme_stylebox_override("pressed", inactive_style)
	dot_button.add_theme_stylebox_override("focus", inactive_style)
	dot_button.add_theme_stylebox_override("disabled", inactive_style)


func get_anchor_control() -> Control:
	return dot_button


func _on_dot_mouse_entered() -> void:
	if not is_active:
		return
	if use_medal_visual:
		_medal_hovering = true
		_tween_medal_interaction_fx()
	preview_requested.emit(location_id, preview_image_path, dot_button)


func _on_dot_mouse_exited() -> void:
	if use_medal_visual:
		_medal_hovering = false
		_medal_pressed = false
		_tween_medal_interaction_fx()
	preview_hidden.emit()


func _on_dot_pressed() -> void:
	if not is_active:
		return
	selected.emit(location_id, dot_button)


func _on_dot_button_down() -> void:
	if not is_active or not use_medal_visual:
		return
	_medal_pressed = true
	_tween_medal_interaction_fx()


func _on_dot_button_up() -> void:
	if not use_medal_visual:
		return
	_medal_pressed = false
	if is_active:
		_tween_medal_interaction_fx()


func _set(property: StringName, _value: Variant) -> bool:
	if property == &"use_medal_visual" or property == &"medal_ribbon" or property == &"medal_photo":
		call_deferred("_on_medal_export_changed")
	return false


func _on_medal_export_changed() -> void:
	_apply_visual_mode()
	if is_instance_valid(name_label):
		_refresh_editor_preview()
