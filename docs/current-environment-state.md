# Current Environment State

Last verified: 2026-08-13

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

The authoritative scope and use-case counts are maintained only in
[Enterprise Project Portfolio and Use Case Coverage](enterprise-project-portfolio-and-usecases.md).
Implementation and acceptance counts are maintained separately in
[Use-Case Implementation Status](use-case-implementation-status.md).

## Live on-premises infrastructure

The following state combines the directly verified platform baseline with the
accepted runner, Jenkins, AWX execution-plane, Kubernetes ingress, and
persistent-storage changes completed through 2026-08-08:

| Layer | Verified state |
| --- | --- |
| `infra01.example.com` | Ubuntu 26.04 LTS host reachable after a full reboot; KVM/libvirt, `br0`, and 17/17 autostart domains are up with expected IPv4 addresses; STP is disabled and canary recovery passed |
| `infra02.example.com` | Ubuntu 26.04 LTS, `br0` active, 14/14 domains running, and no active change process |
| `infra03.example.com` | Ubuntu 26.04 LTS, `br0` active, four build-execution domains running with autostart |
| Virtual machines | 35 domains in the latest accepted inventory: 17 on infra01, 14 on infra02, and 4 on infra03; all domains are running and all infra01 guests recovered expected IPv4 addresses |
| Product roles | At least 23 runtime roles directly verified; Harbor is installed; Vault 2.0.3 is active, unsealed, and accepted through NGINX; Keycloak still awaits revalidation |
| Application Kubernetes | kubeadm 1.34.10 on `k8s-control` and three workers; 4/4 nodes Ready; ClusterIP-only ingress-nginx and worker-only Longhorn 1.12.0 V1 accepted |
| AWX platform Kubernetes | Independent k3s 1.36.2 runtime on `awx.example.com`; one AWX node Ready |
| AWX execution plane | AWX 24.6.1 instance 3 on `awx-execution.example.com` is Ready at capacity 76 only in `lab-infrastructure`; NGINX exposes hostname TCP 443 and Receptor remains loopback-only on 27199 |
| AWX inventories | 50 records across nine populated inventories plus the empty Demo inventory; 39 distinct names. Purpose-specific delivery inventories remain isolated, and `awx-execution-plane` contains only the execution node and canary localhost. |
| Git repositories | AWX inventory, Kubernetes ingress, Longhorn storage automation/design, and cloud-infrastructure corrections are published; private application project `midhhealth/applications/podinfo` now retains upstream history and has protected `main` at internal commit `b8dceac72494313eca3ab388a20ad06867675224` |

The directly verified provisioned-only product VMs include `governance`,
`backup`, `artifactory`, `sonarqube`, and `splunk`.
PostgreSQL 18 is active on `postgres.example.com`. Harbor 2.15.0 is active on
`harbor.example.com`: all ten Harbor, registry, database, Redis, portal,
job-service, and Trivy containers are healthy, the health API is healthy, and
native HTTPS returns 200. Vault 2.0.3 is active on
`vault.example.com`, reports `initialized=true`, `sealed=false`, and
`standby=false`, and is reachable through `vault.apps.example.com`. Keycloak
still requires separate revalidation before its older installation claim
becomes canonical.

Four infra03 guests were provisioned at `.136–.139`:
`gitlab-runner-app01`, `gitlab-runner-infra01`, `jenkins-agent01`, and
`gitlab-runner-shared01`. All four are running Rocky Linux and have autostart
enabled.
`gitlab-runner-infra01` is accepted as runner ID 4: the pinned GitLab Runner
19.2.0 Docker executor is project-scoped to project ID 2, locked, rejects
untagged jobs, and has exactly `ansible,infra,terraform` tags. Canary job 1171
ran on that runner, rollback/restore succeeded, and AWX job 645 converged with
zero changes. `gitlab-runner-app01` is also accepted: instance runner ID 3 has
exact `app,docker` tags, rejects untagged jobs, runs the pinned 19.2.0 Docker
executor, and passed canary job 1234 plus rollback/restore and zero-change AWX
job 665. `gitlab-runner-shared01` is accepted as instance runner ID 5 with
exact `shared,validation,security` tags, untagged execution disabled, and the
pinned 19.2.0 Docker executor. Canary job 1424, rollback/restore, and
zero-change AWX job 704 passed. `jenkins-agent01` is accepted: its
WebSocket service is enabled and active, Jenkins reports one exclusive
`kubernetes-deployer` executor online, the controller has zero executors, and
AWX jobs 536/541 both converged with zero changes or failures.

Podinfo project pipeline 653 passed source policy, Go module verification,
tests, vet, and binary packaging as jobs 1943–1945 on application runner ID 3.
This proves the independent project source/CI boundary only. A Harbor image,
Kubernetes namespace, route, telemetry acceptance, and rollback still do not
exist for the application.

Legacy GitLab runner ID 2 (`ansible-jenkins-runner-01`) is paused and its
container is absent from `gitlab.example.com`. Retirement, rollback restore,
final retirement, and zero-change convergence passed through AWX jobs 713,
717, 721, and 725. CI execution therefore remains off the GitLab application
VM.

`awx-execution.example.com` is accepted as the bounded non-production
execution plane. AWX instance 3 is enabled and Ready only in
`lab-infrastructure`; canaries 743 and 747 executed there. NGINX stream TLS
passthrough is the only network-facing socket on TCP 443, while Receptor 1.4.8
binds only `127.0.0.1:27199` with no backend firewall opening. Removal 744,
restore 745, zero-change install 748, and final validation 749 passed at
canonical source revision `7b931558`.

The four-node application cluster currently contains the control-plane
components, CoreDNS, Flannel, Headlamp, the accepted single-replica
ingress-nginx tier, and Longhorn 1.12.0 V1. Longhorn schedules only the three
worker `/data/longhorn` disks and retains a healthy three-replica acceptance
volume. Argo CD, MetalLB, cert-manager, Kyverno, External Secrets Operator,
metrics-server, Velero, OpenTelemetry Operator, Trivy Operator, and Argo
Rollouts are not installed in the current cluster and must not be reported as
completed.

Do not treat AWX's local k3s context as the application cluster. Application
acceptance must use `/etc/kubernetes/admin.conf` on
`k8s-control.example.com`, confirm all four expected node names, and record the
API server version before collecting evidence. AWX platform-cluster evidence
must be labeled separately. See INC-2026-045.

## Application access

The access tier is migrating sequentially from the shared non-HA
`nginx.example.com` VM to NGINX running on each product VM. AWX is the first
accepted migration: `awx.example.com` resolves directly to `192.168.1.103`,
local NGINX forwards port 80 to NodePort `32000`, and
`awx.apps.example.com` has been removed. AWX jobs 485/492 and DNS jobs
502/514 prove first convergence and zero-change idempotence.

`nginx.example.com` remains online temporarily for GitLab, Prometheus,
Alertmanager, Grafana, MinIO, Loki, Tempo, OpenTelemetry HTTP, Kibana, and
Vault. It must not be retired until each consumer is migrated and accepted in
a separate sequential change. Headlamp is no longer a shared-proxy consumer:
`headlamp.example.com -> 192.168.1.108` reaches worker01-local NGINX on TCP 80,
and both Headlamp and ingress-nginx are ClusterIP-only. Vault uses HTTPS with the
version-controlled backend certificate as its trust anchor. Source-restricted
firewalld rules allow only
approved lab-LAN consumers to reach Loki and Tempo and allow the Kubernetes
pod CIDR to reach the OpenTelemetry receivers.

The target convention uses canonical `<product>.example.com` names for both
service identity and user access. Services not yet migrated continue to use
their existing `*.apps.example.com` URL; for example,
`gitlab.apps.example.com` still redirects through the shared proxy.

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
- Kubernetes Helm delivery:
  CHG-2026-009 is accepted and closed. Dedicated `jenkins-agent01` owns the
  reviewed Helm workflow; the controller has zero executors. Corrected PLAN
  build 3 used Kubernetes revision `d206ab3f` and shared-library revision
  `e9790766`. DEPLOY builds 4/5, rollback build 6, and restore build 7 produced
  accepted Helm revisions 1-4. Edge builds 2-7 launched bounded AWX jobs 760,
  772, 782, 792, 802, and 812 for transitional DNS, worker01-local NGINX,
  final DNS, shared-route retirement, ClusterIP cutover, and zero-change
  convergence. The final ingress controller is 1/1 Ready with zero restarts;
  its Service and Headlamp are ClusterIP-only. Authoritative serial
  `2026080302` publishes `headlamp.example.com -> 192.168.1.108`; the legacy
  name is NXDOMAIN. TCP 30080/30081/30444 has no listener or firewall opening
  on any cluster node. INC-2026-078, INC-2026-081, and INC-2026-082 are
  resolved. See the
  [runtime acceptance evidence](evidence/CHG-2026-009-kubernetes-ingress-acceptance.md).
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

The readiness baseline was collected directly through 2026-07-29 and includes
the accepted Jenkins, GitLab Runner, AWX execution-plane, and Kubernetes
ingress changes completed through 2026-08-03:

| Capability | Live evidence | Readiness |
| --- | --- | --- |
| Hypervisor capacity | infra01 has 17/17, infra02 has 14/14, and infra03 has 4/4 domains running; infra01 bridge correction and one controlled guest reboot passed | Monitoring under INC-2026-046 |
| Kubernetes base | Explicit `kubernetes-admin@kubernetes` context reports server 1.34.10, 4/4 nodes Ready, no non-running pods, and no active Jobs | Accepted after infra01 recovery |
| Persistent Kubernetes applications | Longhorn 1.12.0 V1 uses only three worker `/data/longhorn` disks; the default Retain StorageClass, Bound acceptance PVC, healthy attached volume, three worker-separated replicas, and persistent marker passed convergence, recreation, rollback, and restore | Accepted through CHG-2026-010 |
| Kubernetes application ingress | `IngressClass/nginx`, one Ready ingress-nginx controller, ClusterIP-only Services, and worker01-local NGINX expose `headlamp.example.com` on TCP 80 | Accepted through CHG-2026-009 |
| Elastic host logging | Filebeat active and encrypted-output validation passed on 31/31 Rocky Linux VMs; Logstash queue empty; all 31 inventory hostnames present in Elasticsearch | Accepted |
| Prometheus metrics | 32/32 configured targets Up after AWX job 321: Prometheus plus 31 Node Exporters | Accepted for all Rocky Linux VMs |
| Grafana visualization | AWX job 356 provisioned Prometheus, Loki, and Tempo data sources plus the Server Fleet Overview dashboard | Accepted for metrics, logs, and trace exploration |
| Loki log pipeline | AWX job 381 returned one run-specific stream containing the accepted Tempo trace ID | Accepted for the bounded correlated workload |
| Tempo trace pipeline | AWX job 381 found and retrieved trace `f819ea257b72ff3a7fd5998e807b3430`, then correlated it to the Loki event | Accepted for the bounded correlated workload |
| Management applications | GitLab, AWX, Prometheus, Grafana, Kibana, and the Headlamp NGINX route returned HTTP responses; Jenkins returned the expected authenticated HTTP 403 | Available |
| Headlamp name resolution | Authoritative serial `2026080302` returns `headlamp.example.com -> 192.168.1.108`; the legacy `.apps` name is NXDOMAIN; canonical HTTP returns 200 | Accepted through AWX jobs 760 and 782 and CHG-2026-009 |
| Vault secrets service | Vault 2.0.3 reports initialized, unsealed, active, and HTTP 200 through the verified NGINX TLS upstream; NGINX convergence job 421 reported `changed=0`, `unreachable=0`, and `failed=0` | Accepted through AWX jobs 417 and 421 |
| AWX inventory boundaries | Product VMs are canonical in `production`; infra01/02/03 are isolated in `cloud-infra-production`; the four Kubernetes records remain a deliberate cluster RBAC boundary | Accepted through sync job 425 and DNS/NGINX jobs 433, 438, 443, and 448 |
| AWX execution boundary | Instance 3 is Ready only in `lab-infrastructure`; canaries ran on `awx-execution.example.com`; NGINX TCP 443 is reachable and direct Receptor TCP 27199 is not | Accepted through jobs 741-749 and CHG-2026-008 |

The platform can deploy and exercise stateless applications through
ClusterIP-backed Ingress and stateful applications through the accepted
Longhorn StorageClass. The shared telemetry and storage foundations are
accepted; each application must still prove its own persistence, backup,
service-specific telemetry, dashboards, alerts, and SLOs.

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
5. Complete CHG-2026-011: recover the GitOps repository, bootstrap private
   Argo CD 3.4.6, and accept restricted canary reconciliation, convergence,
   rollback, and restore before delegating another resource.
6. Define and accept a separate Longhorn backup-target, credential, retention,
   and restore boundary before assigning storage to Artifactory.
7. Connect Prometheus alert delivery to Alertmanager and validate a test alert.
8. Apply application dashboards, alert rules, and SLOs from
   `observability-sre-platform`.
9. Configure production alert receivers.
10. Decide whether Loki and Tempo should move from local storage to MinIO.
11. Back up `/etc/midhhealth/elastic-stack` through the restricted platform
    secret-backup process.
12. Configure reverse-proxy TLS and SSO for Kibana.
13. Enroll structured Jenkins, AWX job, Kubernetes ingress, PostgreSQL,
    application, AI, and MLOps log classes through the Logstash boundary.
14. Register `midh-ai-edge-01` as the Mac Studio AI/ML development endpoint.
15. Define `infra03` Kubernetes labels and workload placement guardrails before
    assigning VMs from its reserved `.141–.160` block.
16. Migrate Elasticsearch01–03 and the Kubernetes control plane/workers to the
    `infra03-images` pool, validate application and cluster health, then retire
    the confirmed source domains to free infra01/02 capacity.
