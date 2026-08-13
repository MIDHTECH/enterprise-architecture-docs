# MidhHealth Platform Domain Pages

These pages describe the MidhHealth engineering domains as connected teams
inside one provider-payer organization. Each page includes the repository,
team size, team-member responsibilities, key interfaces, and executable
use-case scope.

Business applications remain separate projects from these platform domains.
Register them in the
[Application Project Architecture and Linkage Register](../application-project-deployment-register.md)
and create one
[Application Architecture Record](application-deployment-record-template.md)
per real repository before planning its implementation.

## Detailed application projects

| Project | Purpose | Current state |
| --- | --- | --- |
| [`midhhealth/applications/podinfo`](applications/podinfo.md) | Non-PHI reference workload documenting the connected delivery and operating path | Detailed and linked; implementation not authorized; not deployed |
| [`MIDHTECH/maas`](applications/maas.md) | Workforce and placement operational record joining consultants, companies, jobs, submissions and interviews | Detailed and linked from source; implementation not authorized; runtime unverified |

The application-to-platform relationships and the still-empty
application-to-application inventory are recorded in
[`application-integration-contracts.json`](../application-integration-contracts.json).

Eight real MIDHTECH application repositories have been discovered in the
[Workforce and Placement Application Suite](../workforce-placement-application-suite.md).
MAAS now has a detailed page; the remaining seven stay discovery records until
each receives its own application page and contract classification.

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
