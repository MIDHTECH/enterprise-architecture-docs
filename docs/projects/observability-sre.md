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

## What operators need from this platform

The observability platform should let an on-call engineer start with a failed
user action and move through the service, release, dependency and underlying
host without guessing which dashboard to open. Telemetry is useful only when
it carries ownership and release identity and leads to a decision.

![Observability and SRE architecture](../assets/project-4-sre-observability-architecture.svg)

## Signal path in the current lab

| Signal | Collection and storage | Operational use |
| --- | --- | --- |
| Host and service metrics | Node Exporter and service exporters into Prometheus | Saturation, availability, capacity and SLO inputs |
| Logs | Filebeat from managed Rocky Linux hosts through encrypted Logstash to Elasticsearch; selected application logs may also use Loki | Search, audit, failure context and fleet comparison |
| Traces | OpenTelemetry Collector into Tempo for approved instrumented workloads | Request path and dependency latency |
| Synthetic checks | Prometheus Blackbox Exporter against named endpoints | User-path availability independent of application internals |
| Alerts | Prometheus rules to Alertmanager | Owned, deduplicated incident signals |
| Visualization | Grafana across Prometheus, Loki and Tempo; Kibana for Elastic data | Shared investigation and release evidence |

Prometheus, Alertmanager, Grafana, Loki, Tempo, the OpenTelemetry Collector,
MinIO and the Elastic Stack are running. Metrics cover the managed Rocky Linux
fleet, encrypted host logging has accepted fleet evidence, and a bounded
Loki/Tempo correlation path has been proven. This does not mean every product
or future application is instrumented, has an SLO, or has a tested alert route.
Splunk remains uninstalled and must stay a reference pattern.

## Service telemetry contract

Each application deployment record must define a stable service name,
environment, version or artifact digest, owner and business capability. Those
labels follow metrics, logs, traces, dashboards, alerts and release markers.
The project also supplies:

- a health signal that reflects user value rather than process existence;
- latency, traffic, error and saturation views appropriate to the service;
- dependency signals for database, network, queue, storage or model endpoints;
- an SLI query, SLO intent, evaluation window and threshold decision;
- alert ownership, severity, runbook and expected first response; and
- retention and sampling choices that match investigation and privacy needs.

High-cardinality patient, member, claim, token, request-body or free-text data
does not belong in labels. Protected data is minimized at instrumentation time,
not removed later from every query.

## Release-aware operations

Deployment markers carry the repository revision, artifact digest, pipeline
run and target. A health gate compares the new release with its baseline using
explicit queries and a bounded observation window. A failed gate does not
automatically prove the release caused the symptom; it stops promotion and
provides evidence for a rollback or incident decision.

The standard investigation follows the user path: DNS and reachability,
reverse proxy or ingress, service endpoints, process or pods, node/VM pressure,
storage, database and downstream dependencies. Recent changes are overlaid on
that path. This keeps a Kubernetes outage from becoming “restart pods first”
and a database latency event from becoming “add CPU first.”

## Alert and SLO design

Alerts are based on actionability. Page-worthy conditions need a named owner,
real user or error-budget impact, a runbook, and a reasonable action. Warning
signals may create work without waking someone. Multi-window burn-rate rules
separate a fast, severe failure from a slower erosion of the objective.

SLOs are versioned beside their recording and alerting rules. Thresholds are
decided with the service owner after observing a trustworthy baseline; the
platform does not manufacture precise numbers for an application that does not
yet exist.

## Failure behavior

| Failure | Operator response |
| --- | --- |
| Collector or exporter unavailable | Preserve local buffering where configured, alert on missing coverage, and distinguish “no data” from “healthy” |
| Log or metric surge | Protect the platform with quotas/sampling, identify the source and preserve a bounded incident sample |
| Cardinality explosion | Reject or relabel the offending dimension and verify query/storage recovery |
| Alert storm | Group and inhibit related symptoms while retaining the initiating condition and dependency context |
| Dashboard unavailable | Use source queries and documented CLI/API checks; visualization is not the only diagnostic path |
| Conflicting signals | Record clock, label and sampling gaps; do not force a single narrative before evidence agrees |

## Implementation and acceptance path

Start with fixture-validated rules, dashboards and OpenTelemetry configuration
in the platform repository. Add one service pack at a time, validate syntax and
queries, deploy through Jenkins/AWX, inject a known marker or failure, confirm
collection and routing, and exercise rollback. Acceptance records the source
revision, AWX/Jenkins IDs, target versions, queries, timestamps, expected and
observed alerts, dashboard links, negative privacy checks, rollback and service
owner sign-off. The scenario catalog is in the
[observability use-case index](../use-cases/observability/README.md).
