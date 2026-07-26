# Product Migration History and Annual Upgrade Plan

This guide provides annual migration checkpoints from 2018 through the 2026
on-premises baseline. The principal architecture story is 2023–2026; the older
versions are retained as historical context and for long-lived product
migrations.

See [Architecture Evolution: 2023–2026](architecture-evolution-2023-2026.md)
and [MAAS Monolith-to-Microservices Modernization](maas-monolith-to-microservices.md).

The listed versions are representative supported checkpoints for each year,
not permission to skip vendor-required intermediate releases. Before every
migration, calculate the exact path from the installed patch version using the
vendor's current upgrade documentation.

## Mandatory Migration Procedure

Every product migration follows this sequence:

1. Record the installed version, plugins, integrations, data size, and
   configuration checksum.
2. Read every release note and breaking-change notice between source and
   target.
3. Back up data, configuration, certificates, keys, and external databases.
4. Restore the backup into an isolated migration-test VM.
5. Upgrade through every required intermediate version.
6. Run schema/background migrations to completion.
7. Run product, integration, security, performance, and rollback tests.
8. Take a new backup, schedule the maintenance window, and obtain approval.
9. Upgrade the live service and preserve the old VM/disk until acceptance.
10. Record evidence and update `docs/product-versions.md`.

## Annual Platform Checkpoints

| Product | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 target |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Ubuntu host | 18.04 LTS | 18.04 LTS | 20.04 LTS | 20.04 LTS | 22.04 LTS | 22.04 LTS | 24.04 LTS | 24.04 LTS | 26.04 LTS |
| Enterprise Linux guest | CentOS/RHEL 7 | CentOS/RHEL 7 | CentOS/RHEL 8 | Rocky 8 | Rocky 9 | Rocky 9 | Rocky 9 | Rocky 9 | Rocky 9 |
| GitLab | 11.x | 12.x | 13.x | 14.x | 15.x | 16.x | 17.x | 18.x | 19.2.z |
| Jenkins LTS | 2.138.x | 2.176.x | 2.235.x | 2.263.x | 2.332.x | 2.401.x | 2.479.x | 2.516.x | 2.555.3 |
| AWX | 2.x | 9.x | 15.x | 19.x | 21.x | 23.x | 24.x | 24.x | 24.6.1 |
| Vault | 0.11 | 1.2 | 1.6 | 1.9 | 1.12 | 1.15 | 1.18 | 1.20 | 2.0.3 |
| Keycloak | 4.x | 8.x | 11.x | 15.x | 20.x | 23.x | 26.0 | 26.2 | 26.4.z |
| Harbor | 1.6 | 1.10 | 2.1 | 2.4 | 2.7 | 2.9 | 2.12 | 2.14 | 2.15.0 |
| Artifactory | 6.x | 6.x | 7.0 | 7.12+ | 7.31+ | 7.55+ | 7.90+ | 7.125+ | 7.146.29 |
| SonarQube | 7.x | 8.x | 8.9 LTS | 9.x | 9.9 LTA | 10.x | 24.12 | 25.12 | 26.7.z |
| PostgreSQL | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 18.4 |
| Kubernetes | 1.13 | 1.17 | 1.20 | 1.23 | 1.26 | 1.29 | 1.32 | 1.33 | 1.34.z |
| Argo CD | 0.x | 1.3 | 1.8 | 2.2 | 2.5 | 2.9 | 2.13 | 3.0 | 3.1.z |
| Prometheus | 2.5 | 2.15 | 2.23 | 2.32 | 2.40 | 2.48 | 2.55 | 3.5 LTS | 3.13.1 LTS |
| Alertmanager | 0.15 | 0.20 | 0.21 | 0.23 | 0.25 | 0.26 | 0.27 | 0.28 | 0.33.1 |
| Grafana | 5.x | 6.x | 7.x | 8.x | 9.x | 10.x | 11.x | 12.x | 13.1.z |
| Loki | Not released | 1.x | 2.0 | 2.4 | 2.7 | 2.9 | 3.2 | 3.6 | 3.7.z |
| Tempo | Not released | Not released | Preview | 1.x | 1.5 | 2.3 | 2.6 | 2.8 | 3.0.z |
| OpenTelemetry Collector | Not released | Early project | 0.x | 0.x | 0.x | 0.x | 0.x | 0.x | 0.137.z |
| Velero | 0.x | 1.2 | 1.5 | 1.7 | 1.10 | 1.12 | 1.14 | 1.16 | 1.17.z |
| Longhorn | Not released | Preview | 1.0 | 1.2 | 1.3 | 1.5 | 1.7 | 1.8 | 1.9.z |
| NGINX | 1.14 | 1.16 | 1.18 | 1.20 | 1.22 | 1.24 | 1.26 | 1.26 | 1.26.3 |
| Keepalived | 1.3 | 2.0 | 2.0 | 2.2 | 2.2 | 2.2 | 2.2 | 2.2 | 2.2.8 |

## Product-Specific Migration Routes

### Ubuntu Hypervisors

Annual checkpoint:

```text
18.04 → 20.04 → 22.04 → 24.04 → 26.04
```

Only consecutive Ubuntu releases are supported for in-place upgrades. For the
current lab, use a fresh 26.04 installation instead of carrying eight years of
packages, VirtualBox configuration, and VM data forward. Export the old
inventory, rebuild, then restore only approved configuration.

### Rocky Linux Guests

Rocky Linux did not exist in 2018. Treat CentOS/RHEL 7 and 8 as predecessor
platforms. Do not perform an in-place major migration into Rocky 9 product VMs.
Create a fresh Rocky 9 VM, install the target product, migrate application
data, switch DNS, and retain the source VM for rollback.

### NGINX and Keepalived Edge Tier

The edge tier moves from a single-host reverse proxy to two Rocky Linux nodes
with a floating Keepalived VIP:

```text
single NGINX endpoint → versioned proxy configuration → dual NGINX nodes
→ unicast VRRP VIP → trusted internal TLS
```

For annual upgrades, drain one node by lowering its Keepalived priority or
stopping Keepalived, upgrade and validate NGINX configuration with `nginx -t`,
restore it, then repeat on the peer. Never upgrade both nodes in the same step.
Keepalived configuration changes require a controlled failover test. Before
crossing NGINX release lines, review removed directives, module ABI
compatibility, TLS defaults, HTTP/2 behavior, header parsing, and upstream
retry semantics. Preserve the previous RPMs and proxy configuration until both
nodes pass application and failover acceptance tests.

### GitLab

Representative annual route:

```text
11 → 12 → 13 → 14 → 15 → 16 → 17 → 18 → 19.2
```

GitLab requires version-specific stops and completion of background migrations.
From 17.5 onward, required stops follow `x.2`, `x.5`, `x.8`, and `x.11`.
Always use the latest patch at each required stop and calculate the exact path
with the [GitLab upgrade-path documentation](https://docs.gitlab.com/update/upgrade_paths/).
Back up repositories, uploads, configuration, secrets, and the database.

### Jenkins

Migrate through supported LTS lines annually. Back up `JENKINS_HOME`, export
the plugin catalog, validate the Java requirement for the target LTS, then
upgrade the controller image and plugins in a clone. Do not update all plugins
blindly; test Job DSL, shared libraries, credentials, agents, and pipelines.

### AWX

AWX installations changed substantially between the 2018 Docker-based releases
and the current Operator-based model. Treat this as a platform migration:

```text
legacy AWX export → fresh AWX Operator deployment → import organizations,
inventories, credentials metadata, projects, templates, workflows, and RBAC
```

Recreate secret values through Vault rather than embedding them in exports.
Keep AWX, AWX Operator, PostgreSQL, receptor, and execution-environment
compatibility aligned.

### Vault

Representative route:

```text
0.11 → 1.2 → 1.6 → 1.9 → 1.12 → 1.15 → 1.18 → 1.20 → 2.0.3
```

Take a Raft snapshot and configuration backup, restore into an isolated test
network, review the historic change tracker, and test every auth method and
secrets engine. Vault can change its storage format and does not guarantee
backward data compatibility. Review the [official upgrade guide](https://developer.hashicorp.com/vault/docs/upgrade).

### Keycloak

Keycloak moved from the WildFly distribution to the Quarkus distribution.
Upgrade through documented major-version steps, migrate configuration to
`keycloak.conf` and `kc.sh`, validate custom providers/themes, back up
PostgreSQL, and run the target image against a restored database before
production.

### Harbor

Representative route:

```text
1.6 → 1.10 → 2.1 → 2.4 → 2.7 → 2.9 → 2.12 → 2.14 → 2.15
```

Use Harbor's `prepare` migration utility for every supported step. Back up
`harbor.yml`, certificates, secrets, registry data, and the database. Harbor's
current guide covers 2.12 to 2.15; use archived guides for older stops.

### Artifactory OSS

Representative route:

```text
6.x → latest 6.23.x → supported 7.x bridge → 7.146.29
```

Do not jump directly from an early 6.x release. JFrog documents explicit 6.23
to 7.x compatibility thresholds. Export system configuration, back up the
database and filestore, test Access-service migration, replace API keys with
tokens, and review Java/runtime and deprecated API changes.

### SonarQube Community Build

Representative route:

```text
7.x → 8.9 LTS → 9.9 LTA → 24.12 → 25.12 or 26.1 bridge → 26.7
```

Back up PostgreSQL and configuration. Install the target into a new directory
or image, install only compatible plugins, and let SonarQube perform database
migrations. SonarQube requires the December release before crossing calendar
years, with documented exceptions such as the 26.1 bridge.

### PostgreSQL

Annual route:

```text
11 → 12 → 13 → 14 → 15 → 16 → 17 → 18.4
```

PostgreSQL permits a direct major migration with `pg_upgrade` or dump/restore;
intermediate installations are not required. Still review every intervening
release note. Use dump/restore for the training lab when practical because it
also validates logical recoverability.

### Kubernetes and containerd

Kubernetes supports upgrading one minor version at a time:

```text
1.13 → ... → 1.33 → 1.34
```

For very old clusters, build a new 1.34 cluster and migrate workloads rather
than attempting more than twenty sequential control-plane upgrades. For future
annual maintenance, upgrade kubeadm, control plane, kubelet workers, kubectl,
then add-ons. Respect version skew and back up etcd before each control-plane
change.

### Argo CD and Kubernetes Add-ons

Upgrade Argo CD and every controller separately. Back up custom resources and
configuration, apply new CRDs before controllers when the vendor requires it,
then validate reconciliation. Never update Argo CD, Cilium, ingress, cert-manager,
Kyverno, External Secrets, Longhorn, Velero, and Trivy Operator in one change.

Annual controller review:

| Product | 2018 status | 2026 target | Migration rule |
| --- | --- | --- | --- |
| Cilium | Early 1.x | 1.18.z | Sequential supported minor upgrades |
| MetalLB | Early 0.x | 0.15.z | Convert legacy ConfigMap to CRDs before removal |
| ingress-nginx | 0.x | 1.13.z | Review Kubernetes API and annotation removals |
| cert-manager | 0.x | 1.18.z | Back up resources and upgrade CRDs first |
| Kyverno | Not released | 1.15.z | Test every policy against target engine |
| External Secrets | Predecessor projects | 0.19.z | Convert CRDs/provider configuration |
| metrics-server | 0.x | 0.8.z | Match Kubernetes support matrix |
| Velero | 0.x | 1.17.z | Upgrade server and plugins together |
| Longhorn | Not released | 1.9.z | Follow only documented sequential versions |
| Trivy Operator | Not released | 0.29.z | Review report CRD changes |

### Prometheus and Alertmanager

Representative route:

```text
Prometheus 2.5 → 2.15 → 2.23 → 2.32 → 2.40 → 2.48 → 2.55
→ 3.5 LTS → 3.13.1 LTS
```

Validate rules with `promtool`, check removed flags and feature gates, and
verify the TSDB before and after migration. Upgrade Alertmanager sequentially
enough to remove API v1 dependencies before versions that remove it.

### Grafana

Representative route:

```text
5 → 6 → 7 → 8 → 9 → 10 → 11 → 12 → 13.1
```

Back up the database, provisioning, plugins, and encryption key. Review every
major upgrade guide, update plugins after the server, and validate dashboards,
alerts, authentication, and data sources.

### Loki

Loki was introduced after 2018:

```text
1.x → 2.0 → 2.4 → 2.7 → 2.9 → 3.0 → 3.6 → 3.7
```

Before 3.0, migrate to TSDB and schema v13 or explicitly disable structured
metadata temporarily. Validate configuration with the target image, review
storage-client changes, and do not rewrite historical schema entries.

### Tempo

Tempo was introduced after 2018:

```text
preview → 1.x → 2.x → 3.0
```

Validate object-store compatibility, configuration field migrations, TraceQL
behavior, overrides, and Grafana data-source compatibility. Preserve old trace
blocks until the new deployment can query them.

### OpenTelemetry Collector

The Collector remained pre-1.0 through this history. Pin exact versions and
upgrade at least annually, preferably quarterly. Run
`otelcol-contrib validate --config <file>` against the target binary and
review component stability, renamed processors, removed exporters, and
telemetry-schema changes.

### MinIO and Restic

MinIO uses date-based release tags. Upgrade through tested release snapshots
and verify object/API compatibility. Because community distribution and
support changed, reassess the selected MinIO release before deployment.

Before every Restic update:

```bash
restic snapshots
restic check
```

After the update, restore sample files and validate repository access from a
clean client.

## Annual Migration Calendar

| Quarter | Activity |
| --- | --- |
| Q1 | Identity, secrets, certificates, and database migration rehearsal |
| Q2 | Kubernetes, CNI, ingress, storage, and GitOps controllers |
| Q3 | GitLab, Jenkins, AWX, Harbor, Artifactory, and SonarQube |
| Q4 | Prometheus, Grafana, Loki, Tempo, OpenTelemetry, backup restore test, and next-year roadmap |

Emergency security patches can occur outside this calendar. Major upgrades
must remain separate changes with their own rollback and evidence.
