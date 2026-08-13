# Observability and SRE Domain

**Repository:** `midhhealth/reliability-operations/observability-sre-platform`  
**Supporting repositories:** `ansible-observability`, `ansible-prometheus`  
**Team size:** 7 engineers

## Team Responsibilities

The observability and SRE team owns the telemetry, alerting, SLO, and incident
evidence layer used by every MidhHealth platform and application team.

| Team member | Primary responsibility |
| --- | --- |
| SRE Lead | Owns reliability standards, SLO governance, incident review process, and operational priorities. |
| Metrics Engineer | Maintains Prometheus, exporters, recording rules, alert rules, and capacity dashboards. |
| Logging Engineer | Maintains Loki, Elastic, Splunk integration patterns, parsing, retention, and search workflows. |
| Tracing Engineer | Owns OpenTelemetry, Tempo, distributed tracing, service dependency maps, and trace quality. |
| Alerting and On-Call Engineer | Tunes alert routes, burn-rate alerts, deduplication, escalation, and incident handoff. |
| Reliability Automation Engineer | Connects alerts to runbooks, AWX jobs, triage reports, and safe remediation workflows. |
| Observability Cost Engineer | Controls high-cardinality metrics, log volume, trace sampling, retention, and telemetry cost. |

## Connected Teams

- Receives telemetry from applications, Kubernetes, VMs, databases, network, AI, and MLOps.
- Provides health gates to delivery and rollback signals to resilience operations.
- Provides compliance and incident evidence to governance.

## Executable Use-Case Scope

- OpenTelemetry instrumentation, eBPF observability, logs, metrics, traces, and profiling.
- SLO as code, burn-rate alerting, deployment health scoring, and synthetic monitoring.
- Change-to-incident correlation and automated incident triage.
- Telemetry cost optimization and high-cardinality management.
- Service dependency mapping and RCA evidence capture.
