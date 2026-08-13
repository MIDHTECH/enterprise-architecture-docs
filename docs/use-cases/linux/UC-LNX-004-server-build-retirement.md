# UC-LNX-004: Server Build and Retirement

Last verified: 2026-08-02

## Use-case record

| Field | Value |
| --- | --- |
| Portfolio | Enterprise Linux Systems Engineering Platform |
| Canonical coverage target | Approved creation, handoff, backup and decommission workflow |
| Delivery model | End-to-end infrastructure as code |
| Primary roles | Linux platform lead, service owner, backup engineer, security engineer, change approver |
| Target environment | Linux VMs across the accepted on-premises fleet |
| Current state | **Partially scaffolded. Lifecycle assessment exists; creation, handoff, quarantine, backup proof, and Terraform retirement are not accepted end to end.** |
| Related change | None; implementation requires a future approved change record |
| Owner | Linux Platform team |

## Purpose

A server needs a controlled beginning and an equally controlled end. One lifecycle record keeps ownership, monitoring, backup, data disposition, access removal, and decommission evidence from getting lost between teams.

## Expected outcome

A build reaches handoff only after baseline, monitoring, backup, and owner checks pass. Retirement clears dependencies and retention obligations, then records how access, data, DNS, inventory, and compute were removed.

## Platform and enterprise fit

| Relationship | Detailed fit |
| --- | --- |
| Owning platform | **Server Build and Retirement** belongs to the the documented enterprise outcome because that platform turns GitLab-reviewed standards through Jenkins approval and Terraform/image or AWX/Ansible execution into verified operating-system state. |
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
| Trigger | A service owner requests a new server or an owner-approved retirement |
| Engineering owners | Linux platform lead, service owner, backup engineer, security engineer, change approver |
| Approver | Confirms target, risk, window, plan, and recovery readiness |
| SRE/operations | Reviews health, alerts, evidence, incident linkage, and handoff |

## Preconditions

- The sequential change-control record authorizes this exact Linux component and no conflicting work is active.
- GitLab, the matching tagged runner, Jenkins, AWX, target inventory, DNS, and required observability paths are healthy.
- The target and canary are named explicitly; dynamic all-host execution is not the default.
- Credentials and sensitive variables are stored in approved secret systems and referenced by ID, never committed.
- Backup, snapshot, replacement, or other recovery evidence appropriate to the change exists before mutation.
- The selected Git SHA has passed all source, syntax, lint, policy, and secret gates.

## Scope and exclusions

**In scope:** Request validation, build, baseline, ownership handoff, CMDB/inventory evidence, backup proof, quarantine, data disposition, and IaC deletion.

**Excluded:** Emergency break-glass recovery, undocumented deletion, and application data disposal without owner approval.

## Architecture diagram

![UC-LNX-004 Server Build and Retirement architecture](../../assets/use-cases/UC-LNX-004/UC-LNX-004-architecture.svg)

The owner-approved request flows through build or retirement orchestration and closes with either service handoff or verified decommission evidence.

## IaC delivery model

| Layer | Ownership and control |
| --- | --- |
| GitLab | Authoritative source, merge request, protected branch, validation pipeline, immutable SHA, and artifacts |
| Jenkins | Operator-selected PLAN/CHECK/APPLY/ROLLBACK action, approval boundary, concurrency control, and evidence aggregation |
| Terraform/image automation | Owns VM, image, volume, network, and other infrastructure lifecycle only when the change touches those resources |
| AWX and Ansible | Own operating-system desired state, inventory targeting, check mode, serial rollout, and per-host job events |
| Observability and evidence | Health gates, logs, metrics, alerts, expected-versus-observed result, incident links, and acceptance record |

Current-source reality: roles/host_lifecycle generates lifecycle metadata evidence but does not create or retire servers.

## End-to-end implementation

### Code and configuration map

| State | Repository path | Responsibility |
| --- | --- | --- |
| Existing | `linux-systems-platform: roles/host_lifecycle and playbooks/lifecycle-assessment.yml` | Lifecycle, virtualization, and cloud-init assessment |
| Planned | `linux-systems-platform: playbooks/server-admission.yml and playbooks/server-retirement.yml` | Handoff, quarantine, backup, access removal, and retirement gates |
| Planned | `cloud-infra-automation-platform: terraform/environments/prod` | Reviewed creation and destruction of VM resources |

### Required variables and controls

| Variable/control | Example or constraint | Purpose |
| --- | --- | --- |
| `server_lifecycle_state` | requested/build/accepted/quarantine/retired | Makes phase explicit |
| `server_owner` | named team | Prevents ownerless hosts |
| `retention_ticket` | approved record ID | Binds data disposition |
| `backup_restore_evidence_id` | verified artifact ID | Blocks unsafe retirement |

### Delivery sequence

1. Create a reviewed request containing purpose, owner, capacity, identity, support window, data classification, backup tier, and retirement date.
2. Provision through the cloud-init use case and apply the OS baseline through AWX.
3. Run admission checks, record inventory and monitoring enrollment, and obtain owner handoff acceptance.
4. For retirement, freeze new deployment, remove traffic, capture dependency and backup/restore evidence, and place the host in quarantine.
5. Revoke access and credentials, verify retention approval, then plan exact Terraform destruction.
6. Delete only approved resources, reconcile DNS/inventory/monitoring, and retain the audit record.

## Code and configuration map

The table under **End-to-end implementation** is the implementation map required by the documentation contract. Paths marked `Existing` were observed in the current repository clone; paths marked `Planned` are design targets and must not be treated as completed source.

## Jira breakdown

### STORY-LNX-004-001: Implement and validate the source model

**Description:** The platform team keeps the inputs, roles or modules, tests, pipeline gates, and operating boundaries for Server Build and Retirement in Git. A reviewer can reproduce the proposal from the selected commit without relying on settings that exist only in a console.

**Status:** In progress; bounded supporting source exists, but the full use-case source gate is not accepted.

**Acceptance criteria:**

- Required inputs have schemas/defaults, safe bounds, owners, and secret references.
- Local validation and GitLab CI reject malformed, unsafe, non-idempotent, or out-of-scope changes.
- The pipeline publishes the immutable Git SHA, plan/check artifacts, and exact target assumptions.

**Implementation steps:**

1. Create a reviewed request containing purpose, owner, capacity, identity, support window, data classification, backup tier, and retirement date.
2. Provision through the cloud-init use case and apply the OS baseline through AWX.
3. Run admission checks, record inventory and monitoring enrollment, and obtain owner handoff acceptance.

**Completed work:** roles/host_lifecycle generates lifecycle metadata evidence but does not create or retire servers.

**Validation and rollback:** Run local and CI validation without runtime mutation. Roll back source by reverting the merge request and regenerating artifacts from the prior accepted revision.

**Required attachments:** `ART-LNX-004-001` and `ATT-LNX-004-001`.

### STORY-LNX-004-002: Execute the bounded canary and rollout

**Description:** The operator reviews PLAN or CHECK output against one named canary before applying Server Build and Retirement. Failed health or negative tests stop the run, and expansion requires explicit approval.

**Status:** Planned; no runtime acceptance is claimed.

**Acceptance criteria:**

- Jenkins/AWX or Terraform uses the reviewed Git SHA, credential references, inventory, and explicit canary limit.
- Canary health and negative tests pass before any cohort expansion.
- Failure thresholds stop the workflow and preserve artifacts without hidden manual correction.

**Implementation steps:**

1. For retirement, freeze new deployment, remove traffic, capture dependency and backup/restore evidence, and place the host in quarantine.
2. Revoke access and credentials, verify retention approval, then plan exact Terraform destruction.
3. Delete only approved resources, reconcile DNS/inventory/monitoring, and retain the audit record.

**Completed work:** The execution design is documented; a successful live canary is not yet recorded.

**Validation and rollback:** Admission evidence covers ownership, baseline, monitoring, backup, and service health; Retirement plan targets only the named VM and related ephemeral resources; Restore evidence exists before destructive approval. Cancel before destruction by restoring traffic, access, and monitoring from reviewed source. After approved destruction, recovery is a fresh IaC build plus tested data restore—not undeleting state.

**Required attachments:** `ART-LNX-004-002`, `ATT-LNX-004-002`, and `ATT-LNX-004-003`.

### STORY-LNX-004-003: Prove convergence, recovery, and handoff

**Description:** Operations accepts Server Build and Retirement only after the same revision converges cleanly, runtime health is visible, and the recovery path has been exercised. The evidence must explain what moved, what stayed stable, and how the team recovered it.

**Status:** Planned; blocked until the canary story succeeds.

**Acceptance criteria:**

- Repeating the same reviewed code and inputs produces zero unexpected change.
- Rollback or recovery is exercised and the service returns within its approved objective.
- Logs, metrics, job output, expected-versus-observed results, owner, and follow-up actions are published.

**Implementation steps:**

1. Repeat the identical execution and compare the changed-host/task/resource set.
2. Exercise the documented rollback or recovery path on the bounded target.
3. Verify service health, monitoring, security posture, and consumer access after recovery.
4. Publish sanitized artifacts, link incidents, and obtain owner/SRE acceptance.

**Completed work:** Acceptance criteria and evidence requirements are defined; no use-case-specific runtime evidence is claimed.

**Validation and rollback:** Post-retirement inventory, DNS, monitoring, and Terraform state are consistent. Cancel before destruction by restoring traffic, access, and monitoring from reviewed source. After approved destruction, recovery is a fresh IaC build plus tested data restore—not undeleting state.

**Required attachments:** `ART-LNX-004-003`, `ATT-LNX-004-004`, and `ATT-LNX-004-005`.

## Evidence and screenshot register

| ID | Required evidence | Source | Status |
| --- | --- | --- | --- |
| `ART-LNX-004-001` | CI validation, immutable SHA, and plan/check artifact | GitLab | Pending |
| `ATT-LNX-004-001` | Successful source pipeline overview | GitLab | Pending |
| `ART-LNX-004-002` | Canary execution log with target and changed set | Jenkins/AWX/Terraform | Pending |
| `ATT-LNX-004-002` | Canary job/build result | Jenkins or AWX | Pending |
| `ATT-LNX-004-003` | Runtime health and expected state | Approved CLI or dashboard | Pending |
| `ART-LNX-004-003` | Second convergence and rollback/recovery log | Control plane artifact | Pending |
| `ATT-LNX-004-004` | Recovery result | Control plane | Pending |
| `ATT-LNX-004-005` | Final accepted operating state | Dashboard or approved CLI | Pending |

## Expected versus current result

| Area | Expected | Current observation | Decision |
| --- | --- | --- | --- |
| Source | Complete IaC and pipeline for Server Build and Retirement | roles/host_lifecycle generates lifecycle metadata evidence but does not create or retire servers. | Not yet code complete |
| Runtime | Approved canary and cohort execution | No use-case-specific accepted run recorded | Pending |
| Idempotence | Identical second run has zero unexpected change | No accepted second convergence | Pending |
| Recovery | Recovery exercised and timed | No accepted recovery artifact | Pending |
| Evidence | Sanitized artifacts linked to immutable executions | Register defined; captures pending | Pending |

## Validation, idempotence, and rollback

- Admission evidence covers ownership, baseline, monitoring, backup, and service health.
- Retirement plan targets only the named VM and related ephemeral resources.
- Restore evidence exists before destructive approval.
- Post-retirement inventory, DNS, monitoring, and Terraform state are consistent.

**Rollback/recovery:** Cancel before destruction by restoring traffic, access, and monitoring from reviewed source. After approved destruction, recovery is a fresh IaC build plus tested data restore—not undeleting state.

Idempotence is proved by repeating the same reviewed revision, target, variables, and action after the first successful run. A green first run or an Ansible exit code of zero is insufficient when tasks still report unexplained changes.

## Troubleshooting guide

Primary scenario: **A retirement plan removes the VM but leaves its DNS record, monitoring target, and backup schedule active.**

1. Stop cohort expansion and preserve the Git SHA, pipeline, Jenkins build, AWX job, Terraform plan/state reference, timestamps, and target list.
2. Confirm the failure is in source validation, orchestration, infrastructure, connectivity, privilege, desired-state execution, or consumer health before changing anything.
3. Compare desired inputs with live facts and the last accepted evidence; inspect logs and metrics around the exact execution window.
4. Reproduce only on the canary or in check/plan mode, change one hypothesis at a time, and avoid console drift.
5. Run the documented recovery path. Record any unexpected failure or near miss in the incident register before resuming.

## Interview preparation

1. **Question:** Explain the end-to-end IaC architecture for Server Build and Retirement.
   **Answer signals:** Separate GitLab source gates, Jenkins approval, Terraform/image ownership where applicable, AWX/Ansible desired state, canary rollout, evidence, and rollback.

2. **Question:** Which inputs and target boundaries make server build and retirement safe to repeat and reuse?
   **Answer signals:** server_lifecycle_state, server_owner, retention_ticket, backup_restore_evidence_id; immutable inputs, explicit target limits, deterministic tasks, and no hidden UI state.

3. **Question:** What would you require before approving the first production APPLY?
   **Answer signals:** Admission evidence covers ownership, baseline, monitoring, backup, and service health; Retirement plan targets only the named VM and related ephemeral resources, a reviewed plan/check result, named owner, maintenance window, and recovery evidence.

4. **Question:** Troubleshooting scenario: A retirement plan removes the VM but leaves its DNS record, monitoring target, and backup schedule active. What do you do first?
   **Answer signals:** Stop propagation, preserve job and host evidence, compare desired versus observed state, isolate the failing layer, test one hypothesis at a time, and link an incident when unexpected.

5. **Question:** How do you prove idempotence and distinguish it from a successful first run?
   **Answer signals:** Repeat the identical reviewed revision and inputs; expect zero unintended changes, stable health, and equivalent evidence rather than merely an exit code of zero.

6. **Question:** Describe the rollback or recovery strategy.
   **Answer signals:** Cancel before destruction by restoring traffic, access, and monitoring from reviewed source. After approved destruction, recovery is a fresh IaC build plus tested data restore—not undeleting state.

7. **Question:** What security and audit controls would you defend in an interview?
   **Answer signals:** Least privilege, protected branches, secret references, approval gates, bounded limits, immutable Git SHA, machine-readable artifacts, and sanitized evidence.

8. **Question:** What tradeoff would you discuss between rapid decommissioning and evidence-preserving retention?
   **Answer signals:** State the business constraint, compare failure modes and recovery cost, choose a bounded default, measure the result, and document when the alternative is justified.

9. **Question:** Tell me about a time you owned a difficult Server Build and Retirement change or incident across multiple teams. What did you do?
   **Answer signals:** Use a concise STAR example showing ownership, risk communication, evidence-based decisions, a safe stop or rollback, collaboration with service/security/SRE owners, measurable recovery or improvement, and a durable IaC correction.

## Safety and security controls

- Protected branches, merge requests, tagged runners, immutable revisions, and retained artifacts.
- Least-privilege credentials referenced from Jenkins/AWX or the approved secret system.
- PLAN/CHECK by default; APPLY/ROLLBACK requires explicit confirmation and exact target limits.
- Serial/canary rollout, failure thresholds, runtime health gates, and stop conditions.
- No protected health information, credentials, private keys, or unredacted secrets in logs or screenshots.

## Acceptance decision

UC-LNX-004 is **not yet accepted**. This page is the end-to-end IaC implementation and interview specification. Acceptance requires completed source, a passing GitLab pipeline, controlled execution, runtime health, a zero-change second convergence, exercised recovery, reviewed evidence, and publication on the canonical branch.
