# SRE Incident Register

## Purpose

This register preserves operational failures, recovery knowledge, misleading
symptoms, and near misses from the training environment. SRE and platform staff
should use it during troubleshooting, post-incident review, architecture
changes, and future rebuilds.

An incident remains in this register after resolution. Corrections append new
facts; they do not erase the original observation.

## Status Definitions

| Status | Meaning |
| --- | --- |
| Open | Service remains affected or corrective work is incomplete |
| Monitoring | Service is restored but follow-up validation remains |
| Resolved | Service and validation are complete |
| Accepted | Known limitation is understood and intentionally retained |

## Severity Definitions

| Severity | Meaning |
| --- | --- |
| SEV-1 | Whole platform unavailable or destructive data-loss risk |
| SEV-2 | Critical shared service unavailable with no practical workaround |
| SEV-3 | Host/component unavailable or implementation blocked |
| SEV-4 | Degraded behavior, near miss, or documented operational friction |

## Incident Summary

| ID | Date | Severity | Status | Component | Summary |
| --- | --- | --- | --- | --- | --- |
| INC-2026-001 | 2026-07-25 | SEV-4 | Resolved | Installer media | macOS security controls blocked automated USB imaging |
| INC-2026-002 | 2026-07-25 | SEV-3 | Resolved | infra02 SSH | SSH port refused connections after Ubuntu installation |
| INC-2026-003 | 2026-07-25 | SEV-3 | Resolved | infra02 SSH | Administration key was not authorized |
| INC-2026-004 | 2026-07-25 | SEV-3 | Resolved | infra02 virtualization | `qemu-kvm` had no installation candidate |
| INC-2026-005 | 2026-07-25 | SEV-3 | Resolved | infra02 virtualization | HWE and standard virtualization metapackages conflicted |
| INC-2026-006 | 2026-07-25 | SEV-4 | Resolved | infra02 network | SSH timed out during bridge DHCP/DNS transition |
| INC-2026-007 | 2026-07-25 | SEV-3 | Resolved | Rocky VM provisioning | GenericCloud canary did not boot with legacy BIOS |
| INC-2026-008 | 2026-07-25 | SEV-4 | Resolved | Fleet validation | zsh parsing and SSH stdin produced misleading validation failures |
| INC-2026-009 | 2026-07-25 | SEV-4 | Resolved | Rocky data baseline | XFS rejected a 13-character filesystem label |
| INC-2026-010 | 2026-07-25 | SEV-4 | Resolved | Ansible controller | Mac Python/crypto toolchain blocked temporary Ansible installation |
| INC-2026-011 | 2026-07-25 | SEV-3 | Resolved | infra01 VM fleet | Concurrent hypervisor workflow repeatedly cycled every infra01 VM during DNS configuration |
| INC-2026-012 | 2026-07-25 | SEV-4 | Resolved | Linksys DHCP | Router rejected reservation descriptions containing FQDNs or hyphenated labels |
| INC-2026-013 | 2026-07-25 | SEV-4 | Open | Linksys administration | Authenticated desktop dashboard remains on `Waiting...`, blocking DNS configuration |
| INC-2026-014 | 2026-07-25 | SEV-3 | Resolved | Copper9100 client DNS | Router-advertised IPv6 DNS bypassed the authoritative lab resolver |
| INC-2026-015 | 2026-07-25 | SEV-4 | Resolved | GitLab bootstrap | Initial read-only Rails inventory used an incompatible database-column query |
| INC-2026-016 | 2026-07-25 | SEV-3 | Resolved | Git repository import | Pre-publish scan found a hard-coded PostgreSQL password in current code and history |
| INC-2026-017 | 2026-07-26 | SEV-3 | Resolved | Hypervisor access | Both infra01 and infra02 were temporarily unreachable from the administration workstation |
| INC-2026-018 | 2026-07-26 | SEV-4 | Resolved | IP inventory | Prometheus DNS and Ansible records incorrectly used occupied address `.109` instead of canonical `.115` |
| INC-2026-019 | 2026-07-26 | SEV-4 | Resolved | NGINX design | HA proxy tier was implemented despite the lab's explicit non-HA scope |
| INC-2026-020 | 2026-07-27 | SEV-4 | Resolved | Architecture source of truth | Six Elastic/Splunk VMs and DNS records existed outside checked-in inventory and documentation |
| INC-2026-021 | 2026-07-27 | SEV-4 | Resolved | Git workflow | Concurrent observability updates caused non-fast-forward pushes and overlapping rebase conflicts |
| INC-2026-022 | 2026-07-27 | SEV-4 | Resolved | Five-project architecture | Obsolete HA proxy code and stale project-local architecture remained after the enterprise documentation update |
| INC-2026-023 | 2026-07-28 | SEV-4 | Resolved | NGINX and DNS | Proxy routes targeted stale ports and uninstalled products |
| INC-2026-024 | 2026-07-28 | SEV-3 | Resolved | Central logging | Encrypted fleet logging accepted with complete 31/31 hostname coverage |
| INC-2026-025 | 2026-07-28 | SEV-4 | Resolved | Filebeat enrollment | First enrollment imported active-file history despite the intended new-event baseline |
| INC-2026-026 | 2026-07-28 | SEV-4 | Resolved | Fleet verification | Elasticsearch01 SSH disconnected during protected-material verification |
| INC-2026-027 | 2026-07-28 | SEV-3 | Resolved | AWX SSH access | Canonical key restored, Filebeat enrolled, and 31/31 coverage accepted |
| INC-2026-028 | 2026-07-28 | SEV-4 | Resolved | Recovery target context | AWX permission-repair commands were initially run on infra01 instead of inside the AWX console |
| INC-2026-029 | 2026-07-28 | SEV-4 | Resolved | AWX serial console | A stale virsh client held the AWX console lock and blocked operator login |
| INC-2026-030 | 2026-07-28 | SEV-4 | Open | Headlamp DNS | Headlamp NGINX route is healthy, but its application FQDN is absent from authoritative DNS |
| INC-2026-031 | 2026-07-28 | SEV-4 | Resolved | Prometheus inventory | Live metrics coverage fell to 27/31 hosts while documentation still reported 31/31 |
| INC-2026-032 | 2026-07-29 | SEV-4 | Resolved | Ansible validation workstation | Mac Python and OpenSSL constraints blocked a repo-local Ansible environment |
| INC-2026-033 | 2026-07-29 | SEV-4 | Monitoring | VM management network | Direct administration-workstation SSH intermittently timed out while hypervisor-to-guest traffic remained healthy |
| INC-2026-034 | 2026-07-29 | SEV-3 | Resolved | AWX execution environment | Forced Quay image pulls blocked jobs during external DNS failures |
| INC-2026-035 | 2026-07-29 | SEV-3 | Resolved | Node Exporter reconciliation | An idempotent run unnecessarily downloaded an already installed binary and failed on GitHub DNS |
| INC-2026-036 | 2026-07-29 | SEV-3 | Resolved | Observability data plane | Host firewalls blocked Kubernetes-to-OTel and collector/Grafana/AWX access to Tempo and Loki |
| INC-2026-037 | 2026-07-29 | SEV-3 | Resolved | Authoritative DNS | BIND query ACL excluded the Kubernetes pod network |
| INC-2026-038 | 2026-07-29 | SEV-3 | Resolved | Kubernetes CoreDNS | Private-zone lookups were randomly sent to the router resolver and returned empty answers |
| INC-2026-039 | 2026-07-29 | SEV-4 | Resolved | GitLab Runner | Project-scoped runner could not claim validation jobs from the wider GitLab instance |
| INC-2026-040 | 2026-07-29 | SEV-4 | Resolved | GitLab CI validation | Default images, conflicting stage graphs, and ignored Ansible paths prevented repository validation |
| INC-2026-041 | 2026-07-29 | SEV-3 | Resolved | Terraform security controls | First executable Checkov scan found 14 blocking policy gaps in legacy cloud examples |
| INC-2026-042 | 2026-07-29 | SEV-4 | Resolved | GitLab Runner image policy | Forced registry checks failed cached CI images during router-DNS timeouts |
| INC-2026-043 | 2026-07-29 | SEV-4 | Resolved | AWX cloud project SCM | Existing AWX deploy key was not enabled for the cloud repository |
| INC-2026-044 | 2026-07-29 | SEV-4 | Resolved | AWX Ansible role discovery | DNS job could not find the repository-local `bind_dns` role |
| INC-2026-045 | 2026-07-29 | SEV-4 | Resolved | Kubernetes evidence scope | A DNS acceptance pod initially ran in AWX's k3s cluster instead of the four-node application cluster |
| INC-2026-046 | 2026-07-29 | SEV-2 | Monitoring | infra01 VM networking | Host reboot initially left 16 of 17 autostart guests without IPv4 after bridge STP delayed forwarding |
| INC-2026-047 | 2026-07-29 | SEV-2 | Resolved | GitLab startup | GitLab ports returned resets or refusals during extended post-reboot startup |
| INC-2026-048 | 2026-07-29 | SEV-3 | Resolved | Vault post-reboot recovery | Vault 2.0.3 restarted sealed; controlled unseal and route acceptance restored service |
| INC-2026-049 | 2026-07-29 | SEV-4 | Resolved | AWX inventory | Overlapping inventories inflated 35 unique hostnames to 70 host records |
| INC-2026-050 | 2026-07-29 | SEV-4 | Resolved | NGINX automation | Firewalld and deferred-handler assumptions caused partial convergence |
| INC-2026-051 | 2026-07-29 | SEV-4 | Resolved | AWX inventory groups | A successful DNS job skipped all work because the selected inventory lacked `dns_servers` |
| INC-2026-052 | 2026-07-29 | SEV-4 | Resolved near miss | AWX web UI | Direct SPA navigation displayed stale DNS form data on the NGINX template edit route |
| INC-2026-053 | 2026-07-29 | SEV-4 | Resolved near miss | Kubernetes delivery architecture | Planned ingress launch would have wrapped Helm in Ansible and bypassed Jenkins |
| INC-2026-054 | 2026-07-29 | SEV-4 | Resolved | Kubernetes CI | First Helm-boundary pipeline failed role-prefix lint |
| INC-2026-055 | 2026-07-29 | SEV-4 | Resolved near miss | Jenkins infrastructure CI | `ansible-jenkins` would deploy the controller automatically from `main` |
| INC-2026-056 | 2026-07-29 | SEV-4 | Resolved | Lab DNS | `jenkins-agent01.example.com` had no authoritative record |
| INC-2026-057 | 2026-07-29 | SEV-4 | Resolved | Jenkins source of truth | Catalog reported stale version and container deployment |
| INC-2026-058 | 2026-07-29 | SEV-4 | Resolved | Jenkins agent CI | Agent role used `systemctl` instead of service facts |
| INC-2026-059 | 2026-07-31 | SEV-4 | Resolved | Cloud infrastructure CI | Main Terraform validation briefly failed when Alpine package indexes were unavailable |
| INC-2026-060 | 2026-07-31 | SEV-3 | Resolved | Authoritative DNS automation | AWX DNS job 461 attempted an unnecessary BIND package transaction while public DNS was unavailable |
| INC-2026-061 | 2026-07-31 | SEV-4 | Resolved | Cloud infrastructure CI | Branch pipeline 377 repeated the Alpine package-index bootstrap failure before Terraform validation |
| INC-2026-062 | 2026-07-31 | SEV-4 | Resolved | AWX cloud project SCM | Successful project sync still selected a stale temporary branch instead of canonical main |
| INC-2026-063 | 2026-07-31 | SEV-4 | Monitoring | Administration client DNS | Direct UDP queries from the Mac to the lab resolver timed out while scoped resolution and authoritative queries from infra01 succeeded |
| INC-2026-064 | 2026-08-01 | SEV-3 | Resolved | Hypervisor/control-plane reachability | Agent work paused when infra01/02 and hosted control planes were unreachable; all required endpoints recovered before mutation |
| INC-2026-065 | 2026-08-01 | SEV-4 | Resolved | AWX ansible-jenkins SCM | Initial project sync failed because the existing AWX read-only deploy key was not enabled for the repository |
| INC-2026-066 | 2026-08-01 | SEV-4 | Resolved | Jenkins agent acceptance | AWX installed Helm under `/usr/local/bin`, but the non-login acceptance command used PATH lookup and failed |
| INC-2026-067 | 2026-08-01 | SEV-4 | Resolved | Jenkins local proxy | AWX job 550 found firewalld inactive; corrected source composed the established firewall role before proxy deployment |
| INC-2026-068 | 2026-08-01 | SEV-4 | Resolved | GitLab Runner identity automation | First dedicated-runner deployment assumed an absent `root` GitLab username |
| INC-2026-069 | 2026-08-01 | SEV-4 | Resolved | Shared GitLab runner automation | Dormant provisioning and instance-runner paths exposed role-path, image-checksum, CI-image, and nil-scope assumptions |
| INC-2026-070 | 2026-08-02 | SEV-4 | Resolved | AWX controller-object reconciliation | Initial job templates omitted the project-relative `playbooks/` path |
| INC-2026-071 | 2026-08-02 | SEV-4 | Resolved | AWX inventory reconciliation | The reconciler attempted an unsupported PATCH on nested inventory child endpoints |
| INC-2026-072 | 2026-08-02 | SEV-4 | Resolved | AWX execution scheduling | Controller-side templates were bound to the non-executing control-plane group and could not obtain capacity |
| INC-2026-073 | 2026-08-02 | SEV-4 | Resolved | GitLab shared runner | One source-validation job could not clone GitLab during a transient HTTP connectivity failure |
| INC-2026-074 | 2026-08-02 | SEV-4 | Resolved | AWX execution runtime lock | The first install omitted Python 3.9 conditional hashes for `importlib-metadata` and `zipp` |
| INC-2026-075 | 2026-08-03 | SEV-4 | Resolved | Kubernetes ingress delivery prerequisites | Live reconciliation found the job and credential absent, then exposed an unlabeled seed that could not use the exclusive agent |
| INC-2026-076 | 2026-08-03 | SEV-3 | Resolved | Jenkins Configuration as Code | Production job 1617 deployed an unsupported freestyle label method; merge request !15 and protected jobs 1624/1625 restored and converged Jenkins |
| INC-2026-077 | 2026-08-03 | SEV-4 | Resolved | Jenkins ingress source checkout | PLAN build 1 ran on the dedicated agent but GitLab denied the existing Jenkins deploy key before source checkout |
| INC-2026-078 | 2026-08-03 | SEV-4 | Open | Kubernetes ingress exposure design | Pre-deployment review found that the accepted PLAN still depended on shared `nginx.example.com` and NodePorts, contrary to the permanent product-local NGINX rule |

## INC-2026-001: Automated USB Imaging Blocked

- Date: 2026-07-25
- Component: macOS administration workstation and Ubuntu installer USB
- Detection: Automated disk access was rejected by macOS privacy/security
  controls.
- Impact: Codex could not write the downloaded Ubuntu 26.04 image directly to
  the attached USB device.
- Cause: macOS protected raw-disk access required an interactive,
  locally-authorized workflow.
- Resolution: The operator performed the privileged USB imaging steps manually
  from the Mac.
- Prevention: Treat installer-media creation as a manual workstation runbook
  step. Verify the exact disk identifier immediately before writing and never
  automate selection of a destructive raw-disk target.
- Evidence/related runbook:
  [On-Premises Platform Build Runbook](on-prem-platform-build-runbook.md)

## INC-2026-002: SSH Connection Refused After Reinstallation

- Date: 2026-07-25
- Component: `infra02.example.com`
- Symptom: Ping returned no replies and SSH returned `Connection refused`.
- Impact: Remote host bootstrap could not begin.
- Cause: The freshly installed Ubuntu Desktop host did not yet have an active
  OpenSSH server accepting TCP port 22.
- Resolution: Installed `openssh-server`, enabled the `ssh` service, and allowed
  OpenSSH through UFW.
- Validation: SSH changed from connection refusal to an authentication
  response.
- Prevention: Include SSH installation, service enablement, listening-port
  validation, and firewall configuration in the post-install console checklist.
- Evidence/related runbook:
  [On-Premises Platform Build Runbook](on-prem-platform-build-runbook.md)

## INC-2026-003: SSH Authentication Rejected

- Date: 2026-07-25
- Component: `midhtechadmin@infra02.example.com`
- Symptom: `Permission denied (publickey,password)`.
- Impact: Non-interactive administration remained blocked after SSH became
  reachable.
- Cause: The Mac administration public key was not present in the account's
  `authorized_keys`.
- Resolution: Added `~/.ssh/id_rsa.pub` to the server account and corrected
  `.ssh`/`authorized_keys` permissions.
- Validation:

```bash
ssh -o BatchMode=yes midhtechadmin@infra02.example.com hostname
```

- Prevention: Make key enrollment and non-interactive authentication testing
  mandatory before host automation.

## INC-2026-004: `qemu-kvm` Virtual Package Failure

- Date: 2026-07-25
- Component: Ubuntu 26.04 virtualization bootstrap
- Symptom: APT reported that `qemu-kvm` was a virtual package with no
  installation candidate.
- Impact: The operating-system upgrade completed, but virtualization packages
  were not installed.
- Cause: Ubuntu 26.04 requires selection of a concrete QEMU provider.
- Resolution: Replaced `qemu-kvm` in the bootstrap with an explicit provider.
- Follow-up: The initial HWE provider exposed a second dependency conflict,
  recorded as INC-2026-005.
- Prevention: Simulate release-specific package transactions with
  `apt-get -s` before executing host bootstrap changes.

## INC-2026-005: QEMU HWE/Libvirt Dependency Conflict

- Date: 2026-07-25
- Component: Ubuntu 26.04 virtualization bootstrap
- Symptom: APT could not satisfy dependencies because
  `qemu-system-x86-hwe` selected `ubuntu-virt-hwe`, while `libvirt-clients`
  selected conflicting `ubuntu-virt`.
- Impact: The second virtualization installation attempt stopped before
  package installation.
- Cause: HWE QEMU and the standard libvirt dependency family were mixed in one
  transaction.
- Resolution: Selected standard `qemu-system-x86`. A complete simulated
  transaction resolved successfully before revision 3 was uploaded.
- Validation: After installation and reboot, QEMU 10.2.1, libvirt 12.0.0,
  `/dev/kvm`, Cockpit, Ansible, SSH, and Chrony all passed validation.
- Prevention:

```bash
sudo apt-get -s install \
  qemu-system-x86 libvirt-daemon-system libvirt-clients \
  virt-install virt-manager
```

- Corrective automation:
  `workspace.training/scripts/bootstrap-infra02-host.sh`

## INC-2026-006: Temporary Loss of SSH During Bridge Transition

- Date: 2026-07-25
- Component: `infra02.example.com` physical bridge
- Symptom: SSH to the hostname timed out and ARP for the prior address was
  incomplete immediately after bridge activation.
- Initial assessment: The physical bridge might have failed and rollback might
  be required.
- Corrected finding: The bridge succeeded. The operator did not perform
  rollback. DHCP moved from the former `enp0s25` lease at `192.168.1.73` to
  `br0` at `192.168.1.169`; dynamic DNS then converged.
- Impact: Short management-plane interruption and risk of an unnecessary
  rollback.
- Cause: The bridge used a different MAC identity and received a new DHCP
  lease. DNS convergence lagged behind interface activation.
- Resolution: Waited for DHCP/dynamic DNS convergence and reconnected to
  `infra02.example.com`.
- Validation:

```text
br0      192.168.1.169/24
enp0s25  bridge port, forwarding
default  via 192.168.1.1 dev br0
```

Gateway reachability, SSH, libvirt, and the `lab-images` pool passed.

- Prevention:
  - Reserve `192.168.1.169` against bridge MAC `96:df:df:6e:93:36`.
  - Validate `br0` locally before declaring bridge failure.
  - Allow time for DHCP and dynamic DNS convergence.
  - Use rollback only when the bridge lacks an address/default route or cannot
    reach the gateway.
- Corrective automation:
  `workspace.training/scripts/configure-physical-bridge.sh`
- Evidence/related runbook:
  [On-Premises Platform Build Runbook](on-prem-platform-build-runbook.md)

## INC-2026-007: Rocky GenericCloud Canary Required UEFI

- Date: 2026-07-25
- Severity: SEV-3
- Status: Resolved
- Component: `postgres.example.com` canary provisioning
- Detection/symptom: The libvirt domain was running and consuming CPU, but
  emitted no network traffic, did not connect the QEMU guest agent, provided no
  serial-console output, and timed out on SSH.
- Impact: Canary validation failed and provisioning of the other ten infra02
  VMs was blocked.
- Cause: The pinned Rocky Linux 9.8 GenericCloud image did not complete boot
  under the legacy BIOS configuration selected by the initial `virt-install`
  command.
- Resolution: Powered off the disposable canary definition, changed its
  firmware to UEFI, and restarted it. The provisioning script was corrected to
  include `--boot uefi` for every subsequent VM.
- Validation: The VM completed cloud-init, accepted key-based SSH at
  `192.168.1.125`, reported Rocky Linux 9.8, mounted a 50 GiB root disk, exposed
  the 250 GiB data disk, activated the guest agent/Chrony/firewalld, and
  reported SELinux Enforcing.
- Prevention: UEFI is now mandatory in the Rocky Linux VM provisioning
  automation. The canary gate remains mandatory before `create-all`.
- Corrective automation:
  `workspace.training/scripts/provision-libvirt-vms.sh`
- Evidence/related runbook:
  [On-Premises Platform Build Runbook](on-prem-platform-build-runbook.md)

## INC-2026-008: Fleet Validation Loop Produced False Failures

- Date: 2026-07-25
- Severity: SEV-4
- Status: Resolved
- Component: infra02 post-provision fleet validation
- Detection/symptom: The first ad hoc zsh loop expanded the combined
  name/address entry incorrectly and attempted `midhtechadmin@` with an empty
  host. A corrected pipeline then validated only one VM because SSH consumed
  the loop's standard input. The durable validator was subsequently invoked
  once on infra02 instead of the Mac and correctly failed because the
  hypervisor has no guest private key.
- Impact: Output initially resembled fleet-wide authentication failure and then
  an incomplete inventory run. No VM configuration was changed.
- Cause: zsh does not apply unquoted scalar word splitting like bash, and SSH
  reads stdin unless explicitly detached.
- Resolution: Used explicit `read -r name ip` parsing and `ssh -n`.
- Security finding: No private key was copied to infra02; the validator was
  rerun from the authorized Mac administration workstation.
- Validation: The corrected command reached each allocated VM address and
  reported its actual state.
- Prevention: Replaced the ad hoc operator loop with
  `scripts/validate-libvirt-vms.sh`, which reads CSV fields directly and always
  invokes SSH with `-n`.
- Corrective automation:
  `workspace.training/scripts/validate-libvirt-vms.sh`
- Evidence/related runbook:
  [On-Premises Platform Build Runbook](on-prem-platform-build-runbook.md)

## INC-2026-009: XFS Data Label Exceeded Length Limit

- Date: 2026-07-25
- Severity: SEV-4
- Status: Resolved
- Component: `postgres.example.com` common baseline canary
- Detection/symptom: `mkfs.xfs` rejected label `midhtech-data` because XFS
  labels have a maximum length of 12 characters.
- Impact: The baseline stopped before filesystem creation. The empty data disk
  remained unformatted and no mount or SSH hardening changes followed.
- Cause: The proposed label contained 13 characters.
- Resolution: Changed the label to `midhdata` and reran the idempotent canary
  baseline.
- Validation: Confirmed `/dev/vdb` contained no filesystem before retry.
- Prevention: Keep filesystem labels within format-specific limits and retain
  the baseline's stop-on-error behavior.
- Corrective automation:
  `workspace.training/scripts/rocky9-common-baseline.sh`
- Evidence/related runbook:
  [On-Premises Platform Build Runbook](on-prem-platform-build-runbook.md)

## INC-2026-010: Temporary Mac Ansible Environment Failed

- Date: 2026-07-25
- Severity: SEV-4
- Status: Resolved
- Component: Ansible controller bootstrap
- Detection/symptom: macOS system Python exposed Ansible only through 2.15.
  Bundled Python 3.12 could select Ansible Core 2.20, but pip attempted to build
  `cryptography` and failed because an x86-64 OpenSSL/pkg-config development
  toolchain was not available.
- Impact: The planned disposable Mac Ansible virtual environment could not be
  created. Managed hosts and PostgreSQL were unaffected.
- Cause: Python/package architecture and native build prerequisites on the Mac
  did not match the current cryptography build path.
- Resolution: Used the already-installed Ansible Core 2.20.1 on infra02 and
  forwarded the Mac SSH agent. No private key was copied to the hypervisor.
- Validation: `ssh-add -L` succeeded only within the forwarded session.
- Prevention: AWX will become the durable controller. Before AWX is available,
  execute Ansible on infra02 only through an agent-forwarded administrative
  session and keep playbooks in version control.
- Corrective documentation:
  `cloud-infra-automation-platform/ansible/README.md`

## INC-2026-011: Hypervisor-Initiated DNS VM Shutdown During Ansible

- Date: 2026-07-25
- Severity: SEV-3
- Status: Resolved
- Component: infra01 VM fleet, detected through `dns.example.com`
- Detection/symptom: The DNS playbook lost SSH during the BIND package task.
  The guest temporarily refused port 22 and its QEMU guest agent was
  unavailable.
- Impact: The first DNS configuration run stopped during package installation.
  BIND packages completed installation, but zones and the named service had
  not yet been configured. A second retry stopped before fact gathering.
- Cause: The previous-boot guest journal records
  `guest-shutdown called, mode: powerdown` and
  `hypervisor initiated shutdown`.
- Contributing factors: A VM lifecycle operation overlapped an active
  configuration job. On the second interruption, libvirt IDs changed for all
  13 infra01 domains, confirming a fleet-wide stop/start cycle rather than a
  DNS package failure. The exact initiating hypervisor process was unavailable
  because the infra01 system journal requires interactive sudo.
- Resolution: Paused until the fleet stabilized, then completed the idempotent
  DNS role. The final second convergence run reported `changed=0`,
  `unreachable=0`, and `failed=0`.
- Validation: BIND is enabled and active; firewalld permits DNS; authoritative
  UDP/TCP, reverse, and recursive lookups succeeded from the Mac administration
  workstation.
- Prevention/follow-up: Do not run provisioning or VM lifecycle operations
  while configuration jobs are active. Add an AWX workflow approval and
  maintenance lock. An infra01 administrator should inspect host journal and
  automation history around `2026-07-25 23:53:55 UTC`.
- Corrective automation:
  `cloud-infra-automation-platform/ansible/roles/bind_dns`

## INC-2026-012: Linksys Reservation Description Validation Failure

- Date: 2026-07-25
- Severity: SEV-4
- Status: Resolved
- Component: Linksys DHCP reservation API
- Detection/symptom: `SetLANSettings` returned
  `ErrorReservationDescriptionInvalid`.
- Impact: The requested reservation table was not created.
- Cause: This firmware rejected FQDN and hyphenated reservation descriptions
  even though their IP and MAC values were valid.
- Resolution: The transaction was atomic and left the existing reservation
  list empty. Automation was revised to use short hostname-safe descriptions:
  `infra01`, `infra02`, and `vm101` through `vm140`. The router accepted all 42
  entries and restarted DHCP.
- Validation: Both hypervisors remained reachable. A fresh
  `GetLANSettings` query returned 42 reservations, and normalized comparison
  reported `matches: true` with an empty differences list.
- Prevention/follow-up: Keep Linksys reservation descriptions limited to
  letters and digits. Re-run plan and verification before closing the
  incident.
- Corrective automation:
  `scripts/configure-linksys-dhcp-reservations.sh`

## INC-2026-013: Linksys Desktop Dashboard Stuck on Waiting

- Date: 2026-07-25
- Severity: SEV-4
- Status: Resolved
- Component: Linksys Smart Wi-Fi local administration at `192.168.1.1`
- Detection/symptom: Local router authentication succeeded, but the dashboard
  remained behind a `Waiting...` overlay before and after reload and a router
  DHCP restart.
- Impact: The desktop interface did not expose Advanced Settings or Local
  Network Settings, so the router could not yet be configured to advertise
  `192.168.1.106` as client DNS.
- Cause: The local Smart Wi-Fi application could not complete router/app
  discovery. Browser logs did not provide a definitive failure.
- Resolution: DHCP reservations were safely completed using the router's
  documented local JNAP actions. DNS configuration remains pending through the
  Linksys mobile app.
- Prevention/follow-up: Use **Advanced Settings → Local Network Settings → DNS
  Settings → Manual** in the Linksys app, set `192.168.1.106`, then renew and
  validate a client lease. Do not use guessed or undocumented DNS API fields.
- Evidence/related runbook:
  [Lab DNS Installation and Copper9100 Client Configuration](product-installation-dns.md)

## INC-2026-014: IPv6 Router DNS Bypassed Lab DNS

- Date: 2026-07-25
- Severity: SEV-3
- Status: Resolved
- Component: Copper9100 DNS advertisement and macOS Wi-Fi
- Detection/symptom: `nslookup gitlab.example.com` selected router IPv6
  resolver `2603:300c:571:c280:ea9f:80ff:feec:54af` and returned no answer.
- Impact: Clients using router-advertised DNS cannot resolve internal
  `*.example.com` records. The router DHCP restart also broke an existing SSH
  session with `client_loop: send disconnect: Broken pipe`.
- Cause: The Mac had no explicit Wi-Fi DNS configuration and accepted the
  gateway's IPv6 resolver first, followed by `192.168.1.1`. Neither resolver is
  authoritative for the internal zone.
- Validation: Direct queries to `192.168.1.106` returned
  `gitlab.example.com = 192.168.1.101` and
  `awx.example.com = 192.168.1.103`, confirming BIND is healthy.
- Temporary resolution: On each affected Mac, set Wi-Fi DNS to
  `192.168.1.106` and flush the resolver cache. This requires local sudo.
- Corrected scope: `networksetup` applies this override to the entire Wi-Fi
  service, not only Copper9100. Use `/etc/resolver/example.com` for safer
  temporary split DNS, or remove the override before joining another Wi-Fi
  network.
- Resolution validation: The affected Mac reports `192.168.1.106` as its
  configured Wi-Fi DNS. Normal client queries resolve
  `gitlab.example.com = 192.168.1.101`,
  `awx.example.com = 192.168.1.103`, and public Internet names through BIND
  recursion.
- Split-DNS validation: After replacing the Wi-Fi-wide override with
  `/etc/resolver/example.com`, `scutil --dns` showed the supplemental resolver,
  `dscacheutil` resolved GitLab/AWX correctly, and normal hostname resolution
  reached GitLab. `nslookup` continued to query the default router resolver by
  design and is not a valid supplemental-resolver test.
- Permanent resolution: In the Linksys app, set Local Network DNS to Manual
  with `192.168.1.106`, and disable public/router IPv6 DNS advertisement or
  advertise a stable IPv6 address for the lab DNS server.
- Evidence/related runbook:
  [Lab DNS Installation and Copper9100 Client Configuration](product-installation-dns.md)

## INC-2026-015: GitLab Rails Inventory Query Incompatibility

- Date: 2026-07-25
- Severity: SEV-4
- Status: Resolved
- Component: GitLab 19.2 bootstrap inventory
- Detection/symptom: The initial read-only Rails runner query attempted
  `pluck(:full_path)` for groups and projects and failed because `full_path` is
  a computed model attribute rather than a database column in this GitLab
  version.
- Impact: The first inventory command failed. GitLab data and service
  availability were unaffected, and no mutation had started.
- Cause: The inventory query assumed that the model attribute was directly
  selectable by Active Record.
- Resolution: Re-ran the inventory using `map(&:full_path)` after loading the
  models. It returned an empty group and project inventory as expected.
- Validation: The corrected query succeeded; the private platform group and
  eight projects were then created and enumerated.
- Prevention/follow-up: Prefer documented APIs for routine inventory. When
  Rails runner is necessary, validate computed model attributes against the
  installed GitLab version and perform a read-only preflight first.
- Evidence/related runbook:
  [GitLab Repository Onboarding](gitlab-repository-onboarding.md)

## INC-2026-016: Hard-Coded Database Password Found Before GitLab Import

- Date: 2026-07-25
- Severity: SEV-3
- Status: Resolved
- Component: `cloud-infra-automation-platform` Git history
- Detection/symptom: The pre-publish repository scan found a literal
  PostgreSQL application password in
  `terraform/modules/database/main.tf`. The value was also reachable from an
  earlier commit on `main`.
- Impact: No GitLab project contained the value because all remote projects
  were still empty and the push was stopped. Publishing without remediation
  would have exposed a reusable credential pattern in the private source
  repository and its history.
- Cause: The training implementation embedded a local bootstrap password
  directly in a Kubernetes Secret resource.
- Resolution: Replaced the literal with a required sensitive Terraform input,
  wired all four environments to that input, and rewrote the affected local
  `main` history before the initial push. A recovery ref was retained locally
  during import; it was not pushed.
- Validation: Current-tree search found no literal value. A history search
  found it unreachable from the rewritten `main`. The GitLab project was
  confirmed empty before push, and its remote `main` now matches the sanitized
  local commit.
- Prevention/follow-up: Supply `TF_VAR_postgres_password` from the approved
  secret store, add automated secret scanning to GitLab CI, and never use
  repository examples as a credential store. Rotate the value anywhere it may
  have been reused despite being labeled for local use.
- Corrective automation:
  `cloud-infra-automation-platform/terraform/modules/database`
- Evidence/related runbook:
  [GitLab Repository Onboarding](gitlab-repository-onboarding.md)

## INC-2026-017: Both Hypervisors Unreachable During Proxy-Tier Build

- Date: 2026-07-26
- Severity: SEV-3
- Status: Resolved
- Component: `infra01.example.com`, `infra02.example.com`, and administration
  workstation network path
- Detection/symptom: SSH to both FQDNs and direct addresses
  `192.168.1.38` and `192.168.1.169` timed out. Ping returned 100% loss, TCP
  port 22 reported the hosts down, and ARP entries for both hypervisors,
  GitLab, and DNS remained incomplete.
- Impact: Live libvirt capacity could not be verified and the new NGINX VMs
  could not be provisioned. No VM or DNS mutation was attempted.
- Timeline: Detected while starting the NGINX reverse-proxy implementation on
  2026-07-26.
- Cause: Undetermined. The Mac retained `192.168.1.72/24`, reached the Linksys
  gateway at `192.168.1.1:80`, and learned the gateway MAC, but Layer-2
  neighbor discovery did not reach either hypervisor or their GitLab/DNS VMs.
  This narrows the fault toward both hosts being powered off or disconnected,
  or a shared hypervisor switch/uplink path, rather than loss of the
  workstation-to-router connection.
- Resolution: Connectivity returned without a configuration change from this
  workflow.
- Validation: TCP/22 succeeded to `.38` and `.169`; GitLab HTTP and DNS TCP/53
  succeeded; both bridges held their expected addresses and default routes;
  libvirt and `lab-bridge` were active; both hosts reported approximately
  2.6 TiB free in the VM image filesystem.
- Prevention/follow-up: Add hypervisor reachability and bridge-state
  monitoring after Prometheus is available. Do not interpret FQDN resolution
  as host availability.
- Evidence/related runbook:
  [Standalone NGINX Reverse-Proxy Installation](product-installation-nginx.md)

## INC-2026-018: Prometheus Address Drift Could Have Targeted Non-Lab Device

- Date: 2026-07-26
- Severity: SEV-4
- Status: Resolved
- Component: BIND and Ansible inventory
- Detection/symptom: The canonical VM inventory and libvirt CSV assigned
  `prometheus.example.com` to `192.168.1.115`, while BIND defaults and the
  Ansible host inventory still assigned it to `192.168.1.109`.
- Impact: `.109` is documented as occupied by a non-lab LAN device. Applying
  the stale configuration could have sent automation or monitoring traffic to
  the wrong system. No such apply occurred during this change.
- Cause: Prometheus was moved from `.109` to `.115` after the address conflict,
  but not every machine-readable inventory was updated.
- Resolution: The 2026-07-26 assessment incorrectly claimed both BIND and
  Ansible were corrected. BIND was corrected, but the checked-in Ansible
  inventory still contained `.109`. The 2026-07-27 full audit corrected
  Ansible to `.115` and retained the advanced DNS serial. The canonical VM
  inventory and libvirt CSV already contained `.115`.
- Validation: Repository-wide address checks now identify `.115` for the
  Prometheus VM, Ansible host, DNS record, and proxy backend. Live DNS also
  returns `.115`.
- Prevention/follow-up: Generate DNS, Ansible, router reservations, and
  provisioning inventory from one structured source of truth. Add CI checks
  that reject duplicate or inconsistent IP assignments.
- Corrective automation:
  `cloud-infra-automation-platform/ansible/roles/bind_dns`
- Evidence/related runbook:
  [Canonical VM Inventory](vm-inventory.md)

## INC-2026-019: HA Proxy Design Exceeded Lab Scope

- Date: 2026-07-26
- Severity: SEV-4
- Status: Resolved
- Component: NGINX architecture, libvirt inventory, Ansible, and documentation
- Detection/symptom: The initial implementation created
  `nginx01.example.com` and `nginx02.example.com` with a proposed Keepalived
  VIP even though the lab explicitly does not define HA.
- Impact: Two empty VMs were briefly created and the first automation revision
  contained unnecessary Keepalived, VRRP, VIP, and cluster complexity. No
  application DNS records were published and no user traffic was affected.
- Cause: The phrase "additional VMs" was interpreted as requiring a
  multi-hypervisor proxy pair instead of applying the existing non-HA
  architecture decision.
- Resolution: Stopped and undefined only the two new empty domains, removed
  their OS, data, and cloud-init volumes, and replaced the design with the
  standalone `nginx.example.com` VM at `192.168.1.114`. Removed Keepalived,
  VRRP, `.132`, and `.140` from active configuration. Replaced the stale
  `.114` SSH host key left by the intentionally deleted VM; macOS retained a
  recovery copy as `~/.ssh/known_hosts.old`. Removed the exact orphaned
  `nginx01`/`nginx02` image and cloud-init directories after inspection.
- Validation: `virsh dominfo` confirms both numbered domains are absent.
  Machine-readable inventory, Ansible, DNS, version history, and staff
  documentation now define only the standalone VM. `.132` and `.140` remain
  expansion addresses. The new ED25519 host-key fingerprint is
  `SHA256:yFx7AwITKQNcN6F+ETaLCKFyEREvujUowM9SQPWeK2U`. Final path checks
  confirmed the numbered-domain directories and temporary Ansible bootstrap
  copy are absent.
- Prevention/follow-up: Treat the lab-wide "no HA" decision as an architecture
  constraint. Numeric `01/02` names require an explicitly approved cluster;
  do not infer a cluster from plural wording.
- Corrective automation:
  `cloud-infra-automation-platform/ansible/roles/nginx_reverse_proxy`
- Evidence/related runbook:
  [Standalone NGINX Reverse-Proxy Installation](product-installation-nginx.md)

## INC-2026-020: Elastic/Splunk Topology Was Outside Source Control

- Date: 2026-07-27
- Severity: SEV-4
- Status: Resolved
- Component: libvirt inventory, Ansible inventory, BIND, NGINX, product
  catalog, capacity plan, and staff documentation
- Detection/symptom: A full architecture review found six running/autostart
  domains and corresponding live DNS records that were absent from the
  workspace VM CSVs, checked-in Ansible inventory, and enterprise
  documentation:
  `elasticsearch01`–`elasticsearch03`, `kibana`, `logstash`, and `splunk`.
- Impact: Staff could not reliably rebuild the topology; capacity totals were
  understated; automation did not target the hosts; and a running VM could
  have been mistaken for a completed product installation.
- Timeline: The drift was discovered on 2026-07-27 while reconciling all
  architecture documents with live infra01/infra02 state.
- Cause: The VMs and DNS entries were created before their source-of-truth
  inventory and documentation changes were completed.
- Contributing factors: Documentation validation checked only that a small set
  of files existed and did not compare VM names/addresses across CSV, Ansible,
  DNS, proxy, and documentation.
- Resolution: Added all six VMs to canonical and machine-readable inventories,
  synchronized DNS and Kibana/Splunk proxy definitions, added version and
  annual migration records, documented placement and capacity, and created
  product-specific installation runbooks. Corrected the unrelated Prometheus
  Ansible drift found in the same audit.
- Validation: Cross-source checks confirm the six FQDNs and addresses are
  represented consistently. Documentation explicitly reports them as
  provisioned-only: the common baseline, `/data` mounts, and product packages
  remain pending.
- Prevention/follow-up: CI now requires the new runbooks and rejects the known
  stale Prometheus mapping and legacy host name. Future provisioning changes
  must update CSV, Ansible, DNS, proxy, capacity, status, and incident records
  in the same merge request.
- Corrective automation:
  `cloud-infra-automation-platform/ansible/inventory/onprem.yml`,
  `cloud-infra-automation-platform/ansible/roles/bind_dns`, and
  `cloud-infra-automation-platform/ansible/roles/nginx_reverse_proxy`
- Evidence/related runbooks:
  [Canonical VM Inventory](vm-inventory.md),
  [Elastic Stack Installation](product-installation-elastic-stack.md), and
  [Splunk Enterprise Installation](product-installation-splunk.md)

## INC-2026-021: Concurrent Observability Updates Caused Rebase Conflicts

- Date: 2026-07-27
- Severity: SEV-4
- Status: Resolved
- Component: `enterprise-architecture-docs` and
  `cloud-infra-automation-platform` Git workflows
- Detection/symptom: GitLab rejected the reviewed documentation push as
  non-fast-forward because remote `main` had advanced to `e273121`. Rebasing
  produced content conflicts in the platform runbook, product catalog, and VM
  inventory. The infrastructure repository had also advanced to `1438f0e`;
  its rebase overlapped the Ansible inventory.
- Impact: Publication was delayed; forcing the push or selecting one side
  would have lost either the newly recorded native observability deployment or
  the Elastic/Splunk architecture reconciliation.
- Cause: Two documentation workflows updated overlapping architecture files
  from the same earlier `main`.
- Resolution: Fetched and rebased both repositories without force. Merged the remote exact
  installed versions, native-systemd deployment facts, automation repository
  instructions, and logging-VM build evidence with the new product runbooks,
  capacity controls, and migration history. Retained the remote Ansible service
  groups and added only the missing Kibana/Splunk NGINX routes.
- Validation: No conflict markers remain; document validation, local-link
  checks, XML validation, and cross-source inventory checks pass after the
  merge.
- Prevention/follow-up: Fetch/rebase immediately before broad documentation
  commits and keep `docs/current-environment-state.md` linked from the README.
  Never use force-push on protected `main`.
- Evidence/related runbooks:
  [Current Environment State](current-environment-state.md) and
  [Enterprise Branching Strategy](branching-strategy.md)

## INC-2026-022: Five Project Repositories Retained Previous Architecture

- Date: 2026-07-27
- Severity: SEV-4
- Status: Resolved
- Component: DevSecOps, infrastructure, Kubernetes GitOps, observability, and
  governance repositories
- Detection/symptom: The enterprise documentation was current, but the five
  implementation projects still contained direct management URLs, Compose as
  the canonical observability method, a legacy infra01 hostname, no on-prem
  Argo CD root, incomplete Elastic/Splunk assets, and an unused
  Keepalived/VRRP NGINX role and playbook.
- Impact: Staff following project-local instructions could rebuild the
  previous architecture or report incorrect product status. The dormant HA
  playbook could recreate an explicitly rejected proxy topology.
- Cause: Architecture decisions were updated centrally before every consuming
  repository was reconciled.
- Contributing factors: Project validators checked file presence but did not
  reject retired hostnames/topologies. Initial validation also exposed a
  macOS Python bytecode-cache permission failure and a `find` expression that
  treated empty deleted directories as HA artifacts. The governance evidence
  generator also required an authorized write outside the workspace sandbox
  when validation ran against the live checkout. A concurrent
  `observability-sre-platform` installation-guide commit then produced two
  rebase conflicts.
- Resolution: Updated all five projects, removed the obsolete HA proxy
  implementation, added validation guards, introduced the on-prem Argo CD
  application and telemetry routing contract, expanded governance assets, and
  corrected validation scripts to use a writable temporary Python cache and
  file-only obsolete-artifact search. Governance validation was rerun with the
  required scoped write authorization and produced zero findings. The
  observability rebase preserved its exact Ansible ownership/version facts and
  merged the new Elastic/Splunk routing and provisioned-only state without a
  force push.
- Validation: All five local validation suites pass. YAML/JSON parsing,
  shell syntax, stale-architecture scans, and Git diff checks also pass.
- Prevention/follow-up: Every enterprise architecture change must identify and
  update all consuming repositories in the same workflow. CI must reject
  `infra01.midhtech.local`, active HA proxy artifacts, direct AWX application
  URLs, and missing current topology assets.
- Evidence/related runbooks:
  [Component Architecture](component-architecture.md) and
  [Current Environment State](current-environment-state.md)

## INC-2026-023: NGINX Routes Did Not Reflect Live Product State

- Date: 2026-07-28
- Severity: SEV-4
- Status: Resolved
- Component: `nginx.example.com`, BIND DNS, and source-controlled NGINX roles
- Detection/symptom: Live validation found AWX listening on NodePort `32000`
  while NGINX targeted stale port `30080`. MinIO targeted inactive console port
  `9001`. Alertmanager, MinIO, Loki, Tempo, and OpenTelemetry were active but
  rejected the proxy through firewalld. Uninstalled products produced
  ambiguous 502 responses.
- Impact: Staff could not reliably use application URLs and could mistake
  proxy errors for installed-product failures.
- Cause: The proxy backend map was not reconciled after AWX, Kubernetes, and
  observability installation changes.
- Resolution: Updated the source-controlled backend map, added Headlamp DNS and
  routing, moved AWX to `32000` and MinIO to `9000`, and added source-restricted
  firewalld rules permitting only `192.168.1.114` to reach restricted HTTP
  backends. Uninstalled products now return an intentional 503 with
  `product-not-installed`.
- Validation: DNS and NGINX Ansible runs completed with zero failed and zero
  unreachable. AWX and Headlamp returned HTTP 200. Alertmanager, MinIO, Loki,
  and Tempo health paths returned HTTP 200. GitLab, Jenkins, Prometheus,
  Grafana, and Kibana returned their expected status or redirect.
- Prevention/follow-up: Treat backend address, port, product state, DNS, and
  firewall access as one change. Validate every catalog route after product or
  cluster changes. TLS remains a separate open platform task.
- Corrective automation:
  `cloud-infra-automation-platform/ansible/roles/nginx_reverse_proxy`,
  `cloud-infra-automation-platform/ansible/roles/nginx_backend_firewall`, and
  `cloud-infra-automation-platform/ansible/roles/bind_dns`
- Evidence/related runbook:
  [Standalone NGINX Reverse-Proxy Installation](product-installation-nginx.md)

## INC-2026-024: Rocky Linux Fleet Logs Were Not Reaching Elasticsearch

- Date: 2026-07-28
- Severity: SEV-3
- Status: Resolved
- Component: Rocky Linux VM fleet, Logstash ingestion, and Elasticsearch
- Detection/symptom: An authenticated read-only index audit found one
  `midhhealth-application_json-2026.07.28` index containing exactly three
  documents. Every document was an `elastic-stack-awx-verification` event and
  none contained a Rocky Linux source hostname.
- Impact: Initially, incident investigation could not rely on Elasticsearch
  for fleet coverage. Linux authentication and system logging is now available
  for all 31 VMs.
- Cause: Elastic Stack deployment validated the Logstash-to-Elasticsearch path,
  but no approved fleet log shipper was installed or enrolled.
- Resolution: Filebeat 9.4.2 was deployed through Ansible to all 31 Rocky Linux
  VMs. Senders classify `/var/log/secure` as
  `linux_auth` and `/var/log/messages` as `linux_system`, use a 1 GB disk queue,
  and verify the managed Logstash TLS certificate.
- Validation: The inventory verifier reported 31 expected hosts, 31 observed
  hosts, no missing hosts, and at least 10,000 recent events. All 31
  active-service and encrypted-output tests passed. Logstash reported 571,057
  input events, 571,057 output events, and zero queued events.
- Prevention/follow-up: Elastic deployment acceptance must distinguish
  pipeline verification from source enrollment and require an inventory-based
  host coverage check.
- Corrective automation: `ansible-observability` now contains the Filebeat
  role, `playbooks/deploy-fleet-logging.yml`, and
  `playbooks/verify-fleet-logging.yml`.
- Evidence/related runbook:
  [Elastic Stack Installation](product-installation-elastic-stack.md) and
  [Current Environment State](current-environment-state.md)

## INC-2026-025: First Filebeat Enrollment Imported Existing Log History

- Date: 2026-07-28
- Severity: SEV-4
- Status: Resolved
- Component: Filebeat filestream inputs, Logstash persistent queue, and
  Elasticsearch indexing
- Detection/symptom: The three-node canary created a large queue, and the
  30-node rollout produced substantially more events than a tail-only
  enrollment. `ignore_inactive: since_last_start` did not suppress history
  because Ansible and service startup continued updating the active files.
- Impact: Elasticsearch and Logstash processed an unplanned historical
  backfill. No service outage or data loss occurred.
- Timeline: Canary deployment exposed the queue; the canary queue was allowed
  to drain before fleet rollout; the full rollout then completed with 518,971
  Logstash input and output events and zero queued events.
- Cause: Filestream correctly treated actively modified `/var/log/messages`
  and `/var/log/secure` as current files and began at their existing offsets.
- Contributing factors: Deployment and systemd activity write to the same files
  being enrolled. `ignore_inactive` is based on file modification activity and
  is not a guaranteed tail-only control for active system logs.
- Resolution: Allowed the persistent queue to drain, confirmed equal Logstash
  input/output counts, zero queued events, green Elasticsearch health, and
  complete coverage for the 30 reachable senders.
- Validation: Logstash reported `events_in=518971`, `events_out=518971`, and
  `queue_events=0`; Elasticsearch returned recent documents for 30 hostnames.
- Prevention/follow-up: Treat first enrollment as a controlled backfill unless
  a separately tested registry-baseline procedure is approved. Monitor queue
  depth, disk watermarks, and index growth before adding each fleet batch.
- Corrective automation: The runbook now describes this behavior and retains
  the Filebeat disk queue plus Logstash persistent queue.
- Evidence/related runbook:
  [Elastic Stack Installation](product-installation-elastic-stack.md)

## INC-2026-026: Elasticsearch Verification SSH Session Disconnected

- Date: 2026-07-28
- Severity: SEV-4
- Status: Resolved
- Component: `elasticsearch01.example.com` SSH and the fleet verification
  playbook
- Detection/symptom: After all 30 Filebeat service/output tests passed, the
  verifier lost SSH while reading protected bootstrap material with `no_log`.
- Impact: The automated coverage play ended before its Elasticsearch
  aggregation. Filebeat, Logstash, and Elasticsearch data paths remained
  operational.
- Cause: Transient SSH transport disconnect during a long, high-concurrency
  verification run; no persistent host or service fault was found.
- Resolution: A direct retry connected immediately. Elasticsearch was active,
  cluster health was green with three nodes and 100% active shards, and the
  aggregation returned recent events for all 30 reachable inventory hosts.
- Validation: Subsequent SSH command succeeded; the Elasticsearch API returned
  green health; Logstash queue depth was zero.
- Prevention/follow-up: Keep protected-material output censored, enable bounded
  SSH retries for read-only verification tasks, and retain direct health and
  aggregation commands in the troubleshooting path.
- Corrective automation: Follow-up should add retry handling around bootstrap
  material reads without weakening secret handling.
- Evidence/related runbook:
  [Current Environment State](current-environment-state.md)

## INC-2026-027: AWX Authorized-Key Permissions Block Canonical Access

- Date: 2026-07-28
- Severity: SEV-3
- Status: Resolved
- Component: `awx.example.com`, `midhtechadmin` home directory, and QEMU Guest
  Agent SSH-key management
- Detection/symptom: Direct SSH rejects the canonical account. The live guest
  agent supports `guest-ssh-get-authorized-keys` and
  `guest-ssh-add-authorized-keys`, but both operations fail against
  `/home/midhtechadmin/.ssh/authorized_keys`: reading returns permission
  denied, and additive key repair reports that the inaccessible `.ssh`
  directory already exists. A read-only root-key check also returned permission
  denied. Libvirt confirms an active serial console for the VM.
- Impact: AWX could not be managed by the standard Ansible credential and was
  the only missing Filebeat sender.
- Cause: Ownership or mode drift on the account's `.ssh` path. Exact file
  metadata requires one privileged repair inside the guest.
- Resolution: Used the infra01 serial console to restore `.ssh` ownership,
  modes, and SELinux labels. The existing authorized key belonged to a
  different workstation, so the approved Mac lab public key was appended
  without removing the existing key.
- Validation: `ssh midhtechadmin@awx.example.com` succeeded with the standard
  key; Filebeat 9.4.2 deployed; the service/output checks passed; and the
  verifier reported 31 expected, 31 observed, and no missing hosts. AWX
  Prometheus job `321` later managed all 31 inventory hosts with zero failed or
  unreachable targets, proving execution-environment access as well as
  workstation access.
- Prevention/follow-up: Add authorized-key ownership/mode assertions to the
  common Rocky baseline and validate them before product installation.
- Corrective automation: After access is restored, encode the permission check
  in the baseline role rather than relying on manual key distribution.
- Evidence/related runbook:
  [Elastic Stack Installation](product-installation-elastic-stack.md)

## INC-2026-028: AWX Repair Commands Initially Ran on infra01

- Date: 2026-07-28
- Severity: SEV-4
- Status: Resolved
- Component: `infra01.example.com` administration shell and AWX recovery
  procedure
- Detection/symptom: The operator ran the `.ssh` ownership and mode commands
  while the prompt still showed `midhtechadmin@infra01`. `restorecon` then
  returned command not found because infra01 is Ubuntu, not the Rocky Linux AWX
  guest.
- Impact: The canonical account's existing `.ssh` ownership and modes were
  normalized on infra01. No VM, libvirt, or application configuration was
  changed.
- Cause: The recovery commands were executed before entering and logging in to
  `virsh console awx.example.com`.
- Resolution: Stop at the infra01 shell, do not install SELinux tools there,
  enter the AWX serial console, verify the prompt/hostname reports AWX, and only
  then run the repair commands.
- Validation: infra01 remained available and the commands targeted only
  `/home/midhtechadmin/.ssh` for the same account.
- Prevention/follow-up: Recovery runbooks must include an explicit
  `hostname --fqdn` target check immediately before privileged commands.
- Corrective automation: The AWX recovery procedure now separates hypervisor
  commands from guest commands and requires target verification.
- Evidence/related runbook:
  [Elastic Stack Installation](product-installation-elastic-stack.md)

## INC-2026-029: Stale virsh Client Held the AWX Console Lock

- Date: 2026-07-28
- Severity: SEV-4
- Status: Resolved
- Component: infra01 libvirt serial-console client for `awx.example.com`
- Detection/symptom: `virsh console awx.example.com` returned `Active console
  session exists for this domain`.
- Impact: The operator could not reach the AWX local login prompt to repair
  canonical SSH access. The AWX VM remained running.
- Cause: A stale `virsh --connect qemu:///system console awx.example.com`
  client process from 17:59 retained the exclusive console attachment.
- Resolution: Identified the exact viewer PID, attempted SIGTERM, then used
  SIGKILL only after confirming the process was the console viewer rather than
  QEMU. A new operator console attached successfully; AWX remained `running`.
- Validation: Libvirt reported the domain running and a new console client
  began at 18:04:58.
- Prevention/follow-up: Exit serial consoles with `Ctrl+]`. Before using
  `--force` or terminating a process, identify the exact client PID and confirm
  the domain state.
- Corrective automation: Keep console-lock diagnostics in the recovery
  runbook; never terminate the QEMU domain process to clear a viewer lock.
- Evidence/related runbook:
  [Elastic Stack Installation](product-installation-elastic-stack.md)

## INC-2026-030: Headlamp Application FQDN Missing from DNS

- Date: 2026-07-28
- Severity: SEV-4
- Status: Resolved
- Component: Authoritative lab DNS and
  `headlamp.apps.example.com`
- Detection/symptom: A normal client request failed with `Could not resolve
  host`. The same request forced to `192.168.1.114` with `curl --resolve`
  returned HTTP 200, and the authoritative zone did not contain a Headlamp
  record.
- Impact: Staff could not open Headlamp by its documented application URL.
  Kubernetes, Headlamp, its NodePort, and the NGINX route remain healthy.
- Cause: The Headlamp application A record was omitted from the managed BIND
  service-record inventory.
- Contributing factors: Proxy-route verification can pass independently of
  client and authoritative DNS validation.
- Resolution: Added `headlamp.apps.example.com` at `192.168.1.114`, advanced
  the zone serial to `2026072901`, added an authoritative lookup assertion to
  the BIND role, and deployed through AWX job 398.
- Validation: Authoritative BIND and the Mac split-DNS resolver returned
  `192.168.1.114`; normal HTTP access returned 200; a disposable Kubernetes
  pod resolved the name through CoreDNS `10.43.0.10`; and the pod was removed
  automatically. AWX idempotence job 402 completed with `ok=13`, `changed=0`,
  `unreachable=0`, and `failed=0`.
- Prevention/follow-up: Every NGINX application route acceptance test must
  include authoritative DNS, normal client DNS, and HTTP response checks.
- Corrective automation: Add Headlamp to the DNS inventory and the combined
  DNS/proxy verification workflow.
- Evidence/related runbook:
  [Standalone NGINX Reverse-Proxy Installation](product-installation-nginx.md)

## INC-2026-031: Prometheus Inventory Drift Reduced Host Coverage

- Date: 2026-07-28
- Severity: SEV-4
- Status: Resolved
- Component: AWX `production-inventory` source, Prometheus scrape
  configuration, and monitoring documentation
- Detection/symptom: Prometheus reported all 28 configured targets Up, but the
  node job contained only 27 hosts. The Kubernetes control plane and three
  workers were absent while documentation still reported 31 Node Exporters.
- Impact: Metrics-based dashboards and investigations had no data for four
  Kubernetes nodes. A green target page concealed incomplete inventory
  coverage.
- Cause: The successful AWX inventory source project remained at commit
  `5b97ec5`; GitLab `awx-inventory` had advanced to commit `94c8cf6` with the
  complete production inventory. Prometheus therefore rendered a scrape list
  from stale inventory.
- Contributing factors: Acceptance checked whether configured targets were Up
  but did not compare the target count and names with canonical inventory.
  Documentation retained a previously verified 32/32 result after live state
  regressed.
- Resolution: Launched `deploy-prometheus-stack` as AWX job `321`. Update-on-
  launch synchronized the Prometheus and inventory projects and regenerated
  the Prometheus configuration from all 31 hosts.
- Validation: Job `321` completed successfully with zero failed and zero
  unreachable hosts. All hosts passed the local Node Exporter endpoint check.
  Prometheus returned 32/32 targets Up: 31 Node Exporters plus its self-target.
  Grafana was active with the Prometheus data source, dashboard provider, and
  Server Fleet Overview dashboard provisioned.
- Prevention/follow-up: Monitoring acceptance must compare current inventory
  revision, expected hostnames, configured targets, and Up targets.
- Corrective automation: Add an inventory-to-Prometheus coverage assertion
  that fails unless expected and observed Node Exporter sets are identical.
- Evidence/related runbook:
  [Current Environment State](current-environment-state.md)

## INC-2026-032: Mac Ansible Validation Environment Was Not Buildable

- Date: 2026-07-29
- Severity: SEV-4
- Status: Resolved
- Component: Administration-workstation Python, Ansible Core, cryptography,
  OpenSSL, and `pkg-config`
- Detection/symptom: The default Mac Python could install only an older
  Ansible Core than the repository required. The bundled Python 3.12 path then
  failed while building `cryptography` because a compatible OpenSSL development
  environment was unavailable.
- Impact: Local syntax and lint validation could not run from the workstation.
  No managed host was changed by the failed setup.
- Cause: The workstation language/runtime and native crypto build dependencies
  did not match the repository's validation requirements.
- Resolution: Used the repository's GitLab CI and AWX execution environment
  instead of modifying the workstation toolchain.
- Validation: `ansible-prometheus` pipeline 300 passed lint and syntax checks;
  AWX job 356 successfully reconciled Grafana.
- Prevention/follow-up: Publish and use a pinned validation container or
  supported controller environment for every Ansible repository.
- Corrective automation: Keep controller validation in CI/AWX and treat local
  virtual environments as optional developer tooling.
- Recurrence: The same bundled Python 3.12 `cryptography` build failed while
  preparing local validation for ingress-nginx. No repository or cluster
  change depended on that attempt. A mandatory GitLab CI syntax/lint contract
  was added to `ansible-kubernetes` before deployment.
- Recurrence: The default Intel Mac Python again exposed only Ansible Core
  releases through 2.15 while `ansible-jenkins` requires 2.16 or newer.
  Installation stopped before syntax or lint execution. The change therefore
  relies on the repository's pinned GitLab CI gate and cannot advance to AWX
  until that gate passes.
- Evidence/related runbook:
  [Jenkins, AWX, and Ansible Operations](jenkins-awx-ansible-operations.md)

## INC-2026-033: Direct Workstation-to-VM SSH Was Intermittent

- Date: 2026-07-29
- Severity: SEV-4
- Status: Monitoring
- Component: Copper9100 workstation-to-lab-VM management path
- Detection/symptom: Direct SSH and ICMP from the Mac intermittently timed out
  to AWX, GitLab, infra01, infra02, and observability guests. During the same
  windows, the owning hypervisor could ping its guest with sub-millisecond
  latency.
- Impact: Operational inspection was delayed and some commands required
  retries or `ProxyJump` through the owning hypervisor. Services and guest
  east-west traffic continued to operate.
- Cause: Not yet isolated. Some occurrences affect only the workstation path;
  others make infra01 and all of its guests disappear from both the
  workstation and infra02 while infra01 itself remains powered on.
- Resolution: Used canonical direct SSH when available and hypervisor
  `ProxyJump` for deterministic guest access. No guest reboot was required.
- Validation: The same guests repeatedly accepted SSH through the hypervisor,
  and the deployment and acceptance jobs completed.
- Prevention/follow-up: Capture workstation ARP, route, Wi-Fi association,
  router client, and packet-loss evidence during the next occurrence.
- Recurrence: During CI repair publication, direct HTTP and SSH to GitLab
  timed out once while infra01 still reached GitLab ICMP and ports 22/80.
  The retry succeeded without a guest change. A later read-only check timed
  out to both GitLab and infra01 from the workstation, further supporting a
  workstation/Wi-Fi or router-path fault rather than a single guest failure.
  During Checkov remediation publication on 2026-07-29, the failure changed
  shape: the workstation reached the router and infra02, but not infra01 or
  GitLab. The workstation route to `.101` carried `REJECT`, its ARP entry was
  incomplete, and infra02 independently reported neighbor state `FAILED` for
  both infra01 `.38` and GitLab `.101`. This occurrence points to infra01
  being temporarily absent from the LAN rather than to a GitLab-only problem.
  A standard Wake-on-LAN packet sent from infra02 to infra01's documented
  bridge MAC produced no immediate response; infra02 continued to return
  `Destination Host Unreachable`. When the path recovered, infra01 reported
  almost four days of uninterrupted uptime. The host had not powered off or
  rebooted, confirming another management-network/bridge-path interruption.
  During ingress publication, two HTTP pushes stalled. The workstation again
  showed a rejected route and incomplete ARP for GitLab; infra02 independently
  showed `FAILED` neighbors for infra01 and GitLab, and had no IPv6 neighbor
  for infra01's documented bridge MAC. The ingress commit remained local and
  no AWX or Kubernetes deployment was started.
- Corrective automation: Add a management-path check that compares direct,
  hypervisor-to-guest, and proxied SSH before declaring a guest down.
- Evidence/related runbook:
  [Current Environment State](current-environment-state.md)

## INC-2026-034: AWX Jobs Were Blocked by Forced Execution-Image Pulls

- Date: 2026-07-29
- Severity: SEV-3
- Status: Resolved
- Component: AWX execution environments and `quay.io`
- Detection/symptom: AWX automation pods entered `ImagePullBackOff` with Quay
  DNS and HTTP timeouts. Inventory update 350 terminated in error before
  Ansible started.
- Impact: Inventory and deployment jobs could not launch despite the AWX
  execution image already being cached on the node.
- Cause: All AWX execution environments had an empty/default pull policy,
  causing jobs using mutable image tags to contact the external registry.
- Resolution: Set all three AWX execution environments to pull policy
  `missing`.
- Validation: Retried inventory update 353 completed successfully from the
  cached image; Grafana deployment job 356 and telemetry job 381 also launched
  successfully.
- Prevention/follow-up: Pin execution-image versions and use `missing` for the
  on-premises lab. Mirror required images into Harbor after Harbor is installed.
- Corrective automation: Export AWX execution-environment definitions and pull
  policies as controller configuration.
- Evidence/related runbook:
  [Jenkins, AWX, and Ansible Operations](jenkins-awx-ansible-operations.md)

## INC-2026-035: Node Exporter Reconciliation Required GitHub Egress

- Date: 2026-07-29
- Severity: SEV-3
- Status: Resolved
- Component: `ansible-prometheus` Node Exporter role
- Detection/symptom: AWX job 343 failed on `Download Node Exporter` for
  multiple hosts with DNS failures and timeouts even though Node Exporter
  1.11.1 was already installed.
- Impact: The play never reached Grafana, so Loki and Tempo data-source files
  were not provisioned.
- Cause: The role downloaded and extracted Node Exporter on every
  reconciliation instead of comparing the installed version first.
- Resolution: Commit `ea2e816` added an installed-version check and guarded
  download, extraction, and binary installation.
- Validation: GitLab pipeline 300 passed; AWX job 356 skipped redundant binary
  installation, provisioned the data sources, and verified Grafana.
- Prevention/follow-up: Reconciliation of an installed version must not depend
  on Internet availability.
- Corrective automation: Retain the version assertion and add a second-run
  idempotence test to CI.
- Evidence/related runbook:
  [Current Environment State](current-environment-state.md)

## INC-2026-036: Observability Host Firewalls Blocked the Telemetry Path

- Date: 2026-07-29
- Severity: SEV-3
- Status: Resolved
- Component: OpenTelemetry Collector, Tempo, Loki, and firewalld
- Detection/symptom: Smoke job 361 found `no route to host` from a Kubernetes
  pod to `otel.example.com:4317`. After that path was opened, collector logs
  showed the same error to `tempo.example.com:4317`; Tempo API and Loki API
  ports were also absent from managed firewall policy.
- Impact: Locally healthy services could not exchange telemetry or be queried
  by Grafana/AWX, so end-to-end logs and traces were unavailable.
- Cause: Installation roles verified only loopback health and did not manage
  consumer-facing data-plane ports.
- Resolution: `ansible-observability` commits `67ba728` and `9fbba58` manage
  OTLP 4317/4318, Tempo 3200, and Loki 3100 with source-restricted rules.
  Equivalent validated break-glass rules were applied while CI remained
  pending.
- Validation: Kubernetes connected to the collector; collector-to-Tempo,
  Tempo readiness/search, and Loki readiness succeeded. AWX job 381 completed
  the full trace/log correlation workflow.
- Prevention/follow-up: Acceptance must test from each real producer and
  consumer network, not from service loopback only.
- Corrective automation: Keep all observability data-plane firewall rules in
  the product roles and verify them from the Kubernetes control plane.
- Evidence/related runbook:
  [Current Environment State](current-environment-state.md)

## INC-2026-037: BIND Rejected Kubernetes Pod-Network Queries

- Date: 2026-07-29
- Severity: SEV-3
- Status: Resolved
- Component: `dns.example.com` BIND query and recursion ACL
- Detection/symptom: BIND allowed only `localhost` and `192.168.1.0/24`; the
  Kubernetes pod CIDR `10.244.0.0/16` was absent.
- Impact: CoreDNS upstream queries originating from pods could be refused,
  preventing workloads from resolving on-premises service names.
- Cause: DNS installation predated the Kubernetes pod-network integration.
- Resolution: Commit `3681bb3` changed the BIND role to manage a list of
  authorized networks containing the lab LAN and pod CIDR. The live
  configuration was backed up, validated with `named-checkconf`, and reloaded.
- Validation: A pod on worker02 resolved `otel.example.com` directly through
  `192.168.1.106` to `192.168.1.131`.
- Prevention/follow-up: Review DNS ACLs whenever CNI or service-network CIDRs
  change.
- Corrective automation: `bind_dns_allowed_networks` is the source of truth for
  recursive-query clients.
- Evidence/related runbook:
  [DNS Installation](product-installation-dns.md)

## INC-2026-038: CoreDNS Randomly Used the Router for Private Names

- Date: 2026-07-29
- Severity: SEV-3
- Status: Resolved
- Component: Kubernetes CoreDNS upstream selection
- Detection/symptom: CoreDNS forwarded all external names through
  `/etc/resolv.conf`, which contained both `192.168.1.106` and the router
  `192.168.1.1`. The router returned empty or negative answers for private
  `example.com` records. Telemetry jobs 366, 371, and 376 therefore failed at
  different stages even after individual firewall paths were repaired.
- Impact: Pod service-name resolution was nondeterministic and telemetry
  exporters could lose their bounded payload before DNS recovered.
- Cause: The private zone had no dedicated CoreDNS forwarding block.
- Resolution: Commit `cc466bc` added an Ansible-managed `example.com` server
  block forwarding only to `192.168.1.106`; other names retain the normal
  upstream path. CoreDNS was rolled out cleanly.
- Validation: Three consecutive lookups of `otel.example.com` returned
  `192.168.1.131` from pods pinned to worker01, worker02, and worker03.
  Acceptance job 381 then succeeded.
- Prevention/follow-up: Every private DNS zone must have an explicit
  authoritative forwarder in CoreDNS.
- Corrective automation: The Kubernetes `coredns` role manages the private
  zone and authoritative server.
- Evidence/related runbook:
  [Current Environment State](current-environment-state.md)

## INC-2026-039: GitLab Runner Stopped Claiming Pending Jobs

- Date: 2026-07-29
- Severity: SEV-4
- Status: Resolved
- Component: GitLab Runner 19.2 Docker executor
- Detection/symptom: The runner container was active, its registration
  verified successfully, and `ci_running_builds` was empty, but pending jobs
  in projects 2 and 15 were not assigned. GitLab logged successful
  `/api/v4/jobs/request` polling followed by HTTP 204 responses.
- Impact: New infrastructure and observability validation pipelines remained
  pending or were canceled by superseding commits. Live fixes were verified
  through AWX and direct acceptance while GitLab CI evidence was delayed.
- Cause: The only runner was `project_type` and mapped through
  `ci_runner_projects` only to projects 9 and 10. It was therefore healthy but
  ineligible for projects 2 and 15. The earlier description of the runner as
  enabled for instance jobs was incorrect: `run_untagged=true` controls tag
  matching but does not override project scope.
- Resolution: Removed the two obsolete project associations and converted the
  runner to `instance_type`. GitLab stores runner types in partitions, so the
  conversion moved the record from runner ID 1 to ID 2 while preserving the
  valid authentication token. The runner container was restarted to refresh
  scope. `/srv/gitlab-runner/config/config.toml` was then tuned to
  `concurrent=2` and `request_concurrency=2`; the pre-change copy is
  `/srv/gitlab-runner/config/config.toml.pre-instance-scope-20260729`.
- Validation: `gitlab-runner verify` passed. Runner ID 2 concurrently claimed
  job 497 from project 2 and job 511 from project 15. Pipeline 307 left the
  pending state and both its validation jobs were assigned. Job 498 from
  project 2 completed successfully. Fresh enterprise-documentation pipeline
  310 for commit `aac120f` was assigned to runner ID 2 and completed
  successfully. Other claimed jobs that ended with script failures prove
  scheduling worked and are repository CI defects, not a recurrence of this
  incident.
- Prevention/follow-up: Manage runner scope and concurrency as code. Alert on
  pending jobs with no eligible runner, but confirm `runner_type`,
  `ci_runner_projects`, tags, protected-ref policy, and the coordinator HTTP
  response before restarting a healthy runner.
- Corrective automation: Manage runner configuration, health checks, and queue
  diagnostics through the GitLab installation repository.
- Evidence/related runbook:
  [Jenkins, AWX, and Ansible Operations](jenkins-awx-ansible-operations.md)

## INC-2026-040: GitLab CI Validation Runtimes Were Incomplete

- Date: 2026-07-29
- Severity: SEV-4
- Status: Resolved
- Component: `cloud-infra-automation-platform`,
  `ansible-observability`, and GitLab Runner Docker executor
- Detection/symptom: After INC-2026-039 restored job assignment, cloud
  Terraform jobs 495 and 496 exited 127 because the runner fallback
  `python:3.13-slim` image did not contain Terraform. Cloud main pipeline 305
  failed before creating builds because included CI files declared
  incompatible stage graphs. Observability syntax job 511 could not find the
  checked-in `blackbox_exporter` role because Ansible ignored configuration
  discovery in GitLab's world-writable build directory.
- Impact: CI could not provide reliable Terraform, Ansible, or observability
  validation despite the live platform acceptance tests succeeding.
- Cause: The repositories depended on runner-global defaults and implicit
  Ansible configuration discovery instead of declaring complete job runtimes.
- Resolution: Added one canonical cloud pipeline stage graph, pinned Terraform
  1.13.5, Ansible Core 2.21.2, ansible-lint 26.6.0, and project-specific
  images. Added explicit environment defaults, `ANSIBLE_CONFIG`,
  `ANSIBLE_ROLES_PATH`, and the `community.docker` collection dependency.
  Cloud Ansible validation uses the minimum structural/syntax profile while
  the pre-existing style backlog is remediated separately.
- Validation: Cloud pipeline 317 passed Terraform format, provider validation,
  local validation, layout validation, and Ansible lint jobs 569 through 573.
  Observability pipeline 315 passed syntax job 554 and lint job 555.
- Prevention/follow-up: Every CI job must declare its tool image,
  dependencies, stage, and repository paths. Runner defaults are fallback
  safety only and are not a project runtime contract.
- Corrective automation: Maintain pinned CI requirements and collection files
  in each repository and validate the complete merged GitLab configuration.
- Evidence/related runbook:
  [Jenkins, AWX, and Ansible Operations](jenkins-awx-ansible-operations.md)

## INC-2026-041: Checkov Found Blocking Legacy Terraform Gaps

- Date: 2026-07-29
- Severity: SEV-3
- Status: Resolved
- Component: `cloud-infra-automation-platform` Terraform modules and Checkov
- Detection/symptom: The first executable Checkov job, pipeline 317 job 574,
  passed 77 controls and failed 14. Findings cover container image
  immutability and pull policy, IAM resource scope, security-group egress and
  attachment, VPC flow/default-group controls, and S3 notifications,
  replication, lifecycle, access logging, and KMS encryption.
- Impact: The legacy LocalStack/Kind Terraform examples are not approved as
  production-ready cloud modules, and their security stage remains blocking.
  This does not affect the accepted on-premises libvirt architecture.
- Cause: The examples predate the executable policy gate and implement only a
  development smoke-test subset of enterprise AWS controls.
- Resolution: Remediation is implemented without policy skips. The workload
  image is digest-pinned; IAM and security-group scope is restricted; VPC flow
  logs and default-group lockdown are present; and S3 now includes KMS
  encryption, notifications, versioning, lifecycle, access logging, and
  replication. Access logging and disaster recovery intentionally require
  external log-bucket, replica-bucket, and replica-key inputs so the module
  does not model unsafe self-logging or fake same-bucket replication.
  Terraform plan and environment smoke jobs remain manual so push pipelines
  cannot contact or mutate operator-started environments.
- Remediation evidence: Pipeline 327 job 672 passed 153 controls and reported
  only two missing explicit KMS key policies. After adding those policies,
  pipeline 329 job 696 passed 171 controls; six generic IAM findings remained
  because Checkov classified the required KMS root-administration statements
  as standalone IAM policies. The equivalent policies are now attached
  directly to the KMS keys.
- Validation: Cloud pipeline 332 passed Terraform format, both Terraform
  validations, layout validation, and Ansible lint. Checkov job 730 passed
  155 controls with zero failed and zero skipped checks. Plan, apply,
  bootstrap, and smoke jobs remain manual by design and were not run against
  an operator-started cloud test environment.
- Prevention/follow-up: Introduce policy scanning when a module is created,
  not after the module portfolio is assembled.
- Corrective automation: Keep the Checkov image pinned and retain blocking
  enforcement for every policy ID.
- Evidence/related runbook:
  [Product Version Catalog](product-versions.md)

## INC-2026-042: Forced CI Image Pulls Failed During Router-DNS Outage

- Date: 2026-07-29
- Severity: SEV-4
- Status: Resolved
- Component: GitLab Runner Docker executor, Docker Hub, and router DNS
- Detection/symptom: Cloud pipeline 318 jobs 579 and 580 failed while
  resolving `registry-1.docker.io` through `192.168.1.1`. Terraform 1.13.5
  was already cached, but the runner's `always` policy still performed a
  registry manifest request. The first project-side `if-not-present` attempt
  in pipeline 321 was rejected because the runner allowed only `always`.
- Impact: Deterministic validation jobs failed because an external registry
  lookup was unavailable, even though the required pinned tool image existed
  locally.
- Cause: Project image policy and the runner's
  `allowed_pull_policies` were inconsistent; the runner had no cached-first
  option.
- Resolution: Backed up runner configuration to
  `/srv/gitlab-runner/config/config.toml.pre-pull-policy-20260729`, set the
  default Docker pull policy to `if-not-present`, and allowed both
  `always` and `if-not-present`. Project images explicitly use
  `if-not-present`. The runner token verified and configuration hot reload
  completed.
- Validation: Post-reload cloud pipeline 322 used runner ID 2 and passed
  cached-image Terraform format job 614 and provider-validation job 615.
  INC-2026-041 subsequently resolved with a zero-failure Checkov result.
- Prevention/follow-up: Mirror CI images into Harbor when available and pin
  images by digest. Test runner policy compatibility before adding a
  project-level pull policy.
- Corrective automation: Manage runner Docker pull policy and allowed-policy
  lists as code in the GitLab installation repository.
- Evidence/related runbook:
  [Jenkins, AWX, and Ansible Operations](jenkins-awx-ansible-operations.md)

## INC-2026-043: AWX Deploy Key Was Not Enabled for Cloud Repository

- Date: 2026-07-29
- Severity: SEV-4
- Status: Resolved
- Component: AWX project 23, GitLab cloud project, and AWX SCM deploy key
- Detection/symptom: Initial AWX cloud project update 389 loaded the
  `awx-gitlab-scm` identity and trusted `gitlab.example.com:2222`, but GitLab
  returned that the project could not be found or accessed.
- Impact: AWX could not synchronize the validated DNS playbook, so no live
  DNS change was attempted.
- Cause: The existing read-only AWX deploy key was enabled for other Ansible
  repositories but was not associated with
  `cloud-infra-automation-platform`.
- Resolution: Enabled the existing `AWX SCM read-only` deploy key for only the
  cloud project with `can_push=false`. No new private key was created.
- Validation: AWX project update 390 synchronized successfully from the
  canonical SSH URL.
- Prevention/follow-up: Treat deploy-key assignment as part of onboarding
  every AWX-managed GitLab repository and retain read-only scope unless a
  separately approved workflow requires writes.
- Corrective automation: Reconcile AWX project definitions and GitLab
  read-only deploy-key assignments from controller configuration as code.
- Evidence/related runbook:
  [Jenkins, AWX, and Ansible Operations](jenkins-awx-ansible-operations.md)

## INC-2026-044: AWX Could Not Discover Repository-Local DNS Role

- Date: 2026-07-29
- Severity: SEV-4
- Status: Resolved
- Component: `cloud-infra-automation-platform` AWX runtime contract
- Detection/symptom: DNS deployment job 394 stopped before connecting to the
  target because `bind_dns` was not found in AWX's default role search paths.
- Impact: The managed DNS record was not deployed; the existing BIND service
  and zone remained unchanged.
- Cause: The repository's only `ansible.cfg` was inside `ansible/`. AWX runs
  from the project root, so it did not load that configuration or discover
  `ansible/roles`.
- Resolution: Added a root `ansible.cfg` with
  `roles_path = ansible/roles` and the corresponding inventory path. GitLab
  pipeline 337 passed format, Terraform, layout, Ansible lint, and Checkov
  gates before the retry.
- Validation: AWX DNS job 398 completed successfully. The second convergence,
  job 402, reported `changed=0`, `unreachable=0`, and `failed=0`.
- Prevention/follow-up: Every AWX project with a nested Ansible tree must
  expose controller configuration from the repository root or declare an
  equivalent supported execution-environment setting.
- Corrective automation: Validate AWX role discovery as part of repository
  onboarding, not only Ansible syntax in CI.
- Evidence/related runbook:
  [Jenkins, AWX, and Ansible Operations](jenkins-awx-ansible-operations.md)

## INC-2026-045: DNS Acceptance Initially Used the Wrong Kubernetes Context

- Date: 2026-07-29
- Severity: SEV-4
- Status: Resolved
- Component: AWX platform k3s cluster and four-node kubeadm application cluster
- Detection/symptom: The first disposable DNS-check pod was launched with
  `/usr/local/bin/kubectl` on `awx.example.com`. That context reported a
  single AWX node running k3s `1.36.2`, not the documented four-node
  application cluster.
- Impact: The result proved private-zone forwarding for the AWX platform
  cluster but was initially attributed too broadly to Kubernetes acceptance.
  The DNS record, BIND deployment, and HTTP result were unaffected.
- Cause: Two independent Kubernetes control planes exist in the environment,
  and the verification command did not identify its expected context and node
  count before creating the disposable pod.
- Resolution: Inspected both clusters explicitly, then reran the automatically
  removed DNS-check pod from `k8s-control.example.com` with
  `/etc/kubernetes/admin.conf`.
- Validation: The intended kubeadm `1.34.10` cluster reported one control
  plane and three workers Ready. Its CoreDNS service at `10.96.0.10` resolved
  `headlamp.apps.example.com` to `192.168.1.114`; the pod was deleted.
- Prevention/follow-up: Every Kubernetes acceptance command must record the
  API server version, context, expected node set, and kubeconfig before using
  its result as evidence.
- Corrective automation: Add cluster identity assertions to Kubernetes
  verification playbooks and document AWX k3s as a separate platform cluster.
- Evidence/related runbook:
  [Current Environment State](current-environment-state.md)

## INC-2026-046: Bridge STP Delayed Guest Networking During Host Reboot

- Date: 2026-07-29
- Severity: SEV-2
- Status: Monitoring
- Component: `infra01.example.com`, NetworkManager bridge `lab-br0`, libvirt
  autostart guests, and guest network initialization
- Detection/symptom: After infra01 completed a full host reboot, all 17
  autostart domains were running but only `nginx.example.com` had its expected
  IPv4 address. QEMU guest-agent evidence showed the other 16 guests had an
  Ethernet interface but no IPv4 address or IPv4 route.
- Impact: GitLab, Jenkins, AWX, authoritative DNS, the application Kubernetes
  control plane, and the remaining infra01-hosted services were unavailable.
  Product deployment and every queued infrastructure change remain frozen.
- Timeline: Infra01 booted at approximately 15:35 UTC. The first VM tap entered
  bridge listening state at 15:38:46 and forwarding at 15:39:17. Additional
  taps entered listening through 15:39:19 and did not finish forwarding until
  15:39:50. NGINX, whose tap was first, was the only guest to recover IPv4.
- Cause: Evidence supports a startup race: `lab-br0` had STP enabled with a
  15-second forward delay, while all 17 guests autostarted together. Most
  guests initialized their static network while their tap was not yet
  forwarding and did not retry successfully. Recovery of a canary and the
  fleet is still required to confirm this causal assessment.
- Contributing factors: The bridge has only one physical uplink and VM tap
  ports, but the managed build script explicitly enabled STP. Simultaneous
  libvirt autostart amplified the race across the control plane.
- Resolution: Disabled STP at runtime and persistently on infra01 without
  cycling the management bridge. The remaining guests subsequently reported
  their expected addresses without additional reboots. Rebooted only
  `backup.example.com` as the controlled canary.
- Validation: The canary regained `192.168.1.113/24`, its default route via
  `192.168.1.1`, a connected `192.168.1.0/24` route, and stable 3/3
  reachability after its guest agent completed startup. All 17 infra01 guests
  then reported their expected IPv4 addresses through the QEMU guest agent.
  The incident remains Monitoring until a future controlled infra01 reboot
  validates fleet-wide startup with STP disabled.
- Prevention/follow-up: Keep STP disabled on the single-uplink lab bridges and
  evaluate ordered or delayed domain autostart for control-plane dependencies.
  Reboot acceptance must confirm every expected guest address and service.
- Corrective automation: The physical bridge script now creates `lab-br0`
  with `bridge.stp no`. Apply the live correction sequentially to each
  hypervisor and publish the source after GitLab recovery.
- Evidence/related runbook:
  [Sequential Build and Change Control](sequential-build-change-control.md)

## INC-2026-047: GitLab Did Not Become Healthy After Guest Network Recovery

- Date: 2026-07-29
- Severity: SEV-2
- Status: Resolved
- Component: `gitlab.example.com` Docker-based GitLab 19.2.0 runtime
- Detection/symptom: The VM recovered `192.168.1.101/24`, Docker was active,
  and ports 80 and 2222 were listening, but local GitLab health/readiness
  requests reset and remote HTTP refused the connection. Eight additional
  health checks over two minutes returned no HTTP status.
- Impact: GitLab repositories, pipelines, job inventory, and publication of
  pending source-of-truth commits remain unavailable. The sequential build
  queue cannot advance.
- Timeline: The GitLab VM had been up approximately nine minutes when the
  audit began. Visible container processes showed `gitlab-ctl upgrade-check`
  for version 19.2.0, but the service did not become healthy during the
  bounded observation window.
- Cause: GitLab's containerized services required an extended startup period
  after the host and VM reboot. During that interval the published ports were
  present before the application was ready to accept requests.
- Contributing factors: NGINX returns its route catalog with HTTP 200 when the
  GitLab upstream is unavailable; that response must not be mistaken for
  GitLab health.
- Resolution: Allowed startup to complete without restarting the container or
  changing configuration.
- Validation: The backend root returned the expected redirect to
  `/users/sign_in`; `gitlab.apps.example.com` returned the same GitLab sign-in
  redirect through NGINX; and no Terraform, Ansible, kubectl, Packer, or
  GitLab Runner helper workload was visible on the VM. The NGINX catalog uses
  `gitlab.apps.example.com`; `gitlab.example.com` remains the backend VM name.
- Prevention/follow-up: Add an explicit upstream-failure status to the NGINX
  route catalog and include post-reboot GitLab container health in foundation
  acceptance.
- Corrective automation: Add a bounded GitLab application-readiness wait to
  post-reboot acceptance and distinguish listening ports from application
  readiness.
- Evidence/related runbook:
  [Sequential Build and Change Control](sequential-build-change-control.md)

## INC-2026-048: Vault Remained Sealed After Reboot

- Date: 2026-07-29
- Severity: SEV-3
- Status: Resolved
- Component: `vault.example.com`, Vault Community 2.0.3
- Detection/symptom: The native Vault service and TCP 8200 listener were
  active after the VM reboot, but the HTTPS health response reported
  `initialized=true`, `sealed=true`, `standby=true`, and HTTP 503.
- Impact: Vault UI/API and dependent secret workflows were unavailable.
  NGINX listed `vault.apps.example.com` as unavailable until the controlled
  recovery and proxy acceptance completed.
- Cause: The single-node Community deployment uses Shamir unseal keys and has
  no accepted automatic-unseal design. A service restart therefore returns
  Vault to the sealed state.
- Contributing factors: The older installation source keeps initialization
  material in a root-only local recovery file. That is usable for this lab
  recovery but does not meet the final enterprise custody design.
- Resolution: The operator submitted the three-key threshold locally without
  printing or copying key values. Vault returned to active service, and the
  reviewed NGINX role published its HTTPS upstream with the pinned backend
  certificate.
- Validation: Direct and proxied health reported `initialized=true`,
  `sealed=false`, `standby=false`, and HTTP 200. AWX jobs 417 and 421 applied
  and reconverged the NGINX route; job 421 reported `changed=0`,
  `unreachable=0`, and `failed=0`.
- Prevention/follow-up: Create a separate approved recovery-key custody
  procedure and evaluate an enterprise-appropriate auto-unseal design. Never
  commit, log, paste, or display initialization material.
- Corrective automation: Replace the uncommitted installer artifact with
  reviewed, idempotent automation that separates installation, initialization,
  unseal recovery, and secret-engine configuration.
- Evidence/related runbook:
  [Sequential Build and Change Control](sequential-build-change-control.md)

## INC-2026-049: Overlapping AWX Inventories Doubled Host Records

- Date: 2026-07-29
- Severity: SEV-4
- Status: Resolved
- Component: AWX inventories `production`, `cloud-infra-production`,
  `kubernetes-production`, and `Demo Inventory`
- Detection/symptom: The global AWX Hosts view reports 70 items even though
  the environment does not contain 70 distinct managed machines.
- Impact: Operators can misread inventory records as physical/virtual host
  count. Redundant broad inventories also increase variable-drift and
  wrong-inventory selection risk. A job targets one inventory, so duplicate
  records do not by themselves execute a play twice.
- Cause: AWX host objects are inventory-scoped, not globally deduplicated.
  `production` contained 31 records; `cloud-infra-production` contained those
  same 31 plus `infra01`, `infra02`, and `infra03`; and
  `kubernetes-production` contained four Kubernetes nodes already present in
  both broad inventories. The broad cloud inventory was created during
  project-specific DNS onboarding without an ownership boundary.
- Dependency evidence: `production` is synchronized by inventory source 10
  from project 9, `awx-inventory`, and is used by five Prometheus,
  Elasticsearch, and telemetry job templates. `cloud-infra-production` is
  synchronized by inventory source 24 from project 23,
  `cloud-infra-automation-platform`, and is currently used only by job
  templates 25 and 26, `deploy-lab-dns` and
  `deploy-nginx-reverse-proxy`, before normalization. `Demo Inventory`
  currently has zero hosts but remains attached to the built-in Demo Job
  Template, so it was retained as an isolated sample.
- Validation: Direct authenticated AWX API counts are 31 + 34 + 4 + 1 = 70.
  All 31 `production` names exist in `cloud-infra-production`; all four
  Kubernetes names also exist there. The resulting distinct-name count is 35.
- Resolution: Commit `8f259d0` added
  `ansible/inventory/foundation.yml` with only infra01, infra02, and infra03;
  GitLab pipeline 346 passed. AWX templates 25 and 26 were moved to the
  canonical `production` inventory. Source 24 now imports the foundation file
  with overwrite enabled; sync job 425 succeeded and reduced
  `cloud-infra-production` to three records. `kubernetes-production` remains
  the intentional four-node cluster RBAC boundary.
- Post-resolution validation: AWX now has 38 host records: 31 product records,
  three foundation records, four Kubernetes records, and zero Demo records.
  There are 34 distinct names, with only the intentional four Kubernetes-node
  overlap. DNS jobs 433 and 438 and NGINX jobs 443 and 448 each targeted one
  host and completed with `changed=0`, `unreachable=0`, and `failed=0`.
- Prevention/follow-up: Keep product VMs in `production`, physical KVM hosts
  in `cloud-infra-production`, and cluster-scoped automation in
  `kubernetes-production`. Retain Demo only while its built-in job template is
  intentionally kept; do not count it as managed infrastructure.
- Corrective automation: Reconcile AWX controller objects as code and add a
  check that reports total records, unique names, cross-inventory overlap, and
  orphaned inventory sources.
- Evidence/related runbook:
  [Jenkins, AWX, and Ansible Operations](jenkins-awx-ansible-operations.md)

## INC-2026-050: NGINX Role Assumed Firewalld Was Running

- Date: 2026-07-29
- Severity: SEV-4
- Status: Resolved
- Component: `nginx.example.com`, AWX job template 26, job 407
- Detection/symptom: The first controlled NGINX convergence failed while
  querying the permanent `http` and `https` services. `firewall-cmd` returned
  RC 252 and `FirewallD is not running`.
- Impact: The role stopped after installing the Vault trust certificate and
  rendering the managed NGINX configuration. It did not reach the handler
  flush, service-health validation, or version-lock task. The existing NGINX
  process continued serving its prior loaded configuration.
- Cause: The role assumed that an installed `firewall-cmd` client meant the
  firewalld daemon was active.
- Contributing factors: The standalone proxy already had firewalld stopped,
  the role did not inspect runtime state before querying permanent rules, and
  its NGINX reload handler was deferred until after firewall work. The failed
  run wrote the configuration but did not reload NGINX; job 412 then reported
  `changed=0` because the files already matched, leaving the older in-memory
  configuration active.
- Resolution: The role detects `firewall-cmd --state`, manages
  HTTP/HTTPS rules only when the daemon is active, and flushes the NGINX
  handler immediately after configuration validation. It does not silently
  start a host firewall as part of an application-route change.
- Validation: GitLab pipelines 343 and 344 passed. AWX project update 416
  synchronized revision `bc8481a`; job 417 loaded the route; proxied Vault
  health returned HTTP 200; and job 421 completed with `changed=0`,
  `unreachable=0`, and `failed=0`.
- Prevention/follow-up: Treat firewall lifecycle as a separately approved
  baseline control. Application roles may reconcile rules when the service is
  active but must not change the firewall lifecycle without an explicit
  host-baseline change.
- Corrective automation: Retain the runtime-state guard and add active and
  inactive firewalld scenarios to role validation.
- Evidence/related runbook:
  [Sequential Build and Change Control](sequential-build-change-control.md)

## INC-2026-051: Successful AWX Job Skipped Every DNS Host

- Date: 2026-07-29
- Severity: SEV-4
- Status: Resolved
- Component: AWX job template 25, `production` inventory, and
  `awx-inventory`
- Detection/symptom: DNS validation job 428 displayed `Successful`, but its
  output warned that `dns_servers` did not match any host and the play was
  skipped.
- Impact: No DNS configuration or validation ran. Accepting controller status
  alone would have produced false deployment evidence.
- Cause: The template was correctly moved to the canonical `production`
  inventory, but that inventory defined the product host without the
  `dns_servers` role group required by
  `ansible/playbooks/dns.yml`. `nginx_reverse_proxy` was missing for the same
  reason.
- Resolution: `awx-inventory` commit `2c8ccfe` added the two one-host product
  groups and a CI guard. GitLab pipeline 347 passed, and the local Git remote
  was corrected from the redirected `cloud-team` path to
  `midhhealth/platform-engineering/awx-inventory`.
- Validation: AWX synchronized the updated inventory. DNS jobs 433 and 438
  each processed `dns.example.com` and reported `ok=13`, `changed=0`,
  `unreachable=0`, `failed=0`, and `skipped=2`. NGINX jobs 443 and 448
  processed `nginx.example.com` and reported zero changes and zero failures.
- Prevention/follow-up: Acceptance must require a nonzero expected host count
  and play recap, not only a green AWX status. Inventory CI must verify every
  product group referenced by a controlled playbook.
- Corrective automation: Retain
  `awx-inventory/scripts/validate-inventory.sh` and extend it whenever a
  playbook introduces another required production group.
- Evidence/related runbook:
  [Jenkins, AWX, and Ansible Operations](jenkins-awx-ansible-operations.md)

## INC-2026-052: AWX Edit Route Reused Stale Template Form State

- Date: 2026-07-29
- Severity: SEV-4
- Status: Resolved near miss
- Component: AWX 24.6.1 web UI template editor
- Detection/symptom: Direct single-page navigation from template 25 edit to
  template 26 edit showed the NGINX breadcrumb but retained the DNS template
  name and DNS playbook in the form.
- Impact: Saving the stale form could have overwritten the NGINX template
  with DNS settings. No incorrect save occurred.
- Cause: The browser route changed while the existing React form state was
  retained instead of being reloaded for the new template ID.
- Resolution: The edit was stopped before submission. Template 26 was opened
  in a fresh tab, where its name, NGINX playbook, fixed host limit, and current
  inventory were independently verified before saving.
- Validation: Template 26 details remained
  `deploy-nginx-reverse-proxy`, playbook
  `ansible/playbooks/nginx-reverse-proxy.yml`, limit
  `nginx.example.com`, and inventory `production`. Jobs 443 and 448 succeeded
  with zero changes and zero failures.
- Prevention/follow-up: Open a fresh AWX page for each template edit and
  verify breadcrumb, form name, playbook, inventory, and limit immediately
  before Save. Never trust the route alone after direct SPA navigation.
- Corrective automation: Manage AWX controller objects as code so routine
  reconciliation does not depend on sequential browser form state.
- Evidence/related runbook:
  [Jenkins, AWX, and Ansible Operations](jenkins-awx-ansible-operations.md)

## INC-2026-053: Kubernetes Deployment Boundary Was About to Be Bypassed

- Date: 2026-07-29
- Severity: SEV-4
- Status: Resolved near miss
- Component: GitLab CI, Jenkins, AWX, Ansible, Helm, and ingress-nginx
- Detection/symptom: The proposed ingress execution path would have launched
  AWX directly and the existing Ansible role applied the upstream
  ingress-nginx manifest with `kubectl`.
- Impact: No ingress resources were deployed. Had the plan continued, Jenkins
  would not have owned approval, deployment evidence, promotion, or rollback,
  and Helm release history would not have existed.
- Timeline: The gap was detected during pre-deployment review after the
  Kubernetes cluster audit and before an active deployment job was launched.
- Cause: The cluster-bootstrap playbook had accumulated application-tier
  responsibilities, and the Jenkins job delegated both infrastructure and
  application deployment to AWX.
- Contributing factors: `jenkins-agent01` was provisioned but not configured;
  the existing Jenkins pipeline used `agent any`; and the ingress automation
  predated the explicit platform boundary.
- Resolution: CHG-2026-002 makes GitLab CI the source validation gate, Jenkins
  the deployment orchestrator, Helm the Kubernetes release manager, and
  AWX/Ansible the host and cluster prerequisite manager. The dedicated Jenkins
  agent must be accepted before ingress deployment starts.
- Validation: No `IngressClass`, ingress resource, or ingress controller was
  present when the correction was made. Final validation will be appended
  after the Jenkins agent and Helm deployment pipeline are accepted.
- Prevention/follow-up: Kubernetes product changes must include a Helm chart
  or pinned upstream chart, a Jenkins plan/deploy/rollback contract, and an
  explicit kubeconfig credential. Ansible roles must not run Helm or apply
  application manifests.
- Corrective automation: CI will reject the retired ingress Ansible role and
  validate the Helm chart. The Jenkins job will require a dedicated agent
  label and an explicit deployment confirmation.
- Evidence/related runbook:
  [Sequential Build and Change Control](sequential-build-change-control.md)

## INC-2026-054: Ingress Prerequisite Role Failed Variable-Prefix Lint

- Date: 2026-07-29
- Severity: SEV-4
- Status: Resolved
- Component: `ansible-kubernetes` GitLab pipeline 350, lint job 849
- Detection/symptom: Ansible lint rejected four registered variables in
  `kubernetes_ingress_prerequisites` because their names did not contain the
  complete role prefix.
- Impact: Source validation stopped before any Jenkins, AWX, Helm, or
  Kubernetes runtime change. Syntax validation passed.
- Cause: The variables used the shorter `kubernetes_ingress_` prefix while
  the role is named `kubernetes_ingress_prerequisites`.
- Resolution: Renamed all four registered variables to the complete
  `kubernetes_ingress_prerequisites_` prefix and updated their references.
- Validation: Corrective pipeline 354 passed syntax, lint, deployment-boundary,
  and Helm validation for commit `e34bd54`.
- Prevention/follow-up: Keep Ansible lint blocking and run the same pinned CI
  toolchain before deployment. Never retry a deterministic lint failure
  without a corrective commit.
- Corrective automation: The GitLab lint job remains a required source gate.
- Evidence/related runbook:
  [Kubernetes Helm Delivery](kubernetes-helm-delivery-runbook.md)

## INC-2026-055: Jenkins Controller Pipeline Had Automatic Main Deployment

- Date: 2026-07-29
- Severity: SEV-4
- Status: Resolved near miss
- Component: `ansible-jenkins` GitLab CI production job
- Detection/symptom: Pre-publication review found `deploy_production` would
  start automatically for every commit to `main`.
- Impact: Publishing the dedicated-agent infrastructure code could also have
  reconfigured the Jenkins controller without a separate operator approval.
  No such pipeline was started from the unreviewed change.
- Cause: The legacy repository treated merge to `main` as deployment approval.
- Resolution: The production controller job is now a protected manual job.
  Validation remains automatic. The agent bootstrap is a separately bounded
  AWX operation.
- Validation: Pipeline 360 passed for the Jenkins-agent correction and
  explicitly skipped the protected controller deployment job. The Jenkins
  controller remained on its active 2.568.1 service.
- Prevention/follow-up: Every infrastructure repository must separate source
  validation from production mutation. A push is not deployment approval.
- Corrective automation: CI keeps lint and syntax automatic and declares
  `deploy_production` with `when: manual`.
- Evidence/related runbook:
  [Sequential Build and Change Control](sequential-build-change-control.md)

## INC-2026-056: Jenkins Agent DNS Record Was Missing

- Date: 2026-07-29
- Severity: SEV-4
- Status: Resolved
- Component: Authoritative `example.com` DNS and
  `jenkins-agent01.example.com`
- Detection/symptom: SSH by FQDN failed with a name-resolution error while
  SSH to documented address `192.168.1.138` succeeded and the guest hostname
  matched.
- Impact: Jenkins, AWX, and staff cannot reliably address the deployment
  agent by its required enterprise hostname.
- Cause: The VM and inventory were created, but the canonical BIND record list
  stopped at `.135`.
- Resolution: Cloud commit `e8873211` added `jenkins-agent01` at
  `192.168.1.138`; DNS jobs 502/514 applied and then cleanly reconverged the
  bounded DNS host.
- Validation: Normal workstation resolution, AWX inventory update 524, SSH by
  FQDN, agent-side `getent`, and Jenkins acceptance build 1 all resolved the
  required name to `.138`.
- Prevention/follow-up: Provisioning acceptance must require DNS before a VM
  is handed to product automation.
- Corrective automation: Extend inventory validation to compare provisioned VM
  names with authoritative DNS records.
- Evidence/related runbook:
  [Lab DNS and Copper9100 Configuration](product-installation-dns.md)

## INC-2026-057: Jenkins Version and Deployment Model Were Stale

- Date: 2026-07-29
- Severity: SEV-4
- Status: Resolved
- Component: Jenkins product catalog and live controller
- Detection/symptom: The catalog reported Jenkins 2.555.3 in a container.
  The live `X-Jenkins` header reports 2.568.1 and `systemctl` reports the
  native Jenkins service active.
- Impact: Upgrade planning and staff troubleshooting would use the wrong
  version and service lifecycle.
- Cause: The product catalog was not updated after the controller's native RPM
  reconciliation and LTS upgrade.
- Resolution: Updated the product catalog and annual migration row to Jenkins
  2.568.1 LTS with native RPM/systemd deployment.
- Validation: The controller returned `X-Jenkins: 2.568.1`; the official
  Jenkins LTS changelog lists 2.568.1 for July 2026.
- Prevention/follow-up: Compare the live response header and service manager
  with the catalog during every Jenkins change.
- Corrective automation: Add Jenkins version and service-model evidence to
  platform inventory audits.
- Evidence/related runbook:
  [Product Version Catalog](product-versions.md)

## INC-2026-058: Jenkins Agent Role Failed Service-State Lint

- Date: 2026-07-29
- Severity: SEV-4
- Status: Resolved
- Component: `ansible-jenkins` pipeline 356, lint job 860
- Detection/symptom: Syntax validation passed, but Ansible lint rejected the
  final `systemctl is-active jenkins-agent` command.
- Impact: The dedicated agent was not configured. The protected controller
  deployment job was skipped, so the live Jenkins controller did not change.
- Cause: The role used a shell-oriented service-state check where an Ansible
  service fact was available.
- Resolution: Replaced the command with `ansible.builtin.service_facts` and an
  assertion on `jenkins-agent.service`.
- Validation: Corrective pipeline 360 passed syntax and production-profile
  lint for commit `82adf11`; its protected controller deployment job was
  skipped.
- Prevention/follow-up: Use service modules and facts for systemd lifecycle
  and reserve command tasks for tools without an Ansible module.
- Corrective automation: Keep production-profile Ansible lint blocking before
  AWX can run the agent playbook.
- Evidence/related runbook:
  [Kubernetes Helm Delivery](kubernetes-helm-delivery-runbook.md)

## INC-2026-059: Main Terraform Validation Lost Alpine Package Index

- Date: 2026-07-31
- Severity: SEV-4
- Status: Resolved
- Component: `cloud-infra-automation-platform` pipeline 374,
  `terraform_validate` job 964
- Detection/symptom: The canonical-main pipeline failed before Terraform
  validation because `apk add --no-cache bash` could not fetch the Alpine 3.22
  `main` index and then reported `bash (no such package)`.
- Impact: The AWX local-proxy deployment gate stopped. No AWX, DNS, NGINX,
  Terraform, or other runtime change occurred.
- Timeline: Branch pipeline 372 passed the identical source. Main pipeline 374
  later encountered the temporary repository error. Only the failed job was
  retried as job 973 after the log proved the failure was external to the
  submitted code.
- Cause: Temporary failure reaching the Alpine package repository from the
  GitLab Runner while preparing the pinned Terraform container.
- Contributing factors: The Terraform image does not contain Bash, so every
  validation job depends on a live Alpine package-index fetch.
- Resolution: Retried only `terraform_validate`; job 973 passed. Pipeline 374
  then passed validation, production-profile Ansible lint, and IaC security
  scanning. Manual plan, configure, verify, and apply jobs were not run.
- Validation: The retry used the same commit `5a7a6ade`; Terraform validation
  passed without a code change, confirming a transient dependency failure.
- Prevention/follow-up: Replace runtime `apk add` with a checksum/digest-pinned
  internal CI image containing Bash, or cache/mirror required Alpine packages
  in the lab. Keep the first failed log for comparison and never retry a
  deterministic source failure without a correction.
- Corrective automation: Add a prepared Terraform validation image to the
  internal registry backlog; keep source validation blocking.
- Evidence/related runbook:
  [Sequential Build and Change Control](sequential-build-change-control.md)

## INC-2026-060: DNS Convergence Required Unavailable Public DNS

- Date: 2026-07-31
- Severity: SEV-3
- Status: Resolved
- Component: `dns.example.com`, AWX `deploy-lab-dns` job 461
- Detection/symptom: Job 461 failed at `Install BIND packages` because DNF
  could not resolve `mirrors.rockylinux.org` for the Rocky Linux 9 AppStream
  repository.
- Impact: The direct `awx.example.com` DNS migration stopped before any live
  DNS change. The recap reported `ok=2`, `changed=0`, and `failed=1` on the
  single DNS host.
- Timeline: The failed AWX output was inspected first. A read-only check
  through infra01 then proved `bind` and `bind-utils` version
  `9.16.23-40.el9_8.2` were already installed, `named` was active, and the
  private authoritative zone answered while public recursive lookups timed
  out.
- Cause: The role always called DNF even when both required packages were
  installed, creating a circular dependency on external DNS during DNS-server
  convergence.
- Contributing factors: Public recursion through the router and approved
  forwarders was unavailable, while the role treated a public lookup as a
  mandatory acceptance check for a private authoritative-zone change.
- Resolution: The role now collects package facts and runs DNF only when a
  required BIND package is absent. Private authoritative lookups remain
  mandatory; public recursive validation is controlled by
  `bind_dns_require_recursive_resolution` and defaults to false for this lab.
- Validation: Cloud branch pipeline 378 passed layout, both Terraform
  validations, Ansible lint, and IaC scanning for commit `e8873211`. Runtime
  DNS convergence and idempotence remain part of CHG-2026-002 acceptance.
- Prevention/follow-up: Make installed-state checks independent of external
  repositories. Test authoritative service records separately from optional
  Internet recursion.
- Corrective automation: `bind_dns` package facts, conditional DNF, direct AWX
  authoritative check, and optional recursive-resolution gate.
- Evidence/related runbook:
  [Sequential Build and Change Control](sequential-build-change-control.md)

## INC-2026-061: Terraform CI Repeated Alpine Bootstrap Failure

- Date: 2026-07-31
- Severity: SEV-4
- Status: Resolved
- Component: `cloud-infra-automation-platform` pipeline 377,
  `terraform_local_validate` job 987
- Detection/symptom: Job 987 failed before Terraform ran because
  `apk add --no-cache bash` could not fetch the Alpine indexes and reported
  `bash (no such package)`.
- Impact: The AWX direct-URL source gate stopped. No runtime change occurred.
- Timeline: Pipeline 377 reproduced INC-2026-059 on the feature branch. The
  CI definition was corrected rather than retrying the same network-dependent
  bootstrap. Corrective branch pipeline 378 then passed all automatic gates.
- Cause: Every Terraform job installed Bash dynamically even though the
  formatting and validation commands can run directly in the pinned Terraform
  image.
- Contributing factors: The earlier incident was treated as transient and
  retried, leaving the unnecessary package download in the pipeline.
- Resolution: Removed the `apk add` bootstrap. The CI validation job now runs
  `terraform init -backend=false` and `terraform validate` directly using the
  image entrypoint shell.
- Validation: Pipeline 378 passed `terraform_fmt`, `terraform_validate`,
  `terraform_local_validate`, `layout_validate`, `ansible_lint`, and
  `iac_scan` for commit `e8873211`.
- Prevention/follow-up: CI jobs must use pinned images that already contain
  their required shell and tools. Runtime package installation is not a
  dependable pipeline prerequisite.
- Corrective automation: `gitlab-ci/terraform.gitlab-ci.yml` no longer
  installs Bash and no longer invokes the Bash-only local helper in CI.
- Evidence/related runbook:
  [Sequential Build and Change Control](sequential-build-change-control.md)

## INC-2026-062: AWX Project Synced a Stale Temporary Branch

- Date: 2026-07-31
- Severity: SEV-4
- Status: Resolved
- Component: AWX project 23, `cloud-infra-automation-platform`
- Detection/symptom: Project update 483 succeeded but reported repository
  revision `5f844596`; the project details showed source-control branch
  `codex/awx-local-proxy-main` instead of `main`.
- Impact: Launching the template at that point would have used stale source
  despite a successful status. No deployment job was launched from it.
- Timeline: The project was synchronized after canonical-main CI passed. The
  exact revision in update output was compared with approved commit
  `e8873211`, exposing the drift before runtime execution.
- Cause: The AWX project retained a temporary implementation branch from the
  earlier local-proxy source work.
- Contributing factors: AWX reports SCM transport success independently from
  whether the configured branch is the approved source-of-truth branch.
- Resolution: Changed project 23's source-control branch to `main`. Automatic
  project update 484 succeeded at full revision
  `e8873211d69db789de1f35b26e8e347eacbbbe67`.
- Validation: Only after update 484 matched the GitLab-approved commit were
  local-proxy jobs 485/492 and DNS jobs 502/514 launched.
- Prevention/follow-up: Treat branch and full revision as mandatory pre-launch
  evidence; a green project-sync status alone is insufficient.
- Corrective automation: Keep project revision update on launch and add a
  future policy check that AWX production projects use protected `main`.
- Evidence/related runbook:
  [Sequential Build and Change Control](sequential-build-change-control.md)

## INC-2026-063: Direct Mac DNS Queries Timed Out During Acceptance

- Date: 2026-07-31
- Severity: SEV-4
- Status: Monitoring
- Component: macOS administration client to `dns.example.com` UDP/53
- Detection/symptom: Three explicit `dig @192.168.1.106` queries timed out
  from the Mac during AWX URL acceptance.
- Impact: Raw client-to-resolver verification could not be collected from the
  Mac. Normal scoped macOS resolution still returned `192.168.1.103`, and the
  portless authenticated AWX dashboard loaded successfully.
- Timeline: The same authoritative queries were repeated from infra01 and
  returned the expected canonical, retired, and unaffected service answers.
- Cause: Not yet isolated; likely client/network transport or firewall
  behavior specific to direct UDP queries rather than BIND zone content.
- Contributing factors: The Mac uses a scoped resolver path, which is not
  identical to an explicit `dig` query directly to the server.
- Resolution: No configuration was changed during the AWX component.
  Acceptance used the normal macOS resolver plus independent authoritative
  queries from infra01.
- Validation: `dscacheutil` returned `awx.example.com -> 192.168.1.103`; the
  browser loaded `http://awx.example.com/#/home`; infra01 queries returned
  `.103`, no answer for `awx.apps.example.com`, and `.114` for the unaffected
  GitLab compatibility route.
- Prevention/follow-up: Diagnose Mac-to-DNS UDP/TCP reachability as a separate
  network-engineering change without reopening or bypassing the accepted AWX
  service migration.
- Corrective automation: Add client-path DNS probes that distinguish scoped
  OS resolution, direct UDP, direct TCP, and authoritative server checks.
- Evidence/related runbook:
  [Standalone NGINX Reverse-Proxy Installation](product-installation-nginx.md)

## INC-2026-064: Hypervisor and Control Planes Were Temporarily Unreachable

- Date: 2026-08-01
- Severity: SEV-3
- Status: Resolved
- Component: infra01, infra02, GitLab, Jenkins, AWX, and lab DNS
- Detection/symptom: The required pre-change audit timed out to infra01 and
  infra02; direct checks to GitLab, Jenkins, AWX, and DNS also failed. A check
  from infra03 showed the infra01 neighbor state as `FAILED`.
- Impact: `jenkins-agent01` work could not start because GitLab, AWX, and
  Jenkins were unavailable and direct installation is prohibited.
- Timeline: The change remained read-only. After the operator confirmed all
  three hypervisors were up, SSH and every required control-plane endpoint
  passed a fresh reachability check.
- Cause: Not isolated during this change; reachability recovered without a
  configuration change.
- Resolution: Repeated the complete conflict and reachability audit before the
  first mutation. No control plane was bypassed.
- Validation: infra01/02/03 SSH, GitLab HTTP, Jenkins 8080, AWX HTTP, DNS 53,
  and agent SSH all accepted connections.
- Prevention/follow-up: Keep reachability as a hard pre-change gate and
  diagnose repeat events under the existing management-network monitoring
  work rather than inside an application change.
- Corrective automation: Preserve cross-checks from a second hypervisor when
  workstation reachability is ambiguous.
- Evidence/related runbook:
  [Sequential Build and Change Control](sequential-build-change-control.md)

## INC-2026-065: AWX Deploy Key Was Not Enabled for ansible-jenkins

- Date: 2026-08-01
- Severity: SEV-4
- Status: Resolved
- Component: AWX project 28 and GitLab `ansible-jenkins`
- Detection/symptom: AWX project update 522 completed the SSH handshake but
  reported that the project was not found or accessible.
- Impact: The validated agent role could not be selected in AWX, so inventory
  and deployment correctly stopped before changing the VM.
- Cause: Existing read-only deploy key 1 was enabled for the other canonical
  automation repositories but not for `ansible-jenkins`.
- Resolution: Enabled the existing key read-only through GitLab's authenticated
  API. No new private key or write permission was created.
- Validation: Project update 523 selected `82adf11`; later update 532 selected
  corrected canonical revision `a2544ec`.
- Prevention/follow-up: Add deploy-key authorization to repository onboarding
  acceptance before creating an AWX project.
- Corrective automation: Extend onboarding validation to compare required AWX
  repositories with read-only deploy-key associations.
- Evidence/related runbook:
  [Jenkins Agent Acceptance](evidence/CHG-2026-002-jenkins-agent-acceptance.md)

## INC-2026-066: Jenkins Agent Helm Validation Used the Wrong PATH

- Date: 2026-08-01
- Severity: SEV-4
- Status: Resolved
- Component: `ansible-jenkins` role and AWX job 527
- Detection/symptom: Job 527 installed `/usr/local/bin/helm` and started the
  agent service, then failed `helm version --short` with file-not-found.
- Impact: Initial convergence ended with `failed=1`; the partially installed
  agent was not accepted even though it connected to Jenkins.
- Cause: AWX executes non-login commands with a PATH that did not include
  `/usr/local/bin`, while the role used a PATH lookup for acceptance.
- Resolution: Commit `a2544ec` introduced `jenkins_agent_helm_path` and used
  the explicit path for both installation and validation.
- Validation: Pipelines 384/385 passed. AWX jobs 536/541 each reported
  `ok=17 changed=0 unreachable=0 failed=0`, and Jenkins acceptance build 1
  printed Helm 4.1.0 from the dedicated agent.
- Prevention/follow-up: Validation commands for role-managed binaries outside
  `/usr/bin` must use the same explicit path as the installation task.
- Corrective automation: Retain production-profile lint and add a future role
  test that executes version checks with a restricted non-login PATH.
- Evidence/related runbook:
  [Jenkins Agent Acceptance](evidence/CHG-2026-002-jenkins-agent-acceptance.md)

## INC-2026-067: Jenkins Proxy Role Assumed firewalld Was Running

- Date: 2026-08-01
- Severity: SEV-4
- Status: Resolved
- Component: `ansible-jenkins` local proxy role and AWX job 550
- Detection/symptom: Job 550 reached the permanent HTTP-service query after
  installing NGINX and its configuration, but `firewall-cmd` returned 252 with
  `FirewallD is not running`.
- Impact: Initial convergence stopped at `ok=11 changed=4 failed=1`. Port 80
  remained unavailable and the partial state was not accepted.
- Timeline: GitLab branch pipelines 387-389 and canonical-main pipelines
  390-392 passed. AWX inventory update 546 selected the one-host controller
  scope, project update 549 selected `cb9fc738`, and template 30 launched job
  550. The job stopped at the failed firewall query; no direct workaround was
  used.
- Cause: The new proxy role copied an earlier local-proxy firewall query but
  did not establish the query's prerequisite that firewalld be active.
- Contributing factors: The Jenkins service was healthy on port 8080 while
  firewalld was inactive, so backend health validation alone could not expose
  the missing service-state prerequisite.
- Resolution: Commit `15d61a6` reused the repository's existing `firewalld`
  role ahead of the local proxy role so package/service state is explicit and
  only `80/tcp` is managed. Branch pipeline 394 and main pipeline 395 passed;
  protected controller deployment remained manual.
- Validation: AWX project update 555 selected `15d61a6`. Job 556 succeeded at
  `ok=23 changed=5 failed=0`; job 561 converged at `ok=21 changed=0 failed=0`.
  Jenkins returned HTTP 200 at the canonical port-80 URL, and agent jobs
  566/571 moved the WebSocket URL and then converged with zero changes.
- Prevention/follow-up: Infrastructure roles that invoke service-specific
  clients must either own the service prerequisite or declare it through a
  composed role/playbook.
- Corrective automation: Retain syntax/lint gates and add the established
  firewalld role to the proxy playbook composition.
- Evidence/related runbook:
  [Jenkins Portless Acceptance](evidence/CHG-2026-002-jenkins-portless-acceptance.md)

## INC-2026-068: Runner Identity Automation Assumed the Wrong Administrator

- Date: 2026-08-01
- Severity: SEV-4
- Status: Resolved
- Component: GitLab runner identity role and AWX job 617
- Detection/symptom: Job 617 failed its first GitLab-side task after the
  protected Rails command could not find username `root`.
- Impact: The dedicated infrastructure runner was not created and `.137` was
  not mutated. GitLab CI remained available through the legacy runner.
- Timeline: Job 617 failed safely. A rollback-only Rails diagnostic exposed
  the missing username. The source was changed to configurable administrator
  `gitlab-admin`, service errors were handled correctly, and pipelines
  417/418 passed before job 625 deployed the runner. A later idempotence
  correction passed pipelines 420/421 and job 645 converged cleanly.
- Cause: Automation assumed GitLab's administrator retained the default
  username instead of using the environment's configured administrator.
- Contributing factors: `no_log` correctly protected the runner token but also
  censored the first task's exception in AWX output.
- Resolution: Added `gitlab_runner_creator_username`, defaulted it to the live
  configured `gitlab-admin` account, corrected service-error access, and made
  reconciliation compare desired attributes before writing.
- Validation: Runner ID 4 is online with exact project scope and tags; canary
  job 1171 passed; rollback/restore passed; AWX job 645 reported zero changes.
- Prevention/follow-up: Treat administrative identities as inventory data and
  use rollback-only diagnostics when secret-protected tasks fail.
- Corrective automation: Commits `924f54f` and `281b35e`.
- Evidence/related runbook:
  [GitLab Infrastructure Runner Acceptance](evidence/CHG-2026-004-gitlab-runner-infra-acceptance.md)

## INC-2026-069: Shared Runner Automation Exposed Dormant-Path Assumptions

- Date: 2026-08-01
- Severity: SEV-4
- Status: Resolved
- Component: infra03 VM provisioning and GitLab shared-runner automation
- Detection/symptom: AWX jobs 671 and 674 stopped before VM creation because
  the published branch lacked the repository roles path and attempted to
  retrieve a retired Rocky checksum. AWX job 684 then stopped while creating
  a new instance runner because the GitLab 19.2 service received a nil scope
  key. Dedicated-runner CI also exposed an unpinned Ansible job image.
- Impact: Deployment paused safely. No unintended domain, runner, or shared
  component was created or changed by the failed jobs.
- Timeline: Source corrections added `ansible.cfg`, validated and reused the
  accepted base image, omitted scope for instance-runner creation, pinned the
  Ansible CI image, and routed provisioning jobs to runner ID 4. Pipelines and
  exact-revision AWX synchronization preceded each retry.
- Cause: Previously dormant paths retained assumptions from an older branch:
  implicit role discovery, a historical external checksum entry, a project
  runner parameter shape reused for instance runners, and a runner-specific
  default CI image.
- Contributing factors: Secret-protected identity output correctly used
  `no_log`, so GitLab service source inspection was required to identify the
  nil-scope contract.
- Resolution: Provisioning source commit `1b9313b` pins the Python lint image
  and retains the accepted-base-image and roles-path corrections. Canonical
  runner source commit `8fb79ca` adds scope only for project runners.
- Validation: Guarded jobs 1355/1359 created only the `.139` domain/volume;
  every automatic job in final provisioning pipeline 448 passed; pipelines
  445/446 and canary pipeline 447 passed; AWX jobs 692, 696, 700, and
  zero-change job 704 passed.
- Prevention/follow-up: Pin every CI execution image, avoid optional keys in
  GitLab service parameter hashes, and validate cached base images before
  consulting mutable upstream checksum catalogs.
- Corrective automation: Commits `1b9313b` and `8fb79ca`.
- Evidence/related runbook:
  [GitLab Shared Runner Acceptance](evidence/CHG-2026-006-gitlab-runner-shared-acceptance.md)

## INC-2026-070: AWX Templates Used Non-Project-Relative Playbook Paths

- Date: 2026-08-02
- Severity: SEV-4
- Status: Resolved
- Component: `ansible-awx` controller-object reconciler
- Detection/symptom: The first reconciler attempt at main revision `4053cf88`
  stopped before creating usable job templates because each playbook value
  omitted the repository-relative `playbooks/` prefix.
- Impact: Runtime deployment did not start and the execution VM was unchanged.
- Cause: The controller contract used playbook filenames rather than paths
  relative to the synchronized AWX project root.
- Resolution: Commit `34b415f` added the required paths and a focused
  controller-contract test. Merge request !5 passed branch pipeline 493 and
  main pipeline 494, producing main revision `18334d1e`.
- Validation: Later reconciliation created templates 47 through 52 with the
  expected project-relative playbooks; final jobs 741 through 749 all selected
  canonical revision `7b931558`.
- Prevention/follow-up: Keep project-relative playbook uniqueness and path
  checks in repository CI.
- Corrective automation: `scripts/check_controller_contract.py` and corrected
  template constants in `scripts/reconcile_awx_objects.py`.
- Evidence/related runbook:
  [AWX Execution Plane Acceptance](evidence/CHG-2026-008-awx-execution-plane-acceptance.md)

## INC-2026-071: AWX Inventory Children Rejected Nested PATCH Reconciliation

- Date: 2026-08-02
- Severity: SEV-4
- Status: Resolved
- Component: AWX inventory 10 reconciliation
- Detection/symptom: The corrected reconciler reached inventory children and
  failed when it attempted to PATCH a host through a nested inventory endpoint.
- Impact: Controller reconciliation stopped safely; no deployment job or VM
  mutation occurred.
- Cause: AWX 24.6.1 permits nested inventory endpoints for association and
  listing but requires group and host mutation through their global endpoints.
- Resolution: Commit `bfd23ec` reconciled groups and hosts globally and kept
  nested endpoints only for exact association. Merge request !6 passed branch
  pipeline 495 and main pipeline 496, producing revision `c93c3d1f`.
- Validation: Reconciliation created inventory 10, execution host 88, and
  localhost 89 exactly once; the final read-only object audit passed.
- Prevention/follow-up: Retain the endpoint-contract test for AWX inventory
  children and associations.
- Corrective automation: Global `groups` and `hosts` reconciliation plus the
  bounded association test.
- Evidence/related runbook:
  [AWX Execution Plane Acceptance](evidence/CHG-2026-008-awx-execution-plane-acceptance.md)

## INC-2026-072: Controller Job Template Had No Executing Capacity

- Date: 2026-08-02
- Severity: SEV-4
- Status: Resolved
- Component: AWX job template scheduling
- Detection/symptom: Preflight job 736 remained pending with `not enough
  capacity` and never started because the controller-side templates were bound
  to the non-executing `controlplane` instance group.
- Impact: No task reached `awx-execution.example.com`; job 736 was canceled
  without VM mutation.
- Cause: The source treated the AWX control-plane group as an execution group.
  Accepted controller jobs in this installation use the `default` container
  group.
- Resolution: Commit `e46788e` bound preflight, install, validate, remove, and
  restore only to container group ID 2 (`default`), retained the canary only on
  `lab-infrastructure`, and prohibited instance-group fallback. Merge request
  !7 passed branch pipeline 497 and main pipeline 498 at `11d68675`.
- Validation: Preflight 738 passed; controller jobs 741, 742, and 744 through
  749 ran without capacity errors; canaries 743 and 747 ran specifically on
  `awx-execution.example.com`.
- Prevention/follow-up: Keep the group identity, container-group flag, exact
  association, and no-fallback checks in controller CI and pre-launch audit.
- Corrective automation: Controller contract and exact job-template instance
  group reconciliation.
- Evidence/related runbook:
  [AWX Execution Plane Acceptance](evidence/CHG-2026-008-awx-execution-plane-acceptance.md)

## INC-2026-073: Shared Runner Briefly Could Not Clone GitLab

- Date: 2026-08-02
- Severity: SEV-4
- Status: Resolved
- Component: `ansible-awx` branch pipeline 497, shared-runner job 1589
- Detection/symptom: The first pipeline attempt could not clone the project
  over HTTP because the runner temporarily could not connect to GitLab. The
  source/layout validation itself had no reported defect.
- Impact: Merge request !7 remained gated; no AWX reconciliation or runtime
  change used the unaccepted revision.
- Cause: Transient internal GitLab HTTP connectivity from the shared runner.
- Resolution: Retried only the failed clone job after service connectivity
  recovered. Replacement job 1592 passed and pipeline 497 completed green.
- Validation: Main pipeline 498 passed the same revision, and later pipelines
  499/500 also completed successfully.
- Prevention/follow-up: Retry a clone-only transport failure only after
  confirming source validation is still gated; do not weaken CI or bypass the
  published revision requirement.
- Corrective automation: None; this was a transient transport event.
- Evidence/related runbook:
  [AWX Execution Plane Acceptance](evidence/CHG-2026-008-awx-execution-plane-acceptance.md)

## INC-2026-074: Python 3.9 Conditional Dependencies Were Missing Hashes

- Date: 2026-08-02
- Severity: SEV-4
- Status: Resolved
- Component: AWX execution-node hashed Python runtime, install job 739
- Detection/symptom: Install job 739 stopped at the hashed runtime task because
  Python 3.9 selected `importlib-metadata<6.3,>=4.6`, but the requirements file
  did not pin or hash that package and its `zipp` dependency.
- Impact: The VM contained only partial pre-runtime preparation. Receptor and
  the NGINX stream configuration had not started, instance 3 remained disabled,
  and no backend port was exposed.
- Cause: The initial dependency closure was resolved from a newer workstation
  interpreter instead of the target Linux CPython 3.9 environment.
- Resolution: Commit `b63e109` pinned `importlib-metadata==6.2.1` and
  `zipp==3.23.1` with reviewed SHA-256 hashes, recorded the Python 3.9
  conditional pins in the bundle manifest, and made CI require them. Merge
  request !8 passed branch pipeline 499 and main pipeline 500 at `7b931558`.
- Validation: A target-platform `pip download --require-hashes` resolved all
  13 wheels. Install job 741 passed; rollback/restore passed; final install 748
  reported zero changes and no failures; final validation 749 passed.
- Prevention/follow-up: Resolve and verify dependency locks against every
  supported target Python/platform tuple, including environment-marker-only
  packages.
- Corrective automation: Python 3.9 conditional manifest contract and complete
  hashed runtime requirements.
- Evidence/related runbook:
  [AWX Execution Plane Acceptance](evidence/CHG-2026-008-awx-execution-plane-acceptance.md)

## INC-2026-075: Ingress Queue Overstated Jenkins Prerequisite Readiness

- Date: 2026-08-03
- Severity: SEV-4
- Status: Resolved
- Component: Kubernetes ingress Jenkins delivery prerequisites
- Detection/symptom: The sequential queue said the kubeconfig secret-file
  credential and non-mutating PLAN were complete. The required live audit found
  no `projects/deploy-kubernetes-ingress` job and no Jenkins credential with ID
  `kubernetes-production-kubeconfig`.
- Impact: CHG-2026-009 cannot run PLAN or DEPLOY. No ingress resource, namespace,
  IngressClass, or cluster mutation occurred.
- Timeline: Source pipelines 351, 352, and 354 passed four days earlier. The
  enterprise seed job subsequently checked out exact jobs revision `950cc4f`,
  but build 43 stopped at `script not yet approved for use`. On 2026-08-03 the
  four hashes matching current source were approved and two stale variants
  were left unapproved. Build 44 then queued because the only agent is
  label-restricted and the seed had no assigned label; it was cancelled before
  execution.
- Cause: Documentation promoted intended prerequisite state to completed state
  after source CI, without requiring live Jenkins object and PLAN evidence.
- Contributing factors: The protected Jenkins configuration step was not part
  of automatic GitLab validation, seed failure did not change the queue entry,
  and the source-managed seed definition did not declare the label required by
  the exclusive agent policy.
- Resolution: Merge request !15 and protected jobs 1624/1625 restored and
  converged the source-managed seed on `jenkins-agent01`; seed builds 44/45
  generated the ingress job. The folder-scoped kubeconfig credential was
  created without retaining either temporary copy. Existing Jenkins deploy key
  2 was enabled read-only for the source project, and PLAN build 2 succeeded at
  exact revision `e34bd547` without cluster mutation.
- Validation: Require the generated job, correct secret-file credential type,
  build agent `jenkins-agent01.example.com`, exact source revision, successful
  server-side Helm dry run, and zero secret output.
- Prevention/follow-up: Queue prerequisites must cite live object IDs/builds,
  not source availability alone. A failed protected configuration step must
  leave the next runtime gate explicitly blocked.
- Corrective automation: Add a read-only Jenkins prerequisite contract that
  checks job existence, credential ID/type, agent label, and last successful
  PLAN before an ingress DEPLOY can be enabled.
- Evidence/related runbook:
  [CHG-2026-009 Kubernetes Ingress](change-records/CHG-2026-009-kubernetes-ingress.md),
  [PLAN evidence](evidence/CHG-2026-009-kubernetes-ingress-plan.md)

## INC-2026-076: Jenkins JCasC Seed Label Method Prevented Startup

- Date: 2026-08-03
- Severity: SEV-3
- Status: Resolved
- Component: Jenkins Configuration as Code and enterprise seed
- Detection/symptom: Protected production job 1617 failed its restart handler.
  Jenkins journal reported that `FreeStyleJob.assignedNode()` does not exist and
  systemd repeatedly attempted startup.
- Impact: Jenkins and its agent control plane were unavailable. The enterprise
  seed did not run until recovery, and CHG-2026-009 remained blocked before
  credential creation or PLAN. No ingress or Kubernetes resource was created.
- Timeline: Merge request !14 passed branch pipeline 507 and main validation
  pipeline 509 at revision `c560f6e7`. Manual production job 1617 updated the
  managed JCasC file, restarted Jenkins, and failed after the unsupported Job
  DSL method prevented Configuration as Code initialization.
- Cause: The seed label was expressed with `assignedNode`, which is not a
  supported method on the installed Job DSL `FreeStyleJob` type.
- Contributing factors: Ansible syntax and lint validate YAML/Jinja structure
  but do not execute the installed Jenkins Job DSL API during source CI.
- Resolution: Revision `b19b64bd` in `ansible-jenkins` merge request !15
  replaced only the unsupported call with the supported `label` method.
  Branch pipeline 511 passed, the merge completed as `ff986811`, and main
  pipeline 513 passed. Protected production job 1624 restored Jenkins without
  a direct live-file edit; protected idempotence job 1625 passed with
  `changed=0`.
- Validation: Jenkins is active and HTTP healthy with zero service restarts;
  the controller has zero executors, `jenkins-agent01` is online, seed builds
  44 and 45 succeeded on that labeled agent, the generated ingress job exists,
  the queue is empty, exactly two stale approvals remain unapproved, and the
  second production convergence reported `ok=34 changed=0 unreachable=0
  failed=0`.
- Prevention/follow-up: Add a Jenkins Job DSL compilation check using the
  installed plugin API before JCasC deployment, or validate managed scripts in
  an isolated Jenkins test instance.
- Corrective automation: Extend the protected preflight to load the rendered
  JCasC Job DSL against the deployed plugin set before restarting production.
- Evidence/related runbook:
  [CHG-2026-009 Kubernetes Ingress](change-records/CHG-2026-009-kubernetes-ingress.md)

## INC-2026-077: Jenkins Deploy Key Was Not Enabled for Ingress Source

- Date: 2026-08-03
- Severity: SEV-4
- Status: Resolved
- Component: Jenkins Kubernetes ingress source checkout
- Detection/symptom: Jenkins PLAN build 1 started on `jenkins-agent01` and
  loaded the accepted shared-library revision, but GitLab rejected the
  `gitlab-scm` SSH credential while cloning
  `midhhealth/platform-engineering/ansible-kubernetes`.
- Impact: The reviewed PLAN could not reach source validation or the Helm
  server-side dry run. The Helm stage was skipped, and no namespace,
  IngressClass, Ingress, release, or other cluster resource changed.
- Timeline: The folder-scoped kubeconfig credential was created and its two
  temporary copies were securely removed. Build 1 then used exact source
  `e34bd547`, `ACTION=PLAN`, and `CONFIRM_CHANGE=false`; checkout returned Git
  status 128 and the pipeline finished FAILURE before Helm.
- Cause: The existing private deploy key `Jenkins SCM read-only`, used by the
  Jenkins `gitlab-scm` credential, is privately accessible in GitLab but is not
  enabled on the `ansible-kubernetes` project.
- Contributing factors: Source CI validated the repository and pipeline code,
  but the runtime prerequisite gate did not verify per-project deploy-key
  enablement before the first PLAN.
- Resolution: GitLab's idempotent `Projects::EnableDeployKeyService` joined
  existing deploy key 2 to project 14. Validation reported
  `before_enabled=false`, `after_enabled=true`, and `can_push=false`; no
  replacement key was created. Jenkins PLAN build 2 then checked out exact
  revision `e34bd547` and completed successfully.
- Validation: Build 2 ran on `jenkins-agent01`, checked out exact revision
  `e34bd547`, completed the server-side Helm dry run, printed no kubeconfig
  certificate/key/token fields, and finished SUCCESS. Independent validation
  confirmed all four expected nodes Ready and zero ingress runtime resources.
- Prevention/follow-up: Extend the Jenkins prerequisite contract to perform an
  authenticated read-only `git ls-remote` against every deployment source
  before enabling the manual PLAN action.
- Corrective automation: Add source-access preflight validation to the
  generated deployment job or its shared library without granting write
  access.
- Evidence/related runbook:
  [CHG-2026-009 Kubernetes Ingress](change-records/CHG-2026-009-kubernetes-ingress.md),
  [PLAN evidence](evidence/CHG-2026-009-kubernetes-ingress-plan.md)

## INC-2026-078: Ingress PLAN Retained Shared Proxy and NodePorts

- Date: 2026-08-03
- Severity: SEV-4
- Status: Open
- Component: CHG-2026-009 Kubernetes ingress exposure design
- Detection/symptom: Operator review asked why the planned Headlamp route still
  used `nginx.example.com`. Source and DNS inspection confirmed that PLAN build
  2 rendered NodePorts 30081/30444, expected the shared proxy at
  `192.168.1.114`, and used `headlamp.apps.example.com`.
- Impact: The plan contradicted the permanent rule that every product VM uses
  its own NGINX hostname frontend and never exposes a backend host port. The
  defect was found before deployment; no ingress namespace, controller,
  IngressClass, Ingress, NodePort listener, DNS change, or firewall rule was
  created.
- Timeline: PLAN build 2 successfully proved exact source `e34bd547` on
  `jenkins-agent01`. Post-PLAN inspection showed all four nodes Ready and zero
  ingress resources. Before the firewall or DEPLOY gate, operator review
  rejected the shared-edge assumption. A new conflict audit found zero GitLab,
  Jenkins, AWX, or Kubernetes work, and DNS confirmed
  `headlamp.apps.example.com -> 192.168.1.114` while
  `headlamp.example.com` was absent.
- Cause: The first ingress design treated a source-restricted NodePort as a
  sufficiently private backend and reused the historical shared proxy. That
  interpretation did not satisfy the stricter product-local NGINX boundary.
- Contributing factors: CI asserted the old fixed NodePorts but had no negative
  contract forbidding NodePort, `nginx.example.com`, or the legacy `.apps`
  hostname.
- Resolution: In progress. Correct the Helm Service to ClusterIP, install
  NGINX on `k8s-worker01.example.com`, publish
  `headlamp.example.com -> 192.168.1.108`, remove the shared route at cutover,
  and require a new PLAN from reviewed revisions.
- Validation: Pending corrected source CI, new PLAN, controlled DNS/NGINX
  convergence, runtime acceptance, rollback/restore, legacy-route retirement,
  zero backend host ports, and second-run idempotence.
- Prevention/follow-up: Source validation must fail on NodePort/hostPort,
  `nginx.example.com`, `headlamp.apps.example.com`, and direct backend-IP curl
  acceptance in the active ingress implementation.
- Corrective automation: Add explicit ClusterIP, local-NGINX, canonical-host,
  firewall, and negative legacy-reference assertions to source CI.
- Evidence/related runbook:
  [CHG-2026-009 Kubernetes Ingress](change-records/CHG-2026-009-kubernetes-ingress.md),
  [superseded PLAN evidence](evidence/CHG-2026-009-kubernetes-ingress-plan.md)

## New Incident Template

Copy this section for every new event:

```markdown
## INC-YYYY-NNN: Short Title

- Date:
- Severity:
- Status:
- Component:
- Detection/symptom:
- Impact:
- Timeline:
- Cause:
- Contributing factors:
- Resolution:
- Validation:
- Prevention/follow-up:
- Corrective automation:
- Evidence/related runbook:
```

Add the incident to the summary table when the record is created. Update its
status and findings as evidence changes; retain the original observation and
identify corrected assessments explicitly.
