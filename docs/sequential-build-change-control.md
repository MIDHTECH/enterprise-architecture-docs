# Sequential Build and Change Control

Last verified: 2026-07-29

## Operating rule

Only one infrastructure component may be changed at a time. All implementation
must remain in one active Codex task until that component is validated,
documented, committed, and published. Separate sessions must not provision,
configure, migrate, or upgrade other components in parallel.

Read-only inspection is allowed while a change is blocked. A direct manual
installation is not an acceptable workaround for an unavailable GitLab,
Jenkins, or AWX control plane.

## Active change

| Field | Current value |
| --- | --- |
| Change ID | `CHG-2026-001` |
| Component | Foundation recovery and complete activity audit |
| State | Blocked |
| Blocker | infra01 and every infra01-hosted control service are absent from the LAN |
| Permitted work | Read-only inspection, incident evidence, console diagnostics, and documentation |
| Prohibited work | New product installation, AWX launch, Kubernetes mutation, VM provisioning, migration, or upgrade |
| Exit criteria | infra01, GitLab, Jenkins, AWX, DNS, NGINX, and the application Kubernetes API are reachable; active jobs are audited; source-of-truth drift is reconciled |

Do not advance the queue until `CHG-2026-001` is complete.

## Activity audit

The 2026-07-29 audit found:

| Area | Evidence | Classification |
| --- | --- | --- |
| infra01 and guests | SSH and service ports unavailable; Mac ARP incomplete; infra02 neighbor state `FAILED` | Active blocker |
| infra02 | 14/14 VMs running; no Ansible, Terraform, VM-build, or package-change process except routine `dnf makecache` on Logstash | Stable |
| infra03 | Host stable; three recently provisioned VMs running with autostart | Unreconciled completed provisioning |
| `gitlab-runner-app01` | `.136`, Rocky VM running; no GitLab Runner service or process | Provisioned only |
| `gitlab-runner-infra01` | `.137`, Rocky VM running; no GitLab Runner service or process | Provisioned only |
| `jenkins-agent01` | `.138`, Rocky VM running; no Jenkins agent service or process | Provisioned only |
| Harbor | `.122`; Docker and all Harbor, registry, database, Redis, portal, job-service, and Trivy containers healthy; HTTPS 200 | Installed but canonical documentation is stale |
| Artifactory | `.123`; no product service detected | Provisioned only |
| SonarQube | `.124`; no product service detected | Provisioned only |
| PostgreSQL | `.125`; PostgreSQL 18 service active | Installed |
| Workstation activity | No running Git publication, SSH administration, Ansible, Terraform, kubectl, libvirt, or image-build process | No conflicting active process |
| GitLab/AWX/Jenkins | Unreachable with infra01; pipeline and job audit cannot complete | Audit blocked |

An older documentation clone contains uncommitted Harbor, Vault, and Keycloak
installation artifacts. Those files are preserved but are not canonical until
live state, secrets handling, rollback, validation, and Git history are
reviewed. The `awx-inventory`, Kubernetes ingress, and incident-documentation
repositories each have one local unpushed commit.

## Build queue

| Order | Change | Entry condition |
| ---: | --- | --- |
| 1 | Restore infra01 management connectivity and finish control-plane activity audit | Physical console and bridge evidence available |
| 2 | Reconcile live products and all pending source-of-truth changes | GitLab, AWX, Jenkins, DNS, NGINX, Vault, Keycloak, and Harbor inspected |
| 3 | Review and either complete or retire `gitlab-runner-infra01` | VM placement, `.137` addressing, runner scope, and rollback approved |
| 4 | Review and either complete or retire `gitlab-runner-app01` | Infrastructure runner change closed |
| 5 | Review and either complete or retire `jenkins-agent01` | GitLab runner changes closed |
| 6 | Deploy and accept the single-replica Kubernetes ingress tier | Build-execution drift reconciled; Kubernetes CI and AWX healthy |
| 7 | Deploy and accept Kubernetes persistent storage | Ingress change closed and rollback verified |
| 8 | Install Artifactory | Platform storage and backup prerequisites accepted |
| 9 | Install SonarQube | Artifactory change closed |
| 10 | Continue remaining product and use-case queue | Previous component fully accepted |

The queue may be reordered only through an explicit documented decision. Do
not use multiple tasks to work on different rows simultaneously.

## Change completion gate

A component is complete only when all of the following are true:

1. desired architecture and exact version are documented;
2. source code is committed and its validation pipeline passes;
3. deployment runs through the approved control plane;
4. a second convergence reports zero unexpected changes;
5. service health, consumer access, logs, metrics, and rollback are validated;
6. every encountered incident is recorded;
7. current-state, installation, and operations documentation is updated;
8. all related repositories are clean and synchronized with GitLab;
9. the active-change row is closed before the next queue item starts.

