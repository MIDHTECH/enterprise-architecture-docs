# CHG-2026-004 GitLab Infrastructure Runner Acceptance

Accepted 2026-08-01 for `gitlab-runner-infra01.example.com` (`192.168.1.137`)
on `infra03.example.com`.

## Source and deployment

- Canonical automation revision: `281b35e`.
- GitLab branch pipeline 420 and canonical-main pipeline 421 passed.
- AWX project update 641 and inventory update 642 selected the exact revision
  and the two-host GitLab/build-execution inventory.
- Focused deployment template 33 and rollback template 34 were used; no direct
  installation bypass was used.

## Runtime acceptance

- GitLab runner ID 4 has description
  `gitlab-runner-infra01.example.com`, runner type project, project association
  2, active and locked true, and untagged jobs disabled.
- Exact tags are `ansible,infra,terraform`.
- The runner manager contacted GitLab with version 19.2.0.
- The target runs `gitlab/gitlab-runner:v19.2.0`; coordinator verification,
  internal `gitlab_runner_version_info` metrics, protected file modes, and
  recent-log inspection passed.
- Canary pipeline 419 job 1171 succeeded on runner ID 4.

## Rollback and convergence

- AWX rollback job 629 paused runner ID 4, removed only the runner container,
  and preserved `/srv/gitlab-runner/config`.
- Restore job 633 reused runner ID 4 and returned it to service.
- Final AWX job 645 reported no changes, failures, or unreachable hosts:
  GitLab `ok=7`, runner host `ok=18`, and `changed={}`.
- The legacy GitLab-VM runner was intentionally retained until the application
  and shared runners pass their separate sequential changes.

## Incident

Initial job 617 stopped before target-host mutation because the source assumed
an absent `root` username. INC-2026-068 records the configuration correction,
CI validation, and successful controlled redeployment.
