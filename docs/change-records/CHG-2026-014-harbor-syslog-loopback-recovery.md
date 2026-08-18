# CHG-2026-014: Harbor Syslog Loopback Recovery

## Change metadata

| Field | Value |
| --- | --- |
| Number | `CHG-2026-014` |
| Type | Controlled service recovery |
| State | Closed successfully |
| Risk | Medium |
| Impact | Native Harbor HTTPS and registry API are unavailable |
| Owner | Platform Engineering |

## Purpose and evidence

Recover the existing Harbor 2.15.0 installation on `harbor.example.com`
without reinstalling or upgrading Harbor and without changing its data,
credentials, certificates, hostname, frontend ports, firewall, NGINX, or VM.

The guest and Docker daemon are healthy. `harbor-log` is the only running
container and publishes its syslog listener at `127.0.0.1:1514`. The other
nine containers exited with code 128 because their Docker syslog driver uses
`tcp://localhost:1514`, which attempts `[::1]:1514` on this host.

## Exact scope

Reviewed automation may replace only the generated Compose logging target:

```text
tcp://localhost:1514 -> tcp://127.0.0.1:1514
```

The automation must verify the exact existing mismatch, retain a fixed
pre-change backup for rollback, start/reconcile the existing Compose project,
and wait for runtime acceptance. It must not render or print the secret-bearing
Harbor configuration.

## Control path

1. Add Harbor-only preflight, recovery, and validation playbooks to canonical
   `linux-systems-platform` source.
2. Add only those reviewed paths to the existing Jenkins/AWX allowlists.
3. Pass merge review and branch/canonical-main CI in every changed repository.
4. Run PRECHECK, APPLY, VALIDATE, and a second APPLY through Jenkins and AWX.

Direct Docker or Compose recovery from the workstation is prohibited.

## Preconditions

- GitLab, Jenkins, and AWX have no conflicting running work.
- No package, Docker Compose, Harbor installer, or Ansible mutation is active.
- The Compose project is `/opt/midhtech/harbor/docker-compose.yml` and contains
  the exact local syslog endpoint while the log listener is IPv4 loopback.
- `CHG-2026-013` remains accepted and the sequential queue names only this
  component.

## Acceptance

1. All ten expected Harbor containers are running and none is restarting or
   exited; `harbor-log` is healthy.
2. Native `https://harbor.example.com` responds successfully and
   `/api/v2.0/health` reports healthy.
3. Compose uses only `tcp://127.0.0.1:1514` for the local syslog target and the
   listener remains bound only to `127.0.0.1:1514`.
4. Harbor data, credentials, certificates, hostname, frontend ports, firewall,
   NGINX, DNS, VM, and shared proxy remain unchanged.
5. VALIDATE and a second APPLY report zero changes and no failures.
6. `INC-2026-087`, environment state, and this record are closed and published.

## Rollback

If the stack does not pass acceptance, restore the fixed pre-change Compose
backup through the same reviewed AWX playbook and leave the incident open. Do
not reinstall Harbor, remove volumes, regenerate configuration, or expose a
new listener.

## Closure

| Field | Value |
| --- | --- |
| Close code | Successful |
| Closed date | 2026-08-18 |
| Implementation result | Canonical `linux-systems-platform` revision `9f03c345af201fa25b4475e905947feebda680e6` retained a fixed rollback copy, replaced the nine exact local syslog targets with IPv4 loopback, and reconciled the existing Compose project without reinstalling or upgrading Harbor. |
| Validation evidence | Jenkins preflight 4/AWX 994, APPLY 5/AWX 1004, VALIDATE 6/AWX 1014, and convergence APPLY 7/AWX 1024 succeeded. VALIDATE and convergence reported `changed={}` with no failures. All ten containers are healthy, native HTTPS returns 200, and `/api/v2.0/health` reports `healthy`. |

## Publication and control evidence

- Design merge request !44 passed documentation pipelines 706 and 707 and
  merged as `39df4770864a3335ac3d856ada569ecb52cad5e3`.
- `linux-systems-platform` merge request !2 passed branch pipeline 710 and
  canonical-main pipeline 712 and merged as
  `9f03c345af201fa25b4475e905947feebda680e6`.
- Jenkins shared-library merge request !15 passed pipelines 708 and 711 and
  merged as `50918735436d6af07f5c1786d35fb307e07a10b0`.
- Jenkins-jobs merge requests !10 and !11 passed pipelines 709/713 and
  714/715. Their canonical revisions added the reviewed playbook choices and
  bound the generic AWX job to the existing `kubernetes-deployer` agent.
  Seed builds 73 and 75 succeeded after approval of only their exact DSL.
- Jenkins build 1 was aborted while waiting on the intentionally restricted
  agent. Builds 2 and 3 failed safely during AWX source sync before a host job
  because the repository lacked the matching AWX read-only deploy-key
  association. Existing deploy key 6 was enabled read-only for project 25;
  the unrelated Jenkins key association was removed. No Harbor mutation
  occurred in those failed attempts.

The accepted runtime contains exactly ten healthy Harbor containers. The
Compose file has zero `tcp://localhost:1514` targets and nine
`tcp://127.0.0.1:1514` targets. TCP 1514 remains IPv4 loopback-only. Harbor
data, credentials, certificates, hostname, frontend ports, firewall, NGINX,
DNS, VM, and shared proxy were not changed.
