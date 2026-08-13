# Enterprise Kubernetes Platform with GitOps: Detailed Use Cases

Last verified: 2026-08-13

This index contains all 13 canonical use cases owned by the
Enterprise Kubernetes Platform with GitOps. Together they provide a controlled runtime for provider, payer, data, and platform workloads. Implementation belongs
in `midhhealth/platform-engineering/kubernetes-platform-gitops` and must reuse existing four-node application cluster, jenkins-agent01, GitLab, Jenkins, and accepted storage and ingress.

No page in this directory authorizes a new cluster, node, VM, IP address, load balancer, storage system, or unapproved add-on. All pages begin as
planned specifications; their individual status changes only after source,
runtime, rollback, and evidence gates are met.

| ID | Use case | Canonical coverage |
| --- | --- | --- |
| `UC-K8S-002` | [AKS/EKS/GKE Cluster Provisioning Automation](UC-K8S-002-aks-eks-gke-cluster-provisioning-automation.md) | Future scope: Terraform patterns remain planned; managed-cloud deployment and acceptance are deferred |
| `UC-K8S-001` | [Kubernetes Configuration Drift](UC-K8S-001-kubernetes-configuration-drift.md) | Live cluster state is compared with Git-defined desired state |
| `UC-K8S-003` | [Kubernetes Application Deployment](UC-K8S-003-kubernetes-application-deployment.md) | Helm/Kustomize deploy application workloads |
| `UC-K8S-004` | [GitOps Reconciliation](UC-K8S-004-gitops-reconciliation.md) | Argo CD or Flux restores approved desired state and records sync health |
| `UC-K8S-005` | [Continuous Verification](UC-K8S-005-continuous-verification.md) | Rollouts check latency, errors, restarts and alert state before promotion |
| `UC-K8S-006` | [Kubernetes Security Baseline Implementation](UC-K8S-006-kubernetes-security-baseline-implementation.md) | Policies enforce pod and namespace standards |
| `UC-K8S-007` | [Kubernetes Security Policy Enforcement](UC-K8S-007-kubernetes-security-policy-enforcement.md) | OPA Gatekeeper/Kyverno blocks unsafe workloads |
| `UC-K8S-008` | [Kubernetes Policy-as-Code Governance](UC-K8S-008-kubernetes-policy-as-code-governance.md) | Cluster rules are version-controlled |
| `UC-K8S-009` | [Ingress and Traffic Management Standardization](UC-K8S-009-ingress-and-traffic-management-standardization.md) | Common ingress, TLS, DNS, and routing pattern |
| `UC-K8S-010` | [Workload Right-Sizing](UC-K8S-010-workload-right-sizing.md) | CPU and memory requests are adjusted from observed utilization |
| `UC-K8S-011` | [Container Registry and Image Supply Chain Security](UC-K8S-011-container-registry-and-image-supply-chain-security.md) | Trusted registries and image scanning controls |
| `UC-K8S-012` | [Event-Driven Autoscaling](UC-K8S-012-event-driven-autoscaling.md) | Workloads scale from queues, events or custom metrics |
| `UC-K8S-013` | [Kubernetes Cost Allocation](UC-K8S-013-kubernetes-cost-allocation.md) | Namespace and workload usage is attributed to teams and applications |

## GitLab handoff

1. Create the epic and stories from the selected page in `midhhealth/platform-engineering/kubernetes-platform-gitops`.
2. Implement only the planned paths that fit the repository and current lab.
3. Run fixture or read-only validation before requesting a mutating change.
4. Return commit, pipeline, Jenkins/AWX, runtime, recovery, and incident
   evidence to the architecture page.
5. Stop and request a separate architecture decision if new infrastructure,
   capacity, products, or protected-data integration would be required.
