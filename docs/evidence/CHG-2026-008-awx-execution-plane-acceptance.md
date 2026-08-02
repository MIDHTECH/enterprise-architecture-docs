# CHG-2026-008 AWX Execution Plane Acceptance

Accepted 2026-08-02 for AWX instance 3,
`awx-execution.example.com`, under the non-production `lab-canary` capacity
decision.

## Published source and controller objects

- Canonical project `midhhealth/platform-delivery/ansible-awx` passed the
  controlled-runtime main pipeline 488, controller-object pipelines 492
  through 498, and final runtime-lock pipelines 499/500.
- Main pipeline 500 accepted full revision
  `7b931558d576ed62b07ba4e446c918841fa586d2`.
- AWX project update 740 synchronized that exact revision before the accepted
  runtime jobs were launched.
- The bounded objects are SCM credential 6, encrypted bundle credential type
  31 and credential 7, project 46, inventory 10, execution host 88, localhost
  89, instance group 3 (`lab-infrastructure`), and templates 47 through 52.
- Controller templates use only the `default` container group. Canary template
  52 uses only `lab-infrastructure`; instance-group fallback is prohibited.
- The final controller audit found zero active jobs before deployment and
  confirmed only `awx-execution.example.com:443` as the canonical Receptor
  address.

## Runtime acceptance

| Purpose | AWX job | Result |
| --- | ---: | --- |
| Read-only preflight | 738 | `ok=8`, `changed=0`, no failures or unreachable host |
| Corrected install | 741 | `ok=58`, `changed=18`, no failures or unreachable host |
| Initial runtime/boundary validation | 742 | `ok=29`, `changed=0`, no failures |
| Initial execution-plane canary | 743 | Ran on `awx-execution.example.com`; `ok=3`, `changed=0`, no failures |
| Controlled removal | 744 | `ok=32`, `changed=14`; backend and NGINX edge confirmed absent |
| Controlled restore | 745 | `ok=59`, `changed=29`, no failures or unreachable host |
| Post-restore validation | 746 | `ok=29`, `changed=0`, no failures |
| Post-restore canary | 747 | Ran on `awx-execution.example.com`; `ok=3`, `changed=0`, no failures |
| Idempotence install | 748 | `ok=52`, `changed=0`, no failures or unreachable host |
| Final validation | 749 | `ok=29`, `changed=0`, no failures |

Every accepted job selected full source revision
`7b931558d576ed62b07ba4e446c918841fa586d2`. The node was disabled before
installation and throughout the rollback/removal interval. A bounded AWX
health check returned the restored Receptor topology to `ready` before the
node was re-enabled.

## Hostname and security boundary

- NGINX stream TLS passthrough is the only network-facing listener, on TCP
  443 for `awx-execution.example.com`.
- Receptor 1.4.8 listens only on `127.0.0.1:27199` and uses the
  controller-generated mutual-TLS identity.
- Firewalld permanently admits `https`; it has no `27199/tcp` opening.
- Validation 742, 746, and 749 proved that the hostname edge is reachable from
  the control plane and that direct `awx-execution.example.com:27199` access is
  stopped.
- NGINX and Receptor are enabled and active, `nginx -t` passes, the pinned
  package identities and certificate fingerprints match, and Ansible Runner
  2.4.0 executes from the isolated hashed Python runtime.
- No VM backend or container host port is published directly.

## Final controller state

- AWX 24.6.1 instance 3 is enabled, policy management is disabled, node state
  is `ready`, capacity is 76, and the errors field is empty.
- Instance 3 belongs only to `lab-infrastructure`.
- Its only Receptor address is canonical
  `awx-execution.example.com:443`, with control-node peering enabled.
- Project 46 is successful at the accepted full revision and the final active
  AWX job count is zero.
- The 4-vCPU, 8-GiB VM remains intentionally scoped to non-production
  `lab-canary`; no resize occurred.

## Incidents and protected-material cleanup

INC-2026-070 through INC-2026-074 record the project-relative playbook path,
AWX inventory endpoint, controller capacity group, transient GitLab clone, and
Python 3.9 conditional lock defects. Each failed safely before acceptance and
was corrected through source review and passing CI.

After restore, canary, idempotence, and final validation passed, the temporary
controller-generated install-bundle archive, extracted private bundle,
controller helper scripts, dedicated deploy-key helper, and local dependency
inspection directories were overwrite-deleted. No generated private key was
committed. The encrypted AWX credential remains the controlled runtime copy.
