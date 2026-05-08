class_name ChoicePanel
extends Control

signal choice_selected(choice_key: String)

const MAX_CHOICES := 5
const FONT_PATH := "res://resources/font/AlegreyaSans-Regular.ttf"

var _choices: Dictionary = {}
var _content_panel: PanelContainer
var _choices_box: VBoxContainer
var _font: FontFile


func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	if ResourceLoader.exists(FONT_PATH):
		_font = load(FONT_PATH)
	_build_ui()
	_rebuild_choices()
	get_viewport().size_changed.connect(_update_panel_width)


func setup(choices: Dictionary) -> void:
	_choices = choices.duplicate(true)
	if is_node_ready():
		_rebuild_choices()


func _build_ui() -> void:
	var center := CenterContainer.new()
	center.name = "CenterContainer"
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	center.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(center)

	_content_panel = PanelContainer.new()
	_content_panel.name = "ContentPanel"
	_content_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	_content_panel.add_theme_stylebox_override("panel", _make_panel_style())
	center.add_child(_content_panel)

	var margin := MarginContainer.new()
	margin.name = "MarginContainer"
	margin.add_theme_constant_override("margin_left", 22)
	margin.add_theme_constant_override("margin_right", 22)
	margin.add_theme_constant_override("margin_top", 20)
	margin.add_theme_constant_override("margin_bottom", 20)
	_content_panel.add_child(margin)

	_choices_box = VBoxContainer.new()
	_choices_box.name = "ChoicesBox"
	_choices_box.add_theme_constant_override("separation", 12)
	margin.add_child(_choices_box)

	_update_panel_width()


func _update_panel_width() -> void:
	if _content_panel == null:
		return
	var viewport_width := get_viewport_rect().size.x
	var panel_width := clampf(viewport_width * 0.58, 680.0, 1040.0)
	_content_panel.custom_minimum_size = Vector2(panel_width, 0.0)


func _rebuild_choices() -> void:
	if _choices_box == null:
		return

	for child in _choices_box.get_children():
		child.queue_free()

	var keys := _choices.keys()
	keys.sort_custom(_sort_choice_keys)

	var count := 0
	for raw_key in keys:
		if count >= MAX_CHOICES:
			push_warning("ChoicePanel only displays the first %d choices." % MAX_CHOICES)
			break

		var key := str(raw_key)
		var choice_data: Dictionary = _choices.get(raw_key, {})
		var label := str(choice_data.get("label", "..."))
		var display_key := str(choice_data.get("display_key", key))
		var button_text := label
		if display_key != "":
			button_text = "%s. %s" % [display_key, label]

		var button := _create_choice_button(button_text)
		button.pressed.connect(func(): choice_selected.emit(key))
		_choices_box.add_child(button)
		count += 1


func _sort_choice_keys(a: Variant, b: Variant) -> bool:
	var a_data: Dictionary = _choices.get(a, {})
	var b_data: Dictionary = _choices.get(b, {})
	var a_order := int(a_data.get("_order", 999))
	var b_order := int(b_data.get("_order", 999))
	if a_order == b_order:
		return str(a) < str(b)
	return a_order < b_order


func _create_choice_button(text: String) -> Button:
	var button := Button.new()
	button.text = ""
	button.custom_minimum_size = Vector2(0.0, 78.0)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

	if _font != null:
		button.add_theme_font_override("font", _font)
	button.add_theme_font_size_override("font_size", 19)
	button.add_theme_color_override("font_color", Color(0.24, 0.31, 0.43, 1.0))
	button.add_theme_color_override("font_hover_color", Color(0.12, 0.42, 0.72, 1.0))
	button.add_theme_color_override("font_pressed_color", Color(0.08, 0.32, 0.58, 1.0))
	button.add_theme_stylebox_override(
		"normal", _make_button_style(Color(0.98, 0.99, 1.0, 0.98), Color(0.36, 0.42, 0.75, 0.8))
	)
	button.add_theme_stylebox_override(
		"hover", _make_button_style(Color(0.91, 0.96, 1.0, 1.0), Color(0.26, 0.56, 0.94, 1.0))
	)
	button.add_theme_stylebox_override(
		"pressed", _make_button_style(Color(0.84, 0.93, 1.0, 1.0), Color(0.18, 0.48, 0.86, 1.0))
	)
	button.add_theme_stylebox_override(
		"focus", _make_button_style(Color(0.91, 0.96, 1.0, 1.0), Color(0.18, 0.48, 0.86, 1.0))
	)

	var label_margin := MarginContainer.new()
	label_margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	label_margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label_margin.add_theme_constant_override("margin_left", 18)
	label_margin.add_theme_constant_override("margin_right", 18)
	label_margin.add_theme_constant_override("margin_top", 8)
	label_margin.add_theme_constant_override("margin_bottom", 8)
	button.add_child(label_margin)

	var label := Label.new()
	label.text = text
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_size_override("font_size", 19)
	label.add_theme_color_override("font_color", Color(0.24, 0.31, 0.43, 1.0))
	if _font != null:
		label.add_theme_font_override("font", _font)
	label_margin.add_child(label)

	return button


func _make_panel_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(1.0, 1.0, 1.0, 0.96)
	style.border_width_left = 2
	style.border_width_top = 2
	style.border_width_right = 2
	style.border_width_bottom = 2
	style.border_color = Color(0.36, 0.42, 0.75, 0.9)
	style.corner_radius_top_left = 4
	style.corner_radius_top_right = 4
	style.corner_radius_bottom_left = 4
	style.corner_radius_bottom_right = 4
	style.shadow_color = Color(0.0, 0.0, 0.0, 0.25)
	style.shadow_size = 10
	return style


func _make_button_style(bg_color: Color, border_color: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = bg_color
	style.border_color = border_color
	style.border_width_left = 2
	style.border_width_top = 2
	style.border_width_right = 2
	style.border_width_bottom = 2
	style.corner_radius_top_left = 4
	style.corner_radius_top_right = 4
	style.corner_radius_bottom_left = 4
	style.corner_radius_bottom_right = 4
	style.content_margin_left = 18
	style.content_margin_right = 18
	style.content_margin_top = 12
	style.content_margin_bottom = 12
	return style
