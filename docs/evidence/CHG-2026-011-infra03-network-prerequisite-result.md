# CHG-2026-011 infra03 Network Prerequisite Result

Date: 2026-08-08

## Outcome

The infra03-only STP correction is accepted and idempotent. The broader
transport prerequisite is not accepted because intermittent packet loss
persists on the infra01-to-infra03 path. Argo CD PLAN/DEPLOY remains closed.

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

## Gate

Do not retry Argo CD. Further mutation requires a separately reviewed,
explicitly scoped network-path prerequisite. Acceptance requires sustained
zero-loss ICMP and HTTPS/API probes from every infra03 guest while GitLab,
Jenkins, AWX, the four-node cluster, Longhorn, ingress, and Headlamp remain
healthy.
