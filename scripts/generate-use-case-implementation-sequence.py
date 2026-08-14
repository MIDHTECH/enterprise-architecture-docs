#!/usr/bin/env python3
"""Generate the dependency-safe design implementation sequence for all use cases."""

from collections import defaultdict
from pathlib import Path
import argparse
import json
import re


ROOT = Path(__file__).resolve().parents[1]
USE_CASE_ROOT = ROOT / "docs/use-cases"
OUTPUT = ROOT / "docs/use-case-implementation-sequence.md"
CAPABILITIES = ROOT / "docs/environment-capability-status.json"

PLATFORM_LABELS = {
    "devsecops": "DevSecOps delivery",
    "infrastructure": "Multi-cloud infrastructure",
    "kubernetes": "Kubernetes with GitOps",
    "observability": "Observability and SRE",
    "governance": "Governance and operations",
    "linux": "Linux systems engineering",
    "database": "Database reliability",
    "resilience": "Resilience and service operations",
    "data": "Data engineering and integration",
    "network": "Network engineering and automation",
    "healthcare-ai": "Healthcare AI",
    "mlops": "MLOps model platform",
}

WAVE_INTENTS = (
    "Declare service ownership and the base network addressing contract.",
    "Establish shared identity, DNS, policy, dependency, and service-boundary vocabulary.",
    "Define state, secrets, SLO, recovery-orchestration, and core network contracts.",
    "Connect source controls, access governance, telemetry, incident, and cluster drift contracts.",
    "Add platform assurance, infrastructure analysis, application delivery, and operational response contracts.",
    "Design service procedures, data movement, runtime operations, and specialist platform capabilities.",
    "Join core execution paths across CI/CD, databases, infrastructure, GitOps, identity, and models.",
    "Add evidence aggregation, shared automation, model lifecycle, and recovery measurement.",
    "Close recovery, compliance, governance, cost, and model-retraining control loops.",
    "Apply policy, vulnerability, optimization, and platform-hardening decisions.",
    "Join artifact publication, image assurance, misconfiguration detection, and Kubernetes enforcement.",
    "Complete the Kubernetes policy-as-code governance path.",
)


def load_pages() -> dict[str, dict]:
    pages = {}
    row_pattern = re.compile(
        r"^\| (Required upstream contract|Coordinated assurance handoff) \| "
        r"\[(UC-[A-Z0-9]+-\d{3})(?::[^]]+)?\]\(",
        re.M,
    )
    for path in sorted(USE_CASE_ROOT.glob("*/UC-*.md")):
        text = path.read_text()
        heading = re.match(r"# (UC-[A-Z0-9]+-\d{3}): (.+)", text)
        if not heading:
            raise SystemExit(f"{path}: invalid canonical heading")
        use_case_id, title = heading.groups()
        section = text.split("## Dependencies and handoffs", 1)[1].split(
            "## Quality attributes", 1
        )[0]
        relationships = row_pattern.findall(section)
        pages[use_case_id] = {
            "title": title,
            "path": path,
            "domain": path.parent.name,
            "required": [item for relationship, item in relationships if relationship.startswith("Required")],
            "coordinated": [item for relationship, item in relationships if relationship.startswith("Coordinated")],
        }
    return pages


def topological_waves(pages: dict[str, dict]) -> list[list[str]]:
    remaining = {use_case_id: set(page["required"]) for use_case_id, page in pages.items()}
    unknown = sorted(
        dependency
        for dependencies in remaining.values()
        for dependency in dependencies
        if dependency not in pages
    )
    if unknown:
        raise SystemExit("Unknown required dependencies: " + ", ".join(unknown))
    waves = []
    while remaining:
        ready = sorted(use_case_id for use_case_id, dependencies in remaining.items() if not dependencies)
        if not ready:
            raise SystemExit(
                "Required-upstream dependencies contain a cycle: "
                + ", ".join(sorted(remaining)[:20])
            )
        waves.append(ready)
        ready_set = set(ready)
        remaining = {
            use_case_id: dependencies - ready_set
            for use_case_id, dependencies in remaining.items()
            if use_case_id not in ready_set
        }
    return waves


def use_case_link(page: dict, use_case_id: str) -> str:
    relative = page["path"].relative_to(ROOT / "docs").as_posix()
    return f"[{use_case_id}: {page['title']}]({relative})"


def linked_ids(ids: list[str], pages: dict[str, dict]) -> str:
    if not ids:
        return "None — contract root"
    return ", ".join(
        f"[{use_case_id}]({pages[use_case_id]['path'].relative_to(ROOT / 'docs').as_posix()})"
        for use_case_id in ids
    )


def build_document(pages: dict[str, dict], waves: list[list[str]]) -> str:
    capability_document = json.loads(CAPABILITIES.read_text())
    capability_rows = []
    for name, capability in capability_document["capabilities"].items():
        status = capability["product_status"]
        if status != "accepted":
            capability_rows.append(
                f"| `{name}` | `{status}` | {capability['design_rule']} |"
            )

    required_edges = sum(len(page["required"]) for page in pages.values())
    coordinated_edges = sum(len(page["coordinated"]) for page in pages.values())
    lines = [
        "# Dependency-Safe Use-Case Implementation Sequence",
        "",
        f"Last generated from design contracts: {capability_document['last_verified']}",
        "",
        "## Purpose and boundary",
        "",
        "This sequence turns the 226 architecture designs into an ordered implementation backlog. It",
        "does **not** deploy an application, install a product, create infrastructure, approve a change,",
        "or claim runtime acceptance. A wave means that source contracts, schemas, fixtures, CI checks,",
        "and runbooks can be implemented after their required upstream contracts exist.",
        "Existing implemented or verified slices keep their recorded status; the waves order remaining",
        "contract closure and do not rewrite the historical sequence of lab work.",
        "",
        "A **required upstream contract** is a build-order edge: its versioned interface and fixture",
        "behavior must be available before the dependent source slice can claim implementation",
        "readiness. A **coordinated assurance handoff** may be designed in parallel, but its evidence",
        "must still be resolved before runtime promotion or owner acceptance. This distinction removes",
        "false circular prerequisites without weakening runtime controls.",
        "",
        "## Sequence facts",
        "",
        "| Measure | Value |",
        "| --- | ---: |",
        f"| Canonical use cases | {len(pages)} |",
        f"| Implementation waves | {len(waves)} |",
        f"| Required build-order edges | {required_edges} |",
        f"| Coordinated assurance edges | {coordinated_edges} |",
        "| Required-edge cycles | 0 |",
        "",
        "Each later wave depends only on required contracts from earlier waves. Use cases in the same",
        "wave can be implemented in parallel at source level. Their page-specific target, identity,",
        "change, canary, stop, recovery, and evidence gates still control any later runtime action.",
        "",
        "## Wave summary",
        "",
        "| Wave | Design intent | Use cases | Platform domains |",
        "| ---: | --- | ---: | ---: |",
    ]

    for index, wave in enumerate(waves):
        domains = {pages[use_case_id]["domain"] for use_case_id in wave}
        intent = WAVE_INTENTS[index] if index < len(WAVE_INTENTS) else "Extend the dependency-safe implementation frontier."
        lines.append(f"| {index + 1} | {intent} | {len(wave)} | {len(domains)} |")

    lines.extend(
        [
            "",
            "## Implementation waves",
            "",
            "The first source slice for every row is the contract, result schema, fixtures, CI gate,",
            "and operator runbook already named on its detailed page. Runtime mutation remains a",
            "separate approved stage.",
            "",
        ]
    )

    for index, wave in enumerate(waves):
        intent = WAVE_INTENTS[index] if index < len(WAVE_INTENTS) else "Extend the dependency-safe implementation frontier."
        lines.extend(
            [
                f"### Wave {index + 1} — {intent.rstrip('.')}",
                "",
                "| Use case | Owning platform | Required contracts already available | Coordinated assurance before runtime acceptance |",
                "| --- | --- | --- | --- |",
            ]
        )
        for use_case_id in wave:
            page = pages[use_case_id]
            lines.append(
                f"| {use_case_link(page, use_case_id)} | {PLATFORM_LABELS[page['domain']]} | "
                f"{linked_ids(page['required'], pages)} | {linked_ids(page['coordinated'], pages)} |"
            )
        lines.append("")

    lines.extend(
        [
            "## Current capability gates remain in force",
            "",
            "The sequence orders source implementation; it does not turn target-only or unaccepted",
            "capabilities into current infrastructure. The canonical environment manifest currently",
            "requires these boundaries:",
            "",
            "| Capability | Current status | Sequence rule |",
            "| --- | --- | --- |",
            *capability_rows,
            "",
            "Accepted products such as the native Harbor endpoint and Vault may be referenced only",
            "inside their recorded boundaries. Their presence does not authorize a workload rollout or",
            "prove that a dependent use case has been implemented.",
            "",
            "## Promotion rule",
            "",
            "A team may take a use case from this sequence into an implementation repository when:",
            "",
            "1. every required upstream contract shown in its row is versioned and testable;",
            "2. the detailed page still matches the canonical environment status;",
            "3. the planned repository and paths have an accountable owner;",
            "4. source fixtures cover positive, negative, malformed, unauthorized, dependency-failure,",
            "   and recovery behavior; and",
            "5. any target-changing stage remains disabled until a separate change, identity, allowlist,",
            "   canary, stop condition, recovery plan, and independent verification are approved.",
            "",
            "Real provider, payer, and cross-application implementation stays blocked until the actual",
            "application inventory is supplied. This sequence must not be used to manufacture placeholder",
            "applications merely to close that organizational gap.",
            "",
        ]
    )
    return "\n".join(lines)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--apply", action="store_true", help="write the generated sequence")
    parser.add_argument("--check", action="store_true", help="fail when the generated sequence is stale")
    args = parser.parse_args()
    if args.apply and args.check:
        raise SystemExit("Choose --apply or --check, not both")

    pages = load_pages()
    waves = topological_waves(pages)
    document = build_document(pages, waves)
    current = OUTPUT.read_text() if OUTPUT.exists() else ""
    if args.check:
        if current != document:
            raise SystemExit(f"{OUTPUT}: generated implementation sequence is stale")
        print(f"Verified dependency-safe sequence: {len(pages)} use cases in {len(waves)} waves.")
    elif args.apply:
        OUTPUT.write_text(document)
        print(f"Generated {OUTPUT}: {len(pages)} use cases in {len(waves)} waves.")
    else:
        print(f"Dependency-safe sequence: {len(pages)} use cases in {len(waves)} waves.")


if __name__ == "__main__":
    main()
