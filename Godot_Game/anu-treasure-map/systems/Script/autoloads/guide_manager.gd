extends Node

const GuideCharacterScript = preload("res://systems/Script/ui/guide_character.gd")
const _GUIDE_TEXTS_PATH := "res://data/guide_texts.json"

# Fallback text used when the JSON file is absent or missing a step.
const _DEFAULT_TEXTS := {
	0: "Welcome to ANU Treasure Map!\nTap anywhere to continue.",
	1: "Explore campus and collect treasures.\nTap to continue.",
	2: "This is your Week.\nYou have 16 weeks to explore ANU campus!\nTap anywhere to continue.",
	3: "This is your Location.\nIt shows where you are on campus.\nTap anywhere to continue.",
	4: "This is your Time.\nExploring locations costs time each week.\nTap anywhere to continue.",
	5: "This is your Money.\nMore features coming soon!\nTap anywhere to continue.",
	6: "Tap the phone icon — it's your control panel\nfor messages, profile and more!",
}

var _guide: GuideCharacter = null
var _step: int = -1
var _main_ref: Node = null
var _in_onboarding := false
var _loaded_texts := {}
var _locked_map: Node = null
var _locked_hud_buttons: Array[Control] = []


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
			var week_rect := _get_hud_rect("HUD/Bottombar/WeekStatus")
			var bear_x := (week_rect.position.x if week_rect.size != Vector2.ZERO else 40.0) - 10.0
			var bear_pos := Vector2(maxf(bear_x, 20.0), vp.y - 360.0)
			_guide.show_step(
				_get_text(2), bear_pos, GuideCharacter.OVERLAY_SPOTLIGHT, true, false, true
			)
			if week_rect.size != Vector2.ZERO:
				_guide.set_spotlight_rect(week_rect.grow(10.0))

		3:
			var loc_rect := _get_hud_rect("HUD/Bottombar/LocationStatus")
			var bear_x: float
			if loc_rect.size != Vector2.ZERO:
				bear_x = maxf(loc_rect.get_center().x - GuideCharacter.BEAR_SIZE.x - 20.0, 20.0)
			else:
				bear_x = vp.x * 0.25
			var bear_pos := Vector2(bear_x, vp.y - 360.0)
			_guide.show_step(
				_get_text(3), bear_pos, GuideCharacter.OVERLAY_SPOTLIGHT, true, false, true
			)
			if loc_rect.size != Vector2.ZERO:
				_guide.set_spotlight_rect(loc_rect.grow(10.0))

		4:
			var time_rect := _get_hud_rect("HUD/Bottombar/TimeStatus")
			var bear_x := (
				(time_rect.position.x - 280.0) if time_rect.size != Vector2.ZERO else 360.0
			)
			var bear_pos := Vector2(maxf(bear_x, 20.0), vp.y - 360.0)
			_guide.show_step(
				_get_text(4), bear_pos, GuideCharacter.OVERLAY_SPOTLIGHT, true, false, true
			)
			if time_rect.size != Vector2.ZERO:
				_guide.set_spotlight_rect(time_rect.grow(10.0))

		5:
			var money_rect := _get_hud_rect("HUD/Bottombar/MoneyStatus")
			var bear_x := (
				(money_rect.position.x - 280.0) if money_rect.size != Vector2.ZERO else 540.0
			)
			var bear_pos := Vector2(maxf(bear_x, 20.0), vp.y - 360.0)
			_guide.show_step(
				_get_text(5), bear_pos, GuideCharacter.OVERLAY_SPOTLIGHT, true, false, true
			)
			if money_rect.size != Vector2.ZERO:
				_guide.set_spotlight_rect(money_rect.grow(10.0))

		6:
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
					_get_text(6),
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
	_finish_onboarding()
	if _main_ref != null and is_instance_valid(_main_ref):
		var main := _main_ref
		get_tree().create_timer(0.4).timeout.connect(
			func():
				if is_instance_valid(main) and main.has_method("is_player_registered"):
					if not main.call("is_player_registered"):
						main.call("open_profile", true, true)
		)


func _finish_onboarding() -> void:
	_in_onboarding = false
	_unlock_non_phone_input()
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
