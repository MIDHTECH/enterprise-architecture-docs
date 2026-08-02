# Linux Systems Engineering Domain

**Repository:** `midhhealth/platform-engineering/linux-systems-platform`  
**Team size:** 5 engineers

## Team Responsibilities

The Linux systems team owns the operating-system and VM lifecycle for the
existing on-prem fleet. Its current implementation is an active first slice
against existing VMs, not an approval to create new VMs or install new product
stacks.

| Team member | Primary responsibility |
| --- | --- |
| Linux Platform Lead | Owns Linux standards, patch policy, operational readiness, and VM lifecycle decisions. |
| Ansible Systems Engineer | Builds idempotent roles, playbooks, Bash/Python tooling, CI validation, drift controls, and evidence. |
| Virtualization Engineer | Maintains KVM/libvirt and broader VM patterns, cloud-init and image pipelines, storage pools, host networking, and container-host standards. |
| Security Baseline Engineer | Owns SELinux, firewalld, SSH, sudo, LDAP/Kerberos/AD integration, package sources, vulnerability remediation, and compliance checks. |
| Operations Recovery Engineer | Maintains monitoring, on-call triage, RCA, backup/restore, HA/DR, break-glass, boot, filesystem, service recovery, and capacity runbooks. |

## Connected Teams

- Supports Jenkins, AWX, GitLab, Kubernetes, observability, database, cloud, and network runtime foundations.
- Consumes network/DNS standards and governance access policies.
- Sends patch, drift, capacity, and compliance evidence to SRE and governance.

## Canonical Use-Case Scope

The complete Linux use-case list, market-calibration decision, coverage
targets, and authoritative count are maintained only in the
[Enterprise Linux Systems Engineering Platform](../enterprise-project-portfolio-and-usecases.md#enterprise-linux-systems-engineering-platform)
section of the enterprise portfolio. This domain page links to that source
instead of maintaining a second list.

Portfolio definition does not promote a use case to runtime verified or
accepted, and it does not authorize new VMs, products, cloud resources, or
production capacity.
