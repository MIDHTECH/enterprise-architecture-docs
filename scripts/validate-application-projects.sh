#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

python3 - "$ROOT_DIR" <<'PY'
from pathlib import Path
import json
import re
import sys
import xml.etree.ElementTree as ET

root = Path(sys.argv[1])
register = root / "docs/application-project-deployment-register.md"
template = root / "docs/projects/application-deployment-record-template.md"
traceability = root / "docs/use-cases/enterprise-traceability.md"
diagram = root / "docs/assets/application-project-deployment-model.svg"
linkage = root / "docs/application-project-linkage-blueprint.md"
linkage_diagram = root / "docs/assets/application-project-linkage-blueprint.svg"
manifest = root / "docs/application-projects.json"
integration_manifest = root / "docs/application-integration-contracts.json"

for required in (
    register,
    template,
    traceability,
    diagram,
    linkage,
    linkage_diagram,
    manifest,
    integration_manifest,
):
    if not required.is_file():
        raise SystemExit(f"Missing application-project artifact: {required}")

text = register.read_text()
known_projects = (
    "midhhealth/platform-delivery/devsecops-cicd-orchestrator",
    "midhhealth/platform-delivery/jenkins-jobs",
    "midhhealth/platform-delivery/jenkins-shared-library",
    "midhhealth/platform-delivery/ansible-jenkins",
    "midhhealth/platform-delivery/ansible-awx",
    "midhhealth/platform-engineering/cloud-infra-automation-platform",
    "midhhealth/platform-engineering/kubernetes-platform-gitops",
    "midhhealth/platform-engineering/ansible-kubernetes",
    "midhhealth/platform-engineering/awx-inventory",
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
    "remain inventory gaps",
    "No placeholder application name should be invented",
):
    if phrase not in text:
        raise SystemExit(f"{register}: missing project-boundary statement {phrase!r}")

template_text = template.read_text()
for heading in (
    "## Why this project exists",
    "## What this project connects to",
    "## Platform path",
    "## Documented deployment shape",
    "## Intended release conversation",
    "## Operability and recovery",
    "## Security and data boundaries",
    "## Evidence plan and historical facts",
    "## Decision",
):
    if heading not in template_text:
        raise SystemExit(f"{template}: missing required heading {heading}")

for document in (register, template, traceability, linkage):
    document_text = document.read_text()
    for target in re.findall(r"\[[^]]+\]\(([^)]+)\)", document_text):
        if target.startswith(("http://", "https://", "#")):
            continue
        target_path = (document.parent / target.split("#", 1)[0]).resolve()
        if not target_path.exists():
            raise SystemExit(f"{document}: unresolved local link {target}")

namespace = {"svg": "http://www.w3.org/2000/svg"}
for svg_path in (diagram, linkage_diagram):
    svg = ET.parse(svg_path).getroot()
    if svg.attrib.get("role") != "img" or svg.attrib.get("aria-labelledby") != "title desc":
        raise SystemExit(f"{svg_path}: accessible image role and label are required")
    for element in ("title", "desc"):
        node = svg.find(f"svg:{element}", namespace)
        if node is None or not (node.text or "").strip():
            raise SystemExit(f"{svg_path}: accessible {element} is required")

manifest_data = json.loads(manifest.read_text())
if manifest_data.get("schema_version") != 1:
    raise SystemExit(f"{manifest}: unsupported schema_version")
applications = manifest_data.get("applications")
if not isinstance(applications, list) or not applications:
    raise SystemExit(f"{manifest}: at least one real application is required")

allowed_chains = {
    "delivery-spine",
    "identity-and-secrets",
    "network-and-service-access",
    "operational-readiness",
    "telemetry-and-release-feedback",
    "kubernetes-workload",
    "vm-or-native-service",
    "stateful-application",
    "data-producing-or-consuming-application",
    "ai-or-model-enabled-application",
}
allowed_states = {
    "not-deployed",
    "inventory",
    "source-pinned",
    "internal-ci-passed",
    "artifact-published",
    "ready",
    "deployed",
    "accepted",
    "blocked",
}
application_ids = set()
application_repositories = set()
for application in applications:
    application_id = application.get("id")
    repository = application.get("repository")
    if not re.fullmatch(r"[a-z0-9][a-z0-9-]*", application_id or ""):
        raise SystemExit(f"{manifest}: invalid application id {application_id!r}")
    if application_id in application_ids or repository in application_repositories:
        raise SystemExit(f"{manifest}: duplicate application id or repository")
    application_ids.add(application_id)
    application_repositories.add(repository)
    if not re.fullmatch(r"midhhealth/[a-z0-9._-]+/[a-z0-9._-]+", repository or ""):
        raise SystemExit(f"{manifest}: invalid repository {repository!r}")
    if application.get("deployment_state") not in allowed_states:
        raise SystemExit(f"{manifest}: invalid deployment_state for {application_id}")
    if application.get("documentation_state") != "detailed-and-linked":
        raise SystemExit(f"{manifest}: {application_id} documentation must be detailed-and-linked")
    if application.get("implementation_authorized") is not False:
        raise SystemExit(f"{manifest}: {application_id} must not imply implementation authorization")
    source = application.get("source", {})
    if not re.fullmatch(r"[0-9a-f]{40}", source.get("commit", "")):
        raise SystemExit(f"{manifest}: {application_id} must pin a full source commit")
    if not re.fullmatch(r"[0-9a-f]{64}", source.get("license_sha256", "")):
        raise SystemExit(f"{manifest}: {application_id} must pin a license SHA-256")
    internal_repository = application.get("internal_repository", {})
    if application.get("deployment_state") not in {"inventory", "source-pinned"}:
        if not re.fullmatch(r"[0-9a-f]{40}", internal_repository.get("commit", "")):
            raise SystemExit(f"{manifest}: {application_id} must pin its internal commit")
        if not isinstance(internal_repository.get("project_id"), int):
            raise SystemExit(f"{manifest}: {application_id} must record its internal project ID")
        if internal_repository.get("protected_branch") is not True:
            raise SystemExit(f"{manifest}: {application_id} internal default branch must be protected")
    chains = application.get("required_chains", [])
    unknown_chains = set(chains) - allowed_chains
    if not chains or unknown_chains:
        raise SystemExit(f"{manifest}: {application_id} has missing or unknown chains {unknown_chains}")
    project_dependencies = application.get("platform_projects", [])
    unknown_projects = set(project_dependencies) - set(known_projects)
    if not project_dependencies or unknown_projects:
        raise SystemExit(
            f"{manifest}: {application_id} has missing or unknown platform projects {unknown_projects}"
        )
    delivery_contracts = application.get("delivery_contracts", {})
    if application.get("deployment_state") not in {"inventory", "source-pinned"}:
        for contract_name in ("shared_library", "job_dsl"):
            contract = delivery_contracts.get(contract_name, {})
            if contract.get("repository") not in project_dependencies:
                raise SystemExit(
                    f"{manifest}: {application_id} {contract_name} must reference a platform dependency"
                )
            if not re.fullmatch(r"[0-9a-f]{40}", contract.get("commit", "")):
                raise SystemExit(
                    f"{manifest}: {application_id} {contract_name} must pin a full commit"
                )
            if not isinstance(contract.get("pipeline_id"), int):
                raise SystemExit(
                    f"{manifest}: {application_id} {contract_name} must record a pipeline ID"
                )
    for evidence in application.get("evidence", []):
        if not (root / evidence).is_file():
            raise SystemExit(f"{manifest}: {application_id} evidence does not exist: {evidence}")
    gates = application.get("gates", [])
    gate_ids = [gate.get("id") for gate in gates]
    if len(gate_ids) != len(set(gate_ids)) or not gate_ids:
        raise SystemExit(f"{manifest}: {application_id} must have unique acceptance gates")
    if application.get("deployment_state") != "accepted" and not any(
        gate.get("state") == "pending" for gate in gates
    ):
        raise SystemExit(f"{manifest}: non-accepted {application_id} must retain a pending gate")

    record = root / f"docs/projects/applications/{application_id}.md"
    application_diagram = root / f"docs/assets/applications/{application_id}-deployment.svg"
    for artifact in (record, application_diagram):
        if not artifact.is_file():
            raise SystemExit(f"{manifest}: missing project artifact {artifact}")
    record_text = record.read_text()
    for required_value in (
        repository,
        source["commit"],
        application.get("documentation_state"),
        application.get("deployment_state"),
    ):
        if required_value not in record_text:
            raise SystemExit(f"{record}: missing manifest value {required_value!r}")
    application_svg = ET.parse(application_diagram).getroot()
    if (
        application_svg.attrib.get("role") != "img"
        or application_svg.attrib.get("aria-labelledby") != "title desc"
        or application_svg.attrib.get("data-application") != application_id
    ):
        raise SystemExit(f"{application_diagram}: invalid accessible application SVG contract")
    for element in ("title", "desc"):
        node = application_svg.find(f"svg:{element}", namespace)
        if node is None or not (node.text or "").strip():
            raise SystemExit(f"{application_diagram}: accessible {element} is required")

integration_data = json.loads(integration_manifest.read_text())
if integration_data.get("schema_version") != 1:
    raise SystemExit(f"{integration_manifest}: unsupported schema_version")
if integration_data.get("scope") != "documentation-only":
    raise SystemExit(f"{integration_manifest}: scope must remain documentation-only")
if integration_data.get("implementation_authorized") is not False:
    raise SystemExit(f"{integration_manifest}: must not imply implementation authorization")
if set(integration_data.get("registered_applications", [])) != application_ids:
    raise SystemExit(
        f"{integration_manifest}: registered applications must exactly match application-projects.json"
    )

platform_contracts = integration_data.get("application_to_platform_contracts")
application_contracts = integration_data.get("application_to_application_contracts")
if not isinstance(platform_contracts, list) or not isinstance(application_contracts, list):
    raise SystemExit(f"{integration_manifest}: contract collections must be lists")

manifest_by_id = {application["id"]: application for application in applications}
contract_ids = set()
linked_chains = {application_id: set() for application_id in application_ids}
for contract in platform_contracts:
    contract_id = contract.get("id")
    application_id = contract.get("application_id")
    chain = contract.get("chain")
    if not re.fullmatch(r"[a-z0-9][a-z0-9-]*", contract_id or ""):
        raise SystemExit(f"{integration_manifest}: invalid contract id {contract_id!r}")
    if contract_id in contract_ids:
        raise SystemExit(f"{integration_manifest}: duplicate contract id {contract_id}")
    contract_ids.add(contract_id)
    if application_id not in application_ids:
        raise SystemExit(f"{integration_manifest}: unknown application {application_id!r}")
    application = manifest_by_id[application_id]
    if chain not in application["required_chains"] or chain in linked_chains[application_id]:
        raise SystemExit(
            f"{integration_manifest}: {application_id} has missing, duplicate or unexpected chain {chain!r}"
        )
    linked_chains[application_id].add(chain)
    declared_projects = set(application["platform_projects"])
    contract_projects = set(contract.get("platform_projects", []))
    if not contract_projects or not contract_projects <= declared_projects:
        raise SystemExit(
            f"{integration_manifest}: {contract_id} must use declared application platform projects"
        )
    use_cases = contract.get("use_cases", [])
    if not use_cases:
        raise SystemExit(f"{integration_manifest}: {contract_id} must link detailed use cases")
    for use_case in use_cases:
        use_case_path = root / use_case
        if not use_case.startswith("docs/use-cases/") or not use_case_path.is_file():
            raise SystemExit(f"{integration_manifest}: unresolved use case {use_case!r}")
    for field in (
        "application_owner",
        "contract_owner",
        "business_promise",
        "failure_behavior",
        "future_evidence",
    ):
        if not isinstance(contract.get(field), str) or len(contract[field].strip()) < 12:
            raise SystemExit(f"{integration_manifest}: {contract_id} missing useful {field}")
    if contract.get("documentation_state") != "linked":
        raise SystemExit(f"{integration_manifest}: {contract_id} is not linked in documentation")
    if contract.get("runtime_evidence_state") != "not-collected":
        raise SystemExit(f"{integration_manifest}: {contract_id} incorrectly implies runtime evidence")

for application_id, chains in linked_chains.items():
    required = set(manifest_by_id[application_id]["required_chains"])
    if chains != required:
        raise SystemExit(
            f"{integration_manifest}: {application_id} contract chains differ from its required chains"
        )

for contract in application_contracts:
    producer = contract.get("producer_application_id")
    consumer = contract.get("consumer_application_id")
    if producer not in application_ids or consumer not in application_ids or producer == consumer:
        raise SystemExit(
            f"{integration_manifest}: application contracts require two distinct registered applications"
        )
    for field in (
        "business_moment",
        "contract_owner",
        "versioning_rule",
        "failure_behavior",
        "future_evidence",
    ):
        if not isinstance(contract.get(field), str) or len(contract[field].strip()) < 12:
            raise SystemExit(f"{integration_manifest}: application contract missing useful {field}")

required_gap_portfolios = {
    "midhhealth/care-delivery-platform",
    "midhhealth/payer-operations-platform",
}
inventory_gaps = integration_data.get("inventory_gaps", [])
if {gap.get("portfolio") for gap in inventory_gaps} != required_gap_portfolios:
    raise SystemExit(f"{integration_manifest}: care and payer inventory gaps must remain explicit")
for gap in inventory_gaps:
    if gap.get("status") != "real-application-projects-not-registered":
        raise SystemExit(f"{integration_manifest}: invalid inventory-gap status")
    if len(gap.get("missing", [])) < 8:
        raise SystemExit(f"{integration_manifest}: inventory gap must name missing project facts")

all_docs = "\n".join(
    path.read_text(errors="replace")
    for path in (root / "docs").rglob("*.md")
)
for stale_path in (
    "midhhealth/platform-engineering/ansible-jenkins",
    "midhhealth/platform-delivery/awx-inventory",
):
    if stale_path in all_docs:
        raise SystemExit(f"Stale repository path remains in documentation: {stale_path}")

print(
    "Application project validation passed: "
    f"{len(known_projects)} platform projects, {len(applications)} applications, "
    f"{len(required_chains)} reusable chains, {len(platform_contracts)} documented "
    f"application-to-platform contracts, {len(application_contracts)} "
    "application-to-application contracts."
)
PY
