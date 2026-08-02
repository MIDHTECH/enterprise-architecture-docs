# UC-LNX-010: Filesystem, LVM and Storage Management

Last verified: 2026-08-02

## Use-case record

| Field | Value |
| --- | --- |
| Portfolio | Enterprise Linux Systems Engineering Platform |
| Canonical coverage target | Capacity, mount, ownership and recovery standards |
| Delivery model | End-to-end infrastructure as code |
| Primary roles | Linux storage engineer, service owner, backup engineer, SRE |
| Target environment | Linux VM filesystems, LVM volume groups/logical volumes, and approved attached disks |
| Current state | **Partially implemented. Read-only filesystem/LVM evidence exists; safe create/extend/mount automation and recovery drills are planned.** |
| Related change | None; implementation requires a future approved change record |
| Owner | Linux Platform team |

## Purpose

This use case implements **Filesystem, LVM and Storage Management** as reviewed desired state with operational evidence. Its trigger is: a reviewed request adds, grows, mounts, migrates, or recovers storage. The outcome must be reproducible from Git, bounded during execution, observable at runtime, idempotent on repeat, and recoverable without hidden console state.

## Expected outcome

Capacity, mount, ownership and recovery standards. An engineer can trace the request to an immutable revision, review PLAN/CHECK output, execute a canary through the approved control plane, expand safely, prove zero unexpected change, recover, and hand the control to operations.

## Trigger and actors

| Item | Definition |
| --- | --- |
| Trigger | A reviewed request adds, grows, mounts, migrates, or recovers storage |
| Engineering owners | Linux storage engineer, service owner, backup engineer, SRE |
| Approver | Confirms target, risk, maintenance window, evidence, and recovery readiness |
| SRE/operations | Reviews health, alerts, incidents, convergence, and handoff |

## Preconditions

- The sequential change record authorizes this exact use case and no conflicting infrastructure work is active.
- GitLab, tagged runners, Jenkins, AWX, inventory, DNS, and observability dependencies are healthy.
- Target and canary limits are explicit; credentials are referenced from approved secret systems.
- The selected Git SHA passed syntax, lint, policy, secret, and plan/check gates.
- Required backup, console, replacement, or recovery evidence exists before mutation.

## Scope and exclusions

**In scope:** Disk discovery, partition/PV/VG/LV/filesystem lifecycle, mount options, ownership, capacity gates, growth, monitoring, backup coordination, and recovery.

**Excluded:** Destructive shrink without rebuild, undocumented mkfs, SAN administration, and application-level data migration without owner procedures.

## IaC delivery model

| Layer | Responsibility |
| --- | --- |
| GitLab | Source of truth, merge request, protected branch, CI gates, immutable SHA, and artifacts |
| Jenkins | Manual PLAN/CHECK/APPLY/ROLLBACK selection, approval, concurrency control, and evidence aggregation |
| Terraform/image automation | Infrastructure lifecycle only when the use case changes VM, image, volume, or network resources |
| AWX and Ansible | OS desired state, check mode, inventory limit, serial rollout, and per-host events |
| Observability/evidence | Health gates, logs, metrics, incidents, expected-versus-observed result, and acceptance |

Current-source reality: roles/storage_assessment collects filesystem and LVM evidence without mutating storage.

## End-to-end implementation

### Code and configuration map

| State | Repository path | Responsibility |
| --- | --- | --- |
| Existing | `linux-systems-platform: roles/storage_assessment and playbooks/storage-assessment.yml` | Read-only disk, filesystem, mount, and LVM evidence |
| Planned | `linux-systems-platform: roles/storage_state and playbooks/storage-change.yml` | Validated create, extend, filesystem, mount, ownership, and postcheck workflow |
| Planned | `cloud-infra-automation-platform: terraform/modules/storage` | VM volume attachment and infrastructure lifecycle |

### Required variables and controls

| Variable/control | Example or constraint | Purpose |
| --- | --- | --- |
| `storage_device_id` | stable WWN or libvirt serial | Avoids /dev/sdX ambiguity |
| `storage_vg_lv` | approved names and sizes | Deterministic LVM state |
| `storage_filesystem` | xfs or approved type | Supported growth/recovery |
| `storage_mount_options` | security/performance set | Persistent mount policy |

### Delivery sequence

1. Capture lsblk, blkid, pvs/vgs/lvs, mounts, fstab, capacity trend, consumers, backup state, and stable device identity.
2. Plan infrastructure volume attachment separately from in-guest storage configuration.
3. Validate that the target device is unused or matches the expected PV/VG/LV before any destructive command.
4. Apply PV/VG/LV/filesystem/mount state to a canary or non-production clone and verify ownership and SELinux context.
5. Extend online only when the filesystem and application support it; never automate unsupported shrink.
6. Validate reboot persistence, capacity alerts, backup, recovery, and a zero-change second run.

## Code and configuration map

The implementation map above is authoritative for this detail page. `Existing` paths were observed in the current repository clone. `Planned` paths are IaC design targets and are not completion claims.

## Jira breakdown

### STORY-LNX-010-001: Implement and validate the source model

**Description:** As a Linux platform engineer, I need variables, roles/modules, tests, pipeline gates, and an operating contract for Filesystem, LVM and Storage Management so runtime work never depends on undocumented console state.

**Status:** In progress where supporting source is listed; the complete source gate is not accepted.

**Acceptance criteria:**

- Inputs have schemas/defaults, safe bounds, owners, and secret references.
- CI rejects malformed, unsafe, non-idempotent, and out-of-scope changes.
- The pipeline publishes the immutable SHA, exact target assumptions, and plan/check artifact.

**Implementation steps:**

1. Capture lsblk, blkid, pvs/vgs/lvs, mounts, fstab, capacity trend, consumers, backup state, and stable device identity.
2. Plan infrastructure volume attachment separately from in-guest storage configuration.
3. Validate that the target device is unused or matches the expected PV/VG/LV before any destructive command.

**Completed work:** roles/storage_assessment collects filesystem and LVM evidence without mutating storage.

**Validation and rollback:** Validate without mutation; revert the merge request and regenerate artifacts from the prior accepted revision if the source gate is wrong.

**Required attachments:** `ART-LNX-010-001` and `ATT-LNX-010-001`.

### STORY-LNX-010-002: Execute the bounded canary and rollout

**Description:** As an operator, I need approved PLAN/CHECK and canary-first APPLY for Filesystem, LVM and Storage Management so unsafe behavior stops before fleet expansion.

**Status:** Planned; no live acceptance is claimed.

**Acceptance criteria:**

- Execution uses the reviewed SHA, credentials, inventory, variables, and canary limit.
- Health and negative tests pass before cohort expansion.
- Failure thresholds preserve artifacts and stop without hidden manual correction.

**Implementation steps:**

1. Apply PV/VG/LV/filesystem/mount state to a canary or non-production clone and verify ownership and SELinux context.
2. Extend online only when the filesystem and application support it; never automate unsupported shrink.
3. Validate reboot persistence, capacity alerts, backup, recovery, and a zero-change second run.

**Completed work:** The controlled execution design exists only in documentation.

**Validation and rollback:** Stable device identity and current signatures match the plan; Only the named volume, LV, filesystem, and mount change; Mount survives reboot with expected options, ownership, context, and free-space alert. Before filesystem creation, detach the unaccepted volume through Terraform. After data exists, do not shrink or remove it; stop, restore from backup/snapshot to a replacement volume, and follow the application recovery runbook.

**Required attachments:** `ART-LNX-010-002`, `ATT-LNX-010-002`, and `ATT-LNX-010-003`.

### STORY-LNX-010-003: Prove convergence, recovery, and handoff

**Description:** As an SRE, I need repeat convergence, runtime health, recovery proof, and an evidence package for Filesystem, LVM and Storage Management so the capability can be supported and audited.

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

**Validation and rollback:** Second run and storage assessment report no unexpected change. Before filesystem creation, detach the unaccepted volume through Terraform. After data exists, do not shrink or remove it; stop, restore from backup/snapshot to a replacement volume, and follow the application recovery runbook.

**Required attachments:** `ART-LNX-010-003`, `ATT-LNX-010-004`, and `ATT-LNX-010-005`.

## Evidence and screenshot register

| ID | Required evidence | Source | Status |
| --- | --- | --- | --- |
| `ART-LNX-010-001` | CI validation, immutable SHA, and plan/check artifact | GitLab | Pending |
| `ATT-LNX-010-001` | Successful source pipeline | GitLab | Pending |
| `ART-LNX-010-002` | Canary execution log and changed set | Jenkins/AWX/Terraform | Pending |
| `ATT-LNX-010-002` | Canary result | Control plane | Pending |
| `ATT-LNX-010-003` | Runtime health and expected state | Dashboard or approved CLI | Pending |
| `ART-LNX-010-003` | Second convergence and recovery log | Control plane | Pending |
| `ATT-LNX-010-004` | Recovery result | Control plane | Pending |
| `ATT-LNX-010-005` | Final accepted state | Dashboard or approved CLI | Pending |

## Expected versus current result

| Area | Expected | Current observation | Decision |
| --- | --- | --- | --- |
| Source | Complete IaC and pipeline for Filesystem, LVM and Storage Management | roles/storage_assessment collects filesystem and LVM evidence without mutating storage. | Not yet code complete |
| Runtime | Approved canary and cohort execution | No use-case-specific accepted run | Pending |
| Idempotence | Identical second run has zero unexpected change | No accepted convergence proof | Pending |
| Recovery | Recovery exercised and timed | No accepted recovery artifact | Pending |
| Evidence | Sanitized artifacts tied to immutable executions | Register defined; captures pending | Pending |

## Validation, idempotence, and rollback

- Stable device identity and current signatures match the plan.
- Only the named volume, LV, filesystem, and mount change.
- Mount survives reboot with expected options, ownership, context, and free-space alert.
- Second run and storage assessment report no unexpected change.

**Rollback/recovery:** Before filesystem creation, detach the unaccepted volume through Terraform. After data exists, do not shrink or remove it; stop, restore from backup/snapshot to a replacement volume, and follow the application recovery runbook.

Idempotence requires the same reviewed revision, target, variables, and action to produce zero unexplained changes plus stable consumer health. A green first run alone is insufficient.

## Troubleshooting guide

Primary scenario: **A new disk appears as a different /dev name after reboot and the playbook targets the wrong device.**

1. Stop propagation and retain the Git SHA, plan/check, execution IDs, timestamps, and target list.
2. Isolate source, orchestration, infrastructure, connectivity, privilege, host-state, and consumer-health layers.
3. Compare live facts with the intended variables and last accepted baseline; correlate logs and metrics to the execution window.
4. Reproduce only on the canary or in PLAN/CHECK, change one hypothesis, and avoid console drift.
5. Recover through the documented path and record unexpected failures or near misses in the incident register.

## Interview preparation

1. **Question:** Explain the end-to-end IaC architecture for Filesystem, LVM and Storage Management.
   **Answer signals:** Separate source validation, approval/orchestration, infrastructure ownership, AWX/Ansible desired state, runtime health, convergence, evidence, and recovery.

2. **Question:** How would you model this use case so repeated execution is safe?
   **Answer signals:** storage_device_id, storage_vg_lv, storage_filesystem, storage_mount_options; stable identities, declarative state, handlers only on change, bounded targets, and explicit exclusions.

3. **Question:** What must be visible in a GitLab pipeline before runtime approval?
   **Answer signals:** Stable device identity and current signatures match the plan; Only the named volume, LV, filesystem, and mount change; immutable SHA, lint/policy results, plan/check artifact, target assumptions, and no secret exposure.

4. **Question:** Troubleshooting scenario: A new disk appears as a different /dev name after reboot and the playbook targets the wrong device. What is your investigation order?
   **Answer signals:** Stop propagation, preserve timestamps and artifacts, verify target/input, isolate source/orchestration/connectivity/privilege/host/service layers, compare to baseline, and test on the canary.

5. **Question:** How do you prove idempotence rather than only success?
   **Answer signals:** Run the same reviewed SHA, inputs, target, and action again; require zero unexplained changes plus stable consumer health and evidence.

6. **Question:** What rollback or recovery would you use?
   **Answer signals:** Before filesystem creation, detach the unaccepted volume through Terraform. After data exists, do not shrink or remove it; stop, restore from backup/snapshot to a replacement volume, and follow the application recovery runbook.

7. **Question:** Which security and audit controls matter most?
   **Answer signals:** Least privilege, protected source, secret references, explicit approval, canary limits, negative tests, immutable artifacts, exception expiry, and incident linkage.

8. **Question:** Discuss the tradeoff between automation convenience and destructive-storage safety.
   **Answer signals:** Tie the choice to service objectives and failure modes, use a conservative default, measure on a canary, preserve recovery, and document exceptions.

9. **Question:** Tell me about a time you owned a difficult Filesystem, LVM and Storage Management change or incident across multiple teams. What did you do?
   **Answer signals:** Use a concise STAR example showing ownership, risk communication, evidence-based decisions, a safe stop or rollback, collaboration with service/security/SRE owners, measurable recovery or improvement, and a durable IaC correction.

## Safety and security controls

- Protected source, merge requests, tagged runners, immutable revisions, and retained artifacts.
- Least-privilege credentials referenced from approved secret systems.
- PLAN/CHECK by default; APPLY/ROLLBACK requires approval and exact target limits.
- Canary/serial rollout, failure thresholds, health gates, and stop conditions.
- No secrets, private keys, credentials, or protected health information in artifacts.

## Acceptance decision

UC-LNX-010 is **not yet accepted**. Acceptance requires implemented source, passing CI, controlled execution, runtime health, a zero-change second convergence, exercised recovery, reviewed evidence, and publication on the canonical branch.
