# UC-LNX-003: VM Provisioning with cloud-init

Last verified: 2026-08-02

## Use-case record

| Field | Value |
| --- | --- |
| Portfolio | Enterprise Linux Systems Engineering Platform |
| Canonical coverage target | Repeatable identity, network and SSH bootstrap |
| Delivery model | End-to-end infrastructure as code |
| Primary roles | Infrastructure engineer, Linux platform engineer, network engineer, security engineer |
| Target environment | New on-premises Linux VMs created from accepted images |
| Current state | **Defined. Existing guests contain cloud-init metadata, but no end-to-end provisioning pipeline is accepted in this repository.** |
| Related change | None; implementation requires a future approved change record |
| Owner | Linux Platform team |

## Purpose

Provisioning is not finished when a VM powers on. Ownership, addressing, DNS, image, SSH bootstrap, and expiry details must travel from Git to a reachable host without anyone repairing cloud-init by hand.

## Expected outcome

An approved request creates one VM with the intended identity and network, cloud-init completes once, and Ansible reaches it through the expected account. Reapplying the revision leaves both VM and bootstrap state unchanged.

## Platform and enterprise fit

| Relationship | Detailed fit |
| --- | --- |
| Owning platform | **VM Provisioning with cloud-init** belongs to the the documented enterprise outcome because that platform turns GitLab-reviewed standards through Jenkins approval and Terraform/image or AWX/Ansible execution into verified operating-system state. |
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
| Trigger | An approved VM request has capacity, DNS, IP, ownership, and lifecycle metadata |
| Engineering owners | Infrastructure engineer, Linux platform engineer, network engineer, security engineer |
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

**In scope:** Terraform VM creation, deterministic identity, cloud-init metadata/user data, SSH bootstrap, DNS reservation, and inventory handoff.

**Excluded:** Long-term OS configuration in cloud-init, embedded secrets, product installation, and DHCP-created identity drift.

## Architecture diagram

![UC-LNX-003 VM Provisioning with cloud-init architecture](../../assets/use-cases/UC-LNX-003/UC-LNX-003-architecture.svg)

Request metadata and IPAM decisions drive Terraform and cloud-init, followed by DNS, SSH, and inventory checks before handoff.

## IaC delivery model

| Layer | Ownership and control |
| --- | --- |
| GitLab | Authoritative source, merge request, protected branch, validation pipeline, immutable SHA, and artifacts |
| Jenkins | Operator-selected PLAN/CHECK/APPLY/ROLLBACK action, approval boundary, concurrency control, and evidence aggregation |
| Terraform/image automation | Owns VM, image, volume, network, and other infrastructure lifecycle only when the change touches those resources |
| AWX and Ansible | Own operating-system desired state, inventory targeting, check mode, serial rollout, and per-host job events |
| Observability and evidence | Health gates, logs, metrics, alerts, expected-versus-observed result, incident links, and acceptance record |

Current-source reality: The host_lifecycle role assesses cloud-init and VM metadata on existing hosts; provisioning remains planned.

## End-to-end implementation

### Code and configuration map

| State | Repository path | Responsibility |
| --- | --- | --- |
| Existing | `linux-systems-platform: roles/host_lifecycle and playbooks/lifecycle-assessment.yml` | Read-only lifecycle and cloud-init metadata evidence |
| Planned | `cloud-infra-automation-platform: terraform/modules/compute and environments/prod` | VM domain, volume, NIC, and cloud-init ISO resources |
| Planned | `linux-systems-platform: playbooks/provisioning-admission.yml` | Post-bootstrap inventory, DNS, SSH, guest-agent, and baseline admission |

### Required variables and controls

| Variable/control | Example or constraint | Purpose |
| --- | --- | --- |
| `vm_fqdn` | approved example.com name | Canonical identity |
| `vm_ipv4_and_mac` | reserved deterministic pair | Stable network mapping |
| `cloud_init_image_id` | accepted immutable image | Reproducible OS source |
| `bootstrap_public_key_id` | vault-backed reference | Avoids private material in Git |

### Delivery sequence

1. Validate naming, MAC, IP, DNS, capacity, owner, data classification, and retirement date before code review.
2. Render cloud-init metadata and user data from non-secret variables; retrieve sensitive bootstrap material at execution time.
3. Plan and apply the libvirt domain, disk, NIC, and cloud-init seed through Terraform.
4. Wait for guest-agent and cloud-init completion, then verify FQDN, routes, resolver, time, SSH host key, and authorized access.
5. Add the VM to the canonical inventory and run the Ansible baseline in check mode before any product role.
6. Re-run Terraform and Ansible to prove no drift, then remove bootstrap-only access.

## Code and configuration map

The table under **End-to-end implementation** is the implementation map required by the documentation contract. Paths marked `Existing` were observed in the current repository clone; paths marked `Planned` are design targets and must not be treated as completed source.

## Jira breakdown

### STORY-LNX-003-001: Implement and validate the source model

**Description:** The platform team keeps the inputs, roles or modules, tests, pipeline gates, and operating boundaries for VM Provisioning with cloud-init in Git. A reviewer can reproduce the proposal from the selected commit without relying on settings that exist only in a console.

**Status:** In progress; bounded supporting source exists, but the full use-case source gate is not accepted.

**Acceptance criteria:**

- Required inputs have schemas/defaults, safe bounds, owners, and secret references.
- Local validation and GitLab CI reject malformed, unsafe, non-idempotent, or out-of-scope changes.
- The pipeline publishes the immutable Git SHA, plan/check artifacts, and exact target assumptions.

**Implementation steps:**

1. Validate naming, MAC, IP, DNS, capacity, owner, data classification, and retirement date before code review.
2. Render cloud-init metadata and user data from non-secret variables; retrieve sensitive bootstrap material at execution time.
3. Plan and apply the libvirt domain, disk, NIC, and cloud-init seed through Terraform.

**Completed work:** The host_lifecycle role assesses cloud-init and VM metadata on existing hosts; provisioning remains planned.

**Validation and rollback:** Run local and CI validation without runtime mutation. Roll back source by reverting the merge request and regenerating artifacts from the prior accepted revision.

**Required attachments:** `ART-LNX-003-001` and `ATT-LNX-003-001`.

### STORY-LNX-003-002: Execute the bounded canary and rollout

**Description:** The operator reviews PLAN or CHECK output against one named canary before applying VM Provisioning with cloud-init. Failed health or negative tests stop the run, and expansion requires explicit approval.

**Status:** Planned; no runtime acceptance is claimed.

**Acceptance criteria:**

- Jenkins/AWX or Terraform uses the reviewed Git SHA, credential references, inventory, and explicit canary limit.
- Canary health and negative tests pass before any cohort expansion.
- Failure thresholds stop the workflow and preserve artifacts without hidden manual correction.

**Implementation steps:**

1. Wait for guest-agent and cloud-init completion, then verify FQDN, routes, resolver, time, SSH host key, and authorized access.
2. Add the VM to the canonical inventory and run the Ansible baseline in check mode before any product role.
3. Re-run Terraform and Ansible to prove no drift, then remove bootstrap-only access.

**Completed work:** The execution design is documented; a successful live canary is not yet recorded.

**Validation and rollback:** cloud-init schema validation passes before plan; Terraform plan contains one approved VM and no unrelated changes; cloud-init status is done and network identity matches reservations. Before handoff, destroy the exact VM/volume/seed resources through Terraform and remove only its unused reservation records. After handoff, use the server-retirement workflow.

**Required attachments:** `ART-LNX-003-002`, `ATT-LNX-003-002`, and `ATT-LNX-003-003`.

### STORY-LNX-003-003: Prove convergence, recovery, and handoff

**Description:** Operations accepts VM Provisioning with cloud-init only after the same revision converges cleanly, runtime health is visible, and the recovery path has been exercised. The evidence must explain what moved, what stayed stable, and how the team recovered it.

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

**Validation and rollback:** Second Terraform plan and Ansible run converge with zero unexpected change. Before handoff, destroy the exact VM/volume/seed resources through Terraform and remove only its unused reservation records. After handoff, use the server-retirement workflow.

**Required attachments:** `ART-LNX-003-003`, `ATT-LNX-003-004`, and `ATT-LNX-003-005`.

## Evidence and screenshot register

| ID | Required evidence | Source | Status |
| --- | --- | --- | --- |
| `ART-LNX-003-001` | CI validation, immutable SHA, and plan/check artifact | GitLab | Pending |
| `ATT-LNX-003-001` | Successful source pipeline overview | GitLab | Pending |
| `ART-LNX-003-002` | Canary execution log with target and changed set | Jenkins/AWX/Terraform | Pending |
| `ATT-LNX-003-002` | Canary job/build result | Jenkins or AWX | Pending |
| `ATT-LNX-003-003` | Runtime health and expected state | Approved CLI or dashboard | Pending |
| `ART-LNX-003-003` | Second convergence and rollback/recovery log | Control plane artifact | Pending |
| `ATT-LNX-003-004` | Recovery result | Control plane | Pending |
| `ATT-LNX-003-005` | Final accepted operating state | Dashboard or approved CLI | Pending |

## Expected versus current result

| Area | Expected | Current observation | Decision |
| --- | --- | --- | --- |
| Source | Complete IaC and pipeline for VM Provisioning with cloud-init | The host_lifecycle role assesses cloud-init and VM metadata on existing hosts; provisioning remains planned. | Not yet code complete |
| Runtime | Approved canary and cohort execution | No use-case-specific accepted run recorded | Pending |
| Idempotence | Identical second run has zero unexpected change | No accepted second convergence | Pending |
| Recovery | Recovery exercised and timed | No accepted recovery artifact | Pending |
| Evidence | Sanitized artifacts linked to immutable executions | Register defined; captures pending | Pending |

## Validation, idempotence, and rollback

- cloud-init schema validation passes before plan.
- Terraform plan contains one approved VM and no unrelated changes.
- cloud-init status is done and network identity matches reservations.
- Second Terraform plan and Ansible run converge with zero unexpected change.

**Rollback/recovery:** Before handoff, destroy the exact VM/volume/seed resources through Terraform and remove only its unused reservation records. After handoff, use the server-retirement workflow.

Idempotence is proved by repeating the same reviewed revision, target, variables, and action after the first successful run. A green first run or an Ansible exit code of zero is insufficient when tasks still report unexplained changes.

## Troubleshooting guide

Primary scenario: **The VM is running but SSH presents a different host key and the reserved address is already in use.**

1. Stop cohort expansion and preserve the Git SHA, pipeline, Jenkins build, AWX job, Terraform plan/state reference, timestamps, and target list.
2. Confirm the failure is in source validation, orchestration, infrastructure, connectivity, privilege, desired-state execution, or consumer health before changing anything.
3. Compare desired inputs with live facts and the last accepted evidence; inspect logs and metrics around the exact execution window.
4. Reproduce only on the canary or in check/plan mode, change one hypothesis at a time, and avoid console drift.
5. Run the documented recovery path. Record any unexpected failure or near miss in the incident register before resuming.

## Interview preparation

1. **Question:** Explain the end-to-end IaC architecture for VM Provisioning with cloud-init.
   **Answer signals:** Separate GitLab source gates, Jenkins approval, Terraform/image ownership where applicable, AWX/Ansible desired state, canary rollout, evidence, and rollback.

2. **Question:** Which inputs and target boundaries make VM provisioning with cloud-init safe to repeat and reuse?
   **Answer signals:** vm_fqdn, vm_ipv4_and_mac, cloud_init_image_id, bootstrap_public_key_id; immutable inputs, explicit target limits, deterministic tasks, and no hidden UI state.

3. **Question:** What would you require before approving the first production APPLY?
   **Answer signals:** cloud-init schema validation passes before plan; Terraform plan contains one approved VM and no unrelated changes, a reviewed plan/check result, named owner, maintenance window, and recovery evidence.

4. **Question:** Troubleshooting scenario: The VM is running but SSH presents a different host key and the reserved address is already in use. What do you do first?
   **Answer signals:** Stop propagation, preserve job and host evidence, compare desired versus observed state, isolate the failing layer, test one hypothesis at a time, and link an incident when unexpected.

5. **Question:** How do you prove idempotence and distinguish it from a successful first run?
   **Answer signals:** Repeat the identical reviewed revision and inputs; expect zero unintended changes, stable health, and equivalent evidence rather than merely an exit code of zero.

6. **Question:** Describe the rollback or recovery strategy.
   **Answer signals:** Before handoff, destroy the exact VM/volume/seed resources through Terraform and remove only its unused reservation records. After handoff, use the server-retirement workflow.

7. **Question:** What security and audit controls would you defend in an interview?
   **Answer signals:** Least privilege, protected branches, secret references, approval gates, bounded limits, immutable Git SHA, machine-readable artifacts, and sanitized evidence.

8. **Question:** What tradeoff would you discuss between fast bootstrap and keeping configuration out of cloud-init?
   **Answer signals:** State the business constraint, compare failure modes and recovery cost, choose a bounded default, measure the result, and document when the alternative is justified.

9. **Question:** Tell me about a time you owned a difficult VM Provisioning with cloud-init change or incident across multiple teams. What did you do?
   **Answer signals:** Use a concise STAR example showing ownership, risk communication, evidence-based decisions, a safe stop or rollback, collaboration with service/security/SRE owners, measurable recovery or improvement, and a durable IaC correction.

## Safety and security controls

- Protected branches, merge requests, tagged runners, immutable revisions, and retained artifacts.
- Least-privilege credentials referenced from Jenkins/AWX or the approved secret system.
- PLAN/CHECK by default; APPLY/ROLLBACK requires explicit confirmation and exact target limits.
- Serial/canary rollout, failure thresholds, runtime health gates, and stop conditions.
- No protected health information, credentials, private keys, or unredacted secrets in logs or screenshots.

## Acceptance decision

UC-LNX-003 is **not yet accepted**. This page is the end-to-end IaC implementation and interview specification. Acceptance requires completed source, a passing GitLab pipeline, controlled execution, runtime health, a zero-change second convergence, exercised recovery, reviewed evidence, and publication on the canonical branch.
