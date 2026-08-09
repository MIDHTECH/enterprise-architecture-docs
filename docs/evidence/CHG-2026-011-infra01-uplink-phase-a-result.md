# CHG-2026-011 infra01 Uplink Phase A Result

Date: 2026-08-09

## Outcome

Phase A did not satisfy the zero-loss acceptance gate. The operator replaced
infra01's `enp0s25` patch cable while retaining the same upstream port, but the
immediate four-guest window recorded one failed Kubernetes `/readyz` request
from `gitlab-runner-app01.example.com`. The original cable was restored on the
same port and the rollback baseline passed.

Argo CD PLAN and DEPLOY remain closed. Phase B is eligible only after the
current upstream device/port and one known-good candidate port on that same
device are identified by exact labels and reviewed. No port move has occurred.

## Pre-execution gate

The approved canary was published through merge request !31 at merge revision
`202acfa12b254c48cc65b919bd21f670fbd5c870`; branch pipeline 624 and canonical-
main pipeline 625 passed. Immediately before Phase A:

- GitLab reported zero active pipelines and builds;
- Jenkins had an empty queue and zero durable-task markers;
- AWX reported zero active unified jobs;
- infra01/02/03 retained 17/14/4 running and autostart domains with no active
  Git, Ansible, Terraform, package, VM, Helm or kubectl mutator;
- the application cluster retained four Ready Kubernetes 1.34.10 nodes, no
  active Jobs or non-running pods, and healthy Longhorn, ingress and Headlamp;
- infra01 retained `192.168.1.38/24`, its default route through `br0`, live STP
  `0`, all bridge ports forwarding and 1 Gb/s full-duplex carrier;
- `enp0s25` reported `carrier_changes=268` with zero CRC, alignment, missed,
  carrier, FIFO, timeout and collision counters; and
- the operator confirmed local-console presence, a labeled same-port target
  and a known-good Cat5e-or-better replacement cable. The label values were not
  supplied to the evidence record and must be recorded before Phase B.

Two additional spontaneous link cycles had already occurred at 07:28:20-
07:28:23 and 07:28:59-07:29:02 local time, increasing the earlier documented
carrier count from 264 to 268 before the canary.

## Phase A execution

The physical step produced two observed link cycles:

| Event | Local time | Result |
| --- | --- | --- |
| First carrier down | 13:03:34 | `br0` physical port entered disabled state |
| First carrier up | 13:03:50 | 1 Gb/s full duplex; port returned to forwarding |
| Second carrier down | 13:04:25 | `br0` physical port entered disabled state |
| Final carrier up | 13:04:29 | 1 Gb/s full duplex; port returned to forwarding |

After final convergence, `carrier_changes=272`, all 17 infra01 domains remained
running and autostarted, the canonical address/default route and STP state were
unchanged, every bridge port was forwarding, and selected NIC error counters
remained zero. No VM was stopped, restarted or cycled, and no network, router,
bridge, Kubernetes or application configuration changed.

## Immediate acceptance window

The immediate window started after the final 13:04:29 carrier convergence and
ran in parallel from the four infra03 build-execution guests.

| Guest | Standard ICMP | 1,400-byte ICMP | DNS | HTTP/API | Neighbor MAC | Result |
| --- | ---: | ---: | ---: | ---: | --- | --- |
| `gitlab-runner-app01.example.com` | 100/100 | 100/100 | 180/180 | 239/240 | `52:54:00:01:01:07` | Failed |
| `gitlab-runner-infra01.example.com` | 100/100 | 100/100 | 180/180 | 240/240 | `52:54:00:01:01:07` | Passed |
| `jenkins-agent01.example.com` | 100/100 | 100/100 | 180/180 | 240/240 | `52:54:00:01:01:07` | Passed |
| `gitlab-runner-shared01.example.com` | 100/100 | 100/100 | 180/180 | 240/240 | `52:54:00:01:01:07` | Passed |
| **Total** | **400/400** | **400/400** | **720/720** | **959/960** | **Correct on all guests** | **Failed** |

Server access logs independently recorded 60/60 HTTP 200 responses from app01
for GitLab, Jenkins and AWX. The one failed app01 request was therefore the
Kubernetes `/readyz` check. The probe recorded only a non-200-or-timeout result
and suppressed curl's detailed error, so it cannot distinguish a response code,
connect/TLS failure or three-second total timeout. This diagnostic limitation
does not convert the failed request to success. A later successful login or
readiness request is transient recovery, not acceptance.

Post-window inspection found `carrier_changes=272`, no new infra01 link event,
zero selected infra01 and infra03 NIC error counters, no infra03 carrier event,
zero errors/drops on app01's host-side `vnet5`, no Kubernetes event or API-
server error, and a currently healthy local `/readyz` response. Guest receive-
drop counters were cumulative and not unique to app01, so they do not establish
the cause. The exact one-request failure mechanism remains unproven.

## Rollback

The operator restored the original cable on the same upstream port. Infra01
recorded carrier down at 14:17:57 and carrier up at 14:18:24. At 14:19:22:

- `carrier_changes=274`, carrier was present at 1 Gb/s full duplex and the
  physical bridge port was forwarding;
- the canonical address, default route and live STP `0` remained intact;
- selected NIC error counters remained zero;
- all 17 infra01 domains were running and configured for autostart;
- all four Kubernetes nodes were Ready with zero active Jobs and no non-running
  pods; and
- the control-plane-local `/readyz` check returned HTTP 200 in 0.039 seconds.

The rollback baseline is accepted. Phase A remains failed, and the original
cable/port state is retained.

## Gate

Do not run another acceptance window, Argo CD PLAN or DEPLOY. Before Phase B:

1. record the exact current upstream device and LAN-port label;
2. record one exact known-good LAN-port label on the same upstream device;
3. confirm local-console presence and re-run the activity/invariant audit; and
4. update the probe to retain endpoint, response code, duration and curl error
   for every failed request.

Phase B may move only infra01 to that reviewed port. It may not change a mesh
node, router configuration, another host cable, DHCP, DNS, bridge, VM or
Kubernetes configuration.
