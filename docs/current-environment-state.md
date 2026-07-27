# Current Environment State

Last verified: 2026-07-27

## Enterprise project portfolio

The architecture contains ten projects. Projects 1–5 have active
implementation repositories. Projects 6–10—Linux systems, database
reliability, resilience/service operations, data engineering, and network
engineering—are approved planned capabilities. No repository, VM, IP address,
or product installation is implied by their inclusion in the architecture.

The authoritative scope and all 187 use cases are maintained in
[Enterprise Project Portfolio and Use Case Coverage](enterprise-project-portfolio-and-usecases.md).

## GitLab organization

- Group display name: `maas-enterprise-cloud-platform`
- Group path: `maas-enterprise-cloud-platform`
- Visibility: private
- Observability use cases:
  `maas-enterprise-cloud-platform/observability-sre-platform`
- Observability installation:
  `maas-enterprise-cloud-platform/ansible-observability`
- Prometheus, Grafana, and Node Exporter installation:
  `maas-enterprise-cloud-platform/ansible-prometheus`

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

1. Provision Grafana data sources for Prometheus, Loki, and Tempo.
2. Connect Prometheus alert delivery to Alertmanager and validate a test alert.
3. Apply dashboards, alert rules, and SLOs from `observability-sre-platform`.
4. Configure production alert receivers.
5. Decide whether Loki and Tempo should move from local storage to MinIO.
6. Add TLS, SSO, and restricted network access.
