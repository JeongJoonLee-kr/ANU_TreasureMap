# Contributing Guide

This repository has two moving parts:

- Python map-processing utilities in the repository root.
- The playable Godot project in `Godot_Game/anu-treasure-map`.

The collaboration rules below are tuned for the Godot side first, because that is where scene, asset, and script consistency can quietly drift.

## Team Coding Rules

### 1. Work from small vertical slices

- Keep each pull request focused on one gameplay change, one UI change, or one data change.
- If a change touches scene logic and content data together, call that out in the PR description.
- Prefer one feature branch per task. Avoid mixing map-processing Python work with gameplay work unless the feature truly needs both.

### 2. Follow Godot's style guide, but make typing the default

- Follow the official GDScript style guide for naming, spacing, and script organization.
- Use static typing for exported values, local variables whose type is not obvious, function arguments, and return types.
- Prefer `:=` only when the inferred type is obvious on the same line.

Good:

```gdscript
@onready var back_button: Button = $Control/BackButton
var text_index: int = 0
```

Avoid:

```gdscript
@onready var back_button = $Control/BackButton
var data := load_some_unknown_resource()
```

### 3. Keep scene and resource paths Linux-safe

- Treat every path as case-sensitive.
- Use the exact file name in `res://` paths.
- Prefer lowercase snake_case for new `.gd`, `.tscn`, and folder names.
- Do not rename imported assets casually, because `.import` metadata and serialized scene paths can drift out of sync.

### 4. Separate logic from content data

- Put location text, titles, and image references in JSON or dedicated data files.
- Keep scene scripts focused on flow, state transitions, and UI wiring.
- When adding a location, update both `locations.json` and the scene or icon that opens it in the same PR.

### 5. Signals over hidden coupling

- Connect button and UI signals in `_ready()` unless a scene connection is already intentional and stable.
- Use `Global` sparingly. It is fine for cross-scene selection state, but avoid turning it into a dumping ground for unrelated game state.

### 6. Comments should explain intent, not narration

- Add comments for scene transitions, data loading assumptions, and layout math.
- Remove commented-out dead code before merging.
- If a workaround is required for engine behavior or CI, explain the reason in one line.

### 7. PR checklist

Before opening a PR:

- Run GDScript lint locally if possible.
- Validate JSON changes.
- Open the affected scenes in Godot and click through the changed flow.
- If you touched exported paths or file names, test on a case-sensitive path in CI or a Linux environment.

### Optional local pre-commit hook

To auto-format Godot scripts before every commit:

```bash
chmod +x scripts/git-hooks/pre-commit
ln -sf ../../scripts/git-hooks/pre-commit .git/hooks/pre-commit
```

The hook runs `gdformat Godot_Game/anu-treasure-map` and re-stages the formatted files.

If `gdformat` or `gdlint` is missing:

```bash
python3 -m pip install --user "gdtoolkit==4.*"
```

### Automatic formatting on pull requests

GitHub Actions also runs `gdformat` on pull requests that change `.gd` files.
If a contributor opens a PR without local formatting set up, the workflow may push a
small follow-up commit named `style: auto-format Godot scripts` to the same branch.

## GitHub CI Policy

This repository uses two CI layers for the Godot project:

- `lint`: GDScript style and JSON validation.
- `smoke-test`: Headless Godot checks that key scenes and data load correctly.

This is intentionally lighter than a full gameplay test harness. Right now the project has no dedicated unit test framework such as GUT or GdUnit4, so the smoke test acts as the first safety net.

## Recommended Next Step For Tests

When gameplay logic grows, add one of these:

- `GdUnit4` for unit and scene-driven tests inside Godot 4 projects.
- `GUT` if the team prefers a long-established Godot testing workflow.

Until then, keep reusable logic in smaller typed functions so it can be migrated into formal tests later without rewriting the whole scene.
