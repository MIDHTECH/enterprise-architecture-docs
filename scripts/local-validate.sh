#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

required_docs=(
  ".gitlab-ci.yml"
  "README.md"
  "docs/five-project-architecture-and-usecases.md"
  "docs/component-architecture.md"
  "docs/environment-details.md"
  "docs/vm-inventory.md"
  "docs/product-versions.md"
  "docs/product-migration-history.md"
  "docs/product-installation-elastic-stack.md"
  "docs/product-installation-splunk.md"
  "docs/sre-incident-register.md"
  "docs/engineer-interview-guide.md"
  "docs/engineer-training-standard.md"
  "docs/marketing-role-engineer-guide.md"
)

for path in "${required_docs[@]}"; do
  test -f "$path"
done

grep -q "cloud-infra-automation-platform" docs/five-project-architecture-and-usecases.md
grep -q "devsecops-cicd-orchestrator" docs/five-project-architecture-and-usecases.md
grep -q "kubernetes-platform-gitops" docs/five-project-architecture-and-usecases.md
grep -q "observability-sre-platform" docs/five-project-architecture-and-usecases.md
grep -q "cloud-governance-ops-automation" docs/five-project-architecture-and-usecases.md
grep -q "elasticsearch01.example.com" docs/vm-inventory.md
grep -q "elasticsearch03.example.com" docs/vm-inventory.md
grep -q "splunk.example.com" docs/vm-inventory.md
grep -q "Elastic Stack | 9.4.2" docs/product-versions.md
grep -q "Splunk Enterprise | 10.4.1" docs/product-versions.md
grep -q "INC-2026-020" docs/sre-incident-register.md

if grep -R --line-number --exclude='sre-incident-register.md' \
  'infra01\.midhtech\.local' docs; then
  echo "Legacy infra01 hostname remains in active documentation." >&2
  exit 1
fi

if grep -q 'prometheus\.example\.com.*192\.168\.1\.109' docs/vm-inventory.md; then
  echo "Stale Prometheus address remains in canonical inventory." >&2
  exit 1
fi

echo "Enterprise architecture documentation validation passed."
