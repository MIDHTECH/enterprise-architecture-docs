#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

briefing="docs/new-employee-platform-briefing.md"
bank="docs/use-case-interview-question-bank.md"

test -f "$briefing"
test -f "$bank"

./scripts/generate-use-case-interview-bank.py --check

required_briefing_sections=(
  "## About this reference organization"
  "## Business users and journeys"
  "## Architecture goals"
  "## Architecture at a glance"
  "## The reference application estate"
  "## Platform foundation"
  "## Environment model"
  "## The short explanation"
  "## Worked scenario 1: release an application"
  "## Worked scenario 2: exchange provider or payer data"
  "## Worked scenario 3: investigate a service outage"
  "## Worked scenario 4: evaluate an AI workflow"
  "## The twelve domains in plain language"
  "## Important architecture decisions"
  "## What is real today and what is still a design"
  "## How to explain your contribution honestly"
  "## A useful interview answer shape"
  "## A new employee's first-week tour"
)

for heading in "${required_briefing_sections[@]}"; do
  grep -Fqx "$heading" "$briefing" || {
    echo "$briefing: missing $heading" >&2
    exit 1
  }
done

python3 - "$ROOT_DIR" <<'PY'
from collections import Counter
from pathlib import Path
import re
import sys

root = Path(sys.argv[1])
bank = (root / "docs/use-case-interview-question-bank.md").read_text()
documents = sorted((root / "docs/use-cases").glob("*/UC-*.md"))

expected = {}
for document in documents:
    match = re.match(r"(UC-[A-Z0-9]+-\d{3})", document.name)
    expected[match.group(1)] = document.relative_to(root / "docs").as_posix()

linked = re.findall(
    r"\[(UC-[A-Z0-9]+-\d{3}): [^]]+\]\((use-cases/[^)]+\.md)\)", bank
)
counts = Counter(use_case_id for use_case_id, _ in linked)
primary_questions = re.findall(
    r"^\| \[UC-[A-Z0-9]+-\d{3}: [^]]+\]\([^)]+\) \| (.+?) \| .+ \|$",
    bank,
    re.M,
)

missing = sorted(set(expected) - set(counts))
extra = sorted(set(counts) - set(expected))
duplicates = sorted(use_case_id for use_case_id, count in counts.items() if count != 1)
wrong_paths = sorted(
    (use_case_id, path, expected.get(use_case_id))
    for use_case_id, path in linked
    if expected.get(use_case_id) != path
)

if missing or extra or duplicates or wrong_paths:
    raise SystemExit(
        f"Interview-bank coverage failed: missing={missing}, extra={extra}, "
        f"duplicates={duplicates}, wrong_paths={wrong_paths}"
    )

if len(linked) != len(documents):
    raise SystemExit(
        f"Interview-bank count {len(linked)} does not match detailed-page count {len(documents)}"
    )
if len(primary_questions) != len(documents) or len(set(primary_questions)) != len(documents):
    raise SystemExit(
        "Interview bank must contain one distinct context-derived primary question per use case"
    )

platform_links = re.findall(
    r"^Platform detail: \[[^]]+\]\((projects/[^)]+\.md)\)$", bank, re.M
)
if len(platform_links) != 12 or len(set(platform_links)) != 12:
    raise SystemExit(
        f"Interview bank must link 12 unique platform pages; found {platform_links}"
    )
for link in platform_links:
    if not (root / "docs" / link).is_file():
        raise SystemExit(f"Interview bank links missing platform page: {link}")

if bank.count("### Platform questions") != 12:
    raise SystemExit("Interview bank must contain platform-level questions for all 12 domains")

print(
    f"Onboarding and interview documentation validation passed "
    f"({len(linked)} use-case questions)."
)
PY
