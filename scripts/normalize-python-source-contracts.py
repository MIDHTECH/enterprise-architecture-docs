#!/usr/bin/env python3
"""Make planned Python module paths import-safe and entry-point contracts explicit."""

from collections import defaultdict
from pathlib import Path
import argparse
import re


ROOT = Path(__file__).resolve().parents[1]
USE_CASE_ROOT = ROOT / "docs/use-cases"

ENTRYPOINT_OVERRIDES = {
    "UC-CICD-016": "the `evaluate_release_contracts` contract evaluator",
    "UC-RSO-021": "the `evaluate_dependency_resilience` scenario evaluator",
}


def primary_implementation(text: str, page: Path) -> tuple[re.Match, str, str | None]:
    section = text.split("## Implementation design", 1)[1].split(
        "## Code and configuration map", 1
    )[0]
    match = re.search(
        r"^\| Primary implementation \| `([^`]+)`(?:; entry point: (.+?))? \|$",
        section,
        re.M,
    )
    if not match:
        raise SystemExit(f"{page}: missing primary implementation row")
    absolute_start = text.index(section) + match.start()
    absolute_end = text.index(section) + match.end()
    return re.match(r".*", text[absolute_start:absolute_end]), match.group(1), match.group(2)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--apply", action="store_true", help="write normalized Python contracts")
    parser.add_argument("--check", action="store_true", help="fail when Python contracts are invalid")
    args = parser.parse_args()
    if args.apply and args.check:
        raise SystemExit("Choose --apply or --check, not both")

    changes = []
    module_owners = {}
    entrypoint_owners = {}
    python_pages = 0
    for page in sorted(USE_CASE_ROOT.glob("*/UC-*.md")):
        text = page.read_text()
        use_case_id = re.match(r"(UC-[A-Z0-9]+-\d{3})", page.name).group(1)
        _, source_path, entrypoint_text = primary_implementation(text, page)
        if not source_path.endswith(".py"):
            continue
        python_pages += 1
        source = Path(source_path)
        desired_stem = source.stem.replace("-", "_")
        if not desired_stem.isidentifier():
            raise SystemExit(f"{page}: Python module stem {desired_stem!r} is not import-safe")
        desired_path = str(source.with_name(desired_stem + source.suffix))

        desired_entrypoint = entrypoint_text or ENTRYPOINT_OVERRIDES.get(use_case_id)
        if not desired_entrypoint:
            raise SystemExit(f"{page}: Python source lacks a documented entry point")
        symbols = re.findall(r"`([A-Za-z_][A-Za-z0-9_]*)`", desired_entrypoint)
        if len(symbols) != 1 or not symbols[0].isidentifier():
            raise SystemExit(
                f"{page}: Python entry-point description must name exactly one importable symbol"
            )
        entrypoint = symbols[0]

        repository_match = re.search(
            r"^\| Primary implementation repository \| `([^`]+)` \|$", text, re.M
        )
        if not repository_match:
            raise SystemExit(f"{page}: missing primary implementation repository")
        repository = repository_match.group(1)
        module_key = (repository, desired_path)
        entrypoint_key = (repository, entrypoint)
        if module_key in module_owners:
            raise SystemExit(
                f"{page}: Python module path duplicates {module_owners[module_key]}: {desired_path}"
            )
        if entrypoint_key in entrypoint_owners:
            raise SystemExit(
                f"{page}: Python entry point duplicates {entrypoint_owners[entrypoint_key]}: {entrypoint}"
            )
        module_owners[module_key] = use_case_id
        entrypoint_owners[entrypoint_key] = use_case_id

        desired_row = (
            f"| Primary implementation | `{desired_path}`; entry point: {desired_entrypoint} |"
        )
        current_row_pattern = re.compile(
            r"^\| Primary implementation \| `" + re.escape(source_path) + r"`(?:; entry point: .+?)? \|$",
            re.M,
        )
        matches = list(current_row_pattern.finditer(text))
        if len(matches) != 1:
            raise SystemExit(f"{page}: expected one exact primary implementation row")
        new_text = text[: matches[0].start()] + desired_row + text[matches[0].end() :]
        if new_text != text:
            changes.append((page, new_text))

    if args.check and changes:
        raise SystemExit(f"{len(changes)} Python source contracts require normalization")
    if args.apply:
        for page, new_text in changes:
            page.write_text(new_text)
        print(f"Normalized {len(changes)} Python source contracts.")
    else:
        print(
            f"Verified {python_pages} Python module paths and entry points; "
            f"pending normalization={len(changes)}."
        )


if __name__ == "__main__":
    main()
