# Enterprise Cloud Governance and Operations Automation: Detailed Use Cases

Last verified: 2026-08-13

This index contains all 19 canonical use cases owned by the
Enterprise Cloud Governance and Operations Automation. Together they apply traceable controls to platform work that supports provider and payer operations. Implementation belongs
in `midhhealth/security-governance/cloud-governance-ops-automation` and must reuse existing GitLab runners, AWX inventories, Vault boundary, repository scanners, and evidence artifacts.

No page in this directory authorizes a new governance VM, scanner service, cloud account, identity platform, or automatic high-risk remediation. All pages begin as
planned specifications; their individual status changes only after source,
runtime, rollback, and evidence gates are met.

| ID | Use case | Canonical coverage |
| --- | --- | --- |
| `UC-GOV-002` | [Secrets Management Automation](UC-GOV-002-secrets-management-automation.md) | Centralize application and pipeline secrets |
| `UC-GOV-003` | [Secure Secrets Management for Applications](UC-GOV-003-secure-secrets-management-for-applications.md) | Runtime secret injection avoids hardcoded credentials |
| `UC-GOV-004` | [Cloud IAM and RBAC Standardization](UC-GOV-004-cloud-iam-and-rbac-standardization.md) | Least-privilege roles and access patterns |
| `UC-GOV-005` | [Secrets Management with Key Vault](UC-GOV-005-secrets-management-with-key-vault.md) | Azure-focused secrets implementation path |
| `UC-GOV-006` | [Cloud Misconfiguration Detector](UC-GOV-006-cloud-misconfiguration-detector.md) | Policy scans find public exposure, weak IAM, missing encryption, backup and logging gaps |
| `UC-GOV-001` | [Automated Compliance Scanning](UC-GOV-001-compliance-evidence-collection.md) | Checkov/tfsec/policy checks run in pipelines |
| `UC-GOV-007` | [Infrastructure Security Hardening](UC-GOV-007-infrastructure-security-hardening.md) | Enforces baseline cloud and Linux controls |
| `UC-GOV-008` | [Private Endpoint Implementation](UC-GOV-008-private-endpoint-implementation.md) | Restricts service access to private networks |
| `UC-GOV-009` | [DNS and Certificate Management](UC-GOV-009-dns-and-certificate-management.md) | Standardizes DNS and certificate lifecycle |
| `UC-GOV-010` | [Certificate Expiry Monitoring](UC-GOV-010-certificate-expiry-monitoring.md) | Alerts before certificate expiration |
| `UC-GOV-011` | [Runbook Automation](UC-GOV-011-runbook-automation.md) | Operational procedures become executable scripts or AWX workflows |
| `UC-GOV-012` | [Event-Driven Remediation](UC-GOV-012-event-driven-remediation.md) | Alerts, cloud events or policy findings trigger guarded automation |
| `UC-GOV-013` | [Human-in-the-Loop Remediation](UC-GOV-013-human-in-the-loop-remediation.md) | High-risk remediation pauses for approval before execution |
| `UC-GOV-014` | [Closed-Loop Automation](UC-GOV-014-closed-loop-automation.md) | Detect, remediate, validate and record recovery for low-risk failures |
| `UC-GOV-015` | [Self-Healing Infrastructure](UC-GOV-015-self-healing-infrastructure.md) | Known safe failures are repaired and verified automatically |
| `UC-GOV-016` | [Cloud Cost Anomaly Detection](UC-GOV-016-cloud-cost-anomaly-detection.md) | Spend or usage spikes are detected by owner and environment |
| `UC-GOV-017` | [Resource Right-Sizing Automation](UC-GOV-017-resource-right-sizing-automation.md) | Utilization recommends CPU, memory, storage and replica adjustments |
| `UC-GOV-018` | [Automated Root-Cause Analysis](UC-GOV-018-automated-root-cause-analysis.md) | Telemetry, deployment and infrastructure changes are correlated for RCA |
| `UC-GOV-019` | [Intelligent Alert Deduplication](UC-GOV-019-intelligent-alert-deduplication.md) | Repeated alerts are grouped into actionable incidents |

## GitLab handoff

1. Create the epic and stories from the selected page in `midhhealth/security-governance/cloud-governance-ops-automation`.
2. Implement only the planned paths that fit the repository and current lab.
3. Run fixture or read-only validation before requesting a mutating change.
4. Return commit, pipeline, Jenkins/AWX, runtime, recovery, and incident
   evidence to the architecture page.
5. Stop and request a separate architecture decision if new infrastructure,
   capacity, products, or protected-data integration would be required.

