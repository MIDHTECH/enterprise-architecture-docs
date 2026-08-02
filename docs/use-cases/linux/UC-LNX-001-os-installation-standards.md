# UC-LNX-001: Ubuntu and Rocky Linux Installation Standards

Last verified: 2026-08-02

## Use-case record

| Field | Value |
| --- | --- |
| Portfolio | Enterprise Linux Systems Engineering Platform |
| Canonical coverage target | Reproducible supported operating-system builds |
| Delivery model | End-to-end infrastructure as code |
| Primary roles | Linux platform engineer, image engineer, security engineer, SRE |
| Target environment | New Rocky Linux and Ubuntu VM images before production admission |
| Current state | **Defined. The Linux repository validates existing Rocky hosts, but it has no accepted image-build pipeline or Ubuntu build source.** |
| Related change | None; implementation requires a future approved change record |
| Owner | Linux Platform team |

## Purpose

A reliable server build starts before Ansible connects to it. Installation media, checksums, unattended-install files, hardening choices, and admission tests stay together so another engineer can rebuild the image and explain what went into it.

## Expected outcome

The team can rebuild a signed Rocky or Ubuntu image from one reviewed commit, boot it in isolation, verify the baseline, and publish it only when admission passes. A repeat build produces the same manifest without remembered console steps.

## Trigger and actors

| Item | Definition |
| --- | --- |
| Trigger | A supported OS release or hardened image revision is approved for build |
| Engineering owners | Linux platform engineer, image engineer, security engineer, SRE |
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

**In scope:** Version-pinned Rocky and Ubuntu base images, checksums, unattended install inputs, image scanning, publication, provenance, and admission tests.

**Excluded:** Physical bare-metal imaging, desktop images, unreviewed public cloud marketplace images, and product installation.

## Architecture diagram

![UC-LNX-001 Ubuntu and Rocky Linux Installation Standards architecture](../../assets/use-cases/UC-LNX-001/UC-LNX-001-architecture.svg)

Approved OS policy and installation media move through Packer, Terraform, and Ansible, ending with a tested canary image and release evidence.

## IaC delivery model

| Layer | Ownership and control |
| --- | --- |
| GitLab | Authoritative source, merge request, protected branch, validation pipeline, immutable SHA, and artifacts |
| Jenkins | Operator-selected PLAN/CHECK/APPLY/ROLLBACK action, approval boundary, concurrency control, and evidence aggregation |
| Terraform/image automation | Owns VM, image, volume, network, and other infrastructure lifecycle only when the change touches those resources |
| AWX and Ansible | Own operating-system desired state, inventory targeting, check mode, serial rollout, and per-host job events |
| Observability and evidence | Health gates, logs, metrics, alerts, expected-versus-observed result, incident links, and acceptance record |

Current-source reality: Existing source provides inventory and baseline validation only; no image factory is claimed.

## End-to-end implementation

### Code and configuration map

| State | Repository path | Responsibility |
| --- | --- | --- |
| Existing | `linux-systems-platform: roles/linux_baseline and playbooks/preflight.yml` | Post-build OS assumption and baseline checks |
| Planned | `cloud-infra-automation-platform: image-build/rocky and image-build/ubuntu` | Packer definitions, Kickstart/autoinstall inputs, checksums, and image manifests |
| Planned | `linux-systems-platform: tests/os-images and playbooks/os-image-admission.yml` | Boot, package, service, SELinux, network, and evidence admission tests |

### Required variables and controls

| Variable/control | Example or constraint | Purpose |
| --- | --- | --- |
| `linux_image_family` | rocky or ubuntu | Selects supported build workflow |
| `linux_image_version` | approved major/minor | Prevents moving release targets |
| `linux_image_sha256` | publisher checksum | Verifies installation media |
| `linux_image_cis_profile` | approved profile ID | Binds hardening expectations to evidence |

### Delivery sequence

1. Pin installation media URL, checksum, OS version, firmware mode, disk layout, and package manifest in reviewed source.
2. Build an ephemeral image with Kickstart or autoinstall through the approved image pipeline; do not customize it manually.
3. Scan the image, export SBOM and build manifest, and sign or checksum the resulting artifact.
4. Provision an isolated canary VM from the candidate image through Terraform/libvirt and cloud-init.
5. Run Ansible admission checks for identity, networking, repositories, time, SELinux/AppArmor, firewall, guest agent, and unsupported packages.
6. Destroy the canary, publish the immutable image only after approval, and record consumers allowed to use it.

## Code and configuration map

The table under **End-to-end implementation** is the implementation map required by the documentation contract. Paths marked `Existing` were observed in the current repository clone; paths marked `Planned` are design targets and must not be treated as completed source.

## Jira breakdown

### STORY-LNX-001-001: Implement and validate the source model

**Description:** The platform team keeps the inputs, roles or modules, tests, pipeline gates, and operating boundaries for Ubuntu and Rocky Linux Installation Standards in Git. A reviewer can reproduce the proposal from the selected commit without relying on settings that exist only in a console.

**Status:** In progress; bounded supporting source exists, but the full use-case source gate is not accepted.

**Acceptance criteria:**

- Required inputs have schemas/defaults, safe bounds, owners, and secret references.
- Local validation and GitLab CI reject malformed, unsafe, non-idempotent, or out-of-scope changes.
- The pipeline publishes the immutable Git SHA, plan/check artifacts, and exact target assumptions.

**Implementation steps:**

1. Pin installation media URL, checksum, OS version, firmware mode, disk layout, and package manifest in reviewed source.
2. Build an ephemeral image with Kickstart or autoinstall through the approved image pipeline; do not customize it manually.
3. Scan the image, export SBOM and build manifest, and sign or checksum the resulting artifact.

**Completed work:** Existing source provides inventory and baseline validation only; no image factory is claimed.

**Validation and rollback:** Run local and CI validation without runtime mutation. Roll back source by reverting the merge request and regenerating artifacts from the prior accepted revision.

**Required attachments:** `ART-LNX-001-001` and `ATT-LNX-001-001`.

### STORY-LNX-001-002: Execute the bounded canary and rollout

**Description:** The operator reviews PLAN or CHECK output against one named canary before applying Ubuntu and Rocky Linux Installation Standards. Failed health or negative tests stop the run, and expansion requires explicit approval.

**Status:** Planned; no runtime acceptance is claimed.

**Acceptance criteria:**

- Jenkins/AWX or Terraform uses the reviewed Git SHA, credential references, inventory, and explicit canary limit.
- Canary health and negative tests pass before any cohort expansion.
- Failure thresholds stop the workflow and preserve artifacts without hidden manual correction.

**Implementation steps:**

1. Provision an isolated canary VM from the candidate image through Terraform/libvirt and cloud-init.
2. Run Ansible admission checks for identity, networking, repositories, time, SELinux/AppArmor, firewall, guest agent, and unsupported packages.
3. Destroy the canary, publish the immutable image only after approval, and record consumers allowed to use it.

**Completed work:** The execution design is documented; a successful live canary is not yet recorded.

**Validation and rollback:** Packer/image source validation and checksum verification pass; Canary boots without interactive input and cloud-init completes once; Ansible check mode reports the approved baseline. Depublish the candidate image, restore the previous accepted image ID in environment variables, and rebuild affected unaccepted canaries. Existing production VMs are not reimaged as rollback.

**Required attachments:** `ART-LNX-001-002`, `ATT-LNX-001-002`, and `ATT-LNX-001-003`.

### STORY-LNX-001-003: Prove convergence, recovery, and handoff

**Description:** Operations accepts Ubuntu and Rocky Linux Installation Standards only after the same revision converges cleanly, runtime health is visible, and the recovery path has been exercised. The evidence must explain what moved, what stayed stable, and how the team recovered it.

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

**Validation and rollback:** Rebuild from the same inputs produces equivalent manifest and admission results. Depublish the candidate image, restore the previous accepted image ID in environment variables, and rebuild affected unaccepted canaries. Existing production VMs are not reimaged as rollback.

**Required attachments:** `ART-LNX-001-003`, `ATT-LNX-001-004`, and `ATT-LNX-001-005`.

## Evidence and screenshot register

| ID | Required evidence | Source | Status |
| --- | --- | --- | --- |
| `ART-LNX-001-001` | CI validation, immutable SHA, and plan/check artifact | GitLab | Pending |
| `ATT-LNX-001-001` | Successful source pipeline overview | GitLab | Pending |
| `ART-LNX-001-002` | Canary execution log with target and changed set | Jenkins/AWX/Terraform | Pending |
| `ATT-LNX-001-002` | Canary job/build result | Jenkins or AWX | Pending |
| `ATT-LNX-001-003` | Runtime health and expected state | Approved CLI or dashboard | Pending |
| `ART-LNX-001-003` | Second convergence and rollback/recovery log | Control plane artifact | Pending |
| `ATT-LNX-001-004` | Recovery result | Control plane | Pending |
| `ATT-LNX-001-005` | Final accepted operating state | Dashboard or approved CLI | Pending |

## Expected versus current result

| Area | Expected | Current observation | Decision |
| --- | --- | --- | --- |
| Source | Complete IaC and pipeline for Ubuntu and Rocky Linux Installation Standards | Existing source provides inventory and baseline validation only; no image factory is claimed. | Not yet code complete |
| Runtime | Approved canary and cohort execution | No use-case-specific accepted run recorded | Pending |
| Idempotence | Identical second run has zero unexpected change | No accepted second convergence | Pending |
| Recovery | Recovery exercised and timed | No accepted recovery artifact | Pending |
| Evidence | Sanitized artifacts linked to immutable executions | Register defined; captures pending | Pending |

## Validation, idempotence, and rollback

- Packer/image source validation and checksum verification pass.
- Canary boots without interactive input and cloud-init completes once.
- Ansible check mode reports the approved baseline.
- Rebuild from the same inputs produces equivalent manifest and admission results.

**Rollback/recovery:** Depublish the candidate image, restore the previous accepted image ID in environment variables, and rebuild affected unaccepted canaries. Existing production VMs are not reimaged as rollback.

Idempotence is proved by repeating the same reviewed revision, target, variables, and action after the first successful run. A green first run or an Ansible exit code of zero is insufficient when tasks still report unexplained changes.

## Troubleshooting guide

Primary scenario: **The canary boots but cloud-init never reaches done.**

1. Stop cohort expansion and preserve the Git SHA, pipeline, Jenkins build, AWX job, Terraform plan/state reference, timestamps, and target list.
2. Confirm the failure is in source validation, orchestration, infrastructure, connectivity, privilege, desired-state execution, or consumer health before changing anything.
3. Compare desired inputs with live facts and the last accepted evidence; inspect logs and metrics around the exact execution window.
4. Reproduce only on the canary or in check/plan mode, change one hypothesis at a time, and avoid console drift.
5. Run the documented recovery path. Record any unexpected failure or near miss in the incident register before resuming.

## Interview preparation

1. **Question:** Explain the end-to-end IaC architecture for Ubuntu and Rocky Linux Installation Standards.
   **Answer signals:** Separate GitLab source gates, Jenkins approval, Terraform/image ownership where applicable, AWX/Ansible desired state, canary rollout, evidence, and rollback.

2. **Question:** Which inputs and target boundaries make Ubuntu and Rocky Linux installation standards safe to repeat and reuse?
   **Answer signals:** linux_image_family, linux_image_version, linux_image_sha256, linux_image_cis_profile; immutable inputs, explicit target limits, deterministic tasks, and no hidden UI state.

3. **Question:** What would you require before approving the first production APPLY?
   **Answer signals:** Packer/image source validation and checksum verification pass; Canary boots without interactive input and cloud-init completes once, a reviewed plan/check result, named owner, maintenance window, and recovery evidence.

4. **Question:** Troubleshooting scenario: The canary boots but cloud-init never reaches done. What do you do first?
   **Answer signals:** Stop propagation, preserve job and host evidence, compare desired versus observed state, isolate the failing layer, test one hypothesis at a time, and link an incident when unexpected.

5. **Question:** How do you prove idempotence and distinguish it from a successful first run?
   **Answer signals:** Repeat the identical reviewed revision and inputs; expect zero unintended changes, stable health, and equivalent evidence rather than merely an exit code of zero.

6. **Question:** Describe the rollback or recovery strategy.
   **Answer signals:** Depublish the candidate image, restore the previous accepted image ID in environment variables, and rebuild affected unaccepted canaries. Existing production VMs are not reimaged as rollback.

7. **Question:** What security and audit controls would you defend in an interview?
   **Answer signals:** Least privilege, protected branches, secret references, approval gates, bounded limits, immutable Git SHA, machine-readable artifacts, and sanitized evidence.

8. **Question:** What tradeoff would you discuss between image immutability and fast security updates?
   **Answer signals:** State the business constraint, compare failure modes and recovery cost, choose a bounded default, measure the result, and document when the alternative is justified.

9. **Question:** Tell me about a time you owned a difficult Ubuntu and Rocky Linux Installation Standards change or incident across multiple teams. What did you do?
   **Answer signals:** Use a concise STAR example showing ownership, risk communication, evidence-based decisions, a safe stop or rollback, collaboration with service/security/SRE owners, measurable recovery or improvement, and a durable IaC correction.

## Safety and security controls

- Protected branches, merge requests, tagged runners, immutable revisions, and retained artifacts.
- Least-privilege credentials referenced from Jenkins/AWX or the approved secret system.
- PLAN/CHECK by default; APPLY/ROLLBACK requires explicit confirmation and exact target limits.
- Serial/canary rollout, failure thresholds, runtime health gates, and stop conditions.
- No protected health information, credentials, private keys, or unredacted secrets in logs or screenshots.

## Acceptance decision

UC-LNX-001 is **not yet accepted**. This page is the end-to-end IaC implementation and interview specification. Acceptance requires completed source, a passing GitLab pipeline, controlled execution, runtime health, a zero-change second convergence, exercised recovery, reviewed evidence, and publication on the canonical branch.
