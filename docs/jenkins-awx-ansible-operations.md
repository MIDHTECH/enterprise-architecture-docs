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
