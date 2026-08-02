# Use-Case Implementation Status

Last verified: 2026-08-02

Detailed use cases are expanded and accepted sequentially under the
[use-case documentation standard](use-cases/README.md). The first expanded
record is
[UC-CICD-001: End-to-End CI/CD Pipeline Setup](use-cases/devsecops/UC-CICD-001-end-to-end-cicd-pipeline.md).

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
| Explicitly implemented first slices | 10 | Code exists for the bounded automation listed below |
| Fully accepted portfolio use cases | Not yet centrally evidenced | Do not infer acceptance from infrastructure or repository presence |

Defined scope and counts are maintained only in the
[canonical portfolio](enterprise-project-portfolio-and-usecases.md). This
status document intentionally does not duplicate them. Definition does not
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

The portfolio total and this status document must be updated together whenever
a use case is added, removed, or accepted.
