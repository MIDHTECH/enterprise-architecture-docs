# Enterprise Branching Strategy

This standard applies to every active or future repository in the enterprise
platform portfolio. The goal is to keep delivery simple, auditable, and
enterprise-ready while supporting CI/CD, infrastructure, GitOps,
observability, governance, Linux systems, database reliability, service
operations, data engineering, network engineering, Jenkins jobs, and shared
libraries.

## Branching Model

Use a trunk-based GitLab flow:

```text
main
  feature/<ticket-or-topic>
  fix/<ticket-or-topic>
  docs/<topic>
  hotfix/<incident-or-issue>
  release/<version>        optional
```

`main` is the protected source of truth. All work enters `main` through merge requests.

## Branch Types

| Branch type | Purpose | Example |
| --- | --- | --- |
| `main` | Stable, reviewed, protected branch | `main` |
| `feature/*` | New project functionality | `feature/terraform-network-module` |
| `fix/*` | Defect correction | `fix/jenkins-awx-timeout` |
| `docs/*` | Documentation-only changes | `docs/engineer-training-standard` |
| `hotfix/*` | Urgent production or platform fix | `hotfix/prod-ingress-certificate` |
| `release/*` | Optional release stabilization branch | `release/2026.07` |

## Protected Branch Rules

Protect `main` in every project:

- No direct pushes to `main`.
- Merge requests are required.
- At least one approval is required.
- Pipeline must pass before merge.
- Maintainer approval is required for production-impacting changes.
- Security, infrastructure, or governance changes require domain-owner review.

## Merge Request Standard

Every merge request should include:

- Problem being solved.
- Files or components changed.
- Validation performed.
- Risk and rollback notes.
- Screenshots or command output when useful.
- Linked work item, ticket, or project task when available.

## Pipeline Expectations

| Branch | Pipeline behavior |
| --- | --- |
| `feature/*` | Validate, lint, unit test, scan, and produce plans/previews |
| `fix/*` | Validate, test, scan, and prove the issue is fixed |
| `docs/*` | Markdown/link checks where available |
| `hotfix/*` | Run the smallest safe validation set plus required security checks |
| `main` | Full validation, release packaging, deployment, apply, or sync depending on repo type |
| `release/*` | Stabilization, regression validation, release notes, and controlled deployment |

## Environment Strategy

Do not create long-lived branches named `dev`, `qa`, `stage`, or `prod` for normal work. Environment separation should be represented through folders, variables, deployment approvals, protected environments, or GitOps overlays.

Recommended pattern:

```text
main
terraform/environments/dev
terraform/environments/qa
terraform/environments/stage
terraform/environments/prod
clusters/dev
clusters/qa
clusters/stage
clusters/prod
```

This keeps the Git history clean and avoids environment branches drifting apart.

## Release and Tagging Standard

Use tags for released versions:

```text
v2026.07.1
v2026.07.2
```

Use release branches only when the team needs a stabilization window before production deployment.

## Repository-Specific Guidance

| Repository | Branching guidance |
| --- | --- |
| `enterprise-architecture-docs` | Use `docs/*` branches for documentation updates. Merge through review so architecture changes are visible and auditable. |
| `devsecops-cicd-orchestrator` | Use `feature/*` or `fix/*` for pipeline/application changes. `main` should trigger the full CI/CD validation path. |
| `cloud-infra-automation-platform` | Use feature branches for Terraform and Ansible changes. Merge requests must include `terraform plan` output and rollback notes. |
| `kubernetes-platform-gitops` | Use feature branches for manifests, Helm values, policies, and cluster overlays. `main` represents approved desired state. |
| `observability-sre-platform` | Use feature branches for dashboards, alerts, collectors, SLOs, and runbooks. Alert changes should include expected signal/noise impact. |
| `cloud-governance-ops-automation` | Use feature branches for IAM, secrets, compliance, backup, cost, certificate, and remediation changes. Security/governance approval is required. |
| `linux-systems-platform` | Use feature branches for inventories, roles, assessment playbooks, and evidence schemas. State-changing host work requires check-mode evidence. |
| `database-reliability-platform` | Use feature branches for database assessment and lifecycle automation. Backup and recovery changes require restore evidence. |
| `resilience-service-operations` | Use feature branches for SLO, incident, exercise, readiness, and recovery automation. Include expected operational impact. |
| `data-engineering-platform` | Use feature branches for source, quality, orchestration, lineage, and access evidence. Schema or contract changes require compatibility notes. |
| `network-engineering-platform` | Use feature branches for source-of-truth, DNS, connectivity, firewall, and Kubernetes network automation. Include pre/post validation and rollback. |
| `healthcare-ai-platform` | Use feature branches for AI evaluation, RAG, agent, safety, and audit work. Model or prompt changes require evaluation evidence. |
| `mlops-model-platform` | Use feature branches for model lifecycle, serving, monitoring, drift, and governance changes. Promotion requires model evidence and rollback. |
| `ansible-jenkins` | Use feature branches for Jenkins lifecycle roles and validation. Preserve controller data and test upgrades on a canary. |
| `ansible-kubernetes` | Use feature branches for cluster lifecycle automation. Record API compatibility, node sequencing, and recovery steps. |
| `ansible-observability` | Use feature branches for product installation and telemetry transport. Validate health, persistence, and end-to-end signal delivery. |
| `ansible-prometheus` | Use feature branches for metrics components, exporters, targets, and dashboards. Validate target and alert state. |
| `awx-inventory` | Use feature branches for inventory groups and controller mappings. Validate host reachability and prevent secrets from entering inventory. |
| `jenkins-jobs` | Use feature branches for Job DSL changes. Seed job updates should be reviewed before applying to Jenkins. |
| `jenkins-shared-library` | Use feature branches for shared pipeline logic. Breaking changes require versioning or coordinated updates to consuming Jenkinsfiles. |

## Operating Model

The platform uses a trunk-based GitLab flow with protected `main` as the stable
source of truth. Engineers work in short-lived feature, fix, docs, or hotfix
branches and merge through reviewed merge requests. Pipelines validate the
work, and production-impacting changes need approval, evidence, and rollback
notes. Environments stay in folders, variables, protected environments, and
GitOps overlays instead of long-lived environment branches.

## Troubleshooting and Rollback

If a bad change is merged:

1. Stop or pause the affected deployment pipeline if it is still running.
2. Identify the merge request and commit that introduced the issue.
3. Revert the commit through a new merge request when possible.
4. For urgent production issues, create `hotfix/<issue>` from the last known good state.
5. Validate the rollback or hotfix in the pipeline.
6. Capture incident evidence and update the runbook if needed.

## Training Standard

Engineers should be able to answer:

- Why `main` is protected.
- Why feature branches are short-lived.
- Why environment branches are avoided.
- What validation runs before merge.
- What approval is required for production-impacting changes.
- How rollback works when a bad change is merged.
- How this strategy changes slightly for Terraform, GitOps, Jenkins, and governance repositories.
