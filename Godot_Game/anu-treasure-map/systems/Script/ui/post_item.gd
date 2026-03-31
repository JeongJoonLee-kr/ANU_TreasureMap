extends PanelContainer

@onready var avatar_img = $MarginContainer/VBoxContainer/HBoxContainer/Profile
@onready var name_label = $MarginContainer/VBoxContainer/HBoxContainer/Name
@onready var post_text = $MarginContainer/VBoxContainer/PostText 
@onready var post_image = $MarginContainer/VBoxContainer/Image 
@onready var annotation_box = $MarginContainer/VBoxContainer/AnnotationBox 
@onready var annotation_text = $MarginContainer/VBoxContainer/AnnotationBox/MarginContainer/AnnotationText
var current_annotations: Dictionary = {}
var my_post_id: String = ""

func _ready() -> void:
	# Hide annotation box by default
	annotation_box.hide()
	annotation_box.modulate.a = 0.0
	
	# Connect RichTextLabel click signal
	post_text.meta_clicked.connect(_on_post_text_meta_clicked)

# Setup post data from JSON
func setup_post(data: Dictionary, characters_data: Dictionary = {}) -> void:
	my_post_id = data.get("post_id", "")
	
	# 1. ID
	var author_id = data.get("author", "Unknown")
	
	# 2. Look up the author's information in the character dictionary; if you can't find it, just give an empty dictionary.
	var author_info = characters_data.get(author_id, {})
	
	# 3. Name and Profile
	name_label.text = author_info.get("name", author_id)
	_load_texture(avatar_img, author_info.get("avatar_path", ""))
	
	# 4. Set the post body and images (take them from the post's data).
	post_text.text = data.get("text", "")
	_load_texture(post_image, data.get("image_path", ""))
	current_annotations = data.get("annotations", {})

	# Trigger clue discovery automatically when post is seen
	for clue_id in current_annotations.keys():
		if not clue_id in Global.unlocked_clues:
			Global.unlocked_clues.append(clue_id)
			Global.clue_discovered.emit(clue_id)
			print("Clue found automatically: ", clue_id)

func _load_texture(target_node: Node, path: String) -> void:
	if target_node and path != "" and ResourceLoader.exists(path):
		target_node.texture = load(path)
		target_node.show()
	elif target_node:
		target_node.hide()

# Click keyword to show the animation and explanation
func _on_post_text_meta_clicked(meta: Variant) -> void:
	var keyword = str(meta)
	if current_annotations.has(keyword):
		_reveal_annotation(current_annotations[keyword])

# Smoothly reveal the annotation box
func _reveal_annotation(text_content: String) -> void:
	annotation_text.text = text_content
	
	if annotation_box.visible: 
		return
		
	# First set the opacity to 0 (completely transparent), then display it.

	# The effect of this is: the UI will expand the space for a moment, but the player cannot see it because the opacity is 0.
	annotation_box.modulate.a = 0.0
	annotation_box.show()
	
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(annotation_box, "modulate:a", 1.0, 0.3)
