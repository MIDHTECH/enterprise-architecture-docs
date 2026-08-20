#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

python3 - "$ROOT_DIR" <<'PY'
from pathlib import Path
from urllib.parse import unquote
import json
import re
import sys

root = Path(sys.argv[1])
manifest_path = root / "docs/environment-capability-status.json"
manifest = json.loads(manifest_path.read_text())

expected = {
    "harbor": "accepted",
    "vault": "installed-not-accepted",
    "keycloak": "requires-revalidation",
    "artifactory": "provisioned-only",
    "sonarqube": "provisioned-only",
    "splunk": "provisioned-only",
    "argocd": "not-installed",
    "external-secrets-operator": "not-installed",
    "kubernetes-ingress": "accepted",
    "longhorn": "accepted",
    "internal-tls": "partial",
    "public-cloud": "target-only",
    "business-applications": "target-only",
}
actual = {
    name: record.get("product_status")
    for name, record in manifest.get("capabilities", {}).items()
}
if actual != expected:
    raise SystemExit(
        f"{manifest_path}: capability state differs from the reviewed design: {actual}"
    )

required_phrases = {
    "docs/environment-details.md": (
        "Harbor 2.15.0 installed and healthy",
        "External Secrets Operator is a planned",
        "requires revalidation",
        "partially adopted rather than globally installed",
    ),
    "docs/projects/devsecops-delivery.md": (
        "Harbor 2.15.0 is installed and healthy",
        "Artifactory and SonarQube remain provisioned-only",
    ),
    "docs/new-employee-platform-briefing.md": (
        "Harbor is installed and healthy",
        "Keycloak requires revalidation",
        "cloud accounts are target architecture",
    ),
    "docs/component-architecture.md": (
        "AWS / Azure / GCP - target only",
        "Jenkins and Helm remain the accepted release path",
        "worker-only Longhorn 1.12.0 V1",
    ),
    "docs/design-readiness-status.md": (
        "The current program phase is **architecture and implementation design**",
        "Real provider application design | Blocked on inventory",
        "Real payer application design | Blocked on inventory",
    ),
}
for relative, phrases in required_phrases.items():
    text = (root / relative).read_text()
    for phrase in phrases:
        if phrase not in text:
            raise SystemExit(f"{relative}: missing reviewed design statement {phrase!r}")

active_documents = [root / "README.md", *sorted((root / "docs").rglob("*.md"))]
active_text = "\n".join(path.read_text(errors="replace") for path in active_documents)
if re.search(r"\bmaas\b", active_text, re.I):
    raise SystemExit("Unrelated MAAS scope remains in active MidhHealth documentation")

forbidden = {
    "docs/environment-details.md": (
        r"Harbor[^\n]*product not installed",
        r"Human users authenticate through Keycloak",
        r"Kubernetes retrieves secrets through External Secrets Operator",
        r"Internal TLS is not installed",
    ),
    "docs/projects/devsecops-delivery.md": (
        r"Harbor[^\n]*products are not installed",
    ),
    "docs/new-employee-platform-briefing.md": (
        r"Keycloak, Harbor[^\n]*must not be read as installed products",
    ),
}
for relative, patterns in forbidden.items():
    text = (root / relative).read_text()
    for pattern in patterns:
        if re.search(pattern, text, re.I):
            raise SystemExit(f"{relative}: stale current-state language matches {pattern!r}")

integration = json.loads((root / "docs/application-integration-contracts.json").read_text())
if integration.get("application_to_application_contracts"):
    raise SystemExit("Application contracts were added without real application inventory review")
gap_portfolios = {item.get("portfolio") for item in integration.get("inventory_gaps", [])}
if gap_portfolios != {
    "midhhealth/care-delivery-platform",
    "midhhealth/payer-operations-platform",
}:
    raise SystemExit("Care and payer application design blockers are not recorded exactly")

broken = []
link_pattern = re.compile(r"!?\[[^]]*\]\(([^)]+)\)")
for document in active_documents:
    text = document.read_text(errors="replace")
    for raw_target in link_pattern.findall(text):
        target = raw_target.strip().strip("<>")
        if not target or target.startswith(("http://", "https://", "mailto:", "#")):
            continue
        target = unquote(target.split("#", 1)[0])
        if not target:
            continue
        resolved = (document.parent / target).resolve()
        if not resolved.exists():
            broken.append(f"{document.relative_to(root)} -> {target}")
if broken:
    raise SystemExit("Broken local documentation links:\n" + "\n".join(broken))

print(
    "Design consistency validation passed "
    f"({len(expected)} capability states; no scope leakage or broken local links)."
)
PY
