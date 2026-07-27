# Splunk Enterprise Installation

## Scope and Current State

`splunk.example.com` is a standalone Splunk Enterprise training VM. The lab
does not implement a Splunk indexer cluster, search-head cluster, or HA.
Splunk is retained beside the open-source and Elastic observability paths so
staff can compare enterprise operations, licensing, ingestion, and migration.

As of 2026-07-27, the Rocky Linux 9.8 VM and DNS records exist, but Splunk is
**not installed**. Apply the common baseline and mount `/data` first.

| VM | Address | Resources | Target |
| --- | --- | --- | --- |
| `splunk.example.com` | `192.168.1.118` | 4 vCPU, 8 GB RAM, 50/150 GB disks | Splunk Enterprise 10.4.1 |

## Network and Access

- User interface `8000/tcp`: NGINX only; users browse
  `https://splunk.apps.example.com`.
- Management API `8089/tcp`: AWX and approved administrators only.
- Receiving `9997/tcp` and HTTP Event Collector `8088/tcp`: open only to
  approved senders when configured.
- SSH remains management-only.

Until Splunk is installed, the friendly URL returning `502 Bad Gateway` is
expected.

## AWX Implementation Sequence

1. Verify the Rocky baseline, SELinux, firewalld, time sync, guest agent, and
   XFS `/data`.
2. Confirm the lab's Splunk trial/free entitlement and ingestion limits before
   admitting data.
3. Download the vendor RPM through an approved artifact path, validate its
   checksum/signature, and record the exact build in the lock file.
4. Install as the dedicated `splunk` account. Place indexes and operational
   data on `/data`; keep version-controlled configuration outside generated
   runtime files.
5. Accept the license non-interactively only through a protected AWX
   credential/workflow. Set the admin secret through Vault/AWX, never Git.
6. Enable boot-start with systemd, configure TLS, trusted proxy/public URL,
   role-based access, retention, and only the required receiving inputs.
7. Validate login through NGINX, HEC with a test token, search, restart,
   backup, and restore.

## Backup, Upgrade, and Acceptance

Back up `$SPLUNK_HOME/etc`, indexed data required by the exercise, licenses,
and app configuration. Protect secrets in `passwords.conf` and related files.
Acceptance evidence includes the exact build, service status, secure login,
license state, a test event and search, port restrictions, and restore test.

For older estates, use vendor-supported hops rather than skipping majors:
`7.x → 8.x → 9.x → 10.4.1`. At every hop, review operating-system, Python,
app/add-on, forwarder, index-format, and license compatibility; test a restored
copy first and retain a rollback backup.

Official references:

- [Splunk Enterprise download and current release](https://www.splunk.com/en_us/download/splunk-enterprise.html)
- [Splunk Enterprise 10.4 release notes](https://help.splunk.com/en/splunk-enterprise/release-notes-and-updates/release-notes/10.4/whats-new/welcome-to-splunk-enterprise-10.4)

