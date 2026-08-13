#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

platform_records=(
  "docs/projects/devsecops-delivery.md|../assets/project-1-delivery-architecture.svg"
  "docs/projects/multi-cloud-infrastructure.md|../assets/project-2-hybrid-infrastructure-architecture.svg"
  "docs/projects/kubernetes-platform.md|../assets/project-3-kubernetes-gitops-architecture.svg"
  "docs/projects/observability-sre.md|../assets/project-4-sre-observability-architecture.svg"
  "docs/projects/governance-operations.md|../assets/project-5-governance-automation-architecture.svg"
  "docs/projects/linux-systems.md|../assets/project-6-linux-systems-architecture.svg"
  "docs/projects/database-reliability.md|../assets/project-7-database-reliability-architecture.svg"
  "docs/projects/resilience-service-operations.md|../assets/project-8-resilience-operations-architecture.svg"
  "docs/projects/data-engineering.md|../assets/project-9-data-engineering-architecture.svg"
  "docs/projects/network-engineering.md|../assets/project-10-network-engineering-architecture.svg"
  "docs/projects/healthcare-ai.md|../assets/project-11-healthcare-ai-architecture.svg"
  "docs/projects/mlops-model-platform.md|../assets/project-12-mlops-model-architecture.svg"
)

for record in "${platform_records[@]}"; do
  page="${record%%|*}"
  diagram="${record#*|}"

  test -f "$page"

  line_count="$(wc -l < "$page" | tr -d ' ')"
  if [[ "$line_count" -lt 100 ]]; then
    echo "$page: platform detail page has only $line_count lines; expected at least 100." >&2
    exit 1
  fi

  if [[ "$(grep -Fc "($diagram)" "$page")" -ne 1 ]]; then
    echo "$page: expected exactly one architecture-diagram link to $diagram." >&2
    exit 1
  fi

  if ! grep -Eq '^## .*(Failure|failure|Recovery|recovery)' "$page"; then
    echo "$page: missing a platform-specific failure or recovery section." >&2
    exit 1
  fi

  if ! grep -Eq '^## .*(Implementation|implementation|Build|build)' "$page"; then
    echo "$page: missing implementation or build guidance." >&2
    exit 1
  fi

  if ! grep -Eq '^## .*(Acceptance|acceptance)' "$page"; then
    echo "$page: missing an acceptance-evidence section." >&2
    exit 1
  fi

  if ! grep -Eqi 'current|running|installed|active lab|accepted' "$page"; then
    echo "$page: missing current-state language." >&2
    exit 1
  fi
done

echo "Platform detail-page validation passed (${#platform_records[@]} platform pages)."
