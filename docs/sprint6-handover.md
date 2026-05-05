# Sprint 6 Handover Notes

This handover explains what Sprint 6 leaves behind for reviewers and future teams.

## Current Product Shape

ANU TreasureMap is now framed as a playable proof of concept rather than a complete twelve-week game. The Sprint 6 slice focuses on proving the core loop:

1. Start the player in a familiar ANU context.
2. Let the player explore map regions.
3. Trigger location-linked narrative events.
4. Let player choices lead to treasure, missed opportunities, or future hints.
5. Record the concept depth and future expansion plan for later teams.

## Key Implementation Evidence

- `Godot_Game/anu-treasure-map/data/events.json` contains enabled branching events, including Yuki the White Dog.
- `Godot_Game/anu-treasure-map/systems/Script/autoloads/event_manager.gd` handles event eligibility, time phases, AP cost, clues, re-trigger flags, and completion.
- `Godot_Game/anu-treasure-map/data/locations.json` keeps location metadata and image references.
- `.github/workflows/godot-ci.yml` defines automated lint, formatting, location validation, Godot import, and smoke-test checks for relevant code/data/workflow paths.

## Design Decisions From Client Meetings

- Deliver a high-quality Week 1 vertical slice rather than a full game.
- Treat the scope change as a negotiated client-supported pivot.
- Improve contrast, font size, and visual readability for a quick glasses-off test.
- Use a scripted or guided happy path so testers see the intended treasure-hunting loop.
- Prepare the poster and pitch as a vision-led story, similar to a startup pitch.
- Preserve future work in concept documentation so the project can be continued.

## Known Carry-Forward Items

These are handover items, not Sprint 6 failures:

- Full multi-week story expansion
- More complete event database
- Production-ready location accuracy review
- Larger participant testing sample
- Final poster/video/showcase packaging
- Full implementation of future-player hint data beyond the proof-of-concept slice

## Recommended Next Steps

- Keep the game README, Sprint 6 evidence notes, and report materials easy to find in the project documentation set.
- Add final demo screenshots or video frames to the Sprint 6 report evidence pack.
- Attach Week 9 testing findings to Jira and the final DOCX.
- Use the event data format in `events.json` as the template for new treasures.
- Keep new feature work tied to Jira issues and PR evidence.
