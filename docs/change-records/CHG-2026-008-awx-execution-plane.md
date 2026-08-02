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
| Expected outage | No AWX controller outage; a controlled execution-VM shutdown is allowed only for an approved memory resize |

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
- Podman and Receptor are absent and TCP 27199 is closed. The VM is available
  but remains provisioned-only.
- Harbor and all reported registry components are healthy for a later
  execution-environment supply-chain change.
- The proposed canonical source project
  `midhhealth/platform-delivery/ansible-awx` does not yet exist or is not
  accessible and must be created through the normal GitLab governance path.

The current VM is sufficient for a bounded lab canary. AAP-like sizing targets
16 GiB RAM. Because infra02 is capacity constrained, the implementation gate
must record whether to keep an explicitly lab-only 8 GiB profile or perform a
controlled resize with rollback after a fresh capacity check.

## Scope

1. Create and publish the canonical `ansible-awx` automation repository.
2. Generate the execution-node install bundle from the existing AWX controller
   and record exact dependency versions, checksums, certificate identities,
   and listener direction before use.
3. Implement idempotent install, validation, removal, and restore automation
   for only `awx-execution.example.com`.
4. Add only the required Receptor TLS/firewall flow and a bounded
   `lab-infrastructure` instance group.
5. Run one read-only canary that proves the execution-node and
   execution-environment identities.
6. Prove rollback, restore, and final zero-change convergence.

## Exclusions

- no AWX controller, Operator, k3s, or database upgrade;
- no ingress, storage, application, Keycloak, Vault, Harbor, Jenkins,
  Event-Driven Ansible, or HA change;
- no reassignment of an existing production template or inventory during the
  canary;
- no direct installation that bypasses reviewed source and the approved
  control plane;
- no unpinned package, collection, or container `latest` tag.

## Implementation gates

1. Publish this record and pass documentation CI before runtime mutation.
2. Publish source automation and require its GitLab CI to pass.
3. Record exact install-bundle versions/checksums and review generated secrets
   without committing private material.
4. Recheck active AWX jobs, GitLab/Jenkins work, infra02 capacity, DNS, NTP,
   package access, and controller health immediately before deployment.
5. Stop if the source revision, capacity, certificate identity, controller
   state, or required dependency differs from the reviewed evidence.

## Backout plan

Drain and disable only the bounded execution node, remove its Receptor
registration and change-owned runtime/firewall artifacts through reviewed
automation, and prove that the existing AWX controller execution path remains
healthy. If the VM was resized, return it to 8 GiB only during a controlled
shutdown after a host-capacity check. Do not reuse invalidated private keys.

## Acceptance

1. AWX topology reports the exact execution node Ready with the approved peer,
   listener, certificates, and capacity.
2. The node belongs only to `lab-infrastructure` during the canary.
3. A read-only job proves that it ran on the new node with the pinned execution
   environment.
4. DNS, NTP, SELinux, firewalld, Receptor TLS, Podman isolation, logs,
   controller heartbeat, and capacity pass.
5. Rollback removes the node without controller impact and restore returns the
   approved identity.
6. A final convergence reports zero unexpected changes or failures.
7. Evidence, incidents, source, and documentation are published before the
   active change closes.

## Closure information

| Field | Value |
| --- | --- |
| Close code | Pending |
| Closed date | Pending |
| Implementation result | Pending |
| Validation evidence | Pending |
