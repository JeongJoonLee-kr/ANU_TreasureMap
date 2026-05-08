extends Node

const GuideCharacterScript = preload("res://systems/Script/ui/guide_character.gd")

var _guide: GuideCharacter = null


func show(text: String) -> void:
	_ensure_guide()
	if _guide:
		_guide.show_tutorial(text)


func hide_guide() -> void:
	if _guide and is_instance_valid(_guide):
		_guide.hide_tutorial()


func is_showing() -> bool:
	return _guide != null and is_instance_valid(_guide) and _guide.visible


func set_bear_position(pos: Vector2) -> void:
	_ensure_guide()
	if _guide:
		_guide.set_bear_position(pos)


func _ensure_guide() -> void:
	if _guide == null or not is_instance_valid(_guide):
		_guide = GuideCharacterScript.new()
		_guide.name = "GuideCharacter"
		get_tree().root.add_child(_guide)
	elif not _guide.is_inside_tree():
		get_tree().root.add_child(_guide)
