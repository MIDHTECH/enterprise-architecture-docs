# Current Environment State

Last verified: 2026-07-29

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

The following state was verified directly through 2026-07-29:

| Layer | Verified state |
| --- | --- |
| `infra01.example.com` | Ubuntu 26.04 LTS host reachable after a full reboot; KVM/libvirt, `br0`, and 17/17 autostart domains are up with expected IPv4 addresses; STP is disabled and canary recovery passed |
| `infra02.example.com` | Ubuntu 26.04 LTS, `br0` active, 14/14 domains running, and no active change process |
| `infra03.example.com` | Ubuntu 26.04 LTS, `br0` active, three new build-execution domains running with autostart |
| Virtual machines | 34 domains in the latest inventory: 17 on infra01, 14 on infra02, and 3 on infra03; all domains are running and all infra01 guests recovered expected IPv4 addresses |
| Product roles | At least 23 runtime roles directly verified; Harbor is installed; Vault 2.0.3 is active, unsealed, and accepted through NGINX; Keycloak still awaits revalidation |
| Application Kubernetes | kubeadm 1.34.10 on `k8s-control` and three workers; 4/4 nodes Ready |
| AWX platform Kubernetes | Independent k3s 1.36.2 runtime on `awx.example.com`; one AWX node Ready |
| AWX inventories | 38 records across four inventories: 31 product, three physical foundation, four intentional Kubernetes RBAC records, and zero Demo hosts; 34 distinct names |
| Git repositories | AWX inventory, Kubernetes ingress, and cloud-infrastructure corrections are published; incident documentation is updated as each sequential change closes |

The directly verified provisioned-only product VMs include `governance`,
`backup`, `awx-execution`, `artifactory`, `sonarqube`, and `splunk`.
PostgreSQL 18 is active on `postgres.example.com`. Harbor 2.15.0 is active on
`harbor.example.com`: all ten Harbor, registry, database, Redis, portal,
job-service, and Trivy containers are healthy, the health API is healthy, and
native HTTPS returns 200. Vault 2.0.3 is active on
`vault.example.com`, reports `initialized=true`, `sealed=false`, and
`standby=false`, and is reachable through `vault.apps.example.com`. Keycloak
still requires separate revalidation before its older installation claim
becomes canonical.

Three infra03 guests were provisioned at `.136–.138`:
`gitlab-runner-app01`, `gitlab-runner-infra01`, and `jenkins-agent01`.
All three are running Rocky Linux and have autostart enabled, but no GitLab
Runner or Jenkins Agent service is installed or running. Their placement,
addressing, source code, and intended scope must be reconciled before any one
of them is configured.

The four-node application cluster currently contains the control-plane components,
CoreDNS, Flannel, and Headlamp. Argo CD, MetalLB, ingress-nginx, cert-manager,
Kyverno, External Secrets Operator, metrics-server, Velero, Longhorn,
OpenTelemetry Operator, Trivy Operator, and Argo Rollouts are not installed in
the current cluster and must not be reported as completed.

Do not treat AWX's local k3s context as the application cluster. Application
acceptance must use `/etc/kubernetes/admin.conf` on
`k8s-control.example.com`, confirm all four expected node names, and record the
API server version before collecting evidence. AWX platform-cluster evidence
must be labeled separately. See INC-2026-045.

## Application access

`nginx.example.com` is the single non-HA HTTP reverse proxy. Its root URL
returns the current active and unavailable route catalog. Active routes include
GitLab, Jenkins, AWX, Headlamp, Prometheus, Alertmanager, Grafana, MinIO, Loki,
Tempo, OpenTelemetry HTTP, Kibana, and Vault. AWX uses its verified NodePort
`32000`; Headlamp uses `30080`. The Vault upstream uses HTTPS with the
version-controlled backend certificate as its trust anchor. Source-restricted
firewalld rules allow only
approved lab-LAN consumers to reach Loki and Tempo and allow the Kubernetes
pod CIDR to reach the OpenTelemetry receivers.

Backend VM names such as `gitlab.example.com` identify service hosts.
User-facing reverse-proxy names use the `apps.example.com` zone. For example,
`gitlab.apps.example.com` is the accepted GitLab URL and currently redirects
through NGINX to the GitLab sign-in route.

Artifactory, SonarQube, and Splunk remain provisioned-only. Harbor is healthy
on its native HTTPS endpoint, but its application route remains listed as
unavailable by NGINX and requires separate acceptance. Keycloak must still be
revalidated after infra01 recovery. See
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

The following readiness evidence was collected directly through 2026-07-29:

| Capability | Live evidence | Readiness |
| --- | --- | --- |
| Hypervisor capacity | infra01 has 17/17, infra02 has 14/14, and infra03 has 3/3 domains running; infra01 bridge correction and one controlled guest reboot passed | Monitoring under INC-2026-046 |
| Kubernetes base | Explicit `kubernetes-admin@kubernetes` context reports server 1.34.10, 4/4 nodes Ready, no non-running pods, and no active Jobs | Accepted after infra01 recovery |
| Persistent Kubernetes applications | No StorageClass and no PVCs | Blocked until storage is installed and tested |
| Kubernetes application ingress | No IngressClass or ingress controller; Headlamp is exposed by NodePort | Blocked for standard application URLs |
| Elastic host logging | Filebeat active and encrypted-output validation passed on 31/31 Rocky Linux VMs; Logstash queue empty; all 31 inventory hostnames present in Elasticsearch | Accepted |
| Prometheus metrics | 32/32 configured targets Up after AWX job 321: Prometheus plus 31 Node Exporters | Accepted for all Rocky Linux VMs |
| Grafana visualization | AWX job 356 provisioned Prometheus, Loki, and Tempo data sources plus the Server Fleet Overview dashboard | Accepted for metrics, logs, and trace exploration |
| Loki log pipeline | AWX job 381 returned one run-specific stream containing the accepted Tempo trace ID | Accepted for the bounded correlated workload |
| Tempo trace pipeline | AWX job 381 found and retrieved trace `f819ea257b72ff3a7fd5998e807b3430`, then correlated it to the Loki event | Accepted for the bounded correlated workload |
| Management applications | GitLab, AWX, Prometheus, Grafana, Kibana, and the Headlamp NGINX route returned HTTP responses; Jenkins returned the expected authenticated HTTP 403 | Available |
| Headlamp name resolution | BIND, the Mac split resolver, and Kubernetes CoreDNS return `192.168.1.114`; normal application URL returns HTTP 200 | Accepted through AWX jobs 398 and 402 |
| Vault secrets service | Vault 2.0.3 reports initialized, unsealed, active, and HTTP 200 through the verified NGINX TLS upstream; NGINX convergence job 421 reported `changed=0`, `unreachable=0`, and `failed=0` | Accepted through AWX jobs 417 and 421 |
| AWX inventory boundaries | Product VMs are canonical in `production`; infra01/02/03 are isolated in `cloud-infra-production`; the four Kubernetes records remain a deliberate cluster RBAC boundary | Accepted through sync job 425 and DNS/NGINX jobs 433, 438, 443, and 448 |

The platform can deploy and exercise stateless test applications through
ClusterIP or NodePort and can accept their logs, metrics, and traces. The
shared telemetry path is accepted; each application must still prove its own
service-specific telemetry, dashboards, alerts, and SLOs. Enterprise-style
stateful deployment and standard application ingress remain blocked until
Kubernetes storage and ingress are installed and tested.

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

Grafana reconciliation completed in AWX job `356`. Correlated telemetry
acceptance completed in AWX job `381` with run ID `20260729T164944Z`, Tempo
trace ID `f819ea257b72ff3a7fd5998e807b3430`, successful trace-by-ID retrieval,
and one Loki stream containing the same trace ID. Failed jobs `361`, `366`,
`371`, and `376` exposed and drove the managed firewall, BIND ACL, and CoreDNS
forwarding corrections recorded in INC-2026-036 through INC-2026-038.

## Remaining integration work

1. Run the Jenkins seed job so `projects/run-ansible-playbook` is created or
   refreshed from `jenkins-jobs`.
2. Reconcile AWX project definitions and read-only GitLab deploy-key
   assignments as controller configuration as code.
3. Confirm AWX SCM and machine credential IDs for the Linux VM fleet.
4. Run preflight smoke tests for the systems, database, resilience, data, and
   network automation slices through Jenkins/AWX.
5. Install and validate a Kubernetes StorageClass and ingress controller.
6. Connect Prometheus alert delivery to Alertmanager and validate a test alert.
7. Apply application dashboards, alert rules, and SLOs from
   `observability-sre-platform`.
8. Configure production alert receivers.
9. Decide whether Loki and Tempo should move from local storage to MinIO.
10. Back up `/etc/midhhealth/elastic-stack` through the restricted platform
    secret-backup process.
11. Configure reverse-proxy TLS and SSO for Kibana.
12. Enroll structured Jenkins, AWX job, Kubernetes ingress, PostgreSQL,
    application, AI, and MLOps log classes through the Logstash boundary.
13. Register `midh-ai-edge-01` as the Mac Studio AI/ML development endpoint.
14. Define `infra03` Kubernetes labels and workload placement guardrails before
    assigning VMs from its reserved `.141–.160` block.
15. Migrate Elasticsearch01–03 and the Kubernetes control plane/workers to the
    `infra03-images` pool, validate application and cluster health, then retire
    the confirmed source domains to free infra01/02 capacity.
