extends Node

const TOAST_HOLD_SECONDS := 5.0
const TREASURE_SHARE_POSTS_PATH := "res://data/treasure_share_posts.json"
const PLAYER_SHARE_AVATAR_PATH := "res://resources/icon/1-removebg-preview 1.png"

# ========== GAME STATE VARIABLES ==========
# Store the currently selected location id.
# This value is used to pass location information
# from the map scene to the shared location scene.
var current_location_id: String = "chifley_marie_reay"
var selected_location_id: String = "chifley_marie_reay"
var player_location_id: String = "chifley_marie_reay"

var stamina: int = 100
var current_week: int = 1
var current_week_tag: String = "week1"
var max_time_per_week: int = 8
var max_week: int = 16
var time: int = 8
var money: int = 50

var travel_time_per_edge: int = 1

var unlocked_clues: Array[String] = []
var unlocked_treasures: Array[String] = []

var _toast_layer: CanvasLayer = null
var _toast_panel: PanelContainer = null
var _toast_tween: Tween = null

# ========== CACHED DATA ==========
# Loaded once in _ready(), consumed by ins.gd etc.
var characters_data: Dictionary = {}
var base_posts_data: Array = []
var shared_treasure_records: Array = []
var posts_data: Array = []
var treasure_share_posts_data: Dictionary = {}

# ========== PLAYER DYNAMIC DATA ==========
var player_data = {"name": "Unknown", "major": "", "homebase": ""}

# ========== SAVE FILE CONFIGURATION ==========
# user:// is the designated folder on the player's OS for save files
const SAVE_PATH: String = "user://player_save.json"

@warning_ignore("UNUSED_SIGNAL")  # emitted from post_item.gd
signal clue_discovered(clue_id: String)
signal treasure_discovered(treasure_id: String)
signal resources_changed(time_value: int, money_value: int)


func _ready() -> void:
	_load_characters()
	_load_posts()
	_load_treasure_share_posts()
	normalize_legacy_ids()


func notify_resources_changed() -> void:
	resources_changed.emit(time, money)


func unlock_clue(clue_id: String, clue_name: String = "") -> bool:
	var normalized_id := clue_id.strip_edges()
	if normalized_id == "":
		return false
	if unlocked_clues.has(normalized_id):
		return false

	unlocked_clues.append(normalized_id)
	clue_discovered.emit(normalized_id)
	show_toast("Clue obtained", clue_name if clue_name != "" else normalized_id)
	return true


func unlock_treasure(treasure_id: String, treasure_name: String = "") -> bool:
	var normalized_id := treasure_id.strip_edges()
	if normalized_id == "":
		return false
	if unlocked_treasures.has(normalized_id):
		return false

	unlocked_treasures.append(normalized_id)
	treasure_discovered.emit(normalized_id)
	show_toast("Treasure obtained", treasure_name if treasure_name != "" else normalized_id)
	return true


func share_treasure_post(
	treasure_id: String, treasure_name: String = "", image_path: String = ""
) -> bool:
	var normalized_id := treasure_id.strip_edges()
	if normalized_id == "":
		return false
	if _has_shared_treasure_post(normalized_id):
		return false

	var template: Dictionary = treasure_share_posts_data.get(normalized_id, {})
	if template.is_empty():
		push_warning("No treasure share post template for %s" % normalized_id)
		return false

	var display_name := treasure_name if treasure_name.strip_edges() != "" else normalized_id
	var player_name := str(player_data.get("name", "Unknown")).strip_edges()
	if player_name == "":
		player_name = "Unknown"

	var record := {
		"treasure_id": normalized_id,
		"author_name": player_name,
		"image_path": str(template.get("image_path", image_path))
	}
	shared_treasure_records.push_front(record)
	_rebuild_posts_data()
	show_toast("Treasure shared", display_name)
	return true


func show_toast(title: String, detail: String = "") -> void:
	_ensure_toast_panel()
	if _toast_panel == null:
		return

	var title_label := _toast_panel.get_node("Margin/Rows/Title") as Label
	var detail_label := _toast_panel.get_node("Margin/Rows/Detail") as Label
	title_label.text = title
	detail_label.text = detail
	detail_label.visible = detail.strip_edges() != ""

	_layout_toast()
	_toast_panel.show()
	_toast_panel.modulate.a = 0.0
	_toast_panel.position.x += 18.0

	if _toast_tween != null and _toast_tween.is_valid():
		_toast_tween.kill()
	_toast_tween = create_tween()
	_toast_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	_toast_tween.tween_property(_toast_panel, "modulate:a", 1.0, 0.16)
	_toast_tween.parallel().tween_property(
		_toast_panel, "position:x", _toast_panel.position.x - 18.0, 0.16
	)
	_toast_tween.tween_interval(TOAST_HOLD_SECONDS)
	_toast_tween.set_ease(Tween.EASE_IN)
	_toast_tween.tween_property(_toast_panel, "modulate:a", 0.0, 0.22)
	_toast_tween.tween_callback(_toast_panel.hide)


func _ensure_toast_panel() -> void:
	if is_instance_valid(_toast_panel):
		return

	if not is_instance_valid(_toast_layer):
		_toast_layer = CanvasLayer.new()
		_toast_layer.name = "ToastLayer"
		_toast_layer.layer = 200
		add_child(_toast_layer)

	var root := Control.new()
	root.name = "ToastRoot"
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_toast_layer.add_child(root)

	_toast_panel = PanelContainer.new()
	_toast_panel.name = "ToastPanel"
	_toast_panel.custom_minimum_size = Vector2(420, 64)
	_toast_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_toast_panel.add_theme_stylebox_override("panel", _make_toast_style())
	_toast_panel.hide()
	root.add_child(_toast_panel)

	var margin := MarginContainer.new()
	margin.name = "Margin"
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_top", 10)
	margin.add_theme_constant_override("margin_bottom", 10)
	_toast_panel.add_child(margin)

	var rows := VBoxContainer.new()
	rows.name = "Rows"
	rows.add_theme_constant_override("separation", 1)
	margin.add_child(rows)

	var title_label := Label.new()
	title_label.name = "Title"
	title_label.add_theme_font_size_override("font_size", 16)
	title_label.add_theme_color_override("font_color", Color(0.13, 0.43, 0.73, 1.0))
	rows.add_child(title_label)

	var detail_label := Label.new()
	detail_label.name = "Detail"
	detail_label.add_theme_font_size_override("font_size", 14)
	detail_label.add_theme_color_override("font_color", Color(0.34, 0.39, 0.5, 1.0))
	detail_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	rows.add_child(detail_label)

	get_viewport().size_changed.connect(_layout_toast)


func _layout_toast() -> void:
	if not is_instance_valid(_toast_panel):
		return
	var viewport_size := get_viewport().get_visible_rect().size
	var panel_size := Vector2(420, 64)
	_toast_panel.size = panel_size
	_toast_panel.position = Vector2(viewport_size.x - panel_size.x - 30.0, 110.0)


func _make_toast_style() -> StyleBoxFlat:
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


func refresh_week_tag() -> void:
	current_week_tag = "week%d" % current_week


func normalize_location_id(location_id: String) -> String:
	match location_id:
		"lab_cafe":
			return "chifley_marie_reay"
		"lake", "griffin_lake":
			return "lodges"
		_:
			return location_id


func normalize_legacy_ids() -> void:
	current_location_id = normalize_location_id(current_location_id)
	selected_location_id = normalize_location_id(selected_location_id)
	player_location_id = normalize_location_id(player_location_id)

	var homebase := str(player_data.get("homebase", ""))
	player_data["homebase"] = normalize_location_id(homebase)


# ========== DATA LOADING METHODS ==========
func _load_characters() -> void:
	var file = FileAccess.open("res://data/characters.json", FileAccess.READ)
	if file:
		var parsed = JSON.parse_string(file.get_as_text())
		if typeof(parsed) == TYPE_DICTIONARY:
			characters_data = parsed


func _load_posts() -> void:
	var file = FileAccess.open("res://data/ins_posts.json", FileAccess.READ)
	if file:
		var json = JSON.new()
		var json_text := file.get_as_text()
		file.close()
		if json.parse(json_text) == OK:
			if typeof(json.data) == TYPE_ARRAY:
				base_posts_data = json.data
	_rebuild_posts_data()


func _load_treasure_share_posts() -> void:
	var file := FileAccess.open(TREASURE_SHARE_POSTS_PATH, FileAccess.READ)
	if file == null:
		push_warning("Could not open %s" % TREASURE_SHARE_POSTS_PATH)
		return

	var parsed: Variant = JSON.parse_string(file.get_as_text())
	file.close()
	if parsed is Dictionary:
		treasure_share_posts_data = parsed as Dictionary
	else:
		push_warning("Could not parse %s" % TREASURE_SHARE_POSTS_PATH)


func _rebuild_posts_data() -> void:
	posts_data.clear()
	for record in shared_treasure_records:
		if record is Dictionary:
			var shared_post := _make_shared_treasure_post(record as Dictionary)
			if not shared_post.is_empty():
				posts_data.append(shared_post)
	for post in base_posts_data:
		if post is Dictionary:
			posts_data.append((post as Dictionary).duplicate(true))


func _make_shared_treasure_post(record: Dictionary) -> Dictionary:
	var treasure_id := str(record.get("treasure_id", record.get("shared_treasure_id", "")))
	if treasure_id == "":
		return {}

	var template: Dictionary = treasure_share_posts_data.get(treasure_id, {})
	if template.is_empty():
		return {}

	var image_path := str(record.get("image_path", template.get("image_path", "")))
	var post := {
		"post_id": "shared_treasure_%s" % treasure_id,
		"author_name": str(record.get("author_name", "Unknown")),
		"avatar_path": PLAYER_SHARE_AVATAR_PATH,
		"text": str(template.get("text", "")),
		"image_path": image_path,
		"shared_treasure_id": treasure_id
	}
	var annotations: Variant = template.get("annotations", {})
	if annotations is Dictionary and not (annotations as Dictionary).is_empty():
		post["annotations"] = (annotations as Dictionary).duplicate(true)
	return post


func _has_shared_treasure_post(treasure_id: String) -> bool:
	for record in shared_treasure_records:
		if not (record is Dictionary):
			continue
		var record_dict := record as Dictionary
		var record_treasure_id := str(
			record_dict.get("treasure_id", record_dict.get("shared_treasure_id", ""))
		)
		if record_treasure_id == treasure_id:
			return true
	return false


func _migrate_legacy_shared_posts(saved_shared_posts: Variant) -> void:
	shared_treasure_records.clear()
	if not (saved_shared_posts is Array):
		return

	for post in saved_shared_posts:
		if not (post is Dictionary):
			continue
		var post_dict := post as Dictionary
		var treasure_id := str(post_dict.get("shared_treasure_id", ""))
		if treasure_id == "" or _has_shared_treasure_post(treasure_id):
			continue
		shared_treasure_records.append(
			{
				"treasure_id": treasure_id,
				"author_name": str(post_dict.get("author_name", "Unknown")),
				"image_path": str(post_dict.get("image_path", ""))
			}
		)


# ========== PERSISTENCE (SAVE/LOAD) METHODS ==========
func save_game() -> void:
	# Open the file in WRITE mode
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		var event_save := {}
		if Engine.has_singleton("EventManager") or get_node_or_null("/root/EventManager") != null:
			var em = get_node_or_null("/root/EventManager")
			if em != null and em.has_method("get_save_data"):
				event_save = em.get_save_data()

		var save_data := {
			"player_data": player_data,
			"progress":
			{
				"current_location_id": current_location_id,
				"selected_location_id": selected_location_id,
				"player_location_id": player_location_id,
				"current_week": current_week,
				"current_week_tag": current_week_tag,
				"max_time_per_week": max_time_per_week,
				"max_week": max_week,
				"time": time,
				"money": money
			},
			"unlocked_clues": unlocked_clues,
			"unlocked_treasures": unlocked_treasures,
			"shared_treasure_records": shared_treasure_records,
			"event_manager": event_save
		}
		# Convert the save data dictionary into a formatted JSON string (using tabs)
		var json_string = JSON.stringify(save_data, "\t")
		file.store_string(json_string)
		file.close()
		print(
			"Game saved successfully! JSON file created at: ",
			ProjectSettings.globalize_path(SAVE_PATH)
		)
	else:
		print("Error: Could not save the game file!")


func load_game() -> void:
	# Check if the save file exists before trying to read it
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		var json_string = file.get_as_text()
		file.close()

		# Parse the JSON string back into a Dictionary
		var parsed_data = JSON.parse_string(json_string)
		if typeof(parsed_data) == TYPE_DICTIONARY:
			if parsed_data.has("player_data"):
				player_data = parsed_data.get("player_data", player_data)

			var progress = parsed_data.get("progress", {})
			if progress is Dictionary:
				current_location_id = normalize_location_id(
					str(progress.get("current_location_id", current_location_id))
				)
				selected_location_id = normalize_location_id(
					str(progress.get("selected_location_id", selected_location_id))
				)
				player_location_id = normalize_location_id(
					str(progress.get("player_location_id", player_location_id))
				)
				current_week = int(progress.get("current_week", current_week))
				current_week_tag = str(progress.get("current_week_tag", current_week_tag))
				max_time_per_week = int(progress.get("max_time_per_week", max_time_per_week))
				max_week = int(progress.get("max_week", max_week))
				time = int(progress.get("time", time))
				money = int(progress.get("money", money))
			elif parsed_data.has("name") or parsed_data.has("major") or parsed_data.has("homebase"):
				# Backward compatibility with the old save structure.
				player_data = parsed_data

			# Restore unlocked clues
			var saved_clues = parsed_data.get("unlocked_clues", [])
			if saved_clues is Array:
				unlocked_clues.clear()
				for c in saved_clues:
					if c is String:
						unlocked_clues.append(c)

			var saved_treasures = parsed_data.get("unlocked_treasures", [])
			if saved_treasures is Array:
				unlocked_treasures.clear()
				for treasure_id in saved_treasures:
					if treasure_id is String:
						unlocked_treasures.append(treasure_id)

			if parsed_data.has("shared_treasure_records"):
				var saved_shared_records = parsed_data.get("shared_treasure_records", [])
				shared_treasure_records.clear()
				if saved_shared_records is Array:
					for record in saved_shared_records:
						if record is Dictionary:
							shared_treasure_records.append((record as Dictionary).duplicate(true))
			else:
				_migrate_legacy_shared_posts(parsed_data.get("shared_posts", []))
			_rebuild_posts_data()

			# Restore EventManager state
			var event_data = parsed_data.get("event_manager", {})
			if event_data is Dictionary and not event_data.is_empty():
				var em = get_node_or_null("/root/EventManager")
				if em != null and em.has_method("load_save_data"):
					em.load_save_data(event_data)

			normalize_legacy_ids()

			if current_week_tag == "":
				refresh_week_tag()

			print("Game loaded successfully. Current player data: ", player_data)
	else:
		print("No save file found. Using default player data.")
