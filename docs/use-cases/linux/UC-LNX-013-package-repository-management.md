# UC-LNX-013: Package Repository Management

Last verified: 2026-08-02

## Use-case record

| Field | Value |
| --- | --- |
| Portfolio | Enterprise Linux Systems Engineering Platform |
| Canonical coverage target | Approved and pinned software sources |
| Delivery model | End-to-end infrastructure as code |
| Primary roles | Linux platform engineer, security engineer, artifact/repository owner, application owner |
| Target environment | Rocky and Ubuntu package-manager configuration on managed hosts |
| Current state | **Partially implemented. Enabled-repository review exists; mirror/source enforcement, key rotation, pinning, and rollback are planned.** |
| Related change | None; implementation requires a future approved change record |
| Owner | Linux Platform team |

## Purpose

This use case implements **Package Repository Management** as reviewed desired state with operational evidence. Its trigger is: a repository, signing key, mirror, package stream, or exception must change. The outcome must be reproducible from Git, bounded during execution, observable at runtime, idempotent on repeat, and recoverable without hidden console state.

## Expected outcome

Approved and pinned software sources. An engineer can trace the request to an immutable revision, review PLAN/CHECK output, execute a canary through the approved control plane, expand safely, prove zero unexpected change, recover, and hand the control to operations.

## Trigger and actors

| Item | Definition |
| --- | --- |
| Trigger | A repository, signing key, mirror, package stream, or exception must change |
| Engineering owners | Linux platform engineer, security engineer, artifact/repository owner, application owner |
| Approver | Confirms target, risk, maintenance window, evidence, and recovery readiness |
| SRE/operations | Reviews health, alerts, incidents, convergence, and handoff |

## Preconditions

- The sequential change record authorizes this exact use case and no conflicting infrastructure work is active.
- GitLab, tagged runners, Jenkins, AWX, inventory, DNS, and observability dependencies are healthy.
- Target and canary limits are explicit; credentials are referenced from approved secret systems.
- The selected Git SHA passed syntax, lint, policy, secret, and plan/check gates.
- Required backup, console, replacement, or recovery evidence exists before mutation.

## Scope and exclusions

**In scope:** Repository files, URLs, TLS, GPG keys, priorities/pinning, module streams, proxy/mirror policy, metadata refresh, package provenance, and evidence.

**Excluded:** Unreviewed curl-pipe-shell installs, credentials in repo files, public moving sources without provenance, and application dependency management.

## IaC delivery model

| Layer | Responsibility |
| --- | --- |
| GitLab | Source of truth, merge request, protected branch, CI gates, immutable SHA, and artifacts |
| Jenkins | Manual PLAN/CHECK/APPLY/ROLLBACK selection, approval, concurrency control, and evidence aggregation |
| Terraform/image automation | Infrastructure lifecycle only when the use case changes VM, image, volume, or network resources |
| AWX and Ansible | OS desired state, check mode, inventory limit, serial rollout, and per-host events |
| Observability/evidence | Health gates, logs, metrics, incidents, expected-versus-observed result, and acceptance |

Current-source reality: roles/package_repositories generates an enabled-repository review report.

## End-to-end implementation

### Code and configuration map

| State | Repository path | Responsibility |
| --- | --- | --- |
| Existing | `linux-systems-platform: roles/package_repositories and playbooks/package-repository-review.yml` | Read-only enabled source evidence |
| Planned | `linux-systems-platform: roles/package_repository_state` | Approved yum/dnf/apt sources, keys, priorities, modules, and proxy settings |
| Planned | `linux-systems-platform: vars/repository_catalog.yml` | Environment-specific allowlist and lifecycle metadata |

### Required variables and controls

| Variable/control | Example or constraint | Purpose |
| --- | --- | --- |
| `repository_id` | stable catalog ID | Auditable identity |
| `repository_baseurl` | approved internal or vendor URL | Controlled source |
| `repository_gpg_fingerprint` | reviewed fingerprint | Package authenticity |
| `repository_priority_pin` | explicit priority/version rule | Deterministic resolution |

### Delivery sequence

1. Inventory enabled sources, package provenance, signing keys, module streams, proxy, TLS trust, and consumers.
2. Define an allowlisted catalog with owner, purpose, support window, URL, fingerprint, priority, credentials reference, and retirement date.
3. Validate reachability, TLS, signature, metadata, and duplicate-package impact in CI or an isolated canary.
4. Deploy source files and keys through Ansible; disable only explicitly retired sources.
5. Resolve representative packages and compare transaction candidates before and after the change.
6. Repeat the role, run repository review, and preserve provenance and key-rotation evidence.

## Code and configuration map

The implementation map above is authoritative for this detail page. `Existing` paths were observed in the current repository clone. `Planned` paths are IaC design targets and are not completion claims.

## Jira breakdown

### STORY-LNX-013-001: Implement and validate the source model

**Description:** As a Linux platform engineer, I need variables, roles/modules, tests, pipeline gates, and an operating contract for Package Repository Management so runtime work never depends on undocumented console state.

**Status:** In progress where supporting source is listed; the complete source gate is not accepted.

**Acceptance criteria:**

- Inputs have schemas/defaults, safe bounds, owners, and secret references.
- CI rejects malformed, unsafe, non-idempotent, and out-of-scope changes.
- The pipeline publishes the immutable SHA, exact target assumptions, and plan/check artifact.

**Implementation steps:**

1. Inventory enabled sources, package provenance, signing keys, module streams, proxy, TLS trust, and consumers.
2. Define an allowlisted catalog with owner, purpose, support window, URL, fingerprint, priority, credentials reference, and retirement date.
3. Validate reachability, TLS, signature, metadata, and duplicate-package impact in CI or an isolated canary.

**Completed work:** roles/package_repositories generates an enabled-repository review report.

**Validation and rollback:** Validate without mutation; revert the merge request and regenerate artifacts from the prior accepted revision if the source gate is wrong.

**Required attachments:** `ART-LNX-013-001` and `ATT-LNX-013-001`.

### STORY-LNX-013-002: Execute the bounded canary and rollout

**Description:** As an operator, I need approved PLAN/CHECK and canary-first APPLY for Package Repository Management so unsafe behavior stops before fleet expansion.

**Status:** Planned; no live acceptance is claimed.

**Acceptance criteria:**

- Execution uses the reviewed SHA, credentials, inventory, variables, and canary limit.
- Health and negative tests pass before cohort expansion.
- Failure thresholds preserve artifacts and stop without hidden manual correction.

**Implementation steps:**

1. Deploy source files and keys through Ansible; disable only explicitly retired sources.
2. Resolve representative packages and compare transaction candidates before and after the change.
3. Repeat the role, run repository review, and preserve provenance and key-rotation evidence.

**Completed work:** The controlled execution design exists only in documentation.

**Validation and rollback:** Only catalog-approved repositories are enabled; GPG fingerprint and TLS validation match reviewed values; Representative package resolution follows expected priority/pin. Restore prior source files, keys, priorities, and module streams from Git; refresh metadata and verify package candidates. Do not remove a key still required to validate installed or rollback packages.

**Required attachments:** `ART-LNX-013-002`, `ATT-LNX-013-002`, and `ATT-LNX-013-003`.

### STORY-LNX-013-003: Prove convergence, recovery, and handoff

**Description:** As an SRE, I need repeat convergence, runtime health, recovery proof, and an evidence package for Package Repository Management so the capability can be supported and audited.

**Status:** Planned; blocked until the canary story succeeds.

**Acceptance criteria:**

- Repeating identical code and inputs produces zero unexpected change.
- Recovery is exercised and service returns within the approved objective.
- Logs, metrics, job output, owner, expected-versus-observed result, and incidents are linked.

**Implementation steps:**

1. Repeat the identical execution and compare the changed set.
2. Exercise rollback or recovery on the bounded target.
3. Verify service health, monitoring, security posture, and consumer access.
4. Publish sanitized evidence and obtain owner/SRE acceptance.

**Completed work:** Acceptance and evidence requirements are defined; no runtime proof is claimed.

**Validation and rollback:** Second run and repository review show no drift. Restore prior source files, keys, priorities, and module streams from Git; refresh metadata and verify package candidates. Do not remove a key still required to validate installed or rollback packages.

**Required attachments:** `ART-LNX-013-003`, `ATT-LNX-013-004`, and `ATT-LNX-013-005`.

## Evidence and screenshot register

| ID | Required evidence | Source | Status |
| --- | --- | --- | --- |
| `ART-LNX-013-001` | CI validation, immutable SHA, and plan/check artifact | GitLab | Pending |
| `ATT-LNX-013-001` | Successful source pipeline | GitLab | Pending |
| `ART-LNX-013-002` | Canary execution log and changed set | Jenkins/AWX/Terraform | Pending |
| `ATT-LNX-013-002` | Canary result | Control plane | Pending |
| `ATT-LNX-013-003` | Runtime health and expected state | Dashboard or approved CLI | Pending |
| `ART-LNX-013-003` | Second convergence and recovery log | Control plane | Pending |
| `ATT-LNX-013-004` | Recovery result | Control plane | Pending |
| `ATT-LNX-013-005` | Final accepted state | Dashboard or approved CLI | Pending |

## Expected versus current result

| Area | Expected | Current observation | Decision |
| --- | --- | --- | --- |
| Source | Complete IaC and pipeline for Package Repository Management | roles/package_repositories generates an enabled-repository review report. | Not yet code complete |
| Runtime | Approved canary and cohort execution | No use-case-specific accepted run | Pending |
| Idempotence | Identical second run has zero unexpected change | No accepted convergence proof | Pending |
| Recovery | Recovery exercised and timed | No accepted recovery artifact | Pending |
| Evidence | Sanitized artifacts tied to immutable executions | Register defined; captures pending | Pending |

## Validation, idempotence, and rollback

- Only catalog-approved repositories are enabled.
- GPG fingerprint and TLS validation match reviewed values.
- Representative package resolution follows expected priority/pin.
- Second run and repository review show no drift.

**Rollback/recovery:** Restore prior source files, keys, priorities, and module streams from Git; refresh metadata and verify package candidates. Do not remove a key still required to validate installed or rollback packages.

Idempotence requires the same reviewed revision, target, variables, and action to produce zero unexplained changes plus stable consumer health. A green first run alone is insufficient.

## Troubleshooting guide

Primary scenario: **After adding an internal mirror, dnf selects an older package from the wrong repository.**

1. Stop propagation and retain the Git SHA, plan/check, execution IDs, timestamps, and target list.
2. Isolate source, orchestration, infrastructure, connectivity, privilege, host-state, and consumer-health layers.
3. Compare live facts with the intended variables and last accepted baseline; correlate logs and metrics to the execution window.
4. Reproduce only on the canary or in PLAN/CHECK, change one hypothesis, and avoid console drift.
5. Recover through the documented path and record unexpected failures or near misses in the incident register.

## Interview preparation

1. **Question:** Explain the end-to-end IaC architecture for Package Repository Management.
   **Answer signals:** Separate source validation, approval/orchestration, infrastructure ownership, AWX/Ansible desired state, runtime health, convergence, evidence, and recovery.

2. **Question:** How would you model this use case so repeated execution is safe?
   **Answer signals:** repository_id, repository_baseurl, repository_gpg_fingerprint, repository_priority_pin; stable identities, declarative state, handlers only on change, bounded targets, and explicit exclusions.

3. **Question:** What must be visible in a GitLab pipeline before runtime approval?
   **Answer signals:** Only catalog-approved repositories are enabled; GPG fingerprint and TLS validation match reviewed values; immutable SHA, lint/policy results, plan/check artifact, target assumptions, and no secret exposure.

4. **Question:** Troubleshooting scenario: After adding an internal mirror, dnf selects an older package from the wrong repository. What is your investigation order?
   **Answer signals:** Stop propagation, preserve timestamps and artifacts, verify target/input, isolate source/orchestration/connectivity/privilege/host/service layers, compare to baseline, and test on the canary.

5. **Question:** How do you prove idempotence rather than only success?
   **Answer signals:** Run the same reviewed SHA, inputs, target, and action again; require zero unexplained changes plus stable consumer health and evidence.

6. **Question:** What rollback or recovery would you use?
   **Answer signals:** Restore prior source files, keys, priorities, and module streams from Git; refresh metadata and verify package candidates. Do not remove a key still required to validate installed or rollback packages.

7. **Question:** Which security and audit controls matter most?
   **Answer signals:** Least privilege, protected source, secret references, explicit approval, canary limits, negative tests, immutable artifacts, exception expiry, and incident linkage.

8. **Question:** Discuss the tradeoff between repository availability and deterministic trusted provenance.
   **Answer signals:** Tie the choice to service objectives and failure modes, use a conservative default, measure on a canary, preserve recovery, and document exceptions.

9. **Question:** Tell me about a time you owned a difficult Package Repository Management change or incident across multiple teams. What did you do?
   **Answer signals:** Use a concise STAR example showing ownership, risk communication, evidence-based decisions, a safe stop or rollback, collaboration with service/security/SRE owners, measurable recovery or improvement, and a durable IaC correction.

## Safety and security controls

- Protected source, merge requests, tagged runners, immutable revisions, and retained artifacts.
- Least-privilege credentials referenced from approved secret systems.
- PLAN/CHECK by default; APPLY/ROLLBACK requires approval and exact target limits.
- Canary/serial rollout, failure thresholds, health gates, and stop conditions.
- No secrets, private keys, credentials, or protected health information in artifacts.

## Acceptance decision

UC-LNX-013 is **not yet accepted**. Acceptance requires implemented source, passing CI, controlled execution, runtime health, a zero-change second convergence, exercised recovery, reviewed evidence, and publication on the canonical branch.
