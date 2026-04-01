extends PanelContainer

@onready var avatar_img = $MarginContainer/VBoxContainer/HBoxContainer/Profile
@onready var name_label = $MarginContainer/VBoxContainer/HBoxContainer/Name
@onready var post_text = $MarginContainer/VBoxContainer/PostText 
@onready var post_image = $MarginContainer/VBoxContainer/Image 
@onready var annotation_box = $MarginContainer/VBoxContainer/AnnotationBox 
@onready var annotation_text = $MarginContainer/VBoxContainer/AnnotationBox/MarginContainer/AnnotationText

var current_image_action: Dictionary = {}
var original_image_pos: Vector2
var current_annotations: Dictionary = {}
var my_post_id: String = ""

# Tooltip Logic
var custom_tooltip_node: Label = null
var is_hovering_actual_image: bool = false
var tooltip_timer: SceneTreeTimer = null

func _ready() -> void:
	annotation_box.hide()
	annotation_box.modulate.a = 0.0
	post_text.meta_clicked.connect(_on_post_text_meta_clicked)
	
	post_image.mouse_filter = Control.MOUSE_FILTER_STOP
	post_image.gui_input.connect(_on_post_image_gui_input)
	post_image.mouse_exited.connect(_on_post_image_mouse_exited)

# Setup post data from JSON
func setup_post(data: Dictionary, characters_data: Dictionary = {}) -> void:
	my_post_id = data.get("post_id", "")
	var author_id = data.get("author", "Unknown")
	var author_info = characters_data.get(author_id, {})
	
	name_label.text = author_info.get("name", author_id)
	_load_texture(avatar_img, author_info.get("avatar_path", ""))
	
	post_text.text = data.get("text", "")
	_load_texture(post_image, data.get("image_path", ""))
	original_image_pos = post_image.position
	
	current_image_action = data.get("image_action", {})
	if not current_image_action.is_empty():
		post_image.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	else:
		post_image.mouse_default_cursor_shape = Control.CURSOR_ARROW
		
	current_annotations = data.get("annotations", {})

	for clue_id in current_annotations.keys():
		if not clue_id in Global.unlocked_clues:
			Global.unlocked_clues.append(clue_id)
			Global.clue_discovered.emit(clue_id)

func _load_texture(target_node: Node, path: String) -> void:
	if target_node and path != "" and ResourceLoader.exists(path):
		target_node.texture = load(path)
		target_node.show()
	elif target_node:
		target_node.hide()

func _on_post_text_meta_clicked(meta: Variant) -> void:
	var keyword = str(meta)
	if current_annotations.has(keyword):
		_reveal_annotation(current_annotations[keyword])

func _reveal_annotation(text_content: String) -> void:
	if annotation_box.visible and annotation_text.text == text_content:
		return
	annotation_text.text = text_content
	if annotation_box.has_meta("active_tween"):
		var t = annotation_box.get_meta("active_tween")
		if t and t.is_valid(): t.kill()
	var tween = create_tween().set_parallel(true)
	annotation_box.set_meta("active_tween", tween)
	if not annotation_box.visible:
		annotation_box.modulate.a = 0.0
		annotation_box.scale = Vector2(0.95, 0.8) 
		annotation_box.pivot_offset = annotation_box.size / 2.0
		annotation_box.show()
		tween.tween_property(annotation_box, "scale", Vector2(1.0, 1.0), 0.35).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	annotation_text.modulate.a = 0.0
	tween.tween_property(annotation_text, "modulate:a", 1.0, 0.15).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(annotation_box, "modulate:a", 1.0, 0.15).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

# ==========================================
# Optimized Hover & Tooltip Logic
# ==========================================

func _on_post_image_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var over_image = _is_mouse_on_real_texture()
		
		# CASE 1: Entering the actual image pixels
		if over_image and not is_hovering_actual_image:
			is_hovering_actual_image = true
			_trigger_visual_hover(true)
			_start_tooltip_timer()
				
		# CASE 2: Moving WHILE inside the image (Real UX: Hide tooltip on move!)
		elif over_image and is_hovering_actual_image:
			if is_instance_valid(custom_tooltip_node):
				_stop_tooltip_logic() # Mouse moved, kill the existing tooltip
			_start_tooltip_timer() # Reset the timer to wait for the mouse to stop again
			
		# CASE 3: Leaving the pixels for empty space
		elif not over_image and is_hovering_actual_image:
			is_hovering_actual_image = false
			_trigger_visual_hover(false)
			_stop_tooltip_logic()

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if is_hovering_actual_image and not current_image_action.is_empty():
			_stop_tooltip_logic() # Click also hides tooltip
			print("TODO: Image Action triggered!")

func _on_post_image_mouse_exited() -> void:
	if is_hovering_actual_image:
		is_hovering_actual_image = false
		_trigger_visual_hover(false)
		_stop_tooltip_logic()

func _is_mouse_on_real_texture() -> bool:
	if not post_image.texture: return false
	var mouse_pos = post_image.get_local_mouse_position()
	var scale_factor = post_image.size.y / float(post_image.texture.get_height())
	var real_width = post_image.texture.get_width() * scale_factor
	return mouse_pos.x >= 0 and mouse_pos.x <= real_width and mouse_pos.y >= 0 and mouse_pos.y <= post_image.size.y

# --- Timing & Control ---

func _start_tooltip_timer() -> void:
	# If we already have a timer waiting, we don't need to do anything 
	# unless the mouse moved (which is handled in gui_input)
	if current_image_action.has("tooltip"):
		# Using a simple counter or checking if timer exists
		tooltip_timer = get_tree().create_timer(0.7) 
		tooltip_timer.timeout.connect(_show_tooltip)

func _stop_tooltip_logic() -> void:
	# Kill both the timer and the existing node
	tooltip_timer = null
	if is_instance_valid(custom_tooltip_node):
		custom_tooltip_node.queue_free()

func _trigger_visual_hover(active: bool) -> void:
	var tween = create_tween().set_parallel(true)
	var target_scale = Vector2(1.02, 1.02) if active else Vector2(1.0, 1.0)
	var target_color = Color(1.1, 1.2, 1.4, 1.0) if active else Color.WHITE
	tween.tween_property(post_image, "scale", target_scale, 0.2).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(post_image, "modulate", target_color, 0.2)

# --- Tooltip Generation ---

func _show_tooltip() -> void:
	if not is_hovering_actual_image or is_instance_valid(custom_tooltip_node): return
	
	custom_tooltip_node = Label.new()
	custom_tooltip_node.text = current_image_action["tooltip"]
	custom_tooltip_node.top_level = true
	
	# Font & Color
	var custom_font = load("res://resources/font/Literata-Regular.ttf")
	if custom_font: custom_tooltip_node.add_theme_font_override("font", custom_font)
	custom_tooltip_node.add_theme_font_size_override("font_size", 10)
	
	custom_tooltip_node.add_theme_color_override("font_color", Color(0.2, 0.2, 0.2))
	
	# Style Setup
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.95, 0.95, 0.96, 0.92)
	style.content_margin_left = 10
	style.content_margin_right = 10
	style.content_margin_top = 6
	style.content_margin_bottom = 6
	
	style.border_width_left = 1
	style.border_width_top = 1
	style.border_width_right = 1
	style.border_width_bottom = 1
	style.border_color = Color(0.8, 0.8, 0.85, 0.4)
	
	style.shadow_color = Color(0, 0, 0, 0.05)
	style.shadow_size = 4
	style.shadow_offset = Vector2(2, 2)
	
	custom_tooltip_node.add_theme_stylebox_override("normal", style)
	add_child(custom_tooltip_node)
	
	custom_tooltip_node.global_position = get_global_mouse_position() + Vector2(18, 18)

	custom_tooltip_node.modulate.a = 0
	create_tween().tween_property(custom_tooltip_node, "modulate:a", 1.0, 0.1)
