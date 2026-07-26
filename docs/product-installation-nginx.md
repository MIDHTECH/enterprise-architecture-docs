# NGINX Reverse-Proxy Cluster Installation

## Purpose

This runbook builds the shared HTTP application entry tier. Users access
product URLs without remembering backend ports, while VM management names
continue to resolve directly to each VM.

## Architecture

| Identity | Address | Placement | Purpose |
| --- | --- | --- | --- |
| `nginx01.example.com` | `192.168.1.114` | infra01 | Preferred NGINX/Keepalived member |
| `nginx02.example.com` | `192.168.1.132` | infra02 | Standby NGINX/Keepalived member |
| `proxy.example.com` | `192.168.1.140` | Floating | Unicast VRRP virtual IP |
| `*.apps.example.com` | `192.168.1.140` | DNS service records | User-facing application namespace |

The numbered names are permitted because the two NGINX VMs form a cluster.
The VIP has no VM, virtual disk, or dedicated NIC. Keepalived owns it on one
node at a time. NGINX configuration is identical on both nodes.

## URL and Backend Map

| User URL during HTTP bootstrap | Backend |
| --- | --- |
| `http://gitlab.apps.example.com` | `192.168.1.101:80` |
| `http://jenkins.apps.example.com` | `192.168.1.102:8080` |
| `http://awx.apps.example.com` | `192.168.1.103:30080` |
| `http://vault.apps.example.com` | `192.168.1.104:8200` |
| `http://keycloak.apps.example.com` | `192.168.1.105:8080` |
| `http://harbor.apps.example.com` | `192.168.1.122:80` |
| `http://artifactory.apps.example.com` | `192.168.1.123:8082` |
| `http://sonarqube.apps.example.com` | `192.168.1.124:9000` |
| `http://prometheus.apps.example.com` | `192.168.1.115:9090` |
| `http://alertmanager.apps.example.com` | `192.168.1.110:9093` |
| `http://grafana.apps.example.com` | `192.168.1.128:3000` |
| `http://minio.apps.example.com` | `192.168.1.112:9001` |
| `http://loki.apps.example.com` | `192.168.1.129:3100` |
| `http://tempo.apps.example.com` | `192.168.1.130:3200` |
| `http://otel.apps.example.com` | `192.168.1.131:4318` |

An endpoint may return `502 Bad Gateway` until its backend product is
installed. That is not an NGINX failure if `proxy.example.com/nginx-health`
passes and the backend port is closed.

PostgreSQL, DNS, SSH, Kubernetes API, OpenTelemetry gRPC, and other non-HTTP
protocols retain their native DNS names and ports. Do not put them through the
HTTP proxy merely to hide a port number.

## Prerequisites

1. Restore SSH reachability to both hypervisors.
2. Confirm `br0`, `lab-bridge`, `lab-images`, and the Rocky 9.8 base image are
   healthy on both hosts.
3. Confirm `.114`, `.132`, and `.140` are unused. Do not rely on ping alone;
   inspect router reservations, ARP, DNS, and libvirt inventories.
4. Confirm the Mac public key is available without copying its private key to
   either hypervisor.
5. Keep existing product DNS unchanged until the VIP and both proxy nodes pass.

## Provision the VMs

Copy the shared provisioner, the correct inventory, and the administrator
public key to each hypervisor:

```bash
scp workspace.training/scripts/provision-libvirt-vms.sh \
  workspace.training/libvirt/inventory/infra01-vms.csv \
  midhtechadmin@infra01.example.com:/tmp/
scp ~/.ssh/id_rsa.pub \
  midhtechadmin@infra01.example.com:/tmp/midhtechadmin.pub

scp workspace.training/scripts/provision-libvirt-vms.sh \
  workspace.training/libvirt/inventory/infra02-vms.csv \
  midhtechadmin@infra02.example.com:/tmp/
scp ~/.ssh/id_rsa.pub \
  midhtechadmin@infra02.example.com:/tmp/midhtechadmin.pub
```

Review the plans and create only the two approved domains:

```bash
ssh midhtechadmin@infra01.example.com \
  'INVENTORY=/tmp/infra01-vms.csv /tmp/provision-libvirt-vms.sh plan'
ssh midhtechadmin@infra01.example.com \
  'INVENTORY=/tmp/infra01-vms.csv /tmp/provision-libvirt-vms.sh create nginx01.example.com'

ssh midhtechadmin@infra02.example.com \
  'INVENTORY=/tmp/infra02-vms.csv /tmp/provision-libvirt-vms.sh plan'
ssh midhtechadmin@infra02.example.com \
  'INVENTORY=/tmp/infra02-vms.csv /tmp/provision-libvirt-vms.sh create nginx02.example.com'
```

The provisioner is idempotent at the libvirt-domain level and leaves an
existing domain unchanged.

## Apply the Rocky Baseline

Wait for cloud-init, then validate the FQDN, IP, guest agent, Chrony,
firewalld, SELinux enforcing mode, and `/data` disk on each VM. Apply the
existing Rocky baseline to one node at a time:

```bash
workspace.training/scripts/apply-rocky9-baseline.sh 192.168.1.114
workspace.training/scripts/apply-rocky9-baseline.sh 192.168.1.132
```

## Configure NGINX and Keepalived

The authoritative automation is:

```text
cloud-infra-automation-platform/ansible/playbooks/nginx-load-balancers.yml
cloud-infra-automation-platform/ansible/roles/nginx_load_balancer/
```

AWX is the normal controller after it is available. During the current
bootstrap, direct Ansible is permitted only as a recorded break-glass change
from infra02 using the forwarded Mac SSH agent:

```bash
cd cloud-infra-automation-platform/ansible
ansible-inventory -i inventory/onprem.yml --graph
ansible-playbook -i inventory/onprem.yml \
  playbooks/nginx-load-balancers.yml --syntax-check
ansible-playbook -i inventory/onprem.yml \
  playbooks/nginx-load-balancers.yml --check --diff
ansible-playbook -i inventory/onprem.yml \
  playbooks/nginx-load-balancers.yml
```

The role:

- enables the Rocky Linux NGINX 1.26 module stream
- installs NGINX 1.26.3 and Keepalived 2.2.8 package lines
- configures unicast VRRP across the two hypervisors
- opens HTTP, HTTPS, and VRRP in firewalld
- enables the required SELinux backend-connect boolean
- installs common WebSocket and forwarding headers
- exposes `/nginx-health`
- validates NGINX and Keepalived configuration before service acceptance

## Validate Before DNS Publication

Validate each node directly while supplying the future service host header:

```bash
curl --fail --header 'Host: proxy.example.com' \
  http://192.168.1.114/nginx-health
curl --fail --header 'Host: proxy.example.com' \
  http://192.168.1.132/nginx-health
```

Confirm only one node owns the VIP:

```bash
ssh midhtechadmin@192.168.1.114 'ip -4 address show dev eth0'
ssh midhtechadmin@192.168.1.132 'ip -4 address show dev eth0'
curl --fail --header 'Host: proxy.example.com' \
  http://192.168.1.140/nginx-health
```

Test a configured backend without publishing DNS:

```bash
curl --fail --resolve gitlab.apps.example.com:80:192.168.1.140 \
  http://gitlab.apps.example.com/
```

## Publish DNS

Only after both nodes, the VIP, and the GitLab test pass, apply the updated
BIND role:

```bash
cd cloud-infra-automation-platform/ansible
ansible-playbook -i inventory/onprem.yml playbooks/dns.yml --check --diff
ansible-playbook -i inventory/onprem.yml playbooks/dns.yml
```

The DNS change publishes:

- `nginx01.example.com = 192.168.1.114`
- `nginx02.example.com = 192.168.1.132`
- `proxy.example.com = 192.168.1.140`
- approved `*.apps.example.com` application records at `192.168.1.140`

It does not replace VM management records such as
`gitlab.example.com = 192.168.1.101`.

## Failover Acceptance Test

Run this only in an approved maintenance window:

1. Identify the current VIP owner.
2. Start a continuous request to
   `http://proxy.example.com/nginx-health`.
3. Stop Keepalived on the current owner.
4. Confirm `.140` moves to the peer and requests recover within the VRRP
   convergence interval.
5. Start Keepalived on the original owner.
6. Confirm both services are active and exactly one node owns the VIP.
7. Record timings and any failed requests in the SRE evidence.

Do not stop NGINX on both nodes. Do not test failover while GitLab imports,
artifact uploads, or product upgrades are running.

## Product-Specific Follow-up

Each backend must be configured with its public `*.apps.example.com` base URL
and trusted-proxy settings. GitLab, Jenkins, AWX, Keycloak, Harbor,
Artifactory, SonarQube, Grafana, and MinIO generate redirects or cookies from
that public URL; validate login, logout, WebSockets, uploads, callbacks, clone
URLs, registry pushes, and API clients after each product is enabled.

## TLS Phase

HTTP removes backend port numbers but is not the final security state. After
the internal CA is available:

1. Issue a certificate containing `*.apps.example.com` and
   `proxy.example.com`, or approved individual SANs.
2. Store the private key outside Git and deploy it through Vault/AWX.
3. Configure TLS 1.2/1.3 on both nodes.
4. Trust the CA on staff workstations and automation runners.
5. Validate every product over HTTPS.
6. Enable the HTTP-to-HTTPS redirect only after validation.

Do not use a wildcard certificate from a public CA for the internal
`example.com` training zone.

## Rollback

If proxy publication fails, restore the previous BIND zone from version
control and apply the DNS role. VM management records never change, so staff
can reach backends directly by `<product>.example.com:<port>` during rollback.
Stop Keepalived only if the VIP itself is producing network conflicts.
