#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

USE_CASE_FILES=()
while IFS= read -r line; do
  USE_CASE_FILES+=("$line")
done < <(find docs/use-cases -type f -name 'UC-*.md' -print | sort)

if [[ "${#USE_CASE_FILES[@]}" -eq 0 ]]; then
  echo "No detailed use-case documents found." >&2
  exit 1
fi

required_headings=(
  "## Purpose"
  "## Expected outcome"
  "## Trigger and actors"
  "## Preconditions"
  "## Scope and exclusions"
  "## Code and configuration map"
  "## Jira breakdown"
  "## Evidence and screenshot register"
  "## Expected versus current result"
  "## Acceptance decision"
)

for document in "${USE_CASE_FILES[@]}"; do
  for heading in "${required_headings[@]}"; do
    if ! grep -Fqx "$heading" "$document"; then
      echo "$document: missing required heading: $heading" >&2
      exit 1
    fi
  done

  story_count="$(grep -c '^### STORY-' "$document" || true)"
  if [[ "$story_count" -lt 1 ]]; then
    echo "$document: must contain at least one Jira story." >&2
    exit 1
  fi

  awk -v document="$document" '
    BEGIN {
      fields[1] = "**Description:**"
      fields[2] = "**Status:**"
      fields[3] = "**Acceptance criteria:**"
      fields[4] = "**Implementation steps:**"
      fields[5] = "**Completed work:**"
      fields[6] = "**Validation and rollback:**"
      fields[7] = "**Required attachments:**"
      field_count = 7
    }
    function check_story(    field_number) {
      if (story == "") return
      for (field_number = 1; field_number <= field_count; field_number++) {
        if (index(section, fields[field_number]) == 0) {
          printf "%s: %s missing story field %s\n", document, story, fields[field_number] > "/dev/stderr"
          failed = 1
        }
      }
    }
    /^### STORY-/ {
      check_story()
      story = $0
      section = ""
      next
    }
    /^### / || /^## / {
      if (story != "") {
        check_story()
        story = ""
        section = ""
      }
      next
    }
    story != "" { section = section "\n" $0 }
    END {
      check_story()
      exit failed
    }
  ' "$document"
done

LINUX_USE_CASE_FILES=()
while IFS= read -r line; do
  LINUX_USE_CASE_FILES+=("$line")
done < <(find docs/use-cases/linux -type f -name 'UC-LNX-*.md' -print | sort)

portfolio="docs/enterprise-project-portfolio-and-usecases.md"
declared_linux_count="$({
  awk -F'|' '/^\| 6\. Linux Systems Engineering \| [0-9]+ \|$/ { print $3 }' "$portfolio"
} | tr -d ' ')"

if [[ "${#LINUX_USE_CASE_FILES[@]}" -ne "$declared_linux_count" ]]; then
  echo "Linux detail-page count ${#LINUX_USE_CASE_FILES[@]} does not match canonical count $declared_linux_count." >&2
  exit 1
fi

linux_required_headings=(
  "## Architecture diagram"
  "## IaC delivery model"
  "## End-to-end implementation"
  "## Validation, idempotence, and rollback"
  "## Troubleshooting guide"
  "## Interview preparation"
)

LINUX_ARCHITECTURE_FILES=()
while IFS= read -r line; do
  LINUX_ARCHITECTURE_FILES+=("$line")
done < <(find docs/assets/use-cases -type f -name 'UC-LNX-*-architecture.svg' -print | sort)

if [[ "${#LINUX_ARCHITECTURE_FILES[@]}" -ne "$declared_linux_count" ]]; then
  echo "Linux architecture count ${#LINUX_ARCHITECTURE_FILES[@]} does not match canonical count $declared_linux_count." >&2
  exit 1
fi

for document in "${LINUX_USE_CASE_FILES[@]}"; do
  for heading in "${linux_required_headings[@]}"; do
    if ! grep -Fqx "$heading" "$document"; then
      echo "$document: missing Linux IaC heading: $heading" >&2
      exit 1
    fi
  done

  linux_story_count="$(grep -c '^### STORY-LNX-' "$document" || true)"
  if [[ "$linux_story_count" -lt 3 ]]; then
    echo "$document: must contain at least three end-to-end Linux Jira stories." >&2
    exit 1
  fi

  interview_question_count="$(grep -c '^[0-9][0-9]*\. \*\*Question:' "$document" || true)"
  if [[ "$interview_question_count" -lt 9 ]]; then
    echo "$document: must contain at least nine interview questions." >&2
    exit 1
  fi

  use_case_id="$(basename "$document" | cut -d- -f1-3)"
  architecture_file="docs/assets/use-cases/$use_case_id/$use_case_id-architecture.svg"
  architecture_link="../../assets/use-cases/$use_case_id/$use_case_id-architecture.svg"

  if [[ ! -f "$architecture_file" ]]; then
    echo "$document: missing architecture SVG: $architecture_file" >&2
    exit 1
  fi

  architecture_link_count="$(grep -Foc "($architecture_link)" "$document" || true)"
  if [[ "$architecture_link_count" -ne 1 ]]; then
    echo "$document: must link its architecture SVG exactly once." >&2
    exit 1
  fi

  python3 - "$architecture_file" <<'PY'
import sys
import xml.etree.ElementTree as ET

path = sys.argv[1]
root = ET.parse(path).getroot()
namespace = {"svg": "http://www.w3.org/2000/svg"}
title = root.find("svg:title", namespace)
description = root.find("svg:desc", namespace)
if root.attrib.get("role") != "img" or root.attrib.get("aria-labelledby") != "title desc":
    raise SystemExit(f"{path}: SVG must expose role=img and aria-labelledby='title desc'")
if title is None or title.attrib.get("id") != "title" or not (title.text or "").strip():
    raise SystemExit(f"{path}: SVG must contain a non-empty title with id=title")
if description is None or description.attrib.get("id") != "desc" or not (description.text or "").strip():
    raise SystemExit(f"{path}: SVG must contain a non-empty desc with id=desc")
PY

  if grep -Eqi '\b(this|the) use case\b|as a .*,? i need' "$document"; then
    echo "$document: contains template-like wording; write in a direct engineering voice." >&2
    exit 1
  fi

  relative_path="${document#docs/}"
  if ! grep -Fq "($relative_path)" "$portfolio"; then
    echo "$document: canonical portfolio does not link this detail page." >&2
    exit 1
  fi
done

echo "Detailed use-case documentation validation passed (${#USE_CASE_FILES[@]} document(s))."
