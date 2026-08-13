# CHG-2026-011: infra03 Physical-Path Canary

> **Superseded:** Later read-only evidence found repeated physical carrier
> loss and 1 Gb/s renegotiation on infra01 `enp0s25`, while infra03's logged
> neighbor-loss events were STP message-age expirations that stopped after the
> accepted correction. Do not execute this infra03-first plan. Use the
> [infra01 uplink canary](CHG-2026-011-infra01-uplink-canary.md).

## Purpose

Restore deterministic transport between the four infra03 build-execution VMs
and the infra01-hosted Kubernetes control plane without changing Kubernetes,
VMs, the Linux bridge, DHCP, DNS, or another hypervisor. This is a bounded
network prerequisite inside active CHG-2026-011, not a new platform component.

## Evidence requiring the canary

- The reviewed infra03 STP correction is accepted and idempotent.
- Intermittent loss persisted after that correction, including synchronized
  guest failures and directional evidence that replies left infra01 but did
  not consistently arrive at infra03.
- A later four-guest window passed 800/800 ICMP probes, 720/720 DNS checks,
  and 960/960 service/API requests.
- Recovery PLAN build 9 passed without mutation, but the independent
  pre-DEPLOY Jenkins-agent check then returned 6/20 ICMP replies and a
  Kubernetes `/readyz` timeout. DEPLOY was not started.
- Immediate follow-up recovered, proving that a traffic-warmed window is not
  sufficient acceptance.

The remaining evidence is consistent with an intermittent cable, upstream
LAN port, Linksys/Velop node, or wired/wireless backhaul forwarding problem.
It does not prove which one. The canary changes one physical variable at a
time and records the exact result.

## Scope and prohibitions

The only target is infra03's `eno1` physical path upstream of `lab-br0`.

Permitted after the execution gate is explicitly opened:

1. identify and label infra03's current cable, upstream device or mesh node,
   and LAN port;
2. replace only the infra03 Ethernet patch cable on the same port;
3. if the same-port cable canary fails acceptance and is rolled back or
   documented, move only infra03 to one identified known-good LAN port on the
   same upstream device; and
4. if evidence proves infra03 is homed through a wireless mesh child, prepare
   a separately reviewed wired-homing step to the primary LAN or an approved
   wired switch path.

Prohibited:

- router, DHCP, DNS, IPv6, Wi-Fi, mesh, VLAN, firewall, STP, bridge, NetworkManager,
  libvirt, VM, Kubernetes, Helm, or Argo CD configuration changes;
- touching infra01 or infra02 cables or ports;
- changing more than one cable or port before validating and recording the
  preceding state;
- guessing an unlabeled port or using an undocumented router API payload; and
- running Argo CD PLAN or DEPLOY while any observation window is incomplete
  or non-zero-loss.

## Execution prerequisites

Before a physical step:

1. a human operator is present at infra03 with its local console available;
2. the exact current cable and upstream port are identified and photographed
   or labeled without recording credentials or unrelated client data;
3. the replacement cable is a known-good Cat5e-or-better cable and the
   candidate port is confirmed as a LAN port;
4. GitLab has no running pipelines, Jenkins has an empty queue and no busy
   executor, and AWX has zero active unified jobs;
5. infra01/02/03 retain 17/14/4 running domains, infra03 retains four
   autostart domains, and no infrastructure mutator is active;
6. infra03 retains `192.168.1.186/24`, its default route through `br0`,
   persistent STP `no`, live STP `0`, and forwarding `eno1` plus
   `vnet3`-`vnet6`; and
7. the application cluster has four Ready nodes, no active Jobs or non-running
   pods, and healthy Longhorn, ingress, and Headlamp state.

Documentation review and CI do not authorize a physical step by themselves.
The operator must confirm local-console presence and the exact labeled target
before execution begins.

## Sequential canary procedure

### Phase A: same-port cable replacement

1. Record the current upstream device/node, LAN port, cable label, infra03
   link speed/duplex, driver counters, bridge state, and VM state.
2. At the local console, replace only the infra03 cable while retaining the
   same upstream LAN port.
3. Confirm carrier, 1 Gb/s full duplex, canonical address/default route,
   forwarding bridge ports, four running/autostart VMs, and zero new NIC
   errors.
4. Run the separated-window acceptance below.
5. If any invariant or probe fails, restore the original cable on the same
   port and verify the rollback baseline before considering Phase B.

### Phase B: known-good port move

Phase B is eligible only when Phase A is documented as failed or insufficient.

1. Retain the accepted cable and move only infra03 to the one labeled,
   confirmed LAN port selected during review.
2. Confirm the same carrier, host, bridge, VM, and cluster invariants.
3. Run the full separated-window acceptance again.
4. On any failure, return infra03 to its original labeled port and verify the
   rollback baseline.

Do not proceed from Phase B to a mesh/backhaul topology change in the same
execution. A wireless-child finding must be documented and reviewed first.

## Separated-window acceptance

Run three complete windows: immediately after convergence, after at least ten
minutes, and after at least thirty minutes. Do not run continuous warm-up
traffic between windows.

Every window must prove:

- from each of the four infra03 guests, 100/100 standard ICMP and 100/100
  1,400-byte ICMP to `192.168.1.107`;
- the canonical control-plane neighbor MAC `52:54:00:01:01:07`;
- 60/60 correct DNS resolutions for GitLab, Jenkins, and AWX from each guest;
- 60/60 expected responses from GitLab sign-in, Jenkins login, AWX ping, and
  Kubernetes `/readyz` from each guest;
- no CRC, alignment, carrier, missed, FIFO, timeout, or collision counter
  increase on infra03 `eno1`;
- canonical infra03 host, bridge, port, and VM state;
- idle GitLab, Jenkins, and AWX control planes; and
- four Ready Kubernetes nodes with healthy Longhorn, ingress, and Headlamp.

One failed probe fails the window. Transient recovery during follow-up does
not convert a failed window to accepted. After three zero-loss windows, run a
fresh Jenkins recovery PLAN and repeat the independent pre-DEPLOY check before
Helm.

## Rollback and evidence

Rollback restores the exact original labeled cable and port; it does not
recreate the bridge, restart NetworkManager, cycle a VM, or change router
configuration. Stop if the local console cannot restore carrier, the canonical
address/default route, all four VMs, or the healthy cluster.

Retain the following without secrets or unrelated client inventory:

- before/after timestamp, cable label, upstream device/node, and LAN port;
- link speed/duplex and selected NIC counters;
- host, bridge, VM, and cluster pre/post state;
- every separated-window result;
- rollback result when used; and
- the exact decision to accept Phase A, advance to Phase B, or stop for a
  separately reviewed wired-homing design.
