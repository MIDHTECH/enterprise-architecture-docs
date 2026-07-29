# Current Environment State

Last verified: 2026-07-28

## Enterprise project portfolio

The architecture represents **MidhHealth Integrated Care**, an enterprise care
delivery and health insurance organization with a hybrid
on-premises and cloud platform. The repositories map to platform teams that
support provider workflows, payer workflows, analytics, security, and shared
platform operations. They share GitLab, Jenkins, AWX, Ansible/Terraform
patterns, governance standards, environment promotion, and operational
evidence.

The active first slices for Linux systems, database reliability,
resilience/service operations, data engineering, and network engineering run
against the existing VM fleet. They do not imply new product installation. A
separate capacity plan now tracks a third memory-optimized Linux server and a
Mac Studio M1 AI/ML edge development node.

The authoritative scope and all 217 use cases are maintained in
[Enterprise Project Portfolio and Use Case Coverage](enterprise-project-portfolio-and-usecases.md).
Implementation and acceptance counts are maintained separately in
[Use-Case Implementation Status](use-case-implementation-status.md).

## Live on-premises infrastructure

The following state was verified directly on 2026-07-28:

| Layer | Verified state |
| --- | --- |
| `infra01.example.com` and `infra02.example.com` | Ubuntu 26.04 LTS, KVM available, libvirt 12 active, physical `br0` active |
| Virtual machines | 31 of 31 domains running: 17 on infra01 and 14 on infra02 |
| Product roles | 22 active product/runtime roles; 9 VMs remain provisioned without their intended product |
| Local Kubernetes | Kubernetes 1.34.10; one control plane and three workers Ready |
| Git repositories | 20 local repositories clean and equal to their GitLab remote HEAD |

The provisioned-only product VMs are `vault`, `keycloak`, `governance`,
`backup`, `awx-execution`, `harbor`, `artifactory`, `sonarqube`, and `splunk`.
PostgreSQL 18 is active on `postgres.example.com`.

The local Kubernetes cluster currently contains the control-plane components,
CoreDNS, Flannel, and Headlamp. Argo CD, MetalLB, ingress-nginx, cert-manager,
Kyverno, External Secrets Operator, metrics-server, Velero, Longhorn,
OpenTelemetry Operator, Trivy Operator, and Argo Rollouts are not installed in
the current cluster and must not be reported as completed.

## Application access

`nginx.example.com` is the single non-HA HTTP reverse proxy. Its root URL
returns the current active and unavailable route catalog. Active routes include
GitLab, Jenkins, AWX, Headlamp, Prometheus, Alertmanager, Grafana, MinIO, Loki,
Tempo, OpenTelemetry HTTP, and Kibana. AWX uses its verified NodePort `32000`;
Headlamp uses `30080`. Source-restricted firewalld rules allow only
`192.168.1.114` to reach the otherwise restricted observability HTTP ports.

Vault, Keycloak, Harbor, Artifactory, SonarQube, and Splunk application URLs
return an intentional HTTP 503 with `product-not-installed`. Internal TLS is
not deployed yet, so the accepted current URLs use HTTP. See
[Standalone NGINX Reverse-Proxy Installation](product-installation-nginx.md).

## Hybrid capacity plan

The lab is moving from a two-node on-premises base toward a hybrid engineering
footprint that separates platform runtime, high-memory workloads, and AI/ML
development.

| Environment | Planned role | Workload boundary |
| --- | --- | --- |
| `infra01` | Core platform and VM host | GitLab, Jenkins, AWX, DNS, proxy, and selected shared product VMs |
| `infra02` | General platform and application host | Kubernetes workers, integration workloads, observability targets, and supporting VMs |
| `infra03` | Available 256 GB memory-optimized Linux/KVM host with 3.58 TiB VM pool | First priority is Elasticsearch and Kubernetes consolidation; later data, observability, AI/ML backend, and resilience workloads require capacity review |
| `midh-ai-edge-01` | Mac Studio M1, 32 GB RAM, 512 GB disk | AI/ML development, local inference, embeddings, notebooks, prompt and model evaluation, and CI smoke tests |

The Mac Studio is not a primary Kubernetes worker and is not a regulated
production data host. It is used as an engineering workstation and edge
inference environment for non-production AI/ML workflows. The planned
memory-optimized Linux host is the preferred placement for backend AI/ML,
data, observability, and batch workloads that exceed the Mac Studio's memory or
storage envelope.

## GitLab organization

- Top-level group display name: `MidhHealth`
- Top-level group path: `midhhealth`
- Subgroups: `enterprise-architecture`, `platform-delivery`,
  `platform-engineering`, `reliability-operations`, `security-governance`,
  `data-and-integration`, `ai-and-ml-platform`, `care-delivery-platform`, and
  `payer-operations-platform`
- Visibility: private
- Observability use cases:
  `midhhealth/reliability-operations/observability-sre-platform`
- Observability installation:
  `midhhealth/reliability-operations/ansible-observability`
- Prometheus, Grafana, and Node Exporter installation:
  `midhhealth/reliability-operations/ansible-prometheus`
- Linux systems implementation:
  `midhhealth/platform-engineering/linux-systems-platform`
- Jenkins/AWX Ansible launcher:
  `projects/run-ansible-playbook` generated from
  `midhhealth/platform-delivery/jenkins-jobs` and backed by
  `midhhealth/platform-delivery/jenkins-shared-library`
- Enterprise first-slice implementation repositories:
  `midhhealth/data-and-integration/database-reliability-platform`,
  `midhhealth/reliability-operations/resilience-service-operations`,
  `midhhealth/data-and-integration/data-engineering-platform`,
  `midhhealth/platform-engineering/network-engineering-platform`
- Approved AI/ML platform repositories:
  `midhhealth/ai-and-ml-platform/healthcare-ai-platform`,
  `midhhealth/ai-and-ml-platform/mlops-model-platform`

## Observability hosts

All observability VMs run Rocky Linux 9.8. Stateful services use a separately
mounted `/data` disk. The observability runtime is native systemd; unused Docker
Engine and Compose packages were removed through Ansible.

| Host | Installed service | Version | State |
| --- | --- | --- | --- |
| `prometheus.example.com` | Prometheus | 3.13.1 | healthy |
| `prometheus.example.com` | Blackbox Exporter | 0.25.0 | healthy |
| `alertmanager.example.com` | Alertmanager | 0.33.1 | healthy |
| `minio.example.com` | MinIO | `RELEASE.2025-04-22T22-12-26Z` | healthy |
| `grafana.example.com` | Grafana | 13.1.1 | healthy |
| `loki.example.com` | Loki | 3.7.4 | healthy |
| `tempo.example.com` | Tempo | 3.0.2 | healthy |
| `otel.example.com` | OpenTelemetry Collector Contrib | 0.137.0 | healthy |
| `elasticsearch01.example.com` | Elasticsearch | 9.4.2 | healthy |
| `elasticsearch02.example.com` | Elasticsearch | 9.4.2 | healthy |
| `elasticsearch03.example.com` | Elasticsearch | 9.4.2 | healthy |
| `kibana.example.com` | Kibana | 9.4.2 | healthy |
| `logstash.example.com` | Logstash | 9.4.2 | healthy |

Node Exporter 1.11.1 is installed on managed platform hosts.

## Application and telemetry readiness audit

The following readiness evidence was collected directly on 2026-07-28:

| Capability | Live evidence | Readiness |
| --- | --- | --- |
| Hypervisor capacity | 31/31 VMs running across infra01 and infra02; approximately 58/121 GiB and 34/107 GiB RAM in use; both root filesystems below 3% utilization | Ready |
| Kubernetes base | 4/4 nodes Ready; CoreDNS, Flannel, control-plane components, and Headlamp healthy; 22 allocatable CPUs and approximately 41.1 GiB allocatable memory | Ready for stateless test workloads |
| Persistent Kubernetes applications | No StorageClass and no PVCs | Blocked until storage is installed and tested |
| Kubernetes application ingress | No IngressClass or ingress controller; Headlamp is exposed by NodePort | Blocked for standard application URLs |
| Elastic host logging | Filebeat active and encrypted-output validation passed on 31/31 Rocky Linux VMs; Logstash queue empty; all 31 inventory hostnames present in Elasticsearch | Accepted |
| Prometheus metrics | 32/32 configured targets Up after AWX job 321: Prometheus plus 31 Node Exporters | Accepted for all Rocky Linux VMs |
| Grafana visualization | Grafana healthy; Prometheus data source, dashboard provider, and Server Fleet Overview dashboard provisioned | Ready for host metrics |
| Loki log pipeline | Loki service healthy, but the last-hour query returned zero streams and no labels | Standby; no live workload logs |
| Tempo trace pipeline | Tempo and the OpenTelemetry Collector are healthy, but Tempo returned zero traces | Standby; no end-to-end trace proof |
| Management applications | GitLab, AWX, Prometheus, Grafana, Kibana, and the Headlamp NGINX route returned HTTP responses; Jenkins returned the expected authenticated HTTP 403 | Available |
| Headlamp name resolution | Direct NGINX routing returned HTTP 200, but `headlamp.apps.example.com` did not resolve and is absent from the authoritative zone | Degraded; tracked by INC-2026-030 |

The platform can deploy and exercise stateless test applications through
ClusterIP or NodePort today. It is not yet ready for enterprise-style stateful
application deployment or accepted logs-metrics-traces monitoring. The minimum
acceptance path is to install and test Kubernetes storage and ingress,
provision the Loki and Tempo Grafana integrations, and run an
OpenTelemetry-instrumented smoke application that proves logs, metrics, and
traces from workload to query and dashboard.

## Step-by-step verification

1. Clone `ansible-observability`.
2. Confirm `inventories/production/hosts.yml`.
3. Run `ansible observability_servers -m ping`.
4. Run syntax validation and `ansible-lint`.
5. Run `ansible-playbook --check playbooks/install-observability.yml`.
6. Apply `playbooks/install-observability.yml`.
7. Run `playbooks/verify-observability.yml`.
8. Require zero failed and zero unreachable hosts.

Detailed commands, credential handling, service order, health endpoints, and
troubleshooting steps are maintained in
`ansible-observability/docs/installation-runbook.md`.

Elastic Stack automation is implemented in `ansible-observability`, including
Elasticsearch, Kibana, Logstash, the `midhhealth-*` index template and the
approved Logstash ingestion boundary. AWX deployment job `311` reconciled the
installed stack. Independent AWX verification job `316` reloaded the
persistent root-only credentials, confirmed three-node membership and service
health, sent an approved structured event through Logstash, and found it in
the managed Elasticsearch index.

Fleet enrollment was added on 2026-07-28 with Filebeat 9.4.2 and the
`playbooks/deploy-fleet-logging.yml` workflow. Filebeat reads
`/var/log/secure` and `/var/log/messages`, labels events as `linux_auth` or
`linux_system`, uses a 1 GB disk queue, and sends encrypted Beats traffic to
`logstash.example.com:5044`. The Logstash input validates the managed Elastic
CA and routes only approved classes to `midhhealth-*` indices.

All 31 Rocky Linux VMs passed configuration validation, active-service checks,
and encrypted output tests. The final inventory verifier found at least 10,000
recent events and the same 31 distinct hostnames in Elasticsearch, with an
empty missing-host list. Centralized Linux fleet logging is accepted at 31/31.
Logstash reported 571,057 input events, 571,057 output events, and zero queued
events after final enrollment. INC-2026-024 and the AWX access incident
INC-2026-027 are resolved.

## Remaining integration work

1. Run the Jenkins seed job so `projects/run-ansible-playbook` is created or
   refreshed from `jenkins-jobs`.
2. Configure AWX GitLab SSH host trust for `gitlab.example.com:2222`.
3. Confirm AWX SCM and machine credential IDs for the Linux VM fleet.
4. Run preflight smoke tests for the systems, database, resilience, data, and
   network automation slices through Jenkins/AWX.
5. Provision Grafana data sources and dashboards for Loki and Tempo;
   Prometheus and the Server Fleet Overview dashboard are provisioned.
6. Deploy one OpenTelemetry-instrumented smoke application and require
   non-zero, correlated logs, metrics, and traces before declaring telemetry
   ready.
7. Install and validate a Kubernetes StorageClass and ingress controller.
8. Connect Prometheus alert delivery to Alertmanager and validate a test alert.
9. Apply dashboards, alert rules, and SLOs from `observability-sre-platform`.
10. Configure production alert receivers.
11. Decide whether Loki and Tempo should move from local storage to MinIO.
12. Back up `/etc/midhhealth/elastic-stack` through the restricted platform
    secret-backup process.
13. Configure reverse-proxy TLS and SSO for Kibana.
14. Enroll structured Jenkins, AWX job, Kubernetes ingress, PostgreSQL,
    application, AI, and MLOps log classes through the Logstash boundary.
15. Register `midh-ai-edge-01` as the Mac Studio AI/ML development endpoint.
16. Define `infra03` Kubernetes labels and workload placement guardrails before
    assigning VMs from its reserved `.141–.160` block.
17. Migrate Elasticsearch01–03 and the Kubernetes control plane/workers to the
    `infra03-images` pool, validate application and cluster health, then retire
    the confirmed source domains to free infra01/02 capacity.
