# Enterprise Observability and SRE Reliability Platform: Detailed Use Cases

Last verified: 2026-08-13

This index contains all 16 canonical use cases owned by the
Enterprise Observability and SRE Reliability Platform. Together they turn existing telemetry into actionable health and incident evidence for enterprise services. Implementation belongs
in `midhhealth/reliability-operations/observability-sre-platform` and must reuse existing Prometheus, Alertmanager, Grafana, Loki, Tempo, OpenTelemetry, Elastic, and GitLab/AWX paths.

No page in this directory authorizes a new monitoring VM, telemetry backend, paging product, or unapproved data source. All pages begin as
planned specifications; their individual status changes only after source,
runtime, rollback, and evidence gates are met.

| ID | Use case | Canonical coverage |
| --- | --- | --- |
| `UC-OBS-002` | [Kubernetes Cluster Health Monitoring](UC-OBS-002-kubernetes-cluster-health-monitoring.md) | Dashboards for pods, nodes, namespaces, restarts, and capacity |
| `UC-OBS-003` | [OpenTelemetry Auto-Instrumentation](UC-OBS-003-opentelemetry-auto-instrumentation.md) | Standardized zero-touch metrics, logs and traces for supported workloads |
| `UC-OBS-004` | [Centralized Log Management](UC-OBS-004-centralized-log-management.md) | Logs from pods, VMs, and services collected centrally |
| `UC-OBS-005` | [eBPF Observability](UC-OBS-005-ebpf-observability.md) | Kernel-level telemetry captures runtime behavior where code changes are not practical |
| `UC-OBS-006` | [Alerting and On-Call Notification](UC-OBS-006-alerting-and-on-call-notification.md) | Alerts route to incident channels or PagerDuty-style tools |
| `UC-OBS-001` | [SLO as Code](UC-OBS-001-slo-as-code.md) | Service objectives and alert thresholds are versioned in Git |
| `UC-OBS-007` | [Production Incident Troubleshooting Dashboard](UC-OBS-007-production-incident-troubleshooting-dashboard.md) | Single triage view for incidents |
| `UC-OBS-008` | [Deployment Health Scoring](UC-OBS-008-deployment-health-scoring.md) | Release health combines latency, errors, restarts, logs, traces and synthetic checks |
| `UC-OBS-009` | [API Error Rate Monitoring](UC-OBS-009-api-error-rate-monitoring.md) | Tracks 4xx, 5xx, timeout, and dependency failures |
| `UC-OBS-010` | [Database Performance Monitoring](UC-OBS-010-database-performance-monitoring.md) | Database health and query symptoms can be dashboarded |
| `UC-OBS-011` | [Telemetry Cost Optimization](UC-OBS-011-telemetry-cost-optimization.md) | Noisy metrics, high-cardinality labels, verbose logs and retention costs are controlled |
| `UC-OBS-012` | [Synthetic Monitoring](UC-OBS-012-synthetic-monitoring.md) | External checks validate user-facing availability |
| `UC-OBS-013` | [Cloud-Native Monitoring](UC-OBS-013-cloud-native-monitoring.md) | Cloud-managed services included in dashboards |
| `UC-OBS-014` | [Change-to-Incident Correlation](UC-OBS-014-change-to-incident-correlation.md) | Incidents link to recent commits, deployments, Terraform plans and GitOps syncs |
| `UC-OBS-015` | [Automated Incident Triage](UC-OBS-015-automated-incident-triage.md) | Triage output includes owner, dependency, dashboard, runbook and likely change source |
| `UC-OBS-016` | [Burn-Rate Alerting](UC-OBS-016-burn-rate-alerting.md) | Fast and slow error-budget burn alerts replace noisy symptom-only paging |

## GitLab handoff

1. Create the epic and stories from the selected page in `midhhealth/reliability-operations/observability-sre-platform`.
2. Implement only the planned paths that fit the repository and current lab.
3. Run fixture or read-only validation before requesting a mutating change.
4. Return commit, pipeline, Jenkins/AWX, runtime, recovery, and incident
   evidence to the architecture page.
5. Stop and request a separate architecture decision if new infrastructure,
   capacity, products, or protected-data integration would be required.

