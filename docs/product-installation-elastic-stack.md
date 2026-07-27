# Elastic Stack Installation

## Scope and Current State

The lab uses a secured three-node Elasticsearch cluster with dedicated Kibana
and Logstash VMs. Numeric suffixes are valid here because Elasticsearch is a
cluster. This stack is independent of the Prometheus/Grafana/Loki/Tempo path
and exists for enterprise architecture and migration comparison.

As of 2026-07-27, the VMs and DNS records exist, but Elastic products are
**not installed**. The common Rocky baseline and `/data` mounts must be
completed before AWX installs any package.

| Role | VM | Address | Resources |
| --- | --- | --- | --- |
| Elasticsearch node 1 | `elasticsearch01.example.com` | `192.168.1.116` | 4 vCPU, 4 GB RAM, 40/150 GB disks |
| Elasticsearch node 2 | `elasticsearch02.example.com` | `192.168.1.133` | 4 vCPU, 4 GB RAM, 40/150 GB disks |
| Elasticsearch node 3 | `elasticsearch03.example.com` | `192.168.1.134` | 4 vCPU, 4 GB RAM, 40/150 GB disks |
| Kibana | `kibana.example.com` | `192.168.1.117` | 2 vCPU, 4 GB RAM, 40/40 GB disks |
| Logstash | `logstash.example.com` | `192.168.1.135` | 2 vCPU, 4 GB RAM, 40/40 GB disks |

Target all components at Elastic Stack 9.4.2. Pin exact repository packages in
the generated lock file; never mix stack versions during initial deployment.

## Network and Access

- Elasticsearch transport `9300/tcp`: cluster nodes only.
- Elasticsearch HTTPS `9200/tcp`: Kibana, Logstash, AWX, and approved
  administrators only.
- Kibana `5601/tcp`: NGINX only; users browse
  `https://kibana.apps.example.com`.
- Logstash Beats input `5044/tcp`: approved senders only.
- Do not publish Elasticsearch or Logstash through the HTTP reverse proxy.

Until Kibana is installed, its friendly URL returning `502 Bad Gateway` is
expected.

## AWX Implementation Sequence

1. Apply the common Rocky Linux baseline to all five VMs and verify SELinux,
   firewalld, chrony, qemu-guest-agent, and XFS `/data`.
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
8. Store generated credentials and certificate material in Vault/AWX, never
   Git.
9. Validate ingestion, index lifecycle, dashboards, audit logging, restart,
   backup, and restore behavior.

## Acceptance and Operations

Capture evidence for cluster health, shard allocation, TLS certificate chain,
Kibana login, a test Logstash event, disk watermarks, and service enablement.
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

