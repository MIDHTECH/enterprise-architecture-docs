# CHG-2026-013: AWX Receptor Runtime-Directory Recovery

## Change metadata

| Field | Value |
| --- | --- |
| Number | `CHG-2026-013` |
| Type | Controlled service recovery |
| State | Closed successfully |
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
| Close code | Successful |
| Closed date | 2026-08-18 |
| Implementation result | Canonical `ansible-awx` revision `ff34b69f697c4a1deebdd38720b081cc3d3ec0d1` adds the two reviewed systemd runtime-directory directives. Receptor is active with `NRestarts=0`; `/run/receptor` is `awx:awx` mode `0750`; and its Unix control socket is present. |
| Validation evidence | Jenkins PLAN 2/AWX 976, APPLY 3/AWX 978, VALIDATE 4/AWX 980, CANARY 5/AWX 982 on `awx-execution.example.com`, and convergence APPLY 6/AWX 984 all succeeded. VALIDATE and convergence reported `changed={}` and no failures. Instance 3 is Ready, enabled, capacity 76, and belongs only to `lab-infrastructure`. |

## Publication evidence

- Documentation design merge request !42 passed pipelines 694 and 695 and
  merged as `abff4d2`.
- `ansible-awx` merge request !9 passed pipelines 696 and 697 and merged as
  `ff34b69f697c4a1deebdd38720b081cc3d3ec0d1`.
- Jenkins shared-library merge requests !13 and !14 passed pipelines
  698/699 and 702/703. The second revision corrected only the typed AWX polling
  endpoint after build 1 failed safely during project-update observation; no
  host job or mutation was launched by that failed build.
- Jenkins-jobs merge request !9 passed pipelines 700 and 701. Seed build 71
  generated the reviewed `projects/recover-awx-execution` job after approval
  of only its exact Job DSL script.
- The final controlled convergence job returned `ok=52`, `changed={}`,
  `failures={}`, and `dark={}` for `awx-execution.example.com`.

The existing hostname boundary remains unchanged: NGINX listens on TCP 443,
while Receptor's backend listener remains loopback-only on `127.0.0.1:27199`.
No certificate, secret, firewall, execution-environment, AWX object, package,
VM, bridge, Kubernetes, Harbor, DNS, or shared-proxy setting changed.
