# Gameplay and Systems

Evidence baseline: repository branch `sprint6-evidence-docs`, TechLauncher delivery guide, and client-agreed team scope, verified 2026-05-05 14:01 AEST.

## Core Gameplay Loop

The current playable loop is:

1. Start the game.
2. Complete or encounter the onboarding/registration flow.
3. Explore the ANU campus map.
4. Select a reachable location marker.
5. Spend time to travel.
6. Enter a location screen.
7. Trigger a narrative event when the event conditions pass.
8. Choose an outcome.
9. Gain treasure/clue progress or miss the opportunity.
10. Continue exploring with updated time, location, and state.

The loop is intentionally compact. It is designed to prove the Week 1 delivery experience and show how Weeks 2-12 can repeat the same structure with more content.

## Week 1 Delivery Logic

The final delivery is anchored on Week 1 because the later weeks are designed as extensions of the same mechanism. The Week 1 build needs to prove the core system once:

- the start flow brings the player into the game
- the map lets the player move between campus nodes
- each playable node has at least one event or interaction
- events lead into choices and outcomes
- treasure outcomes can show treasure images
- collected treasure can be viewed through the treasure collection UI
- music/audio supports the experience
- progress state is stable enough for a stakeholder demo and future handover

## Player Resources

The current global state starts the player at:

- `current_week`: 1
- `max_week`: 16
- `time`: 8
- `max_time_per_week`: 8
- `money`: 50
- `travel_time_per_edge`: 1
- initial location: `chifley_marie_reay`

The client notes describe a move toward a simpler resource model. In the implementation, time is the important movement and event resource, while money remains part of the visible state.

## Map Movement

The map system loads `data/locations.json`, binds editor-placed location markers to location ids, and validates whether the selected target is active and reachable.

Travel time is calculated with breadth-first search across each location's `neighbors` list. Each edge costs `Global.travel_time_per_edge`, currently 1 time unit. This makes the map behave like a connected graph: a location is not just a picture on the screen, but a node whose neighbors control where the player can go next.

## Event Triggering

`EventManager` loads `data/events.json` and checks events when the player arrives at a location.

An event can trigger only when:

- the player has enough AP/time for the event cost
- the event is enabled
- the event's `location_id` matches the current location
- the event has not been completed with `re_trigger: false`
- any required time-of-day condition is satisfied
- the random trigger roll passes, unless clue ownership makes the event a guaranteed eligible pick

The default event AP cost is 2. Time phase is derived from remaining AP:

- AP 8-6: Morning
- AP 5: Midday
- AP 4-1: Afternoon

Yuki requires afternoon; the chess-board and kangaroo events do not.

## Choice Outcomes

Each event has choices. A choice can:

- mark a treasure as found
- add the event clue to `Global.unlocked_clues`
- prevent the event from triggering again
- allow the event to re-trigger later
- boost future trigger chance

Mechanically, this lets one encounter carry several story meanings. A "correct" choice can close the event as treasure found; a weaker choice can preserve the sense of a missed chance and keep the event alive.

## Save and Load

The global save file is written to `user://player_save.json`. It stores:

- player profile data
- current, selected, and player location ids
- week, week tag, time, max time, max week, and money
- unlocked clues
- event-manager state, including completed events and trigger-chance boosts

The implementation also normalizes older ids such as `lab_cafe` and `griffin_lake` into current location ids.

## Primary Evidence

- `Godot_Game/anu-treasure-map/systems/Script/main/main.gd`
- `Godot_Game/anu-treasure-map/systems/Script/map/map.gd`
- `Godot_Game/anu-treasure-map/systems/Script/autoloads/global.gd`
- `Godot_Game/anu-treasure-map/systems/Script/autoloads/event_manager.gd`
- `Godot_Game/anu-treasure-map/data/locations.json`
- `Godot_Game/anu-treasure-map/data/events.json`
