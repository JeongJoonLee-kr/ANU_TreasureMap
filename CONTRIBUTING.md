# Contributing

## Local format check

Before opening a PR, run:

```bash
gdformat Godot_Game/anu-treasure-map
gdlint Godot_Game/anu-treasure-map
```

If `gdformat` or `gdlint` is missing:

```bash
python3 -m pip install --user "gdtoolkit==4.*"
```

## Optional pre-commit hook

To auto-format Godot scripts before every commit:

```bash
chmod +x scripts/git-hooks/pre-commit
ln -sf ../../scripts/git-hooks/pre-commit .git/hooks/pre-commit
```

The hook runs `gdformat Godot_Game/anu-treasure-map` and re-stages the formatted files.
