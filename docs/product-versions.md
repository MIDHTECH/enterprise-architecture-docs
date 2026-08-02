# Product Version Catalog

This catalog pins the on-premises platform baseline as of 2 August 2026.
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
| NGINX | 1.26.3 Rocky module stream | Rocky Linux 9 AppStream | Stay on the 1.26 stream; apply supported security errata |

## Delivery, Identity, and Artifact Services

| Product | Target version | Deployment | Upgrade authority |
| --- | --- | --- | --- |
| GitLab CE | 19.2, latest patch | GitLab Omnibus container on `gitlab.example.com` | [GitLab upgrade paths](https://docs.gitlab.com/update/upgrade_paths/) |
| GitLab Runner | 19.2.0 | Docker executors on accepted `gitlab-runner-infra01.example.com`, `gitlab-runner-app01.example.com`, and `gitlab-runner-shared01.example.com`; legacy runner ID 2 on `gitlab.example.com` is paused and its container is retired | Upgrade with GitLab compatibility validation |
| Terraform CI | 1.13.5 | `hashicorp/terraform` container | Pin the image and provider lock files |
| Ansible Core CI | 2.21.2 | Python CI container | Pin with repository requirements |
| ansible-lint | 26.6.0 | Python CI container | Raise the enforced profile as legacy findings are remediated |
| Checkov | 3.3.8 | `bridgecrew/checkov` container | All findings remain blocking unless a risk exception is explicitly approved |
| Jenkins | 2.568.1 LTS | Native RPM and systemd on `jenkins.example.com` | [Jenkins LTS changelog](https://www.jenkins.io/changelog-stable/) |
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
| Helm | 4.1.0 | Pinned binary on `jenkins-agent01`; Jenkins release execution | Upgrade only after chart and rollback compatibility tests |
| Cilium | 1.18, latest patch | Argo CD | Upgrade one supported minor at a time |
| Argo CD | 3.1, latest patch | Kubernetes | Pin manifests/chart and review upgrade notes |
| MetalLB | 0.15, latest patch | Kubernetes | Pin CRDs and controller/speaker images |
| ingress-nginx | Chart 4.15.0; controller 1.15.1 | Jenkins-managed Helm release; controller image digest pinned | Validate chart lock, render, atomic deployment, second convergence, and rollback |
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
| Prometheus | 3.13.1 | Native systemd on `prometheus.example.com` | `ansible-prometheus` |
| Alertmanager | 0.33.1 | Native systemd on `alertmanager.example.com` | `ansible-observability` |
| Blackbox Exporter | 0.25.0 | Native systemd on `prometheus.example.com` | `ansible-observability` |
| Node Exporter | 1.11.1 | Native systemd on all managed hosts | `ansible-prometheus` |
| Grafana | 13.1.1 | Native RPM and systemd on `grafana.example.com` | `ansible-prometheus` |
| Loki | 3.7.4 | Native systemd on `loki.example.com` | `ansible-observability` |
| Tempo | 3.0.2 | Native RPM and systemd on `tempo.example.com` | `ansible-observability` |
| OpenTelemetry Collector Contrib | 0.137.0 | Native RPM and systemd on `otel.example.com` | `ansible-observability` |
| MinIO Community | `RELEASE.2025-04-22T22-12-26Z` | Native systemd on `minio.example.com` | `ansible-observability` |
| Elastic Stack | 9.4.2 | Native packages on three Elasticsearch nodes plus Kibana and Logstash | [Elastic release notes](https://www.elastic.co/docs/release-notes) |
| Filebeat | 9.4.2 | Native systemd sender on all 31 Rocky Linux VMs | [Filebeat filestream reference](https://www.elastic.co/docs/reference/beats/filebeat/filebeat-input-filestream) |
| Splunk Enterprise | 10.4.1 | Native standalone installation on `splunk.example.com` | [Splunk Enterprise download](https://www.splunk.com/en_us/download/splunk-enterprise.html) |
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

Elastic Stack 9.4.2 was reconciled through AWX job `311` and independently
verified through AWX job `316` on 2026-07-28. Splunk Enterprise 10.4.1 remains
an approved target; its VM is provisioned, but product installation is still
pending. Filebeat 9.4.2 fleet deployment and encrypted output checks completed
on all 31 Rocky Linux VMs on 2026-07-28.
