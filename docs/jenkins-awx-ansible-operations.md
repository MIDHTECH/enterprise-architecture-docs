# Jenkins AWX Ansible Operations

## Purpose

This runbook records the program-level workflow for launching approved Ansible
automation through Jenkins and AWX. Active consumers are the specialist
platform domains:
`linux-systems-platform`, `database-reliability-platform`,
`resilience-service-operations`, `data-engineering-platform`, and
`network-engineering-platform`.

## Source Repositories

| Repository | Responsibility |
| --- | --- |
| `jenkins-jobs` | Defines the generated Jenkins job `projects/run-ansible-playbook` |
| `jenkins-shared-library` | Provides `ansibleAwxPipeline` and shared AWX reconciliation/launch logic |
| `linux-systems-platform` | Provides Linux inventory, playbooks, roles, runbooks, and GitLab CI validation |
| `database-reliability-platform` | Provides database readiness, backup/restore, security, performance, and lifecycle evidence automation |
| `resilience-service-operations` | Provides service catalog, SLO, incident, exercise, and readiness evidence automation |
| `data-engineering-platform` | Provides data source, quality, orchestration, lineage, and access governance evidence automation |
| `network-engineering-platform` | Provides source-of-truth, DNS/DHCP, connectivity, firewall/proxy, and Kubernetes network evidence automation |

## Jenkins Job

Use this generated Jenkins job:

```text
projects/run-ansible-playbook
```

Operators select `PROJECT`, `GIT_BRANCH`, `PLAYBOOK`,
`INVENTORY_SOURCE_PATH`, `EXTRA_VARS`, `CONFIRM_APPLY`,
`AWX_SCM_CREDENTIAL_ID`, `AWX_MACHINE_CREDENTIAL_ID`, `AWX_URL`, and
`TIMEOUT_MINUTES`.

The Jenkins seed job must read `jenkins-jobs` from:

```text
ssh://git@gitlab.example.com:2222/midhhealth/platform-delivery/jenkins-jobs.git
```

The shared library also expects active Ansible project repositories under the
MidhHealth domain subgroups, such as `platform-engineering`,
`reliability-operations`, and `data-and-integration`.

## Safety Controls

- The shared library enforces a project playbook allowlist.
- The shared library enforces a project extra-vars allowlist.
- `playbooks/site.yml` requires `CONFIRM_APPLY=true`.
- Assessment-only playbooks should run before `site.yml`.
- AWX stores SCM and machine credentials; Jenkins passes only numeric AWX
  credential IDs.
- GitLab SSH host-key trust for `gitlab.example.com:2222` must be configured
  in AWX before project syncs.

## Linux Systems Smoke Test

Use this first:

```text
PROJECT=linux-systems-platform
GIT_BRANCH=main
PLAYBOOK=playbooks/preflight.yml
INVENTORY_SOURCE_PATH=inventories/production/hosts.yml
EXTRA_VARS=
CONFIRM_APPLY=false
```

After preflight succeeds, run assessment playbooks such as
`playbooks/compliance-evidence.yml`, `playbooks/drift-detection.yml`, and
`playbooks/patch-assessment.yml`.

Run `playbooks/site.yml` only after reviewing assessment output and selecting
`CONFIRM_APPLY`.

## Specialist Domain Smoke Tests

Use the same job with `GIT_BRANCH=main`,
`INVENTORY_SOURCE_PATH=inventories/production/hosts.yml`, and
`CONFIRM_APPLY=false`.

| Project | First playbook |
| --- | --- |
| `database-reliability-platform` | `playbooks/preflight.yml` |
| `resilience-service-operations` | `playbooks/preflight.yml` |
| `data-engineering-platform` | `playbooks/preflight.yml` |
| `network-engineering-platform` | `playbooks/preflight.yml` |

Focused evidence playbooks may be run after preflight. The shared library
rejects playbooks that are not approved for the selected project.

## GitLab CI Gate

The specialist platform repositories validate playbooks in GitLab CI with
`structure`, `ansible_syntax`, and `ansible_lint`. Jenkins/AWX execution is the
operational smoke and runtime gate. GitLab CI does not connect to production
VMs.

## Cloud Infrastructure DNS Workflow

The lab DNS configuration now uses these AWX objects:

| Object | ID | Name |
| --- | ---: | --- |
| Project | 23 | `cloud-infra-automation-platform` |
| Product inventory | 2 | `production` |
| Product inventory project | 9 | `awx-inventory` |
| Product inventory source | 10 | `production-inventory` |
| Foundation inventory | 4 | `cloud-infra-production` |
| Foundation inventory source | 24 | `cloud-infra-onprem` |
| Job template | 25 | `deploy-lab-dns` |
| Job template | 26 | `deploy-nginx-reverse-proxy` |

The project synchronizes
`ssh://git@gitlab.example.com:2222/midhhealth/platform-engineering/cloud-infra-automation-platform.git`
with the existing GitLab SCM credential. Foundation inventory source 24
imports `ansible/inventory/foundation.yml` and contains only infra01, infra02,
and infra03. The dedicated `awx-inventory` repository supplies the canonical
product groups in inventory 2. Templates use inventory 2 and the existing
managed-host machine credential. The DNS template runs only
`ansible/playbooks/dns.yml`. Product-local NGINX and edge-retirement playbooks
must use an explicit reviewed inventory; no template may target a shared proxy
as a general application frontend.

Before launching the template:

1. require the cloud GitLab pipeline to pass;
2. confirm project and inventory synchronization are successful;
3. confirm the inventory contains `dns_servers`;
4. require the job output to show one processed DNS host; a green job that
   says `no hosts matched` is a failed acceptance;
5. launch `deploy-lab-dns`;
6. run it a second time and require zero changes;
7. validate authoritative DNS, a normal client, Kubernetes CoreDNS, and the
   application HTTP response.

The AWX SCM deploy key must be enabled read-only for this project. A successful
host-key handshake followed by “project could not be found” indicates missing
repository authorization, not missing SSH trust. The repository root must
contain `ansible.cfg` with `roles_path = ansible/roles`; otherwise AWX cannot
discover nested roles even when CI syntax validation succeeds. See
INC-2026-043 and INC-2026-044.

For the accepted NGINX workflow, project update 416 synchronized revision
`bc8481a`; deployment job 417 activated the validated route catalog; and
idempotency job 421 completed with `changed=0`, `unreachable=0`, and
`failed=0`. See INC-2026-050 for the partial-convergence failure that led to
the immediate post-validation handler flush.

Inventory normalization completed through cloud commit `8f259d0`, inventory
commit `2c8ccfe`, cloud pipeline 346, inventory pipeline 347, and foundation
sync job 425. DNS jobs 433 and 438 and NGINX jobs 443 and 448 then completed
with one expected host, zero changes, and zero failures. See INC-2026-049
through INC-2026-052.

## GitLab Runner Eligibility and Queue Recovery

Use this procedure when GitLab jobs remain pending.

1. Confirm the runner process and token before changing anything:

   ```bash
   sudo docker ps --filter name=gitlab-runner
   sudo docker exec gitlab-runner gitlab-runner verify
   sudo docker logs --since 10m gitlab-runner
   ```

2. Interpret repeated job-request HTTP 204 responses correctly. They show that
   the runner can reach GitLab and GitLab has no job *eligible for that runner*;
   they do not by themselves indicate a stopped scheduler.
3. Check runner scope in GitLab. An untagged project job still cannot use a
   runner assigned to a different project. Verify:

   - runner type is `instance_type` for this shared lab runner;
   - no obsolete rows restrict it through `ci_runner_projects`;
   - `run_untagged` is enabled;
   - job and runner tags match;
   - protected-branch policy permits the job.

4. Keep the lab runner configuration at:

   ```toml
   concurrent = 2

   [[runners]]
     request_concurrency = 2
     executor = "docker"
   ```

5. After a scope change, restart only the runner container, verify its token,
   and watch a job from two different projects receive the runner ID. Do not
   call the incident resolved merely because the container is running.
6. Classify the outcome accurately:

   - pending with no runner ID: continue eligibility/coordinator diagnosis;
   - running or terminal with a runner ID: scheduling is working;
   - `script_failure` or exit 127 after assignment: repair the repository CI
     image or script as a separate defect.

See INC-2026-039 in the
[SRE Incident Register](sre-incident-register.md) for the 2026-07-29 recovery.

## GitLab CI Runtime Contract

Do not rely on the runner's fallback image for project tools. Every repository
must declare:

- a pinned image for Terraform, Checkov, Python, or other required tooling;
- one merged stage graph when local CI files are included;
- pinned Python requirements and Ansible collections;
- explicit `ANSIBLE_CONFIG` and `ANSIBLE_ROLES_PATH` values when the build
  directory permissions can disable automatic configuration discovery;
- manual gates for plans, applies, and smoke tests that require an
  operator-started environment.

Use the job trace to classify failures:

- exit 127 means the declared runtime lacks a command;
- a pipeline with no builds usually indicates merged-configuration or stage
  validation failure;
- Ansible "role not found" with the role checked into the repository usually
  indicates an ignored configuration or incorrect role path;
- Checkov policy failures are security findings and must not be converted to
  soft failures without an explicitly approved risk exception.

The cloud project currently enforces Terraform 1.13.5, Ansible Core 2.21.2,
ansible-lint 26.6.0, and Checkov 3.3.8. See INC-2026-040 and INC-2026-041 in
the [SRE Incident Register](sre-incident-register.md).

Pinned project images use `pull_policy: if-not-present`. The shared runner
must therefore contain:

```toml
[runners.docker]
  pull_policy = "if-not-present"
  allowed_pull_policies = ["always", "if-not-present"]
```

If a job reports `runner_configuration_error` for an invalid pull policy,
fix the runner allowlist and wait for its configuration hot reload before
retrying. If an `always` pull fails while the image is cached, do not delete
the cache; use the approved cached-first policy. See INC-2026-042.

## AAP-Like AWX Execution Boundary

The existing platform architecture and use cases remain authoritative.
`CHG-2026-008` adds only a separated execution plane:

```text
GitLab source and CI
        |
Jenkins approval/orchestration
        |
AWX 24.6.1 control plane on awx.example.com
        |
Receptor mutual TLS to awx-execution.example.com:443
        |
NGINX stream TLS passthrough on the execution VM
        |
Receptor on 127.0.0.1:27199 only
        |
Approved managed hosts and APIs
```

The control plane keeps the UI, API, scheduling, workflow, RBAC, and
credential-use boundary. The execution node runs only dispatched jobs in a
versioned execution environment. Its first instance group is
`lab-infrastructure` and is limited to a read-only canary until rollback,
restore, and idempotence pass.

VM services must not expose backend host ports. They are published by
canonical hostname through NGINX on the service VM. For this execution plane,
only NGINX listens on the network-facing TCP 443 socket. It passes the mutual
TLS stream unchanged to Receptor on `127.0.0.1:27199`. Firewalld must not open
27199, and Receptor must not bind the VM address or `0.0.0.0`.

The AWX-generated install bundle is authoritative for the Receptor version,
certificate authority, node identity, and peer configuration. Record its exact
versions and checksums in the change evidence; never commit generated private
keys. Execution-environment images will later be built in GitLab CI, scanned,
stored in Harbor, and selected in AWX by immutable digest.

The accepted execution VM is available at `192.168.1.121` with Rocky Linux 9.8,
4 vCPU, 8 GiB RAM, 60 GB OS, and 50 GB data storage. SSH, DNS, UTC/NTP,
SELinux, firewalld, and the guest agent pass. The approved bounded profile is
`lab-canary`; it is not a production sizing claim and does not authorize a
resize. NGINX and Receptor are enabled and active. NGINX alone accepts the
hostname edge on TCP 443; Receptor remains on `127.0.0.1:27199`, and firewalld
does not admit that backend port.

The canonical automation repository is
`midhhealth/platform-delivery/ansible-awx`. It pins the AWX-generated bundle,
Receptor 1.4.8, `ansible.receptor` 2.0.3, exact Rocky NGINX/stream-module and
Podman packages, and the complete hashed Python runtime closure. AWX instance
3 is enabled, `ready`, has capacity 76, and belongs only to
`lab-infrastructure` after rollback, restore, and idempotence acceptance.

Accepted revision `7b931558` provides these bounded playbooks:

| Playbook | Purpose |
| --- | --- |
| `execution-node-preflight.yml` | Revalidate identity, Rocky 9, and the explicit 8 GiB `lab-canary` profile without mutation |
| `execution-node-install.yml` | Preserve rollback state, validate the injected bundle, and install the loopback Receptor plus NGINX edge |
| `execution-node-validate.yml` | Prove exact versions, certificates, services, listeners, firewall policy, and control-plane reachability |
| `execution-node-canary.yml` | Run a read-only execution-environment identity canary on the bounded instance group |
| `execution-node-remove.yml` | Restore the recorded package, account, SELinux, firewall, and proxy boundary |
| `execution-node-restore.yml` | Reinstall the same reviewed bundle identity after rollback |

Run them in this order: preflight, install, validation, canary, removal,
rollback absence checks, restore, validation, then a second install requiring
zero unexpected changes. Never pass bundle PEM material as source or ordinary
extra variables; use only the dedicated encrypted AWX custom credential whose
base64 injectors are hash-checked by the install playbook.

The accepted sequence used preflight 738, install/validation/canary 741-743,
removal/restore 744-745, post-restore validation/canary 746-747, zero-change
install 748, and final validation 749. Temporary generated bundle material was
overwrite-deleted after acceptance. See the linked evidence for exact source,
controller-object, listener, and incident records.

See
[CHG-2026-008](change-records/CHG-2026-008-awx-execution-plane.md) for the
scope, gates, rollback, and acceptance contract.
