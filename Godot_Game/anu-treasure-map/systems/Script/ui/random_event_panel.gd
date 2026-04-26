extends Panel

## ─── Random Event Panel ───
## Displays event narrative, branching choices, and outcome text.
## Instantiated by locations.gd when an event triggers.

signal event_completed(event_id: String, choice_key: String)

# ─── State ────────────────────────────────────────────
var event_data: Dictionary = {}
var narrative_texts: Array = []
var narrative_index: int = 0
var narrative_finished: bool = false

var outcome_texts: Array = []
var outcome_index: int = 0
var outcome_finished: bool = false

var selected_choice_key: String = ""
var showing_outcome: bool = false
var showing_treasure: bool = false

# ─── Node references (created in _ready) ─────────────
var background: ColorRect
var content_panel: Panel
var title_label: Label
var narrative_label: Label
var tap_hint_label: Label
var choices_container: VBoxContainer
var choice_a_button: Button
var choice_b_button: Button
var choice_c_button: Button
var outcome_label: Label
var treasure_container: VBoxContainer
var treasure_image: TextureRect
var treasure_label: Label
var continue_button: Button


func _ready() -> void:
	_build_ui()
	_connect_signals()
	if not event_data.is_empty():
		_start_event()


func setup(data: Dictionary) -> void:
	event_data = data


# ─── UI Construction ──────────────────────────────────


func _build_ui() -> void:
	# Get viewport size for absolute positioning
	var vp_size: Vector2 = get_viewport_rect().size

	# Self — full-screen overlay (explicit size, no anchors)
	position = Vector2.ZERO
	size = vp_size
	mouse_filter = Control.MOUSE_FILTER_STOP

	# Remove default panel styling for transparent overlay
	add_theme_stylebox_override("panel", StyleBoxEmpty.new())

	# Dark semi-transparent background
	background = ColorRect.new()
	background.name = "Background"
	background.position = Vector2.ZERO
	background.size = vp_size
	background.color = Color(0, 0, 0, 0.75)
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(background)

	# Content card — centered panel (absolute position)
	var card_w := 900.0
	var card_h := 620.0
	content_panel = Panel.new()
	content_panel.name = "ContentPanel"
	content_panel.position = Vector2((vp_size.x - card_w) / 2.0, (vp_size.y - card_h) / 2.0)
	content_panel.size = Vector2(card_w, card_h)
	content_panel.custom_minimum_size = Vector2(card_w, card_h)
	# Style the card
	var card_style := StyleBoxFlat.new()
	card_style.bg_color = Color(0.12, 0.12, 0.18, 0.95)
	card_style.corner_radius_top_left = 16
	card_style.corner_radius_top_right = 16
	card_style.corner_radius_bottom_left = 16
	card_style.corner_radius_bottom_right = 16
	card_style.border_width_top = 2
	card_style.border_width_bottom = 2
	card_style.border_width_left = 2
	card_style.border_width_right = 2
	card_style.border_color = Color(0.35, 0.55, 0.85, 0.6)
	card_style.shadow_color = Color(0, 0, 0, 0.5)
	card_style.shadow_size = 12
	content_panel.add_theme_stylebox_override("panel", card_style)
	add_child(content_panel)

	# Margin container inside content panel (fill the card)
	var margin := MarginContainer.new()
	margin.position = Vector2.ZERO
	margin.size = Vector2(card_w, card_h)
	margin.add_theme_constant_override("margin_left", 40)
	margin.add_theme_constant_override("margin_right", 40)
	margin.add_theme_constant_override("margin_top", 30)
	margin.add_theme_constant_override("margin_bottom", 30)
	content_panel.add_child(margin)

	var vbox := VBoxContainer.new()
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vbox.add_theme_constant_override("separation", 16)
	margin.add_child(vbox)

	# Title
	title_label = Label.new()
	title_label.name = "TitleLabel"
	title_label.add_theme_font_size_override("font_size", 28)
	title_label.add_theme_color_override("font_color", Color(0.85, 0.75, 0.45))
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title_label)

	# Separator
	var separator := HSeparator.new()
	separator.add_theme_constant_override("separation", 8)
	vbox.add_child(separator)

	# Narrative text
	narrative_label = Label.new()
	narrative_label.name = "NarrativeLabel"
	narrative_label.add_theme_font_size_override("font_size", 20)
	narrative_label.add_theme_color_override("font_color", Color(0.9, 0.9, 0.92))
	narrative_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	narrative_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	narrative_label.custom_minimum_size = Vector2(0, 120)
	vbox.add_child(narrative_label)

	# Tap hint
	tap_hint_label = Label.new()
	tap_hint_label.name = "TapHint"
	tap_hint_label.text = "▼ Click to continue..."
	tap_hint_label.add_theme_font_size_override("font_size", 14)
	tap_hint_label.add_theme_color_override("font_color", Color(0.6, 0.6, 0.65, 0.7))
	tap_hint_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(tap_hint_label)

	# Choices container (hidden initially)
	choices_container = VBoxContainer.new()
	choices_container.name = "ChoicesContainer"
	choices_container.add_theme_constant_override("separation", 10)
	choices_container.hide()
	vbox.add_child(choices_container)

	var choice_style_normal := StyleBoxFlat.new()
	choice_style_normal.bg_color = Color(0.2, 0.25, 0.35, 0.9)
	choice_style_normal.corner_radius_top_left = 8
	choice_style_normal.corner_radius_top_right = 8
	choice_style_normal.corner_radius_bottom_left = 8
	choice_style_normal.corner_radius_bottom_right = 8
	choice_style_normal.content_margin_left = 16
	choice_style_normal.content_margin_right = 16
	choice_style_normal.content_margin_top = 10
	choice_style_normal.content_margin_bottom = 10

	var choice_style_hover := StyleBoxFlat.new()
	choice_style_hover.bg_color = Color(0.3, 0.4, 0.55, 0.95)
	choice_style_hover.corner_radius_top_left = 8
	choice_style_hover.corner_radius_top_right = 8
	choice_style_hover.corner_radius_bottom_left = 8
	choice_style_hover.corner_radius_bottom_right = 8
	choice_style_hover.content_margin_left = 16
	choice_style_hover.content_margin_right = 16
	choice_style_hover.content_margin_top = 10
	choice_style_hover.content_margin_bottom = 10

	choice_a_button = _create_choice_button("A", choice_style_normal, choice_style_hover)
	choice_b_button = _create_choice_button("B", choice_style_normal, choice_style_hover)
	choice_c_button = _create_choice_button("C", choice_style_normal, choice_style_hover)
	choices_container.add_child(choice_a_button)
	choices_container.add_child(choice_b_button)
	choices_container.add_child(choice_c_button)

	# Outcome text (hidden initially)
	outcome_label = Label.new()
	outcome_label.name = "OutcomeLabel"
	outcome_label.add_theme_font_size_override("font_size", 20)
	outcome_label.add_theme_color_override("font_color", Color(0.9, 0.9, 0.92))
	outcome_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	outcome_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	outcome_label.custom_minimum_size = Vector2(0, 80)
	outcome_label.hide()
	vbox.add_child(outcome_label)

	# Treasure display (hidden initially)
	treasure_container = VBoxContainer.new()
	treasure_container.name = "TreasureContainer"
	treasure_container.add_theme_constant_override("separation", 8)
	treasure_container.alignment = BoxContainer.ALIGNMENT_CENTER
	treasure_container.hide()
	vbox.add_child(treasure_container)

	treasure_image = TextureRect.new()
	treasure_image.name = "TreasureImage"
	treasure_image.custom_minimum_size = Vector2(200, 200)
	treasure_image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	treasure_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	treasure_image.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	treasure_image.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	treasure_container.add_child(treasure_image)

	treasure_label = Label.new()
	treasure_label.name = "TreasureLabel"
	treasure_label.add_theme_font_size_override("font_size", 22)
	treasure_label.add_theme_color_override("font_color", Color(1.0, 0.85, 0.3))
	treasure_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	treasure_container.add_child(treasure_label)

	# Continue button (hidden initially)
	continue_button = Button.new()
	continue_button.name = "ContinueButton"
	continue_button.text = "Continue"
	continue_button.custom_minimum_size = Vector2(200, 45)
	continue_button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	var btn_style := StyleBoxFlat.new()
	btn_style.bg_color = Color(0.25, 0.5, 0.35, 0.9)
	btn_style.corner_radius_top_left = 8
	btn_style.corner_radius_top_right = 8
	btn_style.corner_radius_bottom_left = 8
	btn_style.corner_radius_bottom_right = 8
	continue_button.add_theme_stylebox_override("normal", btn_style)
	continue_button.add_theme_font_size_override("font_size", 18)
	continue_button.hide()
	vbox.add_child(continue_button)


func _create_choice_button(
	key: String, normal_style: StyleBoxFlat, hover_style: StyleBoxFlat
) -> Button:
	var btn := Button.new()
	btn.name = "Choice%sButton" % key
	btn.custom_minimum_size = Vector2(0, 45)
	btn.add_theme_stylebox_override("normal", normal_style.duplicate())
	btn.add_theme_stylebox_override("hover", hover_style.duplicate())
	btn.add_theme_stylebox_override("pressed", hover_style.duplicate())
	btn.add_theme_font_size_override("font_size", 16)
	btn.add_theme_color_override("font_color", Color(0.9, 0.9, 0.95))
	btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
	return btn


# ─── Signal Connections ───────────────────────────────


func _connect_signals() -> void:
	choice_a_button.pressed.connect(_on_choice_pressed.bind("A"))
	choice_b_button.pressed.connect(_on_choice_pressed.bind("B"))
	choice_c_button.pressed.connect(_on_choice_pressed.bind("C"))
	continue_button.pressed.connect(_on_continue_pressed)


# ─── Event Flow ───────────────────────────────────────


func _start_event() -> void:
	title_label.text = str(event_data.get("title", "Event"))
	narrative_texts = event_data.get("narrative", [])
	narrative_index = 0
	narrative_finished = false
	showing_outcome = false
	showing_treasure = false

	# Setup choice button labels
	var choices: Dictionary = event_data.get("choices", {})
	_setup_choice_button(choice_a_button, choices.get("A", {}))
	_setup_choice_button(choice_b_button, choices.get("B", {}))
	_setup_choice_button(choice_c_button, choices.get("C", {}))

	# Show first narrative paragraph
	if narrative_texts.size() > 0:
		narrative_label.text = str(narrative_texts[narrative_index])
		narrative_label.show()
		tap_hint_label.show()
	else:
		narrative_finished = true
		_show_choices()


func _setup_choice_button(btn: Button, choice_data: Dictionary) -> void:
	if choice_data.is_empty():
		btn.hide()
		return
	btn.text = str(choice_data.get("label", "..."))
	btn.show()


func _advance_narrative() -> void:
	if narrative_finished:
		return

	if narrative_index < narrative_texts.size() - 1:
		narrative_index += 1
		narrative_label.text = str(narrative_texts[narrative_index])
	else:
		narrative_finished = true
		narrative_label.hide()
		tap_hint_label.hide()
		_show_choices()


func _show_choices() -> void:
	tap_hint_label.hide()
	choices_container.show()


func _on_choice_pressed(choice_key: String) -> void:
	selected_choice_key = choice_key
	choices_container.hide()

	var choices: Dictionary = event_data.get("choices", {})
	var choice: Dictionary = choices.get(choice_key, {})

	outcome_texts = choice.get("outcome_texts", [])
	outcome_index = 0
	outcome_finished = false
	showing_outcome = true

	if outcome_texts.size() > 0:
		outcome_label.text = str(outcome_texts[outcome_index])
		outcome_label.show()
		tap_hint_label.text = "▼ Click to continue..."
		tap_hint_label.show()
	else:
		_finish_outcome()


func _advance_outcome() -> void:
	if outcome_finished:
		return

	if outcome_index < outcome_texts.size() - 1:
		outcome_index += 1
		outcome_label.text = str(outcome_texts[outcome_index])
	else:
		outcome_finished = true
		_finish_outcome()


func _finish_outcome() -> void:
	tap_hint_label.hide()
	showing_outcome = false
	showing_treasure = true

	var choices: Dictionary = event_data.get("choices", {})
	var choice: Dictionary = choices.get(selected_choice_key, {})

	if choice.get("treasure_found", false):
		var treasure_name := str(choice.get("treasure_name", "Unknown Treasure"))
		treasure_label.text = "★ You found the treasure: %s ★" % treasure_name

		var image_path := str(event_data.get("treasure_image_path", ""))
		var tex: Texture2D = _load_texture(image_path)

		if tex != null:
			treasure_image.texture = tex
			treasure_image.show()
		else:
			treasure_image.hide()

		treasure_container.show()
	else:
		outcome_label.text = str(outcome_label.text) + "\n\n(No treasure found this time.)"

	continue_button.show()


func _on_continue_pressed() -> void:
	var event_id := str(event_data.get("id", ""))
	event_completed.emit(event_id, selected_choice_key)


# ─── Texture Loading ──────────────────────────────────
# Robust loader: tries Godot's import system first, then falls back
# to reading raw PNG bytes via FileAccess (works even with invalid
# .import files or unusual filesystem paths like OneDrive).


func _load_texture(image_path: String) -> Texture2D:
	if image_path == "":
		return null

	# Method 1: Godot import system
	if ResourceLoader.exists(image_path):
		var res: Variant = load(image_path)
		if res is Texture2D:
			return res

	# Method 2: Read raw bytes and try all image formats
	var file := FileAccess.open(image_path, FileAccess.READ)
	if file == null:
		print("EventPanel: FileAccess.open failed: ", image_path)
		return null

	var bytes := file.get_buffer(file.get_length())
	file.close()

	var img := Image.new()

	# Try JPEG first (generated images are actually JPEG with .png extension)
	if img.load_jpg_from_buffer(bytes) == OK:
		return ImageTexture.create_from_image(img)

	# Try PNG
	if img.load_png_from_buffer(bytes) == OK:
		return ImageTexture.create_from_image(img)

	# Try WebP
	if img.load_webp_from_buffer(bytes) == OK:
		return ImageTexture.create_from_image(img)

	print("EventPanel: All image decoders failed for: ", image_path)
	return null


# ─── Input Handling ───────────────────────────────────
# Using _input() so clicks ANYWHERE on screen advance text.
# _input() runs before GUI processing, but we only consume the click
# during narrative/outcome phases. When choices or continue button are
# visible, none of the conditions match so clicks pass through to buttons.


func _input(event: InputEvent) -> void:
	if not is_visible_in_tree():
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if not narrative_finished:
			_advance_narrative()
			get_viewport().set_input_as_handled()
		elif showing_outcome and not outcome_finished:
			_advance_outcome()
			get_viewport().set_input_as_handled()
