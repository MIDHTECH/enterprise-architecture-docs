# Jenkins AWX Ansible Operations

## Purpose

This runbook records the program-level workflow for launching approved Ansible
automation through Jenkins and AWX. The first active consumer is
`linux-systems-platform`.

## Source Repositories

| Repository | Responsibility |
| --- | --- |
| `jenkins-jobs` | Defines the generated Jenkins job `projects/run-ansible-playbook` |
| `jenkins-shared-library` | Provides `ansibleAwxPipeline` and shared AWX reconciliation/launch logic |
| `linux-systems-platform` | Provides Linux inventory, playbooks, roles, runbooks, and GitLab CI validation |

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
ssh://git@gitlab.example.com:2222/maas-enterprise-cloud-platform/jenkins-jobs.git
```

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

## GitLab CI Gate

`linux-systems-platform` validates playbooks in GitLab CI with `structure`,
`ansible_syntax`, and `ansible_lint`. Jenkins/AWX execution is the operational
smoke and runtime gate. GitLab CI does not connect to production VMs.
