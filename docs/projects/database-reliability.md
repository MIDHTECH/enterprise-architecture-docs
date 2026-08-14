# Database Reliability Domain

**Repository:** `midhhealth/data-and-integration/database-reliability-platform`  
**Team size:** 5 engineers

## Team Responsibilities

The database reliability team owns database platforms as secure, recoverable,
observable services for care delivery, payer operations, analytics, data
engineering, AI, and MLOps.

| Team member | Primary responsibility |
| --- | --- |
| Database Reliability Lead | Owns database standards, service onboarding, lifecycle roadmap, RPO/RTO targets, and review gates. |
| PostgreSQL Platform Engineer | Maintains installation, configuration, patching, upgrades, extensions, and connection pooling. |
| Backup and Recovery Engineer | Owns backup policy, restore validation, PITR, retention, and recovery exercises. |
| Database Performance Engineer | Handles query analysis, indexing, statistics, capacity, saturation, and slow-query remediation. |
| Database Security Engineer | Owns TLS, credentials, roles, auditing, privileged access, and compliance evidence. |

## Connected Teams

- Receives runtime from Linux, Kubernetes, infrastructure, and network teams.
- Feeds trusted data sources to data engineering, healthcare AI, and MLOps.
- Sends availability, performance, backup, and audit evidence to SRE and governance.

## Outcome and control role

This team owns the database service boundary and proof that data can be
recovered. The application owns schema meaning and acceptable business loss;
the database team turns those expectations into a tested operating contract.

| Responsibility | Database-domain commitment |
| --- | --- |
| Decision owned | Provision, change, patch, tune, fail over, restore or retire a named database service. |
| Evidence consumed | Application owner, data class, schema revision, identity, workload envelope, RPO/RTO, retention, dependencies and maintenance window. |
| Evidence published | Database/role state, migration result, performance baseline, audit status, backup identity, restore result, loss window and recovery time. |
| Safe-stop boundary | Unowned schema, missing backup, unrehearsed irreversible migration, excessive replication lag or failed restore validation blocks promotion. |
| Outcomes measured | Provisioning time, migration failures, query latency, capacity forecast, backup success, measured RPO/RTO and recovery-test age. |

These decisions and evidence use the
[Cross-Platform Outcome and Control Framework](../cross-platform-outcome-control-framework.md).

## Executable Use-Case Scope

- PostgreSQL installation through AWX after approval, database/role provisioning, and schema migration automation.
- Backup, point-in-time recovery, restore validation, patching, upgrades, and failover exercises.
- Performance monitoring, slow-query analysis, capacity forecasting, auditing, and data retention.

## The service being offered

Database reliability provides an application with a named database boundary,
least-privilege identity, controlled schema change, observable performance and
a recovery promise. “PostgreSQL is running” is only the starting condition.

![Database reliability architecture](../assets/project-7-database-reliability-architecture.svg)

The lab has an active PostgreSQL 18 service managed through the approved AWX
path. It is the place to prove synthetic onboarding, backup and restore
workflows. It is not evidence that an unregistered application has a database,
that every documented extension exists, or that high availability/PITR has
passed acceptance.

## Application database contract

| Item | Required decision |
| --- | --- |
| Ownership | Application owner, database owner, data classification and escalation path |
| Isolation | Database/schema boundary and explicit prohibition on anonymous shared ownership |
| Identity | Separate migration and runtime roles; credential source, rotation and revocation |
| Compatibility | Supported server version, extensions, driver and backward/forward migration window |
| Capacity | Connection budget, pool behavior, storage growth, query latency and saturation indicators |
| Protection | Backup class, retention, encryption, restore target, RPO and RTO intent |
| Change | Migration revision, transaction/lock behavior, expand-contract sequence and rollback choice |

Applications own whether a schema change remains compatible with both old and
new releases. Database engineering owns the safe mechanism and platform
limits. A pipeline does not grant itself DDL authority through the same role
used by the running service.

## Implementation: provision-to-retirement flow

1. Classify the data and define service/recovery requirements.
2. Review the existing PostgreSQL capacity and isolation choice before asking
   for new compute.
3. Create database and roles through a source-managed, bounded AWX workflow;
   deliver references to credentials rather than values.
4. Run a synthetic connection and schema migration in the non-production
   boundary. Capture locks, duration and compatibility.
5. Establish database metrics, logs, audit scope, backup job and restore test
   before production-simulation promotion.
6. Rotate credentials and exercise application reconnection.
7. On retirement, confirm data disposition and consumers before revoking roles
   and applying retention policy.

## Performance and change safety

Slow-query work starts with an execution plan, call rate, parameter shape,
locks, cache behavior and resource saturation. An index is not automatically
the answer: it carries write and storage cost. Connection exhaustion is traced
to pools and callers before increasing server limits.

Schema changes use expand-contract when releases overlap: add a compatible
shape, deploy readers/writers that tolerate both, migrate data with bounded
batches, observe, then remove the old shape in a later change. Destructive DDL
must name backup/restore and application rollback implications.

## Failure and recovery behavior

| Failure | Response |
| --- | --- |
| Migration fails | Stop promotion, preserve transaction/lock state, and run the tested down or forward-fix decision |
| Connections exhausted | Protect administrative capacity, identify pool/caller pressure and shed or bound demand |
| Storage or WAL pressure | Stop the growth source, preserve recoverability and validate retention before cleanup |
| Backup job succeeds but restore fails | Treat protection as failed; correct and repeat the restore exercise |
| Suspected corruption | Freeze unsafe writes, collect evidence and choose replica/backup recovery with the incident owner |
| Credential rotation breaks clients | Restore the previous valid reference within its controlled overlap and fix consumer reload behavior |

## Evidence and acceptance

An accepted onboarding records the database identity, role grants, schema and
migration revision, connection test, baseline queries, backup identifier,
restore result, RPO/RTO measurement, credential-rotation result, telemetry and
recovery owner. Backups are not accepted from job exit codes alone; restored
data is queried for expected structure and marker content. Detailed scenarios
remain in the [database use-case index](../use-cases/database/README.md).
