# Enterprise Architecture Documentation

This repo is the written map for **MidhHealth Integrated Care**, an
enterprise care delivery and health insurance organization with a hybrid
on-premises and cloud platform. It explains how infrastructure, CI/CD,
Kubernetes, observability, governance, systems, database, resilience, data, and
network projects fit together as shared organizational capabilities, and gives
operators and engineers a common operating record for the platform.

## Documents

- [Enterprise Project Portfolio and Use Case Coverage](docs/enterprise-project-portfolio-and-usecases.md)
- [Application Project Deployment Register](docs/application-project-deployment-register.md)
- [Podinfo Application Deployment Record](docs/projects/applications/podinfo.md)
- [Advanced Use Case Comparison](docs/advanced-usecase-comparison.md)
- [Use-Case Implementation Status](docs/use-case-implementation-status.md)
- [Enterprise Design Readiness Status](docs/design-readiness-status.md)
- [Dependency-Safe Use-Case Implementation Sequence](docs/use-case-implementation-sequence.md)
- [Use-Case Project and Delivery Register](docs/use-case-delivery-register.md)
- [Canonical Environment Capability Status](docs/environment-capability-status.json)
- [On-Premises Platform Build Runbook](docs/on-prem-platform-build-runbook.md)
- [Staff Documentation Standard](docs/documentation-standard.md)
- [SRE Incident Register](docs/sre-incident-register.md)
- [GitLab Repository Onboarding](docs/gitlab-repository-onboarding.md)
- [GitLab Organization Model](docs/gitlab-organization-model.md)
- [Jenkins AWX Ansible Operations](docs/jenkins-awx-ansible-operations.md)
- [Platform Engineering Interview Learning Labs](docs/platform-engineering-interview-learning-labs.md)
- [Platform and Use-Case Learning Enhancement Plan](docs/platform-usecase-learning-enhancement-plan.md)
- [MidhHealth Integrated Care Reference Architecture](docs/new-employee-platform-briefing.md)
- [Use-Case Interview Question Bank](docs/use-case-interview-question-bank.md)
- [Kubernetes Helm Delivery](docs/kubernetes-helm-delivery-runbook.md)
- [PostgreSQL 18 Installation](docs/product-installation-postgresql.md)
- [Lab DNS and Copper9100 Configuration](docs/product-installation-dns.md)
- [Standalone NGINX Reverse-Proxy Installation](docs/product-installation-nginx.md)
- [Elastic Stack Installation](docs/product-installation-elastic-stack.md)
- [Splunk Enterprise Installation](docs/product-installation-splunk.md)
- [VM Inventory and Placement](docs/vm-inventory.md)
- [Current Environment State](docs/current-environment-state.md)
- [Environment Details](docs/environment-details.md)
- [Platform Installation Runbook](docs/platform-installation-runbook.md)
- [Product Version Catalog](docs/product-versions.md)
- [Product Migration History](docs/product-migration-history.md)
- [Architecture Evolution, 2023–2026](docs/architecture-evolution-2023-2026.md)
- [Engineer Operating Narrative Guide](docs/engineer-interview-guide.md)
- [Role and Contribution Guide](docs/marketing-role-engineer-guide.md)
- [Engineer Training Standard](docs/engineer-training-standard.md)
- [Enterprise Branching Strategy](docs/branching-strategy.md)
- [Component Architecture Diagram](docs/component-architecture.md)
- [Platform Domain Pages](docs/projects/README.md)
- [Application Deployment Record Template](docs/projects/application-deployment-record-template.md)

## Repository Purpose

This is the documentation home for the MidhHealth enterprise platform
portfolio. The repositories map to platform teams inside one integrated
provider-payer organization. Together they support hospital operations, digital
care, claims, eligibility, authorizations, member services, analytics,
security, and platform operations. They share the `midhhealth` GitLab
organization, one Jenkins/AWX delivery control plane, one governance model,
common environment standards, and a hybrid target footprint across on-prem
KVM/Kubernetes and future AWS/Azure/GCP validation.

The current phase completes architecture and implementation design before
additional lab work begins. The documentation is expected to drive executable
work later. A good use case should
be convertible into a Jenkins job, AWX playbook, GitLab CI stage, GitOps sync,
dashboard, alert, data-quality check, model-validation step, or runbook drill.
The portfolio avoids saving job-posting details; it uses current industry
requirements to shape practical backlog items that can produce operational
evidence in the lab.

The current implementation includes active first slices for Linux systems,
database reliability, resilience/service operations, data engineering, and
network engineering. Those slices reuse existing VMs and do not imply new
product installs or production capacity. AI/ML platform capacity planning
includes a Mac Studio M1 development/edge-inference node and a planned
memory-optimized Linux server for heavier data, observability, and AI/ML
workloads.

- Enterprise DevSecOps Delivery Platform
- Enterprise Multi-Cloud Infrastructure Platform
- Enterprise Kubernetes Platform with GitOps
- Enterprise Observability and SRE Reliability Platform
- Enterprise Cloud Governance and Operations Automation
- Enterprise Linux Systems Engineering
- Enterprise Database Engineering and Reliability
- Enterprise Resilience and Service Operations
- Enterprise Data Engineering and Integration
- Enterprise Network Engineering and Automation
- Enterprise Healthcare AI Platform
- Enterprise MLOps Model Platform

It is also the authoritative operations record for the accepted `infra01`,
`infra02`, and `infra03` footprint, registering the
Mac Studio AI/ML edge environment, provisioning Rocky Linux virtual machines,
installing platform products, and rehearsing MidhHealth integrated-care
platform modernization paths on premises.

Infrastructure work is serialized through
[Sequential Build and Change Control](docs/sequential-build-change-control.md).
Staff and automation must close the active component before starting another
build, migration, installation, or upgrade.

## Reference Docs

- [Engineering question bank](docs/interview-questions.md)
