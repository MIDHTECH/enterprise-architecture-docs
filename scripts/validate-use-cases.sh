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

echo "Detailed use-case documentation validation passed (${#USE_CASE_FILES[@]} document(s))."
