# Final Delivery Scope

Evidence baseline: repository branch `sprint6-evidence-docs`, TechLauncher delivery guide, and client-agreed team scope, verified 2026-05-05 14:01 AEST.

## Delivery Context

TechLauncher Delivery runs through Weeks 10-12. The delivery phase is assessed through the delivery plan, delivery execution, stakeholder evaluation, handover materials, project closure, and the team's ability to communicate the final project outcome clearly.

For ANU TreasureMap, the final delivery scope was agreed with the project clients, Susan and Thomas. The team is not presenting a complete twelve-week game as the semester outcome. The agreed delivery is a polished playable Week 1 experience that proves the game loop and provides a maintainable base for future expansion.

## Agreed Semester Delivery

The final delivery target is:

> A playable ANU TreasureMap build from the start screen through Week 1, with the core exploration, event, treasure, UI, audio, and handover materials needed for stakeholders and future teams to understand the product.

Week 2 through Week 12 are treated as future extensions of the Week 1 logic. Because the same loop can be repeated with more locations, events, assets, and story content, the implementation priority is to make Week 1 complete, understandable, and demonstrable.

## Required Delivery Features

The agreed playable Week 1 delivery includes:

| Requirement | Meaning for delivery |
| --- | --- |
| Start screen | The player can enter the game from a clear opening flow. |
| Playable Week 1 | The player can complete the first week of the prototype experience. |
| Events on nodes | Each playable node should have at least one event or interaction target. |
| Treasure collection UI | The player can see collected treasure through a dedicated interface. |
| Music | The build includes audio that supports the playable experience. |
| Treasure images | Treasure outcomes have visual assets, not only text. |
| Core game logic | The map, travel/resource model, event triggering, choices, and progress state work together. |

## Why Week 1 Is The Delivery Anchor

Week 1 is the smallest complete form of the product. It proves the mechanism once: the player enters the game, moves through campus nodes, encounters events, makes choices, receives treasure feedback, and understands how future weeks would grow.

That makes Week 1 like the first working chapter of a book. It does not contain every later chapter, but it establishes the grammar: how the player moves, how events speak, how rewards appear, and how future content should be written.

## Delivery Success Criteria

The delivery should be judged by whether it can:

- demonstrate the agreed Week 1 player journey from start screen to playable exploration
- show that each playable node has at least one meaningful event or interaction
- show treasure collection and treasure images in the user interface
- use music or audio to support the build
- explain how Week 2-12 would repeat and extend the Week 1 logic
- provide clear handover documentation for future teams
- separate completed delivery features from future expansion work

## Current Evidence Coverage

The current repository evidence contains 19 active location entries and 11 enabled event records. Those enabled events currently cover 8 location ids. Before final submission, the team should either add events/interactions for the remaining Week 1 playable nodes or clearly mark any non-covered nodes as outside the final playable Week 1 path.

This check matters because the agreed delivery requirement is about the player experience, not only the data count. A location can appear in `locations.json`, but it only satisfies the delivery requirement if it is part of the playable Week 1 path and has a meaningful event or interaction.

## Out Of Scope For This Semester

The following are future expansion work, not final delivery requirements:

- fully implemented Week 2-12 content
- a complete twelve-week story arc
- production-scale event database
- every final campus location refinement
- large-scale public testing
- production release packaging beyond the agreed demonstration needs

## Primary Evidence

- `TL26-S1-delivery-guide.docx`
- client-agreed scope provided by the team for Susan and Thomas
- `README.md`
- `docs/sprint6-handover.md`
- `docs/sprint6-review-evidence.md`
- `Godot_Game/anu-treasure-map/data/events.json`
- `Godot_Game/anu-treasure-map/data/locations.json`
- `Godot_Game/anu-treasure-map/systems/Script/`
