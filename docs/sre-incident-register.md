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
- Status: Open
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
