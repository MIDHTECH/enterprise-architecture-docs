# CHG-2026-004: Configure Dedicated Infrastructure GitLab Runner

## Change record

| ServiceNow field | Value |
| --- | --- |
| Number | `CHG-2026-004` |
| Type | Normal |
| State | Closed complete |
| Risk | Moderate |
| Impact | Low |
| Priority | High |
| Configuration item | `gitlab-runner-infra01.example.com` |
| Service | GitLab CI |
| Environment | MIDHTECHLAB production simulation |
| Assignment group | Platform Engineering |
| Requested by | MIDHTECHLAB operator |
| Requested date | 2026-08-01 |
| Planned start | 2026-08-01 after GitLab branch/main validation |
| Planned duration | 45 minutes after AWX launch |
| Expected outage | None for GitLab; new runner remains unavailable until accepted |
| Actual start | 2026-08-01 13:28 CDT |
| Actual end | 2026-08-01 15:02 CDT |
| Implementation owner | Codex infrastructure task under sequential change control |

## Short description

Configure and accept the dedicated project-scoped infrastructure GitLab Runner
on `infra03.example.com` at `192.168.1.137`.

## Description and justification

GitLab CE 19.2.0 currently executes CI jobs through runner ID 2 inside the
GitLab VM. Seven-day evidence shows 428 successful jobs across nine active
projects, with two-way concurrency and job durations reaching five minutes.
That workload competes with GitLab web, Sidekiq, PostgreSQL, and repository
services. The operator explicitly requires CI execution to move off the GitLab
VM and approved three dedicated runners for the twelve-domain platform program.

This first sequential component configures only the existing infrastructure
runner VM. Application and shared runners remain queued behind it.

## Scope

- Create or reconcile one locked project runner for project ID 2.
- Apply only the `infra`, `terraform`, and `ansible` tags.
- Disable untagged job execution.
- Install Docker CE on `gitlab-runner-infra01.example.com`.
- Run the version-matched `gitlab/gitlab-runner:v19.2.0` container with
  concurrency 1 and an internal metrics endpoint.
- Transfer the established libvirt CI identity from the GitLab VM to `.137`
  only in protected Ansible memory.
- Prove coordinator verification, tagged scheduling, rollback, restore, and a
  zero-change convergence.

## Out of scope

- Configuration of `gitlab-runner-app01.example.com`.
- Provisioning or configuration of `gitlab-runner-shared01.example.com`.
- Disabling or removing the current GitLab-VM runner.
- Changes to `jenkins-agent01`, ingress, Kubernetes, or another product.
- Increasing concurrency before utilization evidence supports it.

## Risk and impact analysis

The change is moderate risk because it creates a GitLab runner identity,
installs a container runtime, and transfers an existing protected SSH identity.
It does not interrupt GitLab or move existing jobs. The embedded runner remains
available during this component, so failure leaves current CI scheduling
unchanged.

The primary risks are an incorrectly scoped runner, token disclosure, an
unexpected container image, or a runner that accepts untagged work. The source
uses `no_log` for tokens and key material, an exact host inventory, a pinned
runner image, project ID 2, locked scope, explicit tags, and a rollback that
pauses the identity and removes only the `.137` container while preserving
protected configuration.

## Prerequisites

1. `CHG-2026-003` is closed and canonical pipelines 403-409 are green.
2. Sequential active-change record identifies only `CHG-2026-004`.
3. GitLab, AWX, workstation, infra03, and target-host mutation queues are idle.
4. GitLab branch and canonical-main validation pipelines pass.
5. AWX synchronizes the exact canonical source revision.
6. AWX inventory resolves only GitLab and `gitlab-runner-infra01` for this
   playbook; runtime configuration targets only `.137`.

## Implementation plan

1. Publish and validate the active change record.
2. Add the one-component inventory, identity role, host role, deploy playbook,
   rollback playbook, canary, and operations runbook.
3. Pass local layout, production-profile Ansible lint, syntax, YAML, and diff
   checks.
4. Publish the review branch and require every automatic GitLab job to pass.
5. Fast-forward the exact reviewed revision to `main`; require main CI to pass.
6. Synchronize AWX to that exact revision and create focused deploy/rollback
   templates.
7. Reconfirm CI/AWX/host idleness and launch the deploy template.
8. Verify exact GitLab identity scope, container health, coordinator contact,
   metrics, and logs.
9. Trigger `RUN_INFRA_RUNNER_CANARY=true` and require the tagged job to run on
   `gitlab-runner-infra01.example.com`.
10. Run the rollback template, prove the identity is paused and the container
    is absent with configuration preserved, then restore with the deploy
    template.
11. Run a final deployment convergence and require zero unexpected changes.
12. Publish acceptance evidence and close the active record.

## Test and validation plan

- GitLab reports a runner whose description is exactly
  `gitlab-runner-infra01.example.com`.
- Runner type is project, project association is exactly ID 2, locked is true,
  active is true, run-untagged is false, and tags are exactly
  `infra,terraform,ansible`.
- GitLab Runner version and server version are both 19.2.0.
- Docker reports a running pinned container with restart policy `always`.
- `gitlab-runner verify` succeeds without exposing its token.
- local metrics contain `gitlab_runner_version_info` and recent logs have no
  panic or fatal event.
- the variable-gated canary is assigned to the dedicated runner.
- rollback pauses the identity and removes only the runner container while
  preserving the root-owned configuration.
- restore reuses the same identity; the final convergence reports zero
  unexpected changes.

## Backout plan

1. Stop if identity scope, tags, token handling, image, metrics, logs, or
   scheduling validation fails.
2. Run only `gitlab-runner-infra-rollback.yml` through AWX.
3. Confirm the exact identity is paused and no `gitlab-runner` container runs
   on `.137`.
4. Preserve `/srv/gitlab-runner/config` for diagnosis; do not delete the VM,
   runner identity, token, or libvirt key.
5. Verify the existing GitLab-VM runner still schedules current workloads.
6. Record the failure and rollback as an incident before closing the change as
   unsuccessful or publishing a corrected source revision.

## Approvals and gates

| Gate | Evidence/status |
| --- | --- |
| Requester authorization | Operator requested configured GitLab runners, rejected steady-state execution on the GitLab VM, and approved a third similarly named infra03 runner if required |
| Sequential change approval | `CHG-2026-004` active for only `.137` |
| Pre-change activity gate | GitLab pending/running 0; AWX active 0; workstation, infra03, and target mutation processes 0 |
| Capacity gate | infra03 has 238 GiB available RAM and 3.58 TiB available VM-pool capacity |
| Review/source gate | Branch pipelines 411, 415, 417, and 420 passed; pipeline 410 was superseded |
| Canonical source gate | Main pipelines 416, 418, and 421 passed; accepted revision `281b35e` |
| Deployment authority | AWX project 23, inventory 5, deploy template 33, rollback template 34; final sync 641 selected `281b35e` |

## Work notes

- 2026-08-01: Live audit found runner ID 2 online inside the GitLab VM and a
  never-contacted application runner identity; no infrastructure identity
  existed.
- 2026-08-01: Both dedicated runner guests were reachable but had no runner
  service, process, or container.
- 2026-08-01: Infra03 capacity and `.139` collision checks support the queued
  three-runner topology; this change remains limited to `.137`.
- 2026-08-01: Local source checks passed repository layout, production Ansible
  lint, deploy/rollback syntax, host-list, YAML, and whitespace validation.
- 2026-08-01: Initial AWX job 617 failed before creating an identity because
  the source assumed a `root` GitLab username. INC-2026-068 records the
  correction to configured administrator `gitlab-admin` and the improved
  service-error handling. No target-host mutation occurred in that job.
- 2026-08-01: AWX job 625 created runner ID 4 and configured `.137`. GitLab
  reported project type, active/locked true, untagged false, version 19.2.0,
  and exact tags `ansible,infra,terraform`. Coordinator verification, internal
  metrics, and logs passed.
- 2026-08-01: Canary pipeline 419 job 1171 succeeded on runner ID 4.
- 2026-08-01: Rollback job 629 paused runner ID 4 and removed the container
  while preserving protected configuration. Restore job 633 reused the same
  identity. A final idempotence correction passed pipelines 420/421, and AWX
  job 645 reported `changed=0 failures=0 dark=0`.

## Closure information

| Field | Value |
| --- | --- |
| Close code | Successful |
| Closed by | Codex infrastructure task under sequential change control |
| Closed date | 2026-08-01 |
| Actual outage | None; the legacy GitLab-VM runner remained available |
| Implementation result | Dedicated infrastructure runner accepted on infra03 as runner ID 4 |
| Validation evidence | Pipelines 420/421; AWX jobs 625, 629, 633, 645; canary job 1171; [acceptance record](../evidence/CHG-2026-004-gitlab-runner-infra-acceptance.md) |
