# Engineer Interview Guide: Enterprise Cloud and Platform Projects

This guide gives you a natural way to talk about the ten-project enterprise
portfolio in interviews. Projects 1–5 describe active implementation
repositories. Projects 6–10 have active first implementation slices against the
existing VM fleet and must be presented as evidence automation, not completed
product deployments.

## Positioning Statement

Use this version when you need a short overview:

> I built a ten-domain enterprise platform program for MidhHealth Integrated
> Care, a care delivery and health insurance organization. The on-premises side
> uses KVM, Rocky Linux VMs, Kubernetes, GitLab, Jenkins, AWX, DNS, NGINX, and
> observability as the active integration platform. The cloud side extends the
> same standards to AWS, Azure, and GCP through Terraform, Ansible, CI/CD,
> GitOps, governance, and operational evidence.

For role-specific positioning, team model, and contribution wording, see [Marketing Role and Engineer Contribution Guide](marketing-role-engineer-guide.md).

## Project 1: Enterprise DevSecOps Delivery Platform

**Client problem:** Application teams were deploying manually with inconsistent build, test, security, and release controls.

**Solution:** Built a governed CI/CD platform that automates checkout, build, unit tests, security scans, Docker image build, artifact publishing, deployment approval, AWX/Ansible deployment, and post-deployment validation.

**Tools:** GitLab, Jenkins, Jenkins Job DSL, Jenkins shared libraries, Docker, pytest, Trivy/Gitleaks pattern, AWX, Ansible.

**How to explain it:**

> I built the delivery pipeline so an app change has a clear path from commit to deployment. Jenkins handles the build, test, scan, package, and approval flow, while AWX runs the deployment work. The shared library and Job DSL pieces keep the Jenkins side from becoming hand-built and hard to maintain.

**Use cases covered:** CI/CD setup, automated builds, unit testing, quality gates, artifact management, Docker image scanning, release promotion, rollback, pipeline standardization, secure CI/CD.

## Project 2: Enterprise Multi-Cloud Infrastructure Platform

**Client problem:** Cloud infrastructure was created manually across AWS, Azure, and GCP, causing drift, inconsistent tagging, weak security, and slow environment delivery.

**Solution:** Built Terraform and Ansible automation for standardized network, compute, storage, database, Kubernetes/container platform, IAM, monitoring, Linux baseline, patching, and smoke testing.

**Tools:** Terraform, Ansible, AWS, Azure, GCP, GitLab CI, Checkov/tfsec pattern, dynamic inventory.

**How to explain it:**

> I organized the infrastructure as reusable Terraform modules with separate environment roots. The pipeline gives each change a plan and review trail before apply, and Ansible takes over the host baseline after provisioning. The repo also includes the standards that matter in practice, like naming, tags, security checks, runbooks, and rollback notes.

**Use cases covered:** Cloud infrastructure provisioning, AWS VPC landing zone, Azure Terraform provisioning, GCP infrastructure provisioning, Ansible server configuration, Linux patching, environment standardization, infrastructure CI/CD, tagging, cost-aware design.

## Project 3: Enterprise Kubernetes Platform with GitOps

**Client problem:** Application teams deployed Kubernetes workloads differently across clusters, creating inconsistent security, ingress, autoscaling, and operational support.

**Solution:** Built a standardized Kubernetes platform model using Terraform-managed clusters, GitOps delivery, Helm/Kustomize, namespace onboarding, RBAC, ingress, TLS, policy-as-code, autoscaling, and backup patterns.

**Tools:** Kubernetes, AKS, EKS, GKE, Helm, Kustomize, Argo CD or Flux, OPA Gatekeeper or Kyverno, ingress controller, cert-manager.

**How to explain it:**

> I built the Kubernetes side around GitOps so teams can change desired state through review instead of making manual cluster edits. The platform standardizes namespaces, RBAC, ingress, policies, resource limits, trusted registries, autoscaling, and onboarding.

**Use cases covered:** AKS/EKS/GKE provisioning, Kubernetes deployment automation, GitOps delivery, policy enforcement, ingress standardization, autoscaling, image supply chain security, backup and disaster recovery.

## Project 4: Enterprise Observability and SRE Reliability Platform

**Client problem:** Teams could not quickly detect or troubleshoot incidents because metrics, logs, traces, and cloud signals were scattered.

**Solution:** Built an observability platform with metrics, logs, traces, dashboards, alerts, SLOs, deployment validation, incident dashboards, and RCA evidence collection.

**Tools:** Prometheus, Grafana, Loki or ELK/OpenSearch, OpenTelemetry, Jaeger or Tempo, Alertmanager, CloudWatch, Azure Monitor, GCP Operations.

**How to explain it:**

> I built the observability repo around the signals teams actually need during incidents: latency, errors, traffic, saturation, pod health, database health, capacity, and deployment impact. Dashboards, alerts, SLOs, and RCA templates live together so the monitoring setup supports response, not just reporting.

**Use cases covered:** Kubernetes health monitoring, APM, centralized logging, tracing, alerting, SLO/error budget monitoring, deployment validation, API error monitoring, database monitoring, capacity planning, multi-cloud observability.

## Project 5: Enterprise Cloud Governance and Operations Automation

**Client problem:** Cloud environments lacked consistent IAM, secrets, compliance checks, backup validation, cost controls, certificate management, and operational remediation.

**Solution:** Built automation that enforces identity, secrets, policy scanning, tagging, compliance evidence, backup/DR validation, cost optimization, certificate alerts, and incident remediation.

**Tools:** Terraform, Ansible, GitLab CI, Checkov/tfsec, Azure Key Vault, AWS Secrets Manager, GCP Secret Manager, cloud IAM/RBAC, backup services, cost tools.

**How to explain it:**

> I built the governance repo to make controls visible and repeatable. It covers IAM, secrets, tags, policy checks, backup validation, certificate monitoring, cost checks, and remediation scripts, with evidence that can be reviewed later.

**Use cases covered:** Secrets management, IAM/RBAC standardization, compliance scanning, infrastructure hardening, private endpoints, DNS/certificate management, backup and DR, cost optimization, incident remediation, toil reduction.

## Project 6: Enterprise Linux Systems Platform

**Target problem:** Linux lifecycle, KVM, patching, storage, DNS, identity, and
system services need consistent automation and operational evidence.

**Target design:** Reusable Ansible roles and AWX workflows manage Rocky Linux
hosts, hypervisor services, baselines, patch windows, storage, recovery, and
validation.

**Current implementation:** `linux-systems-platform` has Ansible inventory,
roles, playbooks, runbooks, GitLab CI validation, and a Jenkins/AWX launcher
path through `projects/run-ansible-playbook`. The launcher requires
`CONFIRM_APPLY` before running `playbooks/site.yml`.

**Interview boundary:** Explain that this is an active first implementation
slice against the existing VM fleet. Do not claim new VM capacity or unrelated
product installation.

## Project 7: Enterprise Database Reliability Platform (Planned)

**Target problem:** Database provisioning, access, performance, upgrades,
backup, and recovery need one reliability model rather than product-by-product
manual procedures.

**Target design:** AWX and database-native tooling automate lifecycle and
recovery exercises while observability supplies health and performance
evidence.

**Interview boundary:** Describe the approved capability design and its
dependencies on systems, secrets, backup, and observability.

## Project 8: Enterprise Resilience and Service Operations (Planned)

**Target problem:** Alerts, incidents, SLOs, capacity decisions, DR tests, and
corrective automation need an integrated service-operations workflow.

**Target design:** Service catalogs, SLOs, runbooks, incident records,
performance tests, controlled failure experiments, and AWX remediation form a
closed reliability loop.

**Interview boundary:** Present this as the planned operational layer that
consumes the active observability platform.

## Project 9: Enterprise Data Engineering Platform (Planned)

**Target problem:** Batch and streaming data movement needs repeatable
orchestration, quality controls, lineage, security, and operational ownership.

**Target design:** Source-controlled pipelines cover ingestion,
transformation, quality gates, metadata, lineage, storage layers, and
monitoring without prematurely selecting products before capacity review.

**Interview boundary:** Discuss the architecture and tradeoffs, not a completed
data platform deployment.

## Project 10: Enterprise Network Engineering Platform (Planned)

**Target problem:** IP allocation, DNS/DHCP, routing, switching, firewall
policy, VPN, cloud networking, load balancing, and Kubernetes networking need
automation and a source of truth.

**Target design:** An IPAM/source-of-truth layer drives reviewed network
changes, validation, configuration backup, drift detection, and observability.

**Interview boundary:** Present this as an approved roadmap capability. The
current BIND DNS and NGINX services are active foundations, not proof that the
complete project exists.

## How to Explain the Overall Architecture

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

## Interview Closing Statement

Use this version:

> Together, the active projects and approved roadmap show an enterprise
> operating model: source-controlled work, reviewed changes, automated
> infrastructure and delivery, Kubernetes desired state, observability,
> governance, and first-slice specialist domains for systems, databases,
> resilience, data, and networking. I clearly separate what I implemented from
> what I designed so the discussion remains accurate and defensible.
