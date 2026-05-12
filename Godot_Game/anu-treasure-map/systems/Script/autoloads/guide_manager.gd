extends Node

const GuideCharacterScript = preload("res://systems/Script/ui/guide_character.gd")
const _GUIDE_TEXTS_PATH := "res://data/guide_texts.json"

# ── Node paths ────────────────────────────────────────────────────────────────
const _PATH_GOAL_PANEL    := "GoalPanelLayer/EndGameGoalPanel/GoalPanel"
const _PATH_BOTTOMBAR     := "HUD/Bottombar"
const _PATH_INS_BTN       := "HUD/MarginContainer/InsButton"
const _PATH_NW_BTN_BOT    := "HUD/Bottombar/NextWeekButton"
const _PATH_NW_BTN_TOP    := "HUD/Topbar/NextWeekButton"
const _PATH_APP_GRID      := "Ins/PhoneScreen/MainMargin/MainVBox/HomeScreen/AppsSlot/AppsCenter/AppGrid/"
const _PATH_PHONE_SCREEN  := "Ins/PhoneScreen"
const _PATH_MARKERS_LAYER := "Map/MapControl/MarkersLayer"
const _PATH_EVENT_PANEL   := "Map/MapControl/EventPanel"
const _PATH_TRAVEL_COST   := "Map/MapControl/EventPanel/TravelCostLabel"
const _PATH_GO_BTN        := "Map/MapControl/EventPanel/GoButton"
const _PATH_CLOSE_BTN     := "Map/MapControl/EventPanel/CloseButton"
const _PATH_INS_FEED      := "Ins/PhoneScreen/MainMargin/MainVBox/InsAppScreen/ScrollContainer/ContentVBox/FeedList"
const _PATH_PROFILE_CARD  := "ProfileCardLayer"

# All phone app buttons in the home screen grid.
const _ALL_APP_BUTTONS := [
	"AppCollectionButton", "AppInsButton", "AppMenuButton", "AppProfileButton"
]

# Fallback text used when the JSON file is absent or missing a step.
const _DEFAULT_TEXTS := {
	0: "Welcome to ANU Treasure Map!\nTap anywhere to continue.",
	1: "Explore campus and collect treasures.\nTap to continue.",
	2: "These are your End Goals!\nComplete any one of them to finish the game.\nAim to collect as many treasures as you can!",
	3: "Tap the phone icon — it's your control panel\nfor messages, profile and more!",
	4: "This is your Profile!\nTap this app to set up your personal info.",
	5: "This is the Collection Book!\nBrowse all the treasures you've discovered.\nTap anywhere to continue.",
	6: "This is the Menu.\nAdjust music or restart the game from here.\nTap anywhere to continue.",
	7: "This is ANU Ins!\nBrowse the latest campus posts.\nTap to open it and finish setup!",
	8: "You can find clues to treasures here!\nThere seems to be some key information?\nTry tapping it!",
	9: "Let's head back to the map\nand see what's happening!",
	11: "These show your Week, Time, Location, and Money.\nKeep an eye on them as you explore!",
	12: "The clue just mentioned something exciting happening here!\nLet's go check it out.",
	13: "This is the time it takes to travel here.",
	14: "Running out of time? Tap Next Week\nto move on to the next week!",
	15: "Let's go take a look!",
}

var _guide: GuideCharacter = null
var _step: int = -1
var _main_ref: Node = null
var _in_onboarding := false
var _loaded_texts := {}
var _locked_map: Node = null
var _locked_hud_buttons: Array[Control] = []
var _locked_phone_buttons: Array[Control] = []
var _locked_map_markers: Array[Control] = []
var _locked_event_panel_ctrls: Array[Control] = []

# Smart marker: location_id derived from the keyword clicked during the Ins step.
var _tracked_clue_location_id: String = ""


func _ready() -> void:
	_load_texts()


# ── Public API ────────────────────────────────────────────────────────────────


func show(text: String) -> void:
	_ensure_guide()
	if _guide:
		_guide.show_tutorial(text)


func hide_guide() -> void:
	if _guide and is_instance_valid(_guide):
		_guide.hide_tutorial()


func is_showing() -> bool:
	return _guide != null and is_instance_valid(_guide) and _guide.visible


func is_in_onboarding() -> bool:
	return _in_onboarding


func set_bear_position(pos: Vector2) -> void:
	_ensure_guide()
	if _guide:
		_guide.set_bear_position(pos)


# Immediately blocks all map input, then shows the guide after a short delay.
func start_onboarding(main_node: Node) -> void:
	_main_ref = main_node
	_in_onboarding = true
	_step = 0
	_tracked_clue_location_id = ""
	_ensure_guide()
	_guide.block_input()
	if not _guide.step_advanced.is_connected(_on_step_advanced):
		_guide.step_advanced.connect(_on_step_advanced)
	get_tree().create_timer(0.6).timeout.connect(
		func():
			if _in_onboarding:
				_run_step(0)
	)


# ── Onboarding steps ──────────────────────────────────────────────────────────


func _on_step_advanced() -> void:
	if not _in_onboarding:
		return
	_step += 1
	_run_step(_step)


func _run_step(step: int) -> void:
	_ensure_guide()
	var vp := _guide.get_viewport_rect().size

	match step:
		# ── 0–2: Welcome, explore intro, end goal ───────────────────────────
		0:
			_set_tap_advance(true)
			_guide.show_step(_get_text(0), _center_bear(vp), GuideCharacter.OVERLAY_FLAT, true)

		1:
			_set_tap_advance(true)
			_guide.show_step(_get_text(1), _center_bear(vp), GuideCharacter.OVERLAY_FLAT, true, false, true)

		2:
			_set_tap_advance(true)
			var goal_rect := _get_hud_rect(_PATH_GOAL_PANEL)
			var bear_x := (
				clampf(goal_rect.end.x + 80.0, 20.0, vp.x - GuideCharacter.BEAR_SIZE.x - 20.0)
				if goal_rect.size != Vector2.ZERO else vp.x * 0.55
			)
			var bear_y := (
				clampf(goal_rect.get_center().y - GuideCharacter.BEAR_SIZE.y * 0.5, 20.0, vp.y - GuideCharacter.BEAR_SIZE.y - 20.0)
				if goal_rect.size != Vector2.ZERO else 20.0
			)
			_guide.show_step(_get_text(2), Vector2(bear_x, bear_y), GuideCharacter.OVERLAY_SPOTLIGHT, true, false, true)
			if goal_rect.size != Vector2.ZERO:
				_guide.set_spotlight_rect(goal_rect.grow(10.0))

		# ── 3: Phone button ─────────────────────────────────────────────────
		3:
			_set_tap_advance(false)
			var phone_rect := _get_hud_rect(_PATH_INS_BTN)
			var bear_pos: Vector2
			if phone_rect.size != Vector2.ZERO:
				bear_pos = Vector2(
					clampf(phone_rect.end.x - GuideCharacter.BEAR_SIZE.x, 20.0, vp.x - GuideCharacter.BEAR_SIZE.x - 20.0),
					clampf(phone_rect.position.y - GuideCharacter.BEAR_SIZE.y - 25.0, 20.0, vp.y - GuideCharacter.BEAR_SIZE.y - 20.0)
				)
			else:
				bear_pos = Vector2(vp.x - 300.0, vp.y * 0.40 - 130.0)
			_guide.show_step(_get_text(3), bear_pos, GuideCharacter.OVERLAY_SPOTLIGHT, false, true, true)
			if phone_rect.size != Vector2.ZERO:
				_guide.set_spotlight_rect(phone_rect.grow(14.0))
			_lock_non_phone_input()
			_connect_phone_listener()

		# ── 4: Profile app ──────────────────────────────────────────────────
		4:
			_set_tap_advance(false)
			_show_phone_app_spotlight(4, "AppProfileButton", false, true)
			_lock_phone_buttons_except("AppProfileButton")
			_connect_profile_listener()

		# ── 5: Collection app ────────────────────────────────────────────────
		5:
			_set_tap_advance(true)
			_show_phone_app_spotlight(5, "AppCollectionButton", true, false)

		# ── 6: Menu app ──────────────────────────────────────────────────────
		6:
			_set_tap_advance(true)
			_show_phone_app_spotlight(6, "AppMenuButton", true, false)

		# ── 7: Ins app ───────────────────────────────────────────────────────
		7:
			_set_tap_advance(false)
			_show_phone_app_spotlight(7, "AppInsButton", false, true)
			_lock_phone_buttons_except("AppInsButton")
			_connect_ins_listener()

		# ── 8: Keywords in Ins ───────────────────────────────────────────────
		8:
			_set_tap_advance(false)
			if not _guide.step_advanced.is_connected(_on_step_8_advanced):
				_guide.step_advanced.connect(_on_step_8_advanced, CONNECT_ONE_SHOT)
			_guide.show_step(_get_text(8), _bear_pos_beside_phone(vp), GuideCharacter.OVERLAY_FLAT, true, false, false)

		# ── 9: Back to map ───────────────────────────────────────────────────
		9:
			_set_tap_advance(true)
			_guide.show_step(_get_text(9), _bear_pos_beside_phone(vp), GuideCharacter.OVERLAY_FLAT, true, false, false)

		# ── 10: Transition — close phone, then jump to map steps ─────────────
		10:
			_set_tap_advance(false)
			hide_guide()
			var ins_node := _main_ref.get_node_or_null("Ins") if _main_ref else null
			if ins_node != null and ins_node.has_method("close_phone"):
				ins_node.call("close_phone")
			get_tree().create_timer(0.8).timeout.connect(
				func():
					if _in_onboarding:
						_step = 11
						_run_step(11)
			)

		# ── 11: Combined HUD — spotlight the entire Bottombar ────────────────
		11:
			_set_tap_advance(true)
			var bar_rect := _get_hud_rect(_PATH_BOTTOMBAR)
			var bear_x := clampf(vp.x * 0.5 - GuideCharacter.BEAR_SIZE.x * 0.5, 20.0, vp.x - GuideCharacter.BEAR_SIZE.x - 20.0)
			var bear_y: float
			if bar_rect.size != Vector2.ZERO:
				bear_y = clampf(bar_rect.position.y - GuideCharacter.BEAR_SIZE.y - 30.0, 20.0, vp.y - GuideCharacter.BEAR_SIZE.y - 20.0)
			else:
				bear_y = vp.y - GuideCharacter.BEAR_SIZE.y - 80.0
			_guide.show_step(_get_text(11), Vector2(bear_x, bear_y), GuideCharacter.OVERLAY_SPOTLIGHT, true, false, true)
			if bar_rect.size != Vector2.ZERO:
				_guide.set_spotlight_rect(bar_rect.grow(8.0))
			_unlock_map_only()

		# ── 12: Smart map marker — spotlight the location from the clue ──────
		12:
			_set_tap_advance(false)
			_lock_map_markers_except(_tracked_clue_location_id if _tracked_clue_location_id != "" else "csit_engn_area")
			_lock_ins_button()
			var marker_path := _resolve_marker_path()
			var dot_rect := _get_hud_rect(marker_path + "/DotButton")
			var ref_rect := dot_rect if dot_rect.size != Vector2.ZERO else _get_hud_rect(marker_path)
			var bear_x: float
			var bear_y: float
			if ref_rect.size != Vector2.ZERO:
				var right_x := ref_rect.end.x + 20.0
				bear_x = (
					right_x if right_x + GuideCharacter.BEAR_SIZE.x < vp.x - 20.0
					else clampf(ref_rect.position.x - GuideCharacter.BEAR_SIZE.x - 20.0, 20.0, vp.x - GuideCharacter.BEAR_SIZE.x - 20.0)
				)
				bear_y = clampf(ref_rect.get_center().y - GuideCharacter.BEAR_SIZE.y * 0.5, 20.0, vp.y - GuideCharacter.BEAR_SIZE.y - 20.0)
			else:
				bear_x = vp.x * 0.6
				bear_y = vp.y * 0.35 - 130.0
			_guide.show_step(_get_text(12), Vector2(bear_x, bear_y), GuideCharacter.OVERLAY_SPOTLIGHT, false, true, true)
			if ref_rect.size != Vector2.ZERO:
				_guide.set_spotlight_rect(ref_rect.grow(18.0))
			_connect_marker_listener(marker_path)

		# ── 13: Event panel — travel cost ────────────────────────────────────
		13:
			_set_tap_advance(true)
			var panel_rect := _get_hud_rect(_PATH_EVENT_PANEL)
			var cost_rect := _get_hud_rect(_PATH_TRAVEL_COST)
			var bear_x: float
			var bear_y: float
			if panel_rect.size != Vector2.ZERO:
				var panel_on_right := panel_rect.get_center().x > vp.x * 0.5
				bear_x = clampf(
					panel_rect.position.x - GuideCharacter.BEAR_SIZE.x - 40.0 if panel_on_right else panel_rect.end.x + 40.0,
					20.0, vp.x - GuideCharacter.BEAR_SIZE.x - 20.0
				)
				bear_y = clampf(panel_rect.get_center().y - GuideCharacter.BEAR_SIZE.y * 0.5, 20.0, vp.y - GuideCharacter.BEAR_SIZE.y - 20.0)
			else:
				bear_x = vp.x * 0.1
				bear_y = vp.y * 0.4
			_guide.show_step(_get_text(13), Vector2(bear_x, bear_y), GuideCharacter.OVERLAY_SPOTLIGHT, true, false, false)
			if cost_rect.size != Vector2.ZERO:
				_guide.set_spotlight_rect(cost_rect.grow(10.0))

		# ── 14: Next Week button ─────────────────────────────────────────────
		14:
			_set_tap_advance(true)
			var nw_rect := _get_hud_rect(_PATH_NW_BTN_BOT)
			if nw_rect.size == Vector2.ZERO:
				nw_rect = _get_hud_rect(_PATH_NW_BTN_TOP)
			var bear_x: float
			var bear_y: float
			if nw_rect.size != Vector2.ZERO:
				bear_x = clampf(nw_rect.get_center().x - GuideCharacter.BEAR_SIZE.x * 0.5, 20.0, vp.x - GuideCharacter.BEAR_SIZE.x - 20.0)
				bear_y = clampf(nw_rect.position.y - GuideCharacter.BEAR_SIZE.y - 30.0, 20.0, vp.y - GuideCharacter.BEAR_SIZE.y - 20.0)
			else:
				bear_x = vp.x * 0.5 - 130.0
				bear_y = vp.y * 0.6
			_guide.show_step(_get_text(14), Vector2(bear_x, bear_y), GuideCharacter.OVERLAY_SPOTLIGHT, true, false, true)
			if nw_rect.size != Vector2.ZERO:
				_guide.set_spotlight_rect(nw_rect.grow(10.0))

		# ── 15: Go button ────────────────────────────────────────────────────
		15:
			_set_tap_advance(false)
			_lock_event_panel_close()
			var go_rect := _get_hud_rect(_PATH_GO_BTN)
			var bear_x: float
			var bear_y: float
			if go_rect.size != Vector2.ZERO:
				bear_x = clampf(go_rect.get_center().x - GuideCharacter.BEAR_SIZE.x * 0.5, 20.0, vp.x - GuideCharacter.BEAR_SIZE.x - 20.0)
				bear_y = clampf(go_rect.position.y - GuideCharacter.BEAR_SIZE.y - 30.0, 20.0, vp.y - GuideCharacter.BEAR_SIZE.y - 20.0)
			else:
				bear_x = vp.x * 0.5 - 130.0
				bear_y = vp.y * 0.5
			_guide.show_step(_get_text(15), Vector2(bear_x, bear_y), GuideCharacter.OVERLAY_SPOTLIGHT, false, true, true)
			if go_rect.size != Vector2.ZERO:
				_guide.set_spotlight_rect(go_rect.grow(12.0))
			_connect_go_listener()

		_:
			_finish_onboarding()


# ── Step display helpers ──────────────────────────────────────────────────────

func _set_tap_advance(enabled: bool) -> void:
	if enabled:
		if not _guide.step_advanced.is_connected(_on_step_advanced):
			_guide.step_advanced.connect(_on_step_advanced)
	else:
		if _guide.step_advanced.is_connected(_on_step_advanced):
			_guide.step_advanced.disconnect(_on_step_advanced)


func _center_bear(vp: Vector2) -> Vector2:
	return Vector2(vp.x * 0.5 - 130.0, vp.y * 0.42 - 130.0)


func _bear_pos_beside_phone(vp: Vector2) -> Vector2:
	var phone_rect := _get_hud_rect(_PATH_PHONE_SCREEN)
	if phone_rect.size != Vector2.ZERO:
		return Vector2(
			clampf(phone_rect.position.x - GuideCharacter.BEAR_SIZE.x - 20.0, 20.0, vp.x - GuideCharacter.BEAR_SIZE.x - 20.0),
			clampf(phone_rect.get_center().y - GuideCharacter.BEAR_SIZE.y * 0.5, 20.0, vp.y - GuideCharacter.BEAR_SIZE.y - 20.0)
		)
	return Vector2(50.0, vp.y * 0.35 - 130.0)


func _show_phone_app_spotlight(
	text_key: int,
	app_button_name: String,
	allow_tap: bool,
	overlay_passthrough: bool
) -> void:
	var vp := _guide.get_viewport_rect().size
	var rect := _get_hud_rect(_PATH_APP_GRID + app_button_name)
	var bear_x := (
		clampf(rect.get_center().x - GuideCharacter.BEAR_SIZE.x * 0.5, 20.0, vp.x - GuideCharacter.BEAR_SIZE.x - 20.0)
		if rect.size != Vector2.ZERO else vp.x * 0.5 - 130.0
	)
	var bear_y := (
		clampf(rect.end.y + 200.0, 20.0, vp.y - GuideCharacter.BEAR_SIZE.y - 20.0)
		if rect.size != Vector2.ZERO else vp.y * 0.7
	)
	_guide.show_step(
		_get_text(text_key), Vector2(bear_x, bear_y),
		GuideCharacter.OVERLAY_SPOTLIGHT, allow_tap, overlay_passthrough, true
	)
	if rect.size != Vector2.ZERO:
		_guide.set_spotlight_rect(rect.grow(14.0))


# ── Smart marker: resolve clue → location → marker path ───────────────────────

func _resolve_marker_path() -> String:
	var location_id := _tracked_clue_location_id
	if location_id == "":
		return "Map/MapControl/MarkersLayer/CsitEngnAreaMarker"
	var markers_layer := _main_ref.get_node_or_null(_PATH_MARKERS_LAYER) if _main_ref else null
	if markers_layer == null:
		return "Map/MapControl/MarkersLayer/CsitEngnAreaMarker"
	for child in markers_layer.get_children():
		var loc_id = child.get("location_id")
		if typeof(loc_id) != TYPE_STRING:
			continue
		if loc_id == location_id:
			return _PATH_MARKERS_LAYER + "/" + child.name
	return "Map/MapControl/MarkersLayer/CsitEngnAreaMarker"


# Resolve a clue_id to its location_id via events.json (EventManager).
func _resolve_clue_to_location(clue_id: String) -> String:
	if clue_id == "":
		return ""
	var em := get_node_or_null("/root/EventManager")
	if em == null:
		return ""
	var events: Dictionary = em.get("events_data") if em else {}
	for event_id in events:
		var ev: Dictionary = events[event_id] as Dictionary
		if str(ev.get("clue_id", "")) == clue_id:
			return str(ev.get("location_id", ""))
	return ""


# ── Helpers ───────────────────────────────────────────────────────────────────


func _get_hud_rect(path: String) -> Rect2:
	if _main_ref == null:
		return Rect2()
	var node := _main_ref.get_node_or_null(path)
	if node == null or not (node is Control):
		return Rect2()
	return (node as Control).get_global_rect()


func _connect_phone_listener() -> void:
	if _main_ref == null:
		return
	var ins_btn := _main_ref.get_node_or_null(_PATH_INS_BTN)
	if ins_btn == null:
		return
	if not (ins_btn as BaseButton).pressed.is_connected(_on_phone_pressed):
		(ins_btn as BaseButton).pressed.connect(_on_phone_pressed, CONNECT_ONE_SHOT)


func _on_phone_pressed() -> void:
	_ensure_guide()
	_guide.block_input()
	get_tree().create_timer(0.7).timeout.connect(
		func():
			if _in_onboarding:
				_step = 4
				_run_step(4)
	)


func _finish_onboarding() -> void:
	_in_onboarding = false
	_unlock_non_phone_input()
	_unlock_phone_buttons()
	_unlock_map_markers()
	_unlock_event_panel_ctrls()
	if _guide and is_instance_valid(_guide):
		if _guide.step_advanced.is_connected(_on_step_advanced):
			_guide.step_advanced.disconnect(_on_step_advanced)
		_guide.clear_phone_zone()
	hide_guide()


func _lock_non_phone_input() -> void:
	if _main_ref == null:
		return
	var map := _main_ref.get_node_or_null("Map")
	if map != null and _locked_map == null:
		map.set_process_mode(Node.PROCESS_MODE_DISABLED)
		_locked_map = map
	for path in [_PATH_NW_BTN_BOT, _PATH_NW_BTN_TOP]:
		var btn := _main_ref.get_node_or_null(path)
		if btn != null and btn is Control:
			var ctrl := btn as Control
			ctrl.mouse_filter = Control.MOUSE_FILTER_IGNORE
			_locked_hud_buttons.append(ctrl)


func _unlock_non_phone_input() -> void:
	if _locked_map != null and is_instance_valid(_locked_map):
		_locked_map.set_process_mode(Node.PROCESS_MODE_INHERIT)
	_locked_map = null
	for ctrl in _locked_hud_buttons:
		if is_instance_valid(ctrl):
			ctrl.mouse_filter = Control.MOUSE_FILTER_STOP
	_locked_hud_buttons.clear()


func _lock_phone_buttons_except(keep_unlocked: String) -> void:
	if _main_ref == null:
		return
	for btn_name in _ALL_APP_BUTTONS:
		if btn_name == keep_unlocked:
			continue
		var btn := _main_ref.get_node_or_null(_PATH_APP_GRID + btn_name)
		if btn != null and btn is Control:
			var ctrl := btn as Control
			ctrl.mouse_filter = Control.MOUSE_FILTER_IGNORE
			_locked_phone_buttons.append(ctrl)


func _unlock_phone_buttons() -> void:
	for ctrl in _locked_phone_buttons:
		if is_instance_valid(ctrl):
			ctrl.mouse_filter = Control.MOUSE_FILTER_STOP
	_locked_phone_buttons.clear()


func _unlock_map_only() -> void:
	if _locked_map != null and is_instance_valid(_locked_map):
		_locked_map.set_process_mode(Node.PROCESS_MODE_INHERIT)
	_locked_map = null


func _lock_map_markers_except(location_id: String) -> void:
	if _main_ref == null:
		return
	var markers_layer := _main_ref.get_node_or_null(_PATH_MARKERS_LAYER)
	if markers_layer == null:
		return
	for child in markers_layer.get_children():
		var loc_id = child.get("location_id")
		if typeof(loc_id) != TYPE_STRING:
			continue
		if loc_id == location_id:
			continue
		var dot_btn := child.get_node_or_null("DotButton")
		if dot_btn != null and dot_btn is Control:
			var ctrl := dot_btn as Control
			ctrl.mouse_filter = Control.MOUSE_FILTER_IGNORE
			_locked_map_markers.append(ctrl)


func _unlock_map_markers() -> void:
	for ctrl in _locked_map_markers:
		if is_instance_valid(ctrl):
			ctrl.mouse_filter = Control.MOUSE_FILTER_STOP
	_locked_map_markers.clear()


func _lock_ins_button() -> void:
	if _main_ref == null:
		return
	var btn := _main_ref.get_node_or_null(_PATH_INS_BTN)
	if btn != null and btn is Control:
		var ctrl := btn as Control
		ctrl.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_locked_hud_buttons.append(ctrl)


func _lock_event_panel_close() -> void:
	if _main_ref == null:
		return
	var close_btn := _main_ref.get_node_or_null(_PATH_CLOSE_BTN)
	if close_btn != null and close_btn is Control:
		var ctrl := close_btn as Control
		ctrl.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_locked_event_panel_ctrls.append(ctrl)


func _unlock_event_panel_ctrls() -> void:
	for ctrl in _locked_event_panel_ctrls:
		if is_instance_valid(ctrl):
			ctrl.mouse_filter = Control.MOUSE_FILTER_STOP
	_locked_event_panel_ctrls.clear()


# ── Listeners ─────────────────────────────────────────────────────────────────

func _connect_marker_listener(marker_path: String) -> void:
	if _main_ref == null:
		return
	var marker := _main_ref.get_node_or_null(marker_path)
	if marker == null:
		return
	if not marker.selected.is_connected(_on_marker_selected):
		marker.selected.connect(_on_marker_selected, CONNECT_ONE_SHOT)


func _on_marker_selected(_location_id: String, _anchor: Control) -> void:
	if not _in_onboarding:
		return
	_ensure_guide()
	_guide.block_input()
	get_tree().create_timer(0.4).timeout.connect(
		func():
			if _in_onboarding:
				_step = 13
				_run_step(13)
	)


func _connect_go_listener() -> void:
	if _main_ref == null:
		return
	var go_btn := _main_ref.get_node_or_null(_PATH_GO_BTN)
	if go_btn == null:
		return
	if not (go_btn as BaseButton).pressed.is_connected(_on_go_pressed):
		(go_btn as BaseButton).pressed.connect(_on_go_pressed, CONNECT_ONE_SHOT)


func _on_go_pressed() -> void:
	_finish_onboarding()


func _on_step_8_advanced() -> void:
	if not _in_onboarding:
		return
	hide_guide()
	get_tree().create_timer(0.3).timeout.connect(
		func():
			if _in_onboarding:
				_connect_keyword_listeners()
	)


func _connect_keyword_listeners() -> void:
	if _main_ref == null:
		return
	var feed_list := _main_ref.get_node_or_null(_PATH_INS_FEED)
	if feed_list == null:
		return
	for post_item in feed_list.get_children():
		var post_text := post_item.get_node_or_null("MarginContainer/VBoxContainer/PostText")
		if post_text != null and post_text.has_signal("meta_clicked"):
			if not post_text.meta_clicked.is_connected(_on_keyword_clicked):
				post_text.meta_clicked.connect(_on_keyword_clicked, CONNECT_ONE_SHOT)


func _on_keyword_clicked(meta: Variant) -> void:
	if not _in_onboarding:
		return
	# Capture the keyword → clue → location mapping for the smart marker step.
	var keyword := str(meta)
	var clue_id := _find_clue_id_for_keyword(keyword)
	if clue_id != "":
		_tracked_clue_location_id = _resolve_clue_to_location(clue_id)
	_ensure_guide()
	get_tree().create_timer(0.5).timeout.connect(
		func():
			if _in_onboarding:
				_step = 9
				_run_step(9)
	)


func _find_clue_id_for_keyword(keyword: String) -> String:
	var posts: Array = Global.get("posts_data") if Global else []
	for post in posts:
		if not (post is Dictionary):
			continue
		var annotations: Dictionary = post.get("annotations", {})
		if annotations.has(keyword):
			var ann: Dictionary = annotations[keyword] as Dictionary
			return str(ann.get("clue_id", ""))
	return ""


func _connect_ins_listener() -> void:
	if _main_ref == null:
		return
	var ins_btn := _main_ref.get_node_or_null(_PATH_APP_GRID + "AppInsButton")
	if ins_btn == null:
		return
	if not (ins_btn as BaseButton).pressed.is_connected(_on_ins_app_pressed):
		(ins_btn as BaseButton).pressed.connect(_on_ins_app_pressed, CONNECT_ONE_SHOT)


func _on_ins_app_pressed() -> void:
	_unlock_phone_buttons()
	_ensure_guide()
	_guide.block_input()
	get_tree().create_timer(0.7).timeout.connect(
		func():
			if _in_onboarding:
				_step = 8
				_run_step(8)
	)


func _connect_profile_listener() -> void:
	if _main_ref == null:
		return
	var profile_btn := _main_ref.get_node_or_null(_PATH_APP_GRID + "AppProfileButton")
	if profile_btn == null:
		return
	if not (profile_btn as BaseButton).pressed.is_connected(_on_profile_app_pressed):
		(profile_btn as BaseButton).pressed.connect(_on_profile_app_pressed, CONNECT_ONE_SHOT)


func _on_profile_app_pressed() -> void:
	_unlock_phone_buttons()
	hide_guide()
	get_tree().create_timer(0.5).timeout.connect(_poll_for_profile_closed)


func _poll_for_profile_closed() -> void:
	if not _in_onboarding or _main_ref == null:
		return
	if _main_ref.get_node_or_null(_PATH_PROFILE_CARD) != null:
		get_tree().create_timer(0.3).timeout.connect(_poll_for_profile_closed)
	else:
		_on_profile_card_closed()


func _on_profile_card_closed() -> void:
	if not _in_onboarding:
		return
	if _main_ref != null and _main_ref.has_method("open_ins"):
		_main_ref.call_deferred("open_ins")
	get_tree().create_timer(0.8).timeout.connect(
		func():
			if _in_onboarding:
				_step = 5
				_run_step(5)
	)


# ── Text loading ──────────────────────────────────────────────────────────────


func _load_texts() -> void:
	var file := FileAccess.open(_GUIDE_TEXTS_PATH, FileAccess.READ)
	if file == null:
		return
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	file.close()
	if not (parsed is Dictionary):
		return
	for entry in parsed.get("onboarding", []):
		if entry is Dictionary and entry.has("step") and entry.has("text"):
			_loaded_texts[int(entry["step"])] = str(entry["text"])


func _get_text(step: int) -> String:
	if _loaded_texts.has(step):
		return _loaded_texts[step]
	return _DEFAULT_TEXTS.get(step, "")


# ── Internal ──────────────────────────────────────────────────────────────────


func _ensure_guide() -> void:
	if _guide == null or not is_instance_valid(_guide):
		_guide = GuideCharacterScript.new()
		_guide.name = "GuideCharacter"
		get_tree().root.add_child(_guide)
	elif not _guide.is_inside_tree():
		get_tree().root.add_child(_guide)
