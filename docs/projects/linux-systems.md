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
| Ansible Systems Engineer | Builds idempotent roles and playbooks for baseline, patching, services, drift, and evidence. |
| Virtualization Engineer | Maintains KVM/libvirt patterns, VM inventory, cloud-init, storage pools, and host networking. |
| Security Baseline Engineer | Owns SELinux, firewalld, SSH, sudo, service accounts, package sources, and compliance checks. |
| Operations Recovery Engineer | Maintains break-glass, boot, filesystem, service recovery, and capacity troubleshooting runbooks. |

## Connected Teams

- Supports Jenkins, AWX, GitLab, Kubernetes, observability, database, and network runtime foundations.
- Consumes network/DNS standards and governance access policies.
- Sends patch, drift, capacity, and compliance evidence to SRE and governance.

## Executable Use-Case Scope

- OS build standards, patch assessment, baseline configuration, package repository control, and service management.
- KVM/libvirt, cloud-init, storage, DNS/NTP, host networking, SSH, sudo, SELinux, and firewalld.
- Configuration drift detection, server compliance evidence, capacity troubleshooting, and break-glass recovery.
