# Handover Guide

Evidence baseline: repository branch `sprint6-evidence-docs`, TechLauncher delivery guide, and client-agreed team scope, verified 2026-05-05 14:01 AEST.

## For Reviewers

Start with the README, then read the Final Delivery Scope page, the Sprint 6 evidence register, and this wiki. The repository is organized so the evidence trail moves from product overview to delivery claims to implementation files.

Recommended review path:

1. Read `README.md`.
2. Read this wiki's `Final Delivery Scope` page.
3. Read `docs/sprint6-review-evidence.md`.
4. Read `docs/testing-and-demo-evidence.md`.
5. Run or inspect the Godot project at `Godot_Game/anu-treasure-map/project.godot`.
6. Check `data/events.json` for the enabled events.
7. Check `.github/workflows/godot-ci.yml` for automated quality gates.

## For Future Developers

Work from the existing data-first pattern. Locations and events are not hard-coded story fragments scattered across the project; they are structured data loaded by map and event systems.

Safest extension path:

1. Add or refine a location in `data/locations.json`.
2. Add matching marker behavior in the Godot map scene if a new location is needed.
3. Add a new event in `data/events.json`.
4. Add any treasure/location assets under `resources/`.
5. Test map reachability and event triggering in Godot.
6. Keep the PR tied to screenshots, test notes, or a Jira task.

## Carry-Forward Work

The verified carry-forward items are:

- full multi-week story expansion
- full Week 2-12 gameplay content
- larger event database
- deeper future-player hint mechanics
- production-level location accuracy review
- larger testing sample
- final poster, video, and showcase packaging
- final demo screenshots or video frames
- Week 9 or later testing/meeting evidence if available

These are not framed as Sprint 6 failures. They are the boundary stones of the vertical slice.

## Publishing and Maintenance

This wiki is based on repository branch `sprint6-evidence-docs`, the TechLauncher delivery guide, and client-agreed delivery scope for Susan and Thomas.

Before final assessment submission:

1. Add missing demo/testing evidence if the team has it.
2. Re-run relevant validation checks if Godot and Python dependencies are available.
3. Keep any new review claim tied to a repository file, meeting note, Jira issue, screenshot, or demo artifact.
4. Update this wiki when final demo media, external testing results, or late meeting notes are added.

## Primary Evidence

- `README.md`
- `docs/sprint6-handover.md`
- `docs/sprint6-review-evidence.md`
- `docs/testing-and-demo-evidence.md`
- `Godot_Game/anu-treasure-map/data/locations.json`
- `Godot_Game/anu-treasure-map/data/events.json`
- `.github/workflows/godot-ci.yml`
