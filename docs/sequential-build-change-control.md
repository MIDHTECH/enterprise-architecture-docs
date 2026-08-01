# Sequential Build and Change Control

Last verified: 2026-08-01

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
| State | `CHG-2026-003` is complete. Jenkins persists `http://jenkins.example.com/` as its root URL; authenticated `/manage/` returns HTTP 200 without the empty-URL warning; Jenkins and NGINX are active; `jenkins-agent01` is online and idle with one executor; focused job 604 converged at `changed=0 failed=0 unreachable=0`. The observed controlled restart interruption was 15 seconds. No incident or rollback occurred. |
| Blocker | None for the completed Jenkins root-URL correction. The next change must receive a new single active record before mutation. |
| Permitted work | Read-only audits, or selecting exactly one next queue item and recording it here before mutation. |
| Prohibited work | Starting another infrastructure component before it becomes the single active change, or treating this correction as approval for swap, monitor, or ingress changes. |
| Exit criteria | Not applicable while no change is active. |

`CHG-2026-001`, `CHG-2026-002`, and `CHG-2026-003` are complete.

The authenticated post-acceptance screenshots explicitly reorder the Jenkins
root-URL defect ahead of ingress as `CHG-2026-003`. The node page also reports
zero free swap on both nodes. Live memory validation shows no pressure and no
configured swap, so swap policy is not inferred from a Jenkins monitor color
and remains outside this focused correction.

The ingress queue item exposed an unmet delivery prerequisite:
`jenkins-agent01` was only provisioned. The queue is therefore explicitly
reordered to complete row 5 before row 6. GitLab CI remains the source
validation gate. Jenkins owns deployment orchestration and approval. Helm owns
Kubernetes releases. AWX and Ansible own only VM, operating-system, firewall,
container-runtime, and Kubernetes-cluster configuration.

After the agent acceptance was published, the user explicitly reordered the
same Jenkins component once more: canonical Jenkins access on port 80 must be
accepted before ingress work. The bounded correction keeps Jenkins on its
existing port-8080 backend, adds an NGINX frontend only on the Jenkins VM,
updates the inbound agent to `http://jenkins.example.com`, and removes the
legacy `jenkins.apps.example.com` DNS record only after runtime acceptance.
This is not authorization to modify another product or start ingress.

Accepted source evidence: ingress correction pipeline 354, Jenkins shared
library pipeline 351, Jenkins Job DSL pipeline 352, Jenkins agent correction
pipeline 360, and agent DNS source pipeline 358 passed. Pipeline 360 explicitly
skipped the protected controller deployment job. No ingress or agent runtime
change has started. Documentation pipeline 367 passed the first detailed
use-case record, its seven Jira stories, and the new documentation-contract
validator for commit `ca129e5a`; this does not change the runtime state.
Cloud branch pipeline 372 passed the AWX local-proxy source, including
production-profile Ansible lint. Canonical-main pipeline 374 passed for commit
`5a7a6ade` after transient job 964 was retried as job 973; INC-2026-059 records
the external Alpine repository failure. The AWX API at
`127.0.0.1:32000/api/v2/ping/` returned version 24.6.1 before deployment.
The direct-URL feature branch pipeline 378 passed all automatic gates for
commit `e8873211` after the CI bootstrap correction in INC-2026-061.
INC-2026-060 records the earlier no-change DNS job 461 failure and the
installed-package-aware correction. Canonical-main pipeline 380 passed all
automatic gates; manual Terraform, bootstrap, smoke-test, and apply jobs were
not launched because they are outside the AWX-only change.
AWX project sync 483 exposed a stale temporary SCM branch; INC-2026-062 records
the correction to `main` and successful sync 484 at `e8873211`. Local-proxy
jobs 485 and 492 succeeded on only `awx.example.com`; the second run reported
`ok=16 changed=0 unreachable=0 failed=0`. DNS template 25 now has the explicit
`dns.example.com` limit; jobs 502 and 514 both reported
`ok=13 changed=0 unreachable=0 failed=0`. Authoritative queries return
`awx.example.com -> 192.168.1.103`, no answer for the retired
`awx.apps.example.com`, and preserve `gitlab.apps.example.com ->
192.168.1.114`. The portless authenticated AWX dashboard is accepted.

The agent inventory correction `827a529` passed branch pipeline 382 job 1026
and canonical-main pipeline 383 job 1027. AWX project sync 522 then exposed a
missing read-only deploy-key association; INC-2026-065 records the GitLab API
correction and successful sync 523 at `82adf11`. Inventory update 524 created
exactly one `jenkins_agents` host at `192.168.1.138`. First deployment job 527
installed the runtime but failed its Helm version check because the AWX process
PATH omitted `/usr/local/bin`; INC-2026-066 records correction `a2544ec`.
Branch pipeline 384 and main pipeline 385 passed, while protected controller
deployment job 1032 remained manual. AWX sync 532 selected `a2544ec`; jobs 536
and 541 both completed with `ok=17 changed=0 unreachable=0 failed=0`. Jenkins
acceptance build 1 ran on `jenkins-agent01`, recorded Helm 4.1.0, kubectl
1.34.10, Java 21.0.12, Git 2.52.0, and canonical DNS, then the temporary job
was removed. The preserved evidence is in
[Jenkins Agent Acceptance](evidence/CHG-2026-002-jenkins-agent-acceptance.md).

## Completed change

`CHG-2026-003` set the canonical Jenkins root URL through focused JCasC
reconciliation. Automation commit `44bd7e9` passed pipelines 404/407; AWX
update 598 selected that revision; job 599 applied the block and performed one
15-second restart; job 604 reported `changed=0`. The authenticated management
warning is absent and the accepted agent remains online. The zero-swap monitor
observation was documented without changing OS capacity policy. See the
[ServiceNow-style change record](change-records/CHG-2026-003-jenkins-root-url.md).

`CHG-2026-002` accepted the dedicated Jenkins agent and canonical portless
controller path. Jenkins proxy/agent jobs 561/571, DNS job 582, and shared
route cleanup job 593 each converged with zero changes. Canonical HTTP,
authenticated node state, authoritative DNS, CoreDNS, firewalld, service
state, and legacy route absence passed. INC-2026-065 through INC-2026-067 are
resolved. See
[Jenkins Agent Acceptance](evidence/CHG-2026-002-jenkins-agent-acceptance.md)
and
[Jenkins Portless Acceptance](evidence/CHG-2026-002-jenkins-portless-acceptance.md).

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
| Jenkins | Jenkins backend remains active on port 8080 behind controller-local NGINX; canonical `http://jenkins.example.com` returns HTTP 200 on port 80; `jenkins-agent01` is online through that URL; the legacy `.apps` DNS and shared route are absent | Accepted and idle |
| AWX | API and `awx.apps.example.com` return HTTP 200; AWX 24.6.1 control heartbeat is current with capacity 30; no visible Ansible Runner workload | Healthy and idle |
| Application Kubernetes | Explicit context `kubernetes-admin@kubernetes`; server 1.34.10; control plane plus three workers Ready; no non-running pods or active Jobs | Healthy and idle |
| NGINX routes | The catalog advertises 13 active routes and five intentional unavailable routes. All active routes returned expected non-5xx UI, redirect, authentication, or API responses; Vault health is HTTP 200 and unsealed. | Healthy; jobs 417 and 421 accepted |
| infra02 | 14/14 VMs running; no Ansible, Terraform, VM-build, or package-change process except routine `dnf makecache` on Logstash | Stable |
| infra03 | Host stable; three recently provisioned VMs running with autostart | Unreconciled completed provisioning |
| `gitlab-runner-app01` | `.136`, Rocky VM running; no GitLab Runner service or process | Provisioned only |
| `gitlab-runner-infra01` | `.137`, Rocky VM running; no GitLab Runner service or process | Provisioned only |
| `jenkins-agent01` | `.138`, Rocky 9.8; WebSocket agent service enabled/active; Helm 4.1.0, kubectl 1.34.10, Java 21, and Git 2.52.0; Jenkins online with one exclusive executor | Accepted; jobs 536/541 clean |
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
| 5 | Review `jenkins-agent01`, then correct canonical Jenkins port-80 access | Completed 2026-08-01; agent and portless URL accepted, Jenkins `.apps` DNS and shared route retired |
| 6 | Deploy and accept the single-replica Kubernetes ingress tier | Agent accepted; documentation pipeline published; kubeconfig secret-file credential and non-mutating PLAN complete |
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
