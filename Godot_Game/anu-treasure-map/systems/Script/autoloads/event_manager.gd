extends Node

## ─── Event Manager Autoload ───
## Handles random event triggering, virtual clock, and event persistence.

# ─── Constants ─────────────────────────────────────────
const EVENTS_PATH := "res://data/events.json"
const EVENT_AP_COST := 2
const TRIGGER_CHANCE_BOOST := 0.15
const EXHAUSTED_MESSAGE := "It's getting late and you're exhausted. You should head back and rest. Try exploring again tomorrow."

# ─── Virtual Clock Phases ──────────────────────────────
# Maps AP remaining → time-of-day phase.
# With max_time_per_week = 8:
#   AP 8-6 → Morning   (9 AM – 11 AM)
#   AP 5   → Midday    (12 PM)
#   AP 4-1 → Afternoon (1 PM – 4 PM)
enum TimePhase { MORNING, MIDDAY, AFTERNOON }

# ─── Signals ──────────────────────────────────────────
signal event_triggered(event_data: Dictionary)
signal not_enough_ap

# ─── State ────────────────────────────────────────────
var events_data: Dictionary = {}

# Tracks completed events (event_id → true) — events with re_trigger=false
var completed_events: Dictionary = {}

# Tracks per-event trigger chance boosts (event_id → float offset)
var trigger_chance_boosts: Dictionary = {}


func _ready() -> void:
	_load_events()


# ─── Virtual Clock ────────────────────────────────────


## Returns the current time-of-day phase based on remaining AP.
func get_current_phase() -> TimePhase:
	var ap := Global.time
	if ap >= 6:
		return TimePhase.MORNING
	elif ap == 5:
		return TimePhase.MIDDAY
	else:
		return TimePhase.AFTERNOON


## Returns a human-readable label for the current phase.
func get_phase_label() -> String:
	match get_current_phase():
		TimePhase.MORNING:
			return "Morning"
		TimePhase.MIDDAY:
			return "Midday"
		TimePhase.AFTERNOON:
			return "Afternoon"
		_:
			return "Unknown"


## Check if it is currently afternoon.
func is_afternoon() -> bool:
	return get_current_phase() == TimePhase.AFTERNOON


## Check if the player has enough AP to trigger an event.
func has_enough_ap() -> bool:
	return Global.time >= EVENT_AP_COST


# ─── Data Loading ─────────────────────────────────────


func _load_events() -> void:
	var file := FileAccess.open(EVENTS_PATH, FileAccess.READ)
	if file == null:
		push_error("EventManager: Failed to open %s" % EVENTS_PATH)
		return

	var parsed: Variant = JSON.parse_string(file.get_as_text())
	file.close()

	if parsed is Dictionary:
		events_data = parsed
	else:
		push_error("EventManager: Failed to parse %s" % EVENTS_PATH)


# ─── Event Triggering ─────────────────────────────────


## Main entry point. Call when the player arrives at a location.
## Returns the event Dictionary if one triggers, or null for normal
## exploration. Emits not_enough_ap if AP is too low.
func try_trigger_event(location_id: String) -> Variant:
	# ── AP gate ──
	if not has_enough_ap():
		not_enough_ap.emit()
		return null

	# ── Gather eligible events for this location ──
	var eligible: Array[Dictionary] = []
	for event_id in events_data:
		var ev: Dictionary = events_data[event_id]
		if not ev.get("enabled", false):
			continue
		if str(ev.get("location_id", "")) != location_id:
			continue
		if _is_event_completed(event_id):
			continue
		# Time-of-day gate
		if ev.get("require_afternoon", false) and not is_afternoon():
			continue
		eligible.append(ev)

	if eligible.is_empty():
		return null

	# ── Clue-based selection logic ──
	var player_clues: Array[String] = Global.unlocked_clues
	var clue_events: Array[Dictionary] = []
	var non_clue_events: Array[Dictionary] = []

	for ev in eligible:
		var clue_id := str(ev.get("clue_id", ""))
		if clue_id != "" and player_clues.has(clue_id):
			# Player already has this clue → this event is "clue-related" for re-pick
			clue_events.append(ev)
		else:
			non_clue_events.append(ev)

	# If player holds clues for some events but not all, prioritise unclued ones
	if not non_clue_events.is_empty():
		# Roll trigger chance for each non-clue event
		var triggered_event: Variant = _roll_trigger(non_clue_events)
		if triggered_event != null:
			return triggered_event
		# Nothing triggered — no event this visit
		return null

	# All eligible events are clue-owned → randomly pick one (guaranteed trigger)
	if not clue_events.is_empty():
		return clue_events[randi() % clue_events.size()]

	return null


## Roll the trigger chance for a list of candidate events.
## Returns the triggered event or null.
func _roll_trigger(candidates: Array[Dictionary]) -> Variant:
	# Shuffle to randomize selection order
	var shuffled := candidates.duplicate()
	shuffled.shuffle()

	for ev in shuffled:
		var event_id := str(ev.get("id", ""))
		var base_chance: float = float(ev.get("base_trigger_chance", 0.3))
		var boost: float = trigger_chance_boosts.get(event_id, 0.0)
		var final_chance: float = clampf(base_chance + boost, 0.0, 1.0)

		if randf() <= final_chance:
			return ev

	return null


## Check if an event has been completed with re_trigger=false.
func _is_event_completed(event_id: String) -> bool:
	return completed_events.has(event_id)


# ─── Event Completion ─────────────────────────────────


## Call after the player makes a choice.
## Spends AP, records clues, and handles re-trigger flags.
func complete_event(event_id: String, choice_key: String) -> void:
	# Spend AP
	Global.time -= EVENT_AP_COST
	if Global.time <= 0:
		# If out of time, advance week
		var main_scene := get_tree().current_scene
		if main_scene != null and main_scene.has_method("advance_week"):
			main_scene.advance_week()
		else:
			Global.current_week += 1
			Global.refresh_week_tag()
			Global.time = Global.max_time_per_week
	Global.notify_resources_changed()

	var ev: Dictionary = events_data.get(event_id, {})
	if ev.is_empty():
		return

	var choices: Dictionary = ev.get("choices", {})
	var choice: Dictionary = choices.get(choice_key, {})
	if choice.is_empty():
		return

	# Record treasure / clue
	if choice.get("treasure_found", false):
		var clue_id := str(ev.get("clue_id", ""))
		if clue_id != "" and not Global.unlocked_clues.has(clue_id):
			Global.unlocked_clues.append(clue_id)
			Global.clue_discovered.emit(clue_id)

	# Handle re-trigger flag
	if not choice.get("re_trigger", true):
		completed_events[event_id] = true

	# Handle trigger chance boost
	if choice.get("boost_trigger_chance", false):
		var current_boost: float = trigger_chance_boosts.get(event_id, 0.0)
		trigger_chance_boosts[event_id] = current_boost + TRIGGER_CHANCE_BOOST


# ─── Persistence ──────────────────────────────────────


## Returns a Dictionary that can be merged into the save file.
func get_save_data() -> Dictionary:
	return {
		"completed_events": completed_events.duplicate(),
		"trigger_chance_boosts": trigger_chance_boosts.duplicate()
	}


## Loads previously saved event state.
func load_save_data(data: Dictionary) -> void:
	if data.has("completed_events") and data["completed_events"] is Dictionary:
		completed_events = data["completed_events"]
	if data.has("trigger_chance_boosts") and data["trigger_chance_boosts"] is Dictionary:
		trigger_chance_boosts = data["trigger_chance_boosts"]
