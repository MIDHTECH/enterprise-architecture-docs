# Canonical VM Inventory

This document is the source of truth for Rocky Linux 9 virtual machines in the
MidhHealth enterprise platform environment. The physical hypervisors run Ubuntu
26.04 LTS with GNOME, KVM/QEMU, libvirt, cloud-init tooling, and Ansible.

## Naming Standard

- A standalone product uses its product name: `gitlab.example.com`.
- Numeric suffixes are used only for members of a cluster:
  `k8s-worker01.example.com`.
- The lab does not implement HA. The standalone reverse proxy is
  `nginx.example.com`; clients use `*.apps.example.com` through that VM.
- The libvirt domain name, operating-system hostname, DNS record, monitoring
  target, and configuration-management inventory name must match.
- `example.com` is an internal split-DNS training zone. Public certificates
  require a domain owned by the organization; the lab uses an internal CA.

## Physical Hosts

| Host | Management address | Operating system | Role |
| --- | --- | --- | --- |
| `infra01.example.com` | `192.168.1.38/24` | Ubuntu 26.04 LTS Desktop | KVM compute host A |
| `infra02.example.com` | `192.168.1.169/24` | Ubuntu 26.04 LTS Desktop | KVM compute host B |

The default gateway is `192.168.1.1`. The authoritative lab resolver is
`192.168.1.106`; router DNS advertisement remains a documented follow-up. VM
addresses use the approved static range
`192.168.1.101–192.168.1.140`, which must remain excluded from general DHCP
allocation. Do not assign an address merely because it does not answer a ping.

## Address and MAC Allocation

Addresses `.101–.118` except `.109` are allocated to infra01 and
`.121–.135` except `.132` to infra02. Address `.109` remains occupied by a
non-lab LAN device and is not assigned to a VM.
Addresses `.119–.120`, `.132`, and `.136–.140` remain reserved for expansion. MAC
addresses are persistent configuration and must not be regenerated during a VM
rebuild.

| VM FQDN | Hypervisor | IPv4 address | MAC address |
| --- | --- | --- | --- |
| `gitlab.example.com` | infra01 | `192.168.1.101` | `52:54:00:01:01:01` |
| `jenkins.example.com` | infra01 | `192.168.1.102` | `52:54:00:01:01:02` |
| `awx.example.com` | infra01 | `192.168.1.103` | `52:54:00:01:01:03` |
| `vault.example.com` | infra01 | `192.168.1.104` | `52:54:00:01:01:04` |
| `keycloak.example.com` | infra01 | `192.168.1.105` | `52:54:00:01:01:05` |
| `dns.example.com` | infra01 | `192.168.1.106` | `52:54:00:01:01:06` |
| `k8s-control.example.com` | infra01 | `192.168.1.107` | `52:54:00:01:01:07` |
| `k8s-worker01.example.com` | infra01 | `192.168.1.108` | `52:54:00:01:01:08` |
| `prometheus.example.com` | infra01 | `192.168.1.115` | `52:54:00:01:01:09` |
| `alertmanager.example.com` | infra01 | `192.168.1.110` | `52:54:00:01:01:10` |
| `governance.example.com` | infra01 | `192.168.1.111` | `52:54:00:01:01:11` |
| `minio.example.com` | infra01 | `192.168.1.112` | `52:54:00:01:01:12` |
| `backup.example.com` | infra01 | `192.168.1.113` | `52:54:00:01:01:13` |
| `nginx.example.com` | infra01 | `192.168.1.114` | `52:54:00:01:01:14` |
| `elasticsearch01.example.com` | infra01 | `192.168.1.116` | `52:54:00:01:01:16` |
| `kibana.example.com` | infra01 | `192.168.1.117` | `52:54:00:01:01:17` |
| `splunk.example.com` | infra01 | `192.168.1.118` | `52:54:00:01:01:18` |
| `awx-execution.example.com` | infra02 | `192.168.1.121` | `52:54:00:02:01:21` |
| `harbor.example.com` | infra02 | `192.168.1.122` | `52:54:00:02:01:22` |
| `artifactory.example.com` | infra02 | `192.168.1.123` | `52:54:00:02:01:23` |
| `sonarqube.example.com` | infra02 | `192.168.1.124` | `52:54:00:02:01:24` |
| `postgres.example.com` | infra02 | `192.168.1.125` | `52:54:00:02:01:25` |
| `k8s-worker02.example.com` | infra02 | `192.168.1.126` | `52:54:00:02:01:26` |
| `k8s-worker03.example.com` | infra02 | `192.168.1.127` | `52:54:00:02:01:27` |
| `grafana.example.com` | infra02 | `192.168.1.128` | `52:54:00:02:01:28` |
| `loki.example.com` | infra02 | `192.168.1.129` | `52:54:00:02:01:29` |
| `tempo.example.com` | infra02 | `192.168.1.130` | `52:54:00:02:01:30` |
| `otel.example.com` | infra02 | `192.168.1.131` | `52:54:00:02:01:31` |
| `elasticsearch02.example.com` | infra02 | `192.168.1.133` | `52:54:00:02:01:33` |
| `elasticsearch03.example.com` | infra02 | `192.168.1.134` | `52:54:00:02:01:34` |
| `logstash.example.com` | infra02 | `192.168.1.135` | `52:54:00:02:01:35` |

## infra01 Placement

| VM FQDN | Product or role | vCPU | RAM | Suggested OS disk | Suggested data disk |
| --- | --- | ---: | ---: | ---: | ---: |
| `gitlab.example.com` | GitLab CE | 4 | 12 GB | 60 GB | 250 GB |
| `jenkins.example.com` | Jenkins controller | 4 | 8 GB | 50 GB | 100 GB |
| `awx.example.com` | AWX controller | 4 | 12 GB | 60 GB | 100 GB |
| `vault.example.com` | Vault or OpenBao | 2 | 4 GB | 40 GB | 50 GB |
| `keycloak.example.com` | Keycloak SSO/OIDC | 2 | 4 GB | 40 GB | 40 GB |
| `dns.example.com` | Internal DNS | 2 | 2 GB | 30 GB | 20 GB |
| `k8s-control.example.com` | Kubernetes control plane | 4 | 8 GB | 60 GB | 50 GB |
| `k8s-worker01.example.com` | Kubernetes worker | 6 | 12 GB | 60 GB | 150 GB |
| `prometheus.example.com` | Prometheus | 4 | 8 GB | 40 GB | 250 GB |
| `alertmanager.example.com` | Alertmanager | 2 | 4 GB | 30 GB | 20 GB |
| `governance.example.com` | Policy, evidence, and remediation runner | 2 | 4 GB | 40 GB | 50 GB |
| `minio.example.com` | S3-compatible backup/object storage | 4 | 8 GB | 40 GB | 500 GB |
| `backup.example.com` | Restic/Borg and database backup automation | 4 | 8 GB | 40 GB | 500 GB |
| `nginx.example.com` | Standalone NGINX reverse proxy | 2 | 2 GB | 30 GB | 20 GB |
| `elasticsearch01.example.com` | Elasticsearch cluster node 1 | 4 | 4 GB | 40 GB | 150 GB |
| `kibana.example.com` | Kibana log analysis and visualization | 2 | 4 GB | 40 GB | 40 GB |
| `splunk.example.com` | Standalone Splunk Enterprise platform | 4 | 8 GB | 50 GB | 150 GB |

Allocated memory is approximately 112 GB. With about 121 GiB physical memory,
infra01 has little operational headroom. Do not add or enlarge a VM without
checking resident memory, swap, and peak workloads. Do not run high-ingestion
exercises on all logging platforms simultaneously.

## infra02 Placement

| VM FQDN | Product or role | vCPU | RAM | Suggested OS disk | Suggested data disk |
| --- | --- | ---: | ---: | ---: | ---: |
| `awx-execution.example.com` | AWX execution node for AWS and infrastructure jobs | 4 | 8 GB | 60 GB | 50 GB |
| `harbor.example.com` | Harbor Docker/OCI and Helm OCI registry | 4 | 8 GB | 50 GB | 250 GB |
| `artifactory.example.com` | Artifactory OSS build artifact repository | 4 | 8 GB | 50 GB | 250 GB |
| `sonarqube.example.com` | SonarQube Community | 4 | 8 GB | 50 GB | 100 GB |
| `postgres.example.com` | PostgreSQL service databases | 4 | 8 GB | 50 GB | 250 GB |
| `k8s-worker02.example.com` | Kubernetes worker | 6 | 12 GB | 60 GB | 150 GB |
| `k8s-worker03.example.com` | Kubernetes worker | 6 | 12 GB | 60 GB | 150 GB |
| `grafana.example.com` | Grafana | 2 | 4 GB | 40 GB | 50 GB |
| `loki.example.com` | Loki log storage | 4 | 8 GB | 40 GB | 250 GB |
| `tempo.example.com` | Tempo trace storage | 4 | 8 GB | 40 GB | 250 GB |
| `otel.example.com` | OpenTelemetry gateway | 2 | 4 GB | 40 GB | 50 GB |
| `elasticsearch02.example.com` | Elasticsearch cluster node 2 | 4 | 4 GB | 40 GB | 150 GB |
| `elasticsearch03.example.com` | Elasticsearch cluster node 3 | 4 | 4 GB | 40 GB | 150 GB |
| `logstash.example.com` | Elastic ingestion and enrichment pipeline | 2 | 4 GB | 40 GB | 40 GB |

Allocated memory is approximately 100 GB. With about 107 GiB physical memory,
infra02 is capacity constrained. Preserve memory for Ubuntu, libvirt,
filesystem cache, image builds, and recovery operations. No additional VM is
approved without a capacity review. Monitor memory and disk latency during
indexing exercises.

## Logging Platform VM Build Status

The additional logging-platform VMs were provisioned on 2026-07-27:

- `elasticsearch01.example.com`, `kibana.example.com`, and
  `splunk.example.com` on infra01;
- `elasticsearch02.example.com`, `elasticsearch03.example.com`, and
  `logstash.example.com` on infra02.

All six libvirt domains are running and enabled for autostart. Forward and
reverse DNS, SSH by canonical name, cloud-init completion, qemu-guest-agent,
chronyd, firewalld, CPU, memory, and virtual-disk sizes were validated.

Elastic Stack 9.4.2 is installed on the five Elastic VMs and verified through
AWX jobs `311` and `316`. Elasticsearch and Logstash use their approved
`/data` paths and service ownership. Splunk is not installed or configured yet;
its secondary disk remains unformatted until that product role defines the
filesystem, mount point, ownership, and backup policy. Prometheus configuration
was not changed as part of the Elastic deployment.

## Kubernetes Services That Are Not VMs

The following are installed through Argo CD into the local Kubernetes cluster:

- Argo CD, exposed internally as `argocd.example.com`
- MetalLB
- ingress-nginx
- cert-manager
- Kyverno
- External Secrets Operator
- metrics-server
- Velero
- Longhorn
- OpenTelemetry Operator
- Trivy Operator
- Argo Rollouts when the base platform is stable

## AWS-Managed Resources That Are Not VMs

AWX provisions the AWS test environment from version-controlled
Terraform/OpenTofu:

- VPC, public/private subnets, routes, gateways, and security groups
- Amazon EKS control plane and managed node group
- Amazon ECR repositories and lifecycle policies
- IAM roles, EKS access entries, KMS keys, and CloudWatch logging
- S3-compatible Terraform state backend and locking controls

EKS and ECR names are cloud resource names, not entries in the local VM
inventory.

## Deployment Method by VM

| VM | Preferred installation method |
| --- | --- |
| `gitlab.example.com` | Vendor-supported Docker Compose using GitLab Omnibus |
| `jenkins.example.com` | Docker Compose with persistent Jenkins home |
| `awx.example.com` | AWX Operator on a dedicated single-node k3s installation |
| `awx-execution.example.com` | AWX receptor/execution node with a versioned execution-environment image |
| `vault.example.com` | Native systemd service or a hardened single-product Compose deployment |
| `keycloak.example.com` | Docker Compose connected to `postgres.example.com` |
| `dns.example.com` | Native Rocky Linux service |
| `harbor.example.com` | Official Harbor Docker Compose installer |
| `artifactory.example.com` | Official Artifactory OSS Docker Compose package |
| `sonarqube.example.com` | Docker Compose connected to `postgres.example.com` |
| `postgres.example.com` | Native systemd service or Docker Compose with a dedicated data disk |
| `prometheus.example.com` | Native Prometheus and Blackbox Exporter systemd units managed by Ansible |
| `alertmanager.example.com` | Native Alertmanager systemd unit managed by Ansible |
| `grafana.example.com` | Native Grafana RPM and systemd unit managed by Ansible |
| `loki.example.com` | Native Loki systemd unit with local storage under `/data/loki` |
| `tempo.example.com` | Native Tempo RPM and systemd unit with local storage under `/data/tempo` |
| `otel.example.com` | Native OpenTelemetry Collector Contrib RPM and systemd unit |
| `governance.example.com` | Python virtual environment and systemd timers, or a versioned runner container |
| `minio.example.com` | Native MinIO systemd unit using `/data/minio` |
| `backup.example.com` | Native systemd timers and backup tooling |
| `nginx.example.com` | Native NGINX package managed by Ansible |
| `elasticsearch01.example.com`–`elasticsearch03.example.com` | Native Elastic packages configured as one secured three-node cluster |
| `kibana.example.com` | Native Elastic package managed by Ansible |
| `logstash.example.com` | Native Elastic package managed by Ansible |
| `splunk.example.com` | Native Splunk Enterprise package managed by Ansible |
| Kubernetes nodes | Native containerd, kubelet, kubeadm, and kubectl |

Each Compose project must live under `/opt/midhtech/<product>/`, use an
environment file readable only by root, pin image versions, define health
checks, mount persistent data from the dedicated data disk, and send logs to
the central observability platform.

## Placement Rules

1. Run one major product per VM.
2. A product may use containers inside its dedicated VM when that is a
   supported installation method.
3. Store persistent application data on a separate virtual disk.
4. Enable SELinux enforcing, firewalld, chrony, qemu-guest-agent, and automatic
   security updates on every Rocky Linux VM.
5. Route Kubernetes and container operational logs to Loki, structured
   application and platform logs to Elasticsearch, security/audit/network
   events to Splunk, metrics to Prometheus, and traces through the
   OpenTelemetry gateway.
6. Back up configuration, databases, and persistent data before upgrades.
7. Do not create additional VMs without updating this inventory and the
   capacity totals.

Linux systems, database reliability, resilience, data engineering, and network
engineering use the existing VM fleet for first-slice operations automation and
evidence collection. They do not receive dedicated VM, address, or MAC
allocations from this document. Prefer existing services and Kubernetes
workloads where practical; infra01 and infra02 currently lack safe headroom for
an unreviewed product fleet.

## Current Implementation State

As of 2026-07-27, both hypervisors and all 31 listed VM domains are running
with autostart. GitLab, DNS, and NGINX have completed product installation.
The six Elastic/Splunk VMs are **provisioned only**: Rocky Linux 9.8,
cloud-init, qemu-guest-agent, chrony, and firewalld are present, but the common
baseline, `/data` mount, and product packages have not been applied. A running
VM must never be reported as an installed product.
