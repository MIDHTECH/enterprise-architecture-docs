# UC-LNX-017: Break-Glass Recovery

Last verified: 2026-08-02

## Use-case record

| Field | Value |
| --- | --- |
| Portfolio | Enterprise Linux Systems Engineering Platform |
| Canonical coverage target | Console, boot, filesystem and access recovery |
| Delivery model | End-to-end infrastructure as code |
| Primary roles | Incident commander, senior Linux engineer, service owner, security reviewer |
| Target environment | A bounded failed Linux VM or host requiring emergency restoration |
| Current state | **Partially documented. A break-glass runbook exists; time-bound access automation, recovery-media checks, drills, and revocation evidence are planned.** |
| Related change | None; implementation requires a future approved change record |
| Owner | Linux Platform team |

## Purpose

This use case implements **Break-Glass Recovery** as a traceable IaC capability. Its operational trigger is: normal remote management is unavailable or unsafe and an approved emergency condition exists. Every outcome must be reproducible from reviewed source, bounded during execution, observable, idempotent, recoverable, and evidenced.

## Expected outcome

Console, boot, filesystem and access recovery. Operators can trace the request to an immutable Git revision, review PLAN/CHECK, execute one canary, expand only through health gates, prove repeat convergence, recover through a tested path, and hand off evidence without relying on console memory.

## Trigger and actors

| Item | Definition |
| --- | --- |
| Trigger | Normal remote management is unavailable or unsafe and an approved emergency condition exists |
| Engineering owners | Incident commander, senior Linux engineer, service owner, security reviewer |
| Approver | Confirms scope, risk, window, plan, and recovery readiness |
| Operations/SRE | Reviews health, evidence, incident linkage, and acceptance |

## Preconditions

- The sequential change record authorizes this exact use case and no conflicting infrastructure work is active.
- GitLab, tagged runner, Jenkins, AWX, inventory, DNS, and observability dependencies are healthy.
- Exact target/canary limits and owners are known; secrets are referenced from approved systems.
- The selected SHA passed source, syntax, lint, policy, security, and plan/check gates.
- Recovery prerequisites and stop conditions are verified before mutation.

## Scope and exclusions

**In scope:** Emergency declaration, console path, credential release, boot rescue, filesystem repair, access restoration, evidence, revocation, and post-incident source reconciliation.

**Excluded:** Using break glass for convenience, bypassing incident command, permanent emergency accounts, and unrecorded manual fixes.

## IaC delivery model

| Layer | Responsibility |
| --- | --- |
| GitLab | Source of truth, merge request, protected branch, CI, immutable SHA, artifacts |
| Jenkins | Manual PLAN/CHECK/APPLY/ROLLBACK, approval, concurrency, evidence aggregation |
| Terraform/image automation | VM/image/volume/network lifecycle only when required |
| AWX and Ansible | OS desired state, inventory limit, check mode, serial rollout, job events |
| Observability/evidence | Health, logs, metrics, expected-versus-observed, incidents, acceptance |

Current-source reality: docs/runbooks/break-glass-recovery.md documents procedures, but no accepted automated drill or credential lifecycle exists.

## End-to-end implementation

### Code and configuration map

| State | Repository path | Responsibility |
| --- | --- | --- |
| Existing | `linux-systems-platform: docs/runbooks/break-glass-recovery.md` | Current human recovery procedure |
| Planned | `linux-systems-platform: playbooks/break-glass-prepare.yml` | Validate console, recovery media, escrow reference, and evidence readiness without releasing secrets |
| Planned | `linux-systems-platform: playbooks/break-glass-reconcile.yml` | Post-recovery access revocation, drift capture, and desired-state restoration |

### Required variables and controls

| Variable/control | Example or constraint | Purpose |
| --- | --- | --- |
| `incident_id` | immutable active incident | Authorization and traceability |
| `break_glass_target` | one exact host | Blast-radius control |
| `credential_lease_minutes` | short approved duration | Automatic expiry |
| `recovery_objective_minutes` | service-specific target | Measures drill/result |

### Delivery sequence

1. Declare the incident, assign commander/engineer/recorder, name the exact host, and verify normal automation cannot safely recover it.
2. Validate console access, recovery media, backup/snapshot, credential escrow reference, owner, and recovery objective.
3. Release time-bound emergency access through the approved control, record every action, and avoid unrelated changes.
4. Recover boot, filesystem, network, or administrative access; then run minimum service and data-integrity checks.
5. Return the host to Ansible desired state, collect drift, revoke emergency access, rotate exposed material, and close console sessions.
6. Publish the timeline, recovery time, evidence, RCA, corrective source changes, and a scheduled repeat drill.

## Code and configuration map

The implementation map above distinguishes observed `Existing` paths from `Planned` IaC design targets. Planned paths must not be used as evidence of completion.

## Jira breakdown

### STORY-LNX-017-001: Implement and validate the source model

**Description:** As a Linux platform engineer, I need variables, roles/modules, tests, pipeline gates, and an operating contract for Break-Glass Recovery so runtime work does not depend on undocumented console state.

**Status:** In progress only where supporting source is listed; the full source gate is not accepted.

**Acceptance criteria:**

- Inputs have schemas/defaults, safe bounds, ownership, and secret references.
- CI rejects malformed, unsafe, non-idempotent, and out-of-scope changes.
- CI publishes immutable SHA, exact assumptions, and plan/check artifacts.

**Implementation steps:**

1. Declare the incident, assign commander/engineer/recorder, name the exact host, and verify normal automation cannot safely recover it.
2. Validate console access, recovery media, backup/snapshot, credential escrow reference, owner, and recovery objective.
3. Release time-bound emergency access through the approved control, record every action, and avoid unrelated changes.

**Completed work:** docs/runbooks/break-glass-recovery.md documents procedures, but no accepted automated drill or credential lifecycle exists.

**Validation and rollback:** Validate without runtime mutation; revert source and regenerate artifacts from the prior accepted revision if incorrect.

**Required attachments:** `ART-LNX-017-001` and `ATT-LNX-017-001`.

### STORY-LNX-017-002: Execute the bounded canary and rollout

**Description:** As an operator, I need an approved PLAN/CHECK and canary-first APPLY for Break-Glass Recovery so unsafe behavior stops before fleet expansion.

**Status:** Planned; no runtime acceptance is claimed.

**Acceptance criteria:**

- Execution uses the reviewed SHA, credential references, inventory, variables, and canary limit.
- Health and negative tests pass before any cohort expansion.
- Failure thresholds stop the workflow and preserve evidence without hidden manual correction.

**Implementation steps:**

1. Recover boot, filesystem, network, or administrative access; then run minimum service and data-integrity checks.
2. Return the host to Ansible desired state, collect drift, revoke emergency access, rotate exposed material, and close console sessions.
3. Publish the timeline, recovery time, evidence, RCA, corrective source changes, and a scheduled repeat drill.

**Completed work:** The execution design is documented; no successful live canary is claimed.

**Validation and rollback:** Emergency use is tied to an incident, exact target, named staff, and expiring lease; Console/recovery path works without revealing secrets in source or artifacts; Service, data, access, monitoring, and desired state are restored. Break glass is itself recovery. If a repair worsens state, stop, preserve evidence, restore from the accepted backup/snapshot or rebuild, and keep incident command in control.

**Required attachments:** `ART-LNX-017-002`, `ATT-LNX-017-002`, and `ATT-LNX-017-003`.

### STORY-LNX-017-003: Prove convergence, recovery, and handoff

**Description:** As an SRE, I need repeat convergence, runtime health, recovery proof, and an evidence package for Break-Glass Recovery so the capability is supportable and auditable.

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

**Validation and rollback:** All emergency access is revoked and a repeat drill meets the recovery objective. Break glass is itself recovery. If a repair worsens state, stop, preserve evidence, restore from the accepted backup/snapshot or rebuild, and keep incident command in control.

**Required attachments:** `ART-LNX-017-003`, `ATT-LNX-017-004`, and `ATT-LNX-017-005`.

## Evidence and screenshot register

| ID | Required evidence | Source | Status |
| --- | --- | --- | --- |
| `ART-LNX-017-001` | CI, immutable SHA, and plan/check artifact | GitLab | Pending |
| `ATT-LNX-017-001` | Successful source pipeline | GitLab | Pending |
| `ART-LNX-017-002` | Canary execution and changed set | Jenkins/AWX/Terraform | Pending |
| `ATT-LNX-017-002` | Canary result | Control plane | Pending |
| `ATT-LNX-017-003` | Runtime health and expected state | Dashboard/CLI | Pending |
| `ART-LNX-017-003` | Second convergence and recovery log | Control plane | Pending |
| `ATT-LNX-017-004` | Recovery result | Control plane | Pending |
| `ATT-LNX-017-005` | Final accepted state | Dashboard/CLI | Pending |

## Expected versus current result

| Area | Expected | Current observation | Decision |
| --- | --- | --- | --- |
| Source | Complete IaC and pipeline for Break-Glass Recovery | docs/runbooks/break-glass-recovery.md documents procedures, but no accepted automated drill or credential lifecycle exists. | Not yet code complete |
| Runtime | Approved canary/cohort execution | No accepted use-case run | Pending |
| Idempotence | Identical second run has zero unexpected change | No accepted convergence proof | Pending |
| Recovery | Recovery exercised and timed | No accepted recovery artifact | Pending |
| Evidence | Sanitized artifacts tied to immutable executions | Register defined; captures pending | Pending |

## Validation, idempotence, and rollback

- Emergency use is tied to an incident, exact target, named staff, and expiring lease.
- Console/recovery path works without revealing secrets in source or artifacts.
- Service, data, access, monitoring, and desired state are restored.
- All emergency access is revoked and a repeat drill meets the recovery objective.

**Rollback/recovery:** Break glass is itself recovery. If a repair worsens state, stop, preserve evidence, restore from the accepted backup/snapshot or rebuild, and keep incident command in control.

Idempotence means the same reviewed revision, target, variables, and action produces zero unexplained changes plus stable consumer health. First-run success is not enough.

## Troubleshooting guide

Primary scenario: **Console access works, but the emergency credential cannot be revoked cleanly after service restoration.**

1. Stop propagation and preserve SHA, plan/check, execution IDs, timestamps, and targets.
2. Isolate source, orchestration, infrastructure, connectivity, privilege, host state, and consumer health.
3. Compare live facts with intended variables and the last accepted baseline; correlate logs/metrics to the window.
4. Reproduce only on the canary or in PLAN/CHECK and change one hypothesis at a time.
5. Recover through the documented path and record unexpected failures or near misses.

## Interview preparation

1. **Question:** Explain the end-to-end IaC architecture for Break-Glass Recovery.
   **Answer signals:** Cover GitLab review and CI, Jenkins approval, Terraform/image ownership where relevant, AWX/Ansible execution, observability, convergence, recovery, and evidence.

2. **Question:** How would you make the implementation idempotent and reusable?
   **Answer signals:** incident_id, break_glass_target, credential_lease_minutes, recovery_objective_minutes; explicit schemas, stable identities, bounded targets, deterministic tasks, and no UI-only state.

3. **Question:** What pipeline and plan/check evidence is required before APPLY?
   **Answer signals:** Emergency use is tied to an incident, exact target, named staff, and expiring lease; Console/recovery path works without revealing secrets in source or artifacts; immutable SHA, runner identity, target assumptions, scan/test results, and no exposed secret.

4. **Question:** Troubleshooting scenario: Console access works, but the emergency credential cannot be revoked cleanly after service restoration. How do you respond?
   **Answer signals:** Stop propagation, preserve execution evidence, verify target and source revision, isolate the failed layer, compare live facts to desired/baseline, and test recovery on the canary.

5. **Question:** How do you prove idempotence?
   **Answer signals:** Repeat identical SHA, inputs, target, credentials scope, and action; require zero unexplained changes plus stable health and equivalent evidence.

6. **Question:** What rollback or recovery path would you defend?
   **Answer signals:** Break glass is itself recovery. If a repair worsens state, stop, preserve evidence, restore from the accepted backup/snapshot or rebuild, and keep incident command in control.

7. **Question:** Which security/audit controls should an interviewer hear?
   **Answer signals:** Protected source, least privilege, secret references, approval gates, short-lived access, canary limits, immutable artifacts, exception expiry, and incident linkage.

8. **Question:** Discuss the tradeoff between fast emergency access and strong accountability.
   **Answer signals:** Frame business impact and failure modes, choose a safe default, measure canary results, keep recovery available, and document justified exceptions.

9. **Question:** Tell me about a time you owned a difficult Break-Glass Recovery change or incident across multiple teams. What did you do?
   **Answer signals:** Use a concise STAR example showing ownership, risk communication, evidence-based decisions, a safe stop or rollback, collaboration with service/security/SRE owners, measurable recovery or improvement, and a durable IaC correction.

## Safety and security controls

- Protected source, merge requests, tagged runners, immutable revisions, and retained artifacts.
- Least-privilege credentials referenced from approved secret systems.
- PLAN/CHECK by default; APPLY/ROLLBACK requires confirmation and exact target limits.
- Canary rollout, failure thresholds, health gates, and stop conditions.
- No credentials, private keys, secrets, or protected health information in artifacts.

## Acceptance decision

UC-LNX-017 is **not yet accepted**. Acceptance requires implemented source, passing CI, controlled execution, runtime health, zero-change second convergence, exercised recovery, reviewed evidence, and publication on the canonical branch.
