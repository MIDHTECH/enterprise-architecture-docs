# CHG-2026-009: Deploy the Kubernetes Ingress Tier

## Change record

| ServiceNow field | Value |
| --- | --- |
| Number | `CHG-2026-009` |
| Type | Normal |
| State | Credential and PLAN prerequisite gate |
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

The permanent VM exposure rule remains in force. The ingress controller uses
NodePorts 30081/30444 only as a private boundary. Firewalld admits HTTP 30081
only from the existing product-local edge proxy at `nginx.example.com`
(`192.168.1.114`). Applications remain exposed by canonical hostname through
NGINX; the NodePorts are not general LAN service endpoints.

## Accepted source

| Repository | Revision | GitLab pipeline | State |
| --- | --- | ---: | --- |
| `midhhealth/platform-engineering/ansible-kubernetes` | `e34bd5477472a6d21c6a5d1933a0d95b5c3ebc55` | 354 | Passed |
| `midhhealth/platform-delivery/jenkins-jobs` | `950cc4f89cba54b12fe64af90db5e90bd7d430fa` | 352 | Passed |
| `midhhealth/platform-delivery/jenkins-shared-library` | `b23d3a4e9ae0db9f398f77554e7559acad839088` | 351 | Passed |

The chart locks ingress-nginx 4.15.0 and controller 1.15.1 by digest. The Helm
release is `platform-ingress` in namespace `ingress-nginx`, with one controller
replica and NodePorts 30081/30444. The managed Headlamp Ingress uses class
`nginx` and host `headlamp.apps.example.com`.

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
7. Run the reviewed Ansible prerequisite playbook only if PLAN and live
   firewall inspection show it is required. The scope is the documented
   Kubernetes nodes and source-restricted NodePort rule only.
8. Run `ACTION=DEPLOY`, `CONFIRM_CHANGE=true` through Jenkins. Require atomic
   Helm wait and runtime acceptance.
9. Repeat DEPLOY from the same revision and require no unexpected rollout,
   replacement, or value drift.
10. Run an explicit known-good Helm rollback through the same Jenkins job,
   validate the retained Headlamp NodePort 30080 recovery path, then restore
   the accepted release and validate again.
11. Publish runtime evidence and incidents before closing the active change.

## Acceptance

1. Release `platform-ingress` is deployed in namespace `ingress-nginx` and
   Helm history records the reviewed revision sequence.
2. Exactly one ingress-nginx controller replica is Available.
3. `IngressClass/nginx` is owned by `k8s.io/ingress-nginx`.
4. HTTP/HTTPS NodePorts are exactly 30081/30444 and are not generally exposed
   as VM host services. The HTTP firewall rule is limited to
   `nginx.example.com`.
5. `headlamp/headlamp` uses ingress class `nginx`, and the expected Host-header
   request succeeds through NodePort 30081.
6. The old Headlamp NodePort 30080 remains available for rollback and is not
   removed by this change.
7. PLAN, DEPLOY, second convergence, rollback, restore, cluster health, logs,
   and Jenkins agent identity pass with no secret leakage.

## Backout plan

Use only the reviewed Jenkins job with `ACTION=ROLLBACK`, an explicit known-good
Helm revision, and `CONFIRM_CHANGE=true`. If Helm rollback cannot restore the
release, keep the existing NGINX route on Headlamp NodePort 30080, record the
incident, and stop. Do not guess a revision, delete cluster resources manually,
or expose a NodePort directly.

## Closure information

| Field | Value |
| --- | --- |
| Close code | Pending |
| Closed date | Pending |
| Implementation result | Pending |
| Validation evidence | Pending |
