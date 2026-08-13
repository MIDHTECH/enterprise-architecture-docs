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

portfolio="docs/enterprise-project-portfolio-and-usecases.md"
declared_total="$({
  awk -F'|' '/^\| \*\*Total\*\* \| \*\*[0-9]+\*\* \|$/ { print $3 }' "$portfolio"
} | tr -d ' *')"

if [[ "${#USE_CASE_FILES[@]}" -ne "$declared_total" ]]; then
  echo "Detailed-page count ${#USE_CASE_FILES[@]} does not match canonical portfolio count $declared_total." >&2
  exit 1
fi

required_headings=(
  "## Purpose"
  "## Expected outcome"
  "## Platform and enterprise fit"
  "## Trigger and actors"
  "## Preconditions"
  "## Scope and exclusions"
  "## Architecture context"
  "## Architecture diagram"
  "## Dependencies and handoffs"
  "## Quality attributes"
  "## Security and privacy architecture"
  "## Architecture decisions and trade-offs"
  "## Implementation design"
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

  if ! grep -Fq '| Supporting use cases |' "$document"; then
    echo "$document: missing supporting use-case links in the record." >&2
    exit 1
  fi

  planned_path_markers=(
    "/contracts/"
    "/schemas/"
    "/tests/fixtures/"
    "/.gitlab/ci/"
    "/docs/runbooks/"
  )
  for marker in "${planned_path_markers[@]}"; do
    if ! grep -Fq "$marker" "$document"; then
      echo "$document: missing planned implementation location containing $marker" >&2
      exit 1
    fi
  done

  if ! grep -Fq 'Thresholds `TBD` before implementation' "$document"; then
    echo "$document: missing owned quality-attribute threshold decision." >&2
    exit 1
  fi

  if grep -Eqi 'addresses a specific operating need inside the|For an approved scope, the future workflow evaluates|turns a versioned platform intent into a repeatable decision|Exact paths and tool choices must be confirmed|same enterprise control language used across|\b(this|the) use case\b|as a .*,? i need' "$document"; then
    echo "$document: contains prohibited stock or robotic wording." >&2
    exit 1
  fi

  story_count="$(grep -c '^### STORY-' "$document" || true)"
  if [[ "$story_count" -lt 3 ]]; then
    echo "$document: must contain at least three Jira stories covering design, source validation, and outcome/recovery." >&2
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

python3 - "$ROOT_DIR" <<'PY'
from pathlib import Path
import re
import sys

root = Path(sys.argv[1])
documents = sorted((root / "docs/use-cases").glob("*/UC-*.md"))
portfolio_text = (root / "docs/enterprise-project-portfolio-and-usecases.md").read_text()
id_to_path = {}
architecture_archetypes = set()
allowed_archetypes = {
    "delivery-pipeline",
    "data-flow",
    "feedback-loop",
    "lifecycle",
    "service-path",
    "decision-map",
    "response",
}
for document in documents:
    match = re.match(r"(UC-[A-Z0-9]+-\d{3})", document.name)
    if not match:
        raise SystemExit(f"{document}: filename does not begin with a canonical use-case ID")
    id_to_path[match.group(1)] = document

for document in documents:
    text = document.read_text()
    own_id = re.match(r"(UC-[A-Z0-9]+-\d{3})", document.name).group(1)
    portfolio_target = document.relative_to(root / "docs").as_posix()
    portfolio_link_count = portfolio_text.count(f"({portfolio_target})")
    if portfolio_link_count != 1:
        raise SystemExit(
            f"{document}: canonical portfolio must link the detailed page exactly once; found {portfolio_link_count}"
        )
    platform_index = document.parent / "README.md"
    if not platform_index.is_file():
        raise SystemExit(f"{document}: missing platform index {platform_index}")
    index_link_count = platform_index.read_text().count(f"({document.name})")
    if index_link_count != 1:
        raise SystemExit(
            f"{document}: platform index must link the detailed page exactly once; found {index_link_count}"
        )
    required_architecture_headings = (
        "Architecture context",
        "Architecture diagram",
        "Dependencies and handoffs",
        "Quality attributes",
        "Security and privacy architecture",
        "Architecture decisions and trade-offs",
        "Implementation design",
    )
    for heading in required_architecture_headings:
        count = len(re.findall(rf"^## {re.escape(heading)}\s*$", text, re.M))
        if count != 1:
            raise SystemExit(f"{document}: architecture heading {heading!r} occurs {count} times")

    if text.count("```") % 2:
        raise SystemExit(f"{document}: unbalanced fenced code blocks")

    handoff_section = text.split("## Dependencies and handoffs", 1)[1].split("## Quality attributes", 1)[0]
    handoff_ids = re.findall(
        r"\[(UC-[A-Z0-9]+-\d{3})(?::[^]]+)?\]\([^)]*\.md\)",
        handoff_section,
    )
    supporting_row = re.search(r"^\| Supporting use cases \| (.+) \|$", text, re.M)
    supporting_ids = (
        re.findall(r"\[(UC-[A-Z0-9]+-\d{3})\]", supporting_row.group(1))
        if supporting_row
        else []
    )
    if own_id in handoff_ids:
        raise SystemExit(f"{document}: dependency table contains self-dependency {own_id}")
    if len(set(handoff_ids)) < 3:
        raise SystemExit(f"{document}: architecture must link at least three dependency use cases")
    if supporting_ids != handoff_ids:
        raise SystemExit(
            f"{document}: supporting-use-case record {supporting_ids} does not match handoff table {handoff_ids}"
        )

    architecture_path = (
        root
        / "docs/assets/use-cases"
        / own_id
        / f"{own_id}-architecture.svg"
    )
    architecture_link = f"../../assets/use-cases/{own_id}/{own_id}-architecture.svg"
    architecture_section = text.split("## Architecture diagram", 1)[1].split(
        "## Dependencies and handoffs", 1
    )[0]
    if not architecture_path.is_file():
        raise SystemExit(f"{document}: missing architecture SVG {architecture_path}")
    if architecture_section.count(f"({architecture_link})") != 1:
        raise SystemExit(
            f"{document}: architecture section must link {architecture_link} exactly once"
        )
    if "```mermaid" in architecture_section:
        raise SystemExit(f"{document}: architecture section must use the detailed SVG, not Mermaid")
    try:
        import xml.etree.ElementTree as ET

        svg_root = ET.parse(architecture_path).getroot()
    except ET.ParseError as error:
        raise SystemExit(f"{architecture_path}: invalid SVG XML: {error}")
    namespace = {"svg": "http://www.w3.org/2000/svg"}
    svg_title = svg_root.find("svg:title", namespace)
    svg_description = svg_root.find("svg:desc", namespace)
    if svg_root.attrib.get("role") != "img" or svg_root.attrib.get("aria-labelledby") != "title desc":
        raise SystemExit(f"{architecture_path}: SVG must expose role=img and aria-labelledby='title desc'")
    if svg_title is None or not (svg_title.text or "").strip():
        raise SystemExit(f"{architecture_path}: SVG must contain an accessible title")
    if svg_description is None or not (svg_description.text or "").strip():
        raise SystemExit(f"{architecture_path}: SVG must contain an accessible description")
    serialized_svg = architecture_path.read_text()
    if svg_root.attrib.get("data-use-case") != own_id:
        raise SystemExit(f"{architecture_path}: data-use-case must equal {own_id}")
    diagram_archetype = svg_root.attrib.get("data-archetype")
    if diagram_archetype not in allowed_archetypes:
        raise SystemExit(f"{architecture_path}: unsupported architecture archetype {diagram_archetype!r}")
    architecture_archetypes.add(diagram_archetype)
    required_human_concepts = (
        "WHAT WE’RE TRYING TO MAKE TRUE",
        "The line we do not cross in this design",
    )
    for concept in required_human_concepts:
        if concept not in serialized_svg:
            raise SystemExit(f"{architecture_path}: missing human-readable visual concept {concept!r}")
    if own_id not in serialized_svg:
        raise SystemExit(f"{architecture_path}: diagram does not contain its own use-case ID")

    for target in re.findall(r"\[[^\]]+\]\(([^)#]+\.md)(?:#[^)]+)?\)", text):
        resolved = (document.parent / target).resolve()
        if not resolved.is_file():
            raise SystemExit(f"{document}: broken internal Markdown link: {target}")

if architecture_archetypes != allowed_archetypes:
    missing = sorted(allowed_archetypes - architecture_archetypes)
    raise SystemExit(f"Architecture portfolio does not exercise every approved visual grammar; missing {missing}")
PY

LINUX_USE_CASE_FILES=()
while IFS= read -r line; do
  LINUX_USE_CASE_FILES+=("$line")
done < <(find docs/use-cases/linux -type f -name 'UC-LNX-*.md' -print | sort)

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

  if ! grep -Fq "($relative_path#architecture-diagram)" "$portfolio"; then
    echo "$document: canonical portfolio does not link directly to its architecture diagram." >&2
    exit 1
  fi
done

python3 - "$portfolio" <<'PY'
from pathlib import Path
import re
import sys

portfolio = Path(sys.argv[1])
lines = portfolio.read_text().splitlines()
platform_headings = {
    "Enterprise DevSecOps Delivery Platform",
    "Enterprise Multi-Cloud Infrastructure Platform",
    "Enterprise Kubernetes Platform with GitOps",
    "Enterprise Observability and SRE Reliability Platform",
    "Enterprise Cloud Governance and Operations Automation",
    "Enterprise Linux Systems Engineering Platform",
    "Enterprise Database Engineering and Reliability Platform",
    "Enterprise Resilience and Service Operations Platform",
    "Enterprise Data Engineering and Integration Platform",
    "Enterprise Network Engineering and Automation Platform",
    "Enterprise Healthcare AI Platform",
    "Enterprise MLOps Model Platform",
}

current = None
in_use_case_table = False
targets = []
unlinked = []
row_pattern = re.compile(r"^\| \[([^]]+)\]\((use-cases/[^)]+\.md)\) \|")

for line in lines:
    if line.startswith("## "):
        heading = line[3:]
        current = heading if heading in platform_headings else None
        in_use_case_table = False
        continue
    if current and line.startswith("| Use case |"):
        in_use_case_table = True
        continue
    if not current or not in_use_case_table or line.startswith("| ---"):
        continue
    if not line.startswith("|"):
        in_use_case_table = False
        continue
    match = row_pattern.match(line)
    if not match:
        unlinked.append((current, line))
        continue
    targets.append(match.group(2))

if unlinked:
    details = "\n".join(f"{heading}: {line}" for heading, line in unlinked[:10])
    raise SystemExit(f"Canonical use-case rows without detail links:\n{details}")

declared = int(re.search(r"^\| \*\*Total\*\* \| \*\*(\d+)\*\* \|$", "\n".join(lines), re.M).group(1))
if len(targets) != declared:
    raise SystemExit(f"Portfolio links {len(targets)} detailed pages; expected {declared}.")
if len(set(targets)) != declared:
    raise SystemExit("Each canonical use case must link to its own unique detailed page.")

missing = [target for target in targets if not (portfolio.parent / target).is_file()]
if missing:
    raise SystemExit("Portfolio links missing detailed pages: " + ", ".join(missing[:10]))

actual = {
    str(path.relative_to(portfolio.parent))
    for path in (portfolio.parent / "use-cases").rglob("UC-*.md")
}
if set(targets) != actual:
    unlisted = sorted(actual - set(targets))
    unknown = sorted(set(targets) - actual)
    raise SystemExit(
        "Portfolio/detail mismatch. Unlisted pages: "
        + ", ".join(unlisted[:10])
        + "; unknown targets: "
        + ", ".join(unknown[:10])
    )
PY

echo "Detailed use-case documentation validation passed (${#USE_CASE_FILES[@]} document(s))."
