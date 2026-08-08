# CHG-2026-011 infra03 Network Prerequisite Result

Date: 2026-08-08

## Outcome

The infra03-only STP correction is accepted and idempotent. Initial
post-correction transport acceptance failed intermittently, but a later
validation-only window passed the complete sustained gate from all four
infra03 guests without any additional mutation. Argo CD recovery PLAN is
open; DEPLOY remains conditional on PLAN repeating the reachability gate.

## Accepted source and controlled execution

- Cloud-infrastructure protected-main revision:
  `7690ad3bde91c725e77c11e3ce6e034330943ef2`
- Jenkins shared-library protected-main revision:
  `5ccf022d29fecfda49b5441e249286969e67242f`
- Jenkins PLAN build 3 / AWX check job 874: success; only persistent and live
  STP convergence predicted
- Jenkins APPLY build 4 / AWX job 882: success; only the two approved STP
  tasks changed
- Jenkins VALIDATE build 5 / AWX job 890: success; zero changes and failures
- Jenkins idempotence APPLY build 6 / AWX job 898: success; zero changes

Two earlier PLAN attempts failed safely before mutation while the AWX machine
credential boundary was reconciled. No VM was restarted, stopped, or cycled,
and the bridge was not reconnected.

## Accepted infrastructure state

- persistent NetworkManager bridge policy: `bridge.stp=no`
- live bridge STP state: `0`
- infra03 domains: four running and four configured for autostart
- physical uplink and four guest ports: forwarding

## Failed transport acceptance

The required zero-loss gate remained intermittent after convergence:

- sequential 30-packet ICMP probes across the four guests returned 1/30,
  0/30, 3/30, and 23/30 replies;
- two extended HTTPS series stopped after 12 and 11 successful `/readyz`
  requests respectively;
- other isolated HTTPS series completed 60/60 or 100/100, demonstrating
  intermittent rather than permanent loss.

Read-only diagnostics verified canonical routing and neighbor MAC, correct
bridge FDB learning, healthy guest and control VMs, the Kubernetes API
listener and firewall allowance, and no source-specific filtering. The
control plane received requests and emitted responses. A failed directional
counter probe showed substantial reply traffic leaving the infra01 path while
only a small fraction arrived at infra03. This narrows the residual problem to
the physical/switch segment, but does not prove a particular cable, port, or
network device as the root cause.

## Recovery acceptance

A later independent window passed with no physical, router, switch, bridge,
VM, or Kubernetes mutation:

- each of the four guests passed 100/100 standard-size ICMP probes to
  `192.168.1.107` with zero loss;
- each guest passed a second 100/100 probe using a 1,400-byte payload with
  zero loss;
- every guest resolved GitLab, Jenkins, and AWX correctly on each of 60
  iterations, for 720 successful DNS checks in total;
- every guest completed 60 requests each to GitLab sign-in, Jenkins login,
  AWX ping, and Kubernetes `/readyz`, for 960 successful HTTP/HTTPS requests
  with zero timeout or unexpected status;
- every guest learned control-plane neighbor MAC `52:54:00:01:01:07`;
- infra03 retained persistent STP `no`, live STP `0`, four running/autostart
  domains, forwarding `eno1` and `vnet3`-`vnet6`, address
  `192.168.1.186/24`, and its default route through `br0`;
- GitLab had zero running pipelines, Jenkins had an empty queue and 0/1 busy
  executors, and AWX had zero active unified jobs; and
- the application cluster retained four Ready nodes, zero active Jobs or
  non-running pods, and healthy Longhorn, ingress, and Headlamp workloads.

No additional corrective action can be credited for the later recovery. The
known STP drift remains corrected, but the exact mechanism of the transient
post-correction loss is undetermined and remains under monitoring.

## Gate

Permit only the controlled Argo CD recovery PLAN against exact accepted
source. PLAN must repeat its initial API reachability checks before Helm. If
any transport probe fails, close the gate and do not run DEPLOY. If PLAN
passes, the same active change may proceed to its reviewed DEPLOY and GitOps
acceptance sequence.
