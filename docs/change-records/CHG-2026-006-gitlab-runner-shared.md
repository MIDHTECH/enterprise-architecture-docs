# CHG-2026-006: Provision and Configure Shared GitLab Runner

## Change record

| ServiceNow field | Value |
| --- | --- |
| Number | `CHG-2026-006` |
| Type | Normal |
| State | Implement |
| Risk | Moderate |
| Impact | Low |
| Priority | High |
| Configuration item | `gitlab-runner-shared01.example.com` |
| Service | GitLab CI |
| Assignment group | Platform Engineering |
| Requested by | MIDHTECHLAB operator |
| Requested date | 2026-08-01 |
| Expected outage | None |

## Scope

Provision only `gitlab-runner-shared01.example.com` at `192.168.1.139` on
infra03 with the published libvirt/Terraform workflow. Configure a pinned
GitLab Runner 19.2.0 Docker executor as an instance runner with exact
`shared,validation,security` tags, untagged execution disabled, and initial
concurrency 1. This completes the three-runner topology for the twelve-platform
program.

Retirement of the GitLab-VM runner is a separate queued change.

## Implementation and validation

1. Add `.139` seed and domain source to the existing published infra03
   Terraform branch and update the plan guard to allow only the shared domain
   and volume creates.
2. Pass branch CI, prepare the seed through AWX, run the guarded GitLab plan,
   review its JSON, and play the manual apply only for that artifact.
3. Prove the domain, address, SSH, autostart, and Rocky 9.8 baseline.
4. Add shared-runner inventory, deploy/rollback playbooks, and canary to the
   canonical runner source; pass branch and main CI.
5. Deploy through focused AWX templates, verify identity/runtime/metrics/logs,
   and require a tagged canary on the shared runner.
6. Run rollback, restore, and final zero-change convergence.
7. Publish evidence and close before retiring the GitLab-VM runner.

## Backout plan

Before runner acceptance, apply only the reviewed Terraform destroy plan for
the new `.139` domain/volume if provisioning must be reversed. After runner
configuration, first use the focused AWX rollback to pause the identity and
remove only its container while preserving configuration. Do not affect the
two accepted runners or GitLab VM.

## Pre-change evidence

- GitLab pending/running jobs: 0; AWX active jobs: 0.
- `gitlab-runner-shared01.example.com` domain absent.
- `.139` does not respond and has no existing runner identity.
- infra03 pool `infra03-images` is active with 3.58 TiB available.
- `CHG-2026-005` is closed through documentation pipelines 429/430.

## Closure information

| Field | Value |
| --- | --- |
| Close code | Pending |
| Closed date | Pending |
| Implementation result | Pending |
| Validation evidence | Pending |
