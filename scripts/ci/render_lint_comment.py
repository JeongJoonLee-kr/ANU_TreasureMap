#!/usr/bin/env python3

from __future__ import annotations

import argparse
import os
import re
from pathlib import Path


MARKER = "<!-- godot-lint-comment -->"

GDLINT_PATTERN = re.compile(
    r"^(?P<file>.+?):(?P<line>\d+): Error: (?P<message>.+?) \((?P<rule>[^()]+)\)$"
)


RULE_GUIDANCE = {
    "class-definitions-order": "Move declarations into the expected order. In this repo we keep exported/public vars before `@onready` vars, and helper comments/functions after declarations.",
    "trailing-whitespace": "Remove the extra spaces at the end of the line.",
    "mixed-tabs-and-spaces": "Use tabs consistently for GDScript indentation.",
    "tab-characters": "Indent GDScript with tabs instead of spaces.",
}


def read_text(path: str | None) -> str:
    if not path:
        return ""
    file_path = Path(path)
    if not file_path.exists():
        return ""
    return file_path.read_text(encoding="utf-8").strip()


def parse_gdlint(text: str) -> list[str]:
    issues: list[str] = []
    for line in text.splitlines():
        match = GDLINT_PATTERN.match(line.strip())
        if not match:
            continue
        file_path = match.group("file")
        line_no = match.group("line")
        message = match.group("message")
        rule = match.group("rule")
        guidance = RULE_GUIDANCE.get(rule, "Adjust the code at this location to satisfy the reported rule.")
        issues.append(f"- `{file_path}:{line_no}` `{rule}`: {message}. {guidance}")
    return issues


def parse_gdformat(text: str) -> list[str]:
    issues: list[str] = []
    for line in text.splitlines():
        stripped = line.strip()
        if stripped.startswith("would reformat "):
            file_path = stripped.removeprefix("would reformat ").strip()
            issues.append(
                f"- `{file_path}`: formatting differs from the repo standard. Run `gdformat Godot_Game/anu-treasure-map` or let the auto-format workflow update the branch."
            )
    return issues


def parse_validation(text: str) -> list[str]:
    issues: list[str] = []
    for line in text.splitlines():
        stripped = line.strip()
        if stripped and not stripped.startswith("Validated "):
            issues.append(f"- `{stripped}`")
    return issues


def build_comment(gdlint_text: str, gdformat_text: str, validate_text: str) -> str:
    sections: list[str] = [MARKER, "## CI lint feedback"]

    gdlint_issues = parse_gdlint(gdlint_text)
    gdformat_issues = parse_gdformat(gdformat_text)
    validation_issues = parse_validation(validate_text)

    if gdlint_issues:
        sections.append("### gdlint")
        sections.extend(gdlint_issues)

    if gdformat_issues:
        sections.append("### gdformat")
        sections.extend(gdformat_issues)

    if validation_issues:
        sections.append("### data validation")
        sections.extend(validation_issues)

    if len(sections) == 2:
        sections.append("No lint issues were found.")

    sections.append("")
    sections.append("### Quick fix")
    sections.append("- For formatting-only failures, run `gdformat Godot_Game/anu-treasure-map` locally.")
    sections.append("- If you do not have local tooling, the `godot-autoformat` workflow can add a formatting commit for `.gd` files.")
    return "\n".join(sections)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--gdlint")
    parser.add_argument("--gdformat")
    parser.add_argument("--validate")
    parser.add_argument("--output")
    args = parser.parse_args()

    body = build_comment(
        read_text(args.gdlint),
        read_text(args.gdformat),
        read_text(args.validate),
    )

    output = args.output or os.environ.get("GITHUB_OUTPUT")
    if output:
        with open(output, "a", encoding="utf-8") as fh:
            fh.write(f"body<<EOF\n{body}\nEOF\n")
    else:
        print(body)


if __name__ == "__main__":
    main()
