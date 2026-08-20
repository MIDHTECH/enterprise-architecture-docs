# CHG-2026-016: Vault Shamir Unseal Recovery

## Change metadata

| Field | Value |
| --- | --- |
| Number | `CHG-2026-016` |
| Type | Controlled service recovery |
| State | Design recorded; implementation pending |
| Risk | High because recovery material is sensitive and Vault backs secret workflows |
| Impact | Restore the initialized single-node Vault service from sealed HTTP 503 to active HTTP 200 |
| Owner | Platform Engineering |

## Current evidence

The canonical frontend is reachable, but `/v1/sys/health` reports
`initialized=true`, `sealed=true`, `standby=true`, Vault 2.0.3, and HTTP 503.
This matches the single-node Community/Shamir restart behavior recorded in
`INC-2026-048`. The existing root-only initialization artifact on the Vault VM
is the only approved recovery source for this lab. Its path and contents are
not documentation data and must never be printed, copied to a controller,
uploaded to AWX, or committed.

The source audit found no existing reviewed unseal playbook. Direct workstation
unseal is prohibited. The correction therefore adds a bounded Jenkins/AWX
workflow that reads the recovery artifact only on the Vault VM, suppresses all
secret-bearing task output, submits the existing threshold locally, and proves
the resulting health state.

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
