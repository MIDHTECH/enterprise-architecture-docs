# Standalone NGINX Reverse-Proxy Installation

## Scope

The lab does not implement high availability. One standalone Rocky Linux VM
provides friendly HTTP application URLs:

| Identity | Address | Placement | Purpose |
| --- | --- | --- | --- |
| `nginx.example.com` | `192.168.1.114` | infra01 | NGINX reverse proxy |
| `*.apps.example.com` | `192.168.1.114` | DNS service records | User-facing application URLs |

There is no second NGINX VM, Keepalived, VRRP, or floating VIP. Address
`.132` and `.140` remain available for future expansion.

## URL and Backend Map

| HTTP bootstrap URL | Backend |
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

An endpoint may return `502 Bad Gateway` until its backend is installed. That
does not indicate an NGINX installation failure if `/nginx-health` passes and
the backend port is closed.

PostgreSQL, DNS, SSH, Kubernetes API, OpenTelemetry gRPC, and other non-HTTP
protocols keep their native names and ports.

## Provision the VM

Confirm `.114` is unused in router reservations, ARP, DNS, and libvirt. Copy
the approved inventory, provisioner, and administrator public key:

```bash
scp workspace.training/scripts/provision-libvirt-vms.sh \
  workspace.training/libvirt/inventory/infra01-vms.csv \
  midhtechadmin@infra01.example.com:/tmp/
scp ~/.ssh/id_rsa.pub \
  midhtechadmin@infra01.example.com:/tmp/midhtechadmin.pub
```

Review and create only the standalone NGINX domain:

```bash
ssh midhtechadmin@infra01.example.com \
  'INVENTORY=/tmp/infra01-vms.csv /tmp/provision-libvirt-vms.sh plan'
ssh midhtechadmin@infra01.example.com \
  'INVENTORY=/tmp/infra01-vms.csv /tmp/provision-libvirt-vms.sh create nginx.example.com'
```

The provisioner leaves an existing domain unchanged.

## Apply the Rocky Baseline

Wait for cloud-init and validate the FQDN, `.114` address, guest agent,
Chrony, firewalld, SELinux enforcing mode, and disks:

```bash
ssh midhtechadmin@192.168.1.114 \
  'sudo cloud-init status --wait; hostname -f; ip -4 -br address show eth0'
workspace.training/scripts/apply-rocky9-baseline.sh 192.168.1.114
```

## Configure NGINX

Authoritative automation:

```text
cloud-infra-automation-platform/ansible/playbooks/nginx-reverse-proxy.yml
cloud-infra-automation-platform/ansible/roles/nginx_reverse_proxy/
```

AWX is the normal controller after it is available. During bootstrap, direct
Ansible from infra02 through the forwarded Mac SSH agent is a recorded
break-glass action:

```bash
cd cloud-infra-automation-platform/ansible
ansible-inventory -i inventory/onprem.yml --graph
ansible-playbook -i inventory/onprem.yml \
  playbooks/nginx-reverse-proxy.yml --syntax-check
ansible-playbook -i inventory/onprem.yml \
  playbooks/nginx-reverse-proxy.yml --check --diff
ansible-playbook -i inventory/onprem.yml \
  playbooks/nginx-reverse-proxy.yml
```

The role installs the Rocky NGINX 1.26 package stream, configures application
virtual hosts and forwarding headers, permits HTTP/HTTPS in firewalld, enables
the SELinux backend-connect boolean, records the installed package version,
and exposes `/nginx-health`.

## Validate Before Publishing DNS

```bash
curl --fail --header 'Host: nginx.example.com' \
  http://192.168.1.114/nginx-health

curl --fail --resolve gitlab.apps.example.com:80:192.168.1.114 \
  http://gitlab.apps.example.com/
```

Do not publish the application records unless both checks pass.

## Publish DNS

Apply the version-controlled DNS role only after NGINX validation:

```bash
cd cloud-infra-automation-platform/ansible
ansible-playbook -i inventory/onprem.yml playbooks/dns.yml --check --diff
ansible-playbook -i inventory/onprem.yml playbooks/dns.yml
```

The change publishes:

- `nginx.example.com = 192.168.1.114`
- approved `*.apps.example.com = 192.168.1.114`

VM management records such as `gitlab.example.com = 192.168.1.101` remain
unchanged.

## Product Follow-up

Configure each backend with its `*.apps.example.com` public base URL and
trusted-proxy settings. Validate redirects, cookies, login/logout, WebSockets,
uploads, callback URLs, Git clone URLs, registry operations, and API clients
when each product becomes available.

## TLS Phase

HTTP removes backend port numbers but is not the final security state. After
the internal CA is available:

1. Issue an approved certificate for `*.apps.example.com`.
2. Store its private key outside Git and deploy it through Vault/AWX.
3. Configure TLS 1.2/1.3 in NGINX.
4. Trust the CA on clients and runners.
5. Validate every product over HTTPS.
6. Enable HTTP-to-HTTPS redirection only after acceptance.

## Backup and Recovery

Because the lab intentionally has no HA, `nginx.example.com` is a single point
of access. Store its configuration in Git, back up certificates separately,
and retain the VM definition in the canonical inventory. If it fails, users
can temporarily reach backends through their direct management names and
ports while the NGINX VM is rebuilt from automation.
