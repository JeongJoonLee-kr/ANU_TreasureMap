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
}

var _guide: GuideCharacter = null
var _step: int = -1
var _main_ref: Node = null
var _in_onboarding := false
var _loaded_texts := {}
var _locked_map: Node = null
var _locked_hud_buttons: Array[Control] = []
var _locked_phone_buttons: Array[Control] = []


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
			_guide.show_step(_get_text(1), bear_pos, GuideCharacter.OVERLAY_FLAT, true, false, true)

		2:
			var goal_rect := _get_hud_rect("HUD/EndGameGoalPanel/GoalPanel")
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
	_finish_onboarding()


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
