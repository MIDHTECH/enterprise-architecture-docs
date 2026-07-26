# Platform Installation Runbook

This runbook describes the installation order for the complete two-host lab.
Project-specific instructions are stored in each project repository.

## 1. Prepare the Hypervisors

On each freshly installed Ubuntu 26.04 LTS host:

```bash
sudo apt update
sudo apt full-upgrade -y
sudo apt install -y \
  qemu-kvm libvirt-daemon-system libvirt-clients virtinst \
  cloud-image-utils bridge-utils ansible git jq
sudo usermod -aG libvirt,kvm midhtechadmin
sudo systemctl enable --now libvirtd
```

Log out and back in, then validate:

```bash
id
virsh -c qemu:///system nodeinfo
sudo kvm-ok
```

Create a libvirt storage pool on a dedicated directory and configure a bridged
or routed VM network. Do not assign production VM addresses until DHCP
reservations and DNS entries have been approved.

## 2. Prepare the Rocky Linux Image

Download the current Rocky Linux 9 GenericCloud image from an official Rocky
Linux mirror. Verify its published checksum, import it as the read-only base
image, and create a copy-on-write qcow2 disk for each VM.

Every cloud-init definition must configure:

- FQDN from `docs/vm-inventory.md`
- `midhtechadmin` administration account and approved SSH public keys
- DHCP or reserved addressing
- DNS and NTP
- qemu-guest-agent
- SELinux enforcing and firewalld
- repository updates and automatic security updates

## 3. Bootstrap Source Control and Automation

First bootstrap `dns.example.com` as the network prerequisite and configure
the Copper9100 DHCP service to advertise `192.168.1.106`. Follow
`product-installation-dns.md`; clients must resolve lab records without local
hosts-file entries before platform product installation begins.

The first two platform products are:

1. `gitlab.example.com`
2. `awx.example.com`

Both VMs are assigned to infra01, at `192.168.1.101` and `192.168.1.103`
respectively. They can be created only after `infra01.example.com` is rebuilt
and its libvirt bridge, storage, Rocky image, and common VM baseline pass
validation.

Current readiness as of 2026-07-25: `infra01.example.com` now has libvirt,
`br0`, `lab-bridge`, `lab-images`, and all 13 planned VM domains. GitLab, AWX,
and DNS domains are running, but a concurrent lifecycle workflow has repeatedly
cycled the entire infra01 fleet. Do not start product configuration until that
workflow has ended and the guests remain reachable and baseline-valid.

Use narrowly scoped bootstrap automation to install GitLab first. Push the
platform repositories into GitLab, protect the main branches, and validate
clone access. Then bootstrap AWX, configure its project to synchronize the
Ansible repository from GitLab, add the on-premises inventory and credentials,
and prove a read-only validation job.

After the AWX validation job succeeds, all remaining product installation,
configuration, customization, and upgrades must run as AWX jobs sourced from
GitLab. Direct shell installation is break-glass activity and must have a
change record.

## 4. Build Foundational Services Through AWX

Build in this order:

1. `dns.example.com`
2. `vault.example.com`
3. `keycloak.example.com`
4. `minio.example.com`
5. `backup.example.com`
6. complete the gated configuration of `postgres.example.com`

Validate DNS forward and reverse records, PostgreSQL connectivity, certificate
trust, secret retrieval, object storage, and a sample restore before proceeding.

Where the inventory selects Docker Compose, install Docker Engine and the
Compose plugin only on that product VM. Store the project at
`/opt/midhtech/<product>/compose.yaml`; do not run a single cross-product
Compose stack spanning multiple VMs.

## 5. Build Remaining Delivery Services Through AWX

Build:

1. `awx-execution.example.com`
2. `jenkins.example.com`
3. `harbor.example.com`
4. `artifactory.example.com`
5. `sonarqube.example.com`

Connect GitLab webhooks to Jenkins, Jenkins credentials to AWX and Harbor,
SonarQube quality gates to Jenkins, and AWX project synchronization to GitLab.

GitLab, Jenkins, Harbor, Artifactory, and SonarQube use product-specific
Compose projects. AWX remains an AWX Operator installation because its
supported architecture is Kubernetes-based.

## 6. Build Kubernetes

Build:

1. `k8s-control.example.com`
2. `k8s-worker01.example.com`
3. `k8s-worker02.example.com`
4. `k8s-worker03.example.com`

Use kubeadm with containerd. Initialize the control plane, install the selected
CNI, join the workers, and verify that all nodes are Ready.

Bootstrap Argo CD once, then let Argo CD install:

- MetalLB
- ingress-nginx
- cert-manager
- Kyverno
- External Secrets Operator
- metrics-server
- Velero
- Longhorn
- OpenTelemetry Operator
- Trivy Operator

## 7. Build Observability

Build and connect:

1. `prometheus.example.com`
2. `alertmanager.example.com`
3. `grafana.example.com`
4. `loki.example.com`
5. `tempo.example.com`
6. `otel.example.com`

Every service and VM must expose or forward health and telemetry data. Test at
least one metric alert, one centralized log query, and one distributed trace.

## 8. Enable Governance

Deploy the governance repository to `governance.example.com`. Configure
read-only access to GitLab, local infrastructure inventories, Kubernetes,
observability APIs, and the approved AWS audit role.

Collect evidence for:

- Terraform/OpenTofu policy
- Kubernetes policy
- image and dependency scanning
- backup success and restore testing
- IAM and secret-management controls
- required tags and expiration
- certificate validity
- cost and resource inventory

## 8. Deferred: Enable AWS EKS/ECR

Do not execute this section during the on-premises build. In the later cloud
phase, build an AWX execution-environment image containing Terraform/OpenTofu, AWS CLI,
kubectl, Helm, Boto3, and the required Ansible collections.

Configure IAM Roles Anywhere and the following roles:

- `AWX-EKS-PlanRole`
- `AWX-EKS-ProvisionRole`
- `AWX-EKS-DestroyRole`
- `Jenkins-ECR-PushRole`
- `Governance-AuditRole`

The AWX workflow must validate, scan, plan, require approval, apply, bootstrap
Argo CD, run smoke tests, and collect evidence. Destruction is a separate
approved workflow.

## 9. On-Premises End-to-End Acceptance Test

1. Commit an application change to GitLab.
2. Jenkins runs tests, scans, and the SonarQube quality gate.
3. Jenkins publishes build output to Artifactory.
4. Jenkins builds and scans the container image.
5. Jenkins pushes the image to Harbor.
6. The GitOps repository receives the immutable image reference.
7. Argo CD deploys the change.
8. Prometheus, Loki, Tempo, and Grafana show the release.
9. Alertmanager receives a controlled test alert.
10. Governance automation stores evidence.
11. The rollback procedure restores the previous release.
