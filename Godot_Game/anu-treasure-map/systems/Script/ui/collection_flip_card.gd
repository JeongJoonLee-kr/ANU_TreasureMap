extends Control

## Decorative frame on the front (e.g. card_front_*.svg).
@export var front_border_texture: Texture2D
## Optional collectible image in the dashed area; hidden if unset.
@export var item_texture: Texture2D
## Shown only on the card art: centered on the short gold line under the portrait (same coords as SVG rect y=228).
@export var treasure_name: String = ""
@export_multiline var treasure_description: String = ""

@export var flip_half_duration: float = 0.2

@onready var flip_pivot: Control = $FlipPivot
@onready var front_face: Control = $FlipPivot/FrontFace
@onready var back_face: Control = $FlipPivot/BackFace
@onready var front_border: TextureRect = $FlipPivot/FrontFace/CardAspect/CardArt/Border
@onready var item_image: TextureRect = $FlipPivot/FrontFace/CardAspect/CardArt/ItemImage
@onready var treasure_name_label: Label = $FlipPivot/FrontFace/CardAspect/CardArt/TreasureName
@onready var back_description_label: Label = null

var _showing_back: bool = false
var _flipping: bool = false


func _ready() -> void:
	_ensure_back_description_label()
	_apply_exports()
	_update_pivot()


func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		_update_pivot()


func _apply_exports() -> void:
	if front_border_texture and front_border:
		front_border.texture = front_border_texture
	if item_texture and item_image:
		item_image.texture = item_texture
		item_image.visible = true
	elif item_image:
		item_image.visible = false
	if treasure_name_label:
		var trimmed := treasure_name.strip_edges()
		treasure_name_label.text = trimmed
		treasure_name_label.visible = trimmed.length() > 0
	if back_description_label:
		var description := treasure_description.strip_edges()
		back_description_label.text = description
		back_description_label.visible = description.length() > 0


func _update_pivot() -> void:
	if flip_pivot == null:
		return
	flip_pivot.pivot_offset = flip_pivot.size * 0.5


func _gui_input(event: InputEvent) -> void:
	if _flipping:
		return
	if event is InputEventMouseButton:
		var mb := event as InputEventMouseButton
		if mb.pressed and mb.button_index == MOUSE_BUTTON_LEFT:
			accept_event()
			_flip()


func _flip() -> void:
	_flipping = true
	var tw := create_tween()
	(
		tw
		. tween_property(flip_pivot, "scale:x", 0.0, flip_half_duration)
		. set_trans(Tween.TRANS_SINE)
		. set_ease(Tween.EASE_IN)
	)
	tw.tween_callback(_swap_faces)
	(
		tw
		. tween_property(flip_pivot, "scale:x", 1.0, flip_half_duration)
		. set_trans(Tween.TRANS_SINE)
		. set_ease(Tween.EASE_OUT)
	)
	tw.tween_callback(func(): _flipping = false)


func _swap_faces() -> void:
	_showing_back = not _showing_back
	front_face.visible = not _showing_back
	back_face.visible = _showing_back


func _ensure_back_description_label() -> void:
	if back_face == null:
		return
	back_description_label = back_face.get_node_or_null("DescriptionMargin/Description") as Label
	if back_description_label != null:
		return

	var margin := MarginContainer.new()
	margin.name = "DescriptionMargin"
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	margin.add_theme_constant_override("margin_left", 12)
	margin.add_theme_constant_override("margin_right", 12)
	margin.add_theme_constant_override("margin_top", 16)
	margin.add_theme_constant_override("margin_bottom", 16)
	back_face.add_child(margin)

	back_description_label = Label.new()
	back_description_label.name = "Description"
	back_description_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	back_description_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	back_description_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	back_description_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	back_description_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	back_description_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	back_description_label.add_theme_font_size_override("font_size", 9)
	back_description_label.add_theme_color_override("font_color", Color(0.34, 0.25, 0.16, 1.0))
	margin.add_child(back_description_label)


## Call when binding data at runtime (resets to front side).
func set_entry(
	frame: Texture2D, icon: Texture2D, entry_name: String = "", description: String = ""
) -> void:
	front_border_texture = frame
	item_texture = icon
	treasure_name = entry_name
	treasure_description = description
	_showing_back = false
	if is_node_ready():
		_ensure_back_description_label()
		_apply_exports()
		if front_face:
			front_face.show()
		if back_face:
			back_face.hide()
		flip_pivot.scale.x = 1.0
