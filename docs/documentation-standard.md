# Staff Documentation Standard

## Policy

Every platform change must include staff-facing documentation in this
repository. Documentation is part of the implementation definition of done and
does not require a separate request.

Every unexpected failure, degraded condition, misleading symptom, recovery
action, or near miss must also be entered in the
[SRE Incident Register](sre-incident-register.md). This applies even when the
issue is resolved during implementation and causes no lasting outage.

This applies to:

- architecture and design decisions
- prerequisites and product-version selections
- installation and upgrade commands
- manual console or privileged steps
- configuration and environment changes
- validation and expected results
- failures, root causes, recovery steps and known limitations
- routine operations, backup, restore and disaster recovery
- security controls and credential-handling requirements
- migration and rollback procedures
- decommissioning steps

## Required Runbook Structure

Each operational runbook should contain:

1. Purpose and scope.
2. Target systems and ownership.
3. Prerequisites and safety checks.
4. Ordered implementation steps.
5. Clearly marked manual actions.
6. Validation commands and expected outcomes.
7. Troubleshooting and recovery.
8. Rollback or restoration instructions where applicable.
9. Change record with date, target, action and result.

## Writing Requirements

- Use commands that staff can copy safely.
- Use FQDNs from the canonical VM inventory.
- Never document real passwords, tokens, private keys or recovery secrets.
- Identify commands that require sudo.
- Separate production/on-prem instructions from legacy developer smoke tests.
- State when AWS, EKS or ECR work is deferred.
- Update stale instructions rather than adding contradictory alternatives.
- Record unexpected implementation failures and their verified resolution.
- Assign each incident an immutable incident ID.
- Cross-reference the affected runbook and any corrective automation change.
- Record uncertainty explicitly; do not present an assumption as root cause.
- Distinguish `planned`, `VM provisioned`, `baseline complete`, `product
  installed`, and `accepted`; a running domain is not proof of product
  installation.
- Reconcile the canonical VM document, libvirt CSV, Ansible inventory, DNS
  records, reverse-proxy routes, product catalog, capacity totals, and live
  state in the same change.
- Record an incident whenever live infrastructure is created outside the
  version-controlled source of truth, even if service is not interrupted.

## Source of Truth

`enterprise-architecture-docs` is the authoritative staff documentation
repository. Project-local documentation may contain component-specific detail,
but architecture, environment, host-build, product-version, migration and
cross-platform operating procedures must also be represented here.
