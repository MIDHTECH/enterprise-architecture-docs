# CHG-2026-011: Velop Shared-Node Diagnostic

## Purpose

Identify the shared physical-path failure affecting infra01 and infra02 before
selecting another network correction. This is a read-only diagnostic stage
inside the active Argo CD prerequisite. It supersedes the unavailable
same-node port move in the infra01 uplink canary.

`CHG-2026-011` was cancelled by operator on 2026-08-09 before this diagnostic
stage was completed. The content below is retained as historical evidence and
decision support for any future successor change.

## Evidence and current conclusion

The operator identified the upstream device as a two-port Linksys Velop
`VLP01` and confirmed that infra01 and infra02 occupy its two Ethernet ports.
The device identity also matches the upstream bridge/STP neighbor previously
observed from infra03. The secret-bearing underside-label photograph is not
retained.

A 2026-08-09 read-only comparison found physical link events at matching
seconds on infra01 and infra02, including:

| Down | Up | infra01 | infra02 |
| --- | --- | --- | --- |
| 2026-08-08 13:24:09 | 13:24:40 | Observed | Observed |
| 2026-08-08 16:22:25 | 16:22:28 | Observed | Observed |
| 2026-08-08 16:35:27 | 16:35:30 | Observed | Observed |
| 2026-08-08 18:40:29 | 18:40:31 | Observed | Observed |
| 2026-08-09 07:28:20 | 07:28:23 | Observed | Observed |

A complete timestamp comparison from 2026-08-08 12:00 through the accepted
2026-08-09 14:19 rollback baseline found 21 carrier-down events on infra01 and
16 on infra02. Fourteen infra02 events matched infra01 in the exact same second
and the remaining two matched within two seconds. There was no infra02-only
event. Of the five infra01-only events, three were the documented Phase A and
rollback cable actions at 13:03:34, 13:04:25, and 14:17:57. The remaining two
were spontaneous events at 16:23:03 on Aug 8 and 07:28:59 on Aug 9.

After excluding the three deliberate cable actions, 16 of 18 spontaneous
infra01 events, or 88.9%, correlated with every infra02 event. infra03 recorded
no physical link-down/up event in the same inspected interval. The two
infra01-only events retain a possible secondary local cable/port contribution
but do not explain the dominant synchronized pattern.

Two independent host NICs and patch cables do not by themselves explain
same-second carrier loss on both ports of one upstream node. The evidence
therefore proves that the dominant failure boundary is shared by the two
Velop-connected hosts and moves the primary investigation to the node, its
power path, internal Ethernet switching, firmware restart behavior, or a
broader mesh/backhaul event that also resets the Ethernet ports. It does not
yet prove which of those mechanisms occurred.

At 15:17 local time on 2026-08-09, infra01, infra02, and infra03 retained
17/14/4 running and autostart domains. All three uplinks had carrier at 1 Gb/s
full duplex. infra01 remained at `carrier_changes=274` after Phase A rollback
with zero selected NIC errors and no later readable link event. infra02
reported `carrier_changes=304`, zero CRC/alignment/carrier/timeout errors, and
a large cumulative missed-receive count that is not assigned as a cause.

## Historical open read-only stage

At the time of cancellation, only the following evidence collection remained
open:

1. Photograph the Ethernet-port side of the identified `VLP01` without the
   secret-bearing underside label. Mark which occupied port/cable serves
   infra01 and which serves infra02.
2. Record the node's power-adapter model/rating, outlet or UPS path, connector
   condition, and whether another device on the same power source recorded an
   interruption. Do not unplug or reseat anything.
3. In the supported Linksys application, read and record only this node's role
   (primary or child), wired/wireless backhaul state, connectivity, uptime or
   last-restart data when exposed, and firmware/update history. Do not change a
   setting, restart a node, expose client inventory, or record credentials.
4. Identify the Velop node and backhaul used by infra03 without moving its
   cable. This determines whether the failed build path crossed from another
   mesh child to the shared infra01/infra02 node.
5. Correlate the shared carrier timestamps with known power, firmware update,
   Linksys administration, and mesh-connectivity events.

Connection-side and application screenshots are evidence only after secret,
QR, public-IP, and unrelated-client fields are excluded or redacted.

## Local management-path result

A secret-safe read-only check on 2026-08-09 opened the local Linksys Smart
Wi-Fi page at `192.168.1.1`. No authenticated browser session existed, and the
page remained behind its historical `Waiting...` overlay at the router-password
sign-in screen. No credential was entered and no setting or request payload was
submitted. The page exposed no trustworthy node role, uptime, firmware,
backhaul, port, or power evidence.

The desktop path is exhausted for this stage. Do not use the photographed
setup credentials, guess a router password, or invoke undocumented JNAP
actions. The supported Linksys application and onsite connection/power
inspection remain the required sources for the open evidence items.

## Historical decision gate

Before cancellation, the diagnostic had to assign one of these outcomes before
an execution design could be opened:

- **Power path:** shared-node power interruption or an unsafe adapter/connector
  is supported by evidence. Prepare a bounded power-path correction with both
  hypervisors' network impact, local consoles, exact replacement rating, and
  rollback documented.
- **Node restart or internal switching:** node uptime, firmware history, or
  correlated events support a device restart or Ethernet-switch reset. Prepare
  a supported node repair or like-for-like replacement plan; do not reset or
  factory-default the node.
- **Mesh/backhaul:** evidence supports loss or restart of the mesh path.
  Prepare a wired-backhaul or stable-router/access-switch design with explicit
  hardware, ports, loop prevention, addressing preservation, and migration
  order.
- **Unproven:** no mechanism is supported strongly enough. Prepare a durable
  lab-network migration design rather than repeating cable swaps or using
  transient success as acceptance.

A dedicated switch is not automatically a correction. A switch downstream of
an unstable Velop node may preserve local carrier while the infra03-to-control-
plane path still fails. Any switch design must identify a stable upstream path
and explain how it removes, rather than hides, the shared failure boundary.

## Prohibited actions

Until a successor change reviews a decision outcome and execution design, do
not:

- disconnect or swap infra01 or infra02;
- unplug, reseat, restart, reset, factory-default, update, or replace a Velop
  node or its power adapter;
- add a switch, change backhaul, or move a cable to another mesh node;
- change Linksys, DHCP, DNS, firewall, Wi-Fi, bridge, STP, VM, Kubernetes,
  Helm, or Argo CD configuration;
- run an Argo CD recovery PLAN or DEPLOY; or
- use label credentials, recovery keys, or undocumented router payloads.

## Historical diagnostic acceptance

Before the parent change was cancelled, this stage would have been accepted
only when:

1. both occupied ports, both host cables, the node role, the node power path,
   and infra03's mesh attachment are identified;
2. available node uptime, restart, firmware, and backhaul evidence is retained
   without secrets or unrelated client inventory;
3. the synchronized host events are correlated against that evidence;
4. one decision outcome is selected with stated confidence and alternatives;
5. the next execution has explicit impact, prerequisites, rollback, separated
   observation windows, and full VM/cluster acceptance; and
6. the sequential gate is updated and reviewed before physical execution.

Diagnostic acceptance does not accept the transport path or open Argo CD.
After cancellation, this diagnostic no longer represents an open stage.
