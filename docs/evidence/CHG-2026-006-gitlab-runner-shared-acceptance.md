# CHG-2026-006 GitLab Shared Runner Acceptance

Accepted 2026-08-01 for `gitlab-runner-shared01.example.com`
(`192.168.1.139`) on `infra03.example.com`.

- AWX seed job 677 prepared the approved cloud-init media. Terraform plan job
  1355 ran on dedicated runner ID 4 and proved exactly two creates: the shared
  libvirt domain and its 60 GiB volume, with no updates or deletes. Apply job
  1359 applied that exact artifact on ID 4.
- The persistent, autostarted VM reports Rocky Linux 9.8, 2 vCPU, 4 GiB RAM,
  a 59 GiB root filesystem, hostname
  `gitlab-runner-shared01.example.com`, and completed cloud-init.
- Canonical runner source revision `8fb79ca` passed branch pipeline 445 and
  main pipeline 446 entirely on the dedicated infrastructure runner.
- AWX project update 688 and inventory update 689 selected exact revision
  `8fb79ca` and exactly the GitLab and `.139` hosts. Deployment job 692
  configured the pinned `gitlab/gitlab-runner:v19.2.0` Docker executor.
- GitLab runner ID 5 is active instance type, unlocked, rejects untagged jobs,
  and has exact `security,shared,validation` tags. Its version, revision,
  architecture, coordinator verification, internal metrics, protected `0600`
  configuration, restart policy, and recent-log checks passed.
- Pipeline 447 job 1424 succeeded on runner ID 5.
- Rollback job 696 paused ID 5, removed only its container, and preserved the
  protected configuration. Restore job 700 reused the same identity.
- Final AWX job 704 reported `changed={}` with no failures or unreachable
  hosts. Runner IDs 3, 4, and 5 remained healthy at version 19.2.0.
- The prior runner on the GitLab VM remained unchanged during this change and
  is queued for retirement only after this closure is published.
- INC-2026-069 records the safe pre-deployment automation failures and their
  source-controlled corrections.
