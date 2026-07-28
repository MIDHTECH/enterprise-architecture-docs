#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

required_docs=(
  ".gitlab-ci.yml"
  "README.md"
  "docs/enterprise-project-portfolio-and-usecases.md"
  "docs/component-architecture.md"
  "docs/environment-details.md"
  "docs/vm-inventory.md"
  "docs/product-versions.md"
  "docs/product-migration-history.md"
  "docs/product-installation-elastic-stack.md"
  "docs/product-installation-splunk.md"
  "docs/sre-incident-register.md"
  "docs/jenkins-awx-ansible-operations.md"
  "docs/gitlab-organization-model.md"
  "docs/engineer-interview-guide.md"
  "docs/engineer-training-standard.md"
  "docs/marketing-role-engineer-guide.md"
)

for path in "${required_docs[@]}"; do
  test -f "$path"
done

portfolio="docs/enterprise-project-portfolio-and-usecases.md"
grep -q "cloud-infra-automation-platform" "$portfolio"
grep -q "devsecops-cicd-orchestrator" "$portfolio"
grep -q "kubernetes-platform-gitops" "$portfolio"
grep -q "observability-sre-platform" "$portfolio"
grep -q "cloud-governance-ops-automation" "$portfolio"
grep -q "linux-systems-platform" "$portfolio"
grep -q "database-reliability-platform" "$portfolio"
grep -q "resilience-service-operations" "$portfolio"
grep -q "data-engineering-platform" "$portfolio"
grep -q "network-engineering-platform" "$portfolio"
grep -q "healthcare-ai-platform" "$portfolio"
grep -q "mlops-model-platform" "$portfolio"
grep -Fq '| **Total** | **217** |' "$portfolio"
use_case_count="$(
  awk '
    /^## Project [0-9]+:/ { in_project=1; next }
    /^## / { in_project=0 }
    in_project && /^\| [^|-]/ && $0 !~ /^\| Use case / { count++ }
    END { print count+0 }
  ' "$portfolio"
)"
test "$use_case_count" -eq 217
grep -q "elasticsearch01.example.com" docs/vm-inventory.md
grep -q "elasticsearch03.example.com" docs/vm-inventory.md
grep -q "splunk.example.com" docs/vm-inventory.md
grep -q "Elastic Stack | 9.4.2" docs/product-versions.md
grep -q "Splunk Enterprise | 10.4.1" docs/product-versions.md
grep -q "INC-2026-020" docs/sre-incident-register.md
grep -q "projects/run-ansible-playbook" docs/jenkins-awx-ansible-operations.md
grep -q "CONFIRM_APPLY" docs/jenkins-awx-ansible-operations.md
grep -q "AWX_SCM_CREDENTIAL_ID" docs/jenkins-awx-ansible-operations.md
grep -q "midhhealth/platform-delivery/jenkins-jobs" docs/jenkins-awx-ansible-operations.md
grep -q "midhhealth/platform-engineering/linux-systems-platform" docs/gitlab-organization-model.md
grep -q "midhhealth/ai-and-ml-platform/healthcare-ai-platform" docs/gitlab-organization-model.md
grep -q "midhhealth/ai-and-ml-platform/mlops-model-platform" docs/gitlab-organization-model.md

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
