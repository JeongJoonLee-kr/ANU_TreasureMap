# Data and Content

Evidence baseline: repository branch `sprint6-evidence-docs`, TechLauncher delivery guide, and client-agreed team scope, verified 2026-05-05 14:01 AEST.

## Location Data

The current location database is `Godot_Game/anu-treasure-map/data/locations.json`.

Verified snapshot:

- 19 location entries
- 19 active location entries
- 11 enabled event records
- enabled events currently cover 8 location ids
- each location uses a stable lowercase id
- each location stores title, map label, active flag, description, image path, text snippets, and neighbor ids

The map treats this file as a graph. A location's `neighbors` list defines possible travel routes. If a location is inactive, the map system does not allow travel to it.

For final delivery, every playable node should have at least one event or interaction target. This is the content rule that turns the map from a navigation screen into a playable Week 1 experience.

## Active Locations

The current active location ids are:

- `student_accommodation`
- `wamburun_halls_ursula_hall`
- `bruce_hall`
- `central_studying_area`
- `csit_engn_area`
- `anu_sports_north_oval`
- `medical_physics_school`
- `south_oval`
- `blocks`
- `houses`
- `southwest`
- `central`
- `fellows_oval`
- `chifley_marie_reay`
- `fenner_hall`
- `copland`
- `lodges`
- `city`
- `art_and_music`

## Event Data

The current event database is `Godot_Game/anu-treasure-map/data/events.json`.

Verified enabled events:

| Event id | Title | Location | Requires afternoon | Treasure image |
| --- | --- | --- | --- | --- |
| `yuki` | Yuki the White Dog | `bruce_hall` | yes | `res://resources/treasure/treasure_yuki.png` |
| `chess_board` | The Giant Chess Board | `chifley_marie_reay` | no | `res://resources/treasure/treasure_chessboard.png` |
| `kangaroo` | The Kangaroo | `bruce_hall` | no | `res://resources/treasure/treasure_kangaroo.png` |
| `student_accommodation_basketball_court` | The Fourth Player | `student_accommodation` | no | `res://resources/treasure/treasure_basketball_court.png` |
| `wamburun_ursula_free_food` | Food That Finds People | `wamburun_halls_ursula_hall` | no | `res://resources/treasure/treasure_free_food.png` |
| `bruce_hall_lemon_tree` | The Lemon Tree Rumour | `bruce_hall` | no | `res://resources/treasure/treasure_lemon_tree.png` |
| `central_studying_area_board_games_society` | One More Turn | `central_studying_area` | no | `res://resources/treasure/treasure_board_games_society.png` |
| `csit_engn_escape_room` | The Sixty-Minute Room | `csit_engn_area` | no | `res://resources/treasure/treasure_escape_room.png` |
| `anu_sport_north_oval_anu_sport` | Three Ways Onto the Field | `anu_sports_north_oval` | no | `res://resources/treasure/treasure_anu_sport.png` |
| `chifley_marie_reay_chifley_library` | The Notebook Map | `chifley_marie_reay` | no | `res://resources/treasure/treasure_chifley_library.png` |
| `copland_subway` | The Lunch Route | `copland` | no | `res://resources/treasure/treasure_subway.png` |

Disabled placeholder events:

- `lotus_lantern`
- `trophy`

## Event Coverage Check

Enabled events currently cover these location ids:

- `student_accommodation`
- `wamburun_halls_ursula_hall`
- `bruce_hall`
- `central_studying_area`
- `csit_engn_area`
- `anu_sports_north_oval`
- `chifley_marie_reay`
- `copland`

The following active location ids still need a final-delivery decision. If they remain part of the playable Week 1 path, they need at least one event or interaction. If they are not part of the Week 1 delivery path, mark that clearly in the delivery narrative.

- `medical_physics_school`
- `south_oval`
- `blocks`
- `houses`
- `southwest`
- `central`
- `fellows_oval`
- `fenner_hall`
- `lodges`
- `city`
- `art_and_music`

## Event Content Pattern

An event entry should include:

- `id`
- `title`
- `location_id`
- `require_afternoon`
- `base_trigger_chance`
- `clue_id`
- `enabled`
- `treasure_image_path`
- `narrative`
- `choices`

Each choice should define the label, outcome text, whether treasure is found, the treasure name, and whether the event can re-trigger.

## Adding a Location

Use the Godot project README as the local convention:

1. Add a background image under `res://resources/Location/`.
2. Add an entry to `data/locations.json`.
3. Make sure the location id matches the relevant map marker id.
4. Include required fields checked by `scripts/ci/validate_locations.py`.
5. Confirm the referenced image path exists.

## Adding an Event

The safest path is to copy the shape of an existing enabled event, then change the id, title, location, clue, narrative, choices, and treasure asset.

Before review, check:

- the target `location_id` exists in `locations.json`
- the event is marked `enabled: true` only when ready
- every final-delivery playable node has at least one event or interaction
- the treasure image path exists
- every choice has a clear outcome
- `re_trigger` matches the intended design
- the event can be reached within the current time/AP model

## Primary Evidence

- `Godot_Game/anu-treasure-map/README.md`
- `Godot_Game/anu-treasure-map/data/locations.json`
- `Godot_Game/anu-treasure-map/data/events.json`
- `Godot_Game/anu-treasure-map/resources/Location/`
- `Godot_Game/anu-treasure-map/resources/treasure/`
- `scripts/ci/validate_locations.py`
