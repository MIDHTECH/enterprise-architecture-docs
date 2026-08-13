#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

guide="docs/platform-engineering-interview-learning-labs.md"
test -f "$guide"
grep -q 'Platform Engineering Interview Learning Labs' "$guide"
grep -q 'documentation-only specification' "$guide"
grep -q 'does not install a Jenkins' "$guide"
grep -q 'employment production incidents' "$guide"

anchors=(
  elastic-jenkins-agents
  pipeline-tool-selection
  native-cpp-build
  terraform-state-drift
  boto3-s3-audit
  cost-overrun-remediation
  incident-command
  cloud-kubernetes-leadership-track
  ai-pipeline-dependency-track
  supported-reliability-operations-track
)

for anchor in "${anchors[@]}"; do
  grep -q "id=\"${anchor}\"" "$guide"
done

use_cases=(
  docs/use-cases/devsecops/UC-CICD-001-end-to-end-cicd-pipeline.md
  docs/use-cases/devsecops/UC-CICD-002-automated-build-pipeline.md
  docs/use-cases/devsecops/UC-CICD-003-automated-unit-testing-in-ci.md
  docs/use-cases/devsecops/UC-CICD-004-code-quality-gate-integration.md
  docs/use-cases/devsecops/UC-CICD-005-artifact-management-automation.md
  docs/use-cases/devsecops/UC-CICD-009-pipeline-template-standardization.md
  docs/use-cases/devsecops/UC-CICD-013-dependency-vulnerability-management.md
  docs/use-cases/devsecops/UC-CICD-014-terraform-plan-automation.md
  docs/use-cases/devsecops/UC-CICD-015-deployment-health-scoring.md
  docs/use-cases/infrastructure/UC-INFRA-001-terraform-drift-detection.md
  docs/use-cases/infrastructure/UC-INFRA-002-azure-infrastructure-provisioning-using-terraform.md
  docs/use-cases/infrastructure/UC-INFRA-007-infrastructure-change-impact-analysis.md
  docs/use-cases/infrastructure/UC-INFRA-009-terraform-state-integrity-monitoring.md
  docs/use-cases/governance/UC-GOV-004-cloud-iam-and-rbac-standardization.md
  docs/use-cases/governance/UC-GOV-006-cloud-misconfiguration-detector.md
  docs/use-cases/governance/UC-GOV-013-human-in-the-loop-remediation.md
  docs/use-cases/governance/UC-GOV-016-cloud-cost-anomaly-detection.md
  docs/use-cases/governance/UC-GOV-017-resource-right-sizing-automation.md
  docs/use-cases/kubernetes/UC-K8S-013-kubernetes-cost-allocation.md
  docs/use-cases/kubernetes/UC-K8S-002-aks-eks-gke-cluster-provisioning-automation.md
  docs/use-cases/kubernetes/UC-K8S-005-continuous-verification.md
  docs/use-cases/observability/UC-OBS-002-kubernetes-cluster-health-monitoring.md
  docs/use-cases/observability/UC-OBS-007-production-incident-troubleshooting-dashboard.md
  docs/use-cases/observability/UC-OBS-014-change-to-incident-correlation.md
  docs/use-cases/observability/UC-OBS-013-cloud-native-monitoring.md
  docs/use-cases/resilience/UC-RSO-004-incident-detection-and-classification.md
  docs/use-cases/resilience/UC-RSO-005-on-call-and-escalation-workflows.md
  docs/use-cases/resilience/UC-RSO-006-automated-incident-evidence-collection.md
  docs/use-cases/resilience/UC-RSO-007-post-incident-review.md
  docs/use-cases/resilience/UC-RSO-008-problem-management.md
  docs/use-cases/resilience/UC-RSO-009-service-ownership.md
  docs/use-cases/resilience/UC-RSO-014-chaos-and-failure-exercises.md
  docs/use-cases/resilience/UC-RSO-019-awx-automated-remediation.md
  docs/use-cases/observability/UC-OBS-001-slo-as-code.md
  docs/use-cases/observability/UC-OBS-006-alerting-and-on-call-notification.md
  docs/use-cases/observability/UC-OBS-010-database-performance-monitoring.md
  docs/use-cases/observability/UC-OBS-015-automated-incident-triage.md
  docs/use-cases/observability/UC-OBS-016-burn-rate-alerting.md
  docs/use-cases/resilience/UC-RSO-002-sli-and-slo-governance.md
  docs/use-cases/resilience/UC-RSO-012-capacity-and-saturation-testing.md
  docs/use-cases/linux/UC-LNX-014-performance-capacity-troubleshooting.md
  docs/use-cases/linux/UC-LNX-015-configuration-drift-detection.md
  docs/use-cases/linux/UC-LNX-019-linux-monitoring-incident-operations.md
  docs/use-cases/database/UC-DB-008-database-performance-monitoring.md
  docs/use-cases/database/UC-DB-011-connection-pooling.md
  docs/use-cases/database/UC-DB-014-capacity-forecasting.md
  docs/use-cases/database/UC-DB-019-database-incident-runbooks.md
  docs/use-cases/kubernetes/UC-K8S-001-kubernetes-configuration-drift.md
  docs/use-cases/kubernetes/UC-K8S-006-kubernetes-security-baseline-implementation.md
  docs/use-cases/kubernetes/UC-K8S-010-workload-right-sizing.md
  docs/use-cases/governance/UC-GOV-011-runbook-automation.md
  docs/use-cases/governance/UC-GOV-012-event-driven-remediation.md
  docs/use-cases/governance/UC-GOV-014-closed-loop-automation.md
  docs/use-cases/data/UC-DATA-018-pipeline-monitoring-and-alerting.md
)

for page in "${use_cases[@]}"; do
  test -f "$page"
  grep -q '../../platform-engineering-interview-learning-labs.md#' "$page"
  grep -Eq '^## (Enhancement|Interview conversation):' "$page"
  grep -q '^### Enhancement build and deployment binding$' "$page"
  grep -q '^## Implementation design$' "$page"
  question_count="$(grep -c '^- \*\*“' "$page")"
  if [[ "$question_count" -lt 3 ]]; then
    echo "$page has fewer than three use-case-specific interview questions." >&2
    exit 1
  fi
done

grep -q 'platform-engineering-interview-learning-labs.md' README.md
grep -q 'platform-engineering-interview-learning-labs.md' docs/engineer-interview-guide.md
grep -q '^## Enhancement buildability rule$' docs/use-cases/README.md
grep -q '^## Build and deployment gate for every learning enhancement$' "$guide"
grep -q '^## Track 4: Reliability work we can build on the current platform$' "$guide"
grep -q 'GPU placement.*are not current' "$guide"
grep -q 'cloud-kubernetes-leadership-track' docs/projects/multi-cloud-infrastructure.md
grep -q 'cloud-kubernetes-leadership-track' docs/projects/kubernetes-platform.md
grep -q 'Mentoring progression for cloud and platform engineers' docs/engineer-training-standard.md
grep -q '^## AI-assisted engineering standard$' docs/engineer-training-standard.md
grep -q 'ai-pipeline-dependency-track' docs/projects/devsecops-delivery.md

echo "Interview learning-lab documentation validation passed."
