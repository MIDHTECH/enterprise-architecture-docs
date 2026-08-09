# CHG-2026-011: Bootstrap Argo CD GitOps Reconciliation

## Change record

| ServiceNow field | Value |
| --- | --- |
| Number | `CHG-2026-011` |
| Type | Normal |
| State | Runtime prerequisite recovery |
| Risk | Moderate |
| Impact | Low |
| Priority | High |
| Configuration item | Application Kubernetes GitOps control plane |
| Service | Kubernetes application delivery |
| Assignment group | Platform Engineering |
| Requested by | MIDHTECHLAB operator |
| Requested date | 2026-08-08 |
| Expected outage | None; Argo CD is not installed and the first managed object is an isolated reconciliation canary |

## Queue decision

The operator's active goal is to complete the Enterprise Kubernetes Platform
with GitOps. This explicitly places the GitOps control plane after accepted
Longhorn storage and before product installation. Artifactory remains deferred
until its separate storage-backup prerequisite is accepted; this change does
not install Artifactory, SonarQube, a backup target, or another platform
component.

## Decision and delivery boundary

Bootstrap Argo CD `3.4.6` through the official `argo-cd` Helm chart `10.2.2`.
The chart declares Kubernetes `>=1.25.0-0`, matching the live Kubernetes
`1.34.10` cluster. The downloaded official package has SHA-256 digest
`4ee0aa7e01697f230c6e946fd5757f61503287db9af2d2d6bb975874ff6393b4`.
The selected 3.4 line is supported and established; the newly released 3.5
line is deferred until a later reviewed upgrade. See the official
[Argo CD releases](https://github.com/argoproj/argo-cd/releases) and
[Argo Helm release](https://github.com/argoproj/argo-helm/releases/tag/argo-cd-10.2.2).

The installation is a non-HA lab control plane consistent with the accepted
single-control-plane cluster. Jenkins on the exclusive
`kubernetes-deployer` agent owns Helm PLAN, deployment, verification,
rollback, and restore. GitLab CI validates source but cannot deploy. AWX and
Ansible do not install Argo CD. A dedicated read-only GitLab deploy credential
allows Argo CD to read only
`midhhealth/platform-engineering/kubernetes-platform-gitops`.

```text
GitLab protected main and validation
                |
                +--> Jenkins bootstrap job --> Helm --> argocd namespace
                |                                  |
                |                                  +--> Argo CD 3.4.6
                |
                +<-- dedicated read-only repository credential
                                                   |
                                                   +--> clusters/onprem/bootstrap
                                                        |
                                                        +--> isolated reconciliation canary
```

Argo CD owns only the isolated canary resources declared under the approved
bootstrap path. Jenkins retains ownership of ingress-nginx and Longhorn.
Headlamp, application workloads, policy engines, secrets operators, backup,
autoscaling, and other add-ons remain outside this component. Ownership can
move only through later explicit handoff changes; Jenkins and Argo CD must
never reconcile the same resource concurrently.

## Selected architecture

| Concern | Decision |
| --- | --- |
| Argo CD version | `3.4.6` |
| Helm chart | Official `argo-cd` chart `10.2.2`, immutable digest `4ee0aa7e01697f230c6e946fd5757f61503287db9af2d2d6bb975874ff6393b4` |
| Availability | Non-HA lab deployment; one application controller and one replica for each supporting component |
| Placement | Normal Kubernetes scheduling on workers; control-plane taint remains unchanged |
| Exposure | All Services ClusterIP; no Ingress, NodePort, LoadBalancer, hostPort, LAN listener, or UI publication |
| Repository transport | SSH to canonical `gitlab.example.com:2222` with a dedicated project-scoped read-only deploy key |
| Credential handling | Private key is never committed or printed; Jenkins creates the Argo repository Secret from a scoped credential and removes temporary material |
| Project boundary | Dedicated AppProject allows only the exact GitLab repository and isolated `gitops-acceptance` destination |
| Root path | `clusters/onprem/bootstrap`; no application, ingress, Longhorn, policy-engine, backup, or secret-operator ownership |
| Reconciliation | Automated self-heal and prune only inside the isolated project boundary; a marker ConfigMap proves desired-state restoration |
| Bootstrap ownership | Jenkins manages the Argo CD Helm release, repository Secret, AppProject, and root Application; Argo CD manages only child desired state |
| Persistent data | No application PVC is introduced; Redis/repository caches are disposable in this bounded non-HA component |

## Pre-change audit

- The sequential gate is `None` / `Idle` after CHG-2026-010 closeout.
- GitLab reports zero active pipelines/builds; Jenkins has an empty queue and
  no durable task; AWX reports zero active unified jobs.
- infra01/02/03 retain 17/14/4 running domains with no conflicting Git,
  Ansible, Terraform, package, VM-provisioning, Helm, or kubectl mutator.
- The application cluster reports four Ready Kubernetes 1.34.10 nodes, no
  active Jobs, no non-running pods, and a healthy attached three-replica
  Longhorn acceptance volume.
- Namespace `argocd` is absent and zero `argoproj.io` CRDs exist.
- The GitOps repository main revision `71a079bf` is clean locally, but main
  pipeline 244 failed without an assigned runner. Its jobs have no accepted
  runner tag after retirement of the legacy untagged runner.
- Existing source contains a direct `kubectl apply` script, permissive sample
  NetworkPolicy, mutable image tags, the legacy GitLab URL, and an unrestricted
  default Argo project. None is approved for live reconciliation.

## Source and control gates

1. Publish this active change and pass branch plus canonical-main
   documentation CI.
2. Recover GitOps source CI on the accepted `validation` runner. Remove the
   direct deployment job and require all live mutation to use the reviewed
   Jenkins bootstrap path.
3. Vendor the official chart under a locked wrapper and validate its digest,
   application version, non-HA values, worker scheduling, private Services,
   restrictive security contexts, resource requests/limits, and absence of
   ingress/NodePort/LoadBalancer/hostPort source.
4. Replace the broad default project and application definition with a
   dedicated AppProject and `clusters/onprem/bootstrap` canary. Reject legacy
   URLs, mutable image tags, broad destination wildcards, and ownership of
   ingress, Longhorn, or application workloads.
5. Add source-managed Jenkins Job DSL and trusted-library steps for PLAN,
   DEPLOY, VERIFY, TEST_RECONCILIATION, and ROLLBACK. Mutations require
   confirmation and the exclusive `kubernetes-deployer` agent.
6. Pass branch and canonical-main GitLab pipelines for every changed source
   repository. Reconcile the Jenkins seed twice and require the second run to
   make no object change.
7. Enable the existing Jenkins read-only SCM key for the GitOps project without
   push access. Create a separate Argo CD read-only repository identity; do not
   reuse a write-capable human or automation credential.
8. Run a server-side Helm PLAN with hidden Secrets. Require exact version,
   digest, namespace, objects, private exposure, and zero runtime resources
   after the plan.
9. Run the first atomic DEPLOY. Require all Argo CD workloads Ready, exact
   images/version, private Services, restricted project/repository state, and
   a Synced/Healthy canary Application.
10. Patch only the canary marker through the reviewed Jenkins action. Require
    Argo CD self-heal to restore Git desired state and record sync health.
11. Repeat DEPLOY from identical source, prove no unexpected rollout/value
    drift, roll back to a known-good Helm revision, restore accepted source,
    and repeat reconciliation acceptance.
12. Publish runtime evidence, incidents, exact source revisions, CI, Jenkins,
    Helm history, sync history, credential-boundary checks, and negative
    exposure/ownership checks before closing the component.

## Runtime attempt and bounded network prerequisite

Reviewed GitOps, shared-library, and Job DSL source passed branch and
protected-main validation. The Jenkins seed converged, the dedicated Argo CD
repository credential remained project-scoped and read-only, and PLAN build 4
passed against the exact accepted revisions. The first DEPLOY attempt exposed
the Helm CRD discovery boundary and was corrected with a reviewed two-phase
first-install flow. DEPLOY build 7 then reached that accepted flow but lost its
HTTP/2 connection to the Kubernetes API. Atomic rollback removed the failed
Helm release. Recovery PLAN build 8 subsequently timed out during its initial
read-only API check before Helm executed.

The application control plane is healthy, all four nodes are Ready, and the
initial comparison found all four infra03 VMs losing transport to the API.
The bounded corrective source and delivery path were accepted before runtime
mutation. Jenkins PLAN build 3/AWX job 874 predicted only persistent and live
STP convergence. APPLY build 4/job 882 changed only those two states;
VALIDATE build 5/job 890 passed with zero changes; and idempotence APPLY build
6/job 898 also reported zero changes. The exact accepted cloud-infrastructure
revision is `7690ad3bde91c725e77c11e3ce6e034330943ef2`; the credential
reconciliation fix used shared-library protected-main revision
`5ccf022d29fecfda49b5441e249286969e67242f`.

The infrastructure change itself is accepted: persistent `bridge.stp=no`,
live STP `0`, four running/autostart domains, and forwarding uplink and guest
ports. No VM was cycled and the bridge was not reconnected. The transport exit
criterion, however, failed intermittently after convergence. Some HTTPS
probe series passed 60/60 or 100/100, while others failed after 11 or 12
successes. Sequential 30-packet ICMP probes returned 1/30, 0/30, 3/30, and
23/30 across the four guests.

Read-only checks verified correct routes, neighbor MAC, FDB learning, guest
and control VM health, Kubernetes listener and firewall policy, and absence
of source-specific filtering. The control plane received echo requests and
emitted corresponding replies. During a failed large-packet probe, directional
counters showed substantial reply traffic leaving infra01 but only a small
fraction arriving at infra03. During that interval, evidence narrowed the
residual fault toward the infra01-to-infra03 physical/switch path, but no exact
cable, port, or device cause was proven. The earlier STP drift was real and
corrected; the post-correction loss mechanism remains undetermined.

A later validation-only window passed without a physical, router, switch,
bridge, VM, or Kubernetes mutation. Each infra03 guest passed 100/100 standard
and 100/100 1,400-byte ICMP probes to `192.168.1.107`, with neighbor MAC
`52:54:00:01:01:07`. Across the four guests, 720 DNS checks and 960 HTTP/HTTPS
requests to GitLab, Jenkins, AWX, and Kubernetes `/readyz` completed with zero
failure or timeout. Reinspection proved:

1. all four infra03 domains remain running and configured for autostart;
2. live and persistent infra03 `lab-br0` STP state are disabled;
3. bridge ports remain forwarding and the host retains canonical addressing;
4. every infra03 guest passes sustained ICMP, ARP, DNS, GitLab, Jenkins, AWX,
   and Kubernetes `/readyz` probes without loss or timeout;
5. GitLab, Jenkins, and AWX remain idle after the correction; and
6. the application cluster retains four Ready nodes and healthy Longhorn,
   ingress, and Headlamp state.

The recovery window accepted the prerequisite for Jenkins recovery PLAN only.
PLAN build 9 passed in 23 seconds against exact shared-library revision
`5ccf022d29fecfda49b5441e249286969e67242f` and GitOps revision
`6dbb5bf0d15b310be629e7681c39b540120ada53`; both dry runs preserved the
retained namespace and three CRDs. The independent pre-DEPLOY check then
closed the gate: the Jenkins agent received 6/20 ICMP replies and Kubernetes
`/readyz` timed out. DEPLOY was not started. Follow-up traffic recovered
quickly, which confirms intermittent behavior but does not satisfy sustained
acceptance across separated windows.

Direct router/switch UI changes, remote `nmcli`, workstation Ansible, VM
restart, bridge recreation, another PLAN, and DEPLOY remain prohibited until
a separately reviewed physical or managed-network prerequisite is corrected
and accepted. infra02 standardization remains a separate queued network
change.

INC-2026-085 records the failed builds, accepted STP correction, failed
interval, temporary recovery, and pre-DEPLOY recurrence. The exact execution
and probe result is retained in
[infra03 network prerequisite evidence](../evidence/CHG-2026-011-infra03-network-prerequisite-result.md).

## Acceptance criteria

1. Argo CD reports version 3.4.6 from chart 10.2.2 and all controller, server,
   repository, ApplicationSet, notifications, and Redis workloads are Ready.
2. All Services are ClusterIP. No Argo CD Ingress, NodePort, LoadBalancer,
   hostPort, VM listener, public DNS record, or LAN frontend exists.
3. The repository credential is project-scoped and read-only; no key, token,
   password, or Secret data appears in Git, Helm values, Jenkins logs, or
   evidence.
4. The dedicated AppProject permits only the exact GitOps repository and
   `gitops-acceptance` namespace. The default project does not own the canary.
5. The root Application tracks protected `main` and
   `clusters/onprem/bootstrap`, reports Synced and Healthy, and records the
   accepted Git revision.
6. A controlled marker drift is automatically restored to the Git value
   within the acceptance timeout, with reconciliation evidence preserved.
7. Argo CD manages no ingress-nginx, Longhorn, Headlamp, application workload,
   policy engine, secret operator, backup, autoscaling, or cluster lifecycle
   object in this component.
8. The second deployment causes no unexpected workload replacement or value
   drift. Known-good rollback and accepted-source restore preserve GitOps
   reconciliation.
9. Existing ingress, Headlamp, Longhorn, acceptance PVC/marker, and all four
   cluster nodes remain healthy throughout the change.
10. Jenkins, AWX, GitLab, hypervisor, cluster, event, restart, Helm, and Argo
    sync evidence is published before the active row returns to `None`.

## Backout plan

Before the canary Application is accepted, a failed atomic installation may
be removed only through the reviewed Jenkins job after evidence collection.
After reconciliation is accepted, use a known-good Helm rollback and preserve
the repository Secret, AppProject, root Application, and canary until service
is restored. Do not delete Argo CRDs, existing application resources,
Longhorn, ingress, or the retained storage PVC as a recovery shortcut. If
rollback does not restore controller health and sync status, stop, record the
incident, retain all resources, and recover from the preserved release/source
state.

## Closure information

| Field | Value |
| --- | --- |
| Close code | Pending |
| Closed date | Pending |
| Implementation result | Pending |
| Validation evidence | Pending |
