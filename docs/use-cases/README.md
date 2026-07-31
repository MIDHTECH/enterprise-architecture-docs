# Use-Case Documentation Standard

Last verified: 2026-07-31

This directory turns the enterprise portfolio into work that an engineer can
implement, test, operate, and audit. The portfolio summary remains in
`enterprise-project-portfolio-and-usecases.md`; the detailed record for each
use case lives here.

Use cases are expanded and accepted one at a time. A later use case must not
be started while the current use case has an unresolved implementation,
runtime, rollback, evidence, incident, or publication gate.

## Required use-case content

Every use-case document must contain:

1. a unique ID, owner, status, related change, and target environment;
2. a plain-language purpose and an explicit expected outcome;
3. the trigger, actors, preconditions, scope, exclusions, and safety controls;
4. the end-to-end architecture and execution flow;
5. repository, file, function, role, chart, pipeline, and runbook references;
6. a Jira epic and independently testable Jira stories;
7. a description, acceptance criteria, implementation steps, completed work,
   validation, rollback, and evidence for every story;
8. actual versus expected results and an honest completion decision;
9. screenshot and artifact references; and
10. operational, incident, security, and follow-up notes.

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
