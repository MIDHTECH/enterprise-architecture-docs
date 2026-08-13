# MidhHealth Platform Domain Pages

These pages describe the MidhHealth engineering domains as connected teams
inside one provider-payer organization. Each page includes the repository,
team size, team-member responsibilities, key interfaces, and executable
use-case scope.

Business applications remain separate projects from these platform domains.
Register them in the
[Application Project Architecture and Linkage Register](../application-project-deployment-register.md)
and create one
[Application Deployment Record](application-deployment-record-template.md)
per real repository before planning its implementation.

## Registered application projects

| Project | Purpose | Current state |
| --- | --- | --- |
| [`midhhealth/applications/podinfo`](applications/podinfo.md) | Non-PHI reference workload documenting the connected delivery and operating path | Detailed and linked; implementation not authorized; not deployed |

The application-to-platform relationships and the still-empty
application-to-application inventory are recorded in
[`application-integration-contracts.json`](../application-integration-contracts.json).

New engineers should begin with the
[MidhHealth Platform Briefing](../new-employee-platform-briefing.md), then use
the [Use-Case Interview Question Bank](../use-case-interview-question-bank.md)
to practise explaining the decisions behind these domain pages.

| Domain | Page |
| --- | --- |
| DevSecOps delivery | [DevSecOps Delivery](devsecops-delivery.md) |
| Multi-cloud infrastructure | [Multi-Cloud Infrastructure](multi-cloud-infrastructure.md) |
| Kubernetes platform | [Kubernetes Platform](kubernetes-platform.md) |
| Observability and SRE | [Observability and SRE](observability-sre.md) |
| Governance and operations automation | [Governance and Operations Automation](governance-operations.md) |
| Linux systems engineering | [Linux Systems Engineering](linux-systems.md) |
| Database reliability | [Database Reliability](database-reliability.md) |
| Resilience and service operations | [Resilience and Service Operations](resilience-service-operations.md) |
| Data engineering and integration | [Data Engineering and Integration](data-engineering.md) |
| Network engineering and automation | [Network Engineering](network-engineering.md) |
| Healthcare AI platform | [Healthcare AI Platform](healthcare-ai.md) |
| MLOps model platform | [MLOps Model Platform](mlops-model-platform.md) |

## Shared Staffing Principles

- Every team owns code, runbooks, evidence, and operational outcomes.
- Every team works through GitLab merge requests, protected branches, CI checks,
  Jenkins/AWX execution, and documented rollback or recovery paths.
- Team members may be shared in the lab, but the role model shows how the work
  would be split in a real MidhHealth platform organization.
- First-slice teams use existing VMs and services unless a capacity review
  explicitly approves new runtime placement.
