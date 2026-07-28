# Enterprise Architecture Documentation

This repo is the written map for **MidhHealth Integrated Care**, a fictional
enterprise care delivery and health insurance organization with a hybrid
on-premises and cloud platform. It explains how infrastructure, CI/CD,
Kubernetes, observability, governance, systems, database, resilience, data, and
network projects fit together as shared organizational capabilities, and gives
you language for talking about the work in interviews.

## Documents

- [Enterprise Project Portfolio and Use Case Coverage](docs/enterprise-project-portfolio-and-usecases.md)
- [On-Premises Platform Build Runbook](docs/on-prem-platform-build-runbook.md)
- [Staff Documentation Standard](docs/documentation-standard.md)
- [SRE Incident Register](docs/sre-incident-register.md)
- [GitLab Repository Onboarding](docs/gitlab-repository-onboarding.md)
- [Jenkins AWX Ansible Operations](docs/jenkins-awx-ansible-operations.md)
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
- [MAAS Monolith-to-Microservices Roadmap](docs/maas-monolith-to-microservices.md)
- [Engineer Interview Guide](docs/engineer-interview-guide.md)
- [Marketing Role and Engineer Contribution Guide](docs/marketing-role-engineer-guide.md)
- [Engineer Training Standard](docs/engineer-training-standard.md)
- [Enterprise Branching Strategy](docs/branching-strategy.md)
- [Component Architecture Diagram](docs/component-architecture.md)

## Repository Purpose

This is the documentation home for the ten-project MidhHealth enterprise
portfolio. The projects should be understood as departments or platform domains
inside one integrated provider-payer organization, not as separate labs. They
support hospital operations, digital care, claims, eligibility,
authorizations, member services, analytics, security, and platform operations.
They share one GitLab namespace, one Jenkins/AWX delivery control plane, one
governance model, common environment standards, and a hybrid target footprint
across on-prem KVM/Kubernetes and future AWS/Azure/GCP validation.

Projects 1–10 now have implementation repositories. Projects 6–10 are active
first slices that reuse existing VMs and do not imply new product installs,
new VM placement, or production capacity:

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

It is also the authoritative operations record for rebuilding `infra01` and
`infra02`, provisioning their Rocky Linux virtual machines, installing platform
products, and rehearsing the MAAS modernization path on premises.

## Extra Docs

- [Interview questions](docs/interview-questions.md)
