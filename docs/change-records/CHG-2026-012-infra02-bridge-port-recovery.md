# CHG-2026-012: infra02 Live Libvirt Bridge-Port Recovery

## Change metadata

| Field | Value |
| --- | --- |
| Number | `CHG-2026-012` |
| Type | Emergency service restoration through normal reviewed controls |
| State | Closed; bridge recovery accepted |
| Risk | Moderate |
| Impact | Restored: 14 infra02 guests and two application-cluster workers are reachable |
| Owner | Platform Engineering |
| Scheduled start | 2026-08-18; completed through Jenkins and AWX |

## Purpose

Restore the already-defined live libvirt network topology on
`infra02.example.com`. All 14 domains are running and QEMU Guest Agent reports
their canonical IPv4 addresses, but none of their live `vnet` tap interfaces
is enslaved to `br0`. The bridge contains only physical port `enp0s25`, and the
hypervisor cannot reach any guest address.

This change restores only live bridge membership. It does not standardize STP,
alter the physical path, change NetworkManager, restart libvirt or a domain, or
repair an application directly.

## Detection and pre-change evidence

The 2026-08-18 service audit found:

- infra02 has 14/14 running and autostart domains;
- QEMU Guest Agent reports the expected addresses `.121` through `.135` for
  every defined guest;
- `ip -details link show br0` reports the canonical `192.168.1.169/24` address
  and an active physical uplink;
- `bridge link show` reports only `enp0s25` as a `br0` member; `vnet0` through
  `vnet13` are live but have no bridge master;
- every guest ICMP probe from infra02 fails;
- all infra02 guest SSH probes time out and Grafana, Loki, Tempo, OpenTelemetry,
  Harbor, Elasticsearch02/03, Logstash, PostgreSQL, AWX execution, and the two
  Kubernetes workers are unavailable from consumers;
- the application cluster reports worker02 and worker03 `NotReady`, with
  existing Headlamp, ingress, Longhorn, and storage-acceptance pods Pending or
  Unknown; and
- no conflicting host mutator was visible on infra01, infra02, or infra03.

The failure is local to live bridge membership. It is not evidence that the 14
guest operating systems, addresses, domain definitions, disks, or services
were removed.

Three persistent interfaces use libvirt network `lab-bridge`, so `domiflist`
shows that network name. Their live XML resolves `lab-bridge` to Linux bridge
`br0`; the other 11 interfaces name `br0` directly. Reviewed automation now
derives the live tap from `domiflist` and verifies the resolved live XML bridge.

## Exact scope

The only mutable target is the live master relationship between `br0` and the
14 tap names returned by `virsh domiflist` for this exact domain set:

- `awx-execution.example.com`
- `harbor.example.com`
- `artifactory.example.com`
- `sonarqube.example.com`
- `postgres.example.com`
- `k8s-worker02.example.com`
- `k8s-worker03.example.com`
- `grafana.example.com`
- `loki.example.com`
- `tempo.example.com`
- `otel.example.com`
- `elasticsearch02.example.com`
- `elasticsearch03.example.com`
- `logstash.example.com`

The automation must derive the live tap name for each domain, prove the
interface is type `bridge` with source `br0`, prove every tap exists, and then
attach only taps whose current master is absent. It must never use a wildcard
or assume a numeric `vnet` mapping.

## Source and control path

1. Enterprise documentation records this active boundary and `INC-2026-086`.
2. `cloud-infra-automation-platform` provides a host-limited Ansible role plus
   APPLY and mutation-disabled VALIDATE playbooks.
3. `jenkins-shared-library` provides a `PLAN`, confirmed `APPLY`, and
   `VALIDATE` AWX pipeline contract for `CHG-2026-012`.
4. `jenkins-jobs` provides one parameterized recovery job pinned to the
   dedicated `kubernetes-deployer` agent.
5. GitLab branch and canonical-main pipelines must pass in all four source
   repositories before runtime work.
6. Jenkins reconciles and launches the AWX templates. No workstation Ansible
   or direct host command is an execution fallback.

## Safety preconditions

Immediately before PLAN and again before APPLY:

1. GitLab reports no pending/running pipeline or build; Jenkins has an empty
   queue and no busy executor; AWX reports zero active unified jobs.
2. infra01/02/03 retain exactly 17/14/4 running domains and no conflicting
   Git, Ansible, Terraform, package, libvirt, Helm, or kubectl mutator.
3. infra02 retains `192.168.1.169/24`, its default route through `br0`, and
   forwarding physical port `enp0s25`.
4. The 14 expected domains are running and autostart-enabled.
5. Every domain exposes exactly one live bridge interface sourced from `br0`,
   and the 14 derived tap names are unique.
6. PLAN reports only missing live tap memberships. Any other predicted change
   closes the gate.

## Implementation and rollback

For each derived tap with no current master, APPLY runs only:

```text
ip link set dev <derived-tap> master br0
```

The role waits for the physical port and all expected taps to enter forwarding
state, confirms the exact running-domain set, and probes all canonical guest
addresses. No bridge or NetworkManager reconnection is allowed.

If attachment introduces a bridge or management invariant failure, the role's
rescue path removes only tap memberships added during that execution and fails
the job. It does not detach `enp0s25`, recreate `br0`, cycle NetworkManager,
or restart a VM. If bridge membership is correct but an application remains
unhealthy, retain restored guest connectivity and open or update the relevant
incident; do not recreate the network outage as an application rollback.

## Prohibited changes

- changing persistent or live STP state;
- reconnecting or modifying the `lab-br0` NetworkManager connection;
- moving or resetting `enp0s25`, either Velop port, a cable, or a mesh node;
- changing DHCP, DNS, firewall, route, IPv6, domain XML, autostart, storage, or
  VM power state;
- restarting a guest or product service in this component;
- applying Kubernetes or Helm changes; and
- running Argo CD work under the cancelled `CHG-2026-011` record.

## Acceptance

The component is accepted only when:

1. `br0` contains exactly the expected physical port and 14 derived taps, all
   forwarding;
2. infra02 and all 14 guests retain canonical addresses and the hypervisor can
   reach all 14 guests without loss in the bounded acceptance probe;
3. all 14 domains remain running and autostart-enabled;
4. Kubernetes reports all four nodes Ready and no existing Pending or Unknown
   workload remains because of worker isolation;
5. the installed infra02 services return their expected systemd, container,
   TCP, or HTTP readiness status; provisioned-only Artifactory and SonarQube
   are not promoted to installed products;
6. GitLab, Jenkins, AWX, DNS, the shared proxy, and the infra03 build-execution
   services remain healthy;
7. VALIDATE reports zero changes; and
8. a second confirmed APPLY reports `changed=0`, followed by reviewed evidence
   and canonical repository publication.

## Implementation and validation result

The first four Jenkins PLAN attempts failed safely before bridge mutation and
supplied the evidence used to correct the reviewed source. AWX job 922 exposed
Ubuntu 26.04 `sudo-rs` prompt incompatibility, job 930 exposed unreliable tap
derivation from formatted `domiflist` output, and job 938 exposed GNU
`readlink -f` behavior on an absent master link. Merge requests !6, !7, and !8
corrected those issues; GitLab pipelines 686 through 690 passed, and the
accepted code uses `/usr/bin/sudo.ws`, live domain XML, and a non-canonicalizing
master-link read. No failed attempt changed bridge or guest state.

Jenkins PLAN build 5 and AWX job 946 then passed. Check mode predicted only
attachment of the exact unique set `vnet0` through `vnet13` to `br0`. A fresh
idle gate found no active AWX or infra02 mutator, 14 running domains, and only
the physical port on the bridge. Confirmed Jenkins APPLY build 6 launched AWX
job 954, which completed successfully and attached the missing live taps.

Independent acceptance found `br0` at `192.168.1.169/24` with its canonical
default route, exactly `enp0s25` plus `vnet0` through `vnet13`, and all 15 ports
forwarding. All 14 domains remained running and autostart-enabled, and all 14
canonical guest addresses `.121` through `.131` and `.133` through `.135`
answered the bounded hypervisor probe. Kubernetes returned all four nodes
Ready with no non-running pods.

Jenkins VALIDATE build 7 and AWX job 962 passed 23 checks with `changed={}`.
After another idle gate, Jenkins APPLY build 8 and AWX job 970 passed with
`changed={}` and reported no tap to attach. This is the required convergence
evidence.

The post-network service audit also separated two application failures from
the bridge incident. Harbor has nine containers stopped since 2026-08-15
because its Docker syslog driver resolves `localhost:1514` to IPv6 while the
healthy logging container publishes only IPv4. The AWX execution node is
reachable but Receptor is in a pre-existing restart loop and remains capacity
zero. They are recorded as `INC-2026-087` and `INC-2026-088`; the rollback rule
requires retaining the restored bridge and handling each as a separate,
reviewed component. Primary systemd units for PostgreSQL, both Kubernetes
workers, Grafana, Loki, Tempo, OpenTelemetry Collector, Elasticsearch02/03,
and Logstash are active.

## Closure

| Field | Value |
| --- | --- |
| Close code | Successful bridge restoration; two unrelated application follow-ups opened |
| Closed date | 2026-08-18 |
| Implementation result | Jenkins build 6 / AWX job 954 restored all 14 live tap memberships |
| Validation evidence | Jenkins builds 7 and 8; AWX jobs 962 and 970; 15/15 ports forwarding, 14/14 domains running/autostarted/reachable, Kubernetes 4/4 Ready |
