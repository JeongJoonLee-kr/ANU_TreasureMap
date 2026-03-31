extends TextureButton

# 4 status 
var normal_color = Color(1.0, 1.0, 1.0, 1.0)
var hover_color = Color(0.85, 0.85, 0.85, 1.0) 
var pressed_color = Color(0.6, 0.6, 0.6, 1.0) 
var disabled_color = Color(0.4, 0.4, 0.4, 1.0)

func _ready() -> void:
	pivot_offset = size / 2.0
	item_rect_changed.connect(func(): pivot_offset = size / 2.0)
	
	self_modulate = normal_color
	
	button_down.connect(_on_button_down)
	button_up.connect(_on_button_up)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	# trans
	pressed.connect(_on_pressed)

# 1. click
func _on_button_down() -> void:
	if disabled: return
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "self_modulate", pressed_color, 0.1)
	tween.tween_property(self, "scale", Vector2(0.95, 0.95), 0.1).set_trans(Tween.TRANS_CUBIC)

# 2. unclick
func _on_button_up() -> void:
	if disabled: return
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "self_modulate", hover_color, 0.2)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

# 3. hover
func _on_mouse_entered() -> void:
	if disabled: return
	var tween = create_tween()
	tween.tween_property(self, "self_modulate", hover_color, 0.2)

# 4. leave
func _on_mouse_exited() -> void:
	if disabled: return
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "self_modulate", normal_color, 0.2)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.2) 

func _on_pressed() -> void:
	if disabled: return
	
	await get_tree().create_timer(0.15).timeout
	
	get_tree().change_scene_to_file("res://ins.tscn")

# 6. disabled
func _set(property: StringName, value: Variant) -> bool:
	if property == "disabled":
		if value == true:
			self_modulate = disabled_color
			scale = Vector2(1.0, 1.0)
		else:
			self_modulate = normal_color
	return false
