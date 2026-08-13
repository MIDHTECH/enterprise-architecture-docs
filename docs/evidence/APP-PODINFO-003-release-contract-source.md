# APP-PODINFO-003 Application Release Contract Source

Date: 2026-08-13

## Decision

Podinfo now has an application-specific release contract in the two existing
platform repositories that already own Jenkins behavior. The application code
stays in `midhhealth/applications/podinfo`; the shared library owns reusable
Helm behavior; the Job DSL repository owns the generated Jenkins job. These
projects are linked by explicit revisions instead of being combined.

| Project | Verified revision | CI evidence | Responsibility |
| --- | --- | --- | --- |
| `midhhealth/platform-delivery/jenkins-shared-library` | `71c5b28811630aa1bdc5ac2d5395660f8f6afec6` | pipeline `656`, passed | Reusable `applicationHelmPipeline` PLAN/DEPLOY/ROLLBACK and acceptance behavior |
| `midhhealth/platform-delivery/jenkins-jobs` | `8adccc2e6de77d37bf6104f82d8832030409fc62` | pipeline `657`, passed | Manual `projects/deploy-podinfo` job definition |
| `midhhealth/applications/podinfo` | current protected `main` | application pipeline recorded separately | Application chart, values, source and release history |

## Contract behavior

The reusable library requires a registry-qualified image repository and an
immutable `sha256` digest for PLAN and DEPLOY. It renders the application-owned
chart and values, rejects the pending digest marker, runs a server-side Helm
dry run for PLAN, and requires `CONFIRM_CHANGE` for DEPLOY or ROLLBACK. After a
mutating action it checks rollout, ClusterIP-only exposure, the required pod
security context, the running digest, `/readyz`, and `/healthz` through a local
port-forward.

The Job DSL binds that behavior to the private Podinfo repository, the existing
`kubernetes-deployer` agent, namespace and release `podinfo`, and the existing
`kubernetes-production-kubeconfig` credential ID. It has no trigger and does
not call AWX or Ansible. VM configuration remains owned by AWX/Ansible; the
application Helm release remains owned by Jenkins and the application project.

## Current boundary

The source definitions and their GitLab validation pipelines pass. The Jenkins
seed job has not yet been authenticated and run for this revision, so this
evidence does not claim that `projects/deploy-podinfo` exists on the controller.
It also does not claim a Harbor digest, Helm PLAN, deployment, or rollback.
