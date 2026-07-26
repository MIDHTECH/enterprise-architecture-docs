# PostgreSQL 18 Installation

## Purpose

`postgres.example.com` provides service databases for the on-premises platform.
It runs PostgreSQL 18.4 from the official PostgreSQL Yum repository on its
dedicated Rocky Linux 9.8 VM.

## Current Status and AWX Gate

PostgreSQL 18.4 completed its initial package and service bootstrap before the
AWX-first operating decision. Preserve the current running state, but make no
further lifecycle changes until `awx.example.com` is operational.

While this gate is active, staff must not:

- create application databases, roles, or credentials;
- apply schema, extension, authentication, or tuning customizations;
- configure backup, restore, replication, or monitoring integrations;
- perform package or major-version upgrades.

The Ansible role passed its second convergence run with `changed=0`,
`failed=0`, and `unreachable=0`. It remains the authoritative implementation
and will next be executed by AWX from the GitLab-hosted automation repository.

## Prerequisites

- VM address: `192.168.1.125`
- 4 vCPU and 8 GiB RAM
- 50 GiB operating-system disk
- 250 GiB XFS data disk mounted at `/data`
- Common Rocky baseline complete
- Key-based SSH from the Mac administration workstation

## Installation

Ansible is the authoritative installation and lifecycle method. After the AWX
control plane is available, launch the PostgreSQL job template in AWX. The
project must synchronize this repository from `gitlab.example.com` before the
job is permitted to run.

Direct command-line execution of `playbooks/postgresql18.yml` is retained for
break-glass recovery only and requires a recorded change approval.

The shell installer was used for the first bootstrap and remains available as
recovery/reference automation, but future configuration and upgrades must use
the `postgresql18` Ansible role.

Initial bootstrap fallback, retained for recovery reference only:

```bash
ssh -T midhtechadmin@192.168.1.125 \
  'sudo bash -s' \
  < workspace.training/scripts/install-postgresql18.sh
```

The installer:

- enables the official PGDG EL9 repository
- disables the Rocky application-stream PostgreSQL module
- installs PostgreSQL 18.4 server, client, and contrib packages
- initializes `/data/postgresql/18/data`
- uses peer authentication locally and SCRAM-SHA-256 remotely
- listens on localhost and `192.168.1.125`
- permits authenticated connections from the lab `/24`
- restricts port 5432 through firewalld to the lab network
- enables logging and starts the service

The installer does not create application roles or passwords. Those values
will be generated and stored through Vault after the secrets platform is
available.

## Validation

```bash
ssh midhtechadmin@192.168.1.125
sudo systemctl status postgresql-18 --no-pager
sudo -u postgres /usr/pgsql-18/bin/psql \
  -c 'SHOW server_version;'
/usr/pgsql-18/bin/pg_isready -h 192.168.1.125
sudo ss -lntp | grep ':5432'
sudo firewall-cmd --list-rich-rules
findmnt /data
```

Expected server version is `18.4`.

## Backup Preparation

Until `backup.example.com` is built on infra01, do not place irreplaceable
platform data in PostgreSQL. The later backup phase must configure encrypted
base backups, WAL archiving, retention, and a verified restore test.

## Rollback

Do not remove packages or delete `PGDATA` as an incident response. Stop the
service and preserve logs/data:

```bash
sudo systemctl stop postgresql-18
sudo tar -C /data/postgresql -czf \
  /data/postgresql-pre-recovery-$(date -u +%Y%m%dT%H%M%SZ).tar.gz 18
```

Escalate through the SRE incident process before destructive recovery.
