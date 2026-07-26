# Environment Details

## Environment Model

The lab supports two deployment targets:

| Target | Purpose | Provisioning path | Delivery path |
| --- | --- | --- | --- |
| Local KVM | Persistent training and integration environment | Ansible + libvirt + cloud-init | GitLab → Jenkins → Harbor/Artifactory → Argo CD |
| AWS (deferred) | Future cloud validation environment | AWX → Terraform/OpenTofu → EKS/ECR | GitLab → Jenkins → ECR → Argo CD |

Application promotion uses Kubernetes namespaces instead of a separate cluster
for every environment:

| Environment | Namespace | Branch or tag | Deployment policy |
| --- | --- | --- | --- |
| Development | `app-dev` | feature or `develop` | Automatic sync |
| QA | `app-qa` | release candidate | Automatic after tests |
| Stage | `app-stage` | release tag | Manual approval |
| Production simulation | `app-prod` | approved immutable tag | Manual approval and evidence |

## Base Operating Systems

| Layer | Operating system |
| --- | --- |
| Physical hosts | Ubuntu 26.04 LTS Desktop with GNOME |
| Virtual machines | Rocky Linux 9 GenericCloud image |
| Container workloads | Minimal vendor or enterprise base images |

## Core Endpoints

Application endpoints use the `apps.example.com` service namespace through the
NGINX/Keepalived VIP at `192.168.1.140`. VM management names remain direct
`<node>.example.com` records. HTTP is permitted only during bootstrap; the
target state uses TLS from the internal certificate authority:

| Endpoint | Function |
| --- | --- |
| `https://gitlab.apps.example.com` | Source control and merge requests |
| `https://jenkins.apps.example.com` | CI pipelines |
| `https://awx.apps.example.com` | Automation controller |
| `https://harbor.apps.example.com` | OCI images and Helm OCI |
| `https://artifactory.apps.example.com` | Build artifacts |
| `https://sonarqube.apps.example.com` | Code quality |
| `https://vault.apps.example.com` | Secrets |
| `https://grafana.apps.example.com` | Dashboards |
| `https://prometheus.apps.example.com` | Metrics |
| `https://alertmanager.apps.example.com` | Alerts |
| `https://keycloak.apps.example.com` | SSO/OIDC |
| `https://minio.apps.example.com` | Object-storage console |

Argo CD is added to the proxy only after the Kubernetes ingress endpoint is
known and validated. PostgreSQL, DNS, SSH, Kubernetes control-plane ports,
OpenTelemetry gRPC, and other non-HTTP protocols are not forced through this
HTTP reverse-proxy tier.

## Credentials and Trust

- Human users authenticate through Keycloak where the product supports OIDC.
- Jenkins and AWX use service identities with narrowly scoped permissions.
- Kubernetes retrieves secrets through External Secrets Operator.
- AWS automation uses IAM Roles Anywhere and temporary credentials.
- Long-lived AWS administrator keys must not be stored in AWX or Jenkins.
- Internal TLS certificates are issued by the lab CA and distributed through
  configuration management.
- Secrets, private keys, tokens, and generated kubeconfigs are never committed.

## Deferred AWS Guardrails

- Use an approved AWS account and region.
- Require `Environment`, `Owner`, `Project`, `ManagedBy`, and `ExpiresAt` tags.
- Enable EKS control-plane logs.
- Encrypt EKS secrets and ECR images with KMS where configured.
- Scan Terraform/OpenTofu before apply and container images before ECR push.
- Configure an AWS Budget alert before the first deployment.
- Provide a separately approved AWX destroy workflow.
- Default training environments to automatic expiration.

## Backup and Recovery

- `backup.example.com` coordinates database dumps, configuration backups, and
  recovery tests.
- `minio.example.com` stores local S3-compatible backup objects.
- Velero backs up Kubernetes resources and supported persistent volumes.
- GitLab, Jenkins, AWX, Harbor, Artifactory, PostgreSQL, Prometheus, Loki, and
  Tempo have documented product-specific backup jobs.
- A backup is not accepted until a restore test produces evidence.

## Build Order

1. Reinstall and validate `infra02`.
2. Install KVM/libvirt, networking, storage, and Ansible on `infra02`.
3. Reinstall and validate `infra01`.
4. Install KVM/libvirt, networking, storage, and Ansible on `infra01`.
5. Build DNS and the NGINX/Keepalived reverse-proxy cluster.
6. Build PostgreSQL, Vault/OpenBao, MinIO, and backup services.
7. Build GitLab, Jenkins, AWX, AWX execution, Harbor, Artifactory, and
   SonarQube.
8. Build the Kubernetes control plane and three workers.
9. Bootstrap Argo CD and platform add-ons.
10. Build the observability services and connect all targets.
11. Enable governance evidence collection.
12. Complete on-premises acceptance testing. IAM Roles Anywhere and the AWX
    EKS/ECR workflow are deferred until a later phase.
