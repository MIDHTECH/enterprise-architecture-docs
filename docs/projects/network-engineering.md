# Network Engineering and Automation Domain

**Repository:** `midhhealth/platform-engineering/network-engineering-platform`  
**Team size:** 5 engineers

## Team Responsibilities

The network team owns source of truth, address management, DNS/DHCP,
connectivity, firewall policy, Kubernetes networking, and hybrid network
readiness.

| Team member | Primary responsibility |
| --- | --- |
| Network Platform Lead | Owns network standards, segmentation model, change policy, and cross-domain connectivity decisions. |
| IPAM and DNS Engineer | Maintains IPAM, subnets, DHCP reservations, forward/reverse DNS, and naming standards. |
| Connectivity Engineer | Owns routing, VPN, hybrid connectivity, NAT, load balancers, and reverse proxy integration. |
| Network Security Engineer | Maintains firewall policy, segmentation, private endpoints, TLS routing, and network compliance checks. |
| Network Observability Engineer | Owns flow logs, packet capture, blackbox testing, SNMP/exporter metrics, and rollback validation. |

## Connected Teams

- Provides connectivity for GitLab, Jenkins, AWX, Kubernetes, databases, observability, AI, and application traffic.
- Consumes infrastructure and Linux runtime details for host, VM, and cloud networking.
- Sends availability, flow, DNS, and change evidence to SRE and governance.

## Outcome and control role

This team owns whether an approved producer can reach an approved consumer
through the intended trust path. It validates the journey from the consumer
boundary; device configuration success alone does not prove connectivity or
safe isolation.

| Responsibility | Network-domain commitment |
| --- | --- |
| Decision owned | Allocate, route, resolve, allow, deny, expose, isolate, change or restore a named connectivity contract. |
| Evidence consumed | Producer/consumer identity, source and destination, protocol, data class, environment, route, policy, capacity and maintenance window. |
| Evidence published | Source-of-truth revision, config diff, DNS/IP allocation, policy decision, path/flow observation, latency/loss and rollback verification. |
| Safe-stop boundary | Unknown endpoint, overlapping address, missing route owner, broad policy expansion, failed precheck or lost management path blocks or reverses change. |
| Outcomes measured | Provisioning time, drift age, DNS correctness, policy exposure, availability, latency/loss, capacity headroom and rollback success. |

Network change follows the bounded decision loop in the
[Cross-Platform Outcome and Control Framework](../cross-platform-outcome-control-framework.md).

## Executable Use-Case Scope

- IPAM, VLAN/subnet design, DHCP, DNS, network configuration backup, and drift detection.
- Routing, firewall policy, NAT/egress, load balancer/reverse proxy, VPN, cloud VPC/VNet, and hybrid connectivity.
- Kubernetes networking, CNI policy, ingress/egress controls, MetalLB, flow-log analysis, packet capture, and rollback.

## The connectivity promise

Network engineering makes an approved producer-to-consumer path predictable,
observable and reversible. A DNS record, open port or successful local curl is
not the whole service path; each must be tied to ownership and tested from the
consumer boundary.

![Network engineering architecture](../assets/project-10-network-engineering-architecture.svg)

## Current lab topology and ownership

The active path includes physical host bridges, KVM/libvirt guest interfaces,
the lab LAN, BIND authoritative DNS, host firewalls, service-local or shared
NGINX where documented, the kubeadm pod network, CoreDNS, private
ingress-nginx and application Services. The canonical inventory and environment
pages own addresses and current endpoints; this page does not create a second
address source of truth.

Cloud VPC/VNet, VPN, private endpoint and managed load-balancer patterns remain
design work until a cloud target is approved. MetalLB is also a use-case design,
not evidence of installation. The accepted Kubernetes ingress path deliberately
uses private ClusterIP services and worker-local NGINX.

## Connectivity contract

| Question | Required answer |
| --- | --- |
| Who communicates? | Named source workload/user zone and destination service owner |
| Why? | Business or platform purpose and expected protocol behavior |
| How is it named? | Canonical forward/reverse DNS ownership and lifecycle |
| What is permitted? | Source, destination, protocol, port, direction and identity layer |
| How is it protected? | Segmentation, TLS expectation, secret/certificate ownership and logging |
| How is it tested? | Consumer-side DNS, route, TCP/TLS and application check plus negative paths |
| How is it reversed? | Previous record/rule/configuration and TTL/session implications |

## Implementation and change sequence

1. Resolve the intended path from inventory and dependency contracts; reject
   overlapping address or ambiguous ownership before configuration.
2. Capture pre-change DNS, route, listener, firewall and user-path evidence.
3. Validate configuration and generate the exact diff in the repository.
4. Apply through AWX to a canary or bounded target. Avoid changing DNS, proxy
   and firewall simultaneously unless the rollback dependency is understood.
5. Test from each required source and also prove prohibited sources or ports
   remain closed.
6. Observe connection errors, latency and service health through the TTL or
   connection-drain window before removing the old path.

## Kubernetes and hybrid handoffs

Cluster networking has distinct layers: node reachability, pod CIDR, CoreDNS,
Service routing, CNI policy and ingress/egress. A failure in one should not be
masked by changing another. Infrastructure owns cloud/on-prem network objects,
Linux owns host interfaces/firewall convergence, Kubernetes owns CNI and
Services, and this domain validates the complete path.

Hybrid connectivity additionally requires route ownership, overlapping-CIDR
analysis, DNS forwarding, MTU, failure behavior, monitoring and cost. A diagram
without those decisions is not implementation-ready.

## Failure and rollback

| Failure | Safe response |
| --- | --- |
| DNS wrong or stale | Compare authoritative answer, resolver path, TTL and serial; restore the prior record when needed |
| TCP unreachable | Check route, listener and firewalls from both ends before opening a new rule |
| TLS fails | Preserve hostname/SNI evidence and hand certificate trust to its owner; do not disable verification |
| Intermittent loss | Compare interface errors, MTU, saturation and path asymmetry with timestamps |
| Kubernetes service unreachable | Walk DNS → ingress → Service → endpoints → pod/network policy |
| Change cuts off automation | Use console/out-of-band recovery and the pre-recorded network rollback |

## Acceptance evidence

Acceptance binds source revision, inventory objects, configuration diff, AWX
job, pre/post tests from named locations, negative checks, flow/metric evidence,
DNS serial and TTL, rollback test and consumer-owner sign-off. Packet captures
are minimized and sanitized because payloads can contain credentials or health
data. Detailed scenarios remain in the
[network use-case index](../use-cases/network/README.md).
