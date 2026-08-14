#!/usr/bin/env python3
"""Apply architect-reviewed dependency contracts without rewriting unrelated page content."""

from pathlib import Path
import argparse
import json
import os
import re


ROOT = Path(__file__).resolve().parents[1]
USE_CASE_ROOT = ROOT / "docs/use-cases"
CONTRACT_PATH = ROOT / "docs/use-case-dependency-contracts.json"

# These pages predate the common Produced handoff row. Their concise artifacts
# are taken from their own detailed outcomes and existing dependency language.
HANDOFF_OVERRIDES = {
    "UC-CICD-001": "source-to-artifact pipeline provenance and stage outcome",
    "UC-CICD-002": "build result, source revision, output checksum, and provenance record",
    "UC-CICD-004": "machine-readable quality decision tied to the evaluated commit",
    "UC-DB-001": "backup provenance, isolated restore, and recovery verification",
    "UC-GOV-001": "control-to-evidence mapping with ownership, exception, and retention metadata",
    "UC-INFRA-001": "desired/observed infrastructure identity and drift result",
    "UC-K8S-001": "cluster identity and desired-versus-observed state report",
    "UC-LNX-001": "signed operating-system image manifest and baseline admission result",
    "UC-LNX-003": "VM identity, cloud-init completion, and idempotence result",
    "UC-LNX-005": "Ansible check, canary, rollout, and idempotence evidence",
    "UC-LNX-006": "patch selection, canary health, cohort result, and deferral record",
    "UC-LNX-008": "SELinux and firewall intended-path, denial, and rollback evidence",
    "UC-LNX-010": "filesystem capacity, mount identity, and recovery boundary",
    "UC-LNX-011": "host DNS, time, and network readiness evidence",
    "UC-LNX-012": "identity-to-action mapping with successful and denied access evidence",
    "UC-LNX-022": "affected-host, owner, remediation, exception, and closure evidence",
    "UC-MLOPS-001": "model artifact identity, lineage, and lifecycle state",
    "UC-OBS-001": "service-level indicator, objective, and measurement window",
}


def plain(value: str) -> str:
    value = re.sub(r"\[([^]]+)\]\([^)]+\)", r"\1", value)
    value = value.replace("**", "").replace("`", "")
    return re.sub(r"\s+", " ", value).strip().rstrip(".")


def page_index() -> dict[str, Path]:
    result = {}
    for page in sorted(USE_CASE_ROOT.glob("*/UC-*.md")):
        match = re.match(r"(UC-[A-Z0-9]+-\d{3})", page.name)
        if not match:
            raise SystemExit(f"{page}: invalid use-case filename")
        result[match.group(1)] = page
    return result


def title_and_handoff(page: Path) -> tuple[str, str]:
    text = page.read_text()
    id_match = re.match(r"# (UC-[A-Z0-9]+-\d{3}): (.+)", text)
    handoff = re.search(r"^\| Produced handoff \| (.+) \|$", text, re.M)
    if not id_match:
        raise SystemExit(f"{page}: missing canonical title")
    use_case_id, title = id_match.groups()
    if use_case_id in HANDOFF_OVERRIDES:
        artifact = HANDOFF_OVERRIDES[use_case_id]
    elif handoff:
        artifact = plain(handoff.group(1))
    else:
        # Some of the older, hand-authored platform pages use a narrative fit
        # section instead of the newer Produced handoff row. Reuse their own
        # expected-outcome language rather than fabricating a product artifact.
        outcome = text.split("## Expected outcome", 1)[1].split("\n## ", 1)[0].strip()
        first_paragraph = outcome.split("\n\n", 1)[0]
        artifact = plain(first_paragraph)
    return plain(title), artifact


def link(from_page: Path, to_page: Path) -> str:
    return Path(os.path.relpath(to_page, from_page.parent)).as_posix()


def replace_contract(page: Path, dependency_ids: list[str], pages: dict[str, Path]) -> str:
    text = page.read_text()
    own_id = re.match(r"(UC-[A-Z0-9]+-\d{3})", page.name).group(1)
    if own_id in dependency_ids or len(dependency_ids) < 3 or len(set(dependency_ids)) != len(dependency_ids):
        raise SystemExit(f"{page}: dependency contract must contain at least three unique non-self IDs")

    links = []
    rows = []
    for index, dependency_id in enumerate(dependency_ids):
        if dependency_id not in pages:
            raise SystemExit(f"{page}: unknown dependency {dependency_id}")
        dependency_page = pages[dependency_id]
        title, handoff = title_and_handoff(dependency_page)
        relative = link(page, dependency_page)
        links.append(f"[{dependency_id}]({relative})")
        relationship = "Required upstream contract" if index < 2 else "Coordinated assurance handoff"
        rows.append(
            f"| {relationship} | [{dependency_id}: {title}]({relative}) | {handoff} | "
            "Missing, stale, or contradictory handoff stops the dependent decision and is recorded for the accountable owner. |"
        )

    supporting_pattern = r"^\| Supporting use cases \| .+ \|$"
    if len(re.findall(supporting_pattern, text, re.M)) != 1:
        raise SystemExit(f"{page}: expected one supporting-use-cases row")
    text = re.sub(
        supporting_pattern,
        f"| Supporting use cases | {', '.join(links)} |",
        text,
        count=1,
        flags=re.M,
    )

    section_start = text.index("## Dependencies and handoffs")
    table_header = "| Relationship | Use case | Required handoff | Failure propagation |\n| --- | --- | --- | --- |"
    header_start = text.index(table_header, section_start)
    rows_start = header_start + len(table_header)
    paragraph_marker = f"\n\nBefore {plain(text.splitlines()[0].split(': ', 1)[1])} is implemented"
    rows_end = text.index(paragraph_marker, rows_start)
    return text[:rows_start] + "\n" + "\n".join(rows) + text[rows_end:]


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--apply", action="store_true", help="write the reviewed contracts")
    args = parser.parse_args()

    contracts = json.loads(CONTRACT_PATH.read_text())["contracts"]
    pages = page_index()
    changes = []
    for use_case_id, dependency_ids in contracts.items():
        if use_case_id not in pages:
            raise SystemExit(f"{CONTRACT_PATH}: unknown use case {use_case_id}")
        page = pages[use_case_id]
        new_text = replace_contract(page, dependency_ids, pages)
        if new_text != page.read_text():
            changes.append((page, new_text))

    print(f"Reviewed dependency contracts: {len(contracts)}; pages requiring update: {len(changes)}")
    if args.apply:
        for page, new_text in changes:
            page.write_text(new_text)
        print(f"Updated {len(changes)} dependency tables and use-case records.")
    elif changes:
        print("Dry run only; use --apply to write the corrections.")


if __name__ == "__main__":
    main()
