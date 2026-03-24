import json
from pathlib import Path


PROJECT_DIR = Path("Godot_Game/anu-treasure-map")
LOCATIONS_PATH = PROJECT_DIR / "data/locations.json"
REQUIRED_KEYS = {"title", "description", "image_path", "texts"}


def main() -> None:
    payload = json.loads(LOCATIONS_PATH.read_text(encoding="utf-8"))

    if not isinstance(payload, dict) or not payload:
        raise SystemExit("locations.json must contain at least one location object")

    seen_titles: set[str] = set()
    for location_id, location in payload.items():
        if not isinstance(location, dict):
            raise SystemExit(f"{location_id} must map to an object")

        missing = REQUIRED_KEYS - set(location)
        if missing:
            raise SystemExit(f"{location_id} is missing keys: {sorted(missing)}")

        if location_id != location_id.lower():
            raise SystemExit(f"{location_id} must be lowercase for stable icon lookup")

        title = location["title"]
        if not isinstance(title, str) or not title.strip():
            raise SystemExit(f"{location_id} title must be a non-empty string")
        if title in seen_titles:
            raise SystemExit(f"duplicate title found: {title}")
        seen_titles.add(title)

        image_path = location["image_path"]
        if not isinstance(image_path, str) or not image_path.startswith("res://"):
            raise SystemExit(f"{location_id} image_path must start with res://")

        asset_path = PROJECT_DIR / image_path.removeprefix("res://")
        if not asset_path.exists():
            raise SystemExit(f"{location_id} image_path does not exist: {image_path}")

        texts = location["texts"]
        if not isinstance(texts, list) or not texts:
            raise SystemExit(f"{location_id} texts must be a non-empty array")
        if any(not isinstance(text, str) or not text.strip() for text in texts):
            raise SystemExit(f"{location_id} texts must contain only non-empty strings")

    print(f"Validated {len(payload)} locations from {LOCATIONS_PATH}")


if __name__ == "__main__":
    main()
