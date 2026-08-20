# Elastic Stack Installation

## Scope and Current State

MidhHealth uses a secured three-node Elasticsearch cluster with dedicated
Kibana and Logstash VMs. Numeric suffixes are valid here because Elasticsearch
is a cluster. Elastic provides indexed operational log search and investigation
alongside the shared Prometheus, Grafana, Loki, Tempo, and OpenTelemetry
observability services.

Elastic Stack 9.4.2 is installed. AWX deployment job `311` completed
`playbooks/deploy-elastic-stack.yml`, and independent AWX job `316` completed
`playbooks/verify-elastic-stack.yml` on 2026-07-28. The verified path covers
three-node cluster membership, Kibana, the named Logstash pipeline, the managed
index template, and end-to-end ingestion of an approved structured event.

Filebeat 9.4.2 fleet enrollment was deployed later on 2026-07-28. All 31 Rocky
Linux VMs now send encrypted `linux_auth` and `linux_system` events through
Logstash. The final verifier confirmed 31 active services, 31 encrypted output
tests, at least 10,000 recent events, 31 source hostnames, and no missing
hosts. INC-2026-024 and INC-2026-027 are resolved.

| Role | VM | Address | Resources |
| --- | --- | --- | --- |
| Elasticsearch node 1 | `elasticsearch01.example.com` | `192.168.1.116` | 4 vCPU, 4 GB RAM, 40/150 GB disks |
| Elasticsearch node 2 | `elasticsearch02.example.com` | `192.168.1.133` | 4 vCPU, 4 GB RAM, 40/150 GB disks |
| Elasticsearch node 3 | `elasticsearch03.example.com` | `192.168.1.134` | 4 vCPU, 4 GB RAM, 40/150 GB disks |
| Kibana | `kibana.example.com` | `192.168.1.117` | 2 vCPU, 4 GB RAM, 40/40 GB disks |
| Logstash | `logstash.example.com` | `192.168.1.135` | 2 vCPU, 4 GB RAM, 40/40 GB disks |

All components run Elastic Stack 9.4.2. Pin exact repository packages in the
generated lock file and never mix stack versions during an upgrade.

## Network and Access

- Elasticsearch transport `9300/tcp`: cluster nodes only.
- Elasticsearch HTTPS `9200/tcp`: Kibana, Logstash, AWX, and approved
  administrators only.
- Kibana `5601/tcp`: product-local NGINX and the approved management network;
  users browse `http://kibana.example.com` until internal TLS is deployed.
- Logstash Beats input `5044/tcp`: approved senders only.
- Filebeat-to-Logstash traffic uses TLS with full certificate verification
  against the managed Elastic CA.
- Do not publish Elasticsearch or Logstash through the HTTP reverse proxy.

## AWX Implementation Sequence

1. Apply the common Rocky Linux baseline to all five VMs and verify SELinux,
   firewalld, chrony, qemu-guest-agent, XFS `/data`, and `midhtechadmin`
   public-key access.
2. Add the official Elastic 9.x repository and import its signing key through
   a reviewed Ansible role.
3. Install the exact 9.4.2 Elasticsearch package on all three nodes.
4. Configure stable node names, one cluster name, discovery seed hosts, all
   three initial master nodes, data paths under `/data`, heap sizing, TLS, and
   built-in security.
5. Start nodes one at a time, confirm green cluster health, three members, and
   encrypted transport before continuing.
6. Install Kibana 9.4.2, enroll it with Elasticsearch, set its public base URL,
   and restrict its listener to the proxy and management network.
7. Install Logstash 9.4.2 with persistent queue and dead-letter paths on
   `/data`; deploy only version-controlled pipelines.
8. Generate credentials and certificate material once on
   `elasticsearch01.example.com` under `/etc/midhhealth/elastic-stack` with
   root-only permissions. AWX reloads that material for later runs; Git and
   stateless job workspaces never store it. Back up the directory through the
   restricted platform secret-backup process.
9. Validate ingestion, index lifecycle, dashboards, audit logging, restart,
   backup, and restore behavior.

## Rocky Linux Fleet Enrollment

Use the version-controlled workflow; do not install or edit Filebeat manually:

```bash
ansible-playbook --syntax-check playbooks/deploy-fleet-logging.yml
ansible-playbook --check playbooks/deploy-fleet-logging.yml
ansible-playbook playbooks/deploy-fleet-logging.yml
ansible-playbook playbooks/verify-fleet-logging.yml
```

The `rocky_log_senders` inventory group is the acceptance source of truth.
Every sender must run Filebeat 9.4.2, keep a 1 GB disk queue, read
`/var/log/secure` and `/var/log/messages`, and verify the Logstash certificate.
The verifier compares recent Elasticsearch `host.name` values with the entire
inventory group. Missing hosts are failures, not exclusions.

### Manual AWX access repair

INC-2026-027 was resolved with one local AWX console session. Retain this
procedure for recurrence. From an interactive terminal, connect to infra01 and
open the configured serial console:

```bash
ssh midhtechadmin@infra01.example.com
virsh --connect qemu:///system console awx.example.com
```

If libvirt reports an active console session, first check for a stale viewer
with `ps -ef | grep '[v]irsh.*console.*awx.example.com'`. Exit an active
operator session normally with `Ctrl+]`; do not stop or reboot the VM merely to
clear a console-viewer lock.

Log in with the existing local AWX account. Use `Ctrl+]` to leave the serial
console. Before using sudo, require the guest identity:

```bash
hostname --fqdn
# Required output: awx.example.com
```

Run these commands only after the prompt and hostname identify AWX; they
preserve the existing file:

```bash
sudo install -d -o midhtechadmin -g midhtechadmin -m 0700 \
  /home/midhtechadmin/.ssh
sudo touch /home/midhtechadmin/.ssh/authorized_keys
sudo chown midhtechadmin:midhtechadmin \
  /home/midhtechadmin/.ssh/authorized_keys
sudo chmod 0600 /home/midhtechadmin/.ssh/authorized_keys
sudo restorecon -RFv /home/midhtechadmin/.ssh
```

From the Mac, display the approved public key with
`cat ~/.ssh/id_rsa.pub`. If that exact line is absent on AWX, append it from the
local AWX session; do not replace the file or remove other approved keys. Then
verify from the Mac:

```bash
ssh -o BatchMode=yes midhtechadmin@awx.example.com
```

After access succeeds, rerun the fleet deployment and verifier. Closure
requires `expected_hosts: 31`, `observed_hosts: 31`, and an empty missing-host
list.

Initial enrollment imported existing active-file history because deployment
activity updated both watched files during startup. Logstash's persistent queue
drained to zero without loss. Capacity-plan first enrollment as a controlled
backfill and watch the Logstash queue, Elasticsearch disk watermarks, and index
growth. The configured `ignore_inactive` setting is not a guaranteed
tail-only enrollment control for actively changing system logs.

## Approved Log Scope

Logstash is the Elastic ingestion boundary. Events must be labeled with
`fields.midhhealth_log_type` and should use one of these approved values:

| Log class | Expected source |
| --- | --- |
| `nginx_access`, `nginx_error` | NGINX reverse-proxy access and backend failure logs |
| `linux_auth`, `linux_system` | SSH, sudo, systemd, kernel, storage and host-network events |
| `jenkins_job`, `awx_job` | Delivery and automation job summaries, failures, approvals and run IDs |
| `kubernetes_ingress` | Kubernetes ingress/controller routing events |
| `postgres_error`, `postgres_slow` | PostgreSQL error, slow-query, backup and restore signals |
| `application_json` | Structured care, payer and platform application logs without PHI payloads |
| `ai_audit`, `mlops_audit` | Future AI/MLOps audit metadata without protected data payloads |

Events marked `contains_phi: true` are dropped at Logstash. Raw clinical notes,
claims payloads, member data, passwords, tokens, private keys and high-volume
debug streams must not be sent to Elastic.

## Acceptance and Operations

AWX jobs `311` and `316` provide installation and verification evidence for
cluster health, node membership, TLS-protected Elasticsearch, Kibana, Logstash,
the index template, and a test Logstash event. The 2026-07-28 fleet rollout
and final AWX enrollment additionally proved 31 active Filebeat services, 31
encrypted output tests, 31 recent Elasticsearch source hostnames, a green
three-node cluster, and a drained Logstash persistent queue. Continue to capture shard
allocation, certificate expiry, disk watermarks, and service enablement in
scheduled operational evidence.
Configure snapshot repositories before production-like data is admitted.
Back up configuration and snapshot indices before upgrades.

The supported major migration route for legacy training data is
`6.x → 7.17 → 8.19 → 9.4.2`. Run the Upgrade Assistant, resolve deprecations,
reindex incompatible indices, snapshot, restore-test, and follow the vendor's
documented node order. Upgrade Elasticsearch before Kibana; validate Logstash
plugin compatibility at each stage.

Official references:

- [Elastic release notes](https://www.elastic.co/docs/release-notes)
- [Elastic self-managed upgrade guidance](https://www.elastic.co/docs/deploy-manage/upgrade/deployment-or-cluster/upgrade-717)
