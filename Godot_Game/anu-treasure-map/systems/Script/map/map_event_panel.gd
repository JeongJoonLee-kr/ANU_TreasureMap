extends Panel

# Store the selected location id
# This id will be used when the player presses the Go button.
var target_location_id: String = ""
# Get references to the UI nodes inside the popup panel.
@onready var location_title: Label = $LocationTitle
@onready var description: Label = $Description
@onready var close_button: Button = $CloseButton
@onready var go_button: Button = $GoButton
@onready var travel_cost_label: Label = $TravelCostLabel


func _ready() -> void:
	# Connect the Close button signal only once.
	if not close_button.pressed.is_connected(_on_close_button_pressed):
		close_button.pressed.connect(_on_close_button_pressed)

	# Connect the Go button signal only once.
	if not go_button.pressed.is_connected(_on_go_button_pressed):
		go_button.pressed.connect(_on_go_button_pressed)


# Show the popup near the clicked location icon.
# title: location name
# desc: short description shown in the popup
# icon: the clicked icon on the map
# location_id: id used to open the location scene later
func open_popup(
	title: String,
	desc: String,
	icon: Control,
	location_id: String,
	travel_time: int,
	can_travel: bool
) -> void:
	# Update popup text content.
	location_title.text = title
	description.text = desc
	target_location_id = location_id
	show_travel_status(_build_travel_time_text(travel_time, can_travel), can_travel)

	# Show the popup first, then wait one frame
	# so the popup size can be updated correctly.
	show()
	await get_tree().process_frame

	# Get popup size, window size, and icon position/size.
	var popup_size: Vector2 = size
	var window_size: Vector2 = get_viewport_rect().size
	var icon_pos: Vector2 = icon.global_position
	var icon_size: Vector2 = icon.size

	var margin_x := 180
	var margin_y := 0
	var pos := Vector2.ZERO

	# Default position:
	# place the popup to the right of the icon,
	# with the top roughly aligned with the icon.
	pos.x = icon_pos.x + margin_x
	pos.y = icon_pos.y

	# If the popup goes outside the right edge,
	# place it on the left side of the icon instead.
	if pos.x + popup_size.x > window_size.x:
		pos.x = icon_pos.x - popup_size.x

	# If it still goes outside the left edge,
	# move it back inside the window.
	if pos.x < 0:
		pos.x = margin_x

	# If the popup goes below the bottom edge,
	# move it upward.
	if pos.y + popup_size.y > window_size.y:
		pos.y = icon_pos.y + icon_size.y - popup_size.y

	# If the popup goes above the top edge,
	# move it back down.
	if pos.y < 0:
		pos.y = margin_y

	# Apply the final popup position.
	global_position = pos


# Hide the popup and clear the saved location id.
func close_popup() -> void:
	hide()
	target_location_id = ""


# Called when the Close button is pressed.
func _on_close_button_pressed() -> void:
	close_popup()


# Called when the Go button is pressed.
# Save the location id globally and switch to the shared location scene.
func _on_go_button_pressed() -> void:
	if target_location_id != "":
		var map_control = get_parent()
		if map_control != null and map_control.has_method("try_move_to_location"):
			map_control.try_move_to_location(target_location_id)


func show_travel_status(status_text: String, can_travel: bool) -> void:
	travel_cost_label.text = status_text
	travel_cost_label.modulate = Color(1, 1, 1, 1) if can_travel else Color(1, 0.4, 0.4, 1)
	go_button.disabled = not can_travel


func _build_travel_time_text(travel_time: int, can_travel: bool) -> String:
	if travel_time < 0:
		return "Travel Time: Unreachable"

	if can_travel:
		return "Travel Time: %d" % travel_time

	return "Travel Time: %d (Not enough)" % travel_time
