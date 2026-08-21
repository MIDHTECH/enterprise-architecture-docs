# CHG-2026-016: Vault Shamir Unseal Recovery

## Change metadata

| Field | Value |
| --- | --- |
| Number | `CHG-2026-016` |
| Type | Controlled service recovery |
| State | Accepted and closed |
| Risk | High because recovery material is sensitive and Vault backs secret workflows |
| Impact | Restore the initialized single-node Vault service from sealed HTTP 503 to active HTTP 200 |
| Owner | Platform Engineering |

## Current evidence

The canonical frontend was reachable while `/v1/sys/health` reported
`initialized=true`, `sealed=true`, `standby=true`, Vault 2.0.3, and HTTP 503.
This matched the single-node Community/Shamir restart behavior recorded in
`INC-2026-048`. The root-only initialization artifact remained on the Vault VM
at the bounded recovery path. Its contents are not documentation data and must
never be printed, copied to a controller, uploaded to AWX, or committed.

The source audit found no existing reviewed unseal playbook. Direct workstation
unseal is prohibited. The correction therefore adds a bounded Jenkins/AWX
workflow that reads the recovery artifact only on the Vault VM, suppresses all
secret-bearing task output, submits the existing threshold locally, and proves
the resulting health state.

The reviewed controls and parser corrections are merged. The initial
artifact-absence conclusion was caused by a discovery allowlist that omitted
`/data/vault/recovery`; the existing `initialization.json` was later verified
there as `root:root`, mode `0600`, with five shares and threshold three. No
share value was read into evidence. Jenkins builds 15-20 and AWX jobs
1096-1146 failed closed during discovery or parsing, before key submission.
Merge requests !14-!19 corrected discovery and JSON compatibility, and final
protected-main pipeline 757 passed with a non-secret regression for native
mapping and JSON-string inputs.

Jenkins build 21/AWX job 1156 passed preflight. Build 22/job 1166 submitted
exactly the existing threshold locally under `no_log` and succeeded. Build
23/job 1176 passed validation, and build 24/job 1186 proved zero-change
convergence. Backend and canonical product-local NGINX health both return HTTP
200 with `initialized=true`, `sealed=false`, and `standby=false`; Vault and
NGINX are active. `INC-2026-090` is resolved.

## Exact scope and sequence

1. Publish this design and pass branch and protected-main documentation CI.
2. Add three reviewed playbooks to `cloud-infra-automation-platform`:
   secret-safe preflight, unseal recovery, and mutation-disabled validation.
3. Require the preflight to prove exactly one allowed root-owned, non-group-
   or world-readable initialization artifact, parse at least the reported
   threshold, and disclose no path contents or key values.
4. Require the recovery playbook to stop unless Vault is initialized. If Vault
   is sealed, submit only the existing threshold to the loopback Vault API with
   `no_log: true`; if already unsealed, perform no change.
5. Validate direct and canonical health as initialized, unsealed, active, and
   HTTP 200. Do not change product configuration, secrets, policies, engines,
   packages, listeners, certificates, firewall, or NGINX.
6. Repeat the recovery playbook and require zero changes before closure.

## Secret-handling contract

- Recovery material stays on `vault.example.com` and is read only with root
  privilege through the existing AWX machine credential.
- Every task that reads, parses, loops over, or submits a key uses
  `no_log: true`.
- No key, encoded file content, recovery-file content, root token, response
  payload containing sensitive material, or derived secret fact may appear in
  CI, Jenkins, AWX, Ansible, incident, or documentation output.
- Automation may report only non-secret booleans, counts, ownership/mode
  acceptance, health status, and changed/no-change results.
- The change does not move recovery custody into AWX and does not claim that
  the current root-only artifact is the target enterprise design.

## Control path

- Canonical source: `cloud-infra-automation-platform`.
- Source validation: repository layout, YAML syntax, Ansible syntax/lint where
  available, and security CI on reviewed branch and protected main.
- Runtime: the existing authenticated Jenkins `projects/run-ansible-playbook`
  launcher and AWX project/inventory/machine credential.
- Target: only `vault.example.com`; no wildcard or additional host is allowed.

## Acceptance

1. Preflight proves the service is initialized and sealed, the recovery source
   meets ownership/mode policy, and enough keys exist without logging secrets.
2. Recovery reports no failure and processes only `vault.example.com`.
3. Direct and canonical health report `initialized=true`, `sealed=false`,
   `standby=false`, and HTTP 200.
4. Vault and its local NGINX frontend remain active; backend exposure and
   firewall policy are unchanged.
5. AWX/Jenkins output contains no recovery key, root token, or encoded recovery
   artifact.
6. Validation passes without mutation, and the second recovery APPLY reports
   zero changes.

All acceptance conditions were met on 2026-08-21. Detailed counters and
revision evidence are retained in
[CHG-2026-016 acceptance](../evidence/CHG-2026-016-vault-shamir-unseal-recovery-acceptance.md).

## Failure and rollback

An invalid, missing, ambiguous, over-permissive, or unparsable recovery artifact
stops before key submission. A rejected key stops without printing its value.
Partial threshold progress is completed only by the same reviewed playbook;
the operator must not paste keys into Jenkins, AWX, chat, or shell history.

Successful unseal is an in-memory recovery state, not a configuration or data
migration. Deliberately resealing Vault is disruptive and is not an automatic
rollback. If post-unseal health fails, stop dependent workflows, retain the
service and data unchanged, record an incident, and diagnose through a new
reviewed correction. Reinitialization or deletion of Vault data is prohibited.
