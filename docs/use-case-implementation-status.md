# Use-Case Implementation Status

The current program goal is design completion before additional lab
implementation. See [Enterprise Design Readiness
Status](design-readiness-status.md). This page intentionally tracks the later
code and runtime phase separately so architecture-ready never means deployed.

Last verified: 2026-08-13

All 226 canonical use cases now have detailed organizational and platform
designs under the [use-case documentation standard](use-cases/README.md). Each
page explains purpose, enterprise and platform fit, actors, prerequisites,
workflow, controls, evidence, failure behavior, recovery, Jira work, and future
acceptance. Each design also records its existing-lab context, architecture
diagram, linked cross-use-case handoffs, quality attributes, trust boundaries,
architecture decisions, and exact planned source paths. Design completion does
not promote a use case to implemented, runtime verified, or accepted.

## Purpose

This document separates portfolio definition, code implementation, runtime
execution, and acceptance. A repository, playbook, VM, or running product does
not by itself make an enterprise use case complete.

## Status model

| State | Required evidence |
| --- | --- |
| Defined | Use case exists in the canonical portfolio |
| Scaffolded | Repository structure or design exists, but no executable outcome |
| Implemented in code | Executable script, playbook, pipeline, or policy exists and passes repository validation |
| Runtime verified | Automation ran against the intended environment and produced current evidence |
| Accepted | Runtime evidence, expected outcome, rollback or recovery path, and staff runbook were reviewed |

## Current count

| Measure | Count | Interpretation |
| --- | ---: | --- |
| Architecture-ready use-case designs | 226 | Documentation covers context, diagram, dependencies, quality, security, decisions, implementation paths, evidence, and recovery across all 12 platforms; code and execution remain separately governed |
| Explicitly implemented first slices | 10 | Code exists for the bounded automation listed below |
| Fully accepted portfolio use cases | Not yet centrally evidenced | Do not infer acceptance from infrastructure or repository presence |

The canonical scope and authoritative platform counts remain in the
[canonical portfolio](enterprise-project-portfolio-and-usecases.md). The design
total is repeated here only to distinguish the completed documentation phase
from the later implementation program. Definition and detailed design do not
imply implementation.

## Explicitly implemented first slices

| Use case | Repository | Current boundary |
| --- | --- | --- |
| Terraform drift detection | `cloud-infra-automation-platform` | Plan JSON analysis |
| Terraform plan analysis | `cloud-infra-automation-platform` | Change summary generation |
| Infrastructure change-impact analysis | `cloud-infra-automation-platform` | Resource-to-service impact mapping |
| Cloud misconfiguration detection | `cloud-governance-ops-automation` | Evidence and recommendation output |
| Kubernetes configuration-drift detection | `kubernetes-platform-gitops` | Desired-versus-observed comparison code; live GitOps stack is not installed |
| Deployment health scoring | `observability-sre-platform` | Release telemetry scoring |
| Change-to-incident correlation | `observability-sre-platform` | Change evidence attached to incident context |
| Cloud cost anomaly detection | `cloud-governance-ops-automation` | Advisor output |
| Resource right-sizing recommendations | `cloud-governance-ops-automation` | Recommendation-only slice |
| Centralized Rocky Linux fleet logging | `ansible-observability` | Accepted on 31/31 VMs through encrypted Filebeat, Logstash, and inventory-based Elasticsearch verification |

Linux systems, database reliability, resilience, data engineering, and network
engineering contain executable first-slice playbooks. The Linux portfolio now
includes market-calibrated additions, but they remain defined backlog until
corresponding code and passing validation exist. The existing Linux first slice
also remains below `implemented in code`: live GitLab main pipeline 250 failed
because all three validation jobs had no matching runner, and no successful
repository pipeline is recorded. The other executable specialist slices remain
`implemented in code` until Jenkins/AWX execution records and acceptance
evidence are added. Healthcare AI and MLOps remain repository scaffolds.

## Acceptance recording

For every use case promoted to `Runtime verified` or `Accepted`, record:

1. project and exact use-case name;
2. repository commit and pipeline, Jenkins, or AWX job ID;
3. target environment and execution time;
4. expected and observed outcome;
5. evidence artifact or dashboard;
6. failure and rollback validation;
7. reviewing engineer and follow-up work.

Additions and removals are recorded only in the canonical portfolio, with the
matching detail-page link created or retired in the same change. This status
document changes only when implementation or acceptance evidence changes.
