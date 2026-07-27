# Marketing Role and Engineer Contribution Guide

This guide maps each repository in the enterprise cloud platform program to marketable engineering roles. Use it to explain the project, the delivery team, and your personal contribution in interviews, resumes, client discussions, and LinkedIn project summaries.

For the required project training structure and interview question-bank standard, see [Engineer Training Standard](engineer-training-standard.md).

## Program Positioning

Present the active repositories and planned capability roadmap as one
enterprise platform program, not as disconnected labs:

> I contributed to the first five implementation domains of a ten-project
> enterprise platform program: infrastructure, CI/CD, Kubernetes delivery,
> observability, and governance automation. I also helped define the planned
> capability architecture for Linux systems, database reliability, service
> operations, data engineering, and network engineering. The domains use
> GitLab review, Jenkins delivery, Terraform infrastructure, Ansible
> configuration, GitOps, monitoring, and security controls as shared
> foundations.

Only claim implementation contributions for work supported by repositories,
commits, tests, or operational evidence. Projects marked planned are valid
architecture and roadmap experience, but not completed implementations.

## Role-to-Project Map

| Project | Primary marketing roles | Supporting roles |
| --- | --- | --- |
| `enterprise-architecture-docs` | Cloud Architect, Enterprise Architect, Technical Lead | Program Lead, Solution Architect |
| `devsecops-cicd-orchestrator` | DevSecOps Engineer, CI/CD Engineer, DevOps Engineer | Release Engineer, Automation Engineer |
| `cloud-infra-automation-platform` | Cloud Infrastructure Engineer, Terraform Engineer, Cloud Engineer | Ansible Engineer, Platform Engineer |
| `kubernetes-platform-gitops` | Kubernetes Platform Engineer, GitOps Engineer, Platform Engineer | Cloud Native Engineer, SRE |
| `observability-sre-platform` | SRE Engineer, Observability Engineer, Reliability Engineer | Platform Engineer, Incident Response Engineer |
| `cloud-governance-ops-automation` | Cloud Governance Engineer, Cloud Security Engineer, Cloud Operations Engineer | IAM Engineer, Compliance Automation Engineer |
| `enterprise-linux-systems-platform` (planned) | Linux Systems Engineer, Infrastructure Engineer, Systems Automation Engineer | Virtualization Engineer, SRE |
| `enterprise-database-reliability-platform` (planned) | Database Reliability Engineer, Database Engineer, Database Administrator | SRE, Security Engineer |
| `enterprise-resilience-service-operations` (planned) | SRE, Service Operations Engineer, Resilience Engineer | Incident Manager, Performance Engineer |
| `enterprise-data-engineering-platform` (planned) | Data Engineer, Data Platform Engineer, Analytics Engineer | DataOps Engineer, Database Engineer |
| `enterprise-network-engineering-platform` (planned) | Network Engineer, Network Automation Engineer, Cloud Network Engineer | Kubernetes Network Engineer, Security Engineer |
| `jenkins_jobs` | Jenkins Platform Engineer, CI/CD Automation Engineer | DevOps Engineer, Release Engineer |
| `jenkins-shared-library` | Jenkins Shared Library Engineer, Pipeline Automation Engineer | DevOps Engineer, AWX/Ansible Automation Engineer |

## Project Interview Narratives

### Enterprise Architecture Documentation

**Project:** Architecture repository for the full cloud platform program.

**Team:** Cloud architect, DevSecOps lead, platform lead, SRE lead, security/governance lead, and delivery manager.

**My contribution:** I documented the enterprise architecture, repository model, use-case mapping, implementation roadmap, and engineer interview narratives so the program could be explained as a coherent client delivery.

**How to explain it:**

> I created the architecture documentation repository that ties all delivery domains together. It explains how CI/CD, infrastructure automation, Kubernetes GitOps, observability, and governance controls work as one enterprise cloud operating model.

### DevSecOps CI/CD Orchestrator

**Project:** Secure CI/CD and release automation for application delivery.

**Team:** DevSecOps engineer, application developer, QA engineer, release manager, security engineer, and AWX/Ansible automation engineer.

**My contribution:** I built the CI/CD pipeline structure, security gate pattern, Docker image build flow, AWX deployment trigger, and deployment evidence model.

**How to explain it:**

> I worked on a DevSecOps delivery platform that automated build, test, scan, package, approval, and deployment. My contribution was designing the Jenkins pipeline flow, integrating security checks, and connecting Jenkins to AWX so deployments were controlled and auditable.

### Multi-Cloud Infrastructure Automation Platform

**Project:** Terraform and Ansible automation for AWS, Azure, and GCP infrastructure.

**Team:** Cloud infrastructure engineer, Terraform engineer, Ansible automation engineer, security engineer, network engineer, and cloud operations engineer.

**My contribution:** I created the reusable infrastructure module structure, environment separation, Ansible baseline roles, tagging/security standards, and runbooks for provisioning and remediation.

**How to explain it:**

> I helped build a multi-cloud infrastructure automation platform using Terraform and Ansible. The platform standardized networks, compute, storage, databases, IAM, monitoring, and Linux configuration across environments, with GitLab-driven validation and approval controls.

### Kubernetes Platform with GitOps

**Project:** Standardized Kubernetes platform operations across AKS, EKS, and GKE.

**Team:** Kubernetes platform engineer, cloud engineer, GitOps engineer, security engineer, application team representative, and SRE.

**My contribution:** I defined the cluster/environment layout, namespace onboarding model, RBAC pattern, ingress/TLS structure, policy-as-code controls, autoscaling pattern, and backup runbook.

**How to explain it:**

> I contributed to a Kubernetes platform engineering project that let application teams deploy through GitOps instead of manual kubectl commands. My work focused on standardizing namespaces, RBAC, ingress, policies, autoscaling, and backup patterns across clusters.

### Observability and SRE Reliability Platform

**Project:** Monitoring, alerting, SLO, incident response, and reliability engineering platform.

**Team:** SRE, observability engineer, application owner, platform engineer, incident manager, and cloud operations engineer.

**My contribution:** I designed the monitoring and incident-response documentation model, including dashboard coverage, alerting patterns, SLO/error budget tracking, deployment validation, and incident triage runbooks.

**How to explain it:**

> I worked on an observability and SRE platform that unified application, Kubernetes, infrastructure, and cloud telemetry. My contribution was mapping metrics, logs, traces, alerts, SLOs, and incident runbooks into a reliability operating model that reduced troubleshooting time.

### Cloud Governance and Operations Automation

**Project:** Governance, security, compliance evidence, backup, cost, certificates, and remediation automation.

**Team:** Cloud security engineer, governance engineer, IAM engineer, compliance analyst, cloud operations engineer, and platform engineer.

**My contribution:** I organized the governance automation domains, documented compliance evidence collection, and mapped IAM, secrets, tagging, backup, cost optimization, certificate monitoring, and remediation workflows.

**How to explain it:**

> I contributed to a cloud governance automation project that helped standardize IAM, secrets, compliance checks, backup validation, certificate monitoring, cost controls, and remediation. The result was a more auditable and repeatable cloud operations model.

### Enterprise Linux Systems Platform (Planned)

**Project:** Target operating model for Linux lifecycle, KVM, patching,
storage, DNS, identity, and core system services.

**Team:** Linux systems engineer, virtualization engineer, Ansible/AWX
engineer, network engineer, security engineer, and SRE.

**Architecture contribution:** Defined how source-controlled roles, inventories,
maintenance workflows, validation, and evidence should standardize host
operations.

**How to explain it:**

> I designed the planned Linux systems capability around reusable Ansible roles
> and AWX workflows. The architecture connects host baseline, patching,
> storage, DNS, virtualization, recovery, and compliance evidence without
> claiming that the dedicated repository is already implemented.

### Enterprise Database Reliability Platform (Planned)

**Project:** Target database lifecycle, performance, security, backup,
recovery, and upgrade automation.

**Team:** Database reliability engineer, DBA, platform engineer, SRE, security
engineer, and application owner.

**Architecture contribution:** Defined dependencies, reliability controls,
recovery evidence, and the boundary between database-native tooling and
platform automation.

**How to explain it:**

> I contributed the target architecture for a database reliability platform
> that uses approved provisioning, secrets, monitoring, backup verification,
> recovery testing, and controlled upgrades. This is roadmap design pending
> implementation and capacity approval.

### Enterprise Resilience and Service Operations (Planned)

**Project:** Target operating model for SLOs, incidents, performance,
capacity, controlled failure testing, DR, and remediation.

**Team:** SRE, service owner, incident manager, performance engineer, platform
engineer, and business stakeholder.

**Architecture contribution:** Connected observability signals to service
ownership, incident workflows, reliability decisions, and AWX automation.

**How to explain it:**

> I designed the next service-operations layer so telemetry can drive SLO
> reviews, incident response, capacity decisions, recovery exercises, and
> approved remediation. It extends the active observability work and remains a
> planned project.

### Enterprise Data Engineering Platform (Planned)

**Project:** Target batch and streaming data platform covering ingestion,
orchestration, transformation, quality, metadata, lineage, and operations.

**Team:** Data engineer, data platform engineer, analytics engineer, database
engineer, security engineer, and SRE.

**Architecture contribution:** Defined the logical pipeline, ownership,
quality, lineage, security, and observability requirements while leaving
product selection subject to capacity and design review.

**How to explain it:**

> I developed the planned data-platform architecture around source-controlled
> pipelines, data contracts, quality gates, metadata, lineage, and operational
> monitoring. I describe this as target-state engineering, not as an installed
> data stack.

### Enterprise Network Engineering Platform (Planned)

**Project:** Target source-of-truth and automation platform for IPAM,
DNS/DHCP, routing, switching, firewall policy, VPN, cloud, load balancing, and
Kubernetes networking.

**Team:** Network engineer, network automation engineer, cloud network
engineer, security engineer, Kubernetes platform engineer, and SRE.

**Architecture contribution:** Defined reviewed network-change workflows,
validation, backups, drift detection, dependency mapping, and telemetry.

**How to explain it:**

> I designed the planned network engineering capability so an authoritative
> inventory can drive reviewed, tested, and recoverable configuration changes.
> The existing DNS and NGINX services are foundations; they are not presented
> as completion of the broader project.

### Jenkins Jobs

**Project:** Jenkins job-as-code repository for managed pipeline jobs.

**Team:** Jenkins administrator, DevOps engineer, release engineer, platform engineer, and project pipeline owners.

**My contribution:** I created the seed-job model, Job DSL structure, managed job inventory, and validation workflow so project pipelines could be generated from source control.

**How to explain it:**

> I built the Jenkins job-as-code layer for the platform. Instead of creating jobs manually, the seed job reads version-controlled Job DSL scripts and creates standardized project pipeline jobs, which reduces drift and improves auditability.

### Jenkins Shared Library

**Project:** Reusable Jenkins shared library for AWX deployment automation.

**Team:** DevOps engineer, Jenkins platform engineer, Ansible/AWX engineer, release engineer, and application delivery teams.

**My contribution:** I implemented the reusable AWX launch contract, credential handling pattern, polling behavior, and pipeline usage documentation.

**How to explain it:**

> I created a Jenkins shared library step that lets multiple pipelines launch AWX job templates using the same reusable contract. This removed duplicated REST API logic from project Jenkinsfiles and made deployment automation easier to maintain.

## Resume Bullet Patterns

- Built an enterprise cloud platform reference program across CI/CD, infrastructure automation, Kubernetes GitOps, observability, and governance domains.
- Implemented Terraform and Ansible automation patterns for repeatable multi-cloud provisioning and Linux baseline configuration.
- Designed Jenkins pipeline, Job DSL, and shared-library patterns for standardized CI/CD and AWX-driven deployment automation.
- Created Kubernetes GitOps operating model covering namespaces, RBAC, ingress, policy-as-code, autoscaling, and backup patterns.
- Developed observability and SRE documentation for metrics, logs, traces, alerts, SLOs, deployment validation, and incident triage.
- Documented governance automation for IAM, secrets, compliance evidence, tagging, backup validation, cost controls, certificates, and remediation.
- Designed a role-centered roadmap extending the active platform into Linux
  systems, database reliability, service operations, data engineering, and
  network engineering, with explicit capacity and implementation gates.

## Interview Answer Structure

Use this four-part structure when explaining any project:

1. **Client problem:** Describe the operational pain, such as manual provisioning, inconsistent deployments, weak governance, or poor incident visibility.
2. **Team model:** Name the roles involved so the interviewer understands this was delivered like an enterprise engagement.
3. **My contribution:** Be specific about what you designed, implemented, automated, documented, or validated.
4. **Business outcome:** Connect the work to speed, security, auditability, reliability, cost control, or reduced manual effort.
