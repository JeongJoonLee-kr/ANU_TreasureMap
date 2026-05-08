class_name SettingsPanel
extends CanvasLayer

signal closed

const FONT_PATH := "res://resources/font/AlegreyaSans-Regular.ttf"

var _panel: PanelContainer
var _music_slider: HSlider
var _music_value: Label
var _sfx_slider: HSlider
var _sfx_value: Label
var _font: FontFile


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 180
	if ResourceLoader.exists(FONT_PATH):
		_font = load(FONT_PATH)
	_build_ui()
	_sync_values()
	set_process_unhandled_input(true)
	if not AudioManager.volumes_changed.is_connected(_on_audio_volumes_changed):
		AudioManager.volumes_changed.connect(_on_audio_volumes_changed)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		close()


func close() -> void:
	closed.emit()
	queue_free()


func _build_ui() -> void:
	var overlay := ColorRect.new()
	overlay.name = "Overlay"
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.color = Color(0.0, 0.0, 0.0, 0.5)
	overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(overlay)

	var center := CenterContainer.new()
	center.name = "Center"
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	center.mouse_filter = Control.MOUSE_FILTER_STOP
	overlay.add_child(center)

	_panel = PanelContainer.new()
	_panel.name = "SettingsPanel"
	_panel.custom_minimum_size = Vector2(520.0, 440.0)
	_panel.add_theme_stylebox_override("panel", _make_panel_style())
	center.add_child(_panel)

	var margin := MarginContainer.new()
	margin.name = "Margin"
	margin.add_theme_constant_override("margin_left", 48)
	margin.add_theme_constant_override("margin_right", 48)
	margin.add_theme_constant_override("margin_top", 34)
	margin.add_theme_constant_override("margin_bottom", 32)
	_panel.add_child(margin)

	var rows := VBoxContainer.new()
	rows.name = "Rows"
	rows.add_theme_constant_override("separation", 18)
	margin.add_child(rows)

	rows.add_child(_make_dots_row())
	rows.add_child(_make_title())
	rows.add_child(_make_rule(Color(0.38, 0.45, 0.8, 1.0), Vector2(96.0, 4.0)))
	rows.add_child(_make_spacer(12.0))

	var music_row := _make_slider_row("Music Volume")
	_music_value = music_row["value_label"]
	_music_slider = music_row["slider"]
	rows.add_child(music_row["row"])

	var sfx_row := _make_slider_row("Sound Effects Volume")
	_sfx_value = sfx_row["value_label"]
	_sfx_slider = sfx_row["slider"]
	rows.add_child(sfx_row["row"])

	rows.add_child(_make_spacer(10.0))
	rows.add_child(_make_close_button())

	_music_slider.value_changed.connect(_on_music_slider_changed)
	_sfx_slider.value_changed.connect(_on_sfx_slider_changed)


func _make_dots_row() -> HBoxContainer:
	var dots := HBoxContainer.new()
	dots.name = "Dots"
	dots.alignment = BoxContainer.ALIGNMENT_CENTER
	dots.add_theme_constant_override("separation", 14)
	dots.add_child(_make_dot(Color(0.2588, 0.6471, 0.9608, 1.0)))
	dots.add_child(_make_dot(Color(0.937, 0.325, 0.313, 1.0)))
	dots.add_child(_make_dot(Color(0.4, 0.7333, 0.4157, 1.0)))
	return dots


func _make_dot(color: Color) -> Panel:
	var dot := Panel.new()
	dot.custom_minimum_size = Vector2(12.0, 12.0)
	dot.add_theme_stylebox_override("panel", _make_dot_style(color))
	return dot


func _make_title() -> Label:
	var title := Label.new()
	title.name = "Title"
	title.text = "SETTINGS"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title.add_theme_color_override("font_color", Color(0.3686, 0.4235, 0.5176, 1.0))
	title.add_theme_font_size_override("font_size", 52)
	if _font != null:
		title.add_theme_font_override("font", _font)
	return title


func _make_slider_row(row_title: String) -> Dictionary:
	var row := VBoxContainer.new()
	row.name = row_title.replace(" ", "")
	row.add_theme_constant_override("separation", 8)

	var header := HBoxContainer.new()
	header.name = "Header"
	header.add_theme_constant_override("separation", 16)
	row.add_child(header)

	var label := Label.new()
	label.text = row_title
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.add_theme_color_override("font_color", Color(0.3686, 0.4235, 0.5176, 1.0))
	label.add_theme_font_size_override("font_size", 24)
	if _font != null:
		label.add_theme_font_override("font", _font)
	header.add_child(label)

	var value := Label.new()
	value.text = "100%"
	value.custom_minimum_size = Vector2(72.0, 0.0)
	value.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	value.add_theme_color_override("font_color", Color(0.2588, 0.6471, 0.9608, 1.0))
	value.add_theme_font_size_override("font_size", 24)
	if _font != null:
		value.add_theme_font_override("font", _font)
	header.add_child(value)

	var slider := HSlider.new()
	slider.min_value = 0.0
	slider.max_value = 100.0
	slider.step = 1.0
	slider.custom_minimum_size = Vector2(0.0, 44.0)
	slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	slider.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	row.add_child(slider)

	return {"row": row, "slider": slider, "value_label": value}


func _make_close_button() -> Button:
	var close_button := Button.new()
	close_button.name = "CloseButton"
	close_button.text = "CLOSE"
	close_button.custom_minimum_size = Vector2(0.0, 56.0)
	close_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	close_button.add_theme_font_size_override("font_size", 22)
	close_button.add_theme_color_override("font_color", Color(0.3686, 0.4235, 0.5176, 1.0))
	close_button.add_theme_stylebox_override("normal", _make_button_style(Color(1, 1, 1, 0.7)))
	close_button.add_theme_stylebox_override("hover", _make_button_style(Color(1, 1, 1, 0.9)))
	close_button.add_theme_stylebox_override(
		"pressed", _make_button_style(Color(0.92, 0.96, 1.0, 0.95))
	)
	if _font != null:
		close_button.add_theme_font_override("font", _font)
	close_button.pressed.connect(close)
	return close_button


func _make_spacer(height: float) -> Control:
	var spacer := Control.new()
	spacer.custom_minimum_size = Vector2(0.0, height)
	spacer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return spacer


func _make_rule(color: Color, rule_size: Vector2) -> CenterContainer:
	var center := CenterContainer.new()
	var rule := ColorRect.new()
	rule.custom_minimum_size = rule_size
	rule.color = color
	center.add_child(rule)
	return center


func _sync_values() -> void:
	if _music_slider == null or _sfx_slider == null:
		return
	_music_slider.set_value_no_signal(AudioManager.music_volume)
	_sfx_slider.set_value_no_signal(AudioManager.sfx_volume)
	_update_value_labels()


func _update_value_labels() -> void:
	_music_value.text = "%d%%" % roundi(_music_slider.value)
	_sfx_value.text = "%d%%" % roundi(_sfx_slider.value)


func _on_music_slider_changed(value: float) -> void:
	AudioManager.set_music_volume(value)
	_update_value_labels()


func _on_sfx_slider_changed(value: float) -> void:
	AudioManager.set_sfx_volume(value)
	_update_value_labels()


func _on_audio_volumes_changed(_music_volume: float, _sfx_volume: float) -> void:
	_sync_values()


func _make_panel_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(1.0, 1.0, 1.0, 0.92)
	style.border_width_left = 1
	style.border_width_top = 1
	style.border_width_right = 1
	style.border_width_bottom = 1
	style.border_color = Color(0.36, 0.41, 0.55, 0.32)
	style.corner_radius_top_left = 4
	style.corner_radius_top_right = 4
	style.corner_radius_bottom_left = 4
	style.corner_radius_bottom_right = 4
	style.shadow_color = Color(0.0, 0.0, 0.0, 0.22)
	style.shadow_size = 12
	return style


func _make_dot_style(color: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8
	return style


func _make_button_style(color: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.border_width_left = 1
	style.border_width_top = 1
	style.border_width_right = 1
	style.border_width_bottom = 1
	style.border_color = Color(0.2588, 0.6471, 0.9608, 0.65)
	style.corner_radius_top_left = 2
	style.corner_radius_top_right = 2
	style.corner_radius_bottom_left = 2
	style.corner_radius_bottom_right = 2
	return style
