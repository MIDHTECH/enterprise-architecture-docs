# CHG-2026-016 Vault Shamir Unseal Recovery Acceptance

Date: 2026-08-21

## Accepted source

- `cloud-infra-automation-platform` merge request !19 completed the native
  JSON normalization correction at protected-main revision `a2334115`.
- Branch pipeline 756 and protected-main pipeline 757 passed layout,
  Terraform validation, Ansible lint, security scanning, all required syntax
  jobs, and the non-secret Vault parser execution regression.
- Earlier merge requests !14-!18 corrected the bounded artifact path, JSON
  fallback, JSON detection, direct-field compatibility, and decoded-fact
  separation. Each failed runtime attempt stopped before key submission.

## Secret-safe artifact evidence

- Exactly one allowed artifact was found at
  `/data/vault/recovery/initialization.json`.
- Metadata-only checks reported `root:root`, mode `0600`, five shares, and
  threshold three.
- No recovery key, encoded artifact, root token, or sensitive response was
  printed, copied, uploaded, committed, or retained in this evidence.

## Controlled runtime

| Stage | Jenkins | AWX | Result |
| --- | --- | --- | --- |
| Preflight | Build 21 | Job 1156 | Passed discovery, ownership/mode, format, and threshold gates without mutation |
| Recovery | Build 22 | Job 1166 | Submitted exactly the existing threshold locally under `no_log`; successful |
| Validation | Build 23 | Job 1176 | Passed initialized, unsealed, active HTTP 200 checks without mutation |
| Idempotence | Build 24 | Job 1186 | Successful with `changed={}`, `failures={}`, `dark={}`, four OK, and 13 skipped tasks |

The fail-closed evidence interval is retained in `INC-2026-090`: builds 15-20
and AWX jobs 1096-1146 stopped during discovery or parsing. No failed attempt
submitted a recovery share.

## Independent acceptance

- Direct backend `https://127.0.0.1:8200/v1/sys/health`: HTTP 200.
- Product-local NGINX `http://127.0.0.1/v1/sys/health` with canonical Host:
  HTTP 200.
- Both health responses reported `initialized=true`, `sealed=false`,
  `standby=false`, Vault 2.0.3.
- `vault.service` and `nginx.service` are active.
- The repeated recovery path skipped artifact/key handling and changed zero
  resources.

## Decision

`CHG-2026-016` is accepted and closed. `INC-2026-090` is resolved. External
recovery-key custody, auto-unseal, and application secret delivery remain
future separately reviewed work; this acceptance does not authorize them.
