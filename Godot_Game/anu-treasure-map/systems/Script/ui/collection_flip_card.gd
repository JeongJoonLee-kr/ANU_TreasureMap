extends Control

## Decorative frame on the front (e.g. card_front_*.svg).
@export var front_border_texture: Texture2D
## Optional collectible image in the dashed area; hidden if unset.
@export var item_texture: Texture2D
## Shown only on the card art: centered on the short gold line under the portrait (same coords as SVG rect y=228).
@export var treasure_name: String = ""

@export var flip_half_duration: float = 0.2

@onready var flip_pivot: Control = $FlipPivot
@onready var front_face: Control = $FlipPivot/FrontFace
@onready var back_face: Control = $FlipPivot/BackFace
@onready var front_border: TextureRect = $FlipPivot/FrontFace/CardAspect/CardArt/Border
@onready var item_image: TextureRect = $FlipPivot/FrontFace/CardAspect/CardArt/ItemImage
@onready var treasure_name_label: Label = $FlipPivot/FrontFace/CardAspect/CardArt/TreasureName

var _showing_back: bool = false
var _flipping: bool = false


func _ready() -> void:
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


## Call when binding data at runtime (resets to front side).
func set_entry(frame: Texture2D, icon: Texture2D, name: String = "") -> void:
	front_border_texture = frame
	item_texture = icon
	treasure_name = name
	_showing_back = false
	if is_node_ready():
		_apply_exports()
		if front_face:
			front_face.show()
		if back_face:
			back_face.hide()
		flip_pivot.scale.x = 1.0
