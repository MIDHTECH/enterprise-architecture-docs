#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

plan="docs/platform-usecase-learning-enhancement-plan.md"
diagram="docs/assets/platform-usecase-learning-enhancement-plan.svg"

test -f "$plan"
test -f "$diagram"
grep -q 'platform-usecase-learning-enhancement-plan.svg' "$plan"
grep -q 'Platform and Use-Case Learning Enhancement Plan' README.md
grep -q 'platform-usecase-learning-enhancement-plan.md' docs/use-cases/enterprise-traceability.md

platforms=(
  'DevSecOps delivery'
  'Multi-cloud infrastructure'
  'Kubernetes platform'
  'Observability and SRE'
  'Governance and operations automation'
  'Linux systems engineering'
  'Database reliability'
  'Resilience and service operations'
  'Data engineering and integration'
  'Network engineering and automation'
  'Healthcare AI platform'
  'MLOps model platform'
)

for platform in "${platforms[@]}"; do
  grep -q "^### [0-9][0-9]*\. ${platform}$" "$plan"
done

for wave in 0 1 2 3 4 5; do
  grep -q "^### Wave ${wave} " "$plan"
done

required_boundaries=(
  'does not deploy an application'
  'Do not invent provider or payer applications'
  'Reuse the current GitLab'
  'documented design is not implemented'
  'No registry service, feature store, serving platform or cloud'
  'stop at design and open a separate architecture'
)

for boundary in "${required_boundaries[@]}"; do
  grep -q "$boundary" "$plan"
done

grep -q '<title id="title">' "$diagram"
grep -q '<desc id="desc">' "$diagram"
grep -q 'Twelve shared platform capability rails' "$diagram"
grep -q 'Independent application projects' "$diagram"
grep -q 'Integrated enterprise outcomes' "$diagram"
grep -q 'Learning and evidence loop' "$diagram"

echo "Platform and use-case enhancement plan validation passed."
