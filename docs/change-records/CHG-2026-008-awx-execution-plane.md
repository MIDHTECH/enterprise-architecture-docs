# CHG-2026-008: Establish the AWX Execution Plane

## Change record

| ServiceNow field | Value |
| --- | --- |
| Number | `CHG-2026-008` |
| Type | Normal |
| State | Planning / pre-deployment |
| Risk | Moderate |
| Impact | Low |
| Priority | High |
| Configuration item | `awx-execution.example.com` and its AWX Receptor registration |
| Service | AWX automation control plane |
| Assignment group | Platform Engineering |
| Requested by | MIDHTECHLAB operator |
| Requested date | 2026-08-02 |
| Expected outage | None; the approved lab-canary profile keeps the execution VM at 8 GiB and requires no resize |

## Decision

The existing architecture and use-case catalog remain authoritative. This
change adds only the missing AAP-like execution boundary: the existing AWX
24.6.1 controller remains on `awx.example.com`, while
`awx-execution.example.com` becomes an execution-only Receptor node. Later
execution-environment, SSO, event-driven automation, observability, backup, and
HA improvements require separate sequential changes.

The user explicitly placed this prerequisite ahead of Kubernetes ingress on
2026-08-02. This does not authorize concurrent work on ingress or any other
component.

The user also established a platform-wide VM exposure rule on 2026-08-02:
never publish an application or control-plane backend port directly from a VM.
Install NGINX on the service VM and expose the service by canonical hostname.
For this component, AWX connects only to
`awx-execution.example.com:443`; NGINX stream TLS passthrough forwards that
connection to Receptor on `127.0.0.1:27199`. The Receptor backend must never
bind a non-loopback address or receive a firewall opening.

## Verified readiness

- AWX returned HTTP 200 and a current control heartbeat with capacity 30;
  k3s and local NGINX were active.
- No conflicting Ansible, Terraform, package, VM-provisioning, Git
  publication, or Kubernetes mutation process was visible on AWX or
  infra01/02/03.
- `awx-execution.example.com` is running with autostart on infra02 at
  `192.168.1.121` and has Rocky Linux 9.8, 4 vCPU, 8 GiB RAM, a 60 GB OS disk,
  and a 50 GB `/data` disk.
- SSH, authoritative DNS, UTC/NTP, SELinux enforcing, firewalld, and
  qemu-guest-agent passed.
- Podman, Receptor, and the change-owned NGINX stream configuration are absent.
  TCP 443 and 27199 remain closed. The VM is available but remains
  provisioned-only.
- Harbor and all reported registry components are healthy for a later
  execution-environment supply-chain change.
- The private canonical source project
  `midhhealth/platform-delivery/ansible-awx` now exists. Bootstrap merge
  request !1 passed branch pipeline 480 and main pipeline 481. Dependency and
  hostname-boundary merge request !2 passed branch pipeline 482 and merged as
  `0741093f`; main pipeline 483 is the publication gate for that revision.
- AWX instance 2, which used a direct port, was deprovisioned before any job
  ran. Replacement instance 3 is disabled, has never run a job, and records
  only `awx-execution.example.com:443` as its Receptor address.

The current 8 GiB VM is approved only for the bounded, non-production
`lab-canary` profile. AAP-like production sizing still targets 16 GiB RAM and
requires a separate future capacity decision. This change does not resize the
VM.

## Scope

1. Create and publish the canonical `ansible-awx` automation repository.
2. Generate the execution-node install bundle from the existing AWX controller
   and record exact dependency versions, checksums, certificate identities,
   and listener direction before use.
3. Implement idempotent install, validation, removal, and restore automation
   for only `awx-execution.example.com`.
4. Install pinned NGINX stream support, expose only hostname-based TLS on TCP
   443, and bind Receptor only to `127.0.0.1:27199`.
5. Add only the required hostname-based Receptor TLS/firewall flow and a
   bounded `lab-infrastructure` instance group.
6. Run one read-only canary that proves the execution-node and
   execution-environment identities.
7. Prove rollback, restore, and final zero-change convergence.

## Exclusions

- no AWX controller, Operator, k3s, or database upgrade;
- no ingress, storage, application, Keycloak, Vault, Harbor, Jenkins,
  Event-Driven Ansible, or HA change;
- no reassignment of an existing production template or inventory during the
  canary;
- no direct installation that bypasses reviewed source and the approved
  control plane;
- no direct VM exposure of Receptor port 27199, NodePort, container-published
  backend port, IP-only service URL, or alternate listener;
- no unpinned package, collection, or container `latest` tag.

## Implementation gates

1. Publish this record and pass documentation CI before runtime mutation.
2. Publish source automation and require its GitLab CI to pass.
3. Record exact install-bundle versions/checksums and review generated secrets
   without committing private material. Pin NGINX and its stream module as
   explicit dependencies.
4. Recheck active AWX jobs, GitLab/Jenkins work, infra02 capacity, DNS, NTP,
   package access, and controller health immediately before deployment.
5. Stop if the source revision, capacity, certificate identity, controller
   state, hostname, listener address, or required dependency differs from the
   reviewed evidence.

## Backout plan

Drain and disable only the bounded execution node, remove its Receptor
registration and change-owned Receptor, NGINX stream, SELinux, and firewall
artifacts through reviewed automation, and prove that the existing AWX
controller execution path remains healthy. Preserve the unrelated base NGINX
package if another approved configuration consumes it. Do not reuse
invalidated private keys.

## Acceptance

1. AWX topology reports instance 3 Ready with the approved peer, certificates,
   capacity, and only `awx-execution.example.com:443` as its address.
2. The node belongs only to `lab-infrastructure` during the canary.
3. A read-only job proves that it ran on the new node with the pinned execution
   environment.
4. DNS, NTP, SELinux, firewalld, NGINX stream TLS passthrough, Receptor TLS,
   Podman isolation, logs, controller heartbeat, and capacity pass.
5. NGINX is the only network-facing listener on TCP 443; Receptor listens only
   on `127.0.0.1:27199`; TCP 27199 is absent from firewalld and unreachable
   from another host.
6. Rollback removes the node without controller impact and restore returns the
   approved identity.
7. A final convergence reports zero unexpected changes or failures.
8. Evidence, incidents, source, and documentation are published before the
   active change closes.

## Closure information

| Field | Value |
| --- | --- |
| Close code | Pending |
| Closed date | Pending |
| Implementation result | Pending |
| Validation evidence | Pending |
