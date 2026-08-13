# Enterprise Resilience and Service Operations Platform: Detailed Use Cases

Last verified: 2026-08-13

This index contains all 21 canonical use cases owned by the
Enterprise Resilience and Service Operations Platform. Together they connect service ownership, evidence, incident response, and recovery for enterprise workflows. Implementation belongs
in `midhhealth/reliability-operations/resilience-service-operations` and must reuse existing GitLab, Jenkins, AWX, observability APIs, service records, and runbooks.

No page in this directory authorizes a new service-management product, VM, monitoring stack, or unapproved disruptive exercise. All pages begin as
planned specifications; their individual status changes only after source,
runtime, rollback, and evidence gates are met.

| ID | Use case | Canonical coverage |
| --- | --- | --- |
| `UC-RSO-002` | [SLI and SLO Governance](UC-RSO-002-sli-and-slo-governance.md) | Standard service-level objectives |
| `UC-RSO-003` | [Error-Budget Management](UC-RSO-003-error-budget-management.md) | Release and reliability decisions based on risk |
| `UC-RSO-004` | [Incident Detection and Classification](UC-RSO-004-incident-detection-and-classification.md) | Consistent severity and ownership |
| `UC-RSO-005` | [On-Call and Escalation Workflows](UC-RSO-005-on-call-and-escalation-workflows.md) | Defined response routing |
| `UC-RSO-006` | [Automated Incident Evidence Collection](UC-RSO-006-automated-incident-evidence-collection.md) | Logs, metrics, traces and changes captured |
| `UC-RSO-007` | [Post-Incident Review](UC-RSO-007-post-incident-review.md) | Blameless corrective-action tracking |
| `UC-RSO-008` | [Problem Management](UC-RSO-008-problem-management.md) | Recurring failure elimination |
| `UC-RSO-009` | [Service Ownership](UC-RSO-009-service-ownership.md) | Named technical and business accountability |
| `UC-RSO-010` | [Dependency Mapping](UC-RSO-010-dependency-mapping.md) | Runtime and service relationship visibility |
| `UC-RSO-011` | [Synthetic Monitoring](UC-RSO-011-synthetic-monitoring.md) | User-path availability testing |
| `UC-RSO-012` | [Capacity and Saturation Testing](UC-RSO-012-capacity-and-saturation-testing.md) | Resource-limit discovery |
| `UC-RSO-013` | [Load and Performance Testing](UC-RSO-013-load-and-performance-testing.md) | Repeatable workload validation |
| `UC-RSO-014` | [Chaos and Failure Exercises](UC-RSO-014-chaos-and-failure-exercises.md) | Controlled dependency and component failures |
| `UC-RSO-015` | [Backup and Recovery Orchestration](UC-RSO-015-backup-and-recovery-orchestration.md) | Coordinated service recovery |
| `UC-RSO-016` | [Disaster-Recovery Exercises](UC-RSO-016-disaster-recovery-exercises.md) | Full workflow rehearsal |
| `UC-RSO-017` | [RTO and RPO Measurement](UC-RSO-017-rto-and-rpo-measurement.md) | Evidence-based recovery objectives |
| `UC-RSO-018` | [Certificate and Secret Expiry Response](UC-RSO-018-certificate-and-secret-expiry-response.md) | Proactive and automated renewal response |
| `UC-RSO-019` | [AWX Automated Remediation](UC-RSO-019-awx-automated-remediation.md) | Guarded, auditable operational fixes |
| `UC-RSO-020` | [Maintenance-Window Management](UC-RSO-020-maintenance-window-management.md) | Planned service-impact coordination |
| `UC-RSO-021` | [Dependency Failure Containment](UC-RSO-021-dependency-failure-containment.md) | Timeouts, retries, concurrency, degradation and recovery contain dependency failures |
| `UC-RSO-001` | [Operational Readiness Reviews](UC-RSO-001-operational-readiness-review.md) | Production-readiness scorecards and gates |

## GitLab handoff

1. Create the epic and stories from the selected page in `midhhealth/reliability-operations/resilience-service-operations`.
2. Implement only the planned paths that fit the repository and current lab.
3. Run fixture or read-only validation before requesting a mutating change.
4. Return commit, pipeline, Jenkins/AWX, runtime, recovery, and incident
   evidence to the architecture page.
5. Stop and request a separate architecture decision if new infrastructure,
   capacity, products, or protected-data integration would be required.
