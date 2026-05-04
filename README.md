# ANU TreasureMap

ANU TreasureMap is a Godot-based proof-of-concept game about discovering hidden campus treasures through location-based exploration, branching narrative events, and future-player hints.

## Sprint 6 Focus

Sprint 6 narrowed the project into an evidence-backed playable vertical slice. The team treated the sprint as a recovery-and-quality sprint after Sprint 5 feedback by protecting a smaller Week 1 experience and making planning, execution, testing, and handover evidence visible.

The protected Sprint 6 outputs are:

- Start page and onboarding path for the Week 1 slice
- Campus map with active/inactive location markers
- Week 1 playable exploration loop
- Yuki branching event and treasure outcome
- UI readability and contrast improvements from client feedback
- External proof-of-concept testing plan and evidence capture
- GitHub/Jira documentation for Sprint 6 review and future handover

## Repository Map

- `Godot_Game/anu-treasure-map/` contains the Godot project.
- `Godot_Game/anu-treasure-map/data/events.json` stores branching event content such as Yuki, chess board, and kangaroo events.
- `Godot_Game/anu-treasure-map/data/locations.json` stores campus location data.
- `.github/workflows/godot-ci.yml` defines lint, formatting, location validation, Godot import, and smoke-test checks.
- `item/meeting/meeting_2026_sems1/` contains weekly team and stakeholder meeting evidence.
- `docs/` contains Sprint 6 evidence and handover documentation.

## Sprint 6 Evidence Docs

- [Sprint 6 Review Evidence](docs/sprint6-review-evidence.md)
- [Sprint 6 Handover](docs/sprint6-handover.md)
- [Testing and Demo Evidence](docs/testing-and-demo-evidence.md)

## Quality Workflow

The repository uses GitHub pull requests and GitHub Actions as execution evidence. The CI workflow checks Godot scripts with `gdlint`, formatting with `gdformat --check`, location-data validity through `scripts/ci/validate_locations.py`, and a headless Godot smoke test.

Pull requests should link the relevant Jira issue, state the evidence added, and include screenshots or video frames for UI/gameplay changes.

## Sprint 6 Review Status

This documentation was added so Sprint 6 can be assessed from the repository and final DOCX report without relying only on meeting memory. Jira remains the task-management source of truth, while GitHub provides version-control, implementation, CI, and handover evidence.
