#!/usr/bin/env python3
"""Normalize and verify each use case's planned implementation repository and artifacts."""

from pathlib import Path
import argparse
import re


ROOT = Path(__file__).resolve().parents[1]
USE_CASE_ROOT = ROOT / "docs/use-cases"

RESPONSIBILITIES = {
    "contract": lambda label: "allowlist" in label,
    "implementation": lambda label: label == "primary implementation",
    "schema": lambda label: "result schema" in label,
    "fixtures": lambda label: "fixtures" in label,
    "ci": lambda label: "gitlab" in label and ("gate" in label or "include" in label),
    "runbook": lambda label: "operator diagnosis and recovery" in label,
}


def implementation_rows(text: str, page: Path) -> dict[str, str]:
    section = text.split("## Implementation design", 1)[1].split(
        "## Code and configuration map", 1
    )[0]
    table_rows = []
    for line in section.splitlines():
        if not line.startswith("| ") or line.startswith("| ---"):
            continue
        cells = [cell.strip() for cell in line.strip("|").split("|")]
        if len(cells) != 2 or cells[0] == "Planned source responsibility":
            continue
        path_match = re.search(r"`(midhhealth/[^`]+)`", cells[1])
        if path_match:
            table_rows.append((cells[0].lower(), path_match.group(1)))

    result = {}
    for responsibility, matches in RESPONSIBILITIES.items():
        candidates = [path for label, path in table_rows if matches(label)]
        if len(candidates) != 1:
            raise SystemExit(
                f"{page}: expected one {responsibility} implementation row; found {len(candidates)}"
            )
        result[responsibility] = candidates[0]
    return result


def repository_from_contract(contract_path: str, page: Path) -> str:
    marker = "/contracts/"
    if marker not in contract_path:
        raise SystemExit(f"{page}: contract path lacks {marker}")
    return contract_path.split(marker, 1)[0]


def normalized_text(page: Path) -> tuple[str, dict[str, str]]:
    text = page.read_text()
    artifacts = implementation_rows(text, page)
    repository = repository_from_contract(artifacts["contract"], page)
    for responsibility, artifact in artifacts.items():
        if not (artifact == repository or artifact.startswith(repository + "/")):
            raise SystemExit(
                f"{page}: {responsibility} path {artifact!r} escapes implementation repository {repository!r}"
            )

    preferred = re.search(
        r"^\| Primary implementation repository \| `([^`]+)` \|$", text, re.M
    )
    legacy = re.search(r"^\| Primary GitLab repository \| `([^`]+)` \|$", text, re.M)
    if preferred and legacy:
        raise SystemExit(f"{page}: contains both primary repository field names")
    existing = preferred or legacy
    if existing and existing.group(1) != repository:
        raise SystemExit(
            f"{page}: recorded repository {existing.group(1)!r} does not match planned artifacts {repository!r}"
        )

    desired_row = f"| Primary implementation repository | `{repository}` |"
    if preferred:
        new_text = text
    elif legacy:
        new_text = text[: legacy.start()] + desired_row + text[legacy.end() :]
    else:
        support = re.search(r"^\| Supporting use cases \| .+ \|$", text, re.M)
        if not support:
            raise SystemExit(f"{page}: cannot place primary repository after supporting use cases")
        new_text = text[: support.end()] + "\n" + desired_row + text[support.end() :]
    return new_text, artifacts


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--apply", action="store_true", help="write normalized record fields")
    parser.add_argument("--check", action="store_true", help="fail when a page is not normalized")
    args = parser.parse_args()
    if args.apply and args.check:
        raise SystemExit("Choose --apply or --check, not both")

    changes = []
    artifact_owners = {}
    pages = sorted(USE_CASE_ROOT.glob("*/UC-*.md"))
    for page in pages:
        new_text, artifacts = normalized_text(page)
        if new_text != page.read_text():
            changes.append((page, new_text))
        use_case_id = re.match(r"(UC-[A-Z0-9]+-\d{3})", page.name).group(1)
        for responsibility, artifact in artifacts.items():
            if artifact in artifact_owners:
                raise SystemExit(
                    f"Planned artifact collision: {artifact} is owned by {artifact_owners[artifact]} and {use_case_id}"
                )
            artifact_owners[artifact] = use_case_id

    if args.check and changes:
        raise SystemExit(f"{len(changes)} use-case delivery records are not normalized")
    if args.apply:
        for page, new_text in changes:
            page.write_text(new_text)
        print(f"Normalized {len(changes)} use-case delivery records.")
    else:
        print(
            f"Verified {len(pages)} delivery records and {len(artifact_owners)} unique planned artifacts; "
            f"pending normalization={len(changes)}."
        )


if __name__ == "__main__":
    main()
