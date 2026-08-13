# Engineer Operating Narrative Guide: Enterprise Cloud and Platform Projects

This guide defines the operating narrative for the enterprise platform
portfolio. Delivery, infrastructure, Kubernetes, observability, governance, and
Linux systems have active implementation repositories. Database reliability,
resilience/service operations, data engineering, and network engineering have
active first implementation slices against the existing VM fleet and must be
tracked as evidence automation, not completed product deployments.

## Positioning Statement

MidhHealth Integrated Care runs a twelve-domain enterprise platform program for
care delivery and health insurance operations. The on-premises side uses KVM,
Rocky Linux VMs, Kubernetes, GitLab, Jenkins, AWX, DNS, NGINX, and
observability as the active integration platform. The cloud side extends the
same standards to AWS, Azure, and GCP through Terraform, Ansible, CI/CD, GitOps,
governance, and operational evidence.

For role ownership, team model, and repository responsibilities, see
[Role and Contribution Guide](marketing-role-engineer-guide.md).

For scenario questions and evidence-backed exercises on Jenkins capacity,
pipeline decisions, native builds, Terraform state, Boto3 auditing, cloud cost
response and incident command, use the
[Platform Engineering Interview Learning Labs](platform-engineering-interview-learning-labs.md).
The linked use-case pages carry the detailed architecture and their own
follow-up questions; this narrative guide remains the portfolio-level view.

New employees can build the common story from the
[MidhHealth Integrated Care Reference Architecture](new-employee-platform-briefing.md). Interviewers
and candidates can then select platform and scenario questions from the
[Use-Case Interview Question Bank](use-case-interview-question-bank.md), which
links every canonical detailed use case exactly once.

## Enterprise DevSecOps Delivery Platform

**Client problem:** Application teams were deploying manually with inconsistent build, test, security, and release controls.

**Solution:** Built a governed CI/CD platform that automates checkout, build, unit tests, security scans, Docker image build, artifact publishing, deployment approval, AWX/Ansible deployment, and post-deployment validation.

**Tools:** GitLab, Jenkins, Jenkins Job DSL, Jenkins shared libraries, Docker, pytest, Trivy/Gitleaks pattern, AWX, Ansible.

**Operating narrative:** The delivery pipeline gives an app change a clear path
from commit to deployment. Jenkins handles the build, test, scan, package, and
approval flow, while AWX runs the deployment work. The shared library and Job
DSL pieces keep the Jenkins side from becoming hand-built and hard to maintain.

**Use cases covered:** CI/CD setup, automated builds, unit testing, quality gates, artifact management, Docker image scanning, release promotion, rollback, pipeline standardization, secure CI/CD.

## Enterprise Multi-Cloud Infrastructure Platform

**Client problem:** Cloud infrastructure was created manually across AWS, Azure, and GCP, causing drift, inconsistent tagging, weak security, and slow environment delivery.

**Solution:** Built Terraform and Ansible automation for standardized network, compute, storage, database, Kubernetes/container platform, IAM, monitoring, Linux baseline, patching, and smoke testing.

**Tools:** Terraform, Ansible, AWS, Azure, GCP, GitLab CI, Checkov/tfsec pattern, dynamic inventory.

**Operating narrative:** Infrastructure is organized as reusable Terraform
modules with separate environment roots. The pipeline gives each change a plan
and review trail before apply, and Ansible takes over the host baseline after
provisioning. The repo includes the standards that matter in practice, like
naming, tags, security checks, runbooks, and rollback notes.

**Use cases covered:** Cloud infrastructure provisioning, AWS VPC landing zone, Azure Terraform provisioning, GCP infrastructure provisioning, Ansible server configuration, Linux patching, environment standardization, infrastructure CI/CD, tagging, cost-aware design.

## Enterprise Kubernetes Platform with GitOps

**Client problem:** Application teams deployed Kubernetes workloads differently across clusters, creating inconsistent security, ingress, autoscaling, and operational support.

**Solution:** Built a standardized Kubernetes platform model using Terraform-managed clusters, GitOps delivery, Helm/Kustomize, namespace onboarding, RBAC, ingress, TLS, policy-as-code, autoscaling, and backup patterns.

**Tools:** Kubernetes, AKS, EKS, GKE, Helm, Kustomize, Argo CD or Flux, OPA Gatekeeper or Kyverno, ingress controller, cert-manager.

**Operating narrative:** The Kubernetes platform is built around GitOps so teams
change desired state through review instead of making manual cluster edits. The
platform standardizes namespaces, RBAC, ingress, policies, resource limits,
trusted registries, autoscaling, and onboarding.

**Use cases covered:** AKS/EKS/GKE provisioning, Kubernetes deployment automation, GitOps delivery, policy enforcement, ingress standardization, autoscaling, image supply chain security, backup and disaster recovery.

## Enterprise Observability and SRE Reliability Platform

**Client problem:** Teams could not quickly detect or troubleshoot incidents because metrics, logs, traces, and cloud signals were scattered.

**Solution:** Built an observability platform with metrics, logs, traces, dashboards, alerts, SLOs, deployment validation, incident dashboards, and RCA evidence collection.

**Tools:** Prometheus, Grafana, Loki or ELK/OpenSearch, OpenTelemetry, Jaeger or Tempo, Alertmanager, CloudWatch, Azure Monitor, GCP Operations.

**Operating narrative:** The observability repo is organized around the signals
teams need during incidents: latency, errors, traffic, saturation, pod health,
database health, capacity, and deployment impact. Dashboards, alerts, SLOs, and
RCA templates live together so monitoring supports response, not just reporting.

**Use cases covered:** Kubernetes health monitoring, APM, centralized logging, tracing, alerting, SLO/error budget monitoring, deployment validation, API error monitoring, database monitoring, capacity planning, multi-cloud observability.

## Enterprise Cloud Governance and Operations Automation

**Client problem:** Cloud environments lacked consistent IAM, secrets, compliance checks, backup validation, cost controls, certificate management, and operational remediation.

**Solution:** Built automation that enforces identity, secrets, policy scanning, tagging, compliance evidence, backup/DR validation, cost optimization, certificate alerts, and incident remediation.

**Tools:** Terraform, Ansible, GitLab CI, Checkov/tfsec, Azure Key Vault, AWS Secrets Manager, GCP Secret Manager, cloud IAM/RBAC, backup services, cost tools.

**Operating narrative:** The governance repo makes controls visible and
repeatable. It covers IAM, secrets, tags, policy checks, backup validation,
certificate monitoring, cost checks, and remediation scripts, with evidence
that can be reviewed later.

**Use cases covered:** Secrets management, IAM/RBAC standardization, compliance scanning, infrastructure hardening, private endpoints, DNS/certificate management, backup and DR, cost optimization, incident remediation, toil reduction.

## Enterprise Linux Systems Platform

**Target problem:** Enterprise Linux operations need consistent automation,
security, reliability, and operational evidence.

**Target design:** Reusable automation and controlled workflows manage Linux
hosts and produce reviewable operational evidence. The complete scope is
maintained in the
[canonical portfolio](enterprise-project-portfolio-and-usecases.md#enterprise-linux-systems-engineering-platform).

**Current implementation:** `linux-systems-platform` has Ansible inventory,
roles, playbooks, runbooks, a GitLab CI validation definition, and a Jenkins/AWX
launcher path through `projects/run-ansible-playbook`. The launcher requires
`CONFIRM_APPLY` before running `playbooks/site.yml`. A successful repository
pipeline and Jenkins/AWX runtime acceptance are still pending.

**Scope boundary:** This is an active first implementation slice against the
existing VM fleet. It does not claim new VM capacity or unrelated product
installation. Market-calibrated additions remain defined backlog until code,
pipeline, Jenkins/AWX, idempotence, rollback, and acceptance evidence exist;
their definitions are not repeated here.

## Enterprise Database Reliability Platform

**Target problem:** Database provisioning, access, performance, upgrades,
backup, and recovery need one reliability model rather than product-by-product
manual procedures.

**Target design:** AWX and database-native tooling automate lifecycle and
recovery exercises while observability supplies health and performance
evidence.

**Scope boundary:** This is the approved capability design and depends on
systems, secrets, backup, and observability.

## Enterprise Resilience and Service Operations

**Target problem:** Alerts, incidents, SLOs, capacity decisions, DR tests, and
corrective automation need an integrated service-operations workflow.

**Target design:** Service catalogs, SLOs, runbooks, incident records,
performance tests, controlled failure experiments, and AWX remediation form a
closed reliability loop.

**Scope boundary:** The first evidence automation slice is implemented; live
Jenkins/AWX acceptance and broader remediation remain pending.

## Enterprise Data Engineering Platform

**Target problem:** Batch and streaming data movement needs repeatable
orchestration, quality controls, lineage, security, and operational ownership.

**Target design:** Source-controlled pipelines cover ingestion,
transformation, quality gates, metadata, lineage, storage layers, and
monitoring without prematurely selecting products before capacity review.

**Scope boundary:** Evidence playbooks are implemented, but no data-platform
product stack is installed.

## Enterprise Network Engineering Platform

**Target problem:** IP allocation, DNS/DHCP, routing, switching, firewall
policy, VPN, cloud networking, load balancing, and Kubernetes networking need
automation and a source of truth.

**Target design:** An IPAM/source-of-truth layer drives reviewed network
changes, validation, configuration backup, drift detection, and observability.

**Scope boundary:** Evidence playbooks are implemented. The current BIND DNS
and NGINX services are active foundations, not proof that the complete project
exists.

## Enterprise Healthcare AI Platform

**Target problem:** Clinical, operational, financial, and payer AI workflows
need governed retrieval, agent, evaluation, safety, privacy, and audit
boundaries.

**Target design:** Source-controlled prompts and services use approved
de-identified data, retrieval controls, human review, evaluation gates,
observability, and model-governance evidence.

**Scope boundary:** The repository is scaffolded. Runtime implementation and
regulated-data authorization remain planned.

## Enterprise MLOps Model Platform

**Target problem:** Models need reproducible training, registry, promotion,
serving, monitoring, drift, rollback, and governance across teams.

**Target design:** Versioned datasets, features, experiments, models, serving
contracts, evaluation gates, deployment evidence, and drift response form one
reviewed lifecycle.

**Scope boundary:** The repository is scaffolded. Model runtime, registry, and
serving infrastructure remain planned.

## Overall Architecture Flow

Use this flow:

1. GitLab stores all code, documentation, merge requests, approvals, and pipeline evidence.
2. Terraform provisions cloud infrastructure in controlled environments.
3. Ansible configures servers and validates operating-system readiness.
4. CI/CD pipelines build, scan, package, and deploy applications.
5. Kubernetes/GitOps standardizes platform deployment.
6. Observability detects issues and supports incident response.
7. Governance automation enforces security, compliance, cost, secrets, and operational standards.
8. First-slice systems, database, network, data, and service-operations domains
   reuse those controls and add specialist engineering workflows.
9. Healthcare AI and MLOps define the governed model and application lifecycle
   but remain scaffolded until runtime and data controls are approved.

## Scope Summary

Together, the active projects and approved roadmap define an enterprise
operating model: source-controlled work, reviewed changes, automated
infrastructure and delivery, Kubernetes desired state, observability,
governance, and first-slice specialist domains for systems, databases,
resilience, data, and networking. Implemented capabilities and planned
AI/MLOps capabilities are clearly separated so the documentation remains
accurate and defensible.
