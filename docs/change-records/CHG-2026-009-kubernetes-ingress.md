# CHG-2026-009: Deploy the Kubernetes Ingress Tier

## Change record

| ServiceNow field | Value |
| --- | --- |
| Number | `CHG-2026-009` |
| Type | Normal |
| State | Corrected PLAN accepted; AWX credential-use gate |
| Risk | Moderate |
| Impact | Low |
| Priority | High |
| Configuration item | Jenkins ingress delivery objects and `platform-ingress` in application Kubernetes |
| Service | Kubernetes application delivery |
| Assignment group | Platform Engineering |
| Requested by | MIDHTECHLAB operator |
| Requested date | 2026-08-03 |
| Expected outage | None; Headlamp NodePort 30080 remains the rollback path |

## Decision and delivery boundary

Deploy the already reviewed single-replica ingress-nginx tier through the
existing production-like path:

```text
GitLab source and CI
        |
Jenkins job on jenkins-agent01.example.com
        |
Helm 4.1.0 with secret-file kubeconfig
        |
application Kubernetes cluster
```

Jenkins owns Helm planning, deployment, rollback, and evidence. AWX and
Ansible may configure only the documented operating-system and firewalld
prerequisites. They must not install the Helm release or run `kubectl apply`.

The permanent VM exposure rule remains in force. NGINX is installed on the
Kubernetes edge node `k8s-worker01.example.com` and is the only LAN listener,
on standard HTTP port 80. DNS publishes `headlamp.example.com` directly to
`192.168.1.108`. NGINX proxies privately to the ingress-nginx ClusterIP service
through cluster DNS. The ingress controller must not publish a NodePort,
hostPort, or backend port on any cluster VM.

The earlier shared-edge design was rejected before deployment on 2026-08-03.
`nginx.example.com`, `headlamp.apps.example.com`, and NodePorts 30081/30444 are
not part of the corrected target architecture. INC-2026-078 records the design
defect and the required source reset.

The first corrected branch pipelines 522-524 then remained pending with no
runner assigned. Kubernetes and Jenkins-library jobs still assumed untagged
execution even though the accepted dedicated runners intentionally disable it.
The cloud branch was also ten commits behind current main, which already
contained canonical `infra` routing. Corrective revisions `8b169e0`
(`ansible-kubernetes`) and `37027a3` (`jenkins-shared-library`) use the
accepted instance runner's `validation` tag. Cloud revision `e98e793`
incorporates current main and retains its single canonical `infra` default.
Replacement work is routed to `gitlab-runner-shared01.example.com` and
`gitlab-runner-infra01.example.com`. INC-2026-079 records the safe CI-only
failure and is resolved by the accepted main pipelines. No manual job or
runtime deployment was launched.

The final control-path review found that AWX had only the original Kubernetes
preflight/install templates. Kubernetes project 13 still referenced the old
`cloud-team` source at revision `cc466bc`, while cloud project 23 was at
revision `244e418`; neither matched the corrected deployment source. The
source-managed correction adds Jenkins job
`projects/configure-headlamp-edge`. Each confirmed build reconciles the exact
application project, inventory project/source, and one bounded job template,
waits for synchronization, launches it through AWX, and waits for completion.
The five allowed actions are `PUBLISH_DNS`, `INSTALL_EDGE`, `FINALIZE_DNS`,
`REMOVE_SHARED_PROXY`, and `CUTOVER_HEADLAMP`. Jenkins reaches AWX only at
`http://awx.example.com` through the product-local NGINX frontend; direct
backend port 32000 is not a pipeline parameter default.

The first jobs-as-code replacement pipeline was correctly routed but failed
because the minimal Rocky CI image does not contain `find`. Revision
`2ef21f0` replaced that dependency with a Bash glob. Branch pipeline 545 and
main pipeline 546 passed. INC-2026-080 records this safe CI portability
failure; no Jenkins or runtime object changed during the failed pipeline.

Runtime control validation then exposed two further safe prerequisite gates.
The generated Headlamp job initially used `agent any`, while the controller
has zero executors and `jenkins-agent01` is `EXCLUSIVE` to
`kubernetes-deployer`. Merge request !2 corrected the job and added a CI
contract; jobs main `85a83131` passed pipeline 550, and seed builds 50/51
converged. Jenkins PLAN build 3 then passed at exact Kubernetes revision
`d206ab3f` and shared-library revision `e9790766`, rendering only a ClusterIP
controller Service and the `headlamp.example.com` Ingress. INC-2026-081 records
the resolved scheduler prerequisite.

The first `PUBLISH_DNS` attempt synchronized the accepted cloud and inventory
projects and created job template 53, then AWX denied association of machine
credential 1 with HTTP 403. The playbook never launched and DNS did not
change. Read-only inspection found `jenkins-automation` has Default
organization admin through role 1, but `Managed Hosts SSH` credential 1 has
no organization, so the organization role cannot grant credential use.
INC-2026-082 remains open at this RBAC gate; direct DNS or NGINX changes are
not authorized.

## Accepted corrected source

| Repository | Revision | GitLab pipeline | State |
| --- | --- | ---: | --- |
| `midhhealth/platform-engineering/ansible-kubernetes` | `d206ab3f5696455e0c5d816eef9bb420ed2b3cd2` | 530 | Passed |
| `midhhealth/platform-engineering/cloud-infra-automation-platform` | `ffb11dc3eb218509b6647a5a68d09bedb25e3445` | 543 | Passed |
| `midhhealth/platform-delivery/jenkins-shared-library` | `e9790766ef56559230ba46370f99565c620fd1b8` | 542 | Passed |
| `midhhealth/platform-delivery/jenkins-jobs` | `85a83131a25297542a01107be083b99f725f918d` | 550 | Passed |

The original accepted revisions `e34bd547`, `950cc4f`, and `b23d3a4`, plus
PLAN build 2, remain audit evidence but are superseded for deployment. A new
PLAN from the table above is required. The corrected chart retains
ingress-nginx 4.15.0 and controller
1.15.1 by digest, uses one controller replica and a ClusterIP-only Service, and
manages Headlamp with ingress class `nginx` and host
`headlamp.example.com`.

## Pre-change audit

- GitLab reports zero active pipelines; the admin job view shows no pending or
  running execution.
- AWX reports zero active jobs. Execution instance 3 remains Ready at capacity
  76.
- Jenkins returns HTTP 200, its queue file is empty, no deployment mutator is
  visible, and no build file changed in the preceding 30 minutes.
- infra01/02/03 report 17/14/4 running VMs and no Ansible, Terraform, image,
  package, Kubernetes, or Helm mutator.
- The explicit `kubernetes-admin@kubernetes` context reports server 1.34.10,
  all four expected nodes Ready, zero active Jobs, and zero non-running pods.
- No IngressClass, Ingress, or `ingress-nginx` namespace exists.

## Corrected prerequisite state

The prior queue entry said the secret-file credential and PLAN were complete.
The live audit proved otherwise:

- `projects/deploy-kubernetes-ingress` is absent;
- `kubernetes-production-kubeconfig` is absent from Jenkins credentials;
- the enterprise seed job checked out exact jobs revision `950cc4f` but build
  43 stopped before generation because reviewed Job DSL scripts await approval;
- no PLAN or deployment reached the cluster.

This discrepancy is INC-2026-075. It is a safe prerequisite failure, not
authorization to create a freestyle workaround or edit Jenkins files directly.

On 2026-08-03, the operator approved exactly the four pending Job DSL hashes
that matched the current reviewed files. The two older `run-ansible-playbook`
variants remain unapproved. Seed build 44 was then queued but could not start:
the only Jenkins agent is intentionally restricted to label-matched jobs and
the Ansible/JCasC-managed seed had no assigned label. Build 44 was cancelled
before execution. Source revisions `467e000555eac89eb1c6cf6256625d945f431757`
and `c480cd28994f663eb4b1dc40d33af6d78a656522` in
`midhhealth/platform-delivery/ansible-jenkins` merge request !14 add the
existing `kubernetes-deployer` label to the seed, validate that setting, and
target the healthy instance runner with its existing `shared` tag. Pipeline
505 exposed the missing CI tag and did not execute. The correction must pass
CI, review, protected deployment, seed reconciliation, and idempotence before
the credential or PLAN gate can proceed.

Protected production job 1617 at merged main revision `c560f6e7` changed only
the managed JCasC file, then failed when Jenkins rejected `assignedNode` on a
`FreeStyleJob`. Jenkins entered a restart loop before seed reconciliation; no
ingress job, credential, PLAN, or cluster resource was created. INC-2026-076
tracks the service incident. Recovery revision
`b19b64bd1f1571a0627de4edb04ebcdaa927d683` in `ansible-jenkins` merge request
!15 uses the supported `label` DSL. Branch pipeline 511 passed, the merge
completed as `ff98681140b12ca317f7ca75a7fbc6ebca29d23d`, and main pipeline 513
passed. Protected production job 1624 restored Jenkins and completed seed
build 44 successfully on `jenkins-agent01`, generating
`projects/deploy-kubernetes-ingress`. The second protected deployment, job
1625, passed with `ok=34 changed=0 unreachable=0 failed=0`; seed build 45 also
passed on `jenkins-agent01`. Runtime validation found Jenkins active with zero
restarts, HTTP 200, the controller at zero executors, the dedicated agent
online, an empty queue, and exactly the two older scripts still unapproved.
INC-2026-076 is resolved and this change returned to gate 4. The folder-scoped
secret-file credential `kubernetes-production-kubeconfig` was then created;
the mode-0600 workstation and control-plane temporary files were securely
removed and their absence verified. PLAN build 1 used exact source revision
`e34bd5477472a6d21c6a5d1933a0d95b5c3ebc55`, `ACTION=PLAN`,
`CONFIRM_CHANGE=false`, and ran on `jenkins-agent01`. It failed before checkout
because the existing Jenkins `gitlab-scm` SSH key does not have access to
`midhhealth/platform-engineering/ansible-kubernetes`. The Helm stage was
skipped, no kubeconfig content was printed, and all ingress runtime resources
remain absent. GitLab lists the matching `Jenkins SCM read-only` deploy key as
privately accessible but disabled for this project. INC-2026-077 records the
safe prerequisite failure.

GitLab's own idempotent `Projects::EnableDeployKeyService` joined existing
deploy key 2 to project 14 and validation reported `can_push=false`; no new key
or write permission was created. PLAN build 2 then succeeded on
`jenkins-agent01` using the same exact parameters. It checked out `e34bd547`,
reported Helm 4.1.0 and kubectl 1.34.10, reached
`https://k8s-control.example.com:6443`, linted and rendered ingress-nginx chart
4.15.0/controller 1.15.1 with the locked image digest, and completed
`helm upgrade --dry-run=server --hide-secret`. The rendered service has only
NodePorts 30081/30444 and one controller replica. Console inspection found no
kubeconfig certificate, key, or token fields. Independent post-run validation
confirmed context `kubernetes-admin@kubernetes`, all four expected v1.34.10
nodes Ready, zero ingress namespace/class/object, and retained Headlamp
NodePort 30080. INC-2026-075 and INC-2026-077 are resolved.

Firewalld is running on all four nodes and no 30081 or 30444 listener exists.
That absence is now the required target, not a missing prerequisite. The
corrected prerequisite installs product-local NGINX on
`k8s-worker01.example.com`, admits only HTTP 80, and keeps all Kubernetes
backend ports off the LAN. The existing `headlamp.apps.example.com ->
192.168.1.114` record and shared-proxy route remain live only until controlled
cutover; they must be retired after the new path passes acceptance.

## Implementation gates

1. Publish this change record and require documentation CI to pass.
2. Reconfirm the exact three source revisions and zero conflicting activity.
3. Approve only the reviewed pending Job DSL scripts. Apply the source-managed
   seed label through the protected `ansible-jenkins` production job, require
   idempotence, then rerun the enterprise seed and require it to generate the
   exact ingress job on the accepted jobs revision.
4. Create Jenkins secret-file credential
   `kubernetes-production-kubeconfig` from the application-cluster kubeconfig.
   Never print, paste into parameters, commit, or retain a workstation copy of
   its content.
5. Confirm the existing `Jenkins SCM read-only` deploy key is enabled read-only
   for `midhhealth/platform-engineering/ansible-kubernetes`. Do not create a
   second key or grant write access.
6. Run `ACTION=PLAN`, `CONFIRM_CHANGE=false` on
   `jenkins-agent01.example.com`. Require the intended context, four-node set,
   server-side Helm dry run, locked chart, and no secret output.
7. Publish corrected Ansible, Helm, Jenkins-library, Jenkins jobs-as-code,
   DNS, and shared-proxy source. Require CI and review for each exact revision.
   This gate is complete at the revisions in **Accepted corrected source**.
8. Run the enterprise Jenkins seed from jobs revision `85a83131`; require
   `projects/configure-headlamp-edge` to match source and prove a second seed
   run makes no unexpected job-definition change. Complete: builds 50/51.
9. Run a new `ACTION=PLAN`, `CONFIRM_CHANGE=false` from the corrected exact
   revisions. Require a ClusterIP-only service and the
   `headlamp.example.com` Ingress host. Complete: build 3; PLAN build 2 is not
   deployable.
10. Run `PUBLISH_DNS` and then `INSTALL_EDGE` through the source-managed
   `projects/configure-headlamp-edge` Jenkins job. Require AWX to synchronize
   the exact accepted project revisions. This adds
   `headlamp.example.com -> 192.168.1.108` while retaining the legacy record,
   installs NGINX only on `k8s-worker01.example.com`, opens only HTTP 80, and
   never opens a NodePort. Blocked before playbook launch by INC-2026-082 until
   the reviewed AWX credential-use boundary is corrected and validated.
11. Run `ACTION=DEPLOY`, `CONFIRM_CHANGE=true` through Jenkins. Require atomic
   Helm wait and runtime acceptance.
12. Repeat DEPLOY from the same revision and require no unexpected rollout,
   replacement, or value drift.
13. Run an explicit known-good Helm rollback through the same Jenkins job,
   validate the still-retained legacy recovery path, then restore the accepted
   release and validate again.
14. Run `FINALIZE_DNS`, `REMOVE_SHARED_PROXY`, and `CUTOVER_HEADLAMP` through
   `projects/configure-headlamp-edge`. Require the legacy
   `headlamp.apps.example.com` record, shared-proxy route, Headlamp NodePort
   30080, and its firewall admission to be absent.
15. Publish runtime evidence and incidents before closing the active change.

The staged DNS path is deliberate: cloud main revision `ffb11dc3` keeps the existing
legacy record only when `headlamp-dns-publish.yml` explicitly enables the
transition flag. The normal `dns.yml` default is final-state false and removes
that record at cutover. The staged zone uses serial `2026080301`; final removal
advances it to `2026080302`. The shared-proxy role's final state already omits
the Headlamp route, but that role is not reconciled until the new canonical
path passes deployment, rollback, and restore.

Gates 1 through 6 document the superseded implementation and remain useful
audit evidence only. Corrected source gate 7, seed gate 8, and PLAN gate 9 are
complete. No DEPLOY is authorized until the AWX credential-use correction and
staged DNS/local-NGINX prerequisites in gate 10 are accepted.

Evidence: [Kubernetes Ingress PLAN](../evidence/CHG-2026-009-kubernetes-ingress-plan.md)

## Acceptance

1. Release `platform-ingress` is deployed in namespace `ingress-nginx` and
   Helm history records the reviewed revision sequence.
2. Exactly one ingress-nginx controller replica is Available.
3. `IngressClass/nginx` is owned by `k8s.io/ingress-nginx`.
4. The ingress controller Service is ClusterIP-only. No NodePort, hostPort,
   TCP 30081, or TCP 30444 is published on any cluster VM.
5. `headlamp/headlamp` uses ingress class `nginx`, and
   `http://headlamp.example.com` succeeds through NGINX on
   `k8s-worker01.example.com` port 80.
6. The old Headlamp NodePort 30080 and `headlamp.apps.example.com` shared route
   are retained only for rollback proof, then removed before closure.
7. PLAN, DEPLOY, second convergence, rollback, restore, cluster health, logs,
   and Jenkins agent identity pass with no secret leakage.

## Backout plan

Use only the reviewed Jenkins job with `ACTION=ROLLBACK`, an explicit known-good
Helm revision, and `CONFIRM_CHANGE=true`. Before legacy-route retirement, the
existing shared route and Headlamp NodePort 30080 remain the bounded recovery
path. After cutover, restore the last accepted ClusterIP release and local
NGINX configuration through the same controlled sources. Do not guess a
revision, delete cluster resources manually, or expose a NodePort directly.

## Closure information

| Field | Value |
| --- | --- |
| Close code | Pending |
| Closed date | Pending |
| Implementation result | Pending |
| Validation evidence | Pending |
