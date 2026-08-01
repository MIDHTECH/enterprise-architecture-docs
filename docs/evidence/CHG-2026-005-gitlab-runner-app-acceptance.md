# CHG-2026-005 GitLab Application Runner Acceptance

Accepted 2026-08-01 for `gitlab-runner-app01.example.com` (`192.168.1.136`)
on `infra03.example.com`.

- Canonical source revision `712f194` passed pipelines 426/427.
- AWX project update 649 and inventory update 650 selected the exact revision
  and exact GitLab/application-runner hosts.
- Deployment job 653 configured the pinned
  `gitlab/gitlab-runner:v19.2.0` Docker executor.
- GitLab runner ID 3 is active instance type, unlocked, rejects untagged jobs,
  has exact `app,docker` tags, and contacted GitLab with version 19.2.0.
- Coordinator verification, protected `0600` configuration, internal metrics,
  and recent-log checks passed.
- Pipeline 428 job 1234 succeeded on runner ID 3.
- Rollback job 657 paused ID 3, removed only the container, and preserved
  configuration. Restore job 661 reused the same identity.
- Final AWX job 665 reported no changes, failures, or unreachable hosts.
- The shared runner and GitLab-VM runner remained unchanged.
