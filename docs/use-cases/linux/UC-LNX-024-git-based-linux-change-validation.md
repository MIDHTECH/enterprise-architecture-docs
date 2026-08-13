# UC-LNX-024: Git-Based Linux Change Validation

Last verified: 2026-08-02

## Use-case record

| Field | Value |
| --- | --- |
| Portfolio | Enterprise Linux Systems Engineering Platform |
| Supporting use cases | [UC-INFRA-005](../infrastructure/UC-INFRA-005-server-configuration-automation-using-ansible.md), [UC-NET-005](../network/UC-NET-005-authoritative-and-recursive-dns.md), [UC-GOV-002](../governance/UC-GOV-002-secrets-management-automation.md), [UC-OBS-004](../observability/UC-OBS-004-centralized-log-management.md) |
| Canonical coverage target | Peer-reviewed source, CI checks, staged rollout, rollback and auditable change evidence |
| Delivery model | End-to-end infrastructure as code |
| Primary roles | Linux platform engineer, DevOps engineer, reviewer, change approver, SRE |
| Target environment | The linux-systems-platform repository, GitLab runners, Jenkins launcher, AWX project, and managed fleet |
| Current state | **Partially implemented. GitLab CI defines structure/syntax/lint jobs, but the recorded main pipeline failed for lack of a matching runner and no successful Linux pipeline/runtime chain is accepted.** |
| Related change | None; implementation requires a future approved change record |
| Owner | Linux Platform team |

## Purpose

Git helps only when a proposed Linux change can be understood before it reaches a host. Review, source tests, policy, plan output, approval, canary execution, rollback, and evidence stay tied to one revision.

## Expected outcome

A reviewer sees what changes, why it is safe, which tests ran, and which recovery path is ready. The same SHA reaches runtime, and the merge record links the operating result.

## Platform and enterprise fit

| Relationship | Detailed fit |
| --- | --- |
| Owning platform | **Git-Based Linux Change Validation** belongs to the the documented enterprise outcome because that platform turns GitLab-reviewed standards through Jenkins approval and Terraform/image or AWX/Ansible execution into verified operating-system state. |
| Enterprise consumers | The capability supports the Linux foundation beneath provider, payer, database, Kubernetes, observability, and shared services. |
| Enterprise outcome | Its planned result advances: the documented enterprise outcome. |
| Control contribution | The design adds repeatability, least privilege, canary scope, idempotence, recovery, and host-level evidence. |
| Cross-platform handoff | Supporting platforms consume a reviewed result or evidence artifact; they do not take ownership away from the primary platform. |
| Infrastructure boundary | Fit is achieved by reusing documented existing repositories, control planes, services, and targets—not by inventing capacity or treating planned products as available. |

The platform fit is therefore based on ownership and a reusable decision, not
on the presence of a particular tool. Enterprise fit requires evidence that the
named outcome was observed for the bounded scope; completing documentation or
running an isolated technology demonstration is insufficient.

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

## Architecture context

Git-Based Linux Change Validation is evaluated inside the existing enterprise lab and the owning
platform's current source-control and execution boundaries. The architectural
unit is the governed outcome—**Peer-reviewed source, CI checks, staged rollout, rollback and auditable change evidence**—rather than a new product or
environment.

| Context element | Architecture statement |
| --- | --- |
| Business and operational setting | Enterprise consumers: Enterprise Linux Systems Engineering Platform. The result must be explainable, repeatable, and owned. |
| Current state | **Partially implemented. GitLab CI defines structure/syntax/lint jobs, but the recorded main pipeline failed for lack of a matching runner and no successful Linux pipeline/runtime chain is accepted.** |
| Desired state | A reviewed contract drives a bounded result, machine-readable evidence, and a safe stop or recovery decision. |
| Existing target boundary | The linux-systems-platform repository, GitLab runners, Jenkins launcher, AWX project, and managed fleet |
| Infrastructure constraint | Use existing GitLab, Jenkins, AWX, libvirt, and inventoried hosts; no VM, IP, product, or capacity is authorized by this page |
| Accountable platform owner | Linux Platform team; the consuming service, data, security, or workflow owner remains accountable for accepting business impact. |

The page owns the contract, control logic, evidence, and recovery behavior for
Git-Based Linux Change Validation. It does not absorb the responsibilities of the dependency use cases
listed below.

## Architecture diagram

![UC-LNX-024 Git-Based Linux Change Validation architecture](../../assets/use-cases/UC-LNX-024/UC-LNX-024-architecture.svg)

Read this one left to right. The upper line follows a reviewed change toward a provable outcome; the lower branch shows who can stop it and how the team returns to a known release.

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

## Dependencies and handoffs

Git-Based Linux Change Validation remains accountable to its primary platform. The dependencies below
provide explicit contracts or assurance evidence; they do not become alternate owners.

| Relationship | Use case | Required handoff | Failure propagation |
| --- | --- | --- | --- |
| Required upstream contract | [UC-INFRA-005: Server Configuration Automation Using Ansible](../infrastructure/UC-INFRA-005-server-configuration-automation-using-ansible.md) | server configuration source and bounded Ansible execution | Missing, stale, or failed evidence blocks promotion or runtime action. |
| Required upstream contract | [UC-NET-005: Authoritative and Recursive DNS](../network/UC-NET-005-authoritative-and-recursive-dns.md) | authoritative name, resolver path, and expected DNS answer | Missing, stale, or failed evidence blocks promotion or runtime action. |
| Coordinated assurance handoff | [UC-GOV-002: Secrets Management Automation](../governance/UC-GOV-002-secrets-management-automation.md) | approved secret reference, redaction rule, and rotation owner | Missing, stale, or failed evidence blocks promotion or runtime action. |
| Coordinated assurance handoff | [UC-OBS-004: Centralized Log Management](../observability/UC-OBS-004-centralized-log-management.md) | sanitized log fields, source identity, and retention route | Missing, stale, or failed evidence blocks promotion or runtime action. |

Before Git-Based Linux Change Validation is implemented, every handoff must resolve to an immutable
revision and machine-readable artifact. A URL, screenshot, or verbal approval
alone is not sufficient dependency evidence.

## Quality attributes

For Git-Based Linux Change Validation, quality is measured against the bounded enterprise outcome—not
document length or a green job. Unapproved business thresholds remain explicit
decisions and must not be invented.

| Attribute | Required measure or invariant | Decision state |
| --- | --- | --- |
| Functional correctness | Every required input is validated; **Peer-reviewed source, CI checks, staged rollout, rollback and auditable change evidence** is evaluated against positive, negative, missing-input, and unauthorized-scope cases. | Fixed design requirement |
| Performance and scale | Establish a baseline for convergence time, idempotence, service health, and configuration drift on existing capacity; the owner must approve warning and blocking thresholds before runtime promotion. | Thresholds `TBD` before implementation |
| Reliability | Missing prerequisites, stale dependencies, malformed evidence, and partial results fail closed without widening scope. | Fixed design requirement |
| Recovery | Record the maximum acceptable interruption and recovery time before runtime use; source-only validation must remain zero-change. | Owner decision required before runtime exercise |
| Observability | Emit use-case ID, revision, target, executor, start/end time, duration, decision, reason code, and recovery reference. | Required in the result schema |
| Evidence retention | Assign classification, retention period, and deletion owner before storing runtime evidence. | Security/compliance decision required |

Load, latency, availability, retention, RTO, and RPO values for Git-Based Linux Change Validation become
requirements only after the named service or business owner approves them. Until
then, the implementation gate records them as unresolved instead of quietly
choosing defaults.

## Security and privacy architecture

The Git-Based Linux Change Validation design separates source validation, privileged execution, target
access, and evidence review. Those boundaries remain in force even when one
engineer can access more than one system.

| Trust boundary | Allowed flow | Required control |
| --- | --- | --- |
| Contributor → GitLab | Reviewed source, contract, and synthetic/sanitized fixtures | Protected branch rules, peer review, secret scanning, and immutable commit identity |
| GitLab runner → result artifact | Read-only evaluation inputs and machine-readable output | No target-changing credential; pinned tool versions; artifact checksum and expiry |
| Approval plane → executor | Approved revision, target allowlist, mode, canary, and change reference | Separate authorization through the existing Jenkins/AWX or platform control path |
| Executor → existing target | Minimum commands or API operations required for Git-Based Linux Change Validation | Least-privilege identity, explicit target limit, timeout, and stop condition |
| Target → evidence store | Sanitized metadata, measurements, decision, and recovery result | Exclude credentials, tokens, private keys, kubeconfigs, packet payloads, PHI, PII, and unrelated records |

For Git-Based Linux Change Validation, the primary threat is **host-level automation crossing its inventory, privilege, or credential boundary**. The mandatory response is
AWX inventory limits, purpose-specific credentials, check mode, canaries, protected variables, and exact rollback tasks. Authentication and authorization mappings must name
the existing identity source, principal or service account, permitted actions,
credential owner, rotation path, and emergency revocation procedure before a
runtime story can move beyond `Planned`.

## Architecture decisions and trade-offs

| Decision | Selected architecture | Alternative deferred or rejected | Rationale and status |
| --- | --- | --- | --- |
| First implementation slice | Contract, schema, fixtures, and read-only evidence on the existing GitLab runner | Product installation or broad runtime rollout | Proves behavior without expanding infrastructure; **approved design direction** |
| Runtime execution | Use only AWX controlled execution when current inventory and change approval confirm it is available | Direct operator changes or credentials in CI | Preserves separation of duties; **conditional on implementation review** |
| Evidence | Machine-readable result is authoritative; screenshots are optional supporting material | Screenshot-only acceptance | Enables repeatable audit and automated gates; **approved design direction** |
| Failure handling | Fail closed, preserve bounded diagnostics, and recover only the named scope | Continue with partial or stale evidence | Prevents false success and hidden blast radius; **approved design direction** |
| New capacity or product | Stop and raise a separate architecture decision | Silently add a VM, service, cloud dependency, or cluster add-on | Maintains the existing-lab constraint; **mandatory** |

### Open decisions before implementation

| Open decision | Decision owner | Resolution gate |
| --- | --- | --- |
| Exact inventory object and first canary | Platform owner plus consuming service/data owner | Must resolve before the implementation story leaves `Planned` |
| Performance, scale, and reliability thresholds | Service owner and SRE | Must be recorded before a runtime acceptance run |
| Identity-to-action authorization matrix | Platform owner and security reviewer | Must be approved before target credentials are attached |
| Evidence classification and retention | Data/security owner | Must be approved before runtime artifacts are retained |

If any selected approach changes, record the rationale beside UC-LNX-024 in
the implementation repository before code review. A documentation edit alone
does not approve the new architecture.

## Implementation design

The existing Linux code/configuration map remains authoritative; extend its named role and playbook rather than creating parallel automation.

| Planned source responsibility | Exact planned location |
| --- | --- |
| Use-case contract and target allowlist | `midhhealth/platform-engineering/linux-systems-platform/contracts/uc-lnx-024.yaml` |
| Primary implementation | `midhhealth/platform-engineering/linux-systems-platform/roles/git-based-linux-change-validation/tasks/main.yml`; entry point: the page's named Ansible role and verification tasks |
| Machine-readable result schema | `midhhealth/platform-engineering/linux-systems-platform/schemas/uc-lnx-024-result.schema.json` |
| Positive, negative, malformed, and recovery fixtures | `midhhealth/platform-engineering/linux-systems-platform/tests/fixtures/uc-lnx-024/` |
| GitLab source gate | `midhhealth/platform-engineering/linux-systems-platform/.gitlab/ci/uc-lnx-024.yml` |
| Operator diagnosis and recovery | `midhhealth/platform-engineering/linux-systems-platform/docs/runbooks/uc-lnx-024.md` |

### Delivery stages

1. **Contract:** add the contract, schema, owners, dependency revisions, target
   allowlist, modes, reason codes, and open-decision values.
2. **Source validation:** lint exact paths, validate schema compatibility, scan
   for sensitive content, and run every fixture on the existing runner.
3. **Read-only proof:** execute the page's named Ansible role and verification tasks, publish a checksummed result, and
   prove that blocked cases cannot reach a mutating path.
4. **Bounded execution:** only after separate approval, pass the immutable
   revision, target, mode, canary, and change ID to AWX controlled execution.
5. **Independent verification:** measure the expected result, confirm unrelated
   state is unchanged, run recovery or zero-change proof, and obtain owner
   review.

The implementation merge request must link this page, the dependency artifacts,
the decision values above, and the eventual pipeline/job/run identifiers. Code
completion alone cannot promote the page to runtime verified.

## Code and configuration map

The implementation map above distinguishes observed `Existing` paths from `Planned` IaC design targets. Planned paths must not be used as evidence of completion.

## Jira breakdown

### STORY-LNX-024-001: Implement and validate the source model

**Description:** The platform team keeps the inputs, roles or modules, tests, pipeline gates, and operating boundaries for Git-Based Linux Change Validation in Git. A reviewer can reproduce the proposal from the selected commit without relying on settings that exist only in a console.

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

**Description:** The operator reviews PLAN or CHECK output against one named canary before applying Git-Based Linux Change Validation. Failed health or negative tests stop the run, and expansion requires explicit approval.

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

**Description:** Operations accepts Git-Based Linux Change Validation only after the same revision converges cleanly, runtime health is visible, and the recovery path has been exercised. The evidence must explain what moved, what stayed stable, and how the team recovered it.

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
