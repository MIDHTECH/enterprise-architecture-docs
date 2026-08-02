# Role and Contribution Guide

This guide maps each repository in the enterprise platform program to operating
roles, delivery teams, and repository responsibilities. It keeps the ownership
model consistent across architecture, implementation, operations, and audit
documentation.

For the required documentation voice and question-bank standard, see
[Engineer Training Standard](engineer-training-standard.md).

## Program Positioning

The active repositories and first-slice capability roadmap operate as one
enterprise platform program for **MidhHealth Integrated Care**, not as
disconnected labs. The on-premises side uses KVM, Rocky Linux, Kubernetes,
GitLab, Jenkins, AWX, DNS, proxying, and observability as the active integration
platform, while AWS, Azure, and GCP remain governed cloud targets through the
same Terraform, Ansible, CI/CD, GitOps, security, and evidence model.

Implementation status must be supported by repositories, commits, tests, or
operational evidence. Projects marked as first-slice automation are implemented
within their documented scope, but they are not completed product deployments.

## Role-to-Project Map

| Project | Primary operating roles | Supporting roles |
| --- | --- | --- |
| `enterprise-architecture-docs` | Cloud Architect, Enterprise Architect, Technical Lead | Program Lead, Solution Architect |
| `devsecops-cicd-orchestrator` | DevSecOps Engineer, CI/CD Engineer, DevOps Engineer | Release Engineer, Automation Engineer |
| `cloud-infra-automation-platform` | Cloud Infrastructure Engineer, Terraform Engineer, Cloud Engineer | Ansible Engineer, Platform Engineer |
| `kubernetes-platform-gitops` | Kubernetes Platform Engineer, GitOps Engineer, Platform Engineer | Cloud Native Engineer, SRE |
| `observability-sre-platform` | SRE Engineer, Observability Engineer, Reliability Engineer | Platform Engineer, Incident Response Engineer |
| `cloud-governance-ops-automation` | Cloud Governance Engineer, Cloud Security Engineer, Cloud Operations Engineer | IAM Engineer, Compliance Automation Engineer |
| `linux-systems-platform` | Linux Systems Engineer, Infrastructure Engineer, Systems Automation Engineer | Virtualization Engineer, SRE |
| `database-reliability-platform` | Database Reliability Engineer, Database Engineer, Database Administrator | SRE, Security Engineer |
| `resilience-service-operations` | SRE, Service Operations Engineer, Resilience Engineer | Incident Manager, Performance Engineer |
| `data-engineering-platform` | Data Engineer, Data Platform Engineer, Analytics Engineer | DataOps Engineer, Database Engineer |
| `network-engineering-platform` | Network Engineer, Network Automation Engineer, Cloud Network Engineer | Kubernetes Network Engineer, Security Engineer |
| `healthcare-ai-platform` | Healthcare AI Engineer, Applied AI Engineer, AI Platform Engineer | Clinical Informaticist, Privacy Engineer, SRE |
| `mlops-model-platform` | MLOps Engineer, ML Platform Engineer, Model Reliability Engineer | Data Scientist, Governance Engineer, SRE |
| `jenkins_jobs` | Jenkins Platform Engineer, CI/CD Automation Engineer | DevOps Engineer, Release Engineer |
| `jenkins-shared-library` | Jenkins Shared Library Engineer, Pipeline Automation Engineer | DevOps Engineer, AWX/Ansible Automation Engineer |

## Project Operating Narratives

### Enterprise Architecture Documentation

**Project:** Architecture repository for the full cloud platform program.

**Team:** Cloud architect, DevSecOps lead, platform lead, SRE lead, security/governance lead, and delivery manager.

**Repository responsibilities:** Enterprise architecture, repository model,
use-case mapping, implementation roadmap, and operating narratives for coherent
platform delivery.

**Operating narrative:** The architecture documentation repository ties all
delivery domains together. It explains how CI/CD, infrastructure automation,
Kubernetes GitOps, observability, and governance controls work as one enterprise
cloud operating model.

### DevSecOps CI/CD Orchestrator

**Project:** Secure CI/CD and release automation for application delivery.

**Team:** DevSecOps engineer, application developer, QA engineer, release manager, security engineer, and AWX/Ansible automation engineer.

**Repository responsibilities:** CI/CD pipeline structure, security gate
pattern, Docker image build flow, AWX deployment trigger, and deployment
evidence model.

**Operating narrative:** The DevSecOps delivery platform automates build, test,
scan, package, approval, and deployment. Jenkins controls the pipeline flow,
security checks, and AWX handoff so deployments remain controlled and auditable.

### Multi-Cloud Infrastructure Automation Platform

**Project:** Terraform and Ansible automation for AWS, Azure, and GCP infrastructure.

**Team:** Cloud infrastructure engineer, Terraform engineer, Ansible automation engineer, security engineer, network engineer, and cloud operations engineer.

**Repository responsibilities:** Reusable infrastructure module structure,
environment separation, Ansible baseline roles, tagging/security standards, and
runbooks for provisioning and remediation.

**Operating narrative:** The multi-cloud infrastructure automation platform uses
Terraform and Ansible to standardize networks, compute, storage, databases, IAM,
monitoring, and Linux configuration across environments, with GitLab-driven
validation and approval controls.

### Kubernetes Platform with GitOps

**Project:** Standardized Kubernetes platform operations across AKS, EKS, and GKE.

**Team:** Kubernetes platform engineer, cloud engineer, GitOps engineer, security engineer, application team representative, and SRE.

**Repository responsibilities:** Cluster/environment layout, namespace
onboarding model, RBAC pattern, ingress/TLS structure, policy-as-code controls,
autoscaling pattern, and backup runbook.

**Operating narrative:** The Kubernetes platform lets application teams deploy
through GitOps instead of manual kubectl commands. It standardizes namespaces,
RBAC, ingress, policies, autoscaling, and backup patterns across clusters.

### Observability and SRE Reliability Platform

**Project:** Monitoring, alerting, SLO, incident response, and reliability engineering platform.

**Team:** SRE, observability engineer, application owner, platform engineer, incident manager, and cloud operations engineer.

**Repository responsibilities:** Monitoring and incident-response model,
dashboard coverage, alerting patterns, SLO/error budget tracking, deployment
validation, and incident triage runbooks.

**Operating narrative:** The observability and SRE platform unifies application,
Kubernetes, infrastructure, and cloud telemetry. Metrics, logs, traces, alerts,
SLOs, and incident runbooks feed a reliability operating model that reduces
troubleshooting time.

### Cloud Governance and Operations Automation

**Project:** Governance, security, compliance evidence, backup, cost, certificates, and remediation automation.

**Team:** Cloud security engineer, governance engineer, IAM engineer, compliance analyst, cloud operations engineer, and platform engineer.

**Repository responsibilities:** Governance automation domains, compliance
evidence collection, IAM, secrets, tagging, backup, cost optimization,
certificate monitoring, and remediation workflows.

**Operating narrative:** The cloud governance automation project standardizes
IAM, secrets, compliance checks, backup validation, certificate monitoring, cost
controls, and remediation. The result is a more auditable and repeatable cloud
operations model.

### Enterprise Linux Systems Platform

**Project:** Active first Linux systems implementation slice against the
existing VM fleet. Authoritative use-case scope is maintained only in the
[enterprise portfolio](enterprise-project-portfolio-and-usecases.md#enterprise-linux-systems-engineering-platform).

**Team:** Linux systems engineer, virtualization engineer, Ansible/AWX
engineer, network engineer, security engineer, and SRE.

**Architecture contribution:** Provides source-controlled host automation and
operational evidence. The original first-slice source is executable but still
awaits a passing repository pipeline; newer portfolio items remain defined
backlog.

**Operating narrative:** The first Linux systems slice uses reusable Ansible
roles and controlled Jenkins/AWX workflows to produce reviewable host evidence
without adding new VM capacity. Detailed use cases are not repeated here.

**Jenkins/AWX workflow:** The project is launched through
`projects/run-ansible-playbook`, which lets operators select the project,
branch, inventory, playbook, and approved extra vars. The shared Jenkins
library reconciles AWX objects and requires `CONFIRM_APPLY` before running
state-changing playbooks.

### Enterprise Database Reliability Platform (Active First Slice)

**Project:** Target database lifecycle, performance, security, backup,
recovery, and upgrade automation.

**Team:** Database reliability engineer, DBA, platform engineer, SRE, security
engineer, and application owner.

**Architecture contribution:** Defined dependencies, reliability controls,
recovery evidence, and the boundary between database-native tooling and
platform automation.

**Operating narrative:** The first automation slice uses approved
provisioning, secrets, monitoring, backup verification, recovery testing, and
controlled upgrades against the existing PostgreSQL VM. Product expansion and
runtime acceptance remain controlled follow-up work.

### Enterprise Resilience and Service Operations (Active First Slice)

**Project:** Target operating model for SLOs, incidents, performance,
capacity, controlled failure testing, DR, and remediation.

**Team:** SRE, service owner, incident manager, performance engineer, platform
engineer, and business stakeholder.

**Architecture contribution:** Connected observability signals to service
ownership, incident workflows, reliability decisions, and AWX automation.

**Operating narrative:** The first service-operations slice lets telemetry drive
SLO reviews, incident response, capacity decisions, recovery exercises, and
approved remediation evidence. Jenkins/AWX acceptance remains pending.

### Enterprise Data Engineering Platform (Active First Slice)

**Project:** Target batch and streaming data platform covering ingestion,
orchestration, transformation, quality, metadata, lineage, and operations.

**Team:** Data engineer, data platform engineer, analytics engineer, database
engineer, security engineer, and SRE.

**Architecture contribution:** Defined the logical pipeline, ownership,
quality, lineage, security, and observability requirements while leaving
product selection subject to capacity and design review.

**Operating narrative:** The first evidence slice is built around
source-controlled pipelines, data contracts, quality gates, metadata, lineage,
and operational monitoring. It does not claim an installed Airflow, Kafka,
Spark, or lakehouse stack.

### Enterprise Network Engineering Platform (Active First Slice)

**Project:** Target source-of-truth and automation platform for IPAM,
DNS/DHCP, routing, switching, firewall policy, VPN, cloud, load balancing, and
Kubernetes networking.

**Team:** Network engineer, network automation engineer, cloud network
engineer, security engineer, Kubernetes platform engineer, and SRE.

**Architecture contribution:** Defined reviewed network-change workflows,
validation, backups, drift detection, dependency mapping, and telemetry.

**Operating narrative:** The first network engineering slice uses an
authoritative inventory to drive reviewed, tested, and recoverable configuration
changes. The existing DNS and NGINX services are foundations; they are not
presented as completion of the broader project.

### Enterprise Healthcare AI Platform (Scaffolded)

**Project:** Governed healthcare AI, RAG, agent, evaluation, safety, privacy,
and audit architecture.

**Team:** Healthcare AI engineer, AI platform engineer, clinical informaticist,
privacy engineer, security engineer, data engineer, and SRE.

**Architecture contribution:** Defines de-identified data boundaries, retrieval
controls, human review, evaluation gates, observability, and audit evidence.

**Operating narrative:** The repository establishes the governed engineering
boundary but does not claim a deployed AI runtime or regulated-data approval.

### Enterprise MLOps Model Platform (Scaffolded)

**Project:** Reproducible model training, registry, promotion, serving,
monitoring, drift response, rollback, and governance.

**Team:** MLOps engineer, ML platform engineer, data scientist, governance
engineer, security engineer, and SRE.

**Architecture contribution:** Defines the model lifecycle and evidence
contract from data and experiment through serving and retirement.

**Operating narrative:** The repository is an approved scaffold. Model
registry, training, serving, monitoring, and runtime capacity remain planned.

### Jenkins Jobs

**Project:** Jenkins job-as-code repository for managed pipeline jobs.

**Team:** Jenkins administrator, DevOps engineer, release engineer, platform engineer, and project pipeline owners.

**Repository responsibilities:** Seed-job model, Job DSL structure, managed job
inventory, and validation workflow for generated project pipelines.

**Operating narrative:** The Jenkins job-as-code layer keeps pipeline job
definitions in source control. Instead of creating jobs manually, the seed job
reads version-controlled Job DSL scripts and creates standardized project
pipeline jobs, which reduces drift and improves auditability.

### Jenkins Shared Library

**Project:** Reusable Jenkins shared library for AWX deployment automation.

**Team:** DevOps engineer, Jenkins platform engineer, Ansible/AWX engineer, release engineer, and application delivery teams.

**Repository responsibilities:** Reusable AWX launch contract, credential
handling pattern, polling behavior, and pipeline usage documentation.

**Operating narrative:** The Jenkins shared library lets multiple pipelines
launch AWX job templates using the same reusable contract. It removes
duplicated REST API logic from project Jenkinsfiles and makes deployment
automation easier to maintain.

## Delivery Evidence Patterns

- Built an enterprise cloud platform reference program across CI/CD, infrastructure automation, Kubernetes GitOps, observability, and governance domains.
- Implemented Terraform and Ansible automation patterns for repeatable multi-cloud provisioning and Linux baseline configuration.
- Designed Jenkins pipeline, Job DSL, and shared-library patterns for standardized CI/CD and AWX-driven deployment automation.
- Created Kubernetes GitOps operating model covering namespaces, RBAC, ingress, policy-as-code, autoscaling, and backup patterns.
- Developed observability and SRE documentation for metrics, logs, traces, alerts, SLOs, deployment validation, and incident triage.
- Documented governance automation for IAM, secrets, compliance evidence, tagging, backup validation, cost controls, certificates, and remediation.
- Designed the platform roadmap across Linux systems, database reliability,
  service operations, data engineering, network engineering, healthcare AI,
  and MLOps, with explicit capacity and implementation gates.

## Operating Review Structure

Use this four-part structure when reviewing any project:

1. **Client problem:** Describe the operational pain, such as manual provisioning, inconsistent deployments, weak governance, or poor incident visibility.
2. **Team model:** Name the roles involved so ownership and review paths are clear.
3. **Repository responsibilities:** Be specific about what is designed, implemented, automated, documented, or validated.
4. **Business outcome:** Connect the work to speed, security, auditability, reliability, cost control, or reduced manual effort.
