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

## Executable Use-Case Scope

- PostgreSQL installation through AWX after approval, database/role provisioning, and schema migration automation.
- Backup, point-in-time recovery, restore validation, patching, upgrades, and failover exercises.
- Performance monitoring, slow-query analysis, capacity forecasting, auditing, and data retention.
