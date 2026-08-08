# Kubernetes Helm Delivery Runbook

## Purpose

This runbook defines the production-like delivery boundary for Kubernetes
products in the on-premises lab. It applies first to the single-replica
ingress tier and the worker-only Longhorn persistent-storage foundation, then
to later platform charts.

```text
Git commit -> GitLab CI -> Jenkins -> Helm -> Kubernetes
                                 \
                                  runtime evidence and rollback history
```

AWX and Ansible configure VMs, operating systems, firewalls, containerd,
kubeadm, CNI, and cluster prerequisites. They do not install Helm releases or
apply application manifests.

## Required Components

| Component | Required state |
| --- | --- |
| GitLab repository | `midhhealth/platform-engineering/ansible-kubernetes` |
| Jenkins Job DSL | `projects/deploy-kubernetes-ingress` |
| Jenkins shared step | `kubernetesHelmPipeline` |
| Jenkins executor | `jenkins-agent01.example.com`, label `kubernetes-deployer` |
| Jenkins kubeconfig credential | Secret file, ID `kubernetes-production-kubeconfig` |
| Helm | 4.1.0 |
| kubectl | Kubernetes 1.34-compatible client |
| Helm release | `platform-ingress` in namespace `ingress-nginx` |
| Upstream chart | ingress-nginx chart 4.15.0 |
| Controller | ingress-nginx 1.15.1, digest pinned |

Do not run the deployment on the Jenkins controller. Do not copy kubeconfig
content into a job parameter, console log, repository, or shell profile.

## Source Validation

GitLab CI must pass all of these jobs for the exact revision selected in
Jenkins:

- Ansible syntax and lint for cluster configuration;
- deployment-boundary validation proving Ansible does not run Helm or
  `kubectl apply`;
- `helm dependency build`;
- `helm lint`;
- `helm template`.

The committed `Chart.lock` records the upstream chart digest. The controller
image is pinned by tag and SHA-256 digest in
`charts/platform-ingress/values.yaml`.

## Jenkins Agent Acceptance

The initial agent connection is a bootstrap exception because Jenkins cannot
schedule work on an agent that does not exist yet:

1. Sign in to Jenkins and create permanent node `jenkins-agent01`.
2. Set remote root `/var/lib/jenkins/agent`, one executor, label
   `kubernetes-deployer`, and the inbound/WebSocket launch method.
3. Copy the generated agent secret directly into an encrypted, prompted AWX
   variable named `jenkins_agent_secret`. Do not place it in inventory or
   GitLab variables.
4. Run `ansible-jenkins/playbooks/jenkins-agent.yml` through AWX against only
   `jenkins-agent01.example.com`.
5. Destroy the operator's temporary copy of the secret after AWX stores or
   consumes it.

Before enabling the deployment job:

1. Confirm `jenkins-agent01.example.com` is online in **Manage Jenkins >
   Nodes**.
2. Confirm the node has label `kubernetes-deployer` and one executor.
3. Run on that node and record output in the change:

   ```bash
   helm version --short
   kubectl version --client
   java -version
   git --version
   ```

4. Confirm the node can resolve GitLab, the Kubernetes API endpoint, and
   `headlamp.example.com`.
5. Confirm the kubeconfig credential is a Jenkins **Secret file** and is
   scoped to the deployment job/folder.
6. Keep the built-in controller executor count at zero for deployment work.

If the agent is offline, stop. Do not change the job to `agent any`.

## Plan

Open `projects/deploy-kubernetes-ingress` and use:

```text
GIT_BRANCH=<reviewed commit, protected branch, or tag>
ACTION=PLAN
CONFIRM_CHANGE=false
ROLLBACK_REVISION=
KUBECONFIG_CREDENTIAL_ID=kubernetes-production-kubeconfig
```

The plan must resolve the locked dependency, lint and render the chart,
connect to the intended cluster, and complete a server-side Helm dry run.
Confirm that Jenkins used `jenkins-agent01` and that the output contains no
secret material.

## Deploy

After reviewing the plan and GitLab pipeline, rerun with:

```text
ACTION=DEPLOY
CONFIRM_CHANGE=true
```

The pipeline uses `helm upgrade --install --atomic --wait`. Acceptance checks
must prove:

- release `platform-ingress` is deployed in `ingress-nginx`;
- one controller replica is Available;
- `IngressClass/nginx` is owned by `k8s.io/ingress-nginx`;
- the ingress controller Service is ClusterIP-only and has no NodePort or
  hostPort;
- `headlamp/headlamp` uses ingress class `nginx`;
- `http://headlamp.example.com` succeeds through NGINX HTTP 80 on
  `k8s-worker01.example.com`;
- firewalld exposes only the NGINX frontend, not a Kubernetes backend port;
- the old Headlamp NodePort `30080` and shared `headlamp.apps.example.com`
  route remain only through rollback proof and are removed before the change
  closes.

Run DEPLOY a second time from the same Git revision. It must complete without
an unexpected rollout, resource replacement, or value drift.

## Rollback

List release history in the Jenkins build log:

```bash
helm history platform-ingress --namespace ingress-nginx
```

Start the same job with `ACTION=ROLLBACK`, select an explicit known-good
`ROLLBACK_REVISION`, and set `CONFIRM_CHANGE=true`. Never guess a revision.
The pipeline waits for the rollback and repeats runtime acceptance.

If Helm cannot restore service before legacy cutover, retain the existing
Headlamp route temporarily, record the incident, and stop further platform
deployment. Do not create or open another NodePort. After cutover, restore the
accepted ClusterIP release and product-local NGINX source.

## Longhorn Storage Delivery and Recovery

Longhorn uses the same GitLab, exclusive Jenkins agent, kubeconfig credential,
Helm, and cluster boundary. Its additional managed components are:

| Component | Required state |
| --- | --- |
| Host-prerequisite job | `projects/configure-kubernetes-storage-prerequisites` |
| Storage Helm job | `projects/deploy-kubernetes-storage` |
| Shared steps | `kubernetesStoragePrerequisitesAwxPipeline` and `kubernetesStoragePipeline` |
| Host automation | AWX and `ansible-kubernetes` manage packages, `iscsid`, `/data/longhorn`, and worker labels only |
| Helm releases | `platform-storage` in `longhorn-system`; `platform-storage-acceptance` in `storage-acceptance` |
| Longhorn release | 1.12.0 with the official chart digest pinned; V1 Data Engine only |
| Storage topology | Three workers using only dedicated XFS `/data/longhorn`; control plane and root disks excluded |

Run prerequisite `PLAN`, confirmed `APPLY`, `VALIDATE`, and a second confirmed
`APPLY`. The final application must report zero changes, unreachable hosts,
and failed hosts. Do not install packages or label nodes directly to bypass an
unavailable AWX control plane.

Run the storage job with:

```text
GIT_BRANCH=<reviewed commit, protected branch, or tag>
ACTION=PLAN
CONFIRM_CHANGE=false
ROLLBACK_REVISION=
KUBECONFIG_CREDENTIAL_ID=kubernetes-production-kubeconfig
```

The server-side PLAN must render the pinned Longhorn chart with hidden
Secrets and create no resource. After review, use `ACTION=DEPLOY` and
`CONFIRM_CHANGE=true`. Acceptance must prove worker-only placement, V1-only
settings, a default Retain/WaitForFirstConsumer StorageClass, private
Services, a Bound PVC, a Healthy attached volume, three replicas on three
workers, and the persistence marker.

Repeat DEPLOY from the same source. Use `ACTION=RECREATE_ACCEPTANCE` with
confirmation to replace only the acceptance pod; the PVC, PV, Longhorn volume,
and marker must remain. Use `ACTION=VERIFY` for a read-only repeat of all
acceptance and negative checks.

For rollback, select an explicit known-good `platform-storage` revision and
run `ACTION=ROLLBACK` with confirmation. The job must not roll back or delete
the acceptance release, PVC, PV, or data. After acceptance succeeds on the
known-good revision, run confirmed DEPLOY from accepted source and require the
full checks again.

Once a retained PVC contains data, never recover by uninstalling Longhorn,
deleting its CRDs, deleting `/data/longhorn`, or deleting the claim. If a
known-good rollback cannot restore controller and replica health, preserve all
resources, record the incident, and stop. A backup target, credentials,
retention policy, and restore objectives require a separate reviewed change.

## Evidence

Record all of the following in the active change and incident register:

- Git commit and GitLab pipeline ID;
- Jenkins build number and selected parameters;
- Jenkins agent name;
- Helm release revision before and after the change;
- controller rollout and service/IngressClass evidence;
- Headlamp route result;
- second-convergence result;
- rollback test and recovery path;
- every warning, failure, and corrective commit.

For Longhorn also record host-prerequisite convergence, node/disk placement,
StorageClass and PVC/PV identity, volume robustness and replica nodes, marker
value, pod recreation, Helm histories for both releases, empty backup target,
and negative ingress/NodePort/LoadBalancer/hostPort/control-plane-disk checks.
