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

## What this platform must make routine

An engineer should be able to start with a reviewed commit and answer, without
reconstructing the story from several consoles: what was tested, which policy
checks ran, what immutable artifact was produced, who approved promotion, what
changed at the target, whether the service remained healthy, and how to return
to the previous release. The delivery platform exists to preserve that chain.

It does not own application behavior, cloud resources, Linux configuration, or
Kubernetes desired state. It coordinates the owners of those concerns and
keeps their results attached to one source revision.

![DevSecOps delivery architecture](../assets/project-1-delivery-architecture.svg)

## Delivery architecture

| Layer | Responsibility in the MidhHealth path | Source of truth |
| --- | --- | --- |
| Source review | Branch policy, merge request discussion, fast lint/unit/schema checks, and secret detection | Application or platform repository |
| Pipeline definition | Build classes, stage order, credentials, timeouts, retry policy, and evidence format | `jenkins-jobs` and `jenkins-shared-library` |
| Build execution | Isolated workspace, pinned toolchain, test execution, SBOM and artifact production | Dedicated Jenkins agent selected by label |
| Security decision | Dependency, source, IaC and image findings evaluated against documented policy | Pipeline result plus governance policy revision |
| Runtime change | Bounded AWX, Helm, Terraform, or future GitOps action owned by the target platform | Target-platform repository and approved change |
| Release judgment | Health, SLO and rollback evidence tied to the deployed digest | Observability results and release record |

GitLab CI is the repository gate and should finish quickly enough to support
review. Jenkins handles the longer, credentialed orchestration that spans
build, package, promotion and verification. AWX owns host changes through
Ansible. Helm is used for reviewed Kubernetes releases until an explicit
component handoff makes Argo CD the sole reconciler. These are complementary
boundaries, not interchangeable tool choices.

## Current lab truth

- GitLab, Jenkins, the dedicated Jenkins agent and AWX are operating. The
  Jenkins controller has zero executors; builds must not run on it.
- The shared-library AWX launcher and Kubernetes Helm workflow have accepted
  runtime evidence. Their job IDs and revisions remain in the change records.
- Harbor, Artifactory and SonarQube endpoints exist as routing placeholders,
  but the products are not installed. A page or pipeline must not describe a
  successful push or scan against them.
- Argo CD is still a bounded Kubernetes change, so Jenkins remains the
  bootstrap owner until that change is accepted and ownership is handed off.
- Elastic cloud agents and managed cloud runners are design options only. The
  verified static agent is the baseline against which later scaling is judged.

## Application onboarding contract

Before a project can use the delivery path, its deployment record supplies:

1. repository and accountable release owner;
2. build class, pinned toolchain and deterministic test commands;
3. artifact type, name, version and eventual registry destination;
4. dependency, secret, source and image policies that apply;
5. target platform, service identity and environment promotion sequence;
6. health endpoint, telemetry labels, SLO intent and rollback signal; and
7. the previous known-good artifact and the authority allowed to restore it.

The pipeline returns a release evidence manifest containing the Git revision,
pipeline and shared-library revisions, agent identity, test and scan results,
artifact digest, approval, target change reference, health result and rollback
reference. Missing evidence fails the promotion conversation; it is not filled
with a claim such as “passed manually.”

## Failure behavior

| Failure | Safe behavior | Evidence retained |
| --- | --- | --- |
| No matching agent or exhausted executor | Keep the build queued, expose queue age, and stop before credentials or target changes | Queue reason, requested label, wait interval |
| Test or policy failure | Stop before packaging or promotion; point to the failing rule and owning team | Logs, reports, policy revision |
| Artifact destination unavailable | Retain no ambiguous release; retry only the idempotent publish step when a real repository exists | Digest candidate, retry result, outage reference |
| AWX, Helm, or Terraform action fails | Stop later stages, collect target state, and use only the approved recovery path | Job/release/plan identity and observed state |
| Health gate fails after deployment | Hold promotion and invoke the documented rollback or incident decision | Release telemetry, decision maker, rollback result |

## Implementation sequence

1. Keep repository validation local and deterministic before it is put in a
   shared pipeline.
2. Generate multibranch jobs through Job DSL and call versioned shared-library
   steps instead of copying pipeline logic into every application.
3. Add an evidence manifest before adding target mutation; this makes dry runs
   and failures useful.
4. Prove build, test and package with a non-production fixture. Until a real
   registry is installed, validate the artifact and digest locally and label
   publication as pending.
5. Add one target adapter at a time—AWX, Helm, Terraform, then delegated
   GitOps—and prove that two systems never reconcile the same object.
6. Add release health and rollback using the observability and resilience
   contracts, then test repeated execution for convergence.

## Acceptance evidence

A capability is accepted only when its source revision, generated job,
execution identity, credential class, successful and deliberately failed run,
repeat convergence, recovery exercise and sanitized artifacts are recorded.
Queue duration and feedback time are measured separately so faster results do
not hide time spent waiting for an executor. The canonical detailed scenarios
remain in the [DevSecOps use-case index](../use-cases/devsecops/README.md).

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
