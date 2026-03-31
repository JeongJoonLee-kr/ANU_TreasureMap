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
	
	# 1. 拿到作者 ID（比如 "ALEX"）
	var author_id = data.get("author", "Unknown")
	
	# 2. 去角色字典里查这个作者的信息，查不到就给个空字典
	var author_info = characters_data.get(author_id, {})
	
	# 3. 设置名字和头像（从 author_info 里拿）
	# 如果 characters.json 里没配 name，就默认显示 ID
	name_label.text = author_info.get("name", author_id)
	_load_texture(avatar_img, author_info.get("avatar_path", ""))
	
	# 4. 设置帖子正文和配图（从帖子的 data 里拿）
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
	
	# 如果注释框本来就是可见的，就不重复播放动画了
	if annotation_box.visible: 
		return
		
	# 先把透明度设为 0（完全透明），然后再显示。
	# 这样做的效果是：UI 会在一瞬间把空间撑开，但玩家由于透明度是0，此时看不见它
	annotation_box.modulate.a = 0.0
	annotation_box.show()
	
	# 使用 Tween 动画，在 0.3 秒内把透明度从 0 渐变到 1
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(annotation_box, "modulate:a", 1.0, 0.3)
