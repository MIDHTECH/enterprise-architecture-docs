# Enterprise Network Engineering and Automation Platform: Detailed Use Cases

Last verified: 2026-08-13

This index contains all 31 canonical use cases owned by the
Enterprise Network Engineering and Automation Platform. Together they maintain trusted connectivity and service paths across the existing lab. Implementation belongs
in `midhhealth/platform-engineering/network-engineering-platform` and must reuse existing DNS, NGINX, KVM bridges, Kubernetes networking, GitLab, Jenkins, AWX, and blackbox checks.

No page in this directory authorizes a new router, switch, firewall appliance, VM, IP, VLAN, CNI, load balancer, VPN, or cloud network. All pages begin as
planned specifications; their individual status changes only after source,
runtime, rollback, and evidence gates are met.

| ID | Use case | Canonical coverage |
| --- | --- | --- |
| `UC-NET-002` | [Enterprise IP Address Management](UC-NET-002-enterprise-ip-address-management.md) | Governed address and prefix allocation |
| `UC-NET-003` | [VLAN and Subnet Design](UC-NET-003-vlan-and-subnet-design.md) | Standard segmentation and routing domains |
| `UC-NET-004` | [DHCP Reservation Management](UC-NET-004-dhcp-reservation-management.md) | Controlled address-to-MAC assignments |
| `UC-NET-005` | [Authoritative and Recursive DNS](UC-NET-005-authoritative-and-recursive-dns.md) | Managed internal name resolution |
| `UC-NET-006` | [Forward and Reverse DNS Automation](UC-NET-006-forward-and-reverse-dns-automation.md) | Synchronized A/PTR lifecycle |
| `UC-NET-007` | [Router and Switch Configuration Backup](UC-NET-007-router-and-switch-configuration-backup.md) | Recoverable network state |
| `UC-NET-008` | [Network Configuration Automation](UC-NET-008-network-configuration-automation.md) | Version-controlled Ansible changes |
| `UC-NET-009` | [Network Configuration-Drift Detection](UC-NET-009-network-configuration-drift-detection.md) | Desired versus running-state comparison |
| `UC-NET-010` | [Layer 2 Bridge Management](UC-NET-010-layer-2-bridge-management.md) | Host and virtualization switching |
| `UC-NET-011` | [Layer 3 Routing](UC-NET-011-layer-3-routing.md) | Static and dynamic route control |
| `UC-NET-012` | [Firewall Policy Management](UC-NET-012-firewall-policy-management.md) | Reviewed least-privilege traffic policy |
| `UC-NET-013` | [NAT and Egress Management](UC-NET-013-nat-and-egress-management.md) | Controlled outbound and translation paths |
| `UC-NET-014` | [Load Balancer and Reverse Proxy Configuration](UC-NET-014-load-balancer-and-reverse-proxy-configuration.md) | Standard application entry points |
| `UC-NET-015` | [VPN and Remote Access](UC-NET-015-vpn-and-remote-access.md) | Managed encrypted administration connectivity |
| `UC-NET-016` | [Cloud VPC and VNet Networking](UC-NET-016-cloud-vpc-and-vnet-networking.md) | Reusable cloud network foundations |
| `UC-NET-017` | [Hybrid-Cloud Connectivity](UC-NET-017-hybrid-cloud-connectivity.md) | Routed and secured environment integration |
| `UC-NET-018` | [Kubernetes Networking](UC-NET-018-kubernetes-networking.md) | Cluster dataplane and service networking |
| `UC-NET-019` | [CNI Policy and Troubleshooting](UC-NET-019-cni-policy-and-troubleshooting.md) | Cilium/Hubble policy and visibility |
| `UC-NET-020` | [Ingress and Egress Controls](UC-NET-020-ingress-and-egress-controls.md) | Governed workload traffic paths |
| `UC-NET-021` | [MetalLB Address Management](UC-NET-021-metallb-address-management.md) | Controlled service address pools |
| `UC-NET-022` | [Network Segmentation](UC-NET-022-network-segmentation.md) | Environment and trust-zone isolation |
| `UC-NET-023` | [Private Endpoint and Private DNS](UC-NET-023-private-endpoint-and-private-dns.md) | Non-public managed-service access |
| `UC-NET-024` | [Certificate and TLS Routing](UC-NET-024-certificate-and-tls-routing.md) | Trusted encrypted service entry |
| `UC-NET-025` | [Network Performance Monitoring](UC-NET-025-network-performance-monitoring.md) | Latency, loss, throughput and saturation |
| `UC-NET-026` | [Flow-Log Analysis](UC-NET-026-flow-log-analysis.md) | Traffic behavior and security investigation |
| `UC-NET-027` | [Packet Capture and Troubleshooting](UC-NET-027-packet-capture-and-troubleshooting.md) | Evidence-based protocol diagnosis |
| `UC-NET-028` | [Network Availability Testing](UC-NET-028-network-availability-testing.md) | Synthetic and blackbox validation |
| `UC-NET-029` | [Network Configuration Compliance](UC-NET-029-network-configuration-compliance.md) | Auditable device and service standards |
| `UC-NET-030` | [Network Incident Response](UC-NET-030-network-incident-response.md) | Repeatable diagnosis and restoration |
| `UC-NET-031` | [Capacity and Bandwidth Planning](UC-NET-031-capacity-and-bandwidth-planning.md) | Forecasted network growth |
| `UC-NET-001` | [Network Change Validation and Rollback](UC-NET-001-network-change-validation.md) | Pre/post checks and safe recovery |

## GitLab handoff

1. Create the epic and stories from the selected page in `midhhealth/platform-engineering/network-engineering-platform`.
2. Implement only the planned paths that fit the repository and current lab.
3. Run fixture or read-only validation before requesting a mutating change.
4. Return commit, pipeline, Jenkins/AWX, runtime, recovery, and incident
   evidence to the architecture page.
5. Stop and request a separate architecture decision if new infrastructure,
   capacity, products, or protected-data integration would be required.

