#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

required_docs=(
  ".gitlab-ci.yml"
  "README.md"
  "docs/five-project-architecture-and-usecases.md"
  "docs/component-architecture.md"
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
echo "Enterprise architecture documentation validation passed."
