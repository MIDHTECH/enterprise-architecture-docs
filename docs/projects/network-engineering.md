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

## Executable Use-Case Scope

- IPAM, VLAN/subnet design, DHCP, DNS, network configuration backup, and drift detection.
- Routing, firewall policy, NAT/egress, load balancer/reverse proxy, VPN, cloud VPC/VNet, and hybrid connectivity.
- Kubernetes networking, CNI policy, ingress/egress controls, MetalLB, flow-log analysis, packet capture, and rollback.
