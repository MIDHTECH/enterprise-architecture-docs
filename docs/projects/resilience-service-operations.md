# Resilience and Service Operations Domain

**Repository:** `midhhealth/reliability-operations/resilience-service-operations`  
**Team size:** 5 engineers

## Team Responsibilities

The resilience team turns telemetry, incidents, service ownership, and recovery
requirements into controlled operating workflows.

| Team member | Primary responsibility |
| --- | --- |
| Service Operations Lead | Owns service catalog, readiness reviews, severity model, and operational priorities. |
| SLO and Error-Budget Engineer | Defines SLIs/SLOs, burn-rate policies, error budgets, and release reliability gates. |
| Incident Response Engineer | Maintains incident classification, evidence capture, escalation, communication, and post-incident review. |
| Resilience Test Engineer | Runs synthetic checks, load tests, capacity tests, chaos exercises, and DR rehearsals. |
| Remediation Workflow Engineer | Connects runbooks, AWX jobs, approvals, recovery validation, and follow-up actions. |

## Connected Teams

- Consumes telemetry from observability and change records from delivery, infrastructure, Kubernetes, and governance.
- Works with database, Linux, network, data, AI, and MLOps teams during incident and recovery workflows.
- Provides readiness and recovery evidence to business operations and audit.

## Executable Use-Case Scope

- SLO governance, incident detection, escalation, evidence collection, post-incident review, and problem management.
- Dependency mapping, synthetic monitoring, load testing, chaos exercises, backup/recovery orchestration, and DR exercises.
- AWX automated remediation, maintenance-window management, and operational readiness reviews.

## Where resilience work begins

Resilience starts before an incident. A service cannot be recovered coherently
unless its owner, dependencies, acceptable loss, previous release, runbook and
decision authority are known. This domain makes that operating record the join
point between otherwise separate platform and application projects.

![Resilience operations architecture](../assets/project-8-resilience-operations-architecture.svg)

## Service readiness record

Every onboarded service identifies:

- the business capability and accountable technical owner;
- user entry points and upstream/downstream dependencies;
- SLI/SLO intent, escalation route and severity rules;
- release and configuration sources of truth;
- rollback, data restore and infrastructure recovery boundaries;
- RPO/RTO intent and the evidence used to measure them;
- capacity limits, degradation behavior and safe traffic controls; and
- communication, compliance and follow-up owners.

The record references evidence from owning repositories. It does not copy a
stale version of every runbook or dashboard into one giant operations file.

## Incident operating model

| Phase | What the team does |
| --- | --- |
| Detect | Confirm user impact and telemetry quality; identify the service and current release |
| Declare | Assign severity, incident lead, operations lead, communications and evidence recorder |
| Stabilize | Stop risky changes, protect data, reduce blast radius and select a reversible mitigation |
| Diagnose | Walk the dependency path and recent changes; test hypotheses against timestamps and signals |
| Recover | Roll back, restore, fail over, repair or degrade under the named authority |
| Verify | Check user path, data integrity, backlog, SLO and recurrence indicators |
| Learn | Write a blameless timeline, contributing conditions and owned actions with due dates |

Automation may gather context or execute a proven bounded runbook. It does not
declare the incident resolved. A human incident lead judges recovery from user
and data outcomes.

## Exercises that produce useful evidence

The lab can rehearse bounded failures without inventing production history:
an unavailable Kubernetes service path, an exhausted or failed build agent, a
database restore, a DNS or proxy change, telemetry loss, and a capacity/cost
decision using fixtures. Each exercise states the injected condition, expected
detection, safety boundary, recovery target and stop condition. It never uses
real protected data.

Load and chaos work follows capacity review. A test that can destabilize shared
GitLab, Jenkins, AWX, DNS, PostgreSQL or observability services requires an
isolated boundary or explicit change approval; “resilience testing” is not
permission to interrupt the lab.

## Failure decisions

| Situation | Decision principle |
| --- | --- |
| Recent release correlates with failure | Roll back when compatibility and data state make it safer than diagnosis in place |
| Dependency fails | Degrade or queue work if the service contract supports it; avoid retry storms |
| Data correctness is uncertain | Prefer stopping writes and preserving evidence over fast but unsafe availability |
| Automated remediation repeats | Disable it, preserve its action history and return control to the incident lead |
| Recovery exceeds RTO | Escalate business impact and choose the next documented recovery tier |
| Service appears healthy but users fail | Continue through DNS, routing, identity and dependency paths; process health is insufficient |

## Implementation and exercise sequence

Begin with the service-readiness schema and synthetic incident fixtures in the
repository. Validate ownership, severity, timestamps and evidence links before
connecting live telemetry. Add read-only context gathering next, then a
human-launched AWX recovery against a bounded target. Only after rollback,
stop conditions and repeated recovery are proven may a narrowly scoped action
be considered for closed-loop execution. Every exercise is labeled as lab
evidence, not presented as an actual production incident.

## Operational readiness and acceptance

Readiness review is a release decision, not a questionnaire. The owner
demonstrates health queries, alert routing, a current runbook, a known-good
rollback, backup/restore where state exists, dependency failure behavior and a
time-bounded recovery exercise. The evidence includes timestamps, roles,
commands or jobs, decision points, user-path verification and remaining risk.
Open gaps become owned work; they are not rewritten as accepted controls. The
scenario catalog is in the [resilience use-case index](../use-cases/resilience/README.md).
