# Linux Use-Case Implementation Pages

Last verified: 2026-08-13

The authoritative Linux use-case names, coverage targets, and count remain in
the [enterprise portfolio](../../enterprise-project-portfolio-and-usecases.md#enterprise-linux-systems-engineering-platform).
That table and the index below both link directly to each detailed page. The
portfolio remains authoritative; this local index makes the implementation
specifications discoverable while working inside the Linux platform folder.

Each `UC-LNX-*` page is an end-to-end IaC implementation specification and
interview-preparation record. Pages distinguish verified existing source from
planned paths and require GitLab source gates, Jenkins approval/orchestration,
Terraform or image automation where infrastructure changes, AWX/Ansible for
operating-system state, a canary, runtime health, idempotence, recovery, and
evidence before acceptance.

| ID | Detailed use case | Architecture |
| --- | --- | --- |
| `UC-LNX-001` | [Ubuntu and Rocky Linux Installation Standards](UC-LNX-001-os-installation-standards.md) | [Diagram](UC-LNX-001-os-installation-standards.md#architecture-diagram) |
| `UC-LNX-002` | [KVM and libvirt Virtualization](UC-LNX-002-kvm-libvirt-virtualization.md) | [Diagram](UC-LNX-002-kvm-libvirt-virtualization.md#architecture-diagram) |
| `UC-LNX-003` | [VM Provisioning with cloud-init](UC-LNX-003-vm-provisioning-cloud-init.md) | [Diagram](UC-LNX-003-vm-provisioning-cloud-init.md#architecture-diagram) |
| `UC-LNX-004` | [Server Build and Retirement](UC-LNX-004-server-build-retirement.md) | [Diagram](UC-LNX-004-server-build-retirement.md#architecture-diagram) |
| `UC-LNX-005` | [AWX and Ansible Configuration Management](UC-LNX-005-awx-ansible-configuration-management.md) | [Diagram](UC-LNX-005-awx-ansible-configuration-management.md#architecture-diagram) |
| `UC-LNX-006` | [Operating-System Patching](UC-LNX-006-operating-system-patching.md) | [Diagram](UC-LNX-006-operating-system-patching.md#architecture-diagram) |
| `UC-LNX-007` | [Kernel and Major-Version Upgrades](UC-LNX-007-kernel-major-version-upgrades.md) | [Diagram](UC-LNX-007-kernel-major-version-upgrades.md#architecture-diagram) |
| `UC-LNX-008` | [SELinux and Firewall Management](UC-LNX-008-selinux-firewall-management.md) | [Diagram](UC-LNX-008-selinux-firewall-management.md#architecture-diagram) |
| `UC-LNX-009` | [systemd Service Management](UC-LNX-009-systemd-service-management.md) | [Diagram](UC-LNX-009-systemd-service-management.md#architecture-diagram) |
| `UC-LNX-010` | [Filesystem, LVM and Storage Management](UC-LNX-010-filesystem-lvm-storage-management.md) | [Diagram](UC-LNX-010-filesystem-lvm-storage-management.md#architecture-diagram) |
| `UC-LNX-011` | [DNS, NTP and Host Networking](UC-LNX-011-dns-ntp-host-networking.md) | [Diagram](UC-LNX-011-dns-ntp-host-networking.md#architecture-diagram) |
| `UC-LNX-012` | [SSH, sudo and Service Accounts](UC-LNX-012-ssh-sudo-service-accounts.md) | [Diagram](UC-LNX-012-ssh-sudo-service-accounts.md#architecture-diagram) |
| `UC-LNX-013` | [Package Repository Management](UC-LNX-013-package-repository-management.md) | [Diagram](UC-LNX-013-package-repository-management.md#architecture-diagram) |
| `UC-LNX-014` | [Performance and Capacity Troubleshooting](UC-LNX-014-performance-capacity-troubleshooting.md) | [Diagram](UC-LNX-014-performance-capacity-troubleshooting.md#architecture-diagram) |
| `UC-LNX-015` | [Configuration-Drift Detection](UC-LNX-015-configuration-drift-detection.md) | [Diagram](UC-LNX-015-configuration-drift-detection.md#architecture-diagram) |
| `UC-LNX-016` | [Server Compliance Evidence](UC-LNX-016-server-compliance-evidence.md) | [Diagram](UC-LNX-016-server-compliance-evidence.md#architecture-diagram) |
| `UC-LNX-017` | [Break-Glass Recovery](UC-LNX-017-break-glass-recovery.md) | [Diagram](UC-LNX-017-break-glass-recovery.md#architecture-diagram) |
| `UC-LNX-018` | [Linux Automation and Tooling Development](UC-LNX-018-linux-automation-tooling-development.md) | [Diagram](UC-LNX-018-linux-automation-tooling-development.md#architecture-diagram) |
| `UC-LNX-019` | [Linux Monitoring and Incident Operations](UC-LNX-019-linux-monitoring-incident-operations.md) | [Diagram](UC-LNX-019-linux-monitoring-incident-operations.md#architecture-diagram) |
| `UC-LNX-020` | [Hybrid-Cloud and Container Host Engineering](UC-LNX-020-hybrid-cloud-container-host-engineering.md) | [Diagram](UC-LNX-020-hybrid-cloud-container-host-engineering.md#architecture-diagram) |
| `UC-LNX-021` | [Enterprise Identity Integration](UC-LNX-021-enterprise-identity-integration.md) | [Diagram](UC-LNX-021-enterprise-identity-integration.md#architecture-diagram) |
| `UC-LNX-022` | [Vulnerability Remediation Lifecycle](UC-LNX-022-vulnerability-remediation-lifecycle.md) | [Diagram](UC-LNX-022-vulnerability-remediation-lifecycle.md#architecture-diagram) |
| `UC-LNX-023` | [Backup, Restore, Disaster Recovery and HA Testing](UC-LNX-023-backup-restore-disaster-recovery-ha-testing.md) | [Diagram](UC-LNX-023-backup-restore-disaster-recovery-ha-testing.md#architecture-diagram) |
| `UC-LNX-024` | [Git-Based Linux Change Validation](UC-LNX-024-git-based-linux-change-validation.md) | [Diagram](UC-LNX-024-git-based-linux-change-validation.md#architecture-diagram) |

Use the repository-wide [use-case documentation standard](../README.md) for
the required content, evidence naming, Jira story contract, and completion
rules.
