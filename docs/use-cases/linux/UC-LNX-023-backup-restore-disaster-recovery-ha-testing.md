# UC-LNX-023: Backup, Restore, Disaster Recovery and HA Testing

Last verified: 2026-08-02

## Use-case record

| Field | Value |
| --- | --- |
| Portfolio | Enterprise Linux Systems Engineering Platform |
| Canonical coverage target | Prove recoverability, failover, service continuity and restoration evidence |
| Delivery model | End-to-end infrastructure as code |
| Primary roles | Backup engineer, Linux platform engineer, service owner, SRE, incident commander |
| Target environment | Critical Linux hosts, configuration, system data, and service-specific recovery tiers |
| Current state | **Defined backlog. A backup VM and recovery runbooks exist, but Linux backup policy as code, automated restore canaries, HA/DR exercises, and RPO/RTO evidence are not accepted.** |
| Related change | None; implementation requires a future approved change record |
| Owner | Linux Platform team |

## Purpose

A successful backup job does not prove that a service can recover. The design starts with dependencies and recovery objectives, then exercises restore, failover, integrity, application health, and return to normal.

## Expected outcome

An isolated exercise restores the named service, proves data consistency and consumer health, and measures actual RPO and RTO. Gaps become owned backlog work.

## Platform and enterprise fit

| Relationship | Detailed fit |
| --- | --- |
| Owning platform | **Backup, Restore, Disaster Recovery and HA Testing** belongs to the the documented enterprise outcome because that platform turns GitLab-reviewed standards through Jenkins approval and Terraform/image or AWX/Ansible execution into verified operating-system state. |
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
| Trigger | A scheduled recovery exercise, new service onboarding, backup change, or incident requires restoration |
| Engineering owners | Backup engineer, Linux platform engineer, service owner, SRE, incident commander |
| Approver | Confirms scope, risk, window, plan, and recovery readiness |
| Operations/SRE | Reviews health, evidence, incident linkage, and acceptance |

## Preconditions

- The sequential change record authorizes this exact use case and no conflicting infrastructure work is active.
- GitLab, tagged runner, Jenkins, AWX, inventory, DNS, and observability dependencies are healthy.
- Exact target/canary limits and owners are known; secrets are referenced from approved systems.
- The selected SHA passed source, syntax, lint, policy, security, and plan/check gates.
- Recovery prerequisites and stop conditions are verified before mutation.

## Scope and exclusions

**In scope:** Backup policy, include/exclude, encryption, retention, immutability, job monitoring, restore canary, integrity/application validation, failover/failback, RPO/RTO, and evidence.

**Excluded:** Backup success without restore, copying secrets into Git, destructive production drills without isolation, and assuming VM snapshots replace application-consistent backup.

## Architecture diagram

![UC-LNX-023 Backup, Restore, Disaster Recovery and HA Testing architecture](../../assets/use-cases/UC-LNX-023/UC-LNX-023-architecture.svg)

Recovery policy and backup integrity checks lead into an isolated restore or failover, ending with measured RPO/RTO and service evidence.

## IaC delivery model

| Layer | Responsibility |
| --- | --- |
| GitLab | Source of truth, merge request, protected branch, CI, immutable SHA, artifacts |
| Jenkins | Manual PLAN/CHECK/APPLY/ROLLBACK, approval, concurrency, evidence aggregation |
| Terraform/image automation | VM/image/volume/network lifecycle only when required |
| AWX and Ansible | OS desired state, inventory limit, check mode, serial rollout, job events |
| Observability/evidence | Health, logs, metrics, expected-versus-observed, incidents, acceptance |

Current-source reality: The environment has backup.example.com and break-glass/lifecycle runbooks; end-to-end Linux recovery automation is not implemented.

## End-to-end implementation

### Code and configuration map

| State | Repository path | Responsibility |
| --- | --- | --- |
| Existing | `enterprise-architecture-docs: docs/vm-inventory.md` | Canonical backup service and Linux target inventory facts |
| Planned | `linux-systems-platform: roles/backup_client and vars/recovery_tiers.yml` | Agent, policy, schedules, retention, encryption, and monitoring state |
| Planned | `linux-systems-platform: playbooks/restore-canary.yml and dr-exercise.yml` | Isolated restore, integrity, service validation, failover/failback, and evidence |

### Required variables and controls

| Variable/control | Example or constraint | Purpose |
| --- | --- | --- |
| `recovery_tier` | tier-0/1/2/3 | RPO/RTO and exercise frequency |
| `backup_policy_id` | immutable reviewed policy | Traceability |
| `restore_isolation_network` | non-production segment | Safe validation |
| `recovery_evidence_id` | job plus restore manifest | Acceptance proof |

### Delivery sequence

1. Classify service/data owner, consistency method, RPO, RTO, retention, encryption, dependencies, failover order, and recovery acceptance tests.
2. Configure backup client/policy as code and verify schedules, protected paths, exclusions, credentials, repository capacity, and alerts.
3. Select a recovery point and restore into an isolated canary without overwriting production.
4. Verify checksums, ownership, SELinux context, service start, application/data integrity, dependencies, and consumer probes.
5. For HA/DR, execute approved failover and failback while recording impact, data loss, recovery time, and decision points.
6. Repeat automation for convergence, remediate gaps, and retain backup-job plus restore evidence.

## Code and configuration map

The implementation map above distinguishes observed `Existing` paths from `Planned` IaC design targets. Planned paths must not be used as evidence of completion.

## Jira breakdown

### STORY-LNX-023-001: Implement and validate the source model

**Description:** The platform team keeps the inputs, roles or modules, tests, pipeline gates, and operating boundaries for Backup, Restore, Disaster Recovery and HA Testing in Git. A reviewer can reproduce the proposal from the selected commit without relying on settings that exist only in a console.

**Status:** In progress only where supporting source is listed; the full source gate is not accepted.

**Acceptance criteria:**

- Inputs have schemas/defaults, safe bounds, ownership, and secret references.
- CI rejects malformed, unsafe, non-idempotent, and out-of-scope changes.
- CI publishes immutable SHA, exact assumptions, and plan/check artifacts.

**Implementation steps:**

1. Classify service/data owner, consistency method, RPO, RTO, retention, encryption, dependencies, failover order, and recovery acceptance tests.
2. Configure backup client/policy as code and verify schedules, protected paths, exclusions, credentials, repository capacity, and alerts.
3. Select a recovery point and restore into an isolated canary without overwriting production.

**Completed work:** The environment has backup.example.com and break-glass/lifecycle runbooks; end-to-end Linux recovery automation is not implemented.

**Validation and rollback:** Validate without runtime mutation; revert source and regenerate artifacts from the prior accepted revision if incorrect.

**Required attachments:** `ART-LNX-023-001` and `ATT-LNX-023-001`.

### STORY-LNX-023-002: Execute the bounded canary and rollout

**Description:** The operator reviews PLAN or CHECK output against one named canary before applying Backup, Restore, Disaster Recovery and HA Testing. Failed health or negative tests stop the run, and expansion requires explicit approval.

**Status:** Planned; no runtime acceptance is claimed.

**Acceptance criteria:**

- Execution uses the reviewed SHA, credential references, inventory, variables, and canary limit.
- Health and negative tests pass before any cohort expansion.
- Failure thresholds stop the workflow and preserve evidence without hidden manual correction.

**Implementation steps:**

1. Verify checksums, ownership, SELinux context, service start, application/data integrity, dependencies, and consumer probes.
2. For HA/DR, execute approved failover and failback while recording impact, data loss, recovery time, and decision points.
3. Repeat automation for convergence, remediate gaps, and retain backup-job plus restore evidence.

**Completed work:** The execution design is documented; no successful live canary is claimed.

**Validation and rollback:** Backup job success includes target, policy, bytes, recovery point, encryption, and retention; Isolated restore passes file and application-level integrity tests; Measured RPO/RTO and failover/failback meet the approved tier. A restore drill is isolated and discarded through IaC. During failover, return to the last known healthy site/node only after data direction and split-brain controls are verified; preserve all recovery evidence.

**Required attachments:** `ART-LNX-023-002`, `ATT-LNX-023-002`, and `ATT-LNX-023-003`.

### STORY-LNX-023-003: Prove convergence, recovery, and handoff

**Description:** Operations accepts Backup, Restore, Disaster Recovery and HA Testing only after the same revision converges cleanly, runtime health is visible, and the recovery path has been exercised. The evidence must explain what moved, what stayed stable, and how the team recovered it.

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

**Validation and rollback:** Policy rerun is unchanged and a repeat restore remains successful. A restore drill is isolated and discarded through IaC. During failover, return to the last known healthy site/node only after data direction and split-brain controls are verified; preserve all recovery evidence.

**Required attachments:** `ART-LNX-023-003`, `ATT-LNX-023-004`, and `ATT-LNX-023-005`.

## Evidence and screenshot register

| ID | Required evidence | Source | Status |
| --- | --- | --- | --- |
| `ART-LNX-023-001` | CI, immutable SHA, and plan/check artifact | GitLab | Pending |
| `ATT-LNX-023-001` | Successful source pipeline | GitLab | Pending |
| `ART-LNX-023-002` | Canary execution and changed set | Jenkins/AWX/Terraform | Pending |
| `ATT-LNX-023-002` | Canary result | Control plane | Pending |
| `ATT-LNX-023-003` | Runtime health and expected state | Dashboard/CLI | Pending |
| `ART-LNX-023-003` | Second convergence and recovery log | Control plane | Pending |
| `ATT-LNX-023-004` | Recovery result | Control plane | Pending |
| `ATT-LNX-023-005` | Final accepted state | Dashboard/CLI | Pending |

## Expected versus current result

| Area | Expected | Current observation | Decision |
| --- | --- | --- | --- |
| Source | Complete IaC and pipeline for Backup, Restore, Disaster Recovery and HA Testing | The environment has backup.example.com and break-glass/lifecycle runbooks; end-to-end Linux recovery automation is not implemented. | Not yet code complete |
| Runtime | Approved canary/cohort execution | No accepted use-case run | Pending |
| Idempotence | Identical second run has zero unexpected change | No accepted convergence proof | Pending |
| Recovery | Recovery exercised and timed | No accepted recovery artifact | Pending |
| Evidence | Sanitized artifacts tied to immutable executions | Register defined; captures pending | Pending |

## Validation, idempotence, and rollback

- Backup job success includes target, policy, bytes, recovery point, encryption, and retention.
- Isolated restore passes file and application-level integrity tests.
- Measured RPO/RTO and failover/failback meet the approved tier.
- Policy rerun is unchanged and a repeat restore remains successful.

**Rollback/recovery:** A restore drill is isolated and discarded through IaC. During failover, return to the last known healthy site/node only after data direction and split-brain controls are verified; preserve all recovery evidence.

Idempotence means the same reviewed revision, target, variables, and action produces zero unexplained changes plus stable consumer health. First-run success is not enough.

## Troubleshooting guide

Primary scenario: **Backup jobs are green, but the restored service cannot start because certificate keys and SELinux contexts are missing.**

1. Stop propagation and preserve SHA, plan/check, execution IDs, timestamps, and targets.
2. Isolate source, orchestration, infrastructure, connectivity, privilege, host state, and consumer health.
3. Compare live facts with intended variables and the last accepted baseline; correlate logs/metrics to the window.
4. Reproduce only on the canary or in PLAN/CHECK and change one hypothesis at a time.
5. Recover through the documented path and record unexpected failures or near misses.

## Interview preparation

1. **Question:** Explain the end-to-end IaC architecture for Backup, Restore, Disaster Recovery and HA Testing.
   **Answer signals:** Cover GitLab review and CI, Jenkins approval, Terraform/image ownership where relevant, AWX/Ansible execution, observability, convergence, recovery, and evidence.

2. **Question:** How would you make the implementation idempotent and reusable?
   **Answer signals:** recovery_tier, backup_policy_id, restore_isolation_network, recovery_evidence_id; explicit schemas, stable identities, bounded targets, deterministic tasks, and no UI-only state.

3. **Question:** What pipeline and plan/check evidence is required before APPLY?
   **Answer signals:** Backup job success includes target, policy, bytes, recovery point, encryption, and retention; Isolated restore passes file and application-level integrity tests; immutable SHA, runner identity, target assumptions, scan/test results, and no exposed secret.

4. **Question:** Troubleshooting scenario: Backup jobs are green, but the restored service cannot start because certificate keys and SELinux contexts are missing. How do you respond?
   **Answer signals:** Stop propagation, preserve execution evidence, verify target and source revision, isolate the failed layer, compare live facts to desired/baseline, and test recovery on the canary.

5. **Question:** How do you prove idempotence?
   **Answer signals:** Repeat identical SHA, inputs, target, credentials scope, and action; require zero unexplained changes plus stable health and equivalent evidence.

6. **Question:** What rollback or recovery path would you defend?
   **Answer signals:** A restore drill is isolated and discarded through IaC. During failover, return to the last known healthy site/node only after data direction and split-brain controls are verified; preserve all recovery evidence.

7. **Question:** Which security/audit controls should an interviewer hear?
   **Answer signals:** Protected source, least privilege, secret references, approval gates, short-lived access, canary limits, immutable artifacts, exception expiry, and incident linkage.

8. **Question:** Discuss the tradeoff between backup scope/cost and complete recoverability.
   **Answer signals:** Frame business impact and failure modes, choose a safe default, measure canary results, keep recovery available, and document justified exceptions.

9. **Question:** Tell me about a time you owned a difficult Backup, Restore, Disaster Recovery and HA Testing change or incident across multiple teams. What did you do?
   **Answer signals:** Use a concise STAR example showing ownership, risk communication, evidence-based decisions, a safe stop or rollback, collaboration with service/security/SRE owners, measurable recovery or improvement, and a durable IaC correction.

## Safety and security controls

- Protected source, merge requests, tagged runners, immutable revisions, and retained artifacts.
- Least-privilege credentials referenced from approved secret systems.
- PLAN/CHECK by default; APPLY/ROLLBACK requires confirmation and exact target limits.
- Canary rollout, failure thresholds, health gates, and stop conditions.
- No credentials, private keys, secrets, or protected health information in artifacts.

## Acceptance decision

UC-LNX-023 is **not yet accepted**. Acceptance requires implemented source, passing CI, controlled execution, runtime health, zero-change second convergence, exercised recovery, reviewed evidence, and publication on the canonical branch.
