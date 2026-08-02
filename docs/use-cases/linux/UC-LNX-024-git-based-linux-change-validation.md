# UC-LNX-024: Git-Based Linux Change Validation

Last verified: 2026-08-02

## Use-case record

| Field | Value |
| --- | --- |
| Portfolio | Enterprise Linux Systems Engineering Platform |
| Canonical coverage target | Peer-reviewed source, CI checks, staged rollout, rollback and auditable change evidence |
| Delivery model | End-to-end infrastructure as code |
| Primary roles | Linux platform engineer, DevOps engineer, reviewer, change approver, SRE |
| Target environment | The linux-systems-platform repository, GitLab runners, Jenkins launcher, AWX project, and managed fleet |
| Current state | **Partially implemented. GitLab CI defines structure/syntax/lint jobs, but the recorded main pipeline failed for lack of a matching runner and no successful Linux pipeline/runtime chain is accepted.** |
| Related change | None; implementation requires a future approved change record |
| Owner | Linux Platform team |

## Purpose

This use case implements **Git-Based Linux Change Validation** as a traceable IaC capability. Its operational trigger is: any linux inventory, variable, role, playbook, pipeline, or runbook change is proposed. Every outcome must be reproducible from reviewed source, bounded during execution, observable, idempotent, recoverable, and evidenced.

## Expected outcome

Peer-reviewed source, CI checks, staged rollout, rollback and auditable change evidence. Operators can trace the request to an immutable Git revision, review PLAN/CHECK, execute one canary, expand only through health gates, prove repeat convergence, recover through a tested path, and hand off evidence without relying on console memory.

## Trigger and actors

| Item | Definition |
| --- | --- |
| Trigger | Any Linux inventory, variable, role, playbook, pipeline, or runbook change is proposed |
| Engineering owners | Linux platform engineer, DevOps engineer, reviewer, change approver, SRE |
| Approver | Confirms scope, risk, window, plan, and recovery readiness |
| Operations/SRE | Reviews health, evidence, incident linkage, and acceptance |

## Preconditions

- The sequential change record authorizes this exact use case and no conflicting infrastructure work is active.
- GitLab, tagged runner, Jenkins, AWX, inventory, DNS, and observability dependencies are healthy.
- Exact target/canary limits and owners are known; secrets are referenced from approved systems.
- The selected SHA passed source, syntax, lint, policy, security, and plan/check gates.
- Recovery prerequisites and stop conditions are verified before mutation.

## Scope and exclusions

**In scope:** Branch/MR policy, CODEOWNERS, pipeline includes, tagged runners, lint/tests, inventory/schema checks, secret/policy scanning, artifact plan/check, approvals, AWX revision, canary, convergence, rollback, and evidence.

**Excluded:** Direct main commits, untagged runner dependence, manual AWX source edits, pipeline-success-as-runtime-acceptance, and emergency changes left unreconciled.

## IaC delivery model

| Layer | Responsibility |
| --- | --- |
| GitLab | Source of truth, merge request, protected branch, CI, immutable SHA, artifacts |
| Jenkins | Manual PLAN/CHECK/APPLY/ROLLBACK, approval, concurrency, evidence aggregation |
| Terraform/image automation | VM/image/volume/network lifecycle only when required |
| AWX and Ansible | OS desired state, inventory limit, check mode, serial rollout, job events |
| Observability/evidence | Health, logs, metrics, expected-versus-observed, incidents, acceptance |

Current-source reality: .gitlab-ci.yml, scripts/local-validate.sh, Ansible source, and AWX/Jenkins integration documentation exist; the end-to-end gate is not accepted.

## End-to-end implementation

### Code and configuration map

| State | Repository path | Responsibility |
| --- | --- | --- |
| Existing | `linux-systems-platform: .gitlab-ci.yml and scripts/local-validate.sh` | Structure, inventory, syntax, and ansible-lint source gates |
| Existing | `linux-systems-platform: docs/runbooks/awx-jenkins-integration.md` | Approved launcher and CONFIRM_APPLY contract |
| Planned | `linux-systems-platform: .gitlab/ci and tests` | Tagged-runner pipeline, schemas, Molecule/integration, policy, secrets, and artifact checks |

### Required variables and controls

| Variable/control | Example or constraint | Purpose |
| --- | --- | --- |
| `ci_runner_tags` | ansible,infra | Matches dedicated runner policy |
| `change_action` | plan/check/apply/rollback | Explicit stage boundary |
| `approved_git_sha` | immutable commit | Source/runtime traceability |
| `deployment_limit` | one canary then cohort | Blast-radius control |

### Delivery sequence

1. Define protected branch, merge request, CODEOWNERS, approval, signed/source provenance, and change-record requirements.
2. Run YAML, inventory graph/schema, syntax, ansible-lint, role tests, secret/dependency/policy scans, and documentation validation on tagged runners.
3. Publish immutable artifacts and reject broad targets, plaintext secrets, unsafe shell, destructive defaults, and missing rollback.
4. Have Jenkins select the reviewed SHA and reconcile AWX objects; run CHECK against one canary.
5. Require approval before APPLY, record AWX project revision/inventory/template/credential/limit, then validate runtime health.
6. Repeat for convergence, exercise rollback, link evidence/incidents, and merge only after review and green gates.

## Code and configuration map

The implementation map above distinguishes observed `Existing` paths from `Planned` IaC design targets. Planned paths must not be used as evidence of completion.

## Jira breakdown

### STORY-LNX-024-001: Implement and validate the source model

**Description:** As a Linux platform engineer, I need variables, roles/modules, tests, pipeline gates, and an operating contract for Git-Based Linux Change Validation so runtime work does not depend on undocumented console state.

**Status:** In progress only where supporting source is listed; the full source gate is not accepted.

**Acceptance criteria:**

- Inputs have schemas/defaults, safe bounds, ownership, and secret references.
- CI rejects malformed, unsafe, non-idempotent, and out-of-scope changes.
- CI publishes immutable SHA, exact assumptions, and plan/check artifacts.

**Implementation steps:**

1. Define protected branch, merge request, CODEOWNERS, approval, signed/source provenance, and change-record requirements.
2. Run YAML, inventory graph/schema, syntax, ansible-lint, role tests, secret/dependency/policy scans, and documentation validation on tagged runners.
3. Publish immutable artifacts and reject broad targets, plaintext secrets, unsafe shell, destructive defaults, and missing rollback.

**Completed work:** .gitlab-ci.yml, scripts/local-validate.sh, Ansible source, and AWX/Jenkins integration documentation exist; the end-to-end gate is not accepted.

**Validation and rollback:** Validate without runtime mutation; revert source and regenerate artifacts from the prior accepted revision if incorrect.

**Required attachments:** `ART-LNX-024-001` and `ATT-LNX-024-001`.

### STORY-LNX-024-002: Execute the bounded canary and rollout

**Description:** As an operator, I need an approved PLAN/CHECK and canary-first APPLY for Git-Based Linux Change Validation so unsafe behavior stops before fleet expansion.

**Status:** Planned; no runtime acceptance is claimed.

**Acceptance criteria:**

- Execution uses the reviewed SHA, credential references, inventory, variables, and canary limit.
- Health and negative tests pass before any cohort expansion.
- Failure thresholds stop the workflow and preserve evidence without hidden manual correction.

**Implementation steps:**

1. Have Jenkins select the reviewed SHA and reconcile AWX objects; run CHECK against one canary.
2. Require approval before APPLY, record AWX project revision/inventory/template/credential/limit, then validate runtime health.
3. Repeat for convergence, exercise rollback, link evidence/incidents, and merge only after review and green gates.

**Completed work:** The execution design is documented; no successful live canary is claimed.

**Validation and rollback:** Pipeline runs on the intended tagged runner and all required gates pass; AWX project revision equals the approved Git SHA and no UI-only drift exists; Canary APPLY and health checks pass before cohort expansion. Revert the source merge, resync AWX to the prior accepted SHA, run CHECK, then execute the use-case-specific compensating action. A pipeline revert alone does not undo runtime state.

**Required attachments:** `ART-LNX-024-002`, `ATT-LNX-024-002`, and `ATT-LNX-024-003`.

### STORY-LNX-024-003: Prove convergence, recovery, and handoff

**Description:** As an SRE, I need repeat convergence, runtime health, recovery proof, and an evidence package for Git-Based Linux Change Validation so the capability is supportable and auditable.

**Status:** Planned; blocked until the canary story succeeds.

**Acceptance criteria:**

- Repeating identical code and inputs produces zero unexpected change.
- Recovery is exercised and service returns within the approved objective.
- Logs, metrics, job output, owner, result, and incidents are linked.

**Implementation steps:**

1. Repeat the identical execution and compare the changed set.
2. Exercise the documented recovery path on the bounded target.
3. Verify service health, monitoring, security posture, and consumer access.
4. Publish sanitized evidence and obtain owner/SRE acceptance.

**Completed work:** Acceptance requirements are defined; no runtime proof is claimed.

**Validation and rollback:** Second APPLY is unchanged and rollback/recovery evidence is linked. Revert the source merge, resync AWX to the prior accepted SHA, run CHECK, then execute the use-case-specific compensating action. A pipeline revert alone does not undo runtime state.

**Required attachments:** `ART-LNX-024-003`, `ATT-LNX-024-004`, and `ATT-LNX-024-005`.

## Evidence and screenshot register

| ID | Required evidence | Source | Status |
| --- | --- | --- | --- |
| `ART-LNX-024-001` | CI, immutable SHA, and plan/check artifact | GitLab | Pending |
| `ATT-LNX-024-001` | Successful source pipeline | GitLab | Pending |
| `ART-LNX-024-002` | Canary execution and changed set | Jenkins/AWX/Terraform | Pending |
| `ATT-LNX-024-002` | Canary result | Control plane | Pending |
| `ATT-LNX-024-003` | Runtime health and expected state | Dashboard/CLI | Pending |
| `ART-LNX-024-003` | Second convergence and recovery log | Control plane | Pending |
| `ATT-LNX-024-004` | Recovery result | Control plane | Pending |
| `ATT-LNX-024-005` | Final accepted state | Dashboard/CLI | Pending |

## Expected versus current result

| Area | Expected | Current observation | Decision |
| --- | --- | --- | --- |
| Source | Complete IaC and pipeline for Git-Based Linux Change Validation | .gitlab-ci.yml, scripts/local-validate.sh, Ansible source, and AWX/Jenkins integration documentation exist; the end-to-end gate is not accepted. | Not yet code complete |
| Runtime | Approved canary/cohort execution | No accepted use-case run | Pending |
| Idempotence | Identical second run has zero unexpected change | No accepted convergence proof | Pending |
| Recovery | Recovery exercised and timed | No accepted recovery artifact | Pending |
| Evidence | Sanitized artifacts tied to immutable executions | Register defined; captures pending | Pending |

## Validation, idempotence, and rollback

- Pipeline runs on the intended tagged runner and all required gates pass.
- AWX project revision equals the approved Git SHA and no UI-only drift exists.
- Canary APPLY and health checks pass before cohort expansion.
- Second APPLY is unchanged and rollback/recovery evidence is linked.

**Rollback/recovery:** Revert the source merge, resync AWX to the prior accepted SHA, run CHECK, then execute the use-case-specific compensating action. A pipeline revert alone does not undo runtime state.

Idempotence means the same reviewed revision, target, variables, and action produces zero unexplained changes plus stable consumer health. First-run success is not enough.

## Troubleshooting guide

Primary scenario: **GitLab is green, but AWX executes an older project revision against the full inventory.**

1. Stop propagation and preserve SHA, plan/check, execution IDs, timestamps, and targets.
2. Isolate source, orchestration, infrastructure, connectivity, privilege, host state, and consumer health.
3. Compare live facts with intended variables and the last accepted baseline; correlate logs/metrics to the window.
4. Reproduce only on the canary or in PLAN/CHECK and change one hypothesis at a time.
5. Recover through the documented path and record unexpected failures or near misses.

## Interview preparation

1. **Question:** Explain the end-to-end IaC architecture for Git-Based Linux Change Validation.
   **Answer signals:** Cover GitLab review and CI, Jenkins approval, Terraform/image ownership where relevant, AWX/Ansible execution, observability, convergence, recovery, and evidence.

2. **Question:** How would you make the implementation idempotent and reusable?
   **Answer signals:** ci_runner_tags, change_action, approved_git_sha, deployment_limit; explicit schemas, stable identities, bounded targets, deterministic tasks, and no UI-only state.

3. **Question:** What pipeline and plan/check evidence is required before APPLY?
   **Answer signals:** Pipeline runs on the intended tagged runner and all required gates pass; AWX project revision equals the approved Git SHA and no UI-only drift exists; immutable SHA, runner identity, target assumptions, scan/test results, and no exposed secret.

4. **Question:** Troubleshooting scenario: GitLab is green, but AWX executes an older project revision against the full inventory. How do you respond?
   **Answer signals:** Stop propagation, preserve execution evidence, verify target and source revision, isolate the failed layer, compare live facts to desired/baseline, and test recovery on the canary.

5. **Question:** How do you prove idempotence?
   **Answer signals:** Repeat identical SHA, inputs, target, credentials scope, and action; require zero unexplained changes plus stable health and equivalent evidence.

6. **Question:** What rollback or recovery path would you defend?
   **Answer signals:** Revert the source merge, resync AWX to the prior accepted SHA, run CHECK, then execute the use-case-specific compensating action. A pipeline revert alone does not undo runtime state.

7. **Question:** Which security/audit controls should an interviewer hear?
   **Answer signals:** Protected source, least privilege, secret references, approval gates, short-lived access, canary limits, immutable artifacts, exception expiry, and incident linkage.

8. **Question:** Discuss the tradeoff between delivery speed and evidence-rich gated change.
   **Answer signals:** Frame business impact and failure modes, choose a safe default, measure canary results, keep recovery available, and document justified exceptions.

9. **Question:** Tell me about a time you owned a difficult Git-Based Linux Change Validation change or incident across multiple teams. What did you do?
   **Answer signals:** Use a concise STAR example showing ownership, risk communication, evidence-based decisions, a safe stop or rollback, collaboration with service/security/SRE owners, measurable recovery or improvement, and a durable IaC correction.

## Safety and security controls

- Protected source, merge requests, tagged runners, immutable revisions, and retained artifacts.
- Least-privilege credentials referenced from approved secret systems.
- PLAN/CHECK by default; APPLY/ROLLBACK requires confirmation and exact target limits.
- Canary rollout, failure thresholds, health gates, and stop conditions.
- No credentials, private keys, secrets, or protected health information in artifacts.

## Acceptance decision

UC-LNX-024 is **not yet accepted**. Acceptance requires implemented source, passing CI, controlled execution, runtime health, zero-change second convergence, exercised recovery, reviewed evidence, and publication on the canonical branch.
