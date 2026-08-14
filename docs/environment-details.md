# Environment Details

Last verified: 2026-08-13

Capability state in this page is governed by the canonical
[`environment-capability-status.json`](environment-capability-status.json).
This page explains topology and design intent; it must not promote a target
product into current state.

## Environment Model

The environment represents **MidhHealth Integrated Care**, an integrated care
delivery and health insurance organization running a hybrid platform. The
on-premises side is the active integration and operations lab:
KVM/libvirt, Rocky Linux VMs, Kubernetes, DNS, NGINX, GitLab, Jenkins, AWX,
observability, and supporting product VMs. The cloud side is the governed
extension path for AWS, Azure, and GCP, using the same repository, review,
delivery, security, and evidence standards.

The systems, database, resilience, data, and network automation slices use the
existing VM fleet for operations automation and evidence collection; they have
no dedicated VM or IP allocation. Their automation reuses existing GitLab,
Jenkins, AWX, KVM, Kubernetes, observability, DNS, and proxy capacity where
safe. A capacity review is required before any new VM or product is authorized.

The approved capacity direction adds two distinct roles: a planned third Linux
server with 256 GB RAM for high-memory platform workloads, and a Mac Studio M1
with 32 GB unified memory and 512 GB storage named `midh-ai-edge-01` for AI/ML
development, local inference, embeddings, notebooks, and evaluation. The Mac
Studio remains outside the primary Kubernetes worker pool unless a separate
experiment explicitly authorizes it.

The lab supports two deployment targets:

| Target | Purpose | Provisioning path | Delivery path |
| --- | --- | --- | --- |
| Local KVM | Active on-premises integration, operations, and product environment | Ansible + libvirt + cloud-init | GitLab → Jenkins/AWX → accepted Harbor native endpoint → Helm; Argo CD only after separate acceptance |
| AWS/Azure/GCP | Governed cloud validation and expansion environments | AWX → Terraform/OpenTofu → cloud services | GitLab → Jenkins/GitLab CI → cloud registry/services → GitOps |

## Physical and Edge Capacity Plan

| Asset | Role | Primary workloads | Placement notes |
| --- | --- | --- | --- |
| `infra01` | Existing Linux/KVM platform host | Core product VMs and shared platform services | Keep stable control-plane workloads here when possible |
| `infra02` | Existing Linux/KVM platform host | General application, integration, Kubernetes and VM workloads | Balance non-critical workloads with `infra01` |
| `infra03` | Available 256 GB Linux/KVM host with 3.58 TiB VM pool | Elasticsearch and Kubernetes consolidation first; later data engineering, observability scale, AI/ML batch and resilience testing | `br0`, `lab-bridge`, internal DNS, `lab-images`, and `infra03-images` validated |
| `midh-ai-edge-01` | Mac Studio M1, 32 GB RAM, 512 GB disk | Local AI inference, embeddings, notebooks, prompt/model evaluation and AI/ML CI smoke tests | Do not store protected production data; avoid long-term observability/data retention |

Application promotion uses Kubernetes namespaces instead of a separate cluster
for every environment:

| Environment | Namespace | Branch or tag | Deployment policy |
| --- | --- | --- | --- |
| Development | `app-dev` | feature or `develop` | Automatic sync |
| QA | `app-qa` | release candidate | Automatic after tests |
| Stage | `app-stage` | release tag | Manual approval |
| Production simulation | `app-prod` | approved immutable tag | Manual approval and evidence |

## Base Operating Systems

| Layer | Operating system |
| --- | --- |
| Physical hosts | Ubuntu 26.04 LTS Desktop with GNOME |
| Virtual machines | Rocky Linux 9 GenericCloud image |
| Container workloads | Minimal vendor or enterprise base images |

## Core Endpoints

Application endpoints are migrating one product at a time to local NGINX on
the product VM and the canonical `<product>.example.com` name. AWX, Jenkins,
and Headlamp are accepted on this model. The standalone `nginx.example.com` VM at
`192.168.1.114` temporarily serves products not yet migrated. Internal TLS is
partially adopted rather than globally installed: Harbor has accepted native
HTTPS and Vault has its documented HTTPS path, while most verified user-facing
routes below still use HTTP.

| Endpoint | Function | Current state |
| --- | --- | --- |
| `http://gitlab.apps.example.com` | Source control and merge requests | Active |
| `http://jenkins.example.com` | CI pipelines through service-local NGINX to backend port `8080` | Active and accepted; `.apps` DNS and shared route retired |
| `http://awx.example.com` | Automation controller through service-local NGINX to backend port `32000` | Active and accepted; `.apps` record retired |
| `http://headlamp.example.com` | Kubernetes dashboard through worker01-local NGINX to the private ingress-nginx ClusterIP | Active and accepted; `.apps` DNS, shared route, and NodePort retired |
| `http://grafana.apps.example.com` | Dashboards | Active |
| `http://prometheus.apps.example.com` | Metrics | Active |
| `http://alertmanager.apps.example.com` | Alerts | Active |
| `http://minio.apps.example.com` | S3-compatible API | Active; console port is not configured |
| `http://loki.apps.example.com` | Loki HTTP API | Active |
| `http://tempo.apps.example.com` | Tempo HTTP API | Active |
| `http://otel.apps.example.com` | OpenTelemetry HTTP receiver | Active |
| `http://kibana.apps.example.com` | Elastic dashboards and search | Active |
| `https://harbor.example.com` | OCI images and Helm OCI | Harbor 2.15.0 installed and healthy; native HTTPS accepted |
| `http://harbor.apps.example.com` | Legacy shared-proxy Harbor route | Unavailable and not accepted; do not confuse route state with product state |
| `http://artifactory.apps.example.com` | Build artifacts | Intentional 503; product not installed |
| `http://sonarqube.apps.example.com` | Code quality | Intentional 503; product not installed |
| `http://vault.apps.example.com` | Secrets | Active; UI root redirects and `/v1/sys/health` returns HTTP 200 while unsealed |
| `http://keycloak.apps.example.com` | SSO/OIDC | Route unavailable; older product-presence claim requires revalidation before it becomes canonical |
| `http://splunk.apps.example.com` | Splunk search and administration | Intentional 503; product not installed |

PostgreSQL, DNS, SSH, Kubernetes control-plane ports,
OpenTelemetry gRPC, and other non-HTTP protocols are not forced through this
HTTP reverse-proxy tier.

Elasticsearch uses the management names
`elasticsearch01.example.com`–`elasticsearch03.example.com` on ports
9200/9300. Logstash uses `logstash.example.com:5044`. These native data-plane
endpoints are not NGINX virtual hosts.

## Credentials and Trust

- Human authentication through Keycloak is a target OIDC pattern. Keycloak
  requires revalidation before any product may claim that integration.
- Jenkins and AWX use service identities with narrowly scoped permissions.
- Kubernetes secret retrieval through External Secrets Operator is a planned
  contract. The operator is not installed in the current application cluster.
- AWS automation uses IAM Roles Anywhere and temporary credentials.
- Long-lived AWS administrator keys must not be stored in AWX or Jenkins.
- The target design issues internal TLS certificates from the lab CA and
  distributes them through configuration management. Current acceptance is
  endpoint-specific, not enterprise-wide.
- Secrets, private keys, tokens, and generated kubeconfigs are never committed.

## Deferred AWS Guardrails

- Use an approved AWS account and region.
- Require `Environment`, `Owner`, `Project`, `ManagedBy`, and `ExpiresAt` tags.
- Enable EKS control-plane logs.
- Encrypt EKS secrets and ECR images with KMS where configured.
- Scan Terraform/OpenTofu before apply and container images before ECR push.
- Configure an AWS Budget alert before the first deployment.
- Provide a separately approved AWX destroy workflow.
- Default training environments to automatic expiration.

## Backup and Recovery

- `backup.example.com` coordinates database dumps, configuration backups, and
  recovery tests.
- `minio.example.com` stores local S3-compatible backup objects.
- Velero backs up Kubernetes resources and supported persistent volumes.
- The design requires product-specific backup jobs for GitLab, Jenkins, AWX,
  Harbor, Artifactory, PostgreSQL, Prometheus, Loki, and Tempo. A job is not
  current-state proof until its restore evidence is recorded.
- A backup is not accepted until a restore test produces evidence.

## Build Order

1. Reinstall and validate `infra02`.
2. Install KVM/libvirt, networking, storage, and Ansible on `infra02`.
3. Reinstall and validate `infra01`.
4. Install KVM/libvirt, networking, storage, and Ansible on `infra01`.
5. Build DNS and the standalone NGINX reverse proxy.
6. Build GitLab and AWX first; manage the active PostgreSQL 18 service through
   AWX for all subsequent lifecycle changes.
7. Reconcile and accept PostgreSQL, Vault/OpenBao, Jenkins, the AWX execution
   plane and Harbor; install Artifactory and SonarQube only through later
   separately approved changes.
8. Build the Kubernetes control plane and three workers.
9. Bootstrap Argo CD and platform add-ons.
10. Build Prometheus/Grafana/Loki/Tempo/OpenTelemetry, then the Elastic Stack
    and standalone Splunk; connect only validated targets.
11. Enable governance evidence collection.
12. Complete on-premises acceptance testing. IAM Roles Anywhere and the AWX
    EKS/ECR workflow are deferred until a later phase.

## Current Implementation Status

| Layer | State through 2026-08-08 |
| --- | --- |
| Hypervisors, bridges, and libvirt | Operational |
| 35 VM domains | Running in the latest accepted inventory: 17 on `infra01`, 14 on `infra02`, and 4 on `infra03` |
| BIND DNS | Installed; lab LAN and Kubernetes pod CIDR authorized |
| GitLab CE | Installed |
| Standalone NGINX | Installed; active routes verified; uninstalled products return intentional 503 |
| Prometheus, Alertmanager, Grafana, Loki, Tempo, OTel, MinIO | Native systemd services; Prometheus metrics and bounded correlated Loki/Tempo telemetry accepted; alert routing/TLS/SSO remain |
| Elastic Stack | Elastic and Filebeat 9.4.2 healthy; encrypted Linux fleet logs accepted from all 31 VMs |
| Splunk | VM provisioned; product not installed |
| PostgreSQL | PostgreSQL 18 active |
| Local Kubernetes | Four nodes Ready; CoreDNS forwards `example.com` only to `192.168.1.106`; Flannel, Headlamp, ClusterIP-only ingress-nginx, and worker-only Longhorn 1.12.0 V1 accepted; GitOps and remaining add-ons absent |
| Remaining platform products | Provisioned or planned; verify each runbook before reporting installed |
| Portfolio projects 6–10 | Executable first slices exist; Jenkins/AWX runtime acceptance evidence pending |
| Healthcare AI and MLOps | Repository scaffolds; runtime implementation planned |

The VM count is not a product-completion count. Acceptance requires the
product service, version lock, security controls, data disk, and tests.
Exact installed observability versions and remaining integration work are in
[Current Environment State](current-environment-state.md).
