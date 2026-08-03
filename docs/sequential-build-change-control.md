# Sequential Build and Change Control

Last verified: 2026-08-02

## Operating rule

Only one infrastructure component may be changed at a time. All implementation
must remain in one active Codex task until that component is validated,
documented, committed, and published. Separate sessions must not provision,
configure, migrate, or upgrade other components in parallel.

Read-only inspection is allowed while a change is blocked. A direct manual
installation is not an acceptable workaround for an unavailable GitLab,
Jenkins, or AWX control plane.

Never expose a VM service by publishing its backend host port. Install NGINX
on the service VM and expose the service by its canonical hostname. Backend
listeners must remain loopback-only or otherwise private to the approved proxy
boundary; firewalld must admit only the documented NGINX frontend.

## Active change

| Field | Current value |
| --- | --- |
| Change ID | `CHG-2026-009` |
| Component | Single-replica Kubernetes ingress tier: Jenkins delivery objects, `platform-ingress` Helm release, and only its documented cluster prerequisites |
| State | Active at the pre-deployment Jenkins prerequisite gate; no ingress runtime resources have been created. |
| Blocker | Live audit found the generated `projects/deploy-kubernetes-ingress` job and secret-file credential `kubernetes-production-kubeconfig` absent. Six reviewed Job DSL scripts await Jenkins approval, so the documented PLAN has not run. |
| Permitted work | Publish this gate, approve only the exact reviewed Job DSL at accepted source revisions, reconcile the seed job, create the scoped secret-file credential without exposing kubeconfig content, run PLAN, then perform the reviewed DEPLOY/rollback/restore/idempotence sequence through Jenkins and Helm. |
| Prohibited work | Direct Helm or `kubectl apply` from a workstation, AWX, or Ansible; Jenkins-controller execution; storage or another product change; direct LAN exposure of NodePorts 30081/30444; removal of Headlamp NodePort 30080. |
| Exit criteria | Exact source and PLAN accepted; release and one replica healthy; ingress class, restricted NodePorts, and Headlamp host route validated; explicit Helm rollback and restore proven; second convergence clean; incidents, evidence, source, and documentation published. |

`CHG-2026-001` through `CHG-2026-008` are complete.

On 2026-08-03 the user directed the documented queue to continue with the
single-replica Kubernetes ingress tier. The required read-only audit found
GitLab with zero active pipelines, AWX with zero active jobs, Jenkins healthy
with an empty queue, infra01/02/03 at 17/14/4 running VMs with no conflicting
mutator, and the application cluster at Kubernetes 1.34.10 with all four nodes
Ready, zero active Jobs, zero non-running pods, and no IngressClass, Ingress,
or `ingress-nginx` namespace.

Canonical source revisions and pipelines are accepted: `ansible-kubernetes`
`e34bd54` in pipeline 354, `jenkins-jobs` `950cc4f` in pipeline 352, and
`jenkins-shared-library` `b23d3a4` in pipeline 351. Live Jenkins state differs
from the earlier queue entry: the seed checked out `950cc4f` but stopped at
the script-approval gate, the generated ingress job is absent, and credential
`kubernetes-production-kubeconfig` is absent. INC-2026-075 records the drift.
No PLAN or cluster mutation occurred. CHG-2026-009 therefore starts at the
Jenkins prerequisite gate and does not authorize a control-plane bypass.

On 2026-08-02 the user directed work to begin on the already documented
AAP-like AWX goal. `CHG-2026-008` therefore reordered only the AWX execution
plane ahead of Kubernetes ingress. The existing architecture and use cases
were not recreated. Readiness checks found AWX healthy and idle,
`awx-execution.example.com` running at `192.168.1.121`, Harbor healthy, and no
conflicting activity on infra01/02/03. The canonical private `ansible-awx`
project is now published; source pipelines 480 through 483 passed and merge
request !2 produced main revision `0741093f`. Controlled-runtime merge request
!3 passed branch pipeline 487 and main pipeline 488 at revision `6d7887fa`.
The approved
capacity decision is an explicitly non-production 8 GiB `lab-canary` with no
resize. AWX instance 2 was deprovisioned before use; replacement instance 3
records only `awx-execution.example.com:443`. Runtime onboarding passed the
publication, exact-revision reconciliation, activity audit, install,
validation, canary, rollback, restore, and idempotence gates.

The execution-plane exposure boundary is NGINX stream TLS passthrough on TCP
443, addressed only as `awx-execution.example.com`. Receptor binds only
`127.0.0.1:27199`; that backend port is not opened in firewalld and is not an
AWX topology address.

The user approved three dedicated GitLab runners on infra03 for the
twelve-domain platform program and explicitly rejected CI execution on the
GitLab VM as the steady state. The sequential target topology is
`gitlab-runner-infra01.example.com` (`.137`),
`gitlab-runner-app01.example.com` (`.136`), and
`gitlab-runner-shared01.example.com` (`.139`). The shared runner follows the
same scope-based naming convention and owns shared validation/security work.
All three dedicated runners are accepted. Legacy runner ID 2 on the GitLab VM
is paused and its container is retired, so CI execution no longer competes
with the GitLab application. `jenkins-agent01.example.com` at `.138` remains
the dedicated Jenkins executor and is not a GitLab runner.

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

`CHG-2026-008` accepted AWX instance 3 on
`awx-execution.example.com` as the bounded `lab-infrastructure` execution
plane. Canonical revision `7b931558` passed main pipeline 500 and AWX project
update 740. Install/validation/canary jobs 741-743 passed; removal 744 and
restore 745 proved rollback; post-restore validation/canary 746-747 passed;
install 748 reported zero changes; and final validation 749 passed. The node is
Ready at capacity 76. NGINX alone exposes hostname TCP 443, while Receptor is
loopback-only on 27199 with no backend firewall opening. See the
[change record](change-records/CHG-2026-008-awx-execution-plane.md) and
[acceptance evidence](evidence/CHG-2026-008-awx-execution-plane-acceptance.md).

`CHG-2026-007` retired legacy GitLab runner ID 2 from the GitLab VM. Source
commit `244e418` passed pipelines 455/456; AWX retire job 713 paused the exact
identity and removed only its container; restore job 717 proved rollback with
the same ID and pinned Runner 19.2.0 image; final retirement 721 succeeded; and
job 725 reported zero changes or failures. The three dedicated infra03 runners
remain active and GitLab remains HTTP 200. See the
[change record](change-records/CHG-2026-007-retire-gitlab-vm-runner.md) and
[acceptance evidence](evidence/CHG-2026-007-gitlab-vm-runner-retirement-acceptance.md).

`CHG-2026-006` accepted `gitlab-runner-shared01.example.com` on infra03 as
instance runner ID 5 with exact `shared,validation,security` tags and untagged
execution disabled. Terraform plan/apply jobs 1355/1359 created only the
approved domain and volume; source commit `8fb79ca` passed pipelines 445/446;
canary job 1424 ran on ID 5; rollback 696 and restore 700 passed; and AWX job
704 reported zero changes or failures. INC-2026-069 records the safe
pre-deployment corrections. See the
[change record](change-records/CHG-2026-006-gitlab-runner-shared.md) and
[acceptance evidence](evidence/CHG-2026-006-gitlab-runner-shared-acceptance.md).

`CHG-2026-005` accepted `gitlab-runner-app01.example.com` on infra03 as
instance runner ID 3 with exact `app,docker` tags and untagged execution
disabled. Source commit `712f194` passed pipelines 426/427; canary job 1234 ran
on runner ID 3; rollback job 657 paused the identity and preserved protected
configuration; restore job 661 succeeded; and AWX job 665 reported zero
changes or failures. See the
[change record](change-records/CHG-2026-005-gitlab-runner-app.md) and
[acceptance evidence](evidence/CHG-2026-005-gitlab-runner-app-acceptance.md).

`CHG-2026-004` accepted `gitlab-runner-infra01.example.com` on infra03 as
GitLab runner ID 4. Canonical source commit `281b35e` passed pipelines
420/421; canary job 1171 ran on runner ID 4; rollback job 629 paused the
identity, removed only the container, and preserved configuration; restore job
633 succeeded; and AWX job 645 reported zero changes or failures. INC-2026-068
records the corrected administrator-username assumption. See the
[ServiceNow-style change record](change-records/CHG-2026-004-gitlab-runner-infra.md)
and [acceptance evidence](evidence/CHG-2026-004-gitlab-runner-infra-acceptance.md).

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

The latest accepted state, reconciled on 2026-08-02, is:

| Area | Evidence | Classification |
| --- | --- | --- |
| infra01 and guests | Host recovered after a full reboot; bridge and 17/17 domains are up with expected IPv4 addresses. STP is disabled; one controlled canary reboot passed. | Monitoring under INC-2026-046 |
| GitLab | Backend redirects normally; `gitlab.apps.example.com` proxies to the sign-in route; no visible CI workload process | Recovered; INC-2026-047 resolved |
| Jenkins | Jenkins backend remains active on port 8080 behind controller-local NGINX; canonical `http://jenkins.example.com` returns HTTP 200 on port 80; `jenkins-agent01` is online through that URL; the legacy `.apps` DNS and shared route are absent | Accepted and idle |
| AWX | Canonical `awx.example.com` and API are healthy on AWX 24.6.1; execution instance 3 is Ready at capacity 76 only in `lab-infrastructure`; no active jobs remain | Controller and execution plane accepted and idle |
| Application Kubernetes | Explicit context `kubernetes-admin@kubernetes`; server 1.34.10; control plane plus three workers Ready; no non-running pods or active Jobs | Healthy and idle |
| NGINX routes | The catalog advertises 13 active routes and five intentional unavailable routes. All active routes returned expected non-5xx UI, redirect, authentication, or API responses; Vault health is HTTP 200 and unsealed. | Healthy; jobs 417 and 421 accepted |
| infra02 | 14/14 VMs running; `awx-execution.example.com` is accepted with hostname-only NGINX TCP 443 and loopback Receptor; no conflicting change process remains | Stable |
| infra03 | Host stable; four build-execution VMs running with autostart | Accepted placement |
| `gitlab-runner-app01` | `.136`, runner ID 3, pinned Runner 19.2.0 Docker executor, exact `app,docker` tags, untagged execution disabled | Accepted; canary 1234 and jobs 657/661/665 passed |
| `gitlab-runner-infra01` | `.137`, runner ID 4, pinned Runner 19.2.0 Docker executor, exact `ansible,infra,terraform` tags, untagged execution disabled | Accepted; canary 1171 and jobs 629/633/645 passed |
| `gitlab-runner-shared01` | `.139`, runner ID 5, pinned Runner 19.2.0 Docker executor, exact `security,shared,validation` tags, untagged execution disabled | Accepted; canary 1424 and jobs 696/700/704 passed |
| GitLab-VM runner | Runner ID 2 is paused; its container is absent while protected configuration is preserved for controlled rollback | Retired; jobs 713/717/721/725 passed |
| `jenkins-agent01` | `.138`, Rocky 9.8; WebSocket agent service enabled/active; Helm 4.1.0, kubectl 1.34.10, Java 21, and Git 2.52.0; Jenkins online with one exclusive executor | Accepted; jobs 536/541 clean |
| Harbor | `.122`; Docker and all Harbor, registry, database, Redis, portal, job-service, and Trivy containers healthy; HTTPS 200 | Installed but canonical documentation is stale |
| Artifactory | `.123`; no product service detected | Provisioned only |
| SonarQube | `.124`; no product service detected | Provisioned only |
| PostgreSQL | `.125`; PostgreSQL 18 service active | Installed |
| Workstation activity | No running Git publication, SSH administration, Ansible, Terraform, kubectl, libvirt, or image-build process | No conflicting active process |
| GitLab/AWX/Jenkins | GitLab main pipeline 500 passed; AWX jobs 741-749 completed the bounded execution-plane acceptance; Jenkins remained healthy and idle | Audit and CHG-2026-008 complete |

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
| 3 | Review and either complete or retire `gitlab-runner-infra01` | Completed 2026-08-01 through `CHG-2026-004` |
| 4 | Review and either complete or retire `gitlab-runner-app01` | Completed 2026-08-01 through `CHG-2026-005` |
| 5 | Provision, configure, and accept `gitlab-runner-shared01` on infra03 | Completed 2026-08-01 through `CHG-2026-006` |
| 6 | Retire the GitLab-VM runner from CI execution | Completed 2026-08-01 through `CHG-2026-007` |
| 7 | Review `jenkins-agent01`, correct canonical port-80 access, and set the Jenkins root URL | Completed 2026-08-01 through `CHG-2026-003`; agent, portless URL, root URL, DNS, and route cleanup accepted |
| 8 | Establish and accept `awx-execution.example.com` as the bounded AWX execution plane | Completed 2026-08-02 through `CHG-2026-008`; hostname-only NGINX, canary, rollback/restore, and zero-change convergence accepted |
| 9 | Deploy and accept the single-replica Kubernetes ingress tier | Active as `CHG-2026-009`; source pipelines 351/352/354 passed, but live Jenkins job/credential reconciliation and PLAN remain gated |
| 10 | Deploy and accept Kubernetes persistent storage | Ingress change closed and rollback verified |
| 11 | Install Artifactory | Platform storage and backup prerequisites accepted |
| 12 | Install SonarQube | Artifactory change closed |
| 13 | Continue remaining product and use-case queue | Previous component fully accepted |

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
