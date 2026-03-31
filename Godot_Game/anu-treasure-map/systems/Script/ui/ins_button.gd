extends TextureButton

# 4 status 
var normal_color = Color(1.0, 1.0, 1.0, 1.0)      # 纯白
var hover_color = Color(0.85, 0.85, 0.85, 1.0)       # 高光白 (RGB大于1会产生轻微发亮/高光感)
var pressed_color = Color(0.6, 0.6, 0.6, 1.0)     # 纯正灰色，拒绝背景穿透
var disabled_color = Color(0.4, 0.4, 0.4, 1.0)    # 更深的纯灰色

func _ready() -> void:
	pivot_offset = size / 2.0
	item_rect_changed.connect(func(): pivot_offset = size / 2.0)
	
	self_modulate = normal_color
	
	button_down.connect(_on_button_down)
	button_up.connect(_on_button_up)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

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

# 5. disabled
func _set(property: StringName, value: Variant) -> bool:
	if property == "disabled":
		if value == true:
			self_modulate = disabled_color
			scale = Vector2(1.0, 1.0)
		else:
			self_modulate = normal_color
	return false
