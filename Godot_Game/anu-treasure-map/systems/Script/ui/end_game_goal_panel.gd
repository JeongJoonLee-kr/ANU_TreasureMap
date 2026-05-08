extends Control

var config: Dictionary = {}

var _expanded := true
var _panel: PanelContainer
var _title_label: Label
var _week_label: Label
var _treasure_label: Label
var _hint_label: Label
var _toggle_button: Button
var _edge_button: Button


func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_build_ui()
	_update_layout()
	refresh()
	get_viewport().size_changed.connect(_update_layout)


func setup(goal_config: Dictionary) -> void:
	config = goal_config
	if is_node_ready():
		refresh()


func refresh() -> void:
	if not is_node_ready():
		return

	var panel_config: Dictionary = config.get("goal_panel", {})
	var target_week_end := int(config.get("target_week_end", 5))
	var target_week_display: int = maxi(target_week_end - 1, 1)
	var target_treasures := int(config.get("target_treasures", 8))
	var treasure_count := Global.unlocked_treasures.size()

	_title_label.text = str(panel_config.get("title", "End Goals"))
	_week_label.text = str(panel_config.get("week_progress_format", "Week%d / Week%d")) % [
		min(Global.current_week, target_week_display),
		target_week_display
	]
	_treasure_label.text = str(
		panel_config.get("treasure_progress_format", "Treasures %d/%d")
	) % [min(treasure_count, target_treasures), target_treasures]
	_hint_label.text = str(panel_config.get("hint", ""))
	_toggle_button.text = str(panel_config.get("collapse_text", "Hide"))
	_edge_button.text = str(panel_config.get("expand_text", "Goals"))
	_update_visibility()


func _build_ui() -> void:
	_panel = PanelContainer.new()
	_panel.name = "GoalPanel"
	_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	_panel.add_theme_stylebox_override("panel", _make_panel_style())
	add_child(_panel)

	var margin := MarginContainer.new()
	margin.name = "Margin"
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_top", 14)
	margin.add_theme_constant_override("margin_bottom", 14)
	_panel.add_child(margin)

	var rows := VBoxContainer.new()
	rows.name = "Rows"
	rows.add_theme_constant_override("separation", 8)
	margin.add_child(rows)

	var header := HBoxContainer.new()
	header.name = "Header"
	header.add_theme_constant_override("separation", 10)
	rows.add_child(header)

	_title_label = Label.new()
	_title_label.name = "Title"
	_title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_title_label.add_theme_font_size_override("font_size", 18)
	_title_label.add_theme_color_override("font_color", Color(0.13, 0.43, 0.73, 1.0))
	header.add_child(_title_label)

	_toggle_button = Button.new()
	_toggle_button.name = "Toggle"
	_toggle_button.custom_minimum_size = Vector2(64, 30)
	_toggle_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	_toggle_button.pressed.connect(_on_toggle_pressed)
	header.add_child(_toggle_button)

	_week_label = _make_body_label("WeekProgress")
	rows.add_child(_week_label)

	_treasure_label = _make_body_label("TreasureProgress")
	rows.add_child(_treasure_label)

	_hint_label = _make_body_label("Hint")
	_hint_label.add_theme_font_size_override("font_size", 13)
	_hint_label.add_theme_color_override("font_color", Color(0.42, 0.46, 0.55, 1.0))
	_hint_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	rows.add_child(_hint_label)

	_edge_button = Button.new()
	_edge_button.name = "EdgeButton"
	_edge_button.custom_minimum_size = Vector2(58, 92)
	_edge_button.mouse_filter = Control.MOUSE_FILTER_STOP
	_edge_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	_edge_button.pressed.connect(_on_edge_button_pressed)
	add_child(_edge_button)


func _make_body_label(label_name: String) -> Label:
	var label := Label.new()
	label.name = label_name
	label.add_theme_font_size_override("font_size", 15)
	label.add_theme_color_override("font_color", Color(0.24, 0.28, 0.36, 1.0))
	return label


func _update_layout() -> void:
	if _panel == null or _edge_button == null:
		return

	var viewport_size := get_viewport_rect().size
	_panel.position = Vector2(24.0, 24.0)
	_panel.size = Vector2(min(360.0, viewport_size.x - 48.0), 156.0)
	_edge_button.position = Vector2(0.0, 28.0)
	_edge_button.size = Vector2(58.0, 92.0)


func _on_toggle_pressed() -> void:
	_expanded = false
	_update_visibility()


func _on_edge_button_pressed() -> void:
	_expanded = true
	_update_visibility()


func _update_visibility() -> void:
	if _panel == null or _edge_button == null:
		return
	_panel.visible = _expanded
	_edge_button.visible = not _expanded


func _make_panel_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(1.0, 1.0, 1.0, 0.96)
	style.border_width_left = 1
	style.border_width_top = 1
	style.border_width_right = 1
	style.border_width_bottom = 1
	style.border_color = Color(0.36, 0.52, 0.78, 0.65)
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8
	style.shadow_color = Color(0, 0, 0, 0.18)
	style.shadow_size = 8
	return style
