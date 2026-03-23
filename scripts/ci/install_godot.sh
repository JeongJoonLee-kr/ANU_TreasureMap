#!/usr/bin/env bash

set -euo pipefail

GODOT_VERSION="${GODOT_VERSION:-4.5-stable}"
CACHE_DIR="${RUNNER_TEMP:-/tmp}/godot-ci"
GODOT_DIR="$CACHE_DIR/godot"
TEMPLATES_DIR="$HOME/.local/share/godot/export_templates/${GODOT_VERSION}"

mkdir -p "$GODOT_DIR" "$TEMPLATES_DIR"

EDITOR_ZIP="Godot_v${GODOT_VERSION}_linux.x86_64.zip"
TEMPLATES_TPZ="Godot_v${GODOT_VERSION}_export_templates.tpz"
BASE_URL="https://github.com/godotengine/godot/releases/download/${GODOT_VERSION}"

curl -fsSL "${BASE_URL}/${EDITOR_ZIP}" -o "$CACHE_DIR/${EDITOR_ZIP}"
curl -fsSL "${BASE_URL}/${TEMPLATES_TPZ}" -o "$CACHE_DIR/${TEMPLATES_TPZ}"

python3 - <<'PY' "$CACHE_DIR" "$EDITOR_ZIP" "$TEMPLATES_TPZ" "$GODOT_DIR" "$TEMPLATES_DIR"
import shutil
import sys
from pathlib import Path
from zipfile import ZipFile

cache_dir = Path(sys.argv[1])
editor_zip = cache_dir / sys.argv[2]
templates_tpz = cache_dir / sys.argv[3]
godot_dir = Path(sys.argv[4])
templates_dir = Path(sys.argv[5])

with ZipFile(editor_zip) as archive:
    archive.extractall(godot_dir)

with ZipFile(templates_tpz) as archive:
    archive.extractall(cache_dir / "templates")

template_root = cache_dir / "templates" / "templates"
for item in template_root.iterdir():
    target = templates_dir / item.name
    if target.exists():
        if target.is_dir():
            shutil.rmtree(target)
        else:
            target.unlink()
    shutil.move(str(item), str(target))
PY

GODOT_BIN="$(find "$GODOT_DIR" -type f -name 'Godot_v*linux.x86_64' | head -n 1)"
chmod +x "$GODOT_BIN"
echo "GODOT_BIN=$GODOT_BIN" >> "$GITHUB_ENV"
