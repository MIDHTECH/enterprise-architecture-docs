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
| Change ID | None |
| Component | None |
| State | Ready for the next sequential change |
| Blocker | None |
| Permitted work | Read-only audit and selection of exactly one next queue item |
| Prohibited work | Starting more than one component or bypassing GitLab/AWX validation |
| Exit criteria | A single next component is recorded here before mutation |

`CHG-2026-001` is complete.

## Completed change

`CHG-2026-001` restored and audited the foundation control plane and closed
the AWX inventory duplication. Cloud commit `8f259d0` passed pipeline 346;
inventory commit `2c8ccfe` passed pipeline 347; source sync job 425 reduced
`cloud-infra-production` to infra01/02/03; and DNS jobs 433/438 plus NGINX
jobs 443/448 each processed one expected host with `changed=0`,
`unreachable=0`, and `failed=0`. INC-2026-049, INC-2026-051, and the
INC-2026-052 near miss are resolved.

## Activity audit

The 2026-07-29 audit found:

| Area | Evidence | Classification |
| --- | --- | --- |
| infra01 and guests | Host recovered after a full reboot; bridge and 17/17 domains are up with expected IPv4 addresses. STP is disabled; one controlled canary reboot passed. | Monitoring under INC-2026-046 |
| GitLab | Backend redirects normally; `gitlab.apps.example.com` proxies to the sign-in route; no visible CI workload process | Recovered; INC-2026-047 resolved |
| Jenkins | Service active on port 8080; backend and `jenkins.apps.example.com` sign-in pages return HTTP 200; no visible executor workload | Healthy and idle |
| AWX | API and `awx.apps.example.com` return HTTP 200; AWX 24.6.1 control heartbeat is current with capacity 30; no visible Ansible Runner workload | Healthy and idle |
| Application Kubernetes | Explicit context `kubernetes-admin@kubernetes`; server 1.34.10; control plane plus three workers Ready; no non-running pods or active Jobs | Healthy and idle |
| NGINX routes | The catalog advertises 13 active routes and five intentional unavailable routes. All active routes returned expected non-5xx UI, redirect, authentication, or API responses; Vault health is HTTP 200 and unsealed. | Healthy; jobs 417 and 421 accepted |
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
| GitLab/AWX/Jenkins | Recovered with infra01; GitLab pipelines and bounded AWX jobs were audited, and Jenkins remained healthy and idle | Audit complete |

Older documentation clones contain Harbor, Vault, and Keycloak installation
artifacts. Those files are preserved but are not canonical until live state,
secrets handling, rollback, validation, and Git history are reviewed. The
canonical cloud and AWX inventory repositories are published and clean after
the inventory-normalization change.

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
