extends Node

const GuideCharacterScript = preload("res://systems/Script/ui/guide_character.gd")
const _GUIDE_TEXTS_PATH := "res://data/guide_texts.json"

# Fallback text used when the JSON file is absent or missing a step.
const _DEFAULT_TEXTS := {
	0: "Welcome to ANU Treasure Map!\nTap anywhere to continue.",
	1: "Explore campus and collect treasures.\nTap to continue.",
	2: "These are your End Goals!\nComplete any one of them to finish the game.\nAim to collect as many treasures as you can!",
	3: "This is your Week.\nYou have 16 weeks to explore ANU campus!\nTap anywhere to continue.",
	4: "This is your Location.\nIt shows where you are on campus.\nTap anywhere to continue.",
	5: "This is your Time.\nExploring locations costs time each week.\nTap anywhere to continue.",
	6: "This is your Money.\nMore features coming soon!\nTap anywhere to continue.",
	7: "Tap the phone icon — it's your control panel\nfor messages, profile and more!",
	8: "This is your Profile!\nTap this app to set up your personal info.",
	9: "This is the Collection Book!\nBrowse all the treasures you've discovered.\nTap anywhere to continue.",
	10: "This is the Menu.\nAdjust music or restart the game from here.\nTap anywhere to continue.",
	11: "This is ANU Ins!\nBrowse the latest campus posts.\nTap to open it and finish setup!",
	12: "You can find clues to treasures here!\nThere seems to be some key information?\nTry tapping it!",
	13: "Let's head back to the map\nand see what's happening!",
	15: "The clue just mentioned something exciting happening here!\nLet's go check it out.",
	16: "This is the time it takes to travel here.",
	17: "Running out of time? Tap Next Week\nto move on to the next week!",
	18: "Let's go take a look!",
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
	_ensure_guide()
	_guide.block_input()  # transparent STOP overlay — blocks map from frame 1
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
		0:
			var bear_pos := Vector2(vp.x * 0.5 - 130.0, vp.y * 0.42 - 130.0)
			_guide.show_step(_get_text(0), bear_pos, GuideCharacter.OVERLAY_FLAT, true)

		1:
			var bear_pos := Vector2(vp.x * 0.5 - 130.0, vp.y * 0.42 - 130.0)
			_guide.show_step(
				_get_text(1), bear_pos, GuideCharacter.OVERLAY_FLAT, true, false, true
			)

		2:
			var goal_rect := _get_hud_rect("GoalPanelLayer/EndGameGoalPanel/GoalPanel")
			# Place the bear to the right of the panel so neither the bear nor its
			# speech bubble overlaps the goal panel UI.
			var bear_x := (
				clampf(goal_rect.end.x + 80.0, 20.0, vp.x - GuideCharacter.BEAR_SIZE.x - 20.0)
				if goal_rect.size != Vector2.ZERO
				else vp.x * 0.55
			)
			var bear_y := (
				clampf(
					goal_rect.get_center().y - GuideCharacter.BEAR_SIZE.y * 0.5,
					20.0,
					vp.y - GuideCharacter.BEAR_SIZE.y - 20.0
				)
				if goal_rect.size != Vector2.ZERO
				else 20.0
			)
			var bear_pos := Vector2(bear_x, bear_y)
			_guide.show_step(_get_text(2), bear_pos, GuideCharacter.OVERLAY_SPOTLIGHT, true, false, true)
			if goal_rect.size != Vector2.ZERO:
				_guide.set_spotlight_rect(goal_rect.grow(10.0))

		3:
			var week_rect := _get_hud_rect("HUD/Bottombar/WeekStatus")
			var bear_x := (week_rect.position.x if week_rect.size != Vector2.ZERO else 40.0) - 10.0
			var bear_pos := Vector2(maxf(bear_x, 20.0), vp.y - 360.0)
			_guide.show_step(
				_get_text(3), bear_pos, GuideCharacter.OVERLAY_SPOTLIGHT, true, false, true
			)
			if week_rect.size != Vector2.ZERO:
				_guide.set_spotlight_rect(week_rect.grow(10.0))

		4:
			var loc_rect := _get_hud_rect("HUD/Bottombar/LocationStatus")
			var bear_x: float
			if loc_rect.size != Vector2.ZERO:
				bear_x = maxf(loc_rect.get_center().x - GuideCharacter.BEAR_SIZE.x - 20.0, 20.0)
			else:
				bear_x = vp.x * 0.25
			var bear_pos := Vector2(bear_x, vp.y - 360.0)
			_guide.show_step(
				_get_text(4), bear_pos, GuideCharacter.OVERLAY_SPOTLIGHT, true, false, true
			)
			if loc_rect.size != Vector2.ZERO:
				_guide.set_spotlight_rect(loc_rect.grow(10.0))

		5:
			var time_rect := _get_hud_rect("HUD/Bottombar/TimeStatus")
			var bear_x := (
				(time_rect.position.x - 280.0) if time_rect.size != Vector2.ZERO else 360.0
			)
			var bear_pos := Vector2(maxf(bear_x, 20.0), vp.y - 360.0)
			_guide.show_step(
				_get_text(5), bear_pos, GuideCharacter.OVERLAY_SPOTLIGHT, true, false, true
			)
			if time_rect.size != Vector2.ZERO:
				_guide.set_spotlight_rect(time_rect.grow(10.0))

		6:
			var money_rect := _get_hud_rect("HUD/Bottombar/MoneyStatus")
			var bear_x := (
				(money_rect.position.x - 280.0) if money_rect.size != Vector2.ZERO else 540.0
			)
			var bear_pos := Vector2(maxf(bear_x, 20.0), vp.y - 360.0)
			_guide.show_step(
				_get_text(6), bear_pos, GuideCharacter.OVERLAY_SPOTLIGHT, true, false, true
			)
			if money_rect.size != Vector2.ZERO:
				_guide.set_spotlight_rect(money_rect.grow(10.0))

		7:
			# Phone step — overlay passthrough so InsButton keeps its hover effect.
			# Map and other HUD buttons are locked separately.
			if _guide.step_advanced.is_connected(_on_step_advanced):
				_guide.step_advanced.disconnect(_on_step_advanced)

			var phone_rect := _get_hud_rect("HUD/MarginContainer/InsButton")
			var bear_pos: Vector2
			if phone_rect.size != Vector2.ZERO:
				bear_pos = Vector2(
					clampf(
						phone_rect.end.x - GuideCharacter.BEAR_SIZE.x,
						20.0,
						vp.x - GuideCharacter.BEAR_SIZE.x - 20.0
					),
					clampf(
						phone_rect.position.y - GuideCharacter.BEAR_SIZE.y - 25.0,
						20.0,
						vp.y - GuideCharacter.BEAR_SIZE.y - 20.0
					)
				)
			else:
				bear_pos = Vector2(vp.x - 300.0, vp.y * 0.40 - 130.0)

			(
				_guide
				. show_step(
					_get_text(7),
					bear_pos,
					GuideCharacter.OVERLAY_SPOTLIGHT,
					false,
					true,  # overlay_passthrough → MOUSE_FILTER_IGNORE, InsButton gets hover/click
					true,  # keep_overlay
				)
			)
			if phone_rect.size != Vector2.ZERO:
				_guide.set_spotlight_rect(phone_rect.grow(14.0))
			_lock_non_phone_input()
			_connect_phone_listener()

		8:
			# Profile-app step — inside the phone, spotlight on AppProfileButton.
			if _guide.step_advanced.is_connected(_on_step_advanced):
				_guide.step_advanced.disconnect(_on_step_advanced)

			var _app_base := (
				"Ins/PhoneScreen/MainMargin/MainVBox/HomeScreen/AppsSlot/AppsCenter/AppGrid/"
			)
			var profile_rect := _get_hud_rect(_app_base + "AppProfileButton")
			var bear_x := (
				clampf(
					profile_rect.get_center().x - GuideCharacter.BEAR_SIZE.x * 0.5,
					20.0,
					vp.x - GuideCharacter.BEAR_SIZE.x - 20.0
				)
				if profile_rect.size != Vector2.ZERO
				else vp.x * 0.5 - 130.0
			)
			var bear_y := (
				clampf(profile_rect.end.y + 200.0, 20.0, vp.y - GuideCharacter.BEAR_SIZE.y - 20.0)
				if profile_rect.size != Vector2.ZERO
				else vp.y * 0.65
			)
			(
				_guide
				. show_step(
					_get_text(8),
					Vector2(bear_x, bear_y),
					GuideCharacter.OVERLAY_SPOTLIGHT,
					false,
					true,   # overlay_passthrough → AppProfileButton keeps hover/click
					true,   # keep_overlay from phone step
				)
			)
			if profile_rect.size != Vector2.ZERO:
				_guide.set_spotlight_rect(profile_rect.grow(14.0))
			_lock_phone_buttons_except_profile()
			_connect_profile_listener()

		9:
			if not _guide.step_advanced.is_connected(_on_step_advanced):
				_guide.step_advanced.connect(_on_step_advanced)
			var col_base := (
				"Ins/PhoneScreen/MainMargin/MainVBox/HomeScreen/AppsSlot/AppsCenter/AppGrid/"
			)
			var col_rect := _get_hud_rect(col_base + "AppCollectionButton")
			var bear_x := (
				clampf(
					col_rect.get_center().x - GuideCharacter.BEAR_SIZE.x * 0.5,
					20.0,
					vp.x - GuideCharacter.BEAR_SIZE.x - 20.0
				)
				if col_rect.size != Vector2.ZERO
				else vp.x * 0.5 - 130.0
			)
			var bear_y := (
				clampf(col_rect.end.y + 200.0, 20.0, vp.y - GuideCharacter.BEAR_SIZE.y - 20.0)
				if col_rect.size != Vector2.ZERO
				else vp.y * 0.7
			)
			_guide.show_step(
				_get_text(9), Vector2(bear_x, bear_y),
				GuideCharacter.OVERLAY_SPOTLIGHT, true, false, true
			)
			if col_rect.size != Vector2.ZERO:
				_guide.set_spotlight_rect(col_rect.grow(14.0))

		10:
			if not _guide.step_advanced.is_connected(_on_step_advanced):
				_guide.step_advanced.connect(_on_step_advanced)
			var menu_base := (
				"Ins/PhoneScreen/MainMargin/MainVBox/HomeScreen/AppsSlot/AppsCenter/AppGrid/"
			)
			var menu_rect := _get_hud_rect(menu_base + "AppMenuButton")
			var bear_x := (
				clampf(
					menu_rect.get_center().x - GuideCharacter.BEAR_SIZE.x * 0.5,
					20.0,
					vp.x - GuideCharacter.BEAR_SIZE.x - 20.0
				)
				if menu_rect.size != Vector2.ZERO
				else vp.x * 0.5 - 130.0
			)
			var bear_y := (
				clampf(menu_rect.end.y + 200.0, 20.0, vp.y - GuideCharacter.BEAR_SIZE.y - 20.0)
				if menu_rect.size != Vector2.ZERO
				else vp.y * 0.7
			)
			_guide.show_step(
				_get_text(10), Vector2(bear_x, bear_y),
				GuideCharacter.OVERLAY_SPOTLIGHT, true, false, true
			)
			if menu_rect.size != Vector2.ZERO:
				_guide.set_spotlight_rect(menu_rect.grow(14.0))

		11:
			if _guide.step_advanced.is_connected(_on_step_advanced):
				_guide.step_advanced.disconnect(_on_step_advanced)
			var ins_base := (
				"Ins/PhoneScreen/MainMargin/MainVBox/HomeScreen/AppsSlot/AppsCenter/AppGrid/"
			)
			var ins_rect := _get_hud_rect(ins_base + "AppInsButton")
			var bear_x := (
				clampf(
					ins_rect.get_center().x - GuideCharacter.BEAR_SIZE.x * 0.5,
					20.0,
					vp.x - GuideCharacter.BEAR_SIZE.x - 20.0
				)
				if ins_rect.size != Vector2.ZERO
				else vp.x * 0.5 - 130.0
			)
			var bear_y := (
				clampf(ins_rect.end.y + 200.0, 20.0, vp.y - GuideCharacter.BEAR_SIZE.y - 20.0)
				if ins_rect.size != Vector2.ZERO
				else vp.y * 0.7
			)
			(
				_guide
				. show_step(
					_get_text(11),
					Vector2(bear_x, bear_y),
					GuideCharacter.OVERLAY_SPOTLIGHT,
					false,
					true,
					true,
				)
			)
			if ins_rect.size != Vector2.ZERO:
				_guide.set_spotlight_rect(ins_rect.grow(14.0))
			_lock_phone_buttons_except_ins()
			_connect_ins_listener()

		12:
			# Bear appears next to phone (left side), flat overlay, tap to dismiss.
			if _guide.step_advanced.is_connected(_on_step_advanced):
				_guide.step_advanced.disconnect(_on_step_advanced)
			if not _guide.step_advanced.is_connected(_on_step_12_advanced):
				_guide.step_advanced.connect(_on_step_12_advanced, CONNECT_ONE_SHOT)

			var phone_rect := _get_hud_rect("Ins/PhoneScreen")
			var bear_pos_12: Vector2
			if phone_rect.size != Vector2.ZERO:
				var bx := clampf(
					phone_rect.position.x - GuideCharacter.BEAR_SIZE.x - 20.0,
					20.0,
					vp.x - GuideCharacter.BEAR_SIZE.x - 20.0
				)
				var by := clampf(
					phone_rect.get_center().y - GuideCharacter.BEAR_SIZE.y * 0.5,
					20.0,
					vp.y - GuideCharacter.BEAR_SIZE.y - 20.0
				)
				bear_pos_12 = Vector2(bx, by)
			else:
				bear_pos_12 = Vector2(50.0, vp.y * 0.35 - 130.0)

			_guide.show_step(_get_text(12), bear_pos_12, GuideCharacter.OVERLAY_FLAT, true, false, false)

		13:
			# Bear reappears after keyword click, tap to finish.
			if not _guide.step_advanced.is_connected(_on_step_advanced):
				_guide.step_advanced.connect(_on_step_advanced)

			var phone_rect_13 := _get_hud_rect("Ins/PhoneScreen")
			var bear_pos_13: Vector2
			if phone_rect_13.size != Vector2.ZERO:
				var bx := clampf(
					phone_rect_13.position.x - GuideCharacter.BEAR_SIZE.x - 20.0,
					20.0,
					vp.x - GuideCharacter.BEAR_SIZE.x - 20.0
				)
				var by := clampf(
					phone_rect_13.get_center().y - GuideCharacter.BEAR_SIZE.y * 0.5,
					20.0,
					vp.y - GuideCharacter.BEAR_SIZE.y - 20.0
				)
				bear_pos_13 = Vector2(bx, by)
			else:
				bear_pos_13 = Vector2(50.0, vp.y * 0.35 - 130.0)

			_guide.show_step(_get_text(13), bear_pos_13, GuideCharacter.OVERLAY_FLAT, true, false, false)

		14:
			# Transition: close phone, wait, then proceed to map steps.
			if _guide.step_advanced.is_connected(_on_step_advanced):
				_guide.step_advanced.disconnect(_on_step_advanced)
			hide_guide()
			var ins_node := _main_ref.get_node_or_null("Ins") if _main_ref else null
			if ins_node != null and ins_node.has_method("close_phone"):
				ins_node.call("close_phone")
			get_tree().create_timer(0.8).timeout.connect(
				func():
					if _in_onboarding:
						_step = 15
						_run_step(15)
			)

		15:
			# Map: spotlight CSIT/ENGN, lock other markers and HUD phone button.
			if _guide.step_advanced.is_connected(_on_step_advanced):
				_guide.step_advanced.disconnect(_on_step_advanced)
			_unlock_map_only()
			_lock_map_markers_except("csit_engn_area")
			_lock_ins_button()

			var dot_rect := _get_hud_rect(
				"Map/MapControl/MarkersLayer/CsitEngnAreaMarker/DotButton"
			)
			var ref_rect := (
				dot_rect if dot_rect.size != Vector2.ZERO
				else _get_hud_rect("Map/MapControl/MarkersLayer/CsitEngnAreaMarker")
			)
			var bear_x_15: float
			var bear_y_15: float
			if ref_rect.size != Vector2.ZERO:
				var right_x := ref_rect.end.x + 20.0
				if right_x + GuideCharacter.BEAR_SIZE.x < vp.x - 20.0:
					bear_x_15 = right_x
				else:
					bear_x_15 = clampf(
						ref_rect.position.x - GuideCharacter.BEAR_SIZE.x - 20.0,
						20.0,
						vp.x - GuideCharacter.BEAR_SIZE.x - 20.0
					)
				bear_y_15 = clampf(
					ref_rect.get_center().y - GuideCharacter.BEAR_SIZE.y * 0.5,
					20.0,
					vp.y - GuideCharacter.BEAR_SIZE.y - 20.0
				)
			else:
				bear_x_15 = vp.x * 0.6
				bear_y_15 = vp.y * 0.35 - 130.0
			_guide.show_step(
				_get_text(15), Vector2(bear_x_15, bear_y_15),
				GuideCharacter.OVERLAY_SPOTLIGHT, false, true, false
			)
			if ref_rect.size != Vector2.ZERO:
				_guide.set_spotlight_rect(ref_rect.grow(18.0))
			_connect_csit_listener()

		16:
			# EventPanel: spotlight TravelCostLabel, bear on opposite side from panel.
			if not _guide.step_advanced.is_connected(_on_step_advanced):
				_guide.step_advanced.connect(_on_step_advanced)
			var panel_rect_16 := _get_hud_rect("Map/MapControl/EventPanel")
			var cost_rect := _get_hud_rect("Map/MapControl/EventPanel/TravelCostLabel")
			var bear_x_16: float
			var bear_y_16: float
			if panel_rect_16.size != Vector2.ZERO:
				if panel_rect_16.get_center().x > vp.x * 0.5:
					bear_x_16 = clampf(
						panel_rect_16.position.x - GuideCharacter.BEAR_SIZE.x - 40.0,
						20.0, vp.x - GuideCharacter.BEAR_SIZE.x - 20.0
					)
				else:
					bear_x_16 = clampf(
						panel_rect_16.end.x + 40.0,
						20.0, vp.x - GuideCharacter.BEAR_SIZE.x - 20.0
					)
				bear_y_16 = clampf(
					panel_rect_16.get_center().y - GuideCharacter.BEAR_SIZE.y * 0.5,
					20.0, vp.y - GuideCharacter.BEAR_SIZE.y - 20.0
				)
			else:
				bear_x_16 = vp.x * 0.1
				bear_y_16 = vp.y * 0.4
			_guide.show_step(
				_get_text(16), Vector2(bear_x_16, bear_y_16),
				GuideCharacter.OVERLAY_SPOTLIGHT, true, false, false
			)
			if cost_rect.size != Vector2.ZERO:
				_guide.set_spotlight_rect(cost_rect.grow(10.0))

		17:
			# HUD: spotlight Next Week button.
			if not _guide.step_advanced.is_connected(_on_step_advanced):
				_guide.step_advanced.connect(_on_step_advanced)
			var nw_rect := _get_hud_rect("HUD/Bottombar/NextWeekButton")
			if nw_rect.size == Vector2.ZERO:
				nw_rect = _get_hud_rect("HUD/Topbar/NextWeekButton")
			var bear_x_17: float
			var bear_y_17: float
			if nw_rect.size != Vector2.ZERO:
				bear_x_17 = clampf(
					nw_rect.get_center().x - GuideCharacter.BEAR_SIZE.x * 0.5,
					20.0,
					vp.x - GuideCharacter.BEAR_SIZE.x - 20.0
				)
				bear_y_17 = clampf(
					nw_rect.position.y - GuideCharacter.BEAR_SIZE.y - 30.0,
					20.0,
					vp.y - GuideCharacter.BEAR_SIZE.y - 20.0
				)
			else:
				bear_x_17 = vp.x * 0.5 - 130.0
				bear_y_17 = vp.y * 0.6
			_guide.show_step(
				_get_text(17), Vector2(bear_x_17, bear_y_17),
				GuideCharacter.OVERLAY_SPOTLIGHT, true, false, true
			)
			if nw_rect.size != Vector2.ZERO:
				_guide.set_spotlight_rect(nw_rect.grow(10.0))

		18:
			# EventPanel: spotlight Go button, unlock it, lock close button.
			if _guide.step_advanced.is_connected(_on_step_advanced):
				_guide.step_advanced.disconnect(_on_step_advanced)
			_lock_event_panel_close()
			var go_rect := _get_hud_rect("Map/MapControl/EventPanel/GoButton")
			var bear_x_18: float
			var bear_y_18: float
			if go_rect.size != Vector2.ZERO:
				bear_x_18 = clampf(
					go_rect.get_center().x - GuideCharacter.BEAR_SIZE.x * 0.5,
					20.0,
					vp.x - GuideCharacter.BEAR_SIZE.x - 20.0
				)
				bear_y_18 = clampf(
					go_rect.position.y - GuideCharacter.BEAR_SIZE.y - 30.0,
					20.0,
					vp.y - GuideCharacter.BEAR_SIZE.y - 20.0
				)
			else:
				bear_x_18 = vp.x * 0.5 - 130.0
				bear_y_18 = vp.y * 0.5
			_guide.show_step(
				_get_text(18), Vector2(bear_x_18, bear_y_18),
				GuideCharacter.OVERLAY_SPOTLIGHT, false, true, true
			)
			if go_rect.size != Vector2.ZERO:
				_guide.set_spotlight_rect(go_rect.grow(12.0))
			_connect_csit_go_listener()

		_:
			_finish_onboarding()


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
	var ins_btn := _main_ref.get_node_or_null("HUD/MarginContainer/InsButton")
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
				_step = 8
				_run_step(8)
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
	for path in ["HUD/Bottombar/NextWeekButton", "HUD/Topbar/NextWeekButton"]:
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


func _lock_phone_buttons_except_profile() -> void:
	if _main_ref == null:
		return
	var base := "Ins/PhoneScreen/MainMargin/MainVBox/HomeScreen/AppsSlot/AppsCenter/AppGrid/"
	for btn_name in ["AppCollectionButton", "AppInsButton", "AppMenuButton"]:
		var btn := _main_ref.get_node_or_null(base + btn_name)
		if btn != null and btn is Control:
			var ctrl := btn as Control
			ctrl.mouse_filter = Control.MOUSE_FILTER_IGNORE
			_locked_phone_buttons.append(ctrl)


func _unlock_phone_buttons() -> void:
	for ctrl in _locked_phone_buttons:
		if is_instance_valid(ctrl):
			ctrl.mouse_filter = Control.MOUSE_FILTER_STOP
	_locked_phone_buttons.clear()


func _lock_phone_buttons_except_ins() -> void:
	if _main_ref == null:
		return
	var base := "Ins/PhoneScreen/MainMargin/MainVBox/HomeScreen/AppsSlot/AppsCenter/AppGrid/"
	for btn_name in ["AppCollectionButton", "AppProfileButton", "AppMenuButton"]:
		var btn := _main_ref.get_node_or_null(base + btn_name)
		if btn != null and btn is Control:
			var ctrl := btn as Control
			ctrl.mouse_filter = Control.MOUSE_FILTER_IGNORE
			_locked_phone_buttons.append(ctrl)


func _unlock_map_only() -> void:
	if _locked_map != null and is_instance_valid(_locked_map):
		_locked_map.set_process_mode(Node.PROCESS_MODE_INHERIT)
	_locked_map = null


func _lock_map_markers_except(location_id: String) -> void:
	if _main_ref == null:
		return
	var markers_layer := _main_ref.get_node_or_null("Map/MapControl/MarkersLayer")
	if markers_layer == null:
		return
	for child in markers_layer.get_children():
		if not (child is LocationMarker):
			continue
		var marker := child as LocationMarker
		if marker.location_id == location_id:
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
	var btn := _main_ref.get_node_or_null("HUD/MarginContainer/InsButton")
	if btn != null and btn is Control:
		var ctrl := btn as Control
		ctrl.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_locked_hud_buttons.append(ctrl)


func _lock_event_panel_close() -> void:
	if _main_ref == null:
		return
	var close_btn := _main_ref.get_node_or_null("Map/MapControl/EventPanel/CloseButton")
	if close_btn != null and close_btn is Control:
		var ctrl := close_btn as Control
		ctrl.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_locked_event_panel_ctrls.append(ctrl)


func _unlock_event_panel_ctrls() -> void:
	for ctrl in _locked_event_panel_ctrls:
		if is_instance_valid(ctrl):
			ctrl.mouse_filter = Control.MOUSE_FILTER_STOP
	_locked_event_panel_ctrls.clear()


func _connect_csit_listener() -> void:
	if _main_ref == null:
		return
	var marker := _main_ref.get_node_or_null(
		"Map/MapControl/MarkersLayer/CsitEngnAreaMarker"
	)
	if marker == null:
		return
	if not marker.selected.is_connected(_on_csit_selected):
		marker.selected.connect(_on_csit_selected, CONNECT_ONE_SHOT)


func _on_csit_selected(_location_id: String, _anchor: Control) -> void:
	if not _in_onboarding:
		return
	_ensure_guide()
	_guide.block_input()
	get_tree().create_timer(0.4).timeout.connect(
		func():
			if _in_onboarding:
				_step = 16
				_run_step(16)
	)


func _connect_csit_go_listener() -> void:
	if _main_ref == null:
		return
	var go_btn := _main_ref.get_node_or_null("Map/MapControl/EventPanel/GoButton")
	if go_btn == null:
		return
	if not (go_btn as BaseButton).pressed.is_connected(_on_csit_go_pressed):
		(go_btn as BaseButton).pressed.connect(_on_csit_go_pressed, CONNECT_ONE_SHOT)


func _on_csit_go_pressed() -> void:
	_finish_onboarding()


func _on_step_12_advanced() -> void:
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
	var feed_list := _main_ref.get_node_or_null(
		"Ins/PhoneScreen/MainMargin/MainVBox/InsAppScreen/ScrollContainer/ContentVBox/FeedList"
	)
	if feed_list == null:
		return
	for post_item in feed_list.get_children():
		var post_text := post_item.get_node_or_null("MarginContainer/VBoxContainer/PostText")
		if post_text != null and post_text.has_signal("meta_clicked"):
			if not post_text.meta_clicked.is_connected(_on_keyword_clicked):
				post_text.meta_clicked.connect(_on_keyword_clicked, CONNECT_ONE_SHOT)


func _on_keyword_clicked(_meta: Variant) -> void:
	if not _in_onboarding:
		return
	_ensure_guide()
	get_tree().create_timer(0.5).timeout.connect(
		func():
			if _in_onboarding:
				_step = 13
				_run_step(13)
	)


func _connect_ins_listener() -> void:
	if _main_ref == null:
		return
	var path := (
		"Ins/PhoneScreen/MainMargin/MainVBox/HomeScreen/AppsSlot/AppsCenter/AppGrid/AppInsButton"
	)
	var ins_btn := _main_ref.get_node_or_null(path)
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
				_step = 12
				_run_step(12)
	)


func _connect_profile_listener() -> void:
	if _main_ref == null:
		return
	var path := (
		"Ins/PhoneScreen/MainMargin/MainVBox/HomeScreen/AppsSlot/AppsCenter/AppGrid/AppProfileButton"
	)
	var profile_btn := _main_ref.get_node_or_null(path)
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
	if _main_ref.get_node_or_null("ProfileCardLayer") != null:
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
				_step = 9
				_run_step(9)
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
