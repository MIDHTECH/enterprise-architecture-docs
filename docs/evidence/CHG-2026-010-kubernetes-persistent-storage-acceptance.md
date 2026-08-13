# CHG-2026-010 Kubernetes Persistent-Storage Acceptance

Date: 2026-08-08

## Accepted result

The existing four-node kubeadm application cluster now runs Longhorn `1.12.0`
with only the V1 Data Engine enabled. Exactly the three workers provide
storage from dedicated XFS disks at `/data/longhorn`; the control plane and
all root filesystems are excluded. Application teams consume the default
`longhorn` StorageClass through PVCs.

The release is a Jenkins-managed Helm bootstrap until a separately reviewed
change transfers ownership to Argo CD. AWX and Ansible own only the host
prerequisites and worker labels. No workstation Helm command or direct
`kubectl apply` was used. The durable component design is in the
[Kubernetes Platform Domain](../projects/kubernetes-platform.md#longhorn-persistent-storage-component).

## Accepted source and CI

| Repository | Merge request and canonical revision | CI evidence |
| --- | --- | --- |
| `ansible-kubernetes` | !2, `93d4973ab05ba127d37170ebea13ab763e277a8e` | Branch pipelines 562/563 and main pipeline 564 passed |
| `jenkins-shared-library` storage delivery | !3, `5048905dfb8d6a360915f30a264f3378330bc06f` | Branch pipeline 565 and main pipeline 566 passed |
| `jenkins-jobs` storage controls | !3, `698eac835339b94d6b1c4e60a5a2fcc076cb29de` | Branch pipeline 567 and main pipeline 568 passed |
| `jenkins-jobs` installed-option correction | !4, `c9bf66ff8421a50bc0064af57e5cb59431f04a8e` | Branch pipeline 569 and main pipeline 570 passed |
| `jenkins-shared-library` first acceptance correction | !4, `44b2b5e33bfff42c7676f1df2dda4ccb9b9d8710` | Branch pipeline 571 and main pipeline 572 passed |
| `jenkins-shared-library` comprehensive template correction | !5, `edf29c2d225f798e40ec7e8cfaaa84b734b15e03` | Branch pipeline 573 and main pipeline 574 passed |
| Enterprise Longhorn component design | !23, `96e95ab2c2cf342e8a74712f29ce7c18e49c934f` | Branch pipeline 577 and main pipeline 578 passed |

The official Longhorn `1.12.0` chart is pinned by SHA-256 digest
`869bb20701b154473606f1e8967b27f34f2448a2dfe6eb8970f1cae6957384f5`.
Source validation rejects chart drift, V2 enablement, public service types,
host ports, ingress, the control-plane disk, and non-Retain defaults.

## Host-prerequisite delivery

| Gate | Jenkins evidence | AWX evidence | Result |
| --- | --- | --- | --- |
| Pipeline compile | `projects/configure-kubernetes-storage-prerequisites` build 1 | No AWX launch | Failed safely on the unavailable `timestamps()` option; INC-2026-083 |
| PLAN/check | Prerequisite build 2 | Job 823 | Passed; check-mode changes were limited to the expected packages, service, directory, and labels |
| APPLY | Prerequisite build 3 | Job 833 | Passed; all four nodes converged with no dark or failed host |
| VALIDATE | Prerequisite build 4 | Job 843 | Passed with `changed: {}`, no dark hosts, and no failures |
| APPLY convergence | Prerequisite build 5 | Job 853 | Passed with `changed: {}`, no dark hosts, and no failures |

Final host inspection proved `iscsi-initiator-utils 6.2.1.11`,
`cryptsetup 2.8.1`, and `nfs-utils 2.5.4` installed and `iscsid` active on all four
cluster nodes. `/data` is a shared-propagation XFS mount on `/dev/vdb`.
Each worker has `/data/longhorn` owned by `root:root` with mode `0750` and
approximately 159.8 GB free. The control plane's separate `/data` disk has no
`/data/longhorn` directory.

Jenkins seed builds 52 and 55 stopped at the intended script-approval gate.
Only hashes generated from the reviewed source were approved. Seed builds
53/54 and 56/57 then succeeded in pairs; the second run in each pair proved
jobs-as-code convergence.

## Helm and persistence delivery

| Gate | Jenkins storage build | Helm or runtime evidence | Result |
| --- | ---: | --- | --- |
| Server-side PLAN | 1 | Hidden-secret dry run; no cluster resource created | Passed |
| Initial deploy | 2 | Storage and acceptance revision 1; PVC became Bound and volume Healthy | Runtime passed; evidence step failed safely under INC-2026-084 |
| First corrected VERIFY | 3 | Existing release and PVC only | Worker paths passed; second template escape failed under INC-2026-084 |
| Comprehensive VERIFY | 4 | Exact shared-library main `edf29c2d` | Passed every acceptance and negative check |
| Deploy convergence | 5 | Both releases advanced to revision 2 | Passed; acceptance pod was not replaced and marker remained |
| Pod-recreation proof | 6 | Acceptance pod changed from suffix `gshl7` to `8p44t` | Passed; same PVC and marker remained |
| Known-good rollback | 7 | `platform-storage` rolled back to revision 1 and recorded deployed revision 3 | Passed; acceptance release and PVC were untouched |
| Accepted-source restore | 8 | Storage revision 4 and acceptance revision 3 deployed | Passed; full acceptance repeated |

The final Helm history contains `platform-storage` revisions 1-4 with revision
4 deployed and `platform-storage-acceptance` revisions 1-3 with revision 3
deployed. All confirmed operations ran on the exclusive
`kubernetes-deployer` executor through the reviewed Jenkins job.

## Runtime acceptance

- Four of four Kubernetes `1.34.10` nodes are Ready. There are no active Jobs
  and no failed, pending, unknown, error, or crash-looping pods.
- All Longhorn manager, driver, UI, engine-image, instance-manager, CSI
  plugin, attacher, provisioner, resizer, and snapshotter pods are Running and
  Ready on the three workers.
- Longhorn exposes exactly three schedulable storage nodes:
  `k8s-worker01`, `k8s-worker02`, and `k8s-worker03`. Each uses only
  `/data/longhorn`; no Longhorn node exists for `k8s-control`.
- The default `longhorn` StorageClass uses `driver.longhorn.io`, `Retain`,
  `WaitForFirstConsumer`, three replicas, V1, ext4, and best-effort locality.
- PVC `storage-acceptance/platform-storage-acceptance` is Bound at 1 GiB to
  PV and Longhorn volume
  `pvc-c22f57ed-20e6-42aa-9406-a5b8ed55eb27`.
- The volume is attached to `k8s-worker02`, reports `healthy`, and has three
  running replicas placed separately on worker01, worker02, and worker03.
- The recreated acceptance pod is Running on worker02 and still reads marker
  `chg-2026-010-persistence-marker-v1` after convergence, recreation,
  rollback, and restore.
- Every Longhorn Service is ClusterIP with no NodePort. The namespace has no
  Ingress and no container hostPort. The Longhorn UI and APIs therefore remain
  cluster-private.
- The default backup target URL is empty. Local three-way replication is not
  represented as off-cluster backup or disaster recovery.
- Existing ingress-nginx and Headlamp remained healthy throughout the storage
  work.

Initial image pulls and controller startup produced transient manager
readiness, CSI topology/socket, and sidecar restart warnings. The final audit
occurred more than 30 minutes after the last warning: every pod was Ready,
the volume was Healthy, all three replicas were Running, and the successful
VERIFY, convergence, recreation, rollback, and restore builds introduced no
new unresolved warning state.

## Final change-control audit

- GitLab reported zero active pipelines and zero active builds.
- Jenkins had an empty queue and zero durable task process markers.
- AWX reported zero active unified jobs.
- infra01, infra02, and infra03 retained 17, 14, and 4 running domains with no
  conflicting Git, Ansible, Terraform, package, VM-provisioning, Helm, or
  kubectl mutator.
- The application cluster had no active Jobs or non-running pods.

## Incident closure

- INC-2026-083 is resolved by removing the unavailable pipeline option,
  validating the corrected Job DSL, passing branch/main CI, reconciling the
  seed twice, and completing prerequisite builds 2-5 plus AWX jobs 823, 833,
  843, and 853.
- INC-2026-084 is resolved by escaping every intended newline at the Groovy
  boundary and adding a regression guard. Shared-library pipelines 571-574
  passed, and storage builds 4-8 completed successfully against the retained
  volume.
