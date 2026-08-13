# Use-Case Documentation Standard

Last verified: 2026-08-13

This directory turns the enterprise portfolio into work that an engineer can
implement, test, operate, and audit. The portfolio summary remains in
`enterprise-project-portfolio-and-usecases.md`; the detailed record for each
use case lives here.

The [enterprise traceability register](enterprise-traceability.md) maps all 12
platforms and their 224 canonical use cases to provider, payer, shared digital
platform, risk, and resilience outcomes. Use it to verify that a proposed page
fits its owning platform and that the platform fits the enterprise model.

## Detailed platform indexes

| Platform | Detailed use-case designs | Design status |
| --- | ---: | --- |
| DevSecOps delivery | [15](devsecops/README.md) | Complete |
| Multi-cloud infrastructure | [12](infrastructure/README.md) | Complete |
| Kubernetes with GitOps | [13](kubernetes/README.md) | Complete |
| Observability and SRE | [16](observability/README.md) | Complete |
| Governance and operations | [19](governance/README.md) | Complete |
| Linux systems engineering | [24](linux/README.md) | Complete |
| Database reliability | [19](database/README.md) | Complete |
| Resilience and service operations | [20](resilience/README.md) | Complete |
| Data engineering and integration | [25](data/README.md) | Complete |
| Network engineering and automation | [31](network/README.md) | Complete |
| Healthcare AI | [15](healthcare-ai/README.md) | Complete |
| MLOps model platform | [15](mlops/README.md) | Complete |
| **Total** | **224** | **Design complete; implementation separately scheduled** |

All 224 canonical use cases have a dedicated page. The pages are architecture
and delivery designs: they explain the organizational need, platform fit,
enterprise value, actors, workflow, controls, dependencies, failure behavior,
acceptance criteria, and a plan for later implementation. They do not claim
that code or runtime execution exists, and they do not authorize new
infrastructure. When implementation is scheduled later, verified evidence can
flow back into the corresponding page.

Start from the canonical portfolio when reviewing enterprise coverage, or use
the platform indexes above when reviewing a platform backlog. Both navigation
paths link to every detailed page; no use-case design should require browsing
the repository tree to find it.

Detailed designs may be developed across the portfolio without starting their
implementation. Implementation and acceptance are separately scheduled and
tracked so that a documentation update cannot be mistaken for authorization to
change the lab.

## Required use-case content

Every use-case document must contain:

1. a unique ID, owner, status, related change, and target environment;
2. a plain-language purpose and an explicit expected outcome;
3. the trigger, actors, preconditions, scope, exclusions, and safety controls;
4. the end-to-end architecture and execution flow;
5. repository, file, function, role, chart, pipeline, and runbook references;
6. a Jira epic and at least three independently testable Jira stories covering
   design/contract, source validation, and bounded outcome/recovery;
7. a description, acceptance criteria, implementation steps, completed work,
   validation, rollback, and evidence for every story;
8. actual versus expected results and an honest completion decision;
9. screenshot and artifact references; and
10. operational, incident, security, and follow-up notes.

## Architecture-readiness contract

Every detailed page must also make the architecture executable as a future
plan without authorizing infrastructure or runtime work. Required content is:

1. an operating context that distinguishes the enterprise need, current state,
   desired state, accountable platform, target boundary, and no-new-
   infrastructure constraint;
2. a detailed, accessible SVG architecture diagram that shows enterprise
   actors, source and dependency contracts, planned control logic, decision
   gates, accepted execution boundary, existing target, assurance controls,
   evidence, owner acceptance, and recovery. Simple Mermaid block flows do not
   satisfy this requirement. The visual form must fit the work: use a delivery
   pipeline, data flow, feedback loop, controlled lifecycle, service path,
   decision map, or response timeline as appropriate instead of forcing every
   capability into the same layout;
3. explicit upstream and assurance dependencies linked by canonical use-case
   ID, including the artifact exchanged and the effect of missing evidence;
4. functional, performance, scale, reliability, recovery, observability, and
   retention requirements. Unapproved numeric targets remain owned `TBD`
   decisions rather than invented values;
5. trust boundaries covering source contribution, CI evaluation, privileged
   execution, target access, evidence, identity, credential ownership,
   rotation, and emergency revocation;
6. selected architecture decisions, deferred alternatives, rationale, and open
   decisions with an owner and resolution gate;
7. exact planned repository-relative locations for the contract,
   implementation, result schema, fixtures, CI include, and operator runbook;
   and
8. staged delivery from contract and source validation through read-only proof,
   separately approved canary execution, independent verification, and
   recovery.

Shared control language is permitted where it expresses a genuine enterprise
standard. Stock prose that merely substitutes a use-case name into the same
paragraph is not detailed architecture. Purpose, expected outcome, diagrams,
dependencies, risks, and implementation responsibilities must describe the
actual capability.

## Linux end-to-end IaC contract

Every `UC-LNX-*` page is an implementation specification as well as a training
record. The portfolio table remains the only authoritative list and count; the
detailed pages explain how the approved scope will be delivered. Each Linux
page must additionally contain:

1. an IaC delivery model that assigns infrastructure lifecycle to Terraform or
   libvirt automation, bootstrap to image/cloud-init source, operating-system
   desired state to Ansible, source gates to GitLab CI, approval/orchestration
   to Jenkins, and controlled execution to AWX;
2. an honest current-state statement that distinguishes existing source,
   planned source, code-complete work, runtime verification, and acceptance;
3. concrete inventory variables, repository paths, execution stages, canary
   limits, validation commands, expected evidence, idempotence checks, and a
   rollback or recovery path;
4. at least three independently testable Jira stories covering source/design,
   controlled execution, and acceptance/rollback;
5. production-like failure modes and troubleshooting order; and
6. one purpose-built SVG architecture diagram that shows the actual source,
   approval, execution, runtime, evidence, and recovery path for that page; and
7. at least nine interview questions spanning implementation, architecture,
   design tradeoffs, troubleshooting, security, rollback, and behavioral
   ownership, with answer signals rather than memorized scripts.

Write as an experienced engineer explaining real work to another engineer.
Avoid stock openings such as `This use case...` and formulaic Jira prose such
as `As a ..., I need ...`. Story descriptions must still make the owner, need,
operational value, and boundary clear, but they should read naturally.

Documentation may describe planned paths needed for the end state, but it must
label them `Planned`. A path, job, pipeline, screenshot, or outcome must never
be presented as existing or successful until it is verified in the named
repository or runtime environment.

## Jira story contract

Each story must include these fields:

| Field | Requirement |
| --- | --- |
| Summary | One observable outcome, not a broad project name |
| Description | Actor, need, business or operational value, and bounded scope |
| Preconditions | Dependencies that must exist before work starts |
| Acceptance criteria | Testable statements, preferably Given/When/Then |
| Implementation steps | Ordered engineering actions with exact code locations |
| Completed work | Commit, file, configuration, or runtime action already completed |
| Validation | Command, CI pipeline, Jenkins build, AWX job, API result, or dashboard result |
| Rollback | A tested reversal path or an explicit safe stop point |
| Attachments | Screenshot or generated artifact with capture time and source |
| Status | Planned, In progress, Code complete, Runtime verified, Accepted, or Blocked |

Passing source validation is `Code complete`; it is not runtime acceptance.
Screenshots are supporting evidence and never replace machine-readable results.
Do not use mock images, edited success states, or screenshots from a different
environment as acceptance evidence.

## Evidence naming

Store screenshot attachments under:

```text
docs/assets/use-cases/<USE-CASE-ID>/
```

Use this filename pattern:

```text
<story-id>-<evidence-purpose>-<YYYYMMDD-HHMM>-<timezone>.png
```

Each image must be listed in the use-case evidence register with its source
system, execution ID, UTC capture time, expected observation, and review
status. Secrets, access tokens, credentials, protected health information,
and unrelated browser content must be redacted before publication.

## Completion rule

A use case is `Accepted` only when every required story is accepted, the
expected outcome is observed in the target environment, rollback or recovery
is exercised, incidents are linked, documentation validation passes, and the
documentation repository is published and clean.
