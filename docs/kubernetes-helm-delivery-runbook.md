# Kubernetes Helm Delivery Runbook

## Purpose

This runbook defines the production-like delivery boundary for Kubernetes
products in the on-premises lab. It applies first to the single-replica
ingress tier and then to later platform charts.

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
   `headlamp.apps.example.com`.
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
- HTTP and HTTPS NodePorts are `30081` and `30444`;
- `headlamp/headlamp` uses ingress class `nginx`;
- a request with host header `headlamp.apps.example.com` succeeds through
  NodePort `30081`;
- the old Headlamp NodePort `30080` remains available as the rollback path
  until a separate removal change is approved.

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

If Helm cannot restore service, keep NGINX pointed to Headlamp NodePort
`30080`, record the incident, and stop further platform deployment.

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
