extends Panel


# Store the selected location id.
# This id will be used when the player presses the Go button.
var target_location_id: String = ""
# Get references to the UI nodes inside the popup panel.
@onready var location_title: Label = $LocationTitle
@onready var description: Label = $Description
@onready var close_button: Button = $CloseButton
@onready var go_button: Button = $GoButton


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
func open_popup(title: String, desc: String, icon: Control, location_id: String) -> void:
	# Update popup text content.
	location_title.text = title
	description.text = desc
	target_location_id = location_id

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
		Global.current_location_id = target_location_id
		get_tree().change_scene_to_file("res://locations.tscn")
