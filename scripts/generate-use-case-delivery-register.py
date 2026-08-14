#!/usr/bin/env python3
"""Generate the project and source-path delivery register for all detailed use cases."""

from collections import Counter, defaultdict
from pathlib import Path
import argparse
import re


ROOT = Path(__file__).resolve().parents[1]
USE_CASE_ROOT = ROOT / "docs/use-cases"
OUTPUT = ROOT / "docs/use-case-delivery-register.md"

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


def row_path(section: str, predicate, page: Path, responsibility: str) -> str:
    candidates = []
    for line in section.splitlines():
        if not line.startswith("| ") or line.startswith("| ---"):
            continue
        cells = [cell.strip() for cell in line.strip("|").split("|")]
        if len(cells) != 2:
            continue
        match = re.search(r"`(midhhealth/[^`]+)`", cells[1])
        if match and predicate(cells[0].lower()):
            candidates.append(match.group(1))
    if len(candidates) != 1:
        raise SystemExit(f"{page}: expected one {responsibility} path; found {len(candidates)}")
    return candidates[0]


def load_pages() -> dict[str, dict]:
    pages = {}
    relationship_pattern = re.compile(
        r"^\| (Required upstream contract|Coordinated assurance handoff) \| "
        r"\[(UC-[A-Z0-9]+-\d{3})(?::[^]]+)?\]\(",
        re.M,
    )
    for page in sorted(USE_CASE_ROOT.glob("*/UC-*.md")):
        text = page.read_text()
        heading = re.match(r"# (UC-[A-Z0-9]+-\d{3}): (.+)", text)
        repository = re.search(
            r"^\| Primary implementation repository \| `([^`]+)` \|$", text, re.M
        )
        if not heading or not repository:
            raise SystemExit(f"{page}: missing canonical heading or primary implementation repository")
        use_case_id, title = heading.groups()
        implementation = text.split("## Implementation design", 1)[1].split(
            "## Code and configuration map", 1
        )[0]
        relationships = relationship_pattern.findall(
            text.split("## Dependencies and handoffs", 1)[1].split("## Quality attributes", 1)[0]
        )
        paths = {
            "contract": row_path(implementation, lambda label: "allowlist" in label, page, "contract"),
            "implementation": row_path(implementation, lambda label: label == "primary implementation", page, "implementation"),
            "schema": row_path(implementation, lambda label: "result schema" in label, page, "schema"),
            "fixtures": row_path(implementation, lambda label: "fixtures" in label, page, "fixtures"),
            "ci": row_path(implementation, lambda label: "gitlab" in label and ("gate" in label or "include" in label), page, "CI"),
            "runbook": row_path(implementation, lambda label: "operator diagnosis and recovery" in label, page, "runbook"),
        }
        if any(not path.startswith(repository.group(1) + "/") for path in paths.values()):
            raise SystemExit(f"{page}: planned artifact escapes {repository.group(1)}")
        pages[use_case_id] = {
            "title": title,
            "page": page,
            "domain": page.parent.name,
            "repository": repository.group(1),
            "paths": paths,
            "required": [item for relationship, item in relationships if relationship.startswith("Required")],
        }
    return pages


def waves(pages: dict[str, dict]) -> tuple[list[list[str]], dict[str, int]]:
    remaining = {use_case_id: set(page["required"]) for use_case_id, page in pages.items()}
    result = []
    wave_by_id = {}
    while remaining:
        ready = sorted(use_case_id for use_case_id, dependencies in remaining.items() if not dependencies)
        if not ready:
            raise SystemExit("Required dependency graph contains a cycle")
        result.append(ready)
        for use_case_id in ready:
            wave_by_id[use_case_id] = len(result)
        ready_set = set(ready)
        remaining = {
            use_case_id: dependencies - ready_set
            for use_case_id, dependencies in remaining.items()
            if use_case_id not in ready_set
        }
    return result, wave_by_id


def relative(path: str, repository: str) -> str:
    return path[len(repository) + 1 :]


def build_document(pages: dict[str, dict], sequence: list[list[str]], wave_by_id: dict[str, int]) -> str:
    repository_use_cases = defaultdict(list)
    artifact_owners = {}
    for use_case_id, page in pages.items():
        repository_use_cases[page["repository"]].append(use_case_id)
        for path in page["paths"].values():
            if path in artifact_owners:
                raise SystemExit(f"Planned path collision: {path}")
            artifact_owners[path] = use_case_id

    lines = [
        "# Use-Case Project and Delivery Register",
        "",
        "Last generated: 2026-08-13",
        "",
        "## Purpose and boundary",
        "",
        "This register tells an engineer which existing documented GitLab project will receive each",
        "use-case implementation and where its first six source artifacts are planned. It is a design",
        "handoff, not evidence that the repository paths, code, jobs, products, or runtime outcomes",
        "already exist. It creates no project and authorizes no lab change.",
        "",
        "Every use case owns one contract and target allowlist, one primary implementation, one result",
        "schema, one fixture family, one GitLab source gate, and one diagnosis/recovery runbook. The",
        "register validates all six paths even though the detailed tables below show the four paths an",
        "implementer normally opens first. The detailed use-case page remains authoritative for scope,",
        "identity, target, change, recovery, evidence, and acceptance.",
        "",
        "## Delivery facts",
        "",
        "| Measure | Value |",
        "| --- | ---: |",
        f"| Detailed use cases | {len(pages)} |",
        f"| Dependency-safe waves | {len(sequence)} |",
        f"| Primary implementation projects | {len(repository_use_cases)} |",
        f"| Planned source artifacts | {len(artifact_owners)} |",
        "| Planned path collisions | 0 |",
        "",
        "The 12 platform domains use 13 primary implementation projects because the end-to-end CI/CD",
        "demonstration is intentionally delivered through the existing `jenkins-jobs` control project",
        "instead of pretending that all delivery logic belongs in one platform repository.",
        "",
        "## Project summary",
        "",
        "| Primary implementation project | Owning platform domain(s) | Use cases | Waves used |",
        "| --- | --- | ---: | --- |",
    ]

    for repository in sorted(repository_use_cases):
        ids = repository_use_cases[repository]
        domains = sorted({PLATFORM_LABELS[pages[use_case_id]["domain"]] for use_case_id in ids})
        used_waves = sorted({wave_by_id[use_case_id] for use_case_id in ids})
        wave_text = ", ".join(str(value) for value in used_waves)
        lines.append(
            f"| `{repository}` | {', '.join(domains)} | {len(ids)} | {wave_text} |"
        )

    lines.extend(
        [
            "",
            "## Project delivery maps",
            "",
            "Paths are repository-relative below. Result schemas and fixture directories are also",
            "validated for uniqueness and remain visible on each linked detail page.",
            "",
        ]
    )

    for repository in sorted(repository_use_cases):
        ids = sorted(repository_use_cases[repository], key=lambda item: (wave_by_id[item], item))
        lines.extend(
            [
                f"### `{repository}`",
                "",
                "| Wave | Use case | Contract | Primary implementation | GitLab source gate | Recovery runbook |",
                "| ---: | --- | --- | --- | --- | --- |",
            ]
        )
        for use_case_id in ids:
            page = pages[use_case_id]
            detail = page["page"].relative_to(ROOT / "docs").as_posix()
            paths = page["paths"]
            lines.append(
                f"| {wave_by_id[use_case_id]} | [{use_case_id}: {page['title']}]({detail}) | "
                f"`{relative(paths['contract'], repository)}` | "
                f"`{relative(paths['implementation'], repository)}` | "
                f"`{relative(paths['ci'], repository)}` | "
                f"`{relative(paths['runbook'], repository)}` |"
            )
        lines.append("")

    lines.extend(
        [
            "## Handoff rule",
            "",
            "Before a row is started, its required contracts must be available from earlier waves in",
            "the [dependency-safe implementation sequence](use-case-implementation-sequence.md). The",
            "team then creates or confirms only the six planned paths inside the named project. If the",
            "project, ownership, runner, target, product, or identity does not match current inventory,",
            "the implementation stops and the design record is corrected; the discrepancy is not solved",
            "by silently creating infrastructure or moving the work to another repository.",
            "",
            "Application repositories remain separate. They consume published platform contracts through",
            "the application deployment register; platform source must not be copied into an application",
            "project, and placeholder provider or payer applications must not be invented.",
            "",
        ]
    )
    return "\n".join(lines)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--apply", action="store_true", help="write the generated register")
    parser.add_argument("--check", action="store_true", help="fail when the register is stale")
    args = parser.parse_args()
    if args.apply and args.check:
        raise SystemExit("Choose --apply or --check, not both")
    pages = load_pages()
    sequence, wave_by_id = waves(pages)
    document = build_document(pages, sequence, wave_by_id)
    current = OUTPUT.read_text() if OUTPUT.exists() else ""
    if args.check:
        if current != document:
            raise SystemExit(f"{OUTPUT}: generated delivery register is stale")
        print(f"Verified project delivery register for {len(pages)} use cases.")
    elif args.apply:
        OUTPUT.write_text(document)
        print(f"Generated project delivery register for {len(pages)} use cases.")
    else:
        print(f"Project delivery register covers {len(pages)} use cases.")


if __name__ == "__main__":
    main()
