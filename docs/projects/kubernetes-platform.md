# Kubernetes Platform Domain

**Repository:** `midhhealth/platform-engineering/kubernetes-platform-gitops`  
**Team size:** 6 engineers

## Team Responsibilities

The Kubernetes team owns the application runtime platform for containerized
care, payer, platform, data, AI, and observability workloads.

| Team member | Primary responsibility |
| --- | --- |
| Kubernetes Platform Lead | Owns cluster standards, roadmap, availability posture, upgrade policy, and platform adoption. |
| GitOps Engineer | Maintains Argo CD or Flux patterns, environment overlays, sync policies, and reconciliation evidence. |
| Cluster Operations Engineer | Owns cluster lifecycle, node pools, upgrades, ingress, storage, DNS, and backup patterns. |
| Platform Security Engineer | Maintains RBAC, namespace controls, admission policies, image trust, and workload baseline rules. |
| Release Reliability Engineer | Implements progressive delivery, automated rollback, continuous verification, and deployment health gates. |
| Resource Optimization Engineer | Handles right-sizing, autoscaling, capacity reports, and Kubernetes cost allocation. |

## Connected Teams

- Receives infrastructure and network foundations from platform engineering.
- Publishes workload runtime patterns to delivery, observability, governance, data, AI, and MLOps.
- Sends runtime telemetry to SRE and operational evidence to governance.

## Executable Use-Case Scope

- Kubernetes configuration drift monitoring and GitOps reconciliation.
- Progressive delivery, canary/blue-green rollout, continuous verification, and automated rollback.
- Policy enforcement for namespace, workload, image, and security controls.
- Workload right-sizing, event-driven autoscaling, and cost allocation.
- Cluster configuration validation and runtime readiness checks.
