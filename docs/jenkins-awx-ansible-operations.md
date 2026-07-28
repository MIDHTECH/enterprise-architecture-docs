# Jenkins AWX Ansible Operations

## Purpose

This runbook records the program-level workflow for launching approved Ansible
automation through Jenkins and AWX. Active consumers are Projects 6–10:
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

## Projects 7-10 Smoke Tests

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

Projects 6–10 validate playbooks in GitLab CI with `structure`,
`ansible_syntax`, and `ansible_lint`. Jenkins/AWX execution is the operational
smoke and runtime gate. GitLab CI does not connect to production VMs.
