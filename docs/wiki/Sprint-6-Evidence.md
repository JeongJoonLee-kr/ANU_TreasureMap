# Sprint 6 Evidence

Evidence baseline: repository branch `sprint6-evidence-docs`, TechLauncher delivery guide, and client-agreed team scope, verified 2026-05-05 14:01 AEST.

## Review Claim Boundaries

This page separates evidence-backed claims from evidence still needed. It should be used when preparing the final report, final delivery materials, PR description, or showcase script.

The safe claim is:

> The semester final delivery is a client-agreed playable Week 1 experience that proves ANU TreasureMap's repeatable core loop and documents the remaining concept depth for future handover.

The unsafe claim is:

> The team completed all Week 1-12 gameplay content.

The evidence supports the first claim, not the second.

## Evidence Map

| Claim | Evidence | Status |
| --- | --- | --- |
| The project is a Godot prototype for campus exploration | `README.md`, Godot project files | Verified |
| Sprint 6 is a Week 1 vertical slice / proof of concept | Week 7/8 client notes, Sprint 6 docs | Verified |
| Final delivery is start screen through playable Week 1 | client-agreed scope supplied by the team | Verified as team-provided delivery context |
| Week 2-12 are future extensions of Week 1 logic | client-agreed scope supplied by the team | Verified as team-provided delivery context |
| Final delivery requires events on playable nodes, treasure UI, music, treasure images, and core logic | client-agreed scope supplied by the team | Verified as team-provided delivery context |
| The prototype uses campus locations and map movement | `locations.json`, `map.gd`, location marker scenes | Verified |
| The prototype contains enabled branching treasure events | `events.json`, `event_manager.gd` | Verified; 11 enabled event records |
| Enabled events currently cover 8 location ids | `events.json`, `locations.json` | Verified |
| Every final Week 1 playable node has an event or interaction | `events.json`, final playable path definition | Needs final coverage check |
| Location data has automated validation | `.github/workflows/godot-ci.yml`, `scripts/ci/validate_locations.py` | Verified |
| CI includes Godot import and smoke-test jobs | `.github/workflows/godot-ci.yml`, `tests/ci/smoke_test.gd` | Verified |
| UI readability work was driven by client feedback | Week 7/8 client notes, README, Sprint 6 evidence register | Verified at documentation level |
| Final demo screenshots/video exist | not present in tracked repository evidence checked here | Needs team evidence |
| External testing participant results exist | not present in tracked repository evidence checked here | Needs team evidence |

## Evidence To Capture Before Final Submission

The current repository docs already identify evidence gaps. Do not invent these items.

Capture or attach:

- start page screenshot
- onboarding or registration screenshot
- Week 1 campus map screenshot
- active/inactive location-marker screenshot
- playable-node event coverage screenshot, table, or test note
- Yuki introduction screenshot
- Yuki choice screenshot
- treasure-found outcome screenshot
- missed-opportunity or hint outcome screenshot, if available
- participant count
- testing date or week
- tester device/environment
- task flow used
- key onboarding observations
- key map/event understanding observations
- readability findings
- bugs or blockers
- Jira follow-up issues created

## Suggested Review Narrative

Use a short evidence-led structure:

1. Context: ANU TreasureMap is a campus exploration game prototype.
2. Delivery agreement: the clients and team set final delivery as start screen through playable Week 1.
3. Product: the current build should prove map movement, node events, treasure UI/images, music, event triggering, and core progression logic.
4. Scope logic: Weeks 2-12 repeat and extend the Week 1 loop, so they are future content expansion rather than this semester's implementation target.
5. Process: Sprint 6 ties implementation, client feedback, CI, and documentation into one evidence trail.
6. Handover: the team leaves future story expansion, testing expansion, and showcase packaging as explicit next steps.

## Primary Evidence

- `docs/sprint6-review-evidence.md`
- `TL26-S1-delivery-guide.docx`
- `docs/testing-and-demo-evidence.md`
- `docs/sprint6-handover.md`
- `.github/workflows/godot-ci.yml`
- `scripts/ci/validate_locations.py`
- `Godot_Game/anu-treasure-map/tests/ci/smoke_test.gd`
- `item/meeting/meeting_2026_sems1/stakeholder_meeting/W7_Client_meeting.md`
- `item/meeting/meeting_2026_sems1/stakeholder_meeting/W8_Client_meeting.md`
