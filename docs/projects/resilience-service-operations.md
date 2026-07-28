# Resilience and Service Operations Domain

**Repository:** `midhhealth/reliability-operations/resilience-service-operations`  
**Team size:** 5 engineers

## Team Responsibilities

The resilience team turns telemetry, incidents, service ownership, and recovery
requirements into controlled operating workflows.

| Team member | Primary responsibility |
| --- | --- |
| Service Operations Lead | Owns service catalog, readiness reviews, severity model, and operational priorities. |
| SLO and Error-Budget Engineer | Defines SLIs/SLOs, burn-rate policies, error budgets, and release reliability gates. |
| Incident Response Engineer | Maintains incident classification, evidence capture, escalation, communication, and post-incident review. |
| Resilience Test Engineer | Runs synthetic checks, load tests, capacity tests, chaos exercises, and DR rehearsals. |
| Remediation Workflow Engineer | Connects runbooks, AWX jobs, approvals, recovery validation, and follow-up actions. |

## Connected Teams

- Consumes telemetry from observability and change records from delivery, infrastructure, Kubernetes, and governance.
- Works with database, Linux, network, data, AI, and MLOps teams during incident and recovery workflows.
- Provides readiness and recovery evidence to business operations and audit.

## Executable Use-Case Scope

- SLO governance, incident detection, escalation, evidence collection, post-incident review, and problem management.
- Dependency mapping, synthetic monitoring, load testing, chaos exercises, backup/recovery orchestration, and DR exercises.
- AWX automated remediation, maintenance-window management, and operational readiness reviews.
