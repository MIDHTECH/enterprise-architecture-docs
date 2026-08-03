# CHG-2026-009 Kubernetes Ingress PLAN Evidence

Date: 2026-08-03

## Control-plane and source gates

- Canonical documentation main revision before the retry:
  `58d9be4deab92f30b7e4b96adba0b3b0a96520b1`; GitLab pipeline 517 passed.
- Jenkins job: `projects/deploy-kubernetes-ingress`.
- Jenkins executor: `jenkins-agent01`; the controller remains at zero
  executors.
- Source revision:
  `e34bd5477472a6d21c6a5d1933a0d95b5c3ebc55`.
- Shared-library revision:
  `b23d3a4e9ae0db9f398f77554e7559acad839088`.
- Credential: folder-scoped secret file
  `kubernetes-production-kubeconfig`.
- Both mode-0600 temporary kubeconfig copies were securely removed after
  upload and their absence was verified.

PLAN build 1 failed safely before source checkout because existing deploy key
`Jenkins SCM read-only` was not enabled on the source project. GitLab's own
idempotent `Projects::EnableDeployKeyService` joined existing key 2 to project
14; before/after validation was `false`/`true` and `can_push=false`. No new key
or write permission was introduced.

## Accepted PLAN build 2

| Parameter | Value |
| --- | --- |
| `GIT_BRANCH` | `e34bd5477472a6d21c6a5d1933a0d95b5c3ebc55` |
| `ACTION` | `PLAN` |
| `CONFIRM_CHANGE` | `false` |
| `ROLLBACK_REVISION` | empty |
| `KUBECONFIG_CREDENTIAL_ID` | `kubernetes-production-kubeconfig` |

Build 2 finished SUCCESS and recorded:

- exact detached checkout `e34bd547`;
- Helm `v4.1.0` and kubectl client `v1.34.10`;
- application API endpoint `https://k8s-control.example.com:6443`;
- ingress-nginx chart 4.15.0 and controller 1.15.1 image digest
  `sha256:594ceea76b01c592858f803f9ff4d2cb40542cae2060410b2c95f75907d659e1`;
- one controller replica and NodePorts 30081/30444 in the rendered manifest;
- `helm upgrade --install --dry-run=server --hide-secret` with description
  `Dry run complete`;
- no `client-certificate-data`, `client-key-data`, token field, or complete
  kubeconfig structure in console output.

## Post-PLAN runtime proof

- Context: `kubernetes-admin@kubernetes`.
- Client and server: Kubernetes `v1.34.10`.
- Ready nodes: `k8s-control.example.com`, `k8s-worker01.example.com`,
  `k8s-worker02.example.com`, and `k8s-worker03.example.com`.
- `IngressClass` count: 0.
- cluster-wide `Ingress` count: 0.
- `ingress-nginx` namespace count: 0.
- Existing Headlamp NodePort: 30080.
- Active Jenkins queue after the run: empty.

The PLAN was non-mutating. No Helm release, namespace, ingress class, ingress,
controller, 30081 listener, or 30444 listener exists.

## Firewall prerequisite

Firewalld is running on all four Kubernetes nodes. Active-zone and rich/direct
rule inspection found no rule admitting TCP 30081 only from
`nginx.example.com` (`192.168.1.114`). The reviewed Ansible prerequisite is
therefore required before DEPLOY. It must not open 30081 or 30444 generally,
and the existing Headlamp NodePort 30080 must remain available.

DEPLOY is not authorized by this evidence. CHG-2026-009 remains stopped for
explicit operator authorization of the reviewed firewall prerequisite and the
Jenkins `ACTION=DEPLOY`, `CONFIRM_CHANGE=true` run.
