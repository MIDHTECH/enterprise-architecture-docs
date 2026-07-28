# Enterprise Project Portfolio and Use Case Coverage

**MidhHealth Integrated Care** is modeled as an integrated provider-payer
healthcare organization. Its platform supports hospital operations, digital
care, claims, eligibility, authorizations, member services, analytics,
security, and the hybrid infrastructure those services depend on.

The repositories map to the engineering teams that operate the platform:
delivery, infrastructure, Kubernetes, observability, governance, Linux systems,
databases, resilience, data engineering, network engineering, healthcare AI, and
MLOps. Each team owns a different part of the platform, but the end goal is the
same: reliable care delivery, efficient payer operations, governed data
movement, secure automation, and recoverable hybrid infrastructure.

The current implementation uses the existing VM fleet for the active systems,
database, resilience, data, and network slices. Those slices produce operating
evidence and automation without approving new product installs, new VMs, or
production capacity by themselves. The AI and ML domains add the engineering
capabilities needed for healthcare knowledge retrieval, model lifecycle,
evaluation, monitoring, and governance. The capacity plan includes
`midh-ai-edge-01`, a Mac Studio M1 for AI/ML development and edge inference,
plus a planned third Linux server with 256 GB RAM for heavier platform
workloads.

Every repository is expected to produce something reviewable for the shared
platform: code, pipelines, playbooks, GitOps state, policy checks, dashboards,
evidence, or operational runbooks.

## Healthcare Platform Requirements

The newer use cases are shaped from current healthcare technology requirements,
but the portfolio does not store job postings or copy role language. Healthcare
platform teams need hybrid systems that stay reliable while data movement is
modernized, AI workflows become safe enough to operate, and every change remains
reviewed, observable, and recoverable.

For MidhHealth, that translates into practical work:

| Platform requirement | MidhHealth use case direction |
| --- | --- |
| SRE roles now expect observability, resilience, automation, and AI-assisted operations to live together | Build alerts that carry enough context for triage, enrich incidents with runbook and dependency evidence, and measure whether automation actually reduces recovery time |
| Healthcare data roles keep asking for EHR, FHIR, HL7/X12, cloud data platforms, lineage, quality, and real-time pipelines | Treat data feeds as governed products: inventory the source, validate the schema, track lineage, monitor freshness, and make failures visible before downstream teams make decisions from stale data |
| AI roles are moving from experiments to production systems with RAG, agents, responsible AI, evaluation, and auditability | Start with constrained assistants for knowledge retrieval, claims or care-operation support, and incident summarization; require prompt/version tracking, human review, and safety checks before workflow integration |
| MLOps roles emphasize model registries, CI/CT/CD, serving, monitoring, drift, rollback, and governance evidence | Promote models like software: every candidate has data lineage, validation results, deployment evidence, telemetry, rollback path, and an owner |
| Cloud/platform roles still need CI/CD, IaC, Kubernetes, security, cost controls, and operational support | Keep the platform boring in the best way: repeatable builds, protected branches, review gates, secrets out of Git, and visible deployment evidence |

The goal is not to claim that every tool is installed today. The goal is to
define work that a healthcare platform team can operate, audit, and convert into
controlled automation.

## Executable Use-Case Standard

A use case is ready for implementation only when an engineer can turn it into a
pipeline job, playbook, script, dashboard, alert, API endpoint, policy check, or
runbook drill. Broad statements such as "improve reliability" or "modernize
data" are not enough. The repo should say what starts the work, what system is
touched, what the automation does, what evidence is produced, and what the safe
rollback or manual stop point is.

Every executable use case should answer these questions:

| Question | What good looks like |
| --- | --- |
| What starts it? | A merge request, Jenkins parameter, AWX template, GitLab schedule, alert, data-feed event, or manual incident command |
| What does it touch? | A known repo, inventory group, Kubernetes namespace, database, data feed, model artifact, dashboard, or service endpoint |
| What does it do? | Validate, deploy, scan, reconcile, collect evidence, compare drift, run a smoke test, enrich an incident, or generate a controlled report |
| How do we know it worked? | Pipeline result, AWX job ID, artifact, report, dashboard panel, alert state, SLO measurement, audit log, or runbook evidence |
| How do we keep it safe? | Protected branch, allowlist, dry-run mode, `CONFIRM_APPLY`, scoped credentials, no protected data by default, and documented rollback |

## Executable Backlog

This is the first cross-project backlog that should be converted into real
automation. It deliberately favors work we can prove in the lab over vague
enterprise ambitions.

| Backlog item | Primary repo | Executable form | Evidence produced |
| --- | --- | --- | --- |
| Run an approved Ansible playbook by selecting project, branch, inventory, playbook, and extra vars | `jenkins-jobs`, `jenkins-shared-library` | Jenkins parameterized job calls AWX after allowlist checks | Jenkins build log, AWX project sync, AWX job ID, playbook result |
| Check Linux fleet patch and baseline posture without changing hosts | `linux-systems-platform` | AWX evidence playbook in check/read-only mode | Host report for package, service, firewall, SELinux, disk, time, and access posture |
| Detect Linux configuration drift before a maintenance window | `linux-systems-platform` | Scheduled playbook compares desired controls with live state | Drift report, failed-control list, remediation candidate list |
| Validate database backup readiness and restore evidence | `database-reliability-platform` | AWX playbook checks backup jobs, last successful run, storage, and restore notes | Backup readiness report and restore-test evidence |
| Capture database performance and connection pressure | `database-reliability-platform` | Read-only SQL and host checks gathered through AWX | Query latency, connection, storage, and saturation report |
| Build a service readiness view for a care or payer workflow | `resilience-service-operations` | Service catalog plus SLO and dependency checks | Service owner, dependency, SLO, incident, and readiness record |
| Enrich an incident with recent deployments and runbook links | `observability-sre-platform`, `resilience-service-operations` | Alert rule or script joins alert labels, GitLab changes, service catalog, and runbook metadata | Incident context bundle and RCA starter note |
| Watch freshness for an EHR, claims, eligibility, or provider feed | `data-engineering-platform` | Scheduled data-quality check validates arrival time, schema, and row-count thresholds | Feed freshness report, schema result, downstream-consumer impact |
| Track data lineage from source feed to dashboard or model | `data-engineering-platform` | Metadata inventory and validation script | Source owner, transform path, consumers, and stale-link findings |
| Validate DNS, DHCP, proxy, and Kubernetes network paths before change | `network-engineering-platform` | Pre/post network check playbook | Resolver, route, port, ingress, and rollback evidence |
| Run a safe healthcare RAG prototype over approved documents | `healthcare-ai-platform` | Local Mac Studio or CI job indexes approved docs and runs evaluation prompts | Citation quality, answer quality, latency, and prompt/version report |
| Summarize an incident or runbook with citations | `healthcare-ai-platform`, `observability-sre-platform` | Controlled AI workflow uses approved incident notes and runbooks | Summary, cited sources, confidence notes, and human-review marker |
| Register and validate a small model artifact | `mlops-model-platform` | CI job records run metadata, validation metrics, and promotion decision | Model card, metric report, approval status, rollback reference |
| Detect model or data drift for a lab inference endpoint | `mlops-model-platform`, `data-engineering-platform` | Scheduled evaluation compares current sample distribution and output metrics | Drift report, SLO status, retraining recommendation |
| Confirm a release is observable before promotion | `devsecops-cicd-orchestrator`, `observability-sre-platform` | Pipeline gate checks health endpoint, metrics, logs, traces, and rollback metadata | Release evidence bundle and promotion decision |

These backlog items are the bridge between job-derived requirements and code.
Each one can become a GitLab issue, Jenkins job, AWX template, playbook, CI
stage, dashboard, or runbook without inventing a new product installation.

## 2026 Automation Focus Areas

The next implementation wave should focus on automation that keeps desired
state, runtime health, and deployment evidence connected. These areas are
current because teams are no longer satisfied with "we have Terraform" or "we
have monitoring." They want the platform to notice drift, explain impact,
propose a safe action, and prove the system recovered.

| Area | What MidhHealth should build next | Primary repos |
| --- | --- | --- |
| Infrastructure automation | Terraform drift detection, plan automation, state integrity checks, change impact analysis, policy-driven provisioning, and reconciliation loops | `cloud-infra-automation-platform`, `devsecops-cicd-orchestrator`, `cloud-governance-ops-automation` |
| Cloud operations automation | Event-driven remediation, runbook automation, human-approved recovery, cost anomaly detection, and right-sizing recommendations | `cloud-governance-ops-automation`, `resilience-service-operations`, `observability-sre-platform` |
| Kubernetes automation | GitOps reconciliation, live-vs-Git drift checks, automated rollback, progressive delivery, continuous verification, policy enforcement, and workload right-sizing | `kubernetes-platform-gitops`, `observability-sre-platform`, `devsecops-cicd-orchestrator` |
| Platform engineering | Internal developer portal, service catalog, golden paths, environment templates, reusable infrastructure modules, and self-service requests | `cloud-infra-automation-platform`, `kubernetes-platform-gitops`, `jenkins-jobs`, `jenkins-shared-library` |
| Observability and SRE | OpenTelemetry instrumentation, eBPF/zero-code visibility, observability pipelines, SLO as code, burn-rate alerting, health scoring, change correlation, and incident triage | `observability-sre-platform`, `resilience-service-operations`, `healthcare-ai-platform` |

The priority implementation path is a closed-loop workflow: detect drift or
degraded health, explain the operational impact, require approval when risk is
high, run a controlled remediation, and verify recovery.

| Focus item | Executable implementation |
| --- | --- |
| Terraform Drift Detector | Scheduled Terraform plan compares state and provider reality; output becomes a drift report |
| Automated Drift Remediation | Approved Jenkins/AWX workflow reapplies the reviewed Terraform configuration |
| Terraform Plan Analyzer | Merge requests publish summarized creates, updates, destroys, and risky dependencies |
| Infrastructure Change Impact Analyzer | Pipeline maps changed Terraform resources to apps, data feeds, routes, SLOs, and owners |
| Cloud Misconfiguration Detector | Policy scan checks public exposure, weak IAM, missing tags, encryption, backups, and logging |
| Kubernetes Drift Monitor | Script compares Git manifests with live cluster objects and flags unmanaged changes |
| GitOps Reconciliation | Argo CD or Flux restores approved desired state after review |
| Automated Rollback Controller | Deployment health score fails promotion and rolls back when SLO or smoke checks fail |
| Deployment Health Scoring | Release gate combines health endpoint, error rate, latency, logs, and recent alerts |
| SLO Burn-Rate Alerting | Prometheus rules alert on fast and slow budget burn, not just raw downtime |
| Change-to-Incident Correlation | Incident context links alerts to recent commits, deployments, Terraform plans, and GitOps syncs |
| Automated Incident Triage | Guarded workflow gathers service owner, dependency, dashboard, runbook, and likely change source |
| Self-Healing Infrastructure | Low-risk failures trigger known recovery playbooks, followed by validation |
| Cloud Cost Anomaly Detection | Scheduled report flags spend or usage jumps by project, owner, environment, or service |
| Resource Right-Sizing Automation | Utilization data proposes CPU, memory, storage, and replica adjustments with approval gates |

Current external signals support this direction. CNCF's Q1 2026 Technology
Radar placed Helm, Backstage, and kro in the application-delivery "Adopt"
category, and OpenTelemetry's 2026 eBPF work emphasizes production readiness
and hybrid instrumentation. MidhHealth should use those signals pragmatically:
Backstage-style portal and catalog work belongs in the platform backlog; Helm
and GitOps belong in Kubernetes delivery; OpenTelemetry and eBPF belong in
observability, profiling, and incident evidence.

## Enterprise Architecture

```mermaid
flowchart TB
    org[MidhHealth Integrated Care] --> git[GitLab Organization: midhhealth]
    org --> teams[Platform, SRE, Security, Data, Network and App Teams]
    teams --> git
    git --> apprepo[Application and Project Repositories]
    git --> docsrepo[Enterprise Architecture Documentation]
    git --> infrarepo[Infrastructure Repositories]
    apprepo --> cicd[DevSecOps CI/CD Orchestrator]
    cicd --> scans[Security and Quality Gates]
    cicd --> artifacts[Container Image and Build Artifacts]
    cicd --> awx[AWX or Ansible Automation]

    engineer[Cloud or Platform Engineer] --> infrarepo
    infrarepo --> iac[Multi-Cloud Infrastructure Automation]
    iac --> aws[AWS Infrastructure]
    iac --> azure[Azure Infrastructure]
    iac --> gcp[GCP Infrastructure]
    iac --> ansible[Ansible Host Configuration]

    iac --> k8s[Kubernetes Platform Engineering and GitOps]
    artifacts --> k8s
    k8s --> apps[Containerized Applications]

    apps --> obs[Observability and SRE Reliability Platform]
    k8s --> obs
    aws --> obs
    azure --> obs
    gcp --> obs

    sec[Cloud Governance, Security, and Operations Automation]
    sec --> iac
    sec --> k8s
    sec --> obs
    sec --> cicd

    systems[Linux Systems Engineering]
    database[Database Engineering and Reliability]
    resilience[Resilience and Service Operations]
    data[Data Engineering and Integration]
    network[Network Engineering and Automation]
    ai[Healthcare AI Platform]
    ml[MLOps Model Platform]

    iac --> systems
    network --> iac
    network --> k8s
    systems --> database
    systems --> data
    database --> data
    data --> apps
    obs --> resilience
    resilience --> systems
    resilience --> database
    sec --> systems
    sec --> database
    sec --> data
    sec --> network
    data --> ai
    data --> ml
    ai --> apps
    ml --> ai
    obs --> ml

    onprem[On-Prem KVM and Kubernetes] --> k8s
    cloudtarget[Governed Cloud Targets] --> aws
    cloudtarget --> azure
    cloudtarget --> gcp
```

## Organization Model

| Layer | Shared organizational capability |
| --- | --- |
| Business model | Integrated care delivery and health insurance provider |
| Provider operations | Hospital systems, clinical platforms, digital care, patient access, and care operations |
| Payer operations | Claims, eligibility, authorizations, member services, payment integrity, and analytics |
| Source control | One `midhhealth` GitLab organization, domain subgroups, protected branches, merge requests, and audit trail |
| Delivery | Jenkins, GitLab CI, AWX, Ansible, Terraform, GitOps, and reusable shared libraries |
| On-premises platform | KVM/libvirt, Rocky Linux VMs, DNS, NGINX, Kubernetes, observability, and product VMs |
| Cloud platform | AWS, Azure, and GCP foundations managed through the same Terraform, Ansible, CI, governance, and review model |
| AI/ML edge | Mac Studio M1 `midh-ai-edge-01` for non-production inference, embeddings, notebooks, and evaluation |
| Memory-optimized expansion | Planned 256 GB Linux server for data, observability, AI/ML backend workloads, and resilience exercises |
| Governance | Security, secrets, compliance, cost, backup, certificate, and change controls across both on-prem and cloud |
| Operations | SLOs, incident evidence, runbooks, platform telemetry, and controlled remediation |

## Portfolio Status

| # | Repository | Status on 2026-07-27 |
| ---: | --- | --- |
| 1 | `devsecops-cicd-orchestrator` | Active implementation |
| 2 | `cloud-infra-automation-platform` | Active implementation |
| 3 | `kubernetes-platform-gitops` | Active implementation |
| 4 | `observability-sre-platform` | Active implementation |
| 5 | `cloud-governance-ops-automation` | Active implementation |
| 6 | `linux-systems-platform` | Active first implementation slice against existing VM fleet |
| 7 | `database-reliability-platform` | Active first implementation slice against existing VM fleet |
| 8 | `resilience-service-operations` | Active first implementation slice against existing VM fleet |
| 9 | `data-engineering-platform` | Active first implementation slice against existing VM fleet |
| 10 | `network-engineering-platform` | Active first implementation slice against existing VM fleet |
| 11 | `healthcare-ai-platform` | Approved AI platform project; implementation planned |
| 12 | `mlops-model-platform` | Approved ML platform project; implementation planned |

The Linux systems, database reliability, resilience/service operations, data
engineering, and network engineering teams use existing automation, GitLab,
Jenkins/AWX, and VM capacity unless a documented capacity expansion is approved.
Their first implementation slices do not authorize product installation.

The healthcare AI and MLOps teams are approved logical platform domains. The
Mac Studio may be used for AI/ML development, local inference, embeddings,
notebooks, evaluation, and CI smoke tests. The planned 256 GB Linux server may
host heavier backend data, observability, AI/ML batch, and model-serving
workloads after installation and placement controls are documented. Protected
data access, production model deployment, external model providers, and
regulated AI workflows still require separate approval.

## GitLab Repository Model

All projects and documentation should live in GitLab so code, review, approvals, and evidence are tied together.

For the standard branch naming, merge request, protected branch, environment, and rollback model, see [Enterprise Branching Strategy](branching-strategy.md).

Recommended GitLab organization:

```text
midhhealth/
```

Recommended subgroups and repositories:

| GitLab path | Purpose |
| --- | --- |
| `midhhealth/enterprise-architecture/enterprise-architecture-docs` | Architecture diagrams, use case mapping, implementation roadmap, engineer interview narratives |
| `midhhealth/platform-delivery/devsecops-cicd-orchestrator` | Jenkins/GitLab CI pipeline, security gates, Docker build, AWX/Ansible deployment |
| `midhhealth/platform-delivery/jenkins-jobs` | Jenkins Job DSL seed jobs and managed pipeline definitions |
| `midhhealth/platform-delivery/jenkins-shared-library` | Reusable Jenkins pipeline steps, including AWX launch helper |
| `midhhealth/platform-engineering/cloud-infra-automation-platform` | Terraform and Ansible automation for AWS, Azure, and GCP infrastructure |
| `midhhealth/platform-engineering/kubernetes-platform-gitops` | AKS/EKS/GKE platform, Helm, Argo CD/Flux, ingress, policy, autoscaling |
| `midhhealth/platform-engineering/linux-systems-platform` | Linux lifecycle, KVM, patching, configuration, storage, DNS and system services |
| `midhhealth/platform-engineering/network-engineering-platform` | IPAM, DNS/DHCP, routing, switching, firewalls, VPN, cloud and Kubernetes networking |
| `midhhealth/reliability-operations/observability-sre-platform` | Prometheus, Grafana, logs, traces, alerts, SLOs, incident dashboards |
| `midhhealth/reliability-operations/resilience-service-operations` | SLOs, incidents, capacity, performance, exercises, DR and service operations |
| `midhhealth/reliability-operations/ansible-observability` | Native observability product installation and operations |
| `midhhealth/reliability-operations/ansible-prometheus` | Prometheus, Grafana, and Node Exporter installation automation |
| `midhhealth/security-governance/cloud-governance-ops-automation` | IAM/RBAC, secrets, compliance, backup, DR, cost, certificate, remediation automation |
| `midhhealth/data-and-integration/database-reliability-platform` | Database lifecycle, performance, backup, recovery, security and upgrades |
| `midhhealth/data-and-integration/data-engineering-platform` | Batch/stream ingestion, orchestration, transformation, quality, lineage and lakehouse patterns |
| `midhhealth/ai-and-ml-platform/healthcare-ai-platform` | RAG, agentic workflows, AI assistants, FHIR-aware APIs, responsible AI controls, and AI workflow integration |
| `midhhealth/ai-and-ml-platform/mlops-model-platform` | ML lifecycle, feature pipelines, model registry, CI/CT/CD, serving, monitoring, drift, retraining, and model governance |
| `midhhealth/care-delivery-platform` | Future clinical, patient access, digital care, and hospital operations applications |
| `midhhealth/payer-operations-platform` | Future claims, eligibility, authorizations, member services, and payment integrity applications |

Recommended GitLab flow:

```mermaid
flowchart LR
    dev[Engineer] --> branch[Feature Branch]
    branch --> mr[Merge Request]
    mr --> checks[Pipeline: validate, test, scan, plan]
    checks --> review[Code Review and Approval]
    review --> main[Main Branch]
    main --> deploy[Deploy or Apply Pipeline]
```

That makes GitLab the source of truth for code, infrastructure, documentation, merge requests, approvals, and CI/CD evidence.

## Delivery Standards

Each project should include these controls:

| Standard | Expected implementation |
| --- | --- |
| Repository ownership | Clear README, maintainers, protected branches, merge request approvals |
| Environment separation | `dev`, `qa`, `stage`, and `prod` folders or variables |
| CI/CD governance | Validate, test, scan, plan, approval, deploy stages |
| Security controls | Secrets scanning, dependency scanning, IaC scanning, image scanning |
| Change management | Merge requests, approval gates, deployment evidence, rollback notes |
| Operational readiness | Runbooks, troubleshooting guide, smoke tests, dashboards, alerts |
| Compliance evidence | Policy results, scan reports, tagging, IAM reviews, backup validation |
| Cost management | Required tags, resource sizing variables, scheduled cleanup where applicable |

## End-to-End Flow

```mermaid
sequenceDiagram
    participant Dev as Developer
    participant Git as GitLab
    participant CI as Jenkins/GitHub Actions/Azure DevOps
    participant TF as Terraform
    participant CM as Ansible/AWX
    participant K8s as AKS/EKS/GKE
    participant Obs as Observability
    participant Sec as Governance

    Dev->>Git: Commit application or infrastructure code
    Git->>CI: Trigger pipeline
    CI->>CI: Build, test, scan, package
    CI->>TF: Plan and apply infrastructure
    TF->>CM: Provide compute inventory and outputs
    CM->>CM: Patch and configure Linux hosts
    CI->>K8s: Deploy container workload
    K8s->>Obs: Emit metrics, logs, and traces
    Sec->>CI: Enforce security and compliance checks
    Sec->>TF: Validate policy, tags, IAM, and cost controls
    Obs->>Dev: Alert, dashboard, and RCA feedback
```

## Enterprise DevSecOps Delivery Platform

**Purpose:** Automate application delivery from source code commit to secure deployment.

**Main tools:** GitLab, Jenkins, Docker, pytest, Trivy or similar scanners, AWX, Ansible.

**Architecture:**

![DevSecOps delivery architecture](assets/project-1-delivery-architecture.svg)

This diagram shows the project architecture, control boundaries, runtime targets, evidence flow, and operational feedback loop.

**What this covers:**

| Use case | Coverage |
| --- | --- |
| End-to-End CI/CD Pipeline Setup | Implemented through Jenkins pipeline stages from checkout to deployment |
| Automated Build Pipeline | Build process runs in pipeline instead of local machines |
| Automated Unit Testing in CI | Tests run before package/deploy stages |
| Code Quality Gate Integration | Pipeline has a place for quality scans and gating |
| Artifact Management Automation | Build outputs and Docker images can be versioned and published |
| Docker Image Build and Registry Push | Pipeline builds container images and can push to registry |
| Environment-Based Release Promotion | Pipeline supports environment variables and promotion gates |
| Automated Rollback Controller | Pipeline reverses deployments when health or SLO checks fail |
| Pipeline Template Standardization | Jenkins shared library and job DSL standardize pipelines |
| Secure CI/CD Pipeline Implementation | Security checks are embedded into delivery workflow |
| Secrets Detection in Source Code | Pipeline can run Gitleaks/TruffleHog-style checks |
| Container Image Vulnerability Scanning | Pipeline can scan images before deployment |
| Dependency Vulnerability Management | Dependency scanning fits before image build/deploy |
| Terraform Plan Automation | Merge requests publish reviewed Terraform plan artifacts |
| Deployment Health Scoring | Release gates score health, SLO burn, alerts and rollback readiness |

## Enterprise Multi-Cloud Infrastructure Platform

**Purpose:** Provision cloud infrastructure consistently using Terraform and configure compute with Ansible.

**Main tools:** Terraform, Ansible, AWS, Azure, GCP, cloud CLIs, managed PostgreSQL, object storage, VM compute, container platforms.

**Architecture:**

![MidhHealth hybrid infrastructure architecture](assets/project-2-hybrid-infrastructure-architecture.svg)

This is the infrastructure architecture layer for the enterprise platform. It
shows healthcare channels, on-premises facilities, shared platform services,
cloud landing zones, observability/evidence collection, and the
Terraform/Ansible control loop that keeps changes reviewed, traceable, and
recoverable.

**What this covers:**

| Use case | Coverage |
| --- | --- |
| Terraform Drift Detection | Scheduled Terraform plan detects resources changed outside approved code |
| Azure Infrastructure Provisioning Using Terraform | Azure stack covers resource group, VNet, VM, storage, database, container platform |
| AWS VPC Landing Zone Setup | AWS stack covers VPC, subnet, security group, storage, database, compute |
| Terraform Plan Analyzer | Plan output summarizes creates, updates, destroys and replacement risk |
| Server Configuration Automation Using Ansible | Ansible configures Linux hosts after provisioning |
| Linux Server Patch Automation | Ansible common role handles package baseline and can run patching |
| Infrastructure Change Impact Analysis | Planned changes map to services, owners, SLOs, data feeds and runbooks |
| Cloud Resource Tagging Automation | Terraform variables and common tags standardize ownership/cost metadata |
| Terraform State Integrity Monitoring | State backend, lock behavior and unexpected modifications are validated |
| Environment Standardization Across Dev/Test/Prod | Same modules and variables can drive multiple environments |
| Infrastructure Reconciliation Loop | Desired and actual infrastructure state are compared on a schedule |
| Policy-Driven Provisioning | Terraform changes are blocked when they violate standards |

## Enterprise Kubernetes Platform with GitOps

**Purpose:** Build a standardized container platform for application teams.

**Main tools:** Kubernetes, AKS/EKS/GKE, Helm, Argo CD or Flux CD, Kustomize, ingress controller, OPA Gatekeeper or Kyverno.

**Architecture:**

![Kubernetes GitOps architecture](assets/project-3-kubernetes-gitops-architecture.svg)

This diagram shows the project architecture, control boundaries, runtime targets, evidence flow, and operational feedback loop.

**What this covers:**

| Use case | Coverage |
| --- | --- |
| AKS/EKS/GKE Cluster Provisioning Automation | Terraform creates managed Kubernetes clusters |
| Kubernetes Configuration Drift | Live cluster state is compared with Git-defined desired state |
| Kubernetes Application Deployment | Helm/Kustomize deploy application workloads |
| GitOps Reconciliation | Argo CD or Flux restores approved desired state and records sync health |
| Continuous Verification | Rollouts check latency, errors, restarts and alert state before promotion |
| Kubernetes Security Baseline Implementation | Policies enforce pod and namespace standards |
| Kubernetes Security Policy Enforcement | OPA Gatekeeper/Kyverno blocks unsafe workloads |
| Kubernetes Policy-as-Code Governance | Cluster rules are version-controlled |
| Ingress and Traffic Management Standardization | Common ingress, TLS, DNS, and routing pattern |
| Workload Right-Sizing | CPU and memory requests are adjusted from observed utilization |
| Container Registry and Image Supply Chain Security | Trusted registries and image scanning controls |
| Event-Driven Autoscaling | Workloads scale from queues, events or custom metrics |
| Kubernetes Cost Allocation | Namespace and workload usage is attributed to teams and applications |

## Enterprise Observability and SRE Reliability Platform

**Purpose:** Monitor applications, infrastructure, and Kubernetes platforms so incidents can be detected and resolved faster.

**Main tools:** Prometheus, Grafana, Loki, Tempo, OpenTelemetry, Alertmanager,
a three-node Elastic Stack, standalone Splunk Enterprise, and cloud monitoring
services.

**Architecture:**

![Observability and SRE architecture](assets/project-4-sre-observability-architecture.svg)

This diagram shows the project architecture, control boundaries, runtime targets, evidence flow, and operational feedback loop.

The three observability paths are intentional: the Grafana stack demonstrates
cloud-native open-source operations, Elastic demonstrates clustered log
search, and Splunk demonstrates a licensed enterprise platform. The Elastic
and Splunk VMs are provisioned-only until their AWX runbooks complete.

**What this covers:**

| Use case | Coverage |
| --- | --- |
| Kubernetes Cluster Health Monitoring | Dashboards for pods, nodes, namespaces, restarts, and capacity |
| OpenTelemetry Auto-Instrumentation | Standardized zero-touch metrics, logs and traces for supported workloads |
| Centralized Log Management | Logs from pods, VMs, and services collected centrally |
| eBPF Observability | Kernel-level telemetry captures runtime behavior where code changes are not practical |
| Alerting and On-Call Notification | Alerts route to incident channels or PagerDuty-style tools |
| SLO as Code | Service objectives and alert thresholds are versioned in Git |
| Production Incident Troubleshooting Dashboard | Single triage view for incidents |
| Deployment Health Scoring | Release health combines latency, errors, restarts, logs, traces and synthetic checks |
| API Error Rate Monitoring | Tracks 4xx, 5xx, timeout, and dependency failures |
| Database Performance Monitoring | Database health and query symptoms can be dashboarded |
| Telemetry Cost Optimization | Noisy metrics, high-cardinality labels, verbose logs and retention costs are controlled |
| Synthetic Monitoring | External checks validate user-facing availability |
| Cloud-Native Monitoring | Cloud-managed services included in dashboards |
| Change-to-Incident Correlation | Incidents link to recent commits, deployments, Terraform plans and GitOps syncs |
| Automated Incident Triage | Triage output includes owner, dependency, dashboard, runbook and likely change source |
| Burn-Rate Alerting | Fast and slow error-budget burn alerts replace noisy symptom-only paging |

## Enterprise Cloud Governance and Operations Automation

**Purpose:** Enforce security, compliance, cost, backup, certificate, and operational controls across cloud and Kubernetes environments.

**Main tools:** Terraform, Ansible, Checkov/tfsec, cloud IAM, Azure Key Vault/AWS Secrets Manager/GCP Secret Manager, policy as code, backup services, cost tools, automation scripts.

**Architecture:**

![Governance automation architecture](assets/project-5-governance-automation-architecture.svg)

This diagram shows the project architecture, control boundaries, runtime targets, evidence flow, and operational feedback loop.

**What this covers:**

| Use case | Coverage |
| --- | --- |
| Secrets Management Automation | Centralize application and pipeline secrets |
| Secure Secrets Management for Applications | Runtime secret injection avoids hardcoded credentials |
| Cloud IAM and RBAC Standardization | Least-privilege roles and access patterns |
| Secrets Management with Key Vault | Azure-focused secrets implementation path |
| Cloud Misconfiguration Detector | Policy scans find public exposure, weak IAM, missing encryption, backup and logging gaps |
| Automated Compliance Scanning | Checkov/tfsec/policy checks run in pipelines |
| Infrastructure Security Hardening | Enforces baseline cloud and Linux controls |
| Private Endpoint Implementation | Restricts service access to private networks |
| DNS and Certificate Management | Standardizes DNS and certificate lifecycle |
| Certificate Expiry Monitoring | Alerts before certificate expiration |
| Runbook Automation | Operational procedures become executable scripts or AWX workflows |
| Event-Driven Remediation | Alerts, cloud events or policy findings trigger guarded automation |
| Human-in-the-Loop Remediation | High-risk remediation pauses for approval before execution |
| Closed-Loop Automation | Detect, remediate, validate and record recovery for low-risk failures |
| Self-Healing Infrastructure | Known safe failures are repaired and verified automatically |
| Cloud Cost Anomaly Detection | Spend or usage spikes are detected by owner and environment |
| Resource Right-Sizing Automation | Utilization recommends CPU, memory, storage and replica adjustments |
| Automated Root-Cause Analysis | Telemetry, deployment and infrastructure changes are correlated for RCA |
| Intelligent Alert Deduplication | Repeated alerts are grouped into actionable incidents |

## Enterprise Linux Systems Engineering Platform

**Status:** Active first implementation slice. The repository manages Linux
operations use cases against the existing VM fleet; it does not create new VMs
or install major products.

**Purpose:** Standardize the lifecycle and operation of enterprise Linux,
virtualization, storage, network services, and system software.

**Candidate tools:** Ubuntu, Rocky Linux, KVM/libvirt, cloud-init, Ansible,
AWX, systemd, SELinux, firewalld, BIND, NGINX, LVM and XFS.

**Operational launcher:** Jenkins job `projects/run-ansible-playbook` invokes
the `jenkins-shared-library` `ansibleAwxPipeline` step, which reconciles AWX
project, inventory, inventory source, and job template objects before launching
the selected playbook. `playbooks/site.yml` requires `CONFIRM_APPLY=true`.

**Architecture:**

![Linux systems platform architecture](assets/project-6-linux-systems-architecture.svg)

This diagram shows the Linux systems architecture, control boundaries, existing
fleet targets, evidence flow, and operational feedback loop.

| Use case | Coverage target |
| --- | --- |
| Ubuntu and Rocky Linux Installation Standards | Reproducible supported operating-system builds |
| KVM and libvirt Virtualization | Managed hypervisor, network, storage-pool and domain lifecycle |
| VM Provisioning with cloud-init | Repeatable identity, network and SSH bootstrap |
| Server Build and Retirement | Approved creation, handoff, backup and decommission workflow |
| AWX and Ansible Configuration Management | Idempotent configuration through version-controlled roles |
| Operating-System Patching | Assessed, scheduled and evidenced security updates |
| Kernel and Major-Version Upgrades | Rehearsed upgrade and rollback workflow |
| SELinux and Firewall Management | Enforced host security controls |
| systemd Service Management | Standard service ownership, health and recovery |
| Filesystem, LVM and Storage Management | Capacity, mount, ownership and recovery standards |
| DNS, NTP and Host Networking | Consistent infrastructure service configuration |
| SSH, sudo and Service Accounts | Least-privilege administrative access |
| Package Repository Management | Approved and pinned software sources |
| Performance and Capacity Troubleshooting | CPU, memory, disk and network diagnosis |
| Configuration-Drift Detection | Desired-state comparison and remediation |
| Server Compliance Evidence | Auditable operating-system and service posture |
| Break-Glass Recovery | Console, boot, filesystem and access recovery |

## Enterprise Database Engineering and Reliability Platform

**Status:** Planned. PostgreSQL installation remains gated behind AWX.

**Purpose:** Operate database platforms as reliable, secure, recoverable and
performance-managed enterprise services.

**Candidate tools:** PostgreSQL, PgBouncer, Ansible/AWX, pgBackRest, SQL
migration tools, Prometheus exporters, Grafana and Vault.

**Architecture:**

![Database reliability architecture](assets/project-7-database-reliability-architecture.svg)

This diagram shows the database reliability architecture, control boundaries,
runtime targets, evidence flow, and operational feedback loop.

| Use case | Coverage target |
| --- | --- |
| PostgreSQL Installation Through AWX | Versioned and repeatable installation |
| Database and Role Provisioning | Approved service onboarding |
| Schema Migration Automation | Ordered, tested and reversible changes |
| Backup and Point-in-Time Recovery | Defined recovery points and retention |
| Automated Restore Validation | Evidence that backups are usable |
| Major-Version Upgrade Automation | Rehearsed upgrade using supported methods |
| Minor Patching | Controlled maintenance with health validation |
| Database Performance Monitoring | Availability, latency, throughput and saturation |
| Slow-Query Analysis | Query diagnosis and remediation evidence |
| Index and Statistics Maintenance | Controlled database optimization |
| Connection Pooling | PgBouncer lifecycle and capacity controls |
| TLS and Credential Rotation | Encrypted access and managed identities |
| Database Auditing | Privileged and sensitive activity evidence |
| Capacity Forecasting | Storage, connection and workload growth |
| Replication and Failover Exercises | Explicit cluster-only reliability testing |
| RPO and RTO Validation | Measured recovery objectives |
| Application Database Onboarding | Ownership, access, SLO and backup contract |
| Data Retention and Archival | Policy-driven lifecycle management |
| Database Incident Runbooks | Repeatable diagnosis, escalation and recovery |

## Enterprise Resilience and Service Operations Platform

**Status:** Planned.

**Purpose:** Turn observability signals into reliable service operations,
incident response, performance engineering and tested recovery.

**Candidate tools:** Prometheus, Alertmanager, Grafana, Loki, Tempo,
OpenTelemetry, Elastic, Splunk, AWX, k6, JMeter, Litmus or Chaos Mesh.

**Architecture:**

![Resilience operations architecture](assets/project-8-resilience-operations-architecture.svg)

This diagram shows the service operations architecture, control boundaries,
runtime targets, evidence flow, and operational feedback loop.

| Use case | Coverage target |
| --- | --- |
| SLI and SLO Governance | Standard service-level objectives |
| Error-Budget Management | Release and reliability decisions based on risk |
| Incident Detection and Classification | Consistent severity and ownership |
| On-Call and Escalation Workflows | Defined response routing |
| Automated Incident Evidence Collection | Logs, metrics, traces and changes captured |
| Post-Incident Review | Blameless corrective-action tracking |
| Problem Management | Recurring failure elimination |
| Service Ownership | Named technical and business accountability |
| Dependency Mapping | Runtime and service relationship visibility |
| Synthetic Monitoring | User-path availability testing |
| Capacity and Saturation Testing | Resource-limit discovery |
| Load and Performance Testing | Repeatable workload validation |
| Chaos and Failure Exercises | Controlled dependency and component failures |
| Backup and Recovery Orchestration | Coordinated service recovery |
| Disaster-Recovery Exercises | Full workflow rehearsal |
| RTO and RPO Measurement | Evidence-based recovery objectives |
| Certificate and Secret Expiry Response | Proactive and automated renewal response |
| AWX Automated Remediation | Guarded, auditable operational fixes |
| Maintenance-Window Management | Planned service-impact coordination |
| Operational Readiness Reviews | Production-readiness scorecards and gates |

## Enterprise Data Engineering and Integration Platform

**Status:** Planned.

**Purpose:** Provide governed batch, streaming, transformation, quality,
lineage and data-serving capabilities for enterprise data products.

**Candidate tools:** Airflow, Kafka, Debezium, Apicurio or Schema Registry,
dbt, Spark or Flink, MinIO/S3, Iceberg, Trino, OpenMetadata or DataHub.

**Architecture:**

![Data engineering architecture](assets/project-9-data-engineering-architecture.svg)

This diagram shows the data engineering architecture, source and consumer
boundaries, evidence flow, and operational feedback loop.

| Use case | Coverage target |
| --- | --- |
| Batch Data Ingestion | Scheduled and recoverable source ingestion |
| Streaming Data Ingestion | Durable event-driven data movement |
| Change-Data Capture | Database changes published without application coupling |
| ETL and ELT Pipelines | Standard extract, load and transform patterns |
| Workflow Orchestration | Dependency, retry and scheduling control |
| Data Quality Validation | Automated completeness, validity and freshness checks |
| Schema Registry and Evolution | Compatible event and dataset contracts |
| Event-Contract Management | Ownership and versioning of event interfaces |
| dbt Data Transformation | Tested SQL transformation and documentation |
| Distributed Data Processing | Scalable batch or stream computation |
| Data Lake and Lakehouse Storage | Governed object and table storage |
| Data Warehouse Integration | Controlled analytical serving |
| Metadata Catalog and Discovery | Searchable datasets and ownership |
| Data Lineage | Source-to-consumer traceability |
| Data Classification | Sensitivity and regulatory metadata |
| PII Controls | Restricted handling of personal data |
| Data Retention and Archival | Policy-driven dataset lifecycle |
| Pipeline Monitoring and Alerting | Freshness, failure and latency signals |
| Pipeline Retry and Backfill | Safe historical reprocessing |
| Dead-Letter Queues and Replay | Recoverable event-processing failures |
| Data Reconciliation | Source and target correctness validation |
| Dataset Ownership | Data-product accountability and support |
| Data Access Governance | Approved, auditable consumer access |
| Data-Pipeline Disaster Recovery | Restored orchestration, state and data |
| Data Performance and Cost Optimization | Efficient compute, storage and retention |

## Enterprise Network Engineering and Automation Platform

**Status:** Planned.

**Purpose:** Establish network source of truth, automation, segmentation,
connectivity, observability and safe change across on-prem and cloud.

**Candidate tools:** NetBox or Nautobot, Ansible network collections, BIND,
Kea, FRRouting or VyOS, containerlab/EVE-NG, Cilium/Hubble, MetalLB, WireGuard,
Prometheus, Blackbox Exporter, SNMP Exporter, Elastic and Splunk.

**Architecture:**

![Network engineering architecture](assets/project-10-network-engineering-architecture.svg)

This diagram shows the network engineering architecture, source-of-truth
boundary, connectivity domains, evidence flow, and operational feedback loop.

| Use case | Coverage target |
| --- | --- |
| Enterprise IP Address Management | Governed address and prefix allocation |
| VLAN and Subnet Design | Standard segmentation and routing domains |
| DHCP Reservation Management | Controlled address-to-MAC assignments |
| Authoritative and Recursive DNS | Managed internal name resolution |
| Forward and Reverse DNS Automation | Synchronized A/PTR lifecycle |
| Router and Switch Configuration Backup | Recoverable network state |
| Network Configuration Automation | Version-controlled Ansible changes |
| Network Configuration-Drift Detection | Desired versus running-state comparison |
| Layer 2 Bridge Management | Host and virtualization switching |
| Layer 3 Routing | Static and dynamic route control |
| Firewall Policy Management | Reviewed least-privilege traffic policy |
| NAT and Egress Management | Controlled outbound and translation paths |
| Load Balancer and Reverse Proxy Configuration | Standard application entry points |
| VPN and Remote Access | Managed encrypted administration connectivity |
| Cloud VPC and VNet Networking | Reusable cloud network foundations |
| Hybrid-Cloud Connectivity | Routed and secured environment integration |
| Kubernetes Networking | Cluster dataplane and service networking |
| CNI Policy and Troubleshooting | Cilium/Hubble policy and visibility |
| Ingress and Egress Controls | Governed workload traffic paths |
| MetalLB Address Management | Controlled service address pools |
| Network Segmentation | Environment and trust-zone isolation |
| Private Endpoint and Private DNS | Non-public managed-service access |
| Certificate and TLS Routing | Trusted encrypted service entry |
| Network Performance Monitoring | Latency, loss, throughput and saturation |
| Flow-Log Analysis | Traffic behavior and security investigation |
| Packet Capture and Troubleshooting | Evidence-based protocol diagnosis |
| Network Availability Testing | Synthetic and blackbox validation |
| Network Configuration Compliance | Auditable device and service standards |
| Network Incident Response | Repeatable diagnosis and restoration |
| Capacity and Bandwidth Planning | Forecasted network growth |
| Network Change Validation and Rollback | Pre/post checks and safe recovery |

## Enterprise Healthcare AI Platform

**Status:** Approved planned project.

**Purpose:** Build production-ready AI application capabilities for care
delivery, payer operations, value-based care, member services, clinician
workflows, and enterprise knowledge automation.

**Candidate tools:** Python, FastAPI, LangChain or LangGraph, Semantic Kernel,
AutoGen, vector databases, Azure AI Search, Weaviate, Pinecone, FAISS,
OpenAI-compatible APIs, FHIR APIs, Kubernetes, Helm, Terraform, GitLab CI,
Prometheus, Grafana, OpenTelemetry, policy-as-code and responsible AI checks.

**Lab placement:** `midh-ai-edge-01` supports local inference, embeddings,
prompt evaluation, notebooks, and AI assistant prototypes without becoming a
production data host. Backend vector search, API services, telemetry, and
larger batch workloads should target Kubernetes or the planned 256 GB Linux
server when capacity is available.

**Architecture:**

![Healthcare AI platform architecture](assets/project-11-healthcare-ai-architecture.svg)

This diagram shows the healthcare AI architecture, approved data boundaries,
evaluation gates, human review, evidence flow, and operational feedback loop.

| Use case | Coverage target |
| --- | --- |
| Clinical AI Assistant Platform | Secure assistants for clinical workflow support |
| Payer AI Assistant Platform | Claims, eligibility, authorization and member-service support |
| Retrieval-Augmented Generation | Governed document and knowledge retrieval |
| Agentic Workflow Automation | Tool-calling workflows with safe execution boundaries |
| Healthcare Knowledge Base Indexing | Chunking, embeddings, ranking and searchable knowledge stores |
| FHIR-Aware AI APIs | Auditable clinical-data exchange for AI workflows |
| AI Prompt and Response Evaluation | Regression, safety and quality evaluation |
| Responsible AI Controls | Bias, transparency, approval and human-review guardrails |
| AI Workflow Audit Logging | Traceable prompts, context, tools and responses |
| AI Cost and Latency Optimization | Token, model, cache and inference performance controls |
| AI Security and Access Control | Least-privilege access to tools, data and model endpoints |
| AI Release Governance | Reviewable promotion across development, QA, stage and production |
| AI Observability | Metrics, traces, evaluations, failures and user feedback |
| Clinical and Payer Workflow Integration | API-first integration into provider and insurance workflows |
| AI Incident Response | Playbooks for unsafe output, tool failure and degraded models |

The first useful AI slice should feel small and real: index approved runbooks,
policy documents, service catalogs, and sanitized healthcare workflow notes;
let an engineer ask why an alert is noisy, why a claims feed is late, or what
changed before a service degraded; then return cited context, confidence,
owner, and next action. That is more valuable than a flashy assistant with no
audit trail.

## Enterprise MLOps Model Platform

**Status:** Approved planned project.

**Purpose:** Standardize machine-learning lifecycle operations for training,
validation, deployment, monitoring, retraining, model governance, and production
reliability across clinical, operational, financial and payer use cases.

**Candidate tools:** MLflow, Kubeflow, SageMaker, Azure ML, Vertex AI,
Databricks, Spark, Python, SQL, feature stores, model registries, Docker,
Kubernetes, Helm, Terraform, GitLab CI, Airflow, Prometheus, Grafana,
OpenTelemetry, Great Expectations and data-quality tooling.

**Lab placement:** `midh-ai-edge-01` supports experiment notebooks, small-model
inference, embeddings, evaluation jobs, and developer smoke tests. Training
pipelines, model registry services, feature pipelines, batch scoring, and
larger model-serving backends should target Kubernetes or the planned 256 GB
Linux server after workload labels, storage, and governance controls are set.

**Architecture:**

![MLOps model platform architecture](assets/project-12-mlops-model-architecture.svg)

This diagram shows the MLOps architecture, model lifecycle boundaries,
validation gates, serving targets, evidence flow, and operational feedback loop.

| Use case | Coverage target |
| --- | --- |
| ML Training Pipeline Standardization | Repeatable training workflows |
| Feature Engineering and Feature Stores | Governed reusable features |
| Model Registry and Versioning | Traceable model lineage and promotion |
| Model Validation Gates | Accuracy, fairness, safety and performance checks |
| CI/CT/CD for ML | Automated train, test, validate, deploy and promote workflows |
| Batch Inference | Scheduled scoring and downstream delivery |
| Real-Time Inference APIs | Low-latency model serving |
| Model Observability | Latency, errors, throughput and quality signals |
| Drift Detection | Data, prediction and concept drift monitoring |
| Automated Retraining | Controlled retraining triggers and approvals |
| Model Rollback | Safe recovery to a prior approved model |
| Experiment Tracking | Metrics, artifacts, parameters and reproducibility |
| ML Infrastructure as Code | Reproducible cloud and Kubernetes model environments |
| Model Governance Evidence | Audit records for regulated model operation |
| ML Incident Response | Runbooks for degraded, biased or unavailable models |

The first useful MLOps slice should prove that a model can move through the
same discipline as application code. A small readmission-risk, claim-routing,
call-center intent, or capacity-forecasting model is enough: track the dataset,
record the training run, run validation gates, publish an approved artifact,
serve it in a controlled environment, watch drift and latency, and document the
rollback path.

## How Platform Domains Cover the Role Families

| Role family | Best matching domains |
| --- | --- |
| DevOps Engineer | Delivery, infrastructure automation, Kubernetes, Linux systems |
| Site Reliability Engineer | Kubernetes, observability, database reliability, resilience, healthcare AI, MLOps |
| Database Engineer | Database reliability, resilience, data engineering, MLOps |
| Linux/System Engineer | Infrastructure automation, observability, Linux systems, resilience |
| Data Engineer | Database reliability, data engineering, healthcare AI, MLOps |
| Network Engineer | Infrastructure automation, Kubernetes, Linux systems, network engineering |
| DevSecOps Engineer | Delivery, Kubernetes, governance |
| Cloud Infrastructure Engineer | Infrastructure automation, Linux systems, network engineering, healthcare AI, MLOps |
| Kubernetes Platform Engineer | Kubernetes, observability, network engineering, healthcare AI, MLOps |
| Platform Engineer | Delivery, infrastructure automation, Kubernetes, observability, Linux systems, healthcare AI, MLOps |
| Security/Governance Engineer | Delivery, governance, Linux systems, database reliability, data engineering, network engineering, healthcare AI, MLOps |
| AI Engineer | Data engineering, healthcare AI, MLOps |
| Machine Learning Engineer | Data engineering, healthcare AI, MLOps |

## Portfolio Use-Case Count

| Project | Use cases |
| --- | ---: |
| 1. DevSecOps Delivery | 15 |
| 2. Multi-Cloud Infrastructure | 12 |
| 3. Kubernetes with GitOps | 13 |
| 4. Observability and SRE | 16 |
| 5. Governance and Operations | 19 |
| 6. Linux Systems Engineering | 17 |
| 7. Database Engineering and Reliability | 19 |
| 8. Resilience and Service Operations | 20 |
| 9. Data Engineering and Integration | 25 |
| 10. Network Engineering and Automation | 31 |
| 11. Healthcare AI Platform | 15 |
| 12. MLOps Model Platform | 15 |
| **Total** | **217** |

## Portfolio Decision Record

| Date | Decision | Rationale | Operational effect |
| --- | --- | --- | --- |
| 2026-07-27 | Expand the architecture into a broader enterprise platform portfolio | Give DevOps, SRE, database, systems, data and network engineers complete specialist capability domains around shared provider-payer operations | Specialist domains are approved as target architecture only. No VM, IP, product, capacity commitment or implementation-completion claim is created by this decision. |
| 2026-07-27 | Create repository scaffolds for the specialist platform domains | Establish GitLab source-control homes for Linux systems, database reliability, resilience, data engineering, and network engineering | Repository creation only. Implementation, product installation, VM placement, and capacity expansion remain separately approved work. |
| 2026-07-27 | Start Linux systems implementation against the existing VM fleet | Implement Linux operations use cases without creating new infrastructure | Adds Ansible inventory, playbooks, roles, evidence reports, and runbooks for Linux lifecycle, baseline, patching, access, storage, network/time, capacity, drift, compliance, and break-glass recovery. |
| 2026-07-27 | Add Jenkins/AWX launcher guardrails for Linux systems operations | Let operators select project, branch, inventory, playbook, and extra vars while preserving review and safety controls | Adds `projects/run-ansible-playbook`, shared-library allowlists, `CONFIRM_APPLY` for state-changing playbooks, and AWX/Jenkins integration documentation. |
| 2026-07-27 | Start database, resilience, data, and network first implementation slices | Complete the approved specialist domain starts without expanding infrastructure | Adds safe Ansible evidence playbooks, GitLab CI validation, runbooks, engineering coverage, and Jenkins/AWX catalog registration for those teams. |
| 2026-07-27 | Add AI and ML platform domains | Reflect healthcare platform demand for production AI, RAG, agents, MLOps, model governance, drift monitoring and regulated AI operations | Adds approved planned domains for `healthcare-ai-platform` and `mlops-model-platform`; does not save individual job-posting details or authorize new runtime capacity. |
| 2026-07-27 | Add AI/ML edge and high-memory capacity direction | Separate developer inference from heavier backend workloads | Plans `midh-ai-edge-01` as a Mac Studio M1 AI/ML development and edge-inference node, and `infra03` as a future 256 GB Linux server for data, observability, AI/ML backend, and resilience workloads. |

## Recommended Implementation Order

1. Stabilize the existing on-prem control plane: GitLab, Jenkins, AWX,
   Kubernetes, observability, governance, and shared automation.
2. Continue Linux systems automation against the existing VM fleet; avoid new
   VMs unless a capacity review explicitly approves them.
3. Use the database reliability domain for database readiness, backup/restore, security,
   performance, and lifecycle evidence against existing database and backup VMs.
4. Use the network engineering domain for source-of-truth, DNS/DHCP,
   connectivity, firewall/proxy, and Kubernetes network review before changing
   DHCP, routing, or the physical network.
5. Use the resilience/service operations domain to consume existing
   observability signals and incident records for service catalog, SLO,
   incident, exercise, and readiness evidence.
6. Use the data engineering domain for data source, quality, orchestration,
   lineage, and access governance evidence before deploying any new data
   processing products.
7. Use the healthcare AI domain after data/governance foundations exist; start with RAG,
   agent guardrails, FHIR-aware APIs, AI evaluation, audit logging, and workflow
   integration.
8. Use the MLOps model platform after data-quality and Kubernetes foundations
   exist; start with ML lifecycle, model registry, CI/CT/CD, monitoring, drift,
   retraining and governance evidence.

This order avoids treating products as projects and builds reusable enterprise
capabilities for platform, reliability, security, systems, database, data,
network, AI and machine-learning engineering role families.
