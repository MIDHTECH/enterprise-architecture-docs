# DevSecOps Delivery Domain

**Repository:** `midhhealth/platform-delivery/devsecops-cicd-orchestrator`  
**Supporting repositories:** `jenkins-jobs`, `jenkins-shared-library`  
**Team size:** 6 engineers

## Team Responsibilities

The delivery team owns the path from source code to reviewed, tested,
scanned, deployable change. It provides the pipeline patterns used by care
delivery, payer operations, platform services, data, AI, and infrastructure
teams.

| Team member | Primary responsibility |
| --- | --- |
| Delivery Engineering Lead | Owns delivery standards, pipeline roadmap, review policy, release evidence, and cross-team adoption. |
| Jenkins Platform Engineer | Maintains Jenkins controllers, agents, credentials, job DSL, seed jobs, and pipeline reliability. |
| CI/CD Pipeline Engineer | Builds reusable build, test, package, promote, rollback, and deployment workflows. |
| DevSecOps Security Engineer | Maintains dependency, secret, IaC, image, and SAST/DAST scanning gates. |
| Release and Environment Engineer | Owns environment promotion, approvals, release notes, rollback records, and deployment evidence. |
| Developer Experience Engineer | Keeps templates, examples, onboarding docs, and local validation easy for application and platform teams. |

## Connected Teams

- Consumes standards from enterprise architecture and governance.
- Publishes Jenkins jobs and shared-library steps for every platform domain.
- Invokes AWX for Ansible-driven operations and deployment jobs.
- Receives health signals from observability before promotion or rollback.

## Executable Use-Case Scope

- End-to-end CI/CD pipeline setup.
- Automated build, unit test, quality gate, dependency scan, image scan, and secret scan.
- Artifact and image publishing.
- Environment promotion and rollback.
- Terraform plan automation for infrastructure changes.
- Deployment health scoring using SLO, alert, and runtime checks.

## Interview-led feedback and dependency analysis

The [AI-assisted pipeline and dependency track](../platform-engineering-interview-learning-labs.md#ai-pipeline-dependency-track)
adds two source-buildable capabilities to the existing delivery repository:
`tools/pipeline_feedback/` measures explicitly defined queue and feedback
intervals, and `tools/dependency_inventory/` normalizes approved manifest and
lockfile fixtures into JSON and Markdown evidence. Jenkins jobs and the shared
library remain the deployment path; Buildkite is neither installed nor added by
the learning exercise.

The team owns metric definitions, adapters, fixtures, schemas, pipeline
integration and before/after evidence. AI may assist with skeletons and tests,
but every generated line remains subject to deterministic validation, security
review and human ownership before it reaches a shared template.
