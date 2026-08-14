#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

required_docs=(
  ".gitlab-ci.yml"
  "README.md"
  "docs/enterprise-project-portfolio-and-usecases.md"
  "docs/application-project-deployment-register.md"
  "docs/application-projects.json"
  "docs/assets/application-project-deployment-model.svg"
  "docs/assets/applications/podinfo-deployment.svg"
  "docs/evidence/APP-PODINFO-001-source-review.md"
  "docs/evidence/APP-PODINFO-002-internal-project-ci.md"
  "docs/evidence/APP-PODINFO-003-release-contract-source.md"
  "docs/use-case-implementation-status.md"
  "docs/design-readiness-status.md"
  "docs/use-case-implementation-sequence.md"
  "docs/use-case-dependency-contracts.json"
  "docs/environment-capability-status.json"
  "docs/component-architecture.md"
  "docs/environment-details.md"
  "docs/vm-inventory.md"
  "docs/product-versions.md"
  "docs/product-migration-history.md"
  "docs/product-installation-elastic-stack.md"
  "docs/product-installation-splunk.md"
  "docs/sre-incident-register.md"
  "docs/jenkins-awx-ansible-operations.md"
  "docs/platform-engineering-interview-learning-labs.md"
  "docs/platform-usecase-learning-enhancement-plan.md"
  "docs/new-employee-platform-briefing.md"
  "docs/use-case-interview-question-bank.md"
  "docs/assets/platform-usecase-learning-enhancement-plan.svg"
  "docs/kubernetes-helm-delivery-runbook.md"
  "docs/gitlab-organization-model.md"
  "docs/engineer-interview-guide.md"
  "docs/engineer-training-standard.md"
  "docs/marketing-role-engineer-guide.md"
  "docs/projects/README.md"
  "docs/projects/application-deployment-record-template.md"
  "docs/projects/applications/podinfo.md"
  "docs/projects/devsecops-delivery.md"
  "docs/projects/multi-cloud-infrastructure.md"
  "docs/projects/kubernetes-platform.md"
  "docs/projects/observability-sre.md"
  "docs/projects/governance-operations.md"
  "docs/projects/linux-systems.md"
  "docs/projects/database-reliability.md"
  "docs/projects/resilience-service-operations.md"
  "docs/projects/data-engineering.md"
  "docs/projects/network-engineering.md"
  "docs/projects/healthcare-ai.md"
  "docs/projects/mlops-model-platform.md"
  "scripts/validate-platform-detail-pages.sh"
  "scripts/generate-use-case-interview-bank.py"
  "scripts/validate-onboarding-interview-docs.sh"
  "scripts/validate-design-consistency.sh"
  "scripts/generate-use-case-implementation-sequence.py"
  "docs/use-cases/README.md"
  "docs/use-cases/enterprise-traceability.md"
  "docs/use-cases/devsecops/README.md"
  "docs/use-cases/infrastructure/README.md"
  "docs/use-cases/kubernetes/README.md"
  "docs/use-cases/observability/README.md"
  "docs/use-cases/governance/README.md"
  "docs/use-cases/database/README.md"
  "docs/use-cases/resilience/README.md"
  "docs/use-cases/data/README.md"
  "docs/use-cases/network/README.md"
  "docs/use-cases/healthcare-ai/README.md"
  "docs/use-cases/mlops/README.md"
  "docs/use-cases/devsecops/UC-CICD-001-end-to-end-cicd-pipeline.md"
  "docs/use-cases/infrastructure/UC-INFRA-001-terraform-drift-detection.md"
  "docs/use-cases/kubernetes/UC-K8S-001-kubernetes-configuration-drift.md"
  "docs/use-cases/observability/UC-OBS-001-slo-as-code.md"
  "docs/use-cases/governance/UC-GOV-001-compliance-evidence-collection.md"
  "docs/use-cases/database/UC-DB-001-backup-restore-validation.md"
  "docs/use-cases/resilience/UC-RSO-001-operational-readiness-review.md"
  "docs/use-cases/data/UC-DATA-001-healthcare-feed-quality.md"
  "docs/use-cases/network/UC-NET-001-network-change-validation.md"
  "docs/use-cases/healthcare-ai/UC-AI-001-retrieval-augmented-generation.md"
  "docs/use-cases/mlops/UC-MLOPS-001-model-registry-versioning.md"
)

for path in "${required_docs[@]}"; do
  test -f "$path"
done

./scripts/validate-use-cases.sh
./scripts/generate-use-case-implementation-sequence.py --check
./scripts/validate-platform-detail-pages.sh
./scripts/validate-onboarding-interview-docs.sh
./scripts/validate-application-projects.sh
./scripts/validate-interview-learning-labs.sh
./scripts/validate-platform-enhancement-plan.sh
./scripts/validate-design-consistency.sh

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
use_case_count="$(
  awk '
    /^## Enterprise / { in_domain=1; in_table=0; next }
    /^## / { in_domain=0; in_table=0 }
    in_domain && /^\| Use case / { in_table=1; next }
    in_domain && in_table && /^\| ---/ { next }
    in_domain && in_table && /^\| [^|-]/ { count++ }
    END { print count+0 }
  ' "$portfolio"
)"
test "$use_case_count" -gt 0
declared_total="$({
  awk -F'|' '/^\| \*\*Total\*\* \| \*\*[0-9]+\*\* \|$/ { print $3 }' "$portfolio"
} | tr -d ' *')"
test "$declared_total" = "$use_case_count"

linux_use_case_count="$({
  awk '
    /^## Enterprise Linux Systems Engineering Platform/ { in_domain=1; in_table=0; next }
    /^## Enterprise / { if (in_domain) exit }
    in_domain && /^\| Use case / { in_table=1; next }
    in_domain && in_table && /^\| ---/ { next }
    in_domain && in_table && /^\| [^|-]/ { count++ }
    END { print count+0 }
  ' "$portfolio"
})"
declared_linux_count="$({
  awk -F'|' '/^\| 6\. Linux Systems Engineering \| [0-9]+ \|$/ { print $3 }' "$portfolio"
} | tr -d ' ')"
test "$declared_linux_count" = "$linux_use_case_count"
grep -q "elasticsearch01.example.com" docs/vm-inventory.md
grep -q "elasticsearch03.example.com" docs/vm-inventory.md
grep -q "splunk.example.com" docs/vm-inventory.md
grep -q "Elastic Stack | 9.4.2" docs/product-versions.md
grep -q "Splunk Enterprise | 10.4.1" docs/product-versions.md
grep -q "INC-2026-020" docs/sre-incident-register.md
grep -q "INC-2026-027" docs/sre-incident-register.md
grep -q "Filebeat | 9.4.2" docs/product-versions.md
grep -q "projects/run-ansible-playbook" docs/jenkins-awx-ansible-operations.md
grep -q "CONFIRM_APPLY" docs/jenkins-awx-ansible-operations.md
grep -q "AWX_SCM_CREDENTIAL_ID" docs/jenkins-awx-ansible-operations.md
grep -q "midhhealth/platform-delivery/jenkins-jobs" docs/jenkins-awx-ansible-operations.md
grep -q "midhhealth/platform-engineering/linux-systems-platform" docs/gitlab-organization-model.md
grep -q "midhhealth/platform-delivery/ansible-jenkins" docs/gitlab-organization-model.md
grep -q "midhhealth/platform-engineering/awx-inventory" docs/gitlab-organization-model.md
grep -q "midhhealth/platform-engineering/ansible-kubernetes" docs/gitlab-organization-model.md
grep -q "projects/deploy-kubernetes-ingress" docs/kubernetes-helm-delivery-runbook.md
grep -q "kubernetes-production-kubeconfig" docs/kubernetes-helm-delivery-runbook.md
grep -q "Helm | 4.1.0" docs/product-versions.md
grep -q "Chart 4.15.0; controller 1.15.1" docs/product-versions.md
grep -q "midhhealth/ai-and-ml-platform/healthcare-ai-platform" docs/gitlab-organization-model.md
grep -q "midhhealth/ai-and-ml-platform/mlops-model-platform" docs/gitlab-organization-model.md
grep -q "| Explicitly implemented first slices | 10 |" docs/use-case-implementation-status.md

if grep -R --line-number --exclude='sre-incident-register.md' \
  'infra01\.midhtech\.local' docs; then
  echo "Legacy infra01 hostname remains in active documentation." >&2
  exit 1
fi

if grep -q 'prometheus\.example\.com.*192\.168\.1\.109' docs/vm-inventory.md; then
  echo "Stale Prometheus address remains in canonical inventory." >&2
  exit 1
fi

if grep -R --line-number \
  -E 'awx(\.apps)?\.example\.com.*30080|192\.168\.1\.103:30080' \
  README.md docs; then
  echo "Stale AWX proxy port remains; the live AWX NodePort is 32000." >&2
  exit 1
fi

echo "Enterprise architecture documentation validation passed."
