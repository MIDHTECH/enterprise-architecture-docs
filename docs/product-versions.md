# Product Version Catalog

This catalog pins the on-premises platform baseline as of 25 July 2026.
Container images must use the full version shown here or a later approved patch
within the same release line. Never deploy `latest`.

Patch versions marked **resolve at build** must be selected from the vendor's
official release channel on the implementation day, recorded in the lock file,
and tested before deployment.

## Operating System and Virtualization

| Product | Target version | Installation source | Version policy |
| --- | --- | --- | --- |
| Ubuntu Desktop | 26.04 LTS | Canonical ISO | Apply supported security and point updates |
| Rocky Linux | 9, latest supported 9.x GenericCloud image | Rocky Linux official mirror | Stay on Rocky 9 and apply current point updates |
| QEMU/KVM | Ubuntu 26.04 repository version | Ubuntu repositories | Follow Ubuntu security updates |
| libvirt | Ubuntu 26.04 repository version | Ubuntu repositories | Follow Ubuntu security updates |
| cloud-init | Ubuntu/Rocky repository version | Distribution repositories | Follow operating-system updates |
| Ansible Core | Supported Ubuntu package initially; pin execution environments separately | Ubuntu and Ansible collections | Upgrade collections after integration tests |
| Docker Engine | 29.x, latest approved patch | Docker CE repository | Pin major/minor and review daemon changes |
| Docker Compose plugin | 5.x, latest approved patch | Docker CE repository | Pin Compose file compatibility |

## Delivery, Identity, and Artifact Services

| Product | Target version | Deployment | Upgrade authority |
| --- | --- | --- | --- |
| GitLab CE | 19.2, latest patch | GitLab Omnibus container on `gitlab.example.com` | [GitLab upgrade paths](https://docs.gitlab.com/update/upgrade_paths/) |
| Jenkins | 2.555.3 LTS | Container on `jenkins.example.com` | [Jenkins LTS changelog](https://www.jenkins.io/changelog-stable/) |
| AWX | 24.6.1 | AWX Operator on dedicated k3s | AWX and operator release notes |
| AWX Operator | 2.19.1 | k3s on `awx.example.com` | AWX Operator releases |
| AWX execution environment | Project-owned `2026.07.0` | OCI image on `awx-execution.example.com` | Rebuild monthly from locked dependencies |
| Vault Community | 2.0.3 | Native service on `vault.example.com` | [Vault release notes](https://developer.hashicorp.com/vault/docs/updates/release-notes) |
| Keycloak | 26.4, latest patch | Container on `keycloak.example.com` | Keycloak upgrading guide |
| Harbor | 2.15.0 | Official Compose installer on `harbor.example.com` | [Harbor migration guide](https://goharbor.io/docs/main/administration/upgrade/) |
| Artifactory OSS | 7.146.29 | Official container on `artifactory.example.com` | [Artifactory release notes](https://docs.jfrog.com/releases/docs/artifactory-release-notes) |
| SonarQube Community Build | 26.7, latest patch | Container on `sonarqube.example.com` | [SonarQube update path](https://docs.sonarsource.com/sonarqube-community-build/server-update-and-maintenance/update/determine-path) |
| PostgreSQL | 18.4 | Native service on `postgres.example.com` | [PostgreSQL version policy](https://www.postgresql.org/support/versioning/) |

## Kubernetes Platform

| Product | Target version | Deployment | Version policy |
| --- | --- | --- | --- |
| Kubernetes | 1.34, latest patch | kubeadm on Rocky Linux 9 | Upgrade one minor at a time |
| containerd | 2.1, latest approved patch | Native on Kubernetes nodes | Validate CRI compatibility before Kubernetes upgrade |
| Cilium | 1.18, latest patch | Argo CD | Upgrade one supported minor at a time |
| Argo CD | 3.1, latest patch | Kubernetes | Pin manifests/chart and review upgrade notes |
| MetalLB | 0.15, latest patch | Kubernetes | Pin CRDs and controller/speaker images |
| ingress-nginx | 1.13, latest patch | Kubernetes | Pin controller and admission jobs |
| cert-manager | 1.18, latest patch | Kubernetes | Back up and upgrade CRDs first |
| Kyverno | 1.15, latest patch | Kubernetes | Validate policies against new engine |
| External Secrets Operator | 0.19, latest patch | Kubernetes | Validate CRDs and provider behavior |
| metrics-server | 0.8, latest patch | Kubernetes | Match supported Kubernetes versions |
| Velero | 1.17, latest patch | Kubernetes | Verify backup-storage and volume plugins |
| Longhorn | 1.9, latest patch | Kubernetes | Follow sequential Longhorn upgrade path |
| Trivy Operator | 0.29, latest patch | Kubernetes | Review CRD changes before upgrade |
| Argo Rollouts | 1.8, latest patch | Kubernetes, later phase | Install after base platform acceptance |

## Observability, Storage, and Backup

| Product | Target version | Deployment | Upgrade authority |
| --- | --- | --- | --- |
| Prometheus | 3.13.1 LTS | Container on `prometheus.example.com` | [Prometheus downloads](https://prometheus.io/download/) |
| Alertmanager | 0.33.1 | Container on `alertmanager.example.com` | [Prometheus downloads](https://prometheus.io/download/) |
| Blackbox Exporter | 0.28.0 | Prometheus VM auxiliary container | [Prometheus downloads](https://prometheus.io/download/) |
| Node Exporter | 1.12.1 | All hosts and VMs | [Prometheus downloads](https://prometheus.io/download/) |
| Grafana | 13.1, latest patch | Container on `grafana.example.com` | [Grafana upgrade guide](https://grafana.com/docs/grafana/latest/upgrade-guide/) |
| Loki | 3.7, latest patch | Container on `loki.example.com` | [Loki upgrade guide](https://grafana.com/docs/loki/latest/setup/upgrade/) |
| Tempo | 3.0, latest patch | Container on `tempo.example.com` | [Tempo upgrade guide](https://grafana.com/docs/tempo/latest/set-up-for-tracing/setup-tempo/upgrade/) |
| OpenTelemetry Collector Contrib | 0.137, latest patch | Container on `otel.example.com` | Pin receivers, processors, exporters, and extensions |
| MinIO Community | `RELEASE.2025-04-22T22-12-26Z` pending community-support review | Container on `minio.example.com` | Do not change tags without testing data-format compatibility |
| Restic | 0.18, latest patch | Native on `backup.example.com` | Verify repository format and run `restic check` |

## Supporting Platform Packages

Use the Rocky Linux 9 repository versions for BIND, chrony, firewalld,
qemu-guest-agent, SELinux policy, Python, and system utilities. Use the newest
supported patch within the selected major/minor family.

## Pinning Rules

1. Record every deployed package, container digest, Helm chart, and
   GenericCloud checksum in a generated lock file.
2. Pin container images by version and digest.
3. Do not automatically cross major versions.
4. Apply security patches within an approved maintenance window.
5. Test upgrades against restored data and configuration.
6. Update this catalog after every approved product migration.
7. If the vendor's target version is unavailable for the selected edition,
   stop and revise the catalog rather than substituting an unreviewed tag.
