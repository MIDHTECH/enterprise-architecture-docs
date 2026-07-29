# Lab DNS Installation and Copper9100 Client Configuration

## Purpose

`dns.example.com` provides authoritative forward and reverse records for the
on-premises lab and recursive DNS for clients on `192.168.1.0/24` and
Kubernetes pods on `10.244.0.0/16`. The
Copper9100 DHCP service must advertise this server so connected clients can
resolve lab names without editing local hosts files.

DNS is a network bootstrap dependency, not an exception permitting manual
installation of other products. After DNS, GitLab remains the first platform
product and AWX the second.

## Current Status

As of 2026-07-29, BIND is installed, enabled, and active. Forward, reverse,
UDP, TCP, and recursive lookups pass, and the Ansible role has converged with
`changed=0`, `failed=0`, and `unreachable=0`.

The managed query and recursion ACL includes both `192.168.1.0/24` and the
Kubernetes pod CIDR `10.244.0.0/16`. CoreDNS forwards `example.com` only to
`192.168.1.106`; all other names use the normal node upstreams.

Zone serial `2026072801` includes the physical hosts, all 31 VMs, reverse
records, and approved `*.apps.example.com` service names at `.114`. The latest
records add Elasticsearch nodes `.116`, `.133`, and `.134`; Kibana `.117`;
Splunk `.118`; Logstash `.135`; and the Kibana/Splunk application aliases.

The Linksys router now contains 63 verified DHCP reservations: infra01,
infra02, infra03, and every address from `.101` through `.160`. Automatic client DNS
adoption is still pending the Linksys-app change below. Until that change is
applied and leases are renewed, clients continue receiving `192.168.1.1` as
their DNS server.

Clients may also receive router IPv6 resolver
`2603:300c:571:c280:ea9f:80ff:feec:54af`. macOS prefers that resolver and will
return no answer for the internal zone. This is tracked as INC-2026-014.

The Mac administration workstation uses `/etc/resolver/example.com` for
domain-scoped split DNS through `192.168.1.106`. GitLab, AWX, NGINX,
application service names, and public recursive lookups are validated.

## Addressing

| Setting | Value |
| --- | --- |
| DNS VM | `dns.example.com` |
| DNS address | `192.168.1.106` |
| Internal zone | `example.com` |
| Reverse zone | `1.168.192.in-addr.arpa` |
| Permitted client networks | `192.168.1.0/24`, `10.244.0.0/16` |
| Current Copper9100 gateway/DHCP server | `192.168.1.1` |

The router must reserve `192.168.1.106` for the DNS VM. The complete VM range
`192.168.1.101–192.168.1.160` must remain outside the general DHCP pool.

The authoritative zone also includes the physical hypervisors:

| Record | Current address | Required network control |
| --- | --- | --- |
| `infra01.example.com` | `192.168.1.38` | DHCP reservation for the infra01 `br0` MAC |
| `infra02.example.com` | `192.168.1.169` | DHCP reservation for the infra02 `br0` MAC |
| `infra03.example.com` | `192.168.1.186` | DHCP reservation for physical/bridged MAC `b8:ca:3a:95:ea:b0` |

These addresses originated through DHCP. Staff must update the zone serial and
records if either address changes, but the preferred control is a permanent
gateway reservation for each bridge MAC.

### Linksys DHCP reservation automation

The Linksys router cannot reserve a bare IP range: each reservation requires a
unique IP/MAC pair. The controlled reservation script therefore creates:

- `192.168.1.38` for infra01 bridge MAC `ba:31:a8:bf:4b:da`;
- `192.168.1.169` for infra02 bridge MAC `96:df:df:6e:93:36`;
- `192.168.1.186` for infra03 physical and future cloned bridge MAC
  `b8:ca:3a:95:ea:b0`;
- all addresses from `192.168.1.101` through `192.168.1.160`, using the
  deterministic libvirt MAC convention in `vm-inventory.md`.

Run a read-only plan, then apply:

```bash
workspace.training/scripts/configure-linksys-dhcp-reservations.sh plan
workspace.training/scripts/configure-linksys-dhcp-reservations.sh apply
workspace.training/scripts/configure-linksys-dhcp-reservations.sh verify
```

The script prompts for the router password without echoing or storing it,
preserves unrelated LAN/DHCP fields, and verifies all 63 reservations after the
write. Future VMs assigned an expansion address must use the corresponding
reserved deterministic MAC address.

### Linksys stale-device cleanup

The Linksys device database does not expose a reliable last-seen timestamp.
Use a conservative state-based cleanup instead:

```bash
workspace.training/scripts/cleanup-linksys-stale-devices.sh plan
workspace.training/scripts/cleanup-linksys-stale-devices.sh apply
workspace.training/scripts/cleanup-linksys-stale-devices.sh verify
```

The script deletes only records that are disconnected, are not the router
authority, have no custom properties, and do not use any MAC protected by the
DHCP reservation table. Connected devices, hypervisors, reserved VM MACs, and
offline devices with custom names or metadata are preserved. An interrupted
run can be resumed safely because deleted device IDs disappear from the next
plan.

## Installation

During the control-plane bootstrap only, run the DNS playbook from an approved
Ansible controller:

```bash
cd workspace.training/cloud-infra-automation-platform/ansible
ansible-playbook -i inventory/onprem.yml playbooks/dns.yml \
  --syntax-check
ansible-playbook -i inventory/onprem.yml playbooks/dns.yml \
  --check --diff
ansible-playbook -i inventory/onprem.yml playbooks/dns.yml
```

The `bind_dns` role:

- installs BIND and its diagnostic tools;
- serves authoritative `A` and `PTR` records for the VM inventory;
- forwards non-lab queries to the approved external resolvers;
- restricts queries and recursion to localhost, `192.168.1.0/24`, and
  `10.244.0.0/16`;
- permits TCP and UDP port 53 through firewalld;
- validates zone syntax and both authoritative and recursive lookups.

## Kubernetes CoreDNS Integration

The Kubernetes `coredns` role in
`midhhealth/platform-engineering/ansible-kubernetes` manages an explicit
`example.com` server block:

```text
example.com:53 {
    errors
    cache 30
    forward . 192.168.1.106
}
```

Do not forward the private zone through the node's general
`/etc/resolv.conf`. Nodes also receive the router resolver as a secondary
server, and that resolver returns empty or negative answers for private names.

After changing the BIND ACL or CoreDNS configuration:

1. validate BIND with `named-checkconf`;
2. reload BIND;
3. roll out the CoreDNS deployment;
4. run at least three private-zone lookups from a pod pinned to every worker;
5. require the canonical answer on every lookup.

The 2026-07-29 acceptance test returned `192.168.1.131` for
`otel.example.com` three consecutive times on worker01, worker02, and worker03.
See INC-2026-037 and INC-2026-038.

## Manual Copper9100 DHCP Step

Sign in to the gateway at `http://192.168.1.1` using the authorized network
administrator account. In its LAN DHCP settings:

1. Set the primary DNS server distributed by DHCP to `192.168.1.106`.
2. Leave secondary DNS empty when the gateway permits it. Do not advertise
   `192.168.1.1` or a public resolver as secondary because clients could bypass
   internal DNS and fail to resolve `*.example.com`.
3. Save/apply the configuration.
4. Reconnect a test client to Copper9100 or renew its DHCP lease.

Router interfaces use different labels. Do not disable the router DHCP service
unless a separate, reviewed DHCP migration has been approved. If the gateway
does not allow a custom LAN DNS server, stop and use the documented alternative
design: disable router DHCP and move DHCP to a separately reviewed redundant
service. Running two DHCP servers on the same LAN is prohibited.

For the installed Linksys Mesh firmware, use the Linksys mobile app:
**Advanced Settings → Local Network Settings → DNS Settings → Manual**. The
authenticated desktop interface remained on its `Waiting...` overlay and did
not expose the Local Network applet. Do not guess an undocumented API payload.
Linksys documents the supported app workflow at:
`https://support.linksys.com/kb/article/360-en/`.

### IPv6 safeguard

The gateway currently advertises IPv6 DNS. IPv6 clients may bypass the IPv4
lab resolver. Until `dns.example.com` has a reserved IPv6 address, either
disable IPv6 DNS/RDNSS advertisement for Copper9100 or configure the gateway
to advertise an approved stable IPv6 address for the DNS VM. Do not advertise
an IPv6 public resolver alongside the internal IPv4 resolver.

### Temporary macOS remediation

`networksetup -setdnsservers "Wi-Fi"` changes the entire macOS Wi-Fi network
service, not one SSID. It is acceptable only while the Mac remains on
Copper9100:

```bash
sudo networksetup -setdnsservers "Wi-Fi" 192.168.1.106
sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder
```

Validate:

```bash
networksetup -getdnsservers "Wi-Fi"
nslookup gitlab.example.com
nslookup awx.example.com
```

To return the Mac to DHCP-provided DNS after the router is corrected:

```bash
sudo networksetup -setdnsservers "Wi-Fi" Empty
```

For a safer temporary split-DNS configuration, restore DHCP-provided Wi-Fi DNS
and route only the internal zone to the lab server:

```bash
sudo networksetup -setdnsservers "Wi-Fi" Empty
sudo mkdir -p /etc/resolver
printf 'nameserver 192.168.1.106\n' |
  sudo tee /etc/resolver/example.com >/dev/null
sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder
```

This configuration is domain-scoped rather than SSID-scoped: public DNS keeps
using the current network, while `*.example.com` uses the lab resolver when it
is reachable. Validate through the macOS system resolver:

```bash
dscacheutil -q host -a name gitlab.example.com
dscacheutil -q host -a name awx.example.com
dscacheutil -q host -a name nginx.example.com
dscacheutil -q host -a name gitlab.apps.example.com
```

Command-line tools such as `dig` and `nslookup` may query the default resolver
directly and are not authoritative tests of macOS supplemental resolver
routing.

Validated on the Mac administration workstation:

- `scutil --dns` shows a supplemental `example.com` resolver using
  `192.168.1.106`;
- `dscacheutil` resolves GitLab to `.101` and AWX to `.103`;
- `ping gitlab.example.com` resolves through the system resolver and succeeds;
- `nslookup` still reports the router IPv6 resolver and no answer because it
  bypasses macOS supplemental resolver selection.

## Validation

On the DNS VM:

```bash
sudo named-checkconf
sudo named-checkzone example.com /var/named/example.com.zone
sudo named-checkzone 1.168.192.in-addr.arpa /var/named/192.168.1.zone
dig +short @192.168.1.106 gitlab.example.com
dig +short @192.168.1.106 -x 192.168.1.103
dig +short @192.168.1.106 www.redhat.com
sudo systemctl is-active named
```

On a newly reconnected Copper9100 client:

```bash
nslookup gitlab.example.com
nslookup awx.example.com
nslookup www.redhat.com
```

Expected results include `192.168.1.101` for GitLab and `192.168.1.103` for
AWX. `nginx.example.com` and the application service names return
`192.168.1.114`. Confirm the client received `192.168.1.106` as its DNS
server.

## Change Control

Increment `bind_dns_serial` whenever zone records change. Commit and review the
inventory and role changes in GitLab, then deploy through AWX after the AWX
control plane becomes available.
