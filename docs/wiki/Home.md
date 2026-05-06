# ANU TreasureMap Wiki

Evidence baseline: repository branch `sprint6-evidence-docs`, TechLauncher delivery guide, and client-agreed team scope, verified 2026-05-05 14:01 AEST.

ANU TreasureMap is a Godot 4.5 prototype about exploring the Australian National University campus, triggering location-based story events, and collecting treasures through player choices.

The semester final delivery was agreed with the clients, Susan and Thomas, as a playable experience from the start screen through Week 1. Week 2 through Week 12 are future extensions of the same Week 1 play logic, so the delivery emphasis is to make Week 1 complete, demonstrable, and easy to hand over.

## Start Here

- [Project Context](Project-Context) explains the product direction, final delivery scope, and client-feedback trail.
- [Final Delivery Scope](Final-Delivery-Scope) records the agreed final delivery requirements for this semester.
- [Gameplay and Systems](Gameplay-and-Systems) describes the current player loop and the Godot systems that support it.
- [Data and Content](Data-and-Content) documents locations, events, assets, and content-extension conventions.
- [Sprint 6 Evidence](Sprint-6-Evidence) maps review claims to repository evidence.
- [Handover Guide](Handover-Guide) lists the safest next steps for reviewers and future teams.

## Current Snapshot

| Area | Verified status |
| --- | --- |
| Engine | Godot 4.5 project under `Godot_Game/anu-treasure-map/` |
| Product scope | Client-agreed final delivery: start screen through playable Week 1 |
| Delivery requirement | each playable node has at least one event, with treasure UI, music, treasure images, and core game logic |
| Campus data | 19 active location entries in `data/locations.json` |
| Active treasure events | 11 enabled events in `data/events.json`, currently covering 8 location ids |
| Main systems | map movement, HUD resources, location screens, event triggering, save/load state |
| Quality workflow | GitHub Actions for lint, formatting, location-data validation, import, and smoke testing |
| Evidence still needed | final demo media, participant testing summary, final playable-node event coverage check, and any late meeting/testing notes |

## Source Trail

This wiki is grounded in the repository files listed below:

- `README.md`
- `TL26-S1-delivery-guide.docx`
- `docs/sprint6-review-evidence.md`
- `docs/sprint6-handover.md`
- `docs/testing-and-demo-evidence.md`
- `item/meeting/meeting_2026_sems1/stakeholder_meeting/W7_Client_meeting.md`
- `item/meeting/meeting_2026_sems1/stakeholder_meeting/W8_Client_meeting.md`
- `Godot_Game/anu-treasure-map/data/locations.json`
- `Godot_Game/anu-treasure-map/data/events.json`
- `Godot_Game/anu-treasure-map/systems/Script/`
- `.github/workflows/godot-ci.yml`
