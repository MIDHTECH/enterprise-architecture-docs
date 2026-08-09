# CHG-2026-011: infra01 Uplink Physical-Path Canary

## Purpose

Correct the physical path now supported by carrier evidence: infra01's
`enp0s25` uplink, which hosts the Kubernetes control-plane VM behind `br0`.
This supersedes the earlier infra03-first cable canary. It remains a bounded
network prerequisite inside active CHG-2026-011, not a new platform component.

## Target selection evidence

Read-only host inspection found:

- infra01 `enp0s25` uses the `e1000e` driver, has PCI power control `on` and
  runtime status `active`, but reports 264 carrier changes;
- the infra01 kernel repeatedly recorded `NIC Link is Down`, followed by
  `NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx`, during the same
  operating day, including events at 16:22, 16:23, 16:35, 16:53, 17:09,
  17:20, 17:56, 18:07, 18:22, 18:35, and 18:40 local time;
- every down event disabled the `br0` port and every up event returned it to
  forwarding;
- infra03 `eno1` also has PCI power control `on` and runtime status `active`,
  but did not show corresponding physical link-down/up events in the same
  six-hour inspection window; and
- infra03's earlier `neighbor ... lost` messages were bridge STP
  message-age expirations and stopped after the accepted STP correction.

This does not yet distinguish an infra01 patch cable, upstream LAN port, or
Linksys/Velop/backhaul fault, but it does identify infra01 as the first physical
canary. Do not touch infra03's cable before the infra01 canary is completed and
documented.

## Scope and prohibitions

The only physical target is the cable between infra01 `enp0s25` and its exact
labeled upstream LAN port.

Permitted after the execution gate is explicitly opened:

1. identify and label infra01's current patch cable, upstream device or mesh
   node, and LAN port;
2. replace only the infra01 patch cable while retaining the same upstream
   port; and
3. if the same-port cable canary fails acceptance and is rolled back or
   documented, move only infra01 to one identified known-good LAN port on the
   same upstream device.

Prohibited:

- changing router, DHCP, DNS, IPv6, Wi-Fi, mesh, VLAN, firewall, STP, bridge,
  NetworkManager, libvirt, VM, Kubernetes, Helm, or Argo CD configuration;
- touching infra02 or infra03 cables or ports;
- changing more than one cable or port before validating and recording the
  preceding state;
- guessing an unlabeled port or using an undocumented router API payload;
- rebooting infra01 or cycling any VM; and
- running Argo CD PLAN or DEPLOY while any observation window is incomplete
  or non-zero-loss.

## Execution prerequisites

Before a physical step:

1. a human operator is present at infra01 with its local console available;
2. the exact current cable and upstream LAN port are identified and labeled;
3. a known-good Cat5e-or-better replacement cable is available;
4. GitLab has no running pipelines, Jenkins has an empty queue and no busy
   executor, and AWX has zero active unified jobs;
5. infra01/02/03 retain 17/14/4 running and autostart domains with no active
   infrastructure mutator;
6. infra01 retains `192.168.1.38/24`, its default route through `br0`,
   persistent STP `no`, live STP `0`, and forwarding physical and guest ports;
7. infra03 retains its accepted bridge and four-VM state; and
8. the application cluster has four Ready nodes, no active Jobs or non-running
   pods, and healthy Longhorn, ingress, and Headlamp state.

Documentation review and CI do not authorize physical execution by
themselves. The operator must confirm local-console presence and the exact
labeled target immediately before the step.

## Sequential canary procedure

### Phase A: same-port cable replacement

1. Record the upstream device/node, LAN port, cable label, link speed/duplex,
   `carrier_changes`, selected driver counters, bridge state, and all 17 VMs.
2. At the local console, replace only the infra01 patch cable while retaining
   the same upstream LAN port.
3. Confirm carrier, 1 Gb/s full duplex, canonical address/default route,
   forwarding bridge ports, 17 running/autostart VMs, and zero new NIC errors.
4. Run the separated-window acceptance below.
5. If any invariant or probe fails, restore the original cable on the same
   port and prove the rollback baseline before considering Phase B.

### Phase B: known-good port move

Phase B is eligible only when Phase A is documented as failed or insufficient.

1. Retain the accepted cable and move only infra01 to the one labeled,
   confirmed LAN port selected during review.
2. Confirm the same carrier, host, bridge, VM, and cluster invariants.
3. Run the full separated-window acceptance again.
4. On any failure, return infra01 to its original labeled port and prove the
   rollback baseline.

Do not proceed from Phase B to a mesh/backhaul topology change in the same
execution. A wireless-child or upstream-node finding requires a separate
reviewed design.

## Separated-window acceptance

Run complete windows immediately after convergence, after at least ten
minutes, and after at least thirty minutes. Do not run continuous warm-up
traffic between windows.

Every window must prove:

- infra01 `carrier_changes` is unchanged and no new kernel link-down/up event
  exists;
- no CRC, alignment, carrier, missed, FIFO, timeout, or collision counter
  increase on `enp0s25`;
- from each infra03 guest, 100/100 standard and 100/100 1,400-byte ICMP to
  control-plane address `192.168.1.107`;
- canonical control-plane neighbor MAC `52:54:00:01:01:07`;
- from each guest, 60/60 correct DNS resolutions for GitLab, Jenkins, and AWX;
- from each guest, 60/60 expected GitLab, Jenkins, AWX, and Kubernetes
  `/readyz` responses;
- canonical infra01/infra03 host, bridge, port, and VM state;
- idle GitLab, Jenkins, and AWX control planes; and
- four Ready Kubernetes nodes with healthy Longhorn, ingress, and Headlamp.

One failed probe or one new carrier event fails the window. Transient recovery
during follow-up does not convert a failure to accepted. After three clean
windows, run a fresh Jenkins recovery PLAN and repeat the independent
pre-DEPLOY probe before Helm.

## Rollback and evidence

Rollback restores the exact original labeled cable and port. It does not
recreate the bridge, restart NetworkManager, reboot infra01, cycle a VM, or
change router configuration. Stop if the local console cannot restore carrier,
the canonical address/default route, all 17 VMs, or the healthy cluster.

Retain before/after timestamps, cable and port labels, carrier and driver
counters, kernel link events, host/bridge/VM/cluster state, every observation
window, and any rollback result. Do not record a router password, authentication
material, or unrelated client inventory.

## Execution result: Phase A

Phase A ran on 2026-08-09 and failed the immediate zero-loss gate. The cable
replacement converged at 13:04:29 local time with 1 Gb/s full-duplex carrier,
`carrier_changes=272`, zero selected NIC errors, all 17 infra01 domains intact,
and the canonical bridge/address/route state preserved. Across the four infra03
guests, 800/800 combined standard and 1,400-byte ICMP probes and 720/720 DNS
checks passed. HTTP/API checks returned 959/960: app01 missed one Kubernetes
`/readyz` request while its GitLab, Jenkins and AWX checks each passed 60/60.

No new carrier or NIC error event accompanied the failed request, and the exact
response-code-versus-timeout mechanism was not captured. The failure remains a
failure under the approved rule. The operator restored the original cable on
the same port; rollback converged at 14:18:24 with `carrier_changes=274`, zero
selected NIC errors, 17/17 infra01 domains and four Ready Kubernetes nodes.

Phase B was initially eligible but not open. The exact current upstream
device/port label and one known-good candidate port on the same device had to
be added and reviewed first. See the
[Phase A result](../evidence/CHG-2026-011-infra01-uplink-phase-a-result.md).

## Upstream device identification

An operator-supplied underside-label photograph reviewed on 2026-08-09
identifies the upstream mesh node as a Linksys Velop model `VLP01`. The device
MAC printed on that label matches the upstream bridge/STP neighbor identity
previously observed from infra03, confirming that the photograph shows the
correct upstream node. The operator also confirmed that both infra01 and
infra02 are cabled to this same Velop node and that the node has two Ethernet
ports. Both ports are therefore occupied.

The photograph is not repository evidence because the label also contains
authentication and recovery material. No password, recovery key, serial
number, QR content, or complete device MAC was copied into this record.

This identifies the node but not the exact current infra01 port. The image does
not show the Ethernet-port side, attached cables, or port labels. More
importantly, the confirmed two-port/two-host topology proves that no
unoccupied same-node candidate port exists. Phase B is not executable under
this design. The port occupied by infra02 must not be disconnected, moved, or
used as a candidate. Stop for a separately reviewed canary redesign; do not
swap infra01 and infra02 or expand the physical scope ad hoc. A connection-side
photograph remains useful to label the two current host attachments, but it
cannot open the superseded same-node Phase B path.
