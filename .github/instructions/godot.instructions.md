---
applyTo: "Godot_Game/anu-treasure-map/**/*.gd,Godot_Game/anu-treasure-map/**/*.tscn,Godot_Game/anu-treasure-map/**/*.tres,Godot_Game/anu-treasure-map/**/*.tscn.uid,Godot_Game/anu-treasure-map/**/*.json"
---

# Godot Project Instructions

Review these files using Godot Engine stable documentation as the primary source of truth.

## GDScript style and structure

- Assume Godot 4.x GDScript conventions.
- Prefer tabs for indentation in `.gd` files.
- Keep naming aligned with the Godot style guide.
- Favor readable typed code for exported vars, `@onready` vars, function parameters, and return values when typing improves clarity or CI safety.
- Watch for declaration-order problems that can trip `gdlint`, especially around exported vars, plain vars, constants, signals, enums, static vars, and `@onready` vars.

## Scene and resource safety

- Treat all file paths and `res://` references as case-sensitive.
- Flag renamed files, moved scenes, or path edits that may load on macOS but fail in Linux CI.
- Pay attention to whether packed scenes, textures, and JSON data still match the paths referenced in scripts and scenes.

## Scene lifecycle and UI flow

- Review `_ready()`, signal connections, and popup/UI flow with Godot scene lifecycle in mind.
- Prefer explicit, stable signal connections over hidden cross-scene coupling.
- Be careful with global state: it is acceptable for small shared navigation state, but call out growth that makes scene behavior harder to reason about.

## Data and content changes

- When JSON changes, check that scripts and scenes still agree on ids, keys, and expected data shape.
- Prefer separating content data from scene control logic.
- Flag missing or drifted content keys before suggesting stylistic refactors.

## CI behavior

- `gdformat` failures are formatting issues and should be described as mechanical fixes.
- `gdlint` failures should identify the specific rule and the smallest reasonable repair.
- Smoke-test risks should be called out when a change may stop scenes, resources, or startup scripts from loading in headless Godot.
