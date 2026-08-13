# UC-LNX-014: Performance and Capacity Troubleshooting

Last verified: 2026-08-02

## Use-case record

| Field | Value |
| --- | --- |
| Portfolio | Enterprise Linux Systems Engineering Platform |
| Canonical coverage target | CPU, memory, disk and network diagnosis |
| Delivery model | End-to-end infrastructure as code |
| Primary roles | Linux performance engineer, SRE, service owner, virtualization engineer |
| Target environment | Linux hosts and services showing saturation, latency, error, or growth risk |
| Current state | **Partially implemented. Capacity evidence collection exists; automated baseline comparison, diagnostic bundles, safe tuning, and regression gates are planned.** |
| Related change | None; implementation requires a future approved change record |
| Owner | Linux Platform team |

## Purpose

Good performance work preserves evidence before tuning begins. Metrics, logs, workload context, baselines, and diagnostic commands help the team identify a bottleneck instead of choosing a convenient guess.

## Expected outcome

An engineer reproduces the symptom on a bounded target, identifies the constrained resource, tests one change, and measures the result. Persistent tuning is reviewed as code with a reversal threshold.

## Platform and enterprise fit

| Relationship | Detailed fit |
| --- | --- |
| Owning platform | **Performance and Capacity Troubleshooting** belongs to the the documented enterprise outcome because that platform turns GitLab-reviewed standards through Jenkins approval and Terraform/image or AWX/Ansible execution into verified operating-system state. |
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
| Trigger | An alert, incident, trend, or capacity review indicates a resource risk |
| Engineering owners | Linux performance engineer, SRE, service owner, virtualization engineer |
| Approver | Confirms target, risk, maintenance window, evidence, and recovery readiness |
| SRE/operations | Reviews health, alerts, incidents, convergence, and handoff |

## Preconditions

- The sequential change record authorizes this exact use case and no conflicting infrastructure work is active.
- GitLab, tagged runners, Jenkins, AWX, inventory, DNS, and observability dependencies are healthy.
- Target and canary limits are explicit; credentials are referenced from approved secret systems.
- The selected Git SHA passed syntax, lint, policy, secret, and plan/check gates.
- Required backup, console, replacement, or recovery evidence exists before mutation.

## Scope and exclusions

**In scope:** CPU, run queue, memory, reclaim/swap, filesystem, I/O latency, network, process/cgroup, virtualization contention, trend, tuning, and evidence.

**Excluded:** Unmeasured sysctl tuning, permanent emergency commands, application code optimization, and capacity purchases without workload evidence.

## Architecture diagram

![UC-LNX-014 Performance and Capacity Troubleshooting architecture](../../assets/use-cases/UC-LNX-014/UC-LNX-014-architecture.svg)

An alert or capacity trend triggers evidence capture and layer-by-layer diagnosis, followed by a bounded tuning experiment against the original baseline.

## IaC delivery model

| Layer | Responsibility |
| --- | --- |
| GitLab | Source of truth, merge request, protected branch, CI gates, immutable SHA, and artifacts |
| Jenkins | Manual PLAN/CHECK/APPLY/ROLLBACK selection, approval, concurrency control, and evidence aggregation |
| Terraform/image automation | Infrastructure lifecycle only when the change affects VM, image, volume, or network resources |
| AWX and Ansible | OS desired state, check mode, inventory limit, serial rollout, and per-host events |
| Observability/evidence | Health gates, logs, metrics, incidents, expected-versus-observed result, and acceptance |

Current-source reality: roles/performance_capacity collects first-response CPU, memory, disk, and network evidence.

## End-to-end implementation

### Code and configuration map

| State | Repository path | Responsibility |
| --- | --- | --- |
| Existing | `linux-systems-platform: roles/performance_capacity and playbooks/performance-capacity.yml` | First-response host capacity evidence |
| Planned | `linux-systems-platform: roles/performance_diagnostics` | Bounded diagnostic bundle and baseline comparison |
| Planned | `linux-systems-platform: roles/performance_tuning and tests/performance` | Reviewed sysctl/limits/tuned changes with regression and rollback |

### Required variables and controls

| Variable/control | Example or constraint | Purpose |
| --- | --- | --- |
| `diagnostic_window` | incident start/end UTC | Correlates evidence |
| `capacity_thresholds` | CPU/memory/disk/network SLOs | Decision boundaries |
| `tuning_profile` | reviewed versioned profile | Prevents console tuning |
| `canary_workload_probe` | repeatable test ID | Before/after comparison |

### Delivery sequence

1. Freeze the incident timeline and collect host, process, cgroup, disk, network, virtualization, logs, and workload metrics before tuning.
2. Compare against a known healthy baseline and distinguish saturation, contention, throttling, leak, queueing, and downstream latency.
3. Encode only evidence-backed limits, sysctls, scheduler, mount, or service settings as reviewed variables.
4. Apply one change to a canary or one service member and run the same workload/health probes.
5. Measure latency, throughput, errors, resource utilization, and side effects over an agreed window.
6. Repeat configuration for idempotence and update capacity forecast, alerts, and the incident/RCA.

## Code and configuration map

The implementation map above is authoritative for this detail page. `Existing` paths were observed in the current repository clone. `Planned` paths are IaC design targets and are not completion claims.

## Jira breakdown

### STORY-LNX-014-001: Implement and validate the source model

**Description:** The platform team keeps the inputs, roles or modules, tests, pipeline gates, and operating boundaries for Performance and Capacity Troubleshooting in Git. A reviewer can reproduce the proposal from the selected commit without relying on settings that exist only in a console.

**Status:** In progress where supporting source is listed; the complete source gate is not accepted.

**Acceptance criteria:**

- Inputs have schemas/defaults, safe bounds, owners, and secret references.
- CI rejects malformed, unsafe, non-idempotent, and out-of-scope changes.
- The pipeline publishes the immutable SHA, exact target assumptions, and plan/check artifact.

**Implementation steps:**

1. Freeze the incident timeline and collect host, process, cgroup, disk, network, virtualization, logs, and workload metrics before tuning.
2. Compare against a known healthy baseline and distinguish saturation, contention, throttling, leak, queueing, and downstream latency.
3. Encode only evidence-backed limits, sysctls, scheduler, mount, or service settings as reviewed variables.

**Completed work:** roles/performance_capacity collects first-response CPU, memory, disk, and network evidence.

**Validation and rollback:** Validate without mutation; revert the merge request and regenerate artifacts from the prior accepted revision if the source gate is wrong.

**Required attachments:** `ART-LNX-014-001` and `ATT-LNX-014-001`.

### STORY-LNX-014-002: Execute the bounded canary and rollout

**Description:** The operator reviews PLAN or CHECK output against one named canary before applying Performance and Capacity Troubleshooting. Failed health or negative tests stop the run, and expansion requires explicit approval.

**Status:** Planned; no live acceptance is claimed.

**Acceptance criteria:**

- Execution uses the reviewed SHA, credentials, inventory, variables, and canary limit.
- Health and negative tests pass before cohort expansion.
- Failure thresholds preserve artifacts and stop without hidden manual correction.

**Implementation steps:**

1. Apply one change to a canary or one service member and run the same workload/health probes.
2. Measure latency, throughput, errors, resource utilization, and side effects over an agreed window.
3. Repeat configuration for idempotence and update capacity forecast, alerts, and the incident/RCA.

**Completed work:** The controlled execution design exists only in documentation.

**Validation and rollback:** Diagnostic bundle is time-aligned and identifies the constrained layer; Proposed tuning has a measurable hypothesis and rollback value; Canary improves the target metric without violating another SLO. Restore the previous profile/limits/sysctl revision, restart only when required, and verify the original baseline. Capacity rollback may require moving workload or restoring the former VM allocation through its owning IaC.

**Required attachments:** `ART-LNX-014-002`, `ATT-LNX-014-002`, and `ATT-LNX-014-003`.

### STORY-LNX-014-003: Prove convergence, recovery, and handoff

**Description:** Operations accepts Performance and Capacity Troubleshooting only after the same revision converges cleanly, runtime health is visible, and the recovery path has been exercised. The evidence must explain what moved, what stayed stable, and how the team recovered it.

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

**Validation and rollback:** Second run is unchanged and post-change trend remains stable. Restore the previous profile/limits/sysctl revision, restart only when required, and verify the original baseline. Capacity rollback may require moving workload or restoring the former VM allocation through its owning IaC.

**Required attachments:** `ART-LNX-014-003`, `ATT-LNX-014-004`, and `ATT-LNX-014-005`.

## Evidence and screenshot register

| ID | Required evidence | Source | Status |
| --- | --- | --- | --- |
| `ART-LNX-014-001` | CI validation, immutable SHA, and plan/check artifact | GitLab | Pending |
| `ATT-LNX-014-001` | Successful source pipeline | GitLab | Pending |
| `ART-LNX-014-002` | Canary execution log and changed set | Jenkins/AWX/Terraform | Pending |
| `ATT-LNX-014-002` | Canary result | Control plane | Pending |
| `ATT-LNX-014-003` | Runtime health and expected state | Dashboard or approved CLI | Pending |
| `ART-LNX-014-003` | Second convergence and recovery log | Control plane | Pending |
| `ATT-LNX-014-004` | Recovery result | Control plane | Pending |
| `ATT-LNX-014-005` | Final accepted state | Dashboard or approved CLI | Pending |

## Expected versus current result

| Area | Expected | Current observation | Decision |
| --- | --- | --- | --- |
| Source | Complete IaC and pipeline for Performance and Capacity Troubleshooting | roles/performance_capacity collects first-response CPU, memory, disk, and network evidence. | Not yet code complete |
| Runtime | Approved canary and cohort execution | No use-case-specific accepted run | Pending |
| Idempotence | Identical second run has zero unexpected change | No accepted convergence proof | Pending |
| Recovery | Recovery exercised and timed | No accepted recovery artifact | Pending |
| Evidence | Sanitized artifacts tied to immutable executions | Register defined; captures pending | Pending |

## Validation, idempotence, and rollback

- Diagnostic bundle is time-aligned and identifies the constrained layer.
- Proposed tuning has a measurable hypothesis and rollback value.
- Canary improves the target metric without violating another SLO.
- Second run is unchanged and post-change trend remains stable.

**Rollback/recovery:** Restore the previous profile/limits/sysctl revision, restart only when required, and verify the original baseline. Capacity rollback may require moving workload or restoring the former VM allocation through its owning IaC.

Idempotence requires the same reviewed revision, target, variables, and action to produce zero unexplained changes plus stable consumer health. A green first run alone is insufficient.

## Troubleshooting guide

Primary scenario: **CPU is low but application latency rises while disk utilization appears normal.**

1. Stop propagation and retain the Git SHA, plan/check, execution IDs, timestamps, and target list.
2. Isolate source, orchestration, infrastructure, connectivity, privilege, host-state, and consumer-health layers.
3. Compare live facts with the intended variables and last accepted baseline; correlate logs and metrics to the execution window.
4. Reproduce only on the canary or in PLAN/CHECK, change one hypothesis, and avoid console drift.
5. Recover through the documented path and record unexpected failures or near misses in the incident register.

## Interview preparation

1. **Question:** Explain the end-to-end IaC architecture for Performance and Capacity Troubleshooting.
   **Answer signals:** Separate source validation, approval/orchestration, infrastructure ownership, AWX/Ansible desired state, runtime health, convergence, evidence, and recovery.

2. **Question:** How would you model performance and capacity work so repeated execution stays safe?
   **Answer signals:** diagnostic_window, capacity_thresholds, tuning_profile, canary_workload_probe; stable identities, declarative state, handlers only on change, bounded targets, and explicit exclusions.

3. **Question:** What must be visible in a GitLab pipeline before runtime approval?
   **Answer signals:** Diagnostic bundle is time-aligned and identifies the constrained layer; Proposed tuning has a measurable hypothesis and rollback value; immutable SHA, lint/policy results, plan/check artifact, target assumptions, and no secret exposure.

4. **Question:** Troubleshooting scenario: CPU is low but application latency rises while disk utilization appears normal. What is your investigation order?
   **Answer signals:** Stop propagation, preserve timestamps and artifacts, verify target/input, isolate source/orchestration/connectivity/privilege/host/service layers, compare to baseline, and test on the canary.

5. **Question:** How do you prove idempotence rather than only success?
   **Answer signals:** Run the same reviewed SHA, inputs, target, and action again; require zero unexplained changes plus stable consumer health and evidence.

6. **Question:** What rollback or recovery would you use?
   **Answer signals:** Restore the previous profile/limits/sysctl revision, restart only when required, and verify the original baseline. Capacity rollback may require moving workload or restoring the former VM allocation through its owning IaC.

7. **Question:** Which security and audit controls matter most?
   **Answer signals:** Least privilege, protected source, secret references, explicit approval, canary limits, negative tests, immutable artifacts, exception expiry, and incident linkage.

8. **Question:** Discuss the tradeoff between aggressive utilization and predictable latency headroom.
   **Answer signals:** Tie the choice to service objectives and failure modes, use a conservative default, measure on a canary, preserve recovery, and document exceptions.

9. **Question:** Tell me about a time you owned a difficult Performance and Capacity Troubleshooting change or incident across multiple teams. What did you do?
   **Answer signals:** Use a concise STAR example showing ownership, risk communication, evidence-based decisions, a safe stop or rollback, collaboration with service/security/SRE owners, measurable recovery or improvement, and a durable IaC correction.

## Safety and security controls

- Protected source, merge requests, tagged runners, immutable revisions, and retained artifacts.
- Least-privilege credentials referenced from approved secret systems.
- PLAN/CHECK by default; APPLY/ROLLBACK requires approval and exact target limits.
- Canary/serial rollout, failure thresholds, health gates, and stop conditions.
- No secrets, private keys, credentials, or protected health information in artifacts.

## Acceptance decision

UC-LNX-014 is **not yet accepted**. Acceptance requires implemented source, passing CI, controlled execution, runtime health, a zero-change second convergence, exercised recovery, reviewed evidence, and publication on the canonical branch.
