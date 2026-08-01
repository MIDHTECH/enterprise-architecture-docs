# CHG-2026-005: Configure Dedicated Application GitLab Runner

## Change record

| ServiceNow field | Value |
| --- | --- |
| Number | `CHG-2026-005` |
| Type | Normal |
| State | Implement |
| Risk | Moderate |
| Impact | Low |
| Priority | High |
| Configuration item | `gitlab-runner-app01.example.com` |
| Service | GitLab CI |
| Environment | MIDHTECHLAB production simulation |
| Assignment group | Platform Engineering |
| Requested by | MIDHTECHLAB operator |
| Requested date | 2026-08-01 |
| Expected outage | None; accepted runners remain available |
| Implementation owner | Current sequential Codex infrastructure task |

## Scope and justification

Configure only the existing Rocky 9.8 guest at `192.168.1.136`. Reuse and
reconcile existing GitLab runner ID 3 as an instance runner with description
`gitlab-runner-app01.example.com`, exact `app,docker` tags, untagged jobs
disabled, and a pinned `gitlab/gitlab-runner:v19.2.0` Docker executor with
initial concurrency 1. Instance scope permits tagged application work from the
twelve-platform program without running CI inside the GitLab VM.

The shared runner and retirement of the GitLab-VM runner are out of scope.

## Implementation and validation

1. Extend the accepted runner automation to support explicitly selected
   instance scope without weakening the project-scoped infrastructure runner.
2. Add exact `.136` inventory, deploy/rollback playbooks, and a variable-gated
   application canary.
3. Pass local checks, branch CI, and canonical-main CI.
4. Synchronize AWX to the exact accepted revision and deploy only `.136`.
5. Verify identity, tags, version, coordinator contact, container, metrics,
   logs, and a tagged canary.
6. Run rollback, prove the identity paused/container absent/config preserved,
   restore, and require a final zero-change convergence.
7. Publish evidence and close this record before starting the shared runner.

## Backout plan

Run only the focused AWX rollback playbook. Pause runner ID 3, remove only its
container, preserve `/srv/gitlab-runner/config`, and leave all accepted runners
and GitLab services unchanged.

## Pre-change evidence

- GitLab pending/running jobs: 0.
- AWX active jobs: 0.
- Target mutation processes: 0; Docker absent.
- Runner ID 3: instance type, active, untagged false, tags `app,docker`, never
  contacted.
- `CHG-2026-004` is closed and pipelines 422/423 published its evidence.

## Closure information

| Field | Value |
| --- | --- |
| Close code | Pending |
| Closed date | Pending |
| Implementation result | Pending |
| Validation evidence | Pending |
