# Event Dialogue System — Technical Documentation

## Overview

Random narrative events trigger when the player arrives at specific locations. Each event presents a story followed by three branching choices that determine whether the player discovers a treasure.

## System Architecture

- **Data**: `res://data/events.json` — All event definitions (narrative, choices, outcomes)
- **Logic**: `EventManager` autoload (`res://systems/Script/autoloads/event_manager.gd`)
- **UI**: `RandomEventPanel` (`res://random_event_panel.tscn` + `res://systems/Script/ui/random_event_panel.gd`)
- **Integration**: `locations.gd` calls `EventManager.try_trigger_event()` on location arrival

## Virtual Clock

Action Points (AP) map to time-of-day phases:

| AP Range | Phase     | Clock Equivalent |
|----------|-----------|------------------|
| 8–6      | Morning   | 9 AM – 11 AM    |
| 5        | Midday    | 12 PM            |
| 4–1      | Afternoon | 1 PM – 4 PM     |

## Event Cost

All events cost **2 AP**. If `current_ap < 2`, the event cannot trigger and the player sees:
> "It's getting late and you're exhausted. You should head back and rest. Try exploring again tomorrow."

## Trigger Logic

1. Player arrives at a location.
2. System filters events by `location_id` and `enabled` status.
3. Time-of-day gate checked (e.g., Yuki requires Afternoon).
4. Clue-based probability:
   - No related clue → Roll against `base_trigger_chance` (30%).
   - Has related clue but other options exist → Random pick among all eligible.
   - Has related clue, no alternatives → Guaranteed trigger.
5. Choice C with `boost_trigger_chance` adds +15% to future rolls.

---

## Events

### Korean ANU Event Dialogue Drafts
- **Status**: Draft content for future conversion into `data/events.json`
- **File**: `res://resources/narrative/anu_event_dialogue_drafts_ko.md`
- **Assets**: Includes staged 16:9 event image sequences for `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event` and 1:1 treasure prompts for `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/treasure`.
- **Coverage**: Student Accommodation basketball court, Wamburun/Ursula free food, Bruce Hall lemon tree rumour, Board Games Society, CSIT escape room, ANU Sport/North Oval, Chifley Library, and Copland-to-Subway campus lunch route.

### Yuki the White Dog
- **Location**: `bruce_hall`
- **Time Requirement**: Afternoon only
- **Clue ID**: `clue_yuki`
- **Choice A** → Treasure found (Yuki the White Dog), no re-trigger
- **Choice B** → No treasure, can re-trigger
- **Choice C** → No treasure, can re-trigger, +15% future chance

### The Giant Chess Board
- **Location**: `chifley_marie_reay`
- **Time Requirement**: None
- **Clue ID**: `clue_chess_board`
- **Choice A** → Treasure found (The Giant Chess Board), no re-trigger
- **Choice B** → No treasure, can re-trigger
- **Choice C** → No treasure, can re-trigger

### The Kangaroo
- **Location**: `bruce_hall`
- **Time Requirement**: None
- **Clue ID**: `clue_kangaroo`
- **Choice A** → Treasure found (The Kangaroo), no re-trigger
- **Choice B** → No treasure, can re-trigger
- **Choice C** → No treasure, can re-trigger

### Lotus Lantern (Stub)
- **Status**: Disabled — awaiting content

### Trophy (Stub)
- **Status**: Disabled — awaiting content

## Adding New Events

1. Add a new entry to `data/events.json` with a unique `id`.
2. Set `enabled: true` and fill in `location_id`, `narrative`, and `choices`.
3. Place a treasure image at `res://resources/treasure/treasure_<id>.png`.
4. No code changes required.
