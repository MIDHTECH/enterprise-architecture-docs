# Advanced Use Case Comparison

This comparison separates the original portfolio use cases from the newer
advanced automation use cases. The older use cases establish platform coverage:
CI/CD, Terraform, Kubernetes, observability, governance, Linux, database, data,
network, AI, and MLOps. The newer use cases raise the bar: they expect the
platform to detect drift, explain impact, reconcile desired state, score
deployment health, recommend remediation, and produce evidence automatically.

The goal is to turn the advanced list into executable backlog items, not just
new wording in the architecture.

## Summary

| Area | Current portfolio coverage | Advanced direction | Current status |
| --- | --- | --- | --- |
| Infrastructure automation | Terraform modules, environment folders, tagging, security standards, plan/apply pipeline pattern | Drift detection, plan analysis, state integrity, reconciliation, change impact, policy-driven provisioning | First executable slice implemented in `cloud-infra-automation-platform` |
| Cloud operations automation | Governance scans, evidence collection, IAM/secrets/backup/cost/remediation concepts | Event-driven remediation, self-healing, closed-loop automation, human approval, cost anomaly, right-sizing | First executable advisor implemented in `cloud-governance-ops-automation` |
| Kubernetes automation | GitOps folder model, RBAC, NetworkPolicy, security baseline, HPA, Argo CD app | Live-vs-Git drift, reconciliation evidence, rollback, progressive delivery, verification, cost allocation | Drift monitor implemented in `kubernetes-platform-gitops`; rollback/progressive delivery still planned |
| Platform engineering | Shared Jenkins jobs, shared library, repo standards, environment structure | Internal developer platform, golden paths, self-service, environment as a service, service catalog, platform API | Mostly planned; backlog belongs across `jenkins-jobs`, `jenkins-shared-library`, `cloud-infra-automation-platform`, and `kubernetes-platform-gitops` |
| Observability and SRE | Prometheus, Grafana, Loki/Tempo, SLOs, alerts, synthetics, incident runbooks | OpenTelemetry auto-instrumentation, eBPF, observability pipelines, burn-rate alerts, health scoring, change correlation, triage | Health scoring and change correlation implemented in `observability-sre-platform`; eBPF/continuous profiling planned |

## Infrastructure Automation

| Advanced use case | Current equivalent | Gap | Implementation status |
| --- | --- | --- | --- |
| Terraform Drift Detection | Infrastructure CI/CD and Terraform plan pattern | Current portfolio mentioned plan/apply but did not compare actual cloud state against desired state | Implemented: `scripts/terraform_drift_detector.py` reads Terraform plan JSON and emits drift evidence |
| Automated Drift Remediation | Rollback automation and remediation concepts | Needs approval-backed reapply workflow through Jenkins/AWX | Planned next: guarded Jenkins job that consumes drift report and requires approval before apply |
| Terraform Health Assessments | Operational readiness and smoke tests | Needs scheduled workspace/backend/provider checks | Partially covered by static validation; health assessment script still needed |
| Infrastructure Reconciliation Loop | Terraform plan/apply pipeline | Needs repeated detect/report/open-issue/remediate/validate loop | Planned |
| Configuration Drift Monitoring | Linux and network configuration-drift detection | Terraform/cloud configuration drift needed separate implementation | Partially covered by Terraform drift detector and Linux/network drift use cases |
| Terraform Plan Automation | Infrastructure CI/CD pipeline | Needs MR artifact and summarized review output | Implemented as analyzer; pipeline wiring still needed |
| Terraform State Integrity Monitoring | Remote state and locking documented | Needs backend lock, state serial, workspace, and unexpected-modification checks | Planned |
| Infrastructure Change Impact Analysis | Change management, SLOs, ownership, runbooks | Needs resource-to-service/SLO/owner mapping | Implemented: `scripts/terraform_plan_analyzer.py` uses `config/impact-map.json` |
| Policy-Driven Provisioning | IaC scanning and policy-as-code gates | Needs deny rules tied to MidhHealth standards | Partially covered by governance scan; richer policy engine planned |
| Self-Service Infrastructure Provisioning | Environment creation/decommissioning | Needs template request path that opens a reviewed MR | Planned under platform engineering |

## Cloud Operations Automation

| Advanced use case | Current equivalent | Gap | Implementation status |
| --- | --- | --- | --- |
| Auto-Remediation | Incident remediation automation | Needs safe trigger, approval, and validation flow | Partially implemented as recommendations; execution workflow planned |
| Self-Healing Infrastructure | Toil reduction and remediation runbooks | Needs low-risk automatic repair plus post-check | Planned |
| Event-Driven Remediation | Alerting and runbooks | Needs alert/cloud-event input to Jenkins/AWX | Planned |
| Closed-Loop Automation | Detect/remediate/validate idea in backlog | Needs full loop with evidence and stop conditions | Planned |
| Runbook Automation | Operational runbooks | Needs executable scripts/playbooks for each runbook | Partially covered across Ansible repos |
| Automated Root-Cause Analysis | RCA evidence collection | Needs telemetry, deployment, Terraform, GitOps, and ownership correlation | Partially implemented in observability incident correlator |
| Change Correlation | Deployment validation and RCA | Needs recent changes attached to incidents | Implemented: `scripts/incident_change_correlator.py` |
| Intelligent Alert Deduplication | Alert routing | Needs grouping repeated alerts by service, symptom, and window | Planned |
| Predictive Incident Detection | Capacity/performance monitoring | Needs trend or anomaly scoring | Planned |
| Human-in-the-Loop Remediation | Approval gates and `CONFIRM_APPLY` | Needs formal risk classification and approval path | Partially covered; governance advisor marks high-risk approvals |

## Kubernetes Automation

| Advanced use case | Current equivalent | Gap | Implementation status |
| --- | --- | --- | --- |
| Kubernetes Configuration Drift | GitOps desired-state model | Needs live-vs-Git comparison | Implemented: `scripts/kubernetes_drift_monitor.py` |
| GitOps Reconciliation | Argo CD app and GitOps delivery | Needs sync evidence and reconciliation report | Argo CD definition exists; evidence collector planned |
| Automated Rollback | Rollback automation | Needs health-gated rollback workflow | Planned; health score implemented in observability |
| Progressive Delivery | Environment-based promotion | Needs canary/blue-green/percentage rollout manifests | Planned |
| Continuous Verification | Deployment validation | Needs latency/error/restart/alert checks during rollout | Partially implemented through deployment health score |
| Kubernetes Policy Enforcement | NetworkPolicy and security baseline | Needs broader admission policy library | Partially covered |
| Cluster Configuration Validation | Multi-cluster operations and security baseline | Needs baseline scanner for cluster settings | Planned |
| Workload Right-Sizing | Autoscaling and cost controls | Needs utilization-based request/limit recommendations | Planned; governance advisor covers generic compute rightsizing |
| Event-Driven Autoscaling | HPA pattern | Needs KEDA/custom metric scaling examples | Planned |
| Kubernetes Cost Allocation | Cost controls and labels | Needs namespace/workload usage attribution | Planned |

## Platform Engineering

| Advanced use case | Current equivalent | Gap | Implementation status |
| --- | --- | --- | --- |
| Internal Developer Platform | GitLab organization, Jenkins, AWX, GitOps | Needs portal/catalog experience | Planned |
| Golden Path Automation | Pipeline templates and shared library | Needs project scaffolding templates and service onboarding workflow | Planned |
| Developer Self-Service | Jenkins parameterized jobs | Needs approved self-service request flow | Partially covered by `projects/run-ansible-playbook` |
| Environment as a Service | Terraform environment roots | Needs request-to-MR-to-provision workflow | Planned |
| Ephemeral Environments | Environment creation/decommissioning | Needs TTL, destroy plan, and cleanup automation | Planned |
| Platform as a Product | Documentation and ownership model | Needs service metrics, feedback, roadmap, and adoption tracking | Planned |
| Service Catalog | Resilience/service ownership concepts | Needs catalog data model and ownership checks | Planned |
| Reusable Infrastructure Modules | Terraform modules | Existing modules need maturity, versioning, examples, and tests | Partially covered |
| Platform API | None beyond scripts/jobs | Needs API facade for approved actions | Planned |
| Developer Portal | None | Backstage-style portal is planned, not implemented |

## Observability and SRE

| Advanced use case | Current equivalent | Gap | Implementation status |
| --- | --- | --- | --- |
| OpenTelemetry Auto-Instrumentation | OpenTelemetry collector and tracing model | Needs language-agent and deployment examples | Planned |
| eBPF Observability | Not in original portfolio | Needs OBI/eBPF lab evaluation | Planned |
| Zero-Code Instrumentation | Not in original portfolio | Needs OTel/eBPF-based instrumentation path | Planned |
| Observability Pipelines | Telemetry routing config | Needs sampling, redaction, routing, and cost controls | Partially covered |
| Telemetry Cost Optimization | Capacity/cost monitoring | Needs cardinality/log-volume analysis | Planned |
| High-Cardinality Management | Not explicit | Needs label cardinality detection | Planned |
| SLO as Code | `slo/reference-service.yml` | Exists for reference service; needs more services and CI validation | Partially covered |
| Error-Budget Automation | SLO/error budget monitoring | Needs release gate tied to error budget | Planned |
| Deployment Health Scoring | Deployment validation | Implemented as scoring script over release telemetry | Implemented: `scripts/deployment_health_score.py` |
| Service Dependency Mapping | Dependency mapping use case | Needs catalog plus telemetry graph | Planned |
| Distributed Tracing | OpenTelemetry/Tempo model | Collector installed; app instrumentation examples needed | Partially covered |
| Continuous Profiling | Not in original portfolio | Needs OTel Profiles/eBPF profiler evaluation | Planned |
| Synthetic Monitoring | Blackbox and synthetic checks | Implemented for reference service | Partially covered |
| Real User Monitoring | Not in original portfolio | Needs browser/user signal model | Planned |
| Burn-Rate Alerting | SLO alerting mentioned | Needs Prometheus burn-rate rules | Planned |

## Best 15 Focus List

| Focus item | Status | Repo |
| --- | --- | --- |
| Terraform Drift Detector | Implemented first slice | `cloud-infra-automation-platform` |
| Automated Drift Remediation | Planned | `cloud-infra-automation-platform`, `jenkins-jobs`, `jenkins-shared-library` |
| Terraform Plan Analyzer | Implemented first slice | `cloud-infra-automation-platform` |
| Infrastructure Change Impact Analyzer | Implemented first slice | `cloud-infra-automation-platform` |
| Cloud Misconfiguration Detector | Implemented first slice | `cloud-governance-ops-automation` |
| Kubernetes Drift Monitor | Implemented first slice | `kubernetes-platform-gitops` |
| GitOps Reconciliation | Partially covered by Argo CD definition | `kubernetes-platform-gitops` |
| Automated Rollback Controller | Planned | `devsecops-cicd-orchestrator`, `kubernetes-platform-gitops` |
| Deployment Health Scoring | Implemented first slice | `observability-sre-platform` |
| SLO Burn-Rate Alerting | Planned | `observability-sre-platform` |
| Change-to-Incident Correlation | Implemented first slice | `observability-sre-platform` |
| Automated Incident Triage | Partially implemented through correlation output | `observability-sre-platform`, `healthcare-ai-platform` |
| Self-Healing Infrastructure | Planned | `cloud-governance-ops-automation`, `resilience-service-operations` |
| Cloud Cost Anomaly Detection | Implemented first slice | `cloud-governance-ops-automation` |
| Resource Right-Sizing Automation | Implemented recommendation slice | `cloud-governance-ops-automation`; Kubernetes-specific rightsizing planned |

## What Changed

The current portfolio has broad coverage. The advanced list is different
because it expects operating loops:

1. Detect drift, risk, cost, or degraded health.
2. Explain what changed and who owns it.
3. Decide whether automation may act or must pause for approval.
4. Run a controlled remediation, rollback, or reconciliation.
5. Verify recovery and leave evidence.

That operating loop should guide the next implementation work more than adding
more generic use-case rows.
