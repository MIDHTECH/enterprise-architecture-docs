# CHG-2026-007: Retire GitLab-VM Runner from CI Execution

## Change record

| ServiceNow field | Value |
| --- | --- |
| Number | `CHG-2026-007` |
| Type | Normal |
| State | Closed |
| Risk | Moderate |
| Impact | Low |
| Priority | High |
| Configuration item | GitLab runner ID 2, `ansible-jenkins-runner-01` |
| Service | GitLab CI |
| Assignment group | Platform Engineering |
| Requested by | MIDHTECHLAB operator |
| Requested date | 2026-08-01 |
| Expected outage | None |

## Scope

Retire only the legacy instance runner ID 2 from execution on the GitLab VM.
Pause the exact GitLab identity and remove only its `gitlab-runner` container.
Preserve `/srv/gitlab-runner/config/config.toml`, its authentication material,
and the runner database row for rollback. Do not change the GitLab application
container or dedicated runner IDs 3, 4, and 5.

## Implementation and validation

1. Pass focused source CI and synchronize the exact revision to AWX.
2. Confirm zero jobs are assigned to ID 2 and all three dedicated runners are
   active, version matched, reject untagged jobs, and have accepted canaries.
3. Run the focused AWX retirement playbook against only GitLab.
4. Prove ID 2 is paused, its container is absent, configuration is preserved,
   GitLab health is unchanged, and no job is stranded.
5. Run the restore playbook, validate rollback, then rerun retirement and
   require final zero-change convergence.
6. Publish acceptance evidence and close the change.

## Backout plan

Run only the reviewed AWX restore playbook. It reactivates runner ID 2 and
recreates the pinned Runner 19.2.0 container from the preserved configuration.
Do not register a new identity or replace the configuration.

## Pre-change evidence

- GitLab pending/running jobs: 0; AWX active jobs/updates: 0.
- Runner ID 2 is active, unlocked, accepts untagged jobs, and has no tags.
- Its `gitlab/gitlab-runner:alpine` container is running with restart policy
  `always`; the root-owned configuration is mode `0600`.
- Dedicated runner IDs 3, 4, and 5 are active at Runner 19.2.0. Their accepted
  canaries and CHG-2026-004 through CHG-2026-006 closures are published.
- No infra03 provisioning/package process, repository lock, active Kubernetes
  Job, or visible Jenkins durable task conflicts with this retirement.

## Closure information

| Field | Value |
| --- | --- |
| Close code | Successful |
| Closed date | 2026-08-01 |
| Implementation result | Canonical source `244e418` paused only runner ID 2 and removed only its runner container through AWX; preserved configuration remains available for rollback. |
| Validation evidence | Pipelines 455/456 passed; retire 713, restore 717, final retire 721, and zero-change job 725 passed. See `docs/evidence/CHG-2026-007-gitlab-vm-runner-retirement-acceptance.md`. |
