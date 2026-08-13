# MidhHealth Use-Case Interview Question Bank

Last generated from the canonical detailed pages: 2026-08-13

## How to use this bank

This bank is organized by platform and covers every detailed use case exactly once.
The opening questions test whether someone understands the platform boundary; the
use-case questions test whether they can turn that architecture into a safe, buildable
and supportable capability.

These are conversations, not trivia. A strong answer should name the outcome, owner,
architecture, current lab boundary, security controls, failure behavior, recovery and
evidence. When runtime evidence does not exist, the candidate should say what is designed
or source-testable instead of inventing production experience.

Use the companion [MidhHealth reference architecture](new-employee-platform-briefing.md)
for the common architecture story.

## Follow-up ladder for any question

1. What user or operating outcome are you protecting?
2. Which platform owns the decision, and what does it consume or emit?
3. What would you implement first in the existing lab?
4. What identity, secret, review and policy boundaries apply?
5. What is the most dangerous plausible failure, and what stops the blast radius?
6. Which negative test, runtime signal and recovery exercise would prove the design?
7. What is the trade-off, and what evidence would cause you to revisit it?
8. Is the answer architecture, source implementation, runtime verification or accepted evidence?

## Interviewer scoring guide

| Signal | Weak answer | Strong answer |
| --- | --- | --- |
| Ownership | Lists tools | Separates accountable owner, platform owner and consuming teams |
| Architecture | Draws boxes only | Explains control/data flow, trust boundaries and handoffs |
| Implementation | Says ‘automate it’ | Names source locations, stages, identities and current lab target |
| Reliability | Restarts or retries first | Defines failure modes, stop conditions, rollback and data safety |
| Evidence | Relies on a green job or screenshot | Binds revision, execution, target, result, negative test and recovery |
| Honesty | Presents planned work as production experience | Clearly distinguishes design, source, runtime and acceptance |

## DevSecOps Delivery

Platform detail: [DevSecOps Delivery](projects/devsecops-delivery.md)

### Platform questions

- Explain why GitLab, Jenkins, AWX and the runtime have separate responsibilities in this delivery platform.
- How would you onboard a new application without copying pipeline logic or giving its build excessive credentials?
- A release is fast but difficult to reproduce or roll back. Which platform contract is missing?

### Questions tied to detailed use cases

| Use case | Primary question | Interviewer probe |
| --- | --- | --- |
| [UC-CICD-001: End-to-End CI/CD Pipeline Setup](use-cases/devsecops/UC-CICD-001-end-to-end-cicd-pipeline.md) | Where does End-to-End CI/CD Pipeline Setup sit in the path from reviewed source to release decision, and which condition must stop the flow? | Separate GitLab, Jenkins, AWX and runtime ownership; name the immutable revision and rollback point. |
| [UC-CICD-002: Automated Build Pipeline](use-cases/devsecops/UC-CICD-002-automated-build-pipeline.md) | How would you implement Automated Build Pipeline across several repositories without turning Jenkins into hand-maintained configuration? | Discuss Job DSL, shared libraries, agent isolation, credential scope and repository-owned configuration. |
| [UC-CICD-003: Automated Unit Testing in CI](use-cases/devsecops/UC-CICD-003-automated-unit-testing-in-ci.md) | Which failure modes in Automated Unit Testing in CI could create a false pass or an unsafe release, and how would you contain them? | Discuss fail-closed behavior, retry boundaries, artifact identity, credential exposure and the previous known-good release. |
| [UC-CICD-004: Code Quality Gate Integration](use-cases/devsecops/UC-CICD-004-code-quality-gate-integration.md) | What evidence would convince you that Code Quality Gate Integration protects release speed rather than merely adding another green stage? | Ask for a deliberate failure, queue/build timing, policy result, artifact digest and post-release health signal. |
| [UC-CICD-005: Artifact Management Automation](use-cases/devsecops/UC-CICD-005-artifact-management-automation.md) | Where does Artifact Management Automation sit in the path from reviewed source to release decision, and which condition must stop the flow? | Separate GitLab, Jenkins, AWX and runtime ownership; name the immutable revision and rollback point. |
| [UC-CICD-006: Docker Image Build and Registry Push](use-cases/devsecops/UC-CICD-006-docker-image-build-and-registry-push.md) | How would you implement Docker Image Build and Registry Push across several repositories without turning Jenkins into hand-maintained configuration? | Discuss Job DSL, shared libraries, agent isolation, credential scope and repository-owned configuration. |
| [UC-CICD-007: Environment-Based Release Promotion](use-cases/devsecops/UC-CICD-007-environment-based-release-promotion.md) | Which failure modes in Environment-Based Release Promotion could create a false pass or an unsafe release, and how would you contain them? | Discuss fail-closed behavior, retry boundaries, artifact identity, credential exposure and the previous known-good release. |
| [UC-CICD-008: Automated Rollback Controller](use-cases/devsecops/UC-CICD-008-automated-rollback-controller.md) | What evidence would convince you that Automated Rollback Controller protects release speed rather than merely adding another green stage? | Ask for a deliberate failure, queue/build timing, policy result, artifact digest and post-release health signal. |
| [UC-CICD-009: Pipeline Template Standardization](use-cases/devsecops/UC-CICD-009-pipeline-template-standardization.md) | Where does Pipeline Template Standardization sit in the path from reviewed source to release decision, and which condition must stop the flow? | Separate GitLab, Jenkins, AWX and runtime ownership; name the immutable revision and rollback point. |
| [UC-CICD-010: Secure CI/CD Pipeline Implementation](use-cases/devsecops/UC-CICD-010-secure-ci-cd-pipeline-implementation.md) | How would you implement Secure CI/CD Pipeline Implementation across several repositories without turning Jenkins into hand-maintained configuration? | Discuss Job DSL, shared libraries, agent isolation, credential scope and repository-owned configuration. |
| [UC-CICD-011: Secrets Detection in Source Code](use-cases/devsecops/UC-CICD-011-secrets-detection-in-source-code.md) | Which failure modes in Secrets Detection in Source Code could create a false pass or an unsafe release, and how would you contain them? | Discuss fail-closed behavior, retry boundaries, artifact identity, credential exposure and the previous known-good release. |
| [UC-CICD-012: Container Image Vulnerability Scanning](use-cases/devsecops/UC-CICD-012-container-image-vulnerability-scanning.md) | What evidence would convince you that Container Image Vulnerability Scanning protects release speed rather than merely adding another green stage? | Ask for a deliberate failure, queue/build timing, policy result, artifact digest and post-release health signal. |
| [UC-CICD-013: Dependency Vulnerability Management](use-cases/devsecops/UC-CICD-013-dependency-vulnerability-management.md) | Where does Dependency Vulnerability Management sit in the path from reviewed source to release decision, and which condition must stop the flow? | Separate GitLab, Jenkins, AWX and runtime ownership; name the immutable revision and rollback point. |
| [UC-CICD-014: Terraform Plan Automation](use-cases/devsecops/UC-CICD-014-terraform-plan-automation.md) | How would you implement Terraform Plan Automation across several repositories without turning Jenkins into hand-maintained configuration? | Discuss Job DSL, shared libraries, agent isolation, credential scope and repository-owned configuration. |
| [UC-CICD-015: Deployment Health Scoring](use-cases/devsecops/UC-CICD-015-deployment-health-scoring.md) | Which failure modes in Deployment Health Scoring could create a false pass or an unsafe release, and how would you contain them? | Discuss fail-closed behavior, retry boundaries, artifact identity, credential exposure and the previous known-good release. |
| [UC-CICD-016: Cross-Project Release Contract Validation](use-cases/devsecops/UC-CICD-016-cross-project-release-contract-validation.md) | What evidence would convince you that Cross-Project Release Contract Validation protects release speed rather than merely adding another green stage? | Ask for a deliberate failure, queue/build timing, policy result, artifact digest and post-release health signal. |

## Multi-Cloud Infrastructure

Platform detail: [Multi-Cloud Infrastructure](projects/multi-cloud-infrastructure.md)

### Platform questions

- How do reusable Terraform modules, environment roots and remote state boundaries fit together?
- How would you compare on-premises, AWS, Azure and GCP placement without pretending the providers are identical?
- What makes an infrastructure plan safe enough for a human to approve?

### Questions tied to detailed use cases

| Use case | Primary question | Interviewer probe |
| --- | --- | --- |
| [UC-INFRA-001: Terraform Drift Detection](use-cases/infrastructure/UC-INFRA-001-terraform-drift-detection.md) | Where does Terraform Drift Detection fit between reusable modules, environment ownership, state and post-provision configuration? | Cover typed module interfaces, environment roots, backend identity, locking and short-lived execution identity. |
| [UC-INFRA-002: Azure Infrastructure Provisioning Using Terraform](use-cases/infrastructure/UC-INFRA-002-azure-infrastructure-provisioning-using-terraform.md) | What is the smallest buildable lab slice for Azure Infrastructure Provisioning Using Terraform, and what remains conditional on an unavailable target or product? | Use contracts, fixtures and plan parsing first; do not claim a cloud resource from a local test. |
| [UC-INFRA-003: AWS VPC Landing Zone Setup](use-cases/infrastructure/UC-INFRA-003-aws-vpc-landing-zone-setup.md) | If AWS VPC Landing Zone Setup leaves unexpected or partial state, how do you decide whether to repair, reconcile or stop? | Preserve state lineage, identify the active owner and avoid automatic reconciliation of unexplained differences. |
| [UC-INFRA-004: Terraform Plan Analyzer](use-cases/infrastructure/UC-INFRA-004-terraform-plan-analyzer.md) | Which plan, state and service-impact evidence must accompany Terraform Plan Analyzer before and after mutation? | Include module/provider versions, saved-plan digest, policy/cost result, approvals, state serial and health verification. |
| [UC-INFRA-005: Server Configuration Automation Using Ansible](use-cases/infrastructure/UC-INFRA-005-server-configuration-automation-using-ansible.md) | Where does Server Configuration Automation Using Ansible fit between reusable modules, environment ownership, state and post-provision configuration? | Cover typed module interfaces, environment roots, backend identity, locking and short-lived execution identity. |
| [UC-INFRA-006: Linux Server Patch Automation](use-cases/infrastructure/UC-INFRA-006-linux-server-patch-automation.md) | What is the smallest buildable lab slice for Linux Server Patch Automation, and what remains conditional on an unavailable target or product? | Use contracts, fixtures and plan parsing first; do not claim a cloud resource from a local test. |
| [UC-INFRA-007: Infrastructure Change Impact Analysis](use-cases/infrastructure/UC-INFRA-007-infrastructure-change-impact-analysis.md) | If Infrastructure Change Impact Analysis leaves unexpected or partial state, how do you decide whether to repair, reconcile or stop? | Preserve state lineage, identify the active owner and avoid automatic reconciliation of unexplained differences. |
| [UC-INFRA-008: Cloud Resource Tagging Automation](use-cases/infrastructure/UC-INFRA-008-cloud-resource-tagging-automation.md) | Which plan, state and service-impact evidence must accompany Cloud Resource Tagging Automation before and after mutation? | Include module/provider versions, saved-plan digest, policy/cost result, approvals, state serial and health verification. |
| [UC-INFRA-009: Terraform State Integrity Monitoring](use-cases/infrastructure/UC-INFRA-009-terraform-state-integrity-monitoring.md) | Where does Terraform State Integrity Monitoring fit between reusable modules, environment ownership, state and post-provision configuration? | Cover typed module interfaces, environment roots, backend identity, locking and short-lived execution identity. |
| [UC-INFRA-010: Environment Standardization Across Dev/Test/Prod](use-cases/infrastructure/UC-INFRA-010-environment-standardization-across-dev-test-prod.md) | What is the smallest buildable lab slice for Environment Standardization Across Dev/Test/Prod, and what remains conditional on an unavailable target or product? | Use contracts, fixtures and plan parsing first; do not claim a cloud resource from a local test. |
| [UC-INFRA-011: Infrastructure Reconciliation Loop](use-cases/infrastructure/UC-INFRA-011-infrastructure-reconciliation-loop.md) | If Infrastructure Reconciliation Loop leaves unexpected or partial state, how do you decide whether to repair, reconcile or stop? | Preserve state lineage, identify the active owner and avoid automatic reconciliation of unexplained differences. |
| [UC-INFRA-012: Policy-Driven Provisioning](use-cases/infrastructure/UC-INFRA-012-policy-driven-provisioning.md) | Which plan, state and service-impact evidence must accompany Policy-Driven Provisioning before and after mutation? | Include module/provider versions, saved-plan digest, policy/cost result, approvals, state serial and health verification. |

## Kubernetes Platform

Platform detail: [Kubernetes Platform](projects/kubernetes-platform.md)

### Platform questions

- Describe the namespace and workload contract an application must satisfy before it can run on the shared cluster.
- How do Jenkins, Helm and Argo CD avoid becoming competing reconcilers?
- A Kubernetes application is unavailable. How do you troubleshoot from the user path inward?

### Questions tied to detailed use cases

| Use case | Primary question | Interviewer probe |
| --- | --- | --- |
| [UC-K8S-001: Kubernetes Configuration Drift](use-cases/kubernetes/UC-K8S-001-kubernetes-configuration-drift.md) | Where does Kubernetes Configuration Drift fit in the workload or cluster contract, and who owns each side of that boundary? | Name namespace, identity, image, resources, network, storage, telemetry and recovery ownership. |
| [UC-K8S-002: AKS/EKS/GKE Cluster Provisioning Automation](use-cases/kubernetes/UC-K8S-002-aks-eks-gke-cluster-provisioning-automation.md) | What is the first safe implementation slice for AKS/EKS/GKE Cluster Provisioning Automation on the existing four-node cluster without assuming a managed-cloud feature or uninstalled add-on? | Keep the kubeadm, private ingress and Longhorn boundaries explicit; defer AKS/EKS/GKE claims. |
| [UC-K8S-003: Kubernetes Application Deployment](use-cases/kubernetes/UC-K8S-003-kubernetes-application-deployment.md) | The evidence for Kubernetes Application Deployment disagrees with desired state or user experience. Which cluster, path and dependency checks come next? | Walk DNS, NGINX/ingress, Service, endpoints, pods, nodes, storage and downstream services. |
| [UC-K8S-004: GitOps Reconciliation](use-cases/kubernetes/UC-K8S-004-gitops-reconciliation.md) | What success, negative, drift and rollback evidence would you require before accepting GitOps Reconciliation? | Tie desired-state and image digests to policy, route, rollout, health, exposure and recovery results. |
| [UC-K8S-005: Continuous Verification](use-cases/kubernetes/UC-K8S-005-continuous-verification.md) | Where does Continuous Verification fit in the workload or cluster contract, and who owns each side of that boundary? | Name namespace, identity, image, resources, network, storage, telemetry and recovery ownership. |
| [UC-K8S-006: Kubernetes Security Baseline Implementation](use-cases/kubernetes/UC-K8S-006-kubernetes-security-baseline-implementation.md) | What is the first safe implementation slice for Kubernetes Security Baseline Implementation on the existing four-node cluster without assuming a managed-cloud feature or uninstalled add-on? | Keep the kubeadm, private ingress and Longhorn boundaries explicit; defer AKS/EKS/GKE claims. |
| [UC-K8S-007: Kubernetes Security Policy Enforcement](use-cases/kubernetes/UC-K8S-007-kubernetes-security-policy-enforcement.md) | The evidence for Kubernetes Security Policy Enforcement disagrees with desired state or user experience. Which cluster, path and dependency checks come next? | Walk DNS, NGINX/ingress, Service, endpoints, pods, nodes, storage and downstream services. |
| [UC-K8S-008: Kubernetes Policy-as-Code Governance](use-cases/kubernetes/UC-K8S-008-kubernetes-policy-as-code-governance.md) | What success, negative, drift and rollback evidence would you require before accepting Kubernetes Policy-as-Code Governance? | Tie desired-state and image digests to policy, route, rollout, health, exposure and recovery results. |
| [UC-K8S-009: Ingress and Traffic Management Standardization](use-cases/kubernetes/UC-K8S-009-ingress-and-traffic-management-standardization.md) | Where does Ingress and Traffic Management Standardization fit in the workload or cluster contract, and who owns each side of that boundary? | Name namespace, identity, image, resources, network, storage, telemetry and recovery ownership. |
| [UC-K8S-010: Workload Right-Sizing](use-cases/kubernetes/UC-K8S-010-workload-right-sizing.md) | What is the first safe implementation slice for Workload Right-Sizing on the existing four-node cluster without assuming a managed-cloud feature or uninstalled add-on? | Keep the kubeadm, private ingress and Longhorn boundaries explicit; defer AKS/EKS/GKE claims. |
| [UC-K8S-011: Container Registry and Image Supply Chain Security](use-cases/kubernetes/UC-K8S-011-container-registry-and-image-supply-chain-security.md) | The evidence for Container Registry and Image Supply Chain Security disagrees with desired state or user experience. Which cluster, path and dependency checks come next? | Walk DNS, NGINX/ingress, Service, endpoints, pods, nodes, storage and downstream services. |
| [UC-K8S-012: Event-Driven Autoscaling](use-cases/kubernetes/UC-K8S-012-event-driven-autoscaling.md) | What success, negative, drift and rollback evidence would you require before accepting Event-Driven Autoscaling? | Tie desired-state and image digests to policy, route, rollout, health, exposure and recovery results. |
| [UC-K8S-013: Kubernetes Cost Allocation](use-cases/kubernetes/UC-K8S-013-kubernetes-cost-allocation.md) | Where does Kubernetes Cost Allocation fit in the workload or cluster contract, and who owns each side of that boundary? | Name namespace, identity, image, resources, network, storage, telemetry and recovery ownership. |

## Observability and SRE

Platform detail: [Observability and SRE](projects/observability-sre.md)

### Platform questions

- How do metrics, logs, traces, synthetic checks and release markers become one investigation path?
- What information must every application add before a dashboard or alert can be considered owned?
- How do you distinguish no telemetry from a healthy service?

### Questions tied to detailed use cases

| Use case | Primary question | Interviewer probe |
| --- | --- | --- |
| [UC-OBS-001: SLO as Code](use-cases/observability/UC-OBS-001-slo-as-code.md) | For SLO as Code, what user or operator decision should the signal support, and how would you keep it release-aware? | Require service, environment, owner and artifact/release identity; avoid patient/member data in labels. |
| [UC-OBS-002: Kubernetes Cluster Health Monitoring](use-cases/observability/UC-OBS-002-kubernetes-cluster-health-monitoring.md) | How would you build Kubernetes Cluster Health Monitoring using the existing Prometheus, Grafana, Loki, Tempo, OpenTelemetry and Elastic paths? | Start with fixture-validated configuration and one bounded service pack rather than adding another backend. |
| [UC-OBS-003: OpenTelemetry Auto-Instrumentation](use-cases/observability/UC-OBS-003-opentelemetry-auto-instrumentation.md) | OpenTelemetry Auto-Instrumentation becomes noisy, incomplete or contradictory during an incident. How do you protect the telemetry platform and continue diagnosis? | Discuss missing coverage, cardinality, sampling, clock alignment, alert grouping and direct source queries. |
| [UC-OBS-004: Centralized Log Management](use-cases/observability/UC-OBS-004-centralized-log-management.md) | Which query, injected condition, route and recovery evidence would prove Centralized Log Management is actionable? | Ask for source revision, time window, expected/observed result, negative privacy check and rollback. |
| [UC-OBS-005: eBPF Observability](use-cases/observability/UC-OBS-005-ebpf-observability.md) | For eBPF Observability, what user or operator decision should the signal support, and how would you keep it release-aware? | Require service, environment, owner and artifact/release identity; avoid patient/member data in labels. |
| [UC-OBS-006: Alerting and On-Call Notification](use-cases/observability/UC-OBS-006-alerting-and-on-call-notification.md) | How would you build Alerting and On-Call Notification using the existing Prometheus, Grafana, Loki, Tempo, OpenTelemetry and Elastic paths? | Start with fixture-validated configuration and one bounded service pack rather than adding another backend. |
| [UC-OBS-007: Production Incident Troubleshooting Dashboard](use-cases/observability/UC-OBS-007-production-incident-troubleshooting-dashboard.md) | Production Incident Troubleshooting Dashboard becomes noisy, incomplete or contradictory during an incident. How do you protect the telemetry platform and continue diagnosis? | Discuss missing coverage, cardinality, sampling, clock alignment, alert grouping and direct source queries. |
| [UC-OBS-008: Deployment Health Scoring](use-cases/observability/UC-OBS-008-deployment-health-scoring.md) | Which query, injected condition, route and recovery evidence would prove Deployment Health Scoring is actionable? | Ask for source revision, time window, expected/observed result, negative privacy check and rollback. |
| [UC-OBS-009: API Error Rate Monitoring](use-cases/observability/UC-OBS-009-api-error-rate-monitoring.md) | For API Error Rate Monitoring, what user or operator decision should the signal support, and how would you keep it release-aware? | Require service, environment, owner and artifact/release identity; avoid patient/member data in labels. |
| [UC-OBS-010: Database Performance Monitoring](use-cases/observability/UC-OBS-010-database-performance-monitoring.md) | How would you build Database Performance Monitoring using the existing Prometheus, Grafana, Loki, Tempo, OpenTelemetry and Elastic paths? | Start with fixture-validated configuration and one bounded service pack rather than adding another backend. |
| [UC-OBS-011: Telemetry Cost Optimization](use-cases/observability/UC-OBS-011-telemetry-cost-optimization.md) | Telemetry Cost Optimization becomes noisy, incomplete or contradictory during an incident. How do you protect the telemetry platform and continue diagnosis? | Discuss missing coverage, cardinality, sampling, clock alignment, alert grouping and direct source queries. |
| [UC-OBS-012: Synthetic Monitoring](use-cases/observability/UC-OBS-012-synthetic-monitoring.md) | Which query, injected condition, route and recovery evidence would prove Synthetic Monitoring is actionable? | Ask for source revision, time window, expected/observed result, negative privacy check and rollback. |
| [UC-OBS-013: Cloud-Native Monitoring](use-cases/observability/UC-OBS-013-cloud-native-monitoring.md) | For Cloud-Native Monitoring, what user or operator decision should the signal support, and how would you keep it release-aware? | Require service, environment, owner and artifact/release identity; avoid patient/member data in labels. |
| [UC-OBS-014: Change-to-Incident Correlation](use-cases/observability/UC-OBS-014-change-to-incident-correlation.md) | How would you build Change-to-Incident Correlation using the existing Prometheus, Grafana, Loki, Tempo, OpenTelemetry and Elastic paths? | Start with fixture-validated configuration and one bounded service pack rather than adding another backend. |
| [UC-OBS-015: Automated Incident Triage](use-cases/observability/UC-OBS-015-automated-incident-triage.md) | Automated Incident Triage becomes noisy, incomplete or contradictory during an incident. How do you protect the telemetry platform and continue diagnosis? | Discuss missing coverage, cardinality, sampling, clock alignment, alert grouping and direct source queries. |
| [UC-OBS-016: Burn-Rate Alerting](use-cases/observability/UC-OBS-016-burn-rate-alerting.md) | Which query, injected condition, route and recovery evidence would prove Burn-Rate Alerting is actionable? | Ask for source revision, time window, expected/observed result, negative privacy check and rollback. |

## Governance and Operations Automation

Platform detail: [Governance and Operations Automation](projects/governance-operations.md)

### Platform questions

- How does this platform turn policy intent into an executable control without removing human accountability?
- Explain the separation between detection, approval, remediation and acceptance evidence.
- When should a governance gate fail closed, and how are time-bound exceptions handled?

### Questions tied to detailed use cases

| Use case | Primary question | Interviewer probe |
| --- | --- | --- |
| [UC-GOV-001: Automated Compliance Evidence Collection](use-cases/governance/UC-GOV-001-compliance-evidence-collection.md) | How would you design Automated Compliance Evidence Collection so its scope, identity, owner, observation and decision remain auditable? | Name the control intent, assets, principals, allowed actions, policy version, evidence and retention owner. |
| [UC-GOV-002: Secrets Management Automation](use-cases/governance/UC-GOV-002-secrets-management-automation.md) | What can be implemented for Secrets Management Automation with fixtures and read-only checks before any live enforcement is approved? | Use schemas, mocked APIs and deterministic policy results; distinguish detection from enforcement. |
| [UC-GOV-003: Secure Secrets Management for Applications](use-cases/governance/UC-GOV-003-secure-secrets-management-for-applications.md) | Automation for Secure Secrets Management for Applications has partial coverage or begins harming service health. What stops it, and who takes control? | Require a stop condition, preserve action history and return authority to the service or incident owner. |
| [UC-GOV-004: Cloud IAM and RBAC Standardization](use-cases/governance/UC-GOV-004-cloud-iam-and-rbac-standardization.md) | Which positive, negative, inaccessible-scope and expiry tests would you use to accept Cloud IAM and RBAC Standardization? | Do not turn unobserved scope into compliance; include exception and recovery behavior. |
| [UC-GOV-005: Secrets Management with Key Vault](use-cases/governance/UC-GOV-005-secrets-management-with-key-vault.md) | How would you design Secrets Management with Key Vault so its scope, identity, owner, observation and decision remain auditable? | Name the control intent, assets, principals, allowed actions, policy version, evidence and retention owner. |
| [UC-GOV-006: Cloud Misconfiguration Detector](use-cases/governance/UC-GOV-006-cloud-misconfiguration-detector.md) | What can be implemented for Cloud Misconfiguration Detector with fixtures and read-only checks before any live enforcement is approved? | Use schemas, mocked APIs and deterministic policy results; distinguish detection from enforcement. |
| [UC-GOV-007: Infrastructure Security Hardening](use-cases/governance/UC-GOV-007-infrastructure-security-hardening.md) | Automation for Infrastructure Security Hardening has partial coverage or begins harming service health. What stops it, and who takes control? | Require a stop condition, preserve action history and return authority to the service or incident owner. |
| [UC-GOV-008: Private Endpoint Implementation](use-cases/governance/UC-GOV-008-private-endpoint-implementation.md) | Which positive, negative, inaccessible-scope and expiry tests would you use to accept Private Endpoint Implementation? | Do not turn unobserved scope into compliance; include exception and recovery behavior. |
| [UC-GOV-009: DNS and Certificate Management](use-cases/governance/UC-GOV-009-dns-and-certificate-management.md) | How would you design DNS and Certificate Management so its scope, identity, owner, observation and decision remain auditable? | Name the control intent, assets, principals, allowed actions, policy version, evidence and retention owner. |
| [UC-GOV-010: Certificate Expiry Monitoring](use-cases/governance/UC-GOV-010-certificate-expiry-monitoring.md) | What can be implemented for Certificate Expiry Monitoring with fixtures and read-only checks before any live enforcement is approved? | Use schemas, mocked APIs and deterministic policy results; distinguish detection from enforcement. |
| [UC-GOV-011: Runbook Automation](use-cases/governance/UC-GOV-011-runbook-automation.md) | Automation for Runbook Automation has partial coverage or begins harming service health. What stops it, and who takes control? | Require a stop condition, preserve action history and return authority to the service or incident owner. |
| [UC-GOV-012: Event-Driven Remediation](use-cases/governance/UC-GOV-012-event-driven-remediation.md) | Which positive, negative, inaccessible-scope and expiry tests would you use to accept Event-Driven Remediation? | Do not turn unobserved scope into compliance; include exception and recovery behavior. |
| [UC-GOV-013: Human-in-the-Loop Remediation](use-cases/governance/UC-GOV-013-human-in-the-loop-remediation.md) | How would you design Human-in-the-Loop Remediation so its scope, identity, owner, observation and decision remain auditable? | Name the control intent, assets, principals, allowed actions, policy version, evidence and retention owner. |
| [UC-GOV-014: Closed-Loop Automation](use-cases/governance/UC-GOV-014-closed-loop-automation.md) | What can be implemented for Closed-Loop Automation with fixtures and read-only checks before any live enforcement is approved? | Use schemas, mocked APIs and deterministic policy results; distinguish detection from enforcement. |
| [UC-GOV-015: Self-Healing Infrastructure](use-cases/governance/UC-GOV-015-self-healing-infrastructure.md) | Automation for Self-Healing Infrastructure has partial coverage or begins harming service health. What stops it, and who takes control? | Require a stop condition, preserve action history and return authority to the service or incident owner. |
| [UC-GOV-016: Cloud Cost Anomaly Detection](use-cases/governance/UC-GOV-016-cloud-cost-anomaly-detection.md) | Which positive, negative, inaccessible-scope and expiry tests would you use to accept Cloud Cost Anomaly Detection? | Do not turn unobserved scope into compliance; include exception and recovery behavior. |
| [UC-GOV-017: Resource Right-Sizing Automation](use-cases/governance/UC-GOV-017-resource-right-sizing-automation.md) | How would you design Resource Right-Sizing Automation so its scope, identity, owner, observation and decision remain auditable? | Name the control intent, assets, principals, allowed actions, policy version, evidence and retention owner. |
| [UC-GOV-018: Automated Root-Cause Analysis](use-cases/governance/UC-GOV-018-automated-root-cause-analysis.md) | What can be implemented for Automated Root-Cause Analysis with fixtures and read-only checks before any live enforcement is approved? | Use schemas, mocked APIs and deterministic policy results; distinguish detection from enforcement. |
| [UC-GOV-019: Intelligent Alert Deduplication](use-cases/governance/UC-GOV-019-intelligent-alert-deduplication.md) | Automation for Intelligent Alert Deduplication has partial coverage or begins harming service health. What stops it, and who takes control? | Require a stop condition, preserve action history and return authority to the service or incident owner. |

## Linux Systems Engineering

Platform detail: [Linux Systems Engineering](projects/linux-systems.md)

### Platform questions

- Where does Linux platform ownership begin and end between infrastructure, network, Kubernetes and product teams?
- What does a safe Jenkins-to-AWX-to-Ansible change look like across a VM fleet?
- How do check mode, canaries, serial rollout and idempotence support different decisions?

### Questions tied to detailed use cases

| Use case | Primary question | Interviewer probe |
| --- | --- | --- |
| [UC-LNX-001: Ubuntu and Rocky Linux Installation Standards](use-cases/linux/UC-LNX-001-os-installation-standards.md) | Walk through Ubuntu and Rocky Linux Installation Standards as a controlled fleet change. What is inspected, changed, verified and handed back to the service owner? | Separate provisioned compute, OS desired state and application ownership; name the inventory limit. |
| [UC-LNX-002: KVM and libvirt Virtualization](use-cases/linux/UC-LNX-002-kvm-libvirt-virtualization.md) | How would you implement KVM and libvirt Virtualization in Ansible and AWX without hiding unsafe shell behavior or widening the inventory scope? | Discuss roles, playbook composition, strict Bash behavior, structured results, credentials and check output. |
| [UC-LNX-003: VM Provisioning with cloud-init](use-cases/linux/UC-LNX-003-vm-provisioning-cloud-init.md) | During VM Provisioning with cloud-init, the canary becomes unreachable or unhealthy. How do you stop the rollout and recover the host or service? | Use console or break-glass paths where necessary and preserve the failed task, journal and before-state. |
| [UC-LNX-004: Server Build and Retirement](use-cases/linux/UC-LNX-004-server-build-retirement.md) | What host-by-host, security, idempotence and recovery evidence would make Server Build and Retirement defensible? | Include Git revision, Jenkins/AWX IDs, canary, second convergence, service telemetry and reversal. |
| [UC-LNX-005: AWX and Ansible Configuration Management](use-cases/linux/UC-LNX-005-awx-ansible-configuration-management.md) | Walk through AWX and Ansible Configuration Management as a controlled fleet change. What is inspected, changed, verified and handed back to the service owner? | Separate provisioned compute, OS desired state and application ownership; name the inventory limit. |
| [UC-LNX-006: Operating-System Patching](use-cases/linux/UC-LNX-006-operating-system-patching.md) | How would you implement Operating-System Patching in Ansible and AWX without hiding unsafe shell behavior or widening the inventory scope? | Discuss roles, playbook composition, strict Bash behavior, structured results, credentials and check output. |
| [UC-LNX-007: Kernel and Major-Version Upgrades](use-cases/linux/UC-LNX-007-kernel-major-version-upgrades.md) | During Kernel and Major-Version Upgrades, the canary becomes unreachable or unhealthy. How do you stop the rollout and recover the host or service? | Use console or break-glass paths where necessary and preserve the failed task, journal and before-state. |
| [UC-LNX-008: SELinux and Firewall Management](use-cases/linux/UC-LNX-008-selinux-firewall-management.md) | What host-by-host, security, idempotence and recovery evidence would make SELinux and Firewall Management defensible? | Include Git revision, Jenkins/AWX IDs, canary, second convergence, service telemetry and reversal. |
| [UC-LNX-009: systemd Service Management](use-cases/linux/UC-LNX-009-systemd-service-management.md) | Walk through systemd Service Management as a controlled fleet change. What is inspected, changed, verified and handed back to the service owner? | Separate provisioned compute, OS desired state and application ownership; name the inventory limit. |
| [UC-LNX-010: Filesystem, LVM and Storage Management](use-cases/linux/UC-LNX-010-filesystem-lvm-storage-management.md) | How would you implement Filesystem, LVM and Storage Management in Ansible and AWX without hiding unsafe shell behavior or widening the inventory scope? | Discuss roles, playbook composition, strict Bash behavior, structured results, credentials and check output. |
| [UC-LNX-011: DNS, NTP and Host Networking](use-cases/linux/UC-LNX-011-dns-ntp-host-networking.md) | During DNS, NTP and Host Networking, the canary becomes unreachable or unhealthy. How do you stop the rollout and recover the host or service? | Use console or break-glass paths where necessary and preserve the failed task, journal and before-state. |
| [UC-LNX-012: SSH, sudo and Service Accounts](use-cases/linux/UC-LNX-012-ssh-sudo-service-accounts.md) | What host-by-host, security, idempotence and recovery evidence would make SSH, sudo and Service Accounts defensible? | Include Git revision, Jenkins/AWX IDs, canary, second convergence, service telemetry and reversal. |
| [UC-LNX-013: Package Repository Management](use-cases/linux/UC-LNX-013-package-repository-management.md) | Walk through Package Repository Management as a controlled fleet change. What is inspected, changed, verified and handed back to the service owner? | Separate provisioned compute, OS desired state and application ownership; name the inventory limit. |
| [UC-LNX-014: Performance and Capacity Troubleshooting](use-cases/linux/UC-LNX-014-performance-capacity-troubleshooting.md) | How would you implement Performance and Capacity Troubleshooting in Ansible and AWX without hiding unsafe shell behavior or widening the inventory scope? | Discuss roles, playbook composition, strict Bash behavior, structured results, credentials and check output. |
| [UC-LNX-015: Configuration-Drift Detection](use-cases/linux/UC-LNX-015-configuration-drift-detection.md) | During Configuration-Drift Detection, the canary becomes unreachable or unhealthy. How do you stop the rollout and recover the host or service? | Use console or break-glass paths where necessary and preserve the failed task, journal and before-state. |
| [UC-LNX-016: Server Compliance Evidence](use-cases/linux/UC-LNX-016-server-compliance-evidence.md) | What host-by-host, security, idempotence and recovery evidence would make Server Compliance Evidence defensible? | Include Git revision, Jenkins/AWX IDs, canary, second convergence, service telemetry and reversal. |
| [UC-LNX-017: Break-Glass Recovery](use-cases/linux/UC-LNX-017-break-glass-recovery.md) | Walk through Break-Glass Recovery as a controlled fleet change. What is inspected, changed, verified and handed back to the service owner? | Separate provisioned compute, OS desired state and application ownership; name the inventory limit. |
| [UC-LNX-018: Linux Automation and Tooling Development](use-cases/linux/UC-LNX-018-linux-automation-tooling-development.md) | How would you implement Linux Automation and Tooling Development in Ansible and AWX without hiding unsafe shell behavior or widening the inventory scope? | Discuss roles, playbook composition, strict Bash behavior, structured results, credentials and check output. |
| [UC-LNX-019: Linux Monitoring and Incident Operations](use-cases/linux/UC-LNX-019-linux-monitoring-incident-operations.md) | During Linux Monitoring and Incident Operations, the canary becomes unreachable or unhealthy. How do you stop the rollout and recover the host or service? | Use console or break-glass paths where necessary and preserve the failed task, journal and before-state. |
| [UC-LNX-020: Hybrid-Cloud and Container Host Engineering](use-cases/linux/UC-LNX-020-hybrid-cloud-container-host-engineering.md) | What host-by-host, security, idempotence and recovery evidence would make Hybrid-Cloud and Container Host Engineering defensible? | Include Git revision, Jenkins/AWX IDs, canary, second convergence, service telemetry and reversal. |
| [UC-LNX-021: Enterprise Identity Integration](use-cases/linux/UC-LNX-021-enterprise-identity-integration.md) | Walk through Enterprise Identity Integration as a controlled fleet change. What is inspected, changed, verified and handed back to the service owner? | Separate provisioned compute, OS desired state and application ownership; name the inventory limit. |
| [UC-LNX-022: Vulnerability Remediation Lifecycle](use-cases/linux/UC-LNX-022-vulnerability-remediation-lifecycle.md) | How would you implement Vulnerability Remediation Lifecycle in Ansible and AWX without hiding unsafe shell behavior or widening the inventory scope? | Discuss roles, playbook composition, strict Bash behavior, structured results, credentials and check output. |
| [UC-LNX-023: Backup, Restore, Disaster Recovery and HA Testing](use-cases/linux/UC-LNX-023-backup-restore-disaster-recovery-ha-testing.md) | During Backup, Restore, Disaster Recovery and HA Testing, the canary becomes unreachable or unhealthy. How do you stop the rollout and recover the host or service? | Use console or break-glass paths where necessary and preserve the failed task, journal and before-state. |
| [UC-LNX-024: Git-Based Linux Change Validation](use-cases/linux/UC-LNX-024-git-based-linux-change-validation.md) | What host-by-host, security, idempotence and recovery evidence would make Git-Based Linux Change Validation defensible? | Include Git revision, Jenkins/AWX IDs, canary, second convergence, service telemetry and reversal. |

## Database Reliability

Platform detail: [Database Reliability](projects/database-reliability.md)

### Platform questions

- What must an application provide before it receives a database and runtime role?
- How do migration identity, application release identity and backup/restore evidence remain connected?
- Why are a successful backup job and a running PostgreSQL process insufficient reliability evidence?

### Questions tied to detailed use cases

| Use case | Primary question | Interviewer probe |
| --- | --- | --- |
| [UC-DB-001: Automated PostgreSQL Restore Validation](use-cases/database/UC-DB-001-backup-restore-validation.md) | Design Automated PostgreSQL Restore Validation as a database service contract. Which decisions belong to the application, database, security and SRE owners? | Cover schema/database isolation, migration/runtime roles, connection budget, data class and RPO/RTO ownership. |
| [UC-DB-002: PostgreSQL Installation Through AWX](use-cases/database/UC-DB-002-postgresql-installation-through-awx.md) | How would you implement PostgreSQL Installation Through AWX against the existing PostgreSQL path using synthetic data and bounded AWX automation? | Use source-managed SQL/playbooks, explicit grants, synthetic markers and application-level verification. |
| [UC-DB-003: Database and Role Provisioning](use-cases/database/UC-DB-003-database-and-role-provisioning.md) | Database and Role Provisioning fails while clients or data are in a mixed state. How do you protect correctness and select recovery? | Discuss locks, transactions, expand-contract, connection pressure, write safety and previous valid credentials/data. |
| [UC-DB-004: Schema Migration Automation](use-cases/database/UC-DB-004-schema-migration-automation.md) | Which compatibility, performance, security and restore evidence would you require for Schema Migration Automation? | A job exit code is not enough; require queried restored content, timing, telemetry and consumer verification. |
| [UC-DB-005: Backup and Point-in-Time Recovery](use-cases/database/UC-DB-005-backup-and-point-in-time-recovery.md) | Design Backup and Point-in-Time Recovery as a database service contract. Which decisions belong to the application, database, security and SRE owners? | Cover schema/database isolation, migration/runtime roles, connection budget, data class and RPO/RTO ownership. |
| [UC-DB-006: Major-Version Upgrade Automation](use-cases/database/UC-DB-006-major-version-upgrade-automation.md) | How would you implement Major-Version Upgrade Automation against the existing PostgreSQL path using synthetic data and bounded AWX automation? | Use source-managed SQL/playbooks, explicit grants, synthetic markers and application-level verification. |
| [UC-DB-007: Minor Patching](use-cases/database/UC-DB-007-minor-patching.md) | Minor Patching fails while clients or data are in a mixed state. How do you protect correctness and select recovery? | Discuss locks, transactions, expand-contract, connection pressure, write safety and previous valid credentials/data. |
| [UC-DB-008: Database Performance Monitoring](use-cases/database/UC-DB-008-database-performance-monitoring.md) | Which compatibility, performance, security and restore evidence would you require for Database Performance Monitoring? | A job exit code is not enough; require queried restored content, timing, telemetry and consumer verification. |
| [UC-DB-009: Slow-Query Analysis](use-cases/database/UC-DB-009-slow-query-analysis.md) | Design Slow-Query Analysis as a database service contract. Which decisions belong to the application, database, security and SRE owners? | Cover schema/database isolation, migration/runtime roles, connection budget, data class and RPO/RTO ownership. |
| [UC-DB-010: Index and Statistics Maintenance](use-cases/database/UC-DB-010-index-and-statistics-maintenance.md) | How would you implement Index and Statistics Maintenance against the existing PostgreSQL path using synthetic data and bounded AWX automation? | Use source-managed SQL/playbooks, explicit grants, synthetic markers and application-level verification. |
| [UC-DB-011: Connection Pooling](use-cases/database/UC-DB-011-connection-pooling.md) | Connection Pooling fails while clients or data are in a mixed state. How do you protect correctness and select recovery? | Discuss locks, transactions, expand-contract, connection pressure, write safety and previous valid credentials/data. |
| [UC-DB-012: TLS and Credential Rotation](use-cases/database/UC-DB-012-tls-and-credential-rotation.md) | Which compatibility, performance, security and restore evidence would you require for TLS and Credential Rotation? | A job exit code is not enough; require queried restored content, timing, telemetry and consumer verification. |
| [UC-DB-013: Database Auditing](use-cases/database/UC-DB-013-database-auditing.md) | Design Database Auditing as a database service contract. Which decisions belong to the application, database, security and SRE owners? | Cover schema/database isolation, migration/runtime roles, connection budget, data class and RPO/RTO ownership. |
| [UC-DB-014: Capacity Forecasting](use-cases/database/UC-DB-014-capacity-forecasting.md) | How would you implement Capacity Forecasting against the existing PostgreSQL path using synthetic data and bounded AWX automation? | Use source-managed SQL/playbooks, explicit grants, synthetic markers and application-level verification. |
| [UC-DB-015: Replication and Failover Exercises](use-cases/database/UC-DB-015-replication-and-failover-exercises.md) | Replication and Failover Exercises fails while clients or data are in a mixed state. How do you protect correctness and select recovery? | Discuss locks, transactions, expand-contract, connection pressure, write safety and previous valid credentials/data. |
| [UC-DB-016: RPO and RTO Validation](use-cases/database/UC-DB-016-rpo-and-rto-validation.md) | Which compatibility, performance, security and restore evidence would you require for RPO and RTO Validation? | A job exit code is not enough; require queried restored content, timing, telemetry and consumer verification. |
| [UC-DB-017: Application Database Onboarding](use-cases/database/UC-DB-017-application-database-onboarding.md) | Design Application Database Onboarding as a database service contract. Which decisions belong to the application, database, security and SRE owners? | Cover schema/database isolation, migration/runtime roles, connection budget, data class and RPO/RTO ownership. |
| [UC-DB-018: Data Retention and Archival](use-cases/database/UC-DB-018-data-retention-and-archival.md) | How would you implement Data Retention and Archival against the existing PostgreSQL path using synthetic data and bounded AWX automation? | Use source-managed SQL/playbooks, explicit grants, synthetic markers and application-level verification. |
| [UC-DB-019: Database Incident Runbooks](use-cases/database/UC-DB-019-database-incident-runbooks.md) | Database Incident Runbooks fails while clients or data are in a mixed state. How do you protect correctness and select recovery? | Discuss locks, transactions, expand-contract, connection pressure, write safety and previous valid credentials/data. |

## Resilience and Service Operations

Platform detail: [Resilience and Service Operations](projects/resilience-service-operations.md)

### Platform questions

- What belongs in a service-readiness record before an incident occurs?
- How do incident command, technical diagnosis and recovery authority differ?
- How can the lab teach production incident skills without inventing production experience?

### Questions tied to detailed use cases

| Use case | Primary question | Interviewer probe |
| --- | --- | --- |
| [UC-RSO-001: Operational Readiness Review](use-cases/resilience/UC-RSO-001-operational-readiness-review.md) | How does Operational Readiness Review improve service readiness, and what operating information or handoffs must exist first? | Name owner, dependencies, SLO, on-call, previous release, runbook, backup and decision authority. |
| [UC-RSO-002: SLI and SLO Governance](use-cases/resilience/UC-RSO-002-sli-and-slo-governance.md) | Which part of SLI and SLO Governance can be exercised safely in the shared lab, and what operational learning should it produce? | Define injection, blast radius, expected detection, stop condition and restoration before starting. |
| [UC-RSO-003: Error-Budget Management](use-cases/resilience/UC-RSO-003-error-budget-management.md) | While applying Error-Budget Management, telemetry and recent-change evidence point in different directions. How does the team decide what to do next? | Keep hypotheses explicit, protect data and prefer reversible mitigation over confident guessing. |
| [UC-RSO-004: Incident Detection and Classification](use-cases/resilience/UC-RSO-004-incident-detection-and-classification.md) | What user-path, data, timing, role and recovery evidence would make Incident Detection and Classification complete? | Measure from honest start/stop points and distinguish command success from service recovery. |
| [UC-RSO-005: On-Call and Escalation Workflows](use-cases/resilience/UC-RSO-005-on-call-and-escalation-workflows.md) | How does On-Call and Escalation Workflows improve service readiness, and what operating information or handoffs must exist first? | Name owner, dependencies, SLO, on-call, previous release, runbook, backup and decision authority. |
| [UC-RSO-006: Automated Incident Evidence Collection](use-cases/resilience/UC-RSO-006-automated-incident-evidence-collection.md) | Which part of Automated Incident Evidence Collection can be exercised safely in the shared lab, and what operational learning should it produce? | Define injection, blast radius, expected detection, stop condition and restoration before starting. |
| [UC-RSO-007: Post-Incident Review](use-cases/resilience/UC-RSO-007-post-incident-review.md) | While applying Post-Incident Review, telemetry and recent-change evidence point in different directions. How does the team decide what to do next? | Keep hypotheses explicit, protect data and prefer reversible mitigation over confident guessing. |
| [UC-RSO-008: Problem Management](use-cases/resilience/UC-RSO-008-problem-management.md) | What user-path, data, timing, role and recovery evidence would make Problem Management complete? | Measure from honest start/stop points and distinguish command success from service recovery. |
| [UC-RSO-009: Service Ownership](use-cases/resilience/UC-RSO-009-service-ownership.md) | How does Service Ownership improve service readiness, and what operating information or handoffs must exist first? | Name owner, dependencies, SLO, on-call, previous release, runbook, backup and decision authority. |
| [UC-RSO-010: Dependency Mapping](use-cases/resilience/UC-RSO-010-dependency-mapping.md) | Which part of Dependency Mapping can be exercised safely in the shared lab, and what operational learning should it produce? | Define injection, blast radius, expected detection, stop condition and restoration before starting. |
| [UC-RSO-011: Synthetic Monitoring](use-cases/resilience/UC-RSO-011-synthetic-monitoring.md) | While applying Synthetic Monitoring, telemetry and recent-change evidence point in different directions. How does the team decide what to do next? | Keep hypotheses explicit, protect data and prefer reversible mitigation over confident guessing. |
| [UC-RSO-012: Capacity and Saturation Testing](use-cases/resilience/UC-RSO-012-capacity-and-saturation-testing.md) | What user-path, data, timing, role and recovery evidence would make Capacity and Saturation Testing complete? | Measure from honest start/stop points and distinguish command success from service recovery. |
| [UC-RSO-013: Load and Performance Testing](use-cases/resilience/UC-RSO-013-load-and-performance-testing.md) | How does Load and Performance Testing improve service readiness, and what operating information or handoffs must exist first? | Name owner, dependencies, SLO, on-call, previous release, runbook, backup and decision authority. |
| [UC-RSO-014: Chaos and Failure Exercises](use-cases/resilience/UC-RSO-014-chaos-and-failure-exercises.md) | Which part of Chaos and Failure Exercises can be exercised safely in the shared lab, and what operational learning should it produce? | Define injection, blast radius, expected detection, stop condition and restoration before starting. |
| [UC-RSO-015: Backup and Recovery Orchestration](use-cases/resilience/UC-RSO-015-backup-and-recovery-orchestration.md) | While applying Backup and Recovery Orchestration, telemetry and recent-change evidence point in different directions. How does the team decide what to do next? | Keep hypotheses explicit, protect data and prefer reversible mitigation over confident guessing. |
| [UC-RSO-016: Disaster-Recovery Exercises](use-cases/resilience/UC-RSO-016-disaster-recovery-exercises.md) | What user-path, data, timing, role and recovery evidence would make Disaster-Recovery Exercises complete? | Measure from honest start/stop points and distinguish command success from service recovery. |
| [UC-RSO-017: RTO and RPO Measurement](use-cases/resilience/UC-RSO-017-rto-and-rpo-measurement.md) | How does RTO and RPO Measurement improve service readiness, and what operating information or handoffs must exist first? | Name owner, dependencies, SLO, on-call, previous release, runbook, backup and decision authority. |
| [UC-RSO-018: Certificate and Secret Expiry Response](use-cases/resilience/UC-RSO-018-certificate-and-secret-expiry-response.md) | Which part of Certificate and Secret Expiry Response can be exercised safely in the shared lab, and what operational learning should it produce? | Define injection, blast radius, expected detection, stop condition and restoration before starting. |
| [UC-RSO-019: AWX Automated Remediation](use-cases/resilience/UC-RSO-019-awx-automated-remediation.md) | While applying AWX Automated Remediation, telemetry and recent-change evidence point in different directions. How does the team decide what to do next? | Keep hypotheses explicit, protect data and prefer reversible mitigation over confident guessing. |
| [UC-RSO-020: Maintenance-Window Management](use-cases/resilience/UC-RSO-020-maintenance-window-management.md) | What user-path, data, timing, role and recovery evidence would make Maintenance-Window Management complete? | Measure from honest start/stop points and distinguish command success from service recovery. |
| [UC-RSO-021: Dependency Failure Containment](use-cases/resilience/UC-RSO-021-dependency-failure-containment.md) | How does Dependency Failure Containment improve service readiness, and what operating information or handoffs must exist first? | Name owner, dependencies, SLO, on-call, previous release, runbook, backup and decision authority. |

## Data Engineering and Integration

Platform detail: [Data Engineering and Integration](projects/data-engineering.md)

### Platform questions

- What turns a moved file or completed job into a trusted data product?
- How do schema, quality, lineage, privacy and replay contracts travel together?
- What can the current lab prove before a data-platform product stack is selected?

### Questions tied to detailed use cases

| Use case | Primary question | Interviewer probe |
| --- | --- | --- |
| [UC-DATA-001: Healthcare Feed Quality Validation](use-cases/data/UC-DATA-001-healthcare-feed-quality.md) | For Healthcare Feed Quality Validation, define the producer, consumer and data-product contract before choosing a tool. | Cover meaning, ownership, schema compatibility, delivery expectation, classification and failure behavior. |
| [UC-DATA-002: Batch Data Ingestion](use-cases/data/UC-DATA-002-batch-data-ingestion.md) | How would you build the first testable slice of Batch Data Ingestion with schemas and synthetic fixtures in the current lab? | Use repository validation and approved existing interfaces; do not imply Airflow, Kafka or a lakehouse is installed. |
| [UC-DATA-003: Streaming Data Ingestion](use-cases/data/UC-DATA-003-streaming-data-ingestion.md) | Streaming Data Ingestion produces late, duplicated, malformed or partially transformed data. How do you contain and replay it safely? | Discuss quarantine, watermarks, idempotency, dead-letter ownership, backfill bounds and consumer impact. |
| [UC-DATA-004: Change-Data Capture](use-cases/data/UC-DATA-004-change-data-capture.md) | Which quality, lineage, reconciliation, privacy and recovery evidence would prove Change-Data Capture? | Require source checksum, code/schema revisions, counts, rejected records, lineage and replay result. |
| [UC-DATA-005: ETL and ELT Pipelines](use-cases/data/UC-DATA-005-etl-and-elt-pipelines.md) | For ETL and ELT Pipelines, define the producer, consumer and data-product contract before choosing a tool. | Cover meaning, ownership, schema compatibility, delivery expectation, classification and failure behavior. |
| [UC-DATA-006: Workflow Orchestration](use-cases/data/UC-DATA-006-workflow-orchestration.md) | How would you build the first testable slice of Workflow Orchestration with schemas and synthetic fixtures in the current lab? | Use repository validation and approved existing interfaces; do not imply Airflow, Kafka or a lakehouse is installed. |
| [UC-DATA-007: Schema Registry and Evolution](use-cases/data/UC-DATA-007-schema-registry-and-evolution.md) | Schema Registry and Evolution produces late, duplicated, malformed or partially transformed data. How do you contain and replay it safely? | Discuss quarantine, watermarks, idempotency, dead-letter ownership, backfill bounds and consumer impact. |
| [UC-DATA-008: Event-Contract Management](use-cases/data/UC-DATA-008-event-contract-management.md) | Which quality, lineage, reconciliation, privacy and recovery evidence would prove Event-Contract Management? | Require source checksum, code/schema revisions, counts, rejected records, lineage and replay result. |
| [UC-DATA-009: dbt Data Transformation](use-cases/data/UC-DATA-009-dbt-data-transformation.md) | For dbt Data Transformation, define the producer, consumer and data-product contract before choosing a tool. | Cover meaning, ownership, schema compatibility, delivery expectation, classification and failure behavior. |
| [UC-DATA-010: Distributed Data Processing](use-cases/data/UC-DATA-010-distributed-data-processing.md) | How would you build the first testable slice of Distributed Data Processing with schemas and synthetic fixtures in the current lab? | Use repository validation and approved existing interfaces; do not imply Airflow, Kafka or a lakehouse is installed. |
| [UC-DATA-011: Data Lake and Lakehouse Storage](use-cases/data/UC-DATA-011-data-lake-and-lakehouse-storage.md) | Data Lake and Lakehouse Storage produces late, duplicated, malformed or partially transformed data. How do you contain and replay it safely? | Discuss quarantine, watermarks, idempotency, dead-letter ownership, backfill bounds and consumer impact. |
| [UC-DATA-012: Data Warehouse Integration](use-cases/data/UC-DATA-012-data-warehouse-integration.md) | Which quality, lineage, reconciliation, privacy and recovery evidence would prove Data Warehouse Integration? | Require source checksum, code/schema revisions, counts, rejected records, lineage and replay result. |
| [UC-DATA-013: Metadata Catalog and Discovery](use-cases/data/UC-DATA-013-metadata-catalog-and-discovery.md) | For Metadata Catalog and Discovery, define the producer, consumer and data-product contract before choosing a tool. | Cover meaning, ownership, schema compatibility, delivery expectation, classification and failure behavior. |
| [UC-DATA-014: Data Lineage](use-cases/data/UC-DATA-014-data-lineage.md) | How would you build the first testable slice of Data Lineage with schemas and synthetic fixtures in the current lab? | Use repository validation and approved existing interfaces; do not imply Airflow, Kafka or a lakehouse is installed. |
| [UC-DATA-015: Data Classification](use-cases/data/UC-DATA-015-data-classification.md) | Data Classification produces late, duplicated, malformed or partially transformed data. How do you contain and replay it safely? | Discuss quarantine, watermarks, idempotency, dead-letter ownership, backfill bounds and consumer impact. |
| [UC-DATA-016: PII Controls](use-cases/data/UC-DATA-016-pii-controls.md) | Which quality, lineage, reconciliation, privacy and recovery evidence would prove PII Controls? | Require source checksum, code/schema revisions, counts, rejected records, lineage and replay result. |
| [UC-DATA-017: Data Retention and Archival](use-cases/data/UC-DATA-017-data-retention-and-archival.md) | For Data Retention and Archival, define the producer, consumer and data-product contract before choosing a tool. | Cover meaning, ownership, schema compatibility, delivery expectation, classification and failure behavior. |
| [UC-DATA-018: Pipeline Monitoring and Alerting](use-cases/data/UC-DATA-018-pipeline-monitoring-and-alerting.md) | How would you build the first testable slice of Pipeline Monitoring and Alerting with schemas and synthetic fixtures in the current lab? | Use repository validation and approved existing interfaces; do not imply Airflow, Kafka or a lakehouse is installed. |
| [UC-DATA-019: Pipeline Retry and Backfill](use-cases/data/UC-DATA-019-pipeline-retry-and-backfill.md) | Pipeline Retry and Backfill produces late, duplicated, malformed or partially transformed data. How do you contain and replay it safely? | Discuss quarantine, watermarks, idempotency, dead-letter ownership, backfill bounds and consumer impact. |
| [UC-DATA-020: Dead-Letter Queues and Replay](use-cases/data/UC-DATA-020-dead-letter-queues-and-replay.md) | Which quality, lineage, reconciliation, privacy and recovery evidence would prove Dead-Letter Queues and Replay? | Require source checksum, code/schema revisions, counts, rejected records, lineage and replay result. |
| [UC-DATA-021: Data Reconciliation](use-cases/data/UC-DATA-021-data-reconciliation.md) | For Data Reconciliation, define the producer, consumer and data-product contract before choosing a tool. | Cover meaning, ownership, schema compatibility, delivery expectation, classification and failure behavior. |
| [UC-DATA-022: Dataset Ownership](use-cases/data/UC-DATA-022-dataset-ownership.md) | How would you build the first testable slice of Dataset Ownership with schemas and synthetic fixtures in the current lab? | Use repository validation and approved existing interfaces; do not imply Airflow, Kafka or a lakehouse is installed. |
| [UC-DATA-023: Data Access Governance](use-cases/data/UC-DATA-023-data-access-governance.md) | Data Access Governance produces late, duplicated, malformed or partially transformed data. How do you contain and replay it safely? | Discuss quarantine, watermarks, idempotency, dead-letter ownership, backfill bounds and consumer impact. |
| [UC-DATA-024: Data-Pipeline Disaster Recovery](use-cases/data/UC-DATA-024-data-pipeline-disaster-recovery.md) | Which quality, lineage, reconciliation, privacy and recovery evidence would prove Data-Pipeline Disaster Recovery? | Require source checksum, code/schema revisions, counts, rejected records, lineage and replay result. |
| [UC-DATA-025: Data Performance and Cost Optimization](use-cases/data/UC-DATA-025-data-performance-and-cost-optimization.md) | For Data Performance and Cost Optimization, define the producer, consumer and data-product contract before choosing a tool. | Cover meaning, ownership, schema compatibility, delivery expectation, classification and failure behavior. |

## Network Engineering and Automation

Platform detail: [Network Engineering and Automation](projects/network-engineering.md)

### Platform questions

- How do you describe a service path from the consumer through DNS, routing, firewall and proxy to the workload?
- Why are a local listener and a successful ping not proof that an application is reachable?
- How do network, Linux, infrastructure and Kubernetes teams avoid conflicting ownership?

### Questions tied to detailed use cases

| Use case | Primary question | Interviewer probe |
| --- | --- | --- |
| [UC-NET-001: Network Change Validation and Rollback](use-cases/network/UC-NET-001-network-change-validation.md) | Design Network Change Validation and Rollback as a producer-to-consumer connectivity contract. What must be named before configuration changes? | Name source, destination, purpose, protocol/port, ownership, trust boundary and removal condition. |
| [UC-NET-002: Enterprise IP Address Management](use-cases/network/UC-NET-002-enterprise-ip-address-management.md) | How would you implement and canary Enterprise IP Address Management using the current BIND, NGINX, KVM and Kubernetes boundaries? | Use inventory-driven configuration, pre/post tests and AWX limits; do not assume a cloud/VPN/MetalLB product exists. |
| [UC-NET-003: VLAN and Subnet Design](use-cases/network/UC-NET-003-vlan-and-subnet-design.md) | Users report failure during VLAN and Subnet Design, but one local test passes. How do you isolate DNS, route, firewall, TLS, proxy and workload layers? | Test from the affected source and preserve TTL, SNI, session, MTU and asymmetry evidence where relevant. |
| [UC-NET-004: DHCP Reservation Management](use-cases/network/UC-NET-004-dhcp-reservation-management.md) | Which source, path, negative and rollback evidence would you require to accept DHCP Reservation Management? | Include configuration diff, AWX ID, DNS serial, consumer test, prohibited-path test and restored prior state. |
| [UC-NET-005: Authoritative and Recursive DNS](use-cases/network/UC-NET-005-authoritative-and-recursive-dns.md) | Design Authoritative and Recursive DNS as a producer-to-consumer connectivity contract. What must be named before configuration changes? | Name source, destination, purpose, protocol/port, ownership, trust boundary and removal condition. |
| [UC-NET-006: Forward and Reverse DNS Automation](use-cases/network/UC-NET-006-forward-and-reverse-dns-automation.md) | How would you implement and canary Forward and Reverse DNS Automation using the current BIND, NGINX, KVM and Kubernetes boundaries? | Use inventory-driven configuration, pre/post tests and AWX limits; do not assume a cloud/VPN/MetalLB product exists. |
| [UC-NET-007: Router and Switch Configuration Backup](use-cases/network/UC-NET-007-router-and-switch-configuration-backup.md) | Users report failure during Router and Switch Configuration Backup, but one local test passes. How do you isolate DNS, route, firewall, TLS, proxy and workload layers? | Test from the affected source and preserve TTL, SNI, session, MTU and asymmetry evidence where relevant. |
| [UC-NET-008: Network Configuration Automation](use-cases/network/UC-NET-008-network-configuration-automation.md) | Which source, path, negative and rollback evidence would you require to accept Network Configuration Automation? | Include configuration diff, AWX ID, DNS serial, consumer test, prohibited-path test and restored prior state. |
| [UC-NET-009: Network Configuration-Drift Detection](use-cases/network/UC-NET-009-network-configuration-drift-detection.md) | Design Network Configuration-Drift Detection as a producer-to-consumer connectivity contract. What must be named before configuration changes? | Name source, destination, purpose, protocol/port, ownership, trust boundary and removal condition. |
| [UC-NET-010: Layer 2 Bridge Management](use-cases/network/UC-NET-010-layer-2-bridge-management.md) | How would you implement and canary Layer 2 Bridge Management using the current BIND, NGINX, KVM and Kubernetes boundaries? | Use inventory-driven configuration, pre/post tests and AWX limits; do not assume a cloud/VPN/MetalLB product exists. |
| [UC-NET-011: Layer 3 Routing](use-cases/network/UC-NET-011-layer-3-routing.md) | Users report failure during Layer 3 Routing, but one local test passes. How do you isolate DNS, route, firewall, TLS, proxy and workload layers? | Test from the affected source and preserve TTL, SNI, session, MTU and asymmetry evidence where relevant. |
| [UC-NET-012: Firewall Policy Management](use-cases/network/UC-NET-012-firewall-policy-management.md) | Which source, path, negative and rollback evidence would you require to accept Firewall Policy Management? | Include configuration diff, AWX ID, DNS serial, consumer test, prohibited-path test and restored prior state. |
| [UC-NET-013: NAT and Egress Management](use-cases/network/UC-NET-013-nat-and-egress-management.md) | Design NAT and Egress Management as a producer-to-consumer connectivity contract. What must be named before configuration changes? | Name source, destination, purpose, protocol/port, ownership, trust boundary and removal condition. |
| [UC-NET-014: Load Balancer and Reverse Proxy Configuration](use-cases/network/UC-NET-014-load-balancer-and-reverse-proxy-configuration.md) | How would you implement and canary Load Balancer and Reverse Proxy Configuration using the current BIND, NGINX, KVM and Kubernetes boundaries? | Use inventory-driven configuration, pre/post tests and AWX limits; do not assume a cloud/VPN/MetalLB product exists. |
| [UC-NET-015: VPN and Remote Access](use-cases/network/UC-NET-015-vpn-and-remote-access.md) | Users report failure during VPN and Remote Access, but one local test passes. How do you isolate DNS, route, firewall, TLS, proxy and workload layers? | Test from the affected source and preserve TTL, SNI, session, MTU and asymmetry evidence where relevant. |
| [UC-NET-016: Cloud VPC and VNet Networking](use-cases/network/UC-NET-016-cloud-vpc-and-vnet-networking.md) | Which source, path, negative and rollback evidence would you require to accept Cloud VPC and VNet Networking? | Include configuration diff, AWX ID, DNS serial, consumer test, prohibited-path test and restored prior state. |
| [UC-NET-017: Hybrid-Cloud Connectivity](use-cases/network/UC-NET-017-hybrid-cloud-connectivity.md) | Design Hybrid-Cloud Connectivity as a producer-to-consumer connectivity contract. What must be named before configuration changes? | Name source, destination, purpose, protocol/port, ownership, trust boundary and removal condition. |
| [UC-NET-018: Kubernetes Networking](use-cases/network/UC-NET-018-kubernetes-networking.md) | How would you implement and canary Kubernetes Networking using the current BIND, NGINX, KVM and Kubernetes boundaries? | Use inventory-driven configuration, pre/post tests and AWX limits; do not assume a cloud/VPN/MetalLB product exists. |
| [UC-NET-019: CNI Policy and Troubleshooting](use-cases/network/UC-NET-019-cni-policy-and-troubleshooting.md) | Users report failure during CNI Policy and Troubleshooting, but one local test passes. How do you isolate DNS, route, firewall, TLS, proxy and workload layers? | Test from the affected source and preserve TTL, SNI, session, MTU and asymmetry evidence where relevant. |
| [UC-NET-020: Ingress and Egress Controls](use-cases/network/UC-NET-020-ingress-and-egress-controls.md) | Which source, path, negative and rollback evidence would you require to accept Ingress and Egress Controls? | Include configuration diff, AWX ID, DNS serial, consumer test, prohibited-path test and restored prior state. |
| [UC-NET-021: MetalLB Address Management](use-cases/network/UC-NET-021-metallb-address-management.md) | Design MetalLB Address Management as a producer-to-consumer connectivity contract. What must be named before configuration changes? | Name source, destination, purpose, protocol/port, ownership, trust boundary and removal condition. |
| [UC-NET-022: Network Segmentation](use-cases/network/UC-NET-022-network-segmentation.md) | How would you implement and canary Network Segmentation using the current BIND, NGINX, KVM and Kubernetes boundaries? | Use inventory-driven configuration, pre/post tests and AWX limits; do not assume a cloud/VPN/MetalLB product exists. |
| [UC-NET-023: Private Endpoint and Private DNS](use-cases/network/UC-NET-023-private-endpoint-and-private-dns.md) | Users report failure during Private Endpoint and Private DNS, but one local test passes. How do you isolate DNS, route, firewall, TLS, proxy and workload layers? | Test from the affected source and preserve TTL, SNI, session, MTU and asymmetry evidence where relevant. |
| [UC-NET-024: Certificate and TLS Routing](use-cases/network/UC-NET-024-certificate-and-tls-routing.md) | Which source, path, negative and rollback evidence would you require to accept Certificate and TLS Routing? | Include configuration diff, AWX ID, DNS serial, consumer test, prohibited-path test and restored prior state. |
| [UC-NET-025: Network Performance Monitoring](use-cases/network/UC-NET-025-network-performance-monitoring.md) | Design Network Performance Monitoring as a producer-to-consumer connectivity contract. What must be named before configuration changes? | Name source, destination, purpose, protocol/port, ownership, trust boundary and removal condition. |
| [UC-NET-026: Flow-Log Analysis](use-cases/network/UC-NET-026-flow-log-analysis.md) | How would you implement and canary Flow-Log Analysis using the current BIND, NGINX, KVM and Kubernetes boundaries? | Use inventory-driven configuration, pre/post tests and AWX limits; do not assume a cloud/VPN/MetalLB product exists. |
| [UC-NET-027: Packet Capture and Troubleshooting](use-cases/network/UC-NET-027-packet-capture-and-troubleshooting.md) | Users report failure during Packet Capture and Troubleshooting, but one local test passes. How do you isolate DNS, route, firewall, TLS, proxy and workload layers? | Test from the affected source and preserve TTL, SNI, session, MTU and asymmetry evidence where relevant. |
| [UC-NET-028: Network Availability Testing](use-cases/network/UC-NET-028-network-availability-testing.md) | Which source, path, negative and rollback evidence would you require to accept Network Availability Testing? | Include configuration diff, AWX ID, DNS serial, consumer test, prohibited-path test and restored prior state. |
| [UC-NET-029: Network Configuration Compliance](use-cases/network/UC-NET-029-network-configuration-compliance.md) | Design Network Configuration Compliance as a producer-to-consumer connectivity contract. What must be named before configuration changes? | Name source, destination, purpose, protocol/port, ownership, trust boundary and removal condition. |
| [UC-NET-030: Network Incident Response](use-cases/network/UC-NET-030-network-incident-response.md) | How would you implement and canary Network Incident Response using the current BIND, NGINX, KVM and Kubernetes boundaries? | Use inventory-driven configuration, pre/post tests and AWX limits; do not assume a cloud/VPN/MetalLB product exists. |
| [UC-NET-031: Capacity and Bandwidth Planning](use-cases/network/UC-NET-031-capacity-and-bandwidth-planning.md) | Users report failure during Capacity and Bandwidth Planning, but one local test passes. How do you isolate DNS, route, firewall, TLS, proxy and workload layers? | Test from the affected source and preserve TTL, SNI, session, MTU and asymmetry evidence where relevant. |

## Healthcare AI

Platform detail: [Healthcare AI](projects/healthcare-ai.md)

### Platform questions

- How do you decide whether a healthcare workflow should use AI at all?
- Where must human review remain when retrieval, model output or tool use is uncertain?
- How do access control and citations travel through a RAG request?

### Questions tied to detailed use cases

| Use case | Primary question | Interviewer probe |
| --- | --- | --- |
| [UC-AI-001: Retrieval-Augmented Generation](use-cases/healthcare-ai/UC-AI-001-retrieval-augmented-generation.md) | A care or payer team proposes Retrieval-Augmented Generation. What workflow outcome, prohibited action and human-review point would you define first? | Separate decision support from clinical/payer authority and name the accountable workflow owner. |
| [UC-AI-002: Clinical AI Assistant Platform](use-cases/healthcare-ai/UC-AI-002-clinical-ai-assistant-platform.md) | What is a safe, buildable first slice for Clinical AI Assistant Platform using approved documents or synthetic data? | Begin read-only, pin every input and keep protected data out until separately authorized. |
| [UC-AI-003: Payer AI Assistant Platform](use-cases/healthcare-ai/UC-AI-003-payer-ai-assistant-platform.md) | During Payer AI Assistant Platform, retrieval is stale, access is uncertain or the model response is persuasive but unsupported. What should happen? | Fail safely, expose limitations, block unauthorized sources/tools and avoid logging sensitive content. |
| [UC-AI-004: Agentic Workflow Automation](use-cases/healthcare-ai/UC-AI-004-agentic-workflow-automation.md) | Which data, prompt, model, evaluation, citation, denial and rollback evidence would you require for Agentic Workflow Automation? | Test ordinary, ambiguous, missing-source, injection, unauthorized and harmful cases by failure category. |
| [UC-AI-005: Healthcare Knowledge Base Indexing](use-cases/healthcare-ai/UC-AI-005-healthcare-knowledge-base-indexing.md) | A care or payer team proposes Healthcare Knowledge Base Indexing. What workflow outcome, prohibited action and human-review point would you define first? | Separate decision support from clinical/payer authority and name the accountable workflow owner. |
| [UC-AI-006: FHIR-Aware AI APIs](use-cases/healthcare-ai/UC-AI-006-fhir-aware-ai-apis.md) | What is a safe, buildable first slice for FHIR-Aware AI APIs using approved documents or synthetic data? | Begin read-only, pin every input and keep protected data out until separately authorized. |
| [UC-AI-007: AI Prompt and Response Evaluation](use-cases/healthcare-ai/UC-AI-007-ai-prompt-and-response-evaluation.md) | During AI Prompt and Response Evaluation, retrieval is stale, access is uncertain or the model response is persuasive but unsupported. What should happen? | Fail safely, expose limitations, block unauthorized sources/tools and avoid logging sensitive content. |
| [UC-AI-008: Responsible AI Controls](use-cases/healthcare-ai/UC-AI-008-responsible-ai-controls.md) | Which data, prompt, model, evaluation, citation, denial and rollback evidence would you require for Responsible AI Controls? | Test ordinary, ambiguous, missing-source, injection, unauthorized and harmful cases by failure category. |
| [UC-AI-009: AI Workflow Audit Logging](use-cases/healthcare-ai/UC-AI-009-ai-workflow-audit-logging.md) | A care or payer team proposes AI Workflow Audit Logging. What workflow outcome, prohibited action and human-review point would you define first? | Separate decision support from clinical/payer authority and name the accountable workflow owner. |
| [UC-AI-010: AI Cost and Latency Optimization](use-cases/healthcare-ai/UC-AI-010-ai-cost-and-latency-optimization.md) | What is a safe, buildable first slice for AI Cost and Latency Optimization using approved documents or synthetic data? | Begin read-only, pin every input and keep protected data out until separately authorized. |
| [UC-AI-011: AI Security and Access Control](use-cases/healthcare-ai/UC-AI-011-ai-security-and-access-control.md) | During AI Security and Access Control, retrieval is stale, access is uncertain or the model response is persuasive but unsupported. What should happen? | Fail safely, expose limitations, block unauthorized sources/tools and avoid logging sensitive content. |
| [UC-AI-012: AI Release Governance](use-cases/healthcare-ai/UC-AI-012-ai-release-governance.md) | Which data, prompt, model, evaluation, citation, denial and rollback evidence would you require for AI Release Governance? | Test ordinary, ambiguous, missing-source, injection, unauthorized and harmful cases by failure category. |
| [UC-AI-013: AI Observability](use-cases/healthcare-ai/UC-AI-013-ai-observability.md) | A care or payer team proposes AI Observability. What workflow outcome, prohibited action and human-review point would you define first? | Separate decision support from clinical/payer authority and name the accountable workflow owner. |
| [UC-AI-014: Clinical and Payer Workflow Integration](use-cases/healthcare-ai/UC-AI-014-clinical-and-payer-workflow-integration.md) | What is a safe, buildable first slice for Clinical and Payer Workflow Integration using approved documents or synthetic data? | Begin read-only, pin every input and keep protected data out until separately authorized. |
| [UC-AI-015: AI Incident Response](use-cases/healthcare-ai/UC-AI-015-ai-incident-response.md) | During AI Incident Response, retrieval is stale, access is uncertain or the model response is persuasive but unsupported. What should happen? | Fail safely, expose limitations, block unauthorized sources/tools and avoid logging sensitive content. |

## MLOps Model Platform

Platform detail: [MLOps Model Platform](projects/mlops-model-platform.md)

### Platform questions

- Which identities must be preserved to reproduce a model from data through serving?
- How do experiment tracking, a registry and release promotion serve different purposes?
- Why does drift not automatically mean model accuracy has fallen?

### Questions tied to detailed use cases

| Use case | Primary question | Interviewer probe |
| --- | --- | --- |
| [UC-MLOPS-001: Model Registry and Versioning](use-cases/mlops/UC-MLOPS-001-model-registry-versioning.md) | For Model Registry and Versioning, which dataset, feature, code, environment, model and approval identities must remain linked? | Include snapshot/schema, transformations, parameters/seed, artifact digest, evaluation and serving-image compatibility. |
| [UC-MLOPS-002: ML Training Pipeline Standardization](use-cases/mlops/UC-MLOPS-002-ml-training-pipeline-standardization.md) | How would you prove a local first slice of ML Training Pipeline Standardization before a registry, feature store or serving platform is installed? | Use synthetic data, manifests, local artifacts and deterministic tests without naming an uninstalled product as live. |
| [UC-MLOPS-003: Feature Engineering and Feature Stores](use-cases/mlops/UC-MLOPS-003-feature-engineering-and-feature-stores.md) | Feature Engineering and Feature Stores fails or regresses after promotion. How do you distinguish service health, data drift and model-quality problems? | Separate latency/errors from distribution change and ground-truth performance; automatic retraining is not promotion. |
| [UC-MLOPS-004: Model Validation Gates](use-cases/mlops/UC-MLOPS-004-model-validation-gates.md) | What reproducibility, slice, security, serving and rollback evidence would make Model Validation Gates promotable? | Require adverse cases, baseline comparison, lineage, owner decision and prior model/image restoration. |
| [UC-MLOPS-005: CI/CT/CD for ML](use-cases/mlops/UC-MLOPS-005-ci-ct-cd-for-ml.md) | For CI/CT/CD for ML, which dataset, feature, code, environment, model and approval identities must remain linked? | Include snapshot/schema, transformations, parameters/seed, artifact digest, evaluation and serving-image compatibility. |
| [UC-MLOPS-006: Batch Inference](use-cases/mlops/UC-MLOPS-006-batch-inference.md) | How would you prove a local first slice of Batch Inference before a registry, feature store or serving platform is installed? | Use synthetic data, manifests, local artifacts and deterministic tests without naming an uninstalled product as live. |
| [UC-MLOPS-007: Real-Time Inference APIs](use-cases/mlops/UC-MLOPS-007-real-time-inference-apis.md) | Real-Time Inference APIs fails or regresses after promotion. How do you distinguish service health, data drift and model-quality problems? | Separate latency/errors from distribution change and ground-truth performance; automatic retraining is not promotion. |
| [UC-MLOPS-008: Model Observability](use-cases/mlops/UC-MLOPS-008-model-observability.md) | What reproducibility, slice, security, serving and rollback evidence would make Model Observability promotable? | Require adverse cases, baseline comparison, lineage, owner decision and prior model/image restoration. |
| [UC-MLOPS-009: Drift Detection](use-cases/mlops/UC-MLOPS-009-drift-detection.md) | For Drift Detection, which dataset, feature, code, environment, model and approval identities must remain linked? | Include snapshot/schema, transformations, parameters/seed, artifact digest, evaluation and serving-image compatibility. |
| [UC-MLOPS-010: Automated Retraining](use-cases/mlops/UC-MLOPS-010-automated-retraining.md) | How would you prove a local first slice of Automated Retraining before a registry, feature store or serving platform is installed? | Use synthetic data, manifests, local artifacts and deterministic tests without naming an uninstalled product as live. |
| [UC-MLOPS-011: Model Rollback](use-cases/mlops/UC-MLOPS-011-model-rollback.md) | Model Rollback fails or regresses after promotion. How do you distinguish service health, data drift and model-quality problems? | Separate latency/errors from distribution change and ground-truth performance; automatic retraining is not promotion. |
| [UC-MLOPS-012: Experiment Tracking](use-cases/mlops/UC-MLOPS-012-experiment-tracking.md) | What reproducibility, slice, security, serving and rollback evidence would make Experiment Tracking promotable? | Require adverse cases, baseline comparison, lineage, owner decision and prior model/image restoration. |
| [UC-MLOPS-013: ML Infrastructure as Code](use-cases/mlops/UC-MLOPS-013-ml-infrastructure-as-code.md) | For ML Infrastructure as Code, which dataset, feature, code, environment, model and approval identities must remain linked? | Include snapshot/schema, transformations, parameters/seed, artifact digest, evaluation and serving-image compatibility. |
| [UC-MLOPS-014: Model Governance Evidence](use-cases/mlops/UC-MLOPS-014-model-governance-evidence.md) | How would you prove a local first slice of Model Governance Evidence before a registry, feature store or serving platform is installed? | Use synthetic data, manifests, local artifacts and deterministic tests without naming an uninstalled product as live. |
| [UC-MLOPS-015: ML Incident Response](use-cases/mlops/UC-MLOPS-015-ml-incident-response.md) | ML Incident Response fails or regresses after promotion. How do you distinguish service health, data drift and model-quality problems? | Separate latency/errors from distribution change and ground-truth performance; automatic retraining is not promotion. |

## Coverage statement

This generated bank contains one traceable primary question for all **226** detailed
use cases, grouped under all twelve owning platforms. The universal follow-up ladder
turns each primary question into architecture, implementation, security, troubleshooting,
recovery and evidence probes without copying a generic block into every use-case page.

When a use case is added, renamed or removed, regenerate this document with
`./scripts/generate-use-case-interview-bank.py` and run the local validation suite.
