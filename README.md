# ANU TreasureMap

ANU TreasureMap is a Godot prototype game about exploring the Australian National University campus, discovering location-based events, and deciding how to use the treasures and hints found along the way.

The project presents ANU as a playable campus map rather than a static guide. Players move through recognisable campus regions, trigger narrative encounters, collect clues or treasures, and make small choices that shape how the exploration story unfolds.

## Game Concept

ANU TreasureMap is designed around three linked ideas:

- **Campus exploration:** the map is divided into ANU location areas with active and inactive markers.
- **Narrative discovery:** locations can trigger short story events, including character encounters such as Yuki.
- **Future-player hints:** players can choose whether to keep value for themselves or leave useful information for later players.

The current prototype focuses on a contained Week 1 experience so the core loop can be understood, tested, and extended by future contributors.

## Core Gameplay Loop

1. Start the game and follow the onboarding flow.
2. Explore the ANU campus map.
3. Select available location markers.
4. Trigger a narrative event or discovery.
5. Make a choice, such as collecting treasure or leaving a hint.
6. Continue exploring with updated context and progress.

## Current Prototype Features

- Godot 4.5 project with a playable main scene.
- ANU campus map and location marker system.
- Active/inactive region selection for the prototype slice.
- Branching event data stored in JSON.
- Yuki event and treasure artwork.
- Phone-style interface elements and UI assets.
- UI readability, font-size, and layout adjustments from client feedback.
- GitHub Actions workflow for Godot linting, formatting, data validation, import, and smoke testing on relevant code/data/workflow paths.

## Project Structure

- `Godot_Game/anu-treasure-map/` - Godot project root.
- `Godot_Game/anu-treasure-map/project.godot` - Godot project configuration.
- `Godot_Game/anu-treasure-map/main.tscn` - main scene entry point.
- `Godot_Game/anu-treasure-map/data/events.json` - branching event content.
- `Godot_Game/anu-treasure-map/data/locations.json` - campus location data.
- `Godot_Game/anu-treasure-map/systems/Script/` - gameplay, UI, map, and autoload scripts.
- `Godot_Game/anu-treasure-map/resources/` - map, location, UI, icon, font, and treasure assets.
- `Godot_Game/anu-treasure-map/tests/ci/` - CI smoke test scripts.
- `scripts/ci/` - repository-level CI helper scripts.
- `item/meeting/meeting_2026_sems1/` - team and stakeholder meeting records.
- `docs/` - project handover and sprint-review evidence documents.

## Running the Game Locally

1. Install Godot 4.5 or a compatible Godot 4.x version.
2. Open Godot and import the project at `Godot_Game/anu-treasure-map/project.godot`.
3. Run the configured main scene.

The project configuration currently names the project `ANU_Treasure_Map` and points the run configuration at the main scene registered in `project.godot`.

## Development Workflow

Use pull requests for gameplay, UI, content, data, and documentation changes. Pull requests should link the relevant Jira issue and state the evidence added. UI/gameplay changes should include screenshots, video frames, or concise test notes so reviewers can understand the impact without running the project immediately. Documentation-only changes should be reviewed through the pull request discussion because they may not trigger the current path-filtered CI workflow.

The CI workflow checks relevant Godot/code/data paths with:

- GDScript linting through `gdlint`.
- Formatting through `gdformat --check`.
- Location-data validation through `scripts/ci/validate_locations.py`.
- Headless Godot import and smoke testing.

## Project Documentation

- [Sprint 6 Review Evidence](docs/sprint6-review-evidence.md) records the assessment evidence trail.
- [Sprint 6 Handover](docs/sprint6-handover.md) summarises current scope and next-team guidance.
- [Testing and Demo Evidence](docs/testing-and-demo-evidence.md) lists the demo and testing material expected for final review.

These documents support review and handover. The README itself is intended as the game-facing entry point for the repository.
