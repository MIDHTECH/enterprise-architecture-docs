# CHG-2026-013: AWX Receptor Runtime-Directory Recovery

## Change metadata

| Field | Value |
| --- | --- |
| Number | `CHG-2026-013` |
| Type | Controlled service recovery |
| State | Design and source review |
| Risk | Low |
| Impact | AWX execution instance 3 is unavailable at capacity zero |
| Owner | Platform Engineering |

## Purpose and evidence

Restore the existing Receptor service on `awx-execution.example.com` without
replacing the node, certificates, execution environment, NGINX boundary, AWX
instance, or instance-group membership.

The guest is reachable after CHG-2026-012. `receptor.service` is enabled but
restarts every five seconds, and `/var/log/receptor/receptor.log` reports only:

```text
Error: error opening Unix socket: could not acquire lock on socket file: no such file or directory
```

The configured control socket is `/run/receptor/receptor.sock`; the parent
directory is absent. The systemd unit does not declare `RuntimeDirectory`, so
the volatile directory is not recreated after reboot.

## Exact scope

The only persistent correction is to the reviewed Receptor systemd unit:

```ini
RuntimeDirectory=receptor
RuntimeDirectoryMode=0750
```

Systemd must create `/run/receptor` as the existing `awx:awx` service identity
before starting Receptor. No secret, certificate, port, hostname, firewall,
NGINX, AWX object, execution-environment image, or package version may change.

## Control path

1. Update and validate the canonical `ansible-awx` source.
2. Pass branch and canonical-main GitLab CI and merge review.
3. Reconcile the existing install/validate templates through Jenkins and AWX,
   running on the healthy AWX controller execution group.
4. Run mutation-disabled validation and a second APPLY for convergence.

Direct service restart, direct unit editing, workstation Ansible, and node
replacement are prohibited.

## Preconditions

- GitLab, Jenkins, and AWX have no conflicting running work.
- `awx-execution.example.com` is reachable and no package, Ansible, systemd,
  container, or Receptor mutation is active.
- The existing unit and configuration match reviewed source except for the
  missing runtime-directory lifecycle declaration.
- CHG-2026-012 remains accepted and all infra02 bridge ports remain forwarding.

## Acceptance

1. `/run/receptor` is owned by `awx:awx` with the reviewed mode.
2. `receptor.service` is active without restart-counter growth.
3. AWX instance 3 reports Ready with nonzero capacity only in
   `lab-infrastructure`.
4. The existing execution-node canary runs on instance 3.
5. NGINX remains the hostname-only edge; direct backend exposure remains
   absent.
6. VALIDATE and a second APPLY report zero changes.
7. `INC-2026-088`, environment state, and this record are closed and published.

## Rollback

If the corrected unit cannot start Receptor, restore the previously captured
unit content through the same controlled path and leave instance 3 unavailable.
Do not delete or replace the node, certificates, AWX objects, or runtime.

## Closure

| Field | Value |
| --- | --- |
| Close code | Pending |
| Closed date | Pending |
| Implementation result | Pending |
| Validation evidence | Pending |
