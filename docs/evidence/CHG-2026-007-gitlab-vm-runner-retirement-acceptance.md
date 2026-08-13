# CHG-2026-007 GitLab-VM Runner Retirement Acceptance

Accepted 2026-08-01 for legacy runner ID 2,
`ansible-jenkins-runner-01`, on the GitLab VM.

- Canonical automation revision `244e418` passed branch pipeline 455 and main
  pipeline 456 entirely on dedicated runner ID 4.
- AWX project update 709 and inventory update 710 selected exact revision
  `244e418` and exactly `gitlab.example.com`.
- Retirement job 713 verified zero active builds on ID 2, paused the exact
  identity, removed only its `gitlab-runner` container, preserved the
  root-owned `0600` configuration, and confirmed the GitLab application
  container remained running.
- GitLab continued returning HTTP 200 and reported no pending or running jobs.
- Restore job 717 reactivated the same ID 2, recreated the container with
  pinned image `gitlab/gitlab-runner:v19.2.0`, and passed coordinator
  verification. No replacement identity was registered.
- Final retirement job 721 paused the same identity and removed only the
  restored runner container. Final AWX job 725 reported `changed={}` with no
  failures or unreachable hosts.
- Runner ID 2 is paused, its container is absent, and its protected
  configuration remains preserved. Dedicated runner IDs 3, 4, and 5 are
  active at Runner 19.2.0 and reject untagged jobs.
- `gitlab-runner-app01.example.com`, `gitlab-runner-infra01.example.com`, and
  `gitlab-runner-shared01.example.com` are running, autostarted infra03 domains
  with pinned running containers and restart policy `always`.
- Final GitLab health is HTTP 200 with zero pending/running jobs.
