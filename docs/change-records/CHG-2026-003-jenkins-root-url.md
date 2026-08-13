# CHG-2026-003: Configure Canonical Jenkins Root URL

## Change record

| ServiceNow field | Value |
| --- | --- |
| Number | `CHG-2026-003` |
| Type | Normal |
| State | Closed |
| Risk | Low |
| Impact | Low |
| Priority | Moderate |
| Configuration item | `jenkins.example.com` |
| Service | Jenkins CI |
| Environment | MIDHTECHLAB production simulation |
| Assignment group | Platform Engineering |
| Requested by | MIDHTECHLAB operator |
| Requested date | 2026-08-01 |
| Planned start | 2026-08-01 after GitLab branch/main validation |
| Planned duration | 15 minutes after AWX launch |
| Expected outage | One controlled Jenkins restart; less than five minutes |
| Actual start | 2026-08-01 18:16:49 UTC |
| Actual end | 2026-08-01 18:20:14 UTC, including second convergence |
| Implementation owner | Codex infrastructure task under sequential change control |

## Short description

Set the Jenkins root URL to the accepted canonical portless value
`http://jenkins.example.com/` through Jenkins Configuration as Code.

## Description and justification

Authenticated screenshots confirm that Jenkins and `jenkins-agent01` are
available through `http://jenkins.example.com`, but **Manage Jenkins** reports
that the Jenkins URL is empty. An empty root URL can produce incorrect links
for notifications, pull-request status callbacks, and variables such as
`BUILD_URL`. Live inspection confirms that
`JenkinsLocationConfiguration.getUrl()` has no configured value.

The node screenshot also reports `0 B` free swap on the controller and agent.
Live validation shows that neither VM has swap configured and both have ample
available memory. Swap creation and monitor suppression are explicitly outside
this change because no capacity policy or memory-pressure evidence requires
them.

## Scope

- Add the exact canonical URL to source-controlled JCasC.
- Add a focused `jenkins-location.yml` playbook and role.
- Target only the existing one-host `jenkins_servers` AWX inventory group.
- Restart Jenkins only when the JCasC location block changes.
- Confirm canonical HTTP, effective root URL, agent reconnection, and clean
  second convergence.

## Out of scope

- Swap creation, tuning, or node-monitor suppression.
- Jenkins plugin, credential, job, agent, proxy, DNS, or firewall changes.
- Kubernetes ingress, storage, runner, or product deployment.
- The protected full-controller GitLab deployment job.

## Risk and impact analysis

The configuration change is low risk and modifies one Jenkins location value.
The controller restart temporarily interrupts the web UI and agent WebSocket;
the inbound agent is configured to reconnect automatically. The pre-change
audit found no Jenkins queue items, active builds, GitLab pipelines, AWX jobs,
package operations, Ansible, Terraform, Helm, or Kubernetes mutations.

The primary implementation risk is invalid JCasC syntax preventing Jenkins
startup. The role validates the existing managed file, inserts a bounded
marked YAML block, keeps an Ansible backup, waits for backend recovery, and
fails unless the canonical login returns HTTP 200.

## Prerequisites

1. `CHG-2026-002` portless Jenkins acceptance remains healthy.
2. Sequential active-change record identifies only `CHG-2026-003`.
3. GitLab branch and canonical-main lint/syntax pipelines pass.
4. AWX project 28 synchronizes the exact canonical-main revision.
5. AWX template targets inventory 2 group `jenkins_servers` with one host.
6. Jenkins queue and active builds remain empty immediately before launch.

## Implementation plan

1. Add `jenkins_root_url: http://jenkins.example.com/` to the controller role
   defaults and JCasC template for future full reconciliation.
2. Add focused playbook `playbooks/jenkins-location.yml` and role
   `jenkins_location`.
3. Run production-profile Ansible lint and syntax validation locally.
4. Publish the review branch and require its GitLab pipeline to pass.
5. Fast-forward the exact reviewed revision to `main`; require main CI to pass.
6. Synchronize AWX project 28 to that exact revision.
7. Create or reconcile a one-host AWX job template for the focused playbook
   using inventory 2, project 28, execution environment 1, and machine
   credential 1.
8. Reconfirm no Jenkins queue/build activity and launch the template.
9. Verify Jenkins recovers, the canonical URL is effective, the management
   warning is absent, and `jenkins-agent01` reconnects.
10. Launch the same template again and require `changed=0`, `failed=0`, and
    `unreachable=0`.
11. Publish acceptance evidence, resolve any incident, synchronize all related
    repositories, and close this change.

## Test and validation plan

- GitLab Ansible lint and syntax jobs succeed on branch and `main`.
- AWX processes exactly `jenkins.example.com`.
- Jenkins and controller-local NGINX services are active.
- `http://jenkins.example.com/manage/` loads through port 80.
- Persisted Jenkins location configuration reports
  `http://jenkins.example.com/` as the effective root URL after restart.
- The empty-Jenkins-URL administrative warning is absent.
- Jenkins queue is empty and the built-in controller remains at zero
  executors.
- `jenkins-agent01` is online, idle, and retains one executor and its accepted
  labels.
- Second AWX convergence reports zero changes and zero failures.

## Backout plan

1. Stop if Jenkins does not recover within the role timeout.
2. Use the Ansible-created backup of the JCasC file or revert the exact source
   commit; do not edit the Jenkins web UI as an alternative source of truth.
3. Require GitLab validation for the revert and synchronize project 28 to the
   exact rollback revision.
4. Launch the same focused AWX template to restore the previous JCasC block
   state and restart Jenkins.
5. Verify backend port 8080, canonical proxy HTTP, agent reconnection, queue,
   logs, and a clean second rollback convergence.
6. Record the failed implementation and rollback as an incident before closing
   the change as unsuccessful.

## Approvals and gates

| Gate | Evidence/status |
| --- | --- |
| Requester authorization | Authenticated screenshots supplied 2026-08-01 |
| Sequential change approval | Active record set to `CHG-2026-003` |
| Peer/code gate | Pipelines 403-405 passed; automation pipeline 404 jobs 1093/1094 passed |
| Canonical source gate | Pipelines 406/407 passed; protected deploy job 1099 remained manual |
| Deployment authority | AWX project update 598 selected `44bd7e9`; focused template 31 used inventory 2/project 28/credential 1 |
| Outage gate | GitLab/AWX active work 0; Jenkins queue 0; both nodes idle immediately before launch |

## Work notes

- 2026-08-01: Authenticated screenshots confirmed portless access, online
  agent, empty Jenkins URL warning, and zero-swap monitor readings.
- 2026-08-01: Live audit confirmed the root URL is unset; controller has
  6.0 GiB available RAM and agent has 3.1 GiB; neither has configured swap.
- 2026-08-01: GitLab, AWX, Jenkins, and host mutation queues were idle.
- 2026-08-01: Automation commit `44bd7e9` passed branch pipeline 404 and
  canonical-main pipeline 407. The protected full-controller job remained
  manual and unstarted.
- 2026-08-01: ServiceNow-style record commit `e0ce25e` passed branch pipeline
  405 and canonical-main pipeline 406.
- 2026-08-01: AWX project update 598 selected exact revision `44bd7e9` and
  focused template 31 resolved to exactly `jenkins.example.com`.
- 2026-08-01: Job 599 completed at `ok=10 changed=2 failed=0 unreachable=0`.
  Jenkins stopped at 18:17:05 UTC and systemd reported it started at 18:17:20
  UTC, an observed 15-second service interruption.
- 2026-08-01: Authenticated `/manage/` returned HTTP 200 without the empty-URL
  warning. Persisted Jenkins configuration reports
  `http://jenkins.example.com/`; Jenkins and NGINX are active; the agent is
  online, idle, and retains its one executor and accepted labels.
- 2026-08-01: Job 604 completed at
  `ok=9 changed=0 failed=0 unreachable=0`. No incident or rollback occurred.

## Closure information

| Field | Value |
| --- | --- |
| Close code | Successful |
| Closed by | Codex infrastructure task |
| Closed date | 2026-08-01 |
| Actual outage | 15 seconds during the controlled Jenkins restart |
| Implementation result | Canonical root URL configured through JCasC; warning removed; agent reconnected; no other Jenkins or OS setting changed |
| Validation evidence | GitLab pipelines 403-407; AWX update 598; template 31; jobs 599/604; authenticated management-page and node validation |
