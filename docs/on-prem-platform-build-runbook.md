# On-Premises Platform Build Runbook

## Purpose

This is the operator runbook for rebuilding the two physical lab hosts and
preparing them for the enterprise training platform. It records both automated
actions and the manual steps that require local console access or a sudo
password.

The current phase is on-premises only. AWX-driven EKS and ECR provisioning is a
later phase.

## Target Hosts

| Host | Role | Operating system | Address |
| --- | --- | --- | --- |
| `infra01.example.com` | Primary KVM hypervisor | Ubuntu 26.04 LTS Desktop with GNOME | `192.168.1.38` |
| `infra02.example.com` | Secondary KVM hypervisor | Ubuntu 26.04 LTS Desktop with GNOME | `192.168.1.169` (`.73` was the rebuild-time lease) |

The management account on both hosts is `midhtechadmin`.

Do not begin VM provisioning until each physical-host address has a DHCP
reservation and forward/reverse DNS is stable.

## Rebuild Order

Rebuild and validate `infra02.example.com` first. It hosts the secondary
platform products and can be prepared while infra01 remains available for
reference or recovery. Rebuild infra01 only after infra02 passes the host
readiness checks.

## Manual Ubuntu Installation

1. Boot the physical server from the Ubuntu 26.04 installation USB.
2. Select the normal Ubuntu Desktop installation so GNOME remains available.
3. Use the entire intended operating-system disk only after confirming backups.
4. Create the `midhtechadmin` account.
5. Set the host name to the target FQDN.
6. Complete installation, remove the USB drive, and reboot.
7. Open a GNOME terminal and install SSH:

```bash
sudo apt update
sudo apt install -y openssh-server
sudo systemctl enable --now ssh
sudo ufw allow OpenSSH
```

8. Confirm SSH is listening:

```bash
sudo ss -lntp | grep ':22'
```

## Configure Host Name

On infra02:

```bash
sudo hostnamectl set-hostname infra02.example.com
```

On infra01:

```bash
sudo hostnamectl set-hostname infra01.example.com
```

Verify:

```bash
hostnamectl
hostname -f
ip -br address
ip route
```

## Authorize the Administration Workstation

From the Mac:

```bash
ssh-copy-id -i ~/.ssh/id_rsa.pub midhtechadmin@infra02.example.com
```

Test non-interactive access:

```bash
ssh -o BatchMode=yes midhtechadmin@infra02.example.com hostname
```

Repeat for infra01 after its rebuild.

If password-based key installation is disabled, create
`~/.ssh/authorized_keys` locally on the server, add the Mac public key, and set:

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
sudo systemctl restart ssh
```

Never place private keys or passwords in this repository.

## Install the Virtualization Baseline

The maintained bootstrap script is:

```text
workspace.training/scripts/bootstrap-infra02-host.sh
```

It installs:

- QEMU/KVM and libvirt
- `virt-install` and `virt-manager`
- bridge and cloud-image utilities
- Ansible
- Cockpit and Cockpit Machines
- Git, curl, jq, rsync and supporting administration tools
- Chrony time synchronization

It also adds `midhtechadmin` to the `libvirt` and `kvm` groups and creates:

```text
/var/lib/libvirt/lab-images
/var/lib/libvirt/lab-cloudinit
```

After the script has been uploaded to `/tmp`, run this from the Mac so the
operator can enter the sudo password:

```bash
ssh -t midhtechadmin@infra02.example.com \
  'sudo /tmp/bootstrap-infra02-host.sh'
```

The script performs a full package upgrade. Review its output before rebooting.
If `/var/run/reboot-required` exists, reboot:

```bash
ssh -t midhtechadmin@infra02.example.com 'sudo reboot'
```

Wait for the host to return and log in again so new group membership is active.

## Post-Bootstrap Validation

Run:

```bash
cd /Users/midhmaclab/workspace.training
./scripts/check-host-readiness.sh
```

On the host, verify:

```bash
id
ls -l /dev/kvm
virsh --version
virsh list --all
systemctl --no-pager --full status libvirtd
systemctl --no-pager --full status cockpit.socket
ansible --version
df -h /
free -h
```

Expected infra02 baseline:

- Ubuntu 26.04 LTS
- 32 logical CPUs
- approximately 107 GiB RAM
- approximately 2.6 TiB initially free
- `/dev/kvm` available with Intel VT-x
- SSH, libvirt, Chrony, and Cockpit active
- `midhtechadmin` in the `kvm` and `libvirt` groups

Cockpit is available at:

```text
https://infra02.example.com:9090
```

## Configure the Libvirt Storage Pool

Create a persistent directory-backed pool for lab VM disks:

```bash
virsh pool-define-as lab-images dir \
  --target /var/lib/libvirt/lab-images
virsh pool-build lab-images
virsh pool-start lab-images
virsh pool-autostart lab-images
virsh pool-info lab-images
```

The infra02 pool has approximately 2.67 TiB available after the base operating
system installation. VM disks, installation media and cloud images must be
tracked separately; do not store credentials in a libvirt storage volume.

## Network Safety Gate

The initial libvirt `default` network provides NAT on `virbr0` using
`192.168.122.0/24`. It is suitable for initial image and cloud-init testing, but
it does not satisfy the final requirement for directly addressable
`*.example.com` service VMs.

The physical interface on infra02 is `enp0s25`. Before bridge creation it
received `192.168.1.73/24` through the NetworkManager profile
`netplan-enp0s25`. After bridge creation, DHCP and the default route moved to
`br0` and DHCP assigned `192.168.1.169/24`.

Do not convert the physical interface to a bridge over an SSH-only session
until:

1. `192.168.1.169` is reserved for infra02 in DHCP; `.73` is historical only.
2. Console access through GNOME is available.
3. The current NetworkManager profile is backed up.
4. The desired VM address range and gateway are documented.
5. A rollback command has been prepared and tested.

Changing the only physical interface can disconnect the operator and is a
manual, console-supervised change.

## Physical Bridge Script

Use the maintained bridge manager:

```text
workspace.training/scripts/configure-physical-bridge.sh
```

Copy it to the server if it is not already present:

```bash
scp /Users/midhmaclab/workspace.training/scripts/configure-physical-bridge.sh \
  midhtechadmin@infra02.example.com:/tmp/
```

Run preflight remotely or at the server console:

```bash
sudo /tmp/configure-physical-bridge.sh preflight
```

Perform the actual change only from the physical GNOME console:

```bash
sudo /tmp/configure-physical-bridge.sh apply
```

The operator must type `APPLY-BRIDGE`. The script:

1. Confirms `enp0s25` owns the default route.
2. Refuses to overwrite an existing lab bridge.
3. Backs up NetworkManager and netplan configuration under
   `/var/backups/midhtech-network`.
4. Creates NetworkManager bridge `br0` using connection `lab-br0`.
5. Adds `enp0s25` as bridge port `lab-br0-port`.
6. Moves DHCP and IPv6 configuration to the bridge.
7. Waits up to 60 seconds for an IPv4 address and default route.
8. Automatically restores the original connection if validation fails.

Validate afterward:

```bash
sudo /tmp/configure-physical-bridge.sh status
ip -br address
ip route
ping -c 3 192.168.1.1
```

From the Mac:

```bash
ssh midhtechadmin@infra02.example.com
```

Manual rollback from the physical console:

```bash
sudo /tmp/configure-physical-bridge.sh rollback
```

The bridge retains DHCP intentionally. The router reservation must now bind
`192.168.1.169` to the bridge MAC address. Do not reserve the address against
the former physical-interface lease. Do not convert the bridge to a locally
hard-coded static address unless the network addressing plan is formally
changed.

During bridge activation, SSH may time out while DHCP and dynamic DNS converge.
Before initiating rollback, check the physical console:

```bash
ip -br address show br0
ip route
ping -c 3 192.168.1.1
```

If `br0` has an IPv4 address, owns the default route, and reaches the gateway,
the bridge succeeded. Resolve the new address through DNS and reconnect. Use
rollback only when local address or route validation fails.

## Troubleshooting

### SSH connection refused

The host is reachable, but SSH is not listening:

```bash
sudo apt install -y openssh-server
sudo systemctl enable --now ssh
sudo ufw allow OpenSSH
```

### SSH permission denied

Verify the account, authorized key, ownership, and permissions:

```bash
id midhtechadmin
ls -ld ~/.ssh
ls -l ~/.ssh/authorized_keys
```

### Ping fails but SSH works

ICMP may be filtered. Treat a successful SSH connection as the more useful
management-plane test.

### Host address changed

Confirm the new address:

```bash
hostname -I
ip -br address
```

Update the DHCP reservation and DNS records before continuing. Do not encode a
temporary DHCP address in VM definitions.

### KVM unavailable

Confirm virtualization is enabled in firmware:

```bash
lscpu | grep Virtualization
test -e /dev/kvm && echo available
```

Enable Intel VT-x/VT-d or AMD-V/IOMMU in system firmware if necessary.

### Ubuntu 26.04 QEMU package selection

On Ubuntu 26.04, `qemu-kvm` is a virtual package and the provider must be
selected explicitly. This lab uses the standard provider:

```bash
sudo apt install -y qemu-system-x86
```

The maintained bootstrap script already uses this package. If an older copy of
the script stopped at `qemu-kvm`, no virtualization packages were installed by
that command. Re-upload the current script and run it again. The script is
idempotent and the completed operating-system upgrade will not be repeated
unnecessarily.

Do not combine `qemu-system-x86-hwe` with the standard `libvirt-clients`
dependency set on this Ubuntu 26.04 release. The HWE QEMU package selects
`ubuntu-virt-hwe`, while `libvirt-clients` selects `ubuntu-virt`; those two
metapackages conflict. A failed dependency resolution at this stage does not
alter the system. Confirm a clean package state and simulate the corrected
transaction:

```bash
dpkg --audit
sudo apt-get -s install \
  qemu-system-x86 libvirt-daemon-system libvirt-clients \
  virt-install virt-manager
```

## Next Implementation Stages

After both hypervisors pass validation:

1. Finalize persistent management addresses and DNS.
2. Define libvirt storage pools.
3. Define the VM network and decide whether to use a physical bridge.
4. Download and verify the Rocky Linux 9 cloud image.
5. Provision the VM inventory using cloud-init and `virt-install`.
6. Apply the Rocky Linux baseline with Ansible.
7. Bootstrap GitLab on `gitlab.example.com`.
8. Store and protect the automation repositories in GitLab.
9. Bootstrap AWX on `awx.example.com` and connect it to GitLab.
10. Prove inventory, credential, project-sync, and read-only validation jobs.
11. Install every remaining product through AWX-managed Ansible.
12. Build the single-control-plane Kubernetes cluster and three workers.
13. Install GitOps, ingress, certificates, policy, storage and backup operators.
14. Install the dedicated observability services.
15. Validate Projects 1–5 as the active end-to-end implementation.
16. Review capacity and prerequisites for planned Projects 6–10; do not create
    their repositories, VMs, or products from this build step.
17. Optionally deploy a reference workload and begin the on-premises MAAS
    monolith-to-microservices rehearsal.

Exact VM placement and product sequencing are maintained in the linked VM
inventory and platform installation documents.

## Prepare the Libvirt Bridge Network

After `br0` is active, define a libvirt network that attaches VM interfaces
directly to the physical bridge:

```bash
virsh net-define workspace.training/libvirt/networks/lab-bridge.xml
virsh net-start lab-bridge
virsh net-autostart lab-bridge
virsh net-info lab-bridge
```

This network does not provide its own DHCP or NAT. VM addresses come from the
physical LAN addressing plan. The libvirt `default` NAT network remains
available for isolated tests.

## Prepare the Rocky Linux 9 Base Image

The lab pins Rocky Linux 9.8 GenericCloud Base build `20260525.0` rather than
silently consuming a moving `latest` image.

Run:

```bash
workspace.training/scripts/prepare-rocky9-image.sh
```

The script:

1. Downloads the official x86-64 GenericCloud qcow2 image.
2. Supports resuming an interrupted download.
3. Verifies SHA-256
   `92c206cc6f790c61583247eefe87890f8828420662c17cacf247cec78ab4eec8`.
4. Displays qcow2 metadata with `qemu-img info`.
5. Creates stable link
   `/var/lib/libvirt/lab-images/base/rocky9-base.qcow2`.

The source is the official Rocky Linux repository:

```text
https://download.rockylinux.org/pub/rocky/9.8/images/x86_64/
```

## Provision Rocky Linux VMs

The machine-readable infra02 inventory is:

```text
workspace.training/libvirt/inventory/infra02-vms.csv
```

Upload the inventory, provisioning script, and administration public key:

```bash
scp workspace.training/libvirt/inventory/infra02-vms.csv \
  midhtechadmin@infra02.example.com:/tmp/
scp workspace.training/scripts/provision-libvirt-vms.sh \
  midhtechadmin@infra02.example.com:/tmp/
scp ~/.ssh/id_rsa.pub \
  midhtechadmin@infra02.example.com:/tmp/midhtechadmin.pub
```

Review the plan:

```bash
/tmp/provision-libvirt-vms.sh plan
```

Create PostgreSQL as the first canary:

```bash
/tmp/provision-libvirt-vms.sh create postgres.example.com
```

The provisioning script creates thin qcow2 operating-system disks backed by
the verified Rocky image, separate sparse data disks, NoCloud seed media,
static networking, persistent MAC addresses, UEFI firmware, and autostarting
libvirt domains. It installs the guest agent, Chrony, Python and firewalld
through cloud-init.

Do not run `create-all` until the canary VM passes:

```bash
ssh midhtechadmin@192.168.1.125
sudo cloud-init status --wait
hostname -f
cat /etc/rocky-release
ip route
lsblk
systemctl is-active qemu-guest-agent chronyd firewalld
getenforce
```

After canary approval:

```bash
/tmp/provision-libvirt-vms.sh create-all
```

The operation is idempotent at the libvirt-domain level: an existing domain is
reported and left unchanged. VM deletion is intentionally not implemented in
this script.

Validate the complete fleet from the Mac administration workstation, where the
authorized private SSH key remains protected:

```bash
workspace.training/scripts/validate-libvirt-vms.sh
```

The validator reads the CSV directly, prevents SSH from consuming the
inventory stream, verifies the actual FQDN, requires cloud-init `done`, and
requires the guest agent, Chrony, and firewalld to be active. After the common
baseline is applied, it also requires an XFS `/data` mount and the baseline
state record.

Do not copy the Mac private key to infra02 or any VM. Running the validator on
infra02 will return SSH failures because the hypervisor intentionally has no
credential for logging into its guests.

## Apply the Rocky Linux Common Baseline

Run from the Mac administration workstation:

```bash
workspace.training/scripts/apply-rocky9-baseline.sh postgres.example.com
```

Validate the canary `/data` mount and SSH access, then apply the fleet:

```bash
workspace.training/scripts/apply-rocky9-baseline.sh all
```

The baseline is idempotent and:

- installs standard administration packages
- enables Chrony, firewalld, QEMU guest agent, and periodic filesystem trim
- creates `/opt/midhtech`
- creates an XFS filesystem on the empty `/dev/vdb` data disk
- mounts the data disk persistently at `/data` by UUID
- disables SSH passwords, root login, keyboard-interactive login, and X11
- validates SSH configuration before reloading the service
- records `/var/lib/midhtech/baseline-state`

The script refuses to overwrite a data disk containing a non-XFS filesystem.
VM-specific product automation owns all directories below `/data`.

## Change Record

| Date | Host | Change | Result |
| --- | --- | --- | --- |
| 2026-07-25 | `infra02.example.com` | Installed Ubuntu 26.04 LTS Desktop and enabled SSH | Host reachable at `192.168.1.73`; KVM device available |
| 2026-07-25 | `infra02.example.com` | First virtualization bootstrap attempt | OS upgrade completed; package installation stopped because `qemu-kvm` is virtual on Ubuntu 26.04 |
| 2026-07-25 | `infra02.example.com` | Second virtualization bootstrap attempt | `qemu-system-x86-hwe` conflicted with the standard `ubuntu-virt` dependency selected by libvirt |
| 2026-07-25 | `infra02.example.com` | Verified standard package transaction | `apt-get -s` resolved successfully with `qemu-system-x86`; revision 3 uploaded, rerun pending |
| 2026-07-25 | `infra02.example.com` | Completed revision 3 and rebooted | KVM, QEMU 10.2.1, libvirt 12.0.0, Ansible 2.20.1, Cockpit, Chrony and SSH validated |
| 2026-07-25 | `infra02.example.com` | Created `lab-images` storage pool | Persistent, active and autostart enabled with approximately 2.67 TiB available |
| 2026-07-25 | `infra02.example.com` | Inspected network baseline | `enp0s25` uses DHCP at `192.168.1.73`; NAT `virbr0` exists; physical bridge held behind documented safety gate |
| 2026-07-25 | `infra02.example.com` | Created physical bridge `br0` | `enp0s25` attached as a forwarding port; DHCP/default route moved successfully to `br0` |
| 2026-07-25 | `infra02.example.com` | Observed temporary SSH timeout | No rollback performed; DHCP changed the host from `.73` to `.169` and dynamic DNS subsequently converged |
| 2026-07-25 | `infra02.example.com` | Defined `lab-bridge` libvirt network | Active, persistent, autostart enabled, and attached to physical bridge `br0` |
| 2026-07-25 | `infra02.example.com` | Prepared Rocky Linux 9.8 cloud image | Official build `20260525.0` downloaded; SHA-256 passed; qcow2 metadata healthy |
| 2026-07-25 | Lab addressing | Approved VM range | `.101–.113` allocated to infra01, `.121–.131` to infra02; remaining addresses held for expansion |
| 2026-07-25 | `postgres.example.com` | Provisioned infra02 canary VM | Legacy BIOS boot produced no guest traffic; UEFI boot restored startup and all Rocky baseline checks passed |
| 2026-07-25 | infra02 VM fleet | Provisioned 11 Rocky Linux 9.8 VMs | All static addresses, FQDNs, cloud-init jobs, services, SELinux state, and disk allocations validated |
| 2026-07-25 | infra02 VM fleet | Applied common baseline | All data disks formatted XFS and mounted at `/data`; SSH hardening and baseline state applied |
| 2026-07-25 | Platform lifecycle | Adopted GitLab/AWX-first operating model | GitLab will be installed first, AWX second, and all other products will be installed and managed by AWX using Ansible sourced from GitLab |
| 2026-07-25 | `postgres.example.com` | Paused PostgreSQL lifecycle work pending AWX | Existing PostgreSQL 18.4 bootstrap preserved; no databases, roles, credentials, customization, backup, or upgrade work permitted before AWX |
| 2026-07-25 | `infra01.example.com` | Assessed GitLab/AWX VM readiness | Host reachable on Ubuntu 26.04 with 32 CPUs, 121 GiB RAM, 2.6 TiB free, and KVM available; libvirt, QEMU, `br0`, storage pool, and VM domains are not yet configured |
| 2026-07-25 | `infra01.example.com` | Refreshed VM readiness | `br0`, libvirt, `lab-bridge`, `lab-images`, and all 13 planned infra01 domains are present; GitLab, AWX, and DNS VMs now exist |
| 2026-07-25 | infra01 VM fleet | Detected concurrent lifecycle workflow | All 13 domains were cycled during DNS bootstrap; product configuration paused pending stable guests; see INC-2026-011 |
| 2026-07-25 | `dns.example.com` | Installed lab DNS through Ansible | BIND enabled and active; forward/reverse zones, UDP/TCP, recursion, firewall, and second-run idempotence validated; Copper9100 DHCP option remains manual |
| 2026-07-25 | Lab DNS | Added physical hypervisor records | Added A/PTR records for `infra01.example.com` at `.38` and `infra02.example.com` at `.169`; DHCP reservations remain required |
| 2026-07-25 | Linksys DHCP | Reserved lab infrastructure addresses | Verified 42 IP/MAC reservations: infra01 `.38`, infra02 `.169`, and deterministic VM assignments `.101–.140`; router DHCP restart completed and both hosts remained reachable |
| 2026-07-25 | Linksys device database | Planned stale-device cleanup | 824 records inspected: 42 connected, 42 reservation MACs protected, 3 customized offline records protected, and 779 disconnected uncustomized candidates; deletion requires explicit risk approval because firmware exposes no last-seen timestamp |
| 2026-07-25 | Mac administration workstation | Applied temporary lab DNS override | Wi-Fi DNS set to `192.168.1.106`; GitLab, AWX, and public recursion validated; permanent Linksys DNS advertisement remains pending |
| 2026-07-25 | `gitlab.example.com` | Created local source-control namespace | Private `maas-enterprise-cloud-platform` group and eight private projects created; all repository origins restricted to local GitLab |
| 2026-07-25 | GitLab repository fleet | Imported workspace source repositories | Eight clean `main` branches pushed and hash-verified; hard-coded database password removed from current code and reachable history before publication |
| 2026-07-26 | NGINX proxy tier | Approved clustered edge design | Allocated `nginx01` at `.114`, `nginx02` at `.132`, and floating proxy VIP `.140`; application service names use `*.apps.example.com` |
| 2026-07-26 | Hypervisor access | NGINX VM build preflight blocked | infra01 and infra02 unreachable by FQDN and direct IP; no live mutation attempted; see INC-2026-017 |
| 2026-07-26 | Prometheus addressing | Partially corrected configuration drift | BIND changed from occupied `.109` to canonical `.115`; Ansible was mistakenly reported corrected and was actually fixed during the 2026-07-27 audit; see INC-2026-018 |
| 2026-07-26 | Hypervisor access | Restored and revalidated | Both hosts, bridges, libvirt networks, GitLab, and DNS reachable; INC-2026-017 resolved |
| 2026-07-26 | NGINX proxy tier | Corrected HA scope violation | Removed the two newly created empty numbered VMs and all Keepalived/VRRP/VIP design; approved standalone `nginx.example.com` at `.114`; see INC-2026-019 |
| 2026-07-26 | `nginx.example.com` | Provisioned standalone reverse-proxy VM | Rocky Linux 9.8 VM created on infra01 with 2 vCPU, 2 GiB RAM, 30 GiB OS disk, 20 GiB data disk, and autostart |
| 2026-07-26 | `nginx.example.com` | Applied common baseline | Cloud-init complete; SELinux enforcing; SSH hardened; XFS `/data` mounted; core services active |
| 2026-07-26 | `nginx.example.com` | Installed NGINX through Ansible | NGINX 1.26.3 enabled and active; firewall, SELinux, configuration, health, GitLab routing, and zero-change second convergence validated |
| 2026-07-26 | Lab DNS | Published application service URLs | `nginx.example.com` and approved `*.apps.example.com` records resolve to `.114`; reverse lookup and zero-change second BIND convergence validated |
| 2026-07-27 | Enterprise VM topology | Reconciled live Elastic/Splunk VMs with source control | Recorded six provisioned-only VMs, DNS/proxy definitions, capacity constraints, product targets, migration paths, and INC-2026-020; corrected Prometheus Ansible address |
