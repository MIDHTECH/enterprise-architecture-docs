# Current Environment State

Last verified: 2026-07-27

## Enterprise project portfolio

The architecture represents **MidhHealth Integrated Care**, a fictional
enterprise care delivery and health insurance organization with a hybrid
on-premises and cloud platform. The ten projects are platform domains inside
that organization, not separate standalone labs. They support provider
workflows, payer workflows, analytics, security, and shared platform
operations. They share GitLab, Jenkins, AWX, Ansible/Terraform patterns,
governance standards, environment promotion, and operational evidence.

Projects 1–10 have implementation repositories. Projects 6–10 are active first
slices against the existing VM fleet: Linux systems, database reliability,
resilience/service operations, data engineering, and network engineering. They
do not imply new product installation. A separate capacity plan now tracks a
third memory-optimized Linux server and a Mac Studio M1 AI/ML edge development
node.

The authoritative scope and all 217 use cases are maintained in
[Enterprise Project Portfolio and Use Case Coverage](enterprise-project-portfolio-and-usecases.md).

## Hybrid capacity plan

The lab is moving from a two-node on-premises base toward a hybrid engineering
footprint that separates platform runtime, high-memory workloads, and AI/ML
development.

| Environment | Planned role | Workload boundary |
| --- | --- | --- |
| `infra01` | Core platform and VM host | GitLab, Jenkins, AWX, DNS, proxy, and selected shared product VMs |
| `infra02` | General platform and application host | Kubernetes workers, integration workloads, observability targets, and supporting VMs |
| `infra03` | Planned 256 GB memory-optimized Linux server | Data engineering, observability scale, AI/ML batch jobs, model-serving backends, and resilience exercises |
| `midh-ai-edge-01` | Mac Studio M1, 32 GB RAM, 512 GB disk | AI/ML development, local inference, embeddings, notebooks, prompt and model evaluation, and CI smoke tests |

The Mac Studio is not a primary Kubernetes worker and is not a regulated
production data host. It is used as an engineering workstation and edge
inference environment for non-production AI/ML workflows. The planned
memory-optimized Linux server is the preferred placement for backend AI/ML,
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

Node Exporter 1.11.1 is installed on managed platform hosts.

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

## Remaining integration work

1. Run the Jenkins seed job so `projects/run-ansible-playbook` is created or
   refreshed from `jenkins-jobs`.
2. Configure AWX GitLab SSH host trust for `gitlab.example.com:2222`.
3. Confirm AWX SCM and machine credential IDs for the Linux VM fleet.
4. Run preflight smoke tests for Projects 6–10 through Jenkins/AWX.
5. Provision Grafana data sources for Prometheus, Loki, and Tempo.
6. Connect Prometheus alert delivery to Alertmanager and validate a test alert.
7. Apply dashboards, alert rules, and SLOs from `observability-sre-platform`.
8. Configure production alert receivers.
9. Decide whether Loki and Tempo should move from local storage to MinIO.
10. Add TLS, SSO, and restricted network access.
11. Register `midh-ai-edge-01` as the Mac Studio AI/ML development endpoint.
12. Plan `infra03` hardware installation, network identity, storage layout,
    Kubernetes labels, and workload placement guardrails.
