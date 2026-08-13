# CHG-2026-010: Deploy Kubernetes Persistent Storage

## Change record

| ServiceNow field | Value |
| --- | --- |
| Number | `CHG-2026-010` |
| Type | Normal |
| State | Closed - successful |
| Risk | Moderate |
| Impact | Low |
| Priority | High |
| Configuration item | Application Kubernetes persistent-storage foundation |
| Service | Kubernetes application delivery |
| Assignment group | Platform Engineering |
| Requested by | MIDHTECHLAB operator |
| Requested date | 2026-08-03 |
| Expected outage | None; no application currently consumes a PVC |

## Decision and delivery boundary

Deploy stable Longhorn 1.12.0 with its default V1 Data Engine. Longhorn is a
bootstrap release until Argo CD is accepted. Jenkins owns Helm planning,
deployment, rollback, restore, and storage acceptance. AWX and Ansible own
only operating-system packages, services, the dedicated data directory, and
the reviewed Kubernetes worker labels. A later explicit change may transfer
the accepted release to GitOps ownership; Jenkins and Argo CD must never
manage it concurrently.

The durable ownership model, topology, failure behavior, security boundary,
and operational evidence flow are maintained in the
[Kubernetes Platform Domain](../projects/kubernetes-platform.md#longhorn-persistent-storage-component).

```text
GitLab source and CI
        |
        +--> Jenkins -> AWX -> worker host prerequisites and labels
        |
        +--> Jenkins on jenkins-agent01 -> Helm 4.1.0
                                             |
                                             +--> Longhorn 1.12.0 V1
                                                  on three worker /data disks
```

Longhorn must not expose a LAN service. The UI, manager, conversion webhook,
admission webhook, CSI services, and acceptance workload stay private inside
Kubernetes. No NodePort, hostPort, LoadBalancer, or Ingress is permitted.

## Selected architecture

| Concern | Decision |
| --- | --- |
| Longhorn version | `1.12.0`, immutable official Helm chart digest `869bb20701b154473606f1e8967b27f34f2448a2dfe6eb8970f1cae6957384f5` |
| Kubernetes compatibility | Chart declares `>=1.25.0-0`; live cluster is `1.34.10` |
| Data engine | V1 only; V2 is disabled |
| Storage nodes | `k8s-worker01`, `k8s-worker02`, and `k8s-worker03` only |
| Excluded node | `k8s-control`; its `/data` disk must remain absent from Longhorn scheduling |
| Data path | `/data/longhorn` on each worker's dedicated 150 GiB XFS `ftype=1` disk |
| Replica policy | Three replicas across the three worker nodes |
| StorageClass | Default `longhorn`, `Retain`, `WaitForFirstConsumer`, ext4 volume filesystem, best-effort locality |
| Capacity guardrails | No root-disk storage; 25 percent minimum free and 20 percent reserved on each default data disk |
| Exposure | ClusterIP-only; no ingress or host-published backend port |
| Backup target | Unset in CHG-2026-010; scoped MinIO credentials and remote backup/restore require the next reviewed storage-backup boundary |

The version decision uses Longhorn's stable, non-prerelease v1.12.0 release,
published 2026-06-02. The official chart and documentation require Kubernetes
1.25 or later, a compatible container runtime, mount propagation, NFSv4
client support for RWX, and `open-iscsi` with `iscsid` for V1 volumes. The lab
uses the V1 filesystem-backed path because the dedicated XFS disks are already
mounted and the V2 engine is unnecessary for this bounded platform slice.

## Pre-change audit

- CHG-2026-009 is closed and canonical main contains its accepted evidence.
- GitLab has zero active pipelines and zero pending/running builds. Sixty-seven
  dormant `created` manual jobs are not executing.
- Jenkins is active with an empty queue and no running-build marker.
- AWX reports zero active unified jobs and no non-running platform pods.
- infra01/02/03 retain 17/14/4 running domains and show no conflicting Git,
  Ansible, Terraform, package, image-build, libvirt, Kubernetes, or Helm work.
- The application cluster reports four Ready Kubernetes 1.34.10 nodes, no
  active Jobs, and no non-running pods.
- No StorageClass, PV, or PVC exists. The accepted ingress release is the only
  Helm release and remains healthy.
- Each worker has a persistent 150 GiB XFS `/data` disk with `ftype=1`, shared
  mount propagation, and about 149 GiB free. The control plane has a separate
  50 GiB `/data` disk that is out of scope.
- SELinux is Enforcing. `nfs-utils` and device-mapper are installed. The
  `iscsi-initiator-utils` and `cryptsetup` packages are absent, and `iscsid`
  is inactive; these are controlled prerequisites, not reasons to bypass AWX.

## Source and control gates

1. Publish this active change and require documentation CI to pass.
2. Add an idempotent `storage-prerequisites` playbook to
   `midhhealth/platform-engineering/ansible-kubernetes`. It must install only
   the reviewed packages, start `iscsid`, keep the persistent `/data` mount,
   create `/data/longhorn`, label only the three workers, and verify the
   control plane is not storage-eligible.
3. Vendor the official Longhorn 1.12.0 chart under a locked
   `platform-storage` wrapper. CI must verify its SHA-256 digest, V1-only
   values, worker path, Retain policy, three replicas, private Services, and
   absence of NodePort/hostPort/LoadBalancer/Ingress source.
4. Add source-managed Jenkins jobs and trusted-library steps for prerequisite
   PLAN/APPLY/VALIDATE and Helm PLAN/DEPLOY/ROLLBACK. Mutations require an
   explicit confirmation flag and the exclusive `kubernetes-deployer` agent.
5. Pass branch and canonical-main GitLab pipelines for every changed source
   repository. Reconcile the Jenkins seed twice and require the second run to
   make no object change.
6. Run the prerequisite PLAN/check gate. Confirm exact nodes, packages,
   services, XFS properties, mount propagation, free capacity, and labels
   without changing hosts.
7. Apply prerequisites through Jenkins and AWX, validate them, then run a
   second APPLY and require zero changes or failures.
8. Run Helm `PLAN` with server-side dry run and hidden Secrets. Require exact
   chart revision, V1 engine, worker-only scheduling, and private Services.
9. Run the first atomic DEPLOY and acceptance release. Require all Longhorn
   and CSI workloads healthy, one default StorageClass, a Bound test PVC, a
   healthy three-replica volume, and marker data written to the test volume.
10. Repeat DEPLOY from the same source. Require no workload replacement or
    value drift, then recreate the acceptance pod and verify the marker.
11. Roll back to the known-good Helm revision, verify the PVC, volume health,
    replicas, and marker, then restore the accepted source and validate again.
12. Publish runtime evidence, incidents, current state, runbooks, exact source
    revisions, CI, Jenkins, AWX, and Helm history before closing the change.

### Documentation gate status

Merge request !20 passed branch pipeline 555 and merged as `fd75fd47`.
Canonical-main pipeline 556 then failed before validation: shared-runner job
1750 could not connect to `gitlab.example.com:80` during `get_sources` and
exited 128. The archived trace proves the repository validation script never
started. This recurrence is tracked in `INC-2026-073`; all source, AWX,
Jenkins, package, Helm, and Kubernetes mutations remain gated. Five canonical
runner probes observed one DNS failure followed by four HTTP 200 responses;
recovery branch `a696ea4` then passed pipeline 557. Recovery merge request !21
passed branch pipeline 558, merged as `d8d14dca`, and canonical-main pipeline
559 passed job 1753. `INC-2026-073` is resolved and the source gate is open.

## Acceptance criteria

1. Longhorn reports version 1.12.0 and only the V1 Data Engine is enabled.
2. Longhorn Manager, Driver, CSI, webhook, and UI workloads are Ready with no
   failed, pending, unknown, or crash-looping pods.
3. Exactly the three workers are schedulable Longhorn storage nodes. Their
   disks use `/data/longhorn`; the control plane and all root filesystems are
   absent from Longhorn disk configuration.
4. `StorageClass/longhorn` is the only default StorageClass, uses
   `driver.longhorn.io`, has `Retain`, `WaitForFirstConsumer`, three replicas,
   ext4, and best-effort locality.
5. A 1 GiB acceptance PVC is Bound. Its Longhorn volume is Healthy, attached,
   and has three running replicas on three distinct workers.
6. Marker data survives controlled pod deletion/recreation, DEPLOY
   convergence, Helm rollback, and restore.
7. Every Longhorn Service is ClusterIP. No Longhorn Ingress, NodePort,
   LoadBalancer, hostPort, or VM listener is introduced.
8. The second prerequisite application reports zero changes; the second Helm
   deployment causes no unexpected rollout or value drift.
9. Existing ingress and Headlamp remain healthy throughout the change.
10. Logs, Kubernetes events, capacity, Helm history, Jenkins builds, AWX jobs,
    incidents, and negative exposure checks are preserved as evidence.

## Backout plan

Before an accepted PVC contains data, a failed atomic installation may be
removed only through the reviewed Jenkins Helm job after recording evidence.
After the acceptance PVC exists, never uninstall Longhorn, delete its CRDs,
delete `/data/longhorn`, or delete the PVC as a recovery shortcut. Use only a
known-good Helm rollback through Jenkins. If rollback does not restore healthy
controllers and the three replicas, stop, retain all data and cluster
resources, record the incident, and recover from the preserved release state.

## Implementation and validation result

The change completed successfully on 2026-08-08. Accepted source revisions are
`ansible-kubernetes` `93d4973a`, `jenkins-jobs` `c9bf66ff`, and
`jenkins-shared-library` `edf29c2d`; their canonical-main pipelines 564, 570,
and 574 passed. Enterprise Longhorn design merge request !23 merged as
`96e95ab2` and main documentation pipeline 578 passed before closeout.

Prerequisite Jenkins builds 2-5 and AWX jobs 823, 833, 843, and 853 passed;
the final two jobs reported `changed: {}` with no dark or failed host. Storage
PLAN build 1 passed. Builds 2/3 preserved healthy runtime while evidence
defects were corrected under INC-2026-084. VERIFY build 4, convergence build
5, pod-recreation build 6, rollback build 7, and accepted-source restore build
8 then passed.

Final runtime is Longhorn 1.12.0 V1 on only the three worker
`/data/longhorn` disks. Storage release revision 4 and acceptance revision 3
are deployed. The default Retain StorageClass, Bound 1 GiB acceptance PVC,
healthy attached volume, three running worker-separated replicas, persistent
marker, private Services, absent ingress/host ports, empty backup target, and
control-plane exclusion all passed. See the complete
[acceptance evidence](../evidence/CHG-2026-010-kubernetes-persistent-storage-acceptance.md).

## Closure information

| Field | Value |
| --- | --- |
| Close code | Successful |
| Closed date | 2026-08-08 |
| Implementation result | Longhorn 1.12.0 V1 accepted on three worker-only dedicated disks with retained three-replica persistence |
| Validation evidence | [CHG-2026-010 Kubernetes Persistent-Storage Acceptance](../evidence/CHG-2026-010-kubernetes-persistent-storage-acceptance.md) |
