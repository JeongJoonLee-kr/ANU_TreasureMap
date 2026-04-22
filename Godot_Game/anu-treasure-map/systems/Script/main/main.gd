extends Node2D

const LOCATIONS_SCENE = preload("res://locations.tscn")
const INS_SCENE = preload("res://ins.tscn")
const INVESTIGATOR_CARD_SCENE = preload("res://investigator_card.tscn")

@onready var map_instance: Node2D = $Map
@onready var week_label: Label = $HUD/Topbar/WeekLabel
@onready var location_label: Label = $HUD/Topbar/LocationLabel
@onready var time_label: Label = $HUD/Topbar/TimeLabel
@onready var money_label: Label = $HUD/Topbar/MoneyLabel
@onready var ins_button: TextureButton = $HUD/MarginContainer/InsButton
@onready var next_week_button: Button = $HUD/NextWeekButton

var location_instance: Node = null
var location_data: Dictionary = {}


func _ready() -> void:
	if not Global.resources_changed.is_connected(_on_resources_changed):
		Global.resources_changed.connect(_on_resources_changed)
	if not next_week_button.pressed.is_connected(_on_next_week_button_pressed):
		next_week_button.pressed.connect(_on_next_week_button_pressed)
	initialize_progress_state()
	load_location_data()
	show_map()
	update_resource_ui()
	call_deferred("_start_first_time_registration_if_needed")


func show_map() -> void:
	if is_instance_valid(location_instance):
		location_instance.queue_free()
		location_instance = null

	map_instance.show()
	ins_button.show()
	next_week_button.show()
	var map_controller := get_map_controller()
	if map_controller != null and map_controller.has_method("update_current_location_marker"):
		map_controller.update_current_location_marker()
	update_resource_ui()


func show_location(location_id: String = "") -> void:
	if location_id != "":
		Global.selected_location_id = location_id

	if is_instance_valid(map_instance):
		map_instance.hide()

	if is_instance_valid(location_instance):
		location_instance.queue_free()

	location_instance = LOCATIONS_SCENE.instantiate()
	add_child(location_instance)
	ins_button.hide()
	next_week_button.hide()
	update_resource_ui()


func open_ins() -> Node:
	var existing_ins := get_node_or_null("Ins")
	if existing_ins != null:
		return existing_ins

	var ins_instance = INS_SCENE.instantiate()
	if ins_instance is CanvasLayer:
		ins_instance.layer = 2
	add_child(ins_instance)
	return ins_instance


func open_profile(force_first_time_setup: bool = false, opened_from_phone: bool = false) -> Node:
	var existing_layer := get_node_or_null("ProfileCardLayer")
	if existing_layer != null:
		return existing_layer

	var requires_registration := force_first_time_setup or not is_player_registered()
	var top_canvas := CanvasLayer.new()
	top_canvas.name = "ProfileCardLayer"
	top_canvas.layer = 100

	var card_instance = INVESTIGATOR_CARD_SCENE.instantiate()
	card_instance.is_opened_from_phone = opened_from_phone
	card_instance.is_first_time_setup = requires_registration
	card_instance.open_read_only_panel = not requires_registration

	top_canvas.add_child(card_instance)
	add_child(top_canvas)
	return top_canvas


func set_player_location(location_id: String) -> void:
	var normalized_id := Global.normalize_location_id(location_id)
	Global.current_location_id = normalized_id
	Global.selected_location_id = normalized_id
	Global.player_location_id = normalized_id

	var map_controller := get_map_controller()
	if map_controller != null and map_controller.has_method("update_current_location_marker"):
		map_controller.update_current_location_marker()

	update_resource_ui()


func update_resource_ui() -> void:
	week_label.text = "Week: " + Global.current_week_tag
	location_label.text = "Location: " + get_current_location_title()
	time_label.text = "Time: " + str(Global.time)
	money_label.text = "Money: $" + str(Global.money)
	next_week_button.disabled = Global.current_week >= Global.max_week
	next_week_button.text = "Max Week" if next_week_button.disabled else "Next Week"


func _on_resources_changed(_time_value: int, _money_value: int) -> void:
	update_resource_ui()


func spend_time(amount: int) -> bool:
	if amount <= 0:
		return true

	if Global.time < amount:
		return false

	Global.time -= amount
	if Global.time <= 0:
		advance_week()

	Global.notify_resources_changed()
	return true


func advance_week() -> void:
	if Global.current_week >= Global.max_week:
		return

	Global.current_week += 1
	Global.refresh_week_tag()
	Global.time = Global.max_time_per_week


func initialize_progress_state() -> void:
	if Global.max_time_per_week <= 0:
		Global.max_time_per_week = 8

	if Global.max_week <= 0:
		Global.max_week = 16

	if Global.current_week <= 0:
		Global.current_week = 1
	elif Global.current_week > Global.max_week:
		Global.current_week = Global.max_week

	Global.refresh_week_tag()

	if Global.time <= 0:
		Global.time = Global.max_time_per_week


func load_location_data() -> void:
	var file := FileAccess.open("res://data/locations.json", FileAccess.READ)
	if file == null:
		push_error("Failed to open locations.json in Main.")
		return

	var parsed: Variant = JSON.parse_string(file.get_as_text())
	file.close()
	if parsed is Dictionary:
		location_data = parsed
	else:
		push_error("Failed to parse locations.json in Main.")


func get_current_location_title() -> String:
	var location_id := Global.selected_location_id
	if is_instance_valid(map_instance) and map_instance.visible:
		location_id = (
			Global.player_location_id
			if Global.player_location_id != ""
			else Global.current_location_id
		)
	elif location_id == "":
		location_id = Global.current_location_id

	if location_id == "":
		return "-"

	var data = location_data.get(location_id, {})
	if data is Dictionary:
		return data.get("title", location_id)
	return location_id


func get_map_controller() -> Node:
	if not is_instance_valid(map_instance):
		return null

	return map_instance.get_node_or_null("MapControl")


func _on_next_week_button_pressed() -> void:
	if Global.current_week >= Global.max_week:
		update_resource_ui()
		return

	advance_week()
	Global.notify_resources_changed()


func is_player_registered() -> bool:
	return (
		str(Global.player_data.get("major", "")) != ""
		and str(Global.player_data.get("homebase", "")) != ""
	)


func _start_first_time_registration_if_needed() -> void:
	if is_player_registered():
		return

	open_ins()
	get_tree().create_timer(0.15).timeout.connect(func(): open_profile(true, true))
