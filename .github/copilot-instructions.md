# Copilot Repository Instructions

Use the Godot Engine stable documentation as the default reference point when reviewing this repository.
Prefer guidance that matches the Godot 4.x GDScript style guide, project organization guidance, static typing recommendations, and version control guidance.

## Review priorities

When reviewing pull requests in this repository, prioritize:

1. Runtime safety over style preferences.
2. Regressions that can break scene loading, resource loading, or map flow.
3. CI-breaking changes before optional refactors.
4. Suggestions that are realistic for a small student game project.

## Repository context

This repository has two parts:

- Python utilities in the repository root.
- The main Godot project in `Godot_Game/anu-treasure-map`.

For Godot files, prefer feedback that fits GDScript and Godot scene workflows instead of generic object-oriented advice.

## Godot review expectations

- Follow Godot's naming guidance: `snake_case` for functions and variables, `PascalCase` for class names, and `CONSTANT_CASE` for constants.
- Treat resource and scene paths as case-sensitive.
- Prefer stable node access, clear signal wiring, and safe scene transitions.
- Prefer typed GDScript where it improves readability and catches errors, but do not demand extra typing when the type is already obvious and the added annotation does not improve safety.
- Focus on scene lifecycle correctness around `_ready()`, signal connections, exported values, and `@onready` references.
- Flag changes that are likely to break headless CI, such as invalid `res://` paths, missing resources, or JSON/schema drift.

## CI-aware feedback

This repository uses:

- `gdformat` for GDScript formatting
- `gdlint` for lint rules
- a headless smoke test for core scene/data loading

If a change is formatting-only, prefer a short note instead of a deep design critique.
If a change is likely to fail CI, explain the most direct fix first.

## Tone

- Be concise and specific.
- Prefer actionable comments over broad style lectures.
- For low-confidence suggestions, say what assumption the suggestion depends on.
