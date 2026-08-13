#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

python3 - "$ROOT_DIR" <<'PY'
from pathlib import Path
import re
import sys
import xml.etree.ElementTree as ET

root = Path(sys.argv[1])
register = root / "docs/application-project-deployment-register.md"
template = root / "docs/projects/application-deployment-record-template.md"
traceability = root / "docs/use-cases/enterprise-traceability.md"
diagram = root / "docs/assets/application-project-deployment-model.svg"

for required in (register, template, traceability, diagram):
    if not required.is_file():
        raise SystemExit(f"Missing application-project artifact: {required}")

text = register.read_text()
known_projects = (
    "midhhealth/platform-delivery/devsecops-cicd-orchestrator",
    "midhhealth/platform-delivery/jenkins-jobs",
    "midhhealth/platform-delivery/jenkins-shared-library",
    "midhhealth/platform-engineering/cloud-infra-automation-platform",
    "midhhealth/platform-engineering/kubernetes-platform-gitops",
    "midhhealth/platform-engineering/linux-systems-platform",
    "midhhealth/platform-engineering/network-engineering-platform",
    "midhhealth/reliability-operations/observability-sre-platform",
    "midhhealth/reliability-operations/resilience-service-operations",
    "midhhealth/reliability-operations/ansible-observability",
    "midhhealth/reliability-operations/ansible-prometheus",
    "midhhealth/security-governance/cloud-governance-ops-automation",
    "midhhealth/data-and-integration/database-reliability-platform",
    "midhhealth/data-and-integration/data-engineering-platform",
    "midhhealth/ai-and-ml-platform/healthcare-ai-platform",
    "midhhealth/ai-and-ml-platform/mlops-model-platform",
)
for project in known_projects:
    count = text.count(f"`{project}`")
    if count != 1:
        raise SystemExit(
            f"{register}: project {project} must occur once in the register; found {count}"
        )

known_register_section = text.split("## Known project register", 1)[1].split(
    "## Application portfolios that still need project names", 1
)[0]
project_rows = re.findall(r"^\| `midhhealth/[^`]+` \|", known_register_section, re.M)
if len(project_rows) != len(known_projects):
    raise SystemExit(
        f"{register}: expected {len(known_projects)} known project rows; found {len(project_rows)}"
    )

required_chains = (
    "Delivery spine",
    "Identity and secrets",
    "Network and service access",
    "Operational readiness",
    "Telemetry and release feedback",
    "Kubernetes workload",
    "VM or native service",
    "Stateful application",
    "Data-producing or consuming application",
    "AI or model-enabled application",
)
for chain in required_chains:
    if not re.search(rf"^\| {re.escape(chain)} \|", text, re.M):
        raise SystemExit(f"{register}: missing reusable chain {chain!r}")

for phrase in (
    "Application projects",
    "Platform implementation projects",
    "Runtime products",
    "Inventory required",
    "No placeholder application name should be invented",
):
    if phrase not in text:
        raise SystemExit(f"{register}: missing project-boundary statement {phrase!r}")

template_text = template.read_text()
for heading in (
    "## Why this project exists",
    "## What this project connects to",
    "## Platform path",
    "## Deployment shape",
    "## Release conversation",
    "## Operability and recovery",
    "## Security and data boundaries",
    "## Acceptance record",
    "## Decision",
):
    if heading not in template_text:
        raise SystemExit(f"{template}: missing required heading {heading}")

for document in (register, template, traceability):
    document_text = document.read_text()
    for target in re.findall(r"\[[^]]+\]\(([^)]+)\)", document_text):
        if target.startswith(("http://", "https://", "#")):
            continue
        target_path = (document.parent / target.split("#", 1)[0]).resolve()
        if not target_path.exists():
            raise SystemExit(f"{document}: unresolved local link {target}")

svg = ET.parse(diagram).getroot()
namespace = {"svg": "http://www.w3.org/2000/svg"}
if svg.attrib.get("role") != "img" or svg.attrib.get("aria-labelledby") != "title desc":
    raise SystemExit(f"{diagram}: accessible image role and label are required")
for element in ("title", "desc"):
    node = svg.find(f"svg:{element}", namespace)
    if node is None or not (node.text or "").strip():
        raise SystemExit(f"{diagram}: accessible {element} is required")

print(
    "Application project validation passed: "
    f"{len(known_projects)} platform projects, {len(required_chains)} reusable chains."
)
PY
