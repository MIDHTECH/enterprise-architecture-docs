# Standalone NGINX Reverse-Proxy Installation

## Scope

The lab does not implement high availability. One standalone Rocky Linux VM
provides friendly HTTP application URLs:

Implementation status as of 2026-07-31: installed and retained as a temporary
migration dependency. The approved target is one local NGINX instance on each
product VM with the canonical `<product>.example.com` URL. AWX and Jenkins are
migrated; all remaining routes stay here until their own sequential acceptance
closes.

| Identity | Address | Placement | Purpose |
| --- | --- | --- | --- |
| `nginx.example.com` | `192.168.1.114` | infra01 | NGINX reverse proxy |
| remaining `*.apps.example.com` records | `192.168.1.114` | DNS service records | Temporary user-facing routes for products not yet migrated |

There is no second NGINX VM, Keepalived, VRRP, or floating VIP. Address
`.132` and `.140` remain available for future expansion.

## URL and Backend Map

| HTTP URL | Backend | Current result |
| --- | --- | --- |
| `http://gitlab.apps.example.com` | `192.168.1.101:80` | Active |
| `http://jenkins.example.com` | local NGINX on `192.168.1.102:80` → `127.0.0.1:8080` | Migrated and accepted; `.apps` DNS and shared route removed |
| `http://awx.example.com` | local NGINX on `192.168.1.103:80` → `127.0.0.1:32000` | Migrated and accepted; `awx.apps.example.com` removed |
| `http://headlamp.apps.example.com` | `192.168.1.107:30080` | Active |
| `http://prometheus.apps.example.com` | `192.168.1.115:9090` | Active |
| `http://alertmanager.apps.example.com` | `192.168.1.110:9093` | Active |
| `http://grafana.apps.example.com` | `192.168.1.128:3000` | Active |
| `http://minio.apps.example.com` | `192.168.1.112:9000` | Active S3 API |
| `http://loki.apps.example.com` | `192.168.1.129:3100` | Active HTTP API |
| `http://tempo.apps.example.com` | `192.168.1.130:3200` | Active HTTP API |
| `http://otel.apps.example.com` | `192.168.1.131:4318` | Active HTTP receiver |
| `http://kibana.apps.example.com` | `192.168.1.117:5601` | Active |
| `http://vault.apps.example.com` | `https://192.168.1.104:8200` | Active; verified backend TLS |
| `http://keycloak.apps.example.com` | No backend | Intentional 503 |
| `http://harbor.apps.example.com` | No backend | Intentional 503 |
| `http://artifactory.apps.example.com` | No backend | Intentional 503 |
| `http://sonarqube.apps.example.com` | No backend | Intentional 503 |
| `http://splunk.apps.example.com` | No backend | Intentional 503 |

The proxy root returns a JSON catalog of active and unavailable routes.
Uninstalled products deliberately return HTTP 503 with
`product-not-installed`; they do not produce an ambiguous backend 502.

PostgreSQL, DNS, SSH, Kubernetes API, OpenTelemetry gRPC, and other non-HTTP
protocols keep their native names and ports. Elasticsearch ports 9200/9300,
Logstash 5044, and Splunk management/ingest ports 8089/8088/9997 remain
restricted native endpoints. Only Kibana and the Splunk web UI are proxied.

Do not remove the shared `nginx.example.com` VM or its remaining DNS records
as a bulk change. For each product: validate its backend, install and accept
local NGINX, move the canonical DNS record, prove a second zero-change run,
remove only that product's `.apps` record, document rollback, and then advance
to the next product. Retire the shared VM only after a dependency audit finds
zero consumers.

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
INVENTORY=workspace.training/libvirt/inventory/infra01-vms.csv \
  workspace.training/scripts/apply-rocky9-baseline.sh nginx.example.com
```

## Configure NGINX

Authoritative automation:

```text
cloud-infra-automation-platform/ansible/playbooks/nginx-reverse-proxy.yml
cloud-infra-automation-platform/ansible/roles/nginx_reverse_proxy/
cloud-infra-automation-platform/ansible/roles/nginx_backend_firewall/
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

The accepted AWX objects are project 23
`cloud-infra-automation-platform`, inventory 2
`production`, and job template 26
`deploy-nginx-reverse-proxy`. The template has a fixed
`nginx.example.com` limit and uses the existing managed-host SSH credential.
Inventory 4, `cloud-infra-production`, is reserved for the three physical KVM
hosts and must not be used for this product playbook.

The roles install the Rocky NGINX 1.26 package stream, configure application
virtual hosts and forwarding headers, permit HTTP/HTTPS in firewalld, enable
the SELinux backend-connect boolean, record the installed package version,
and expose `/nginx-health`. Firewall rules are reconciled only when firewalld
is active; the role does not silently start a stopped host firewall.
Validated configuration changes are activated before later host-policy tasks,
so a subsequent task failure cannot strand a written but unloaded NGINX
configuration. Restricted observability backends receive
persistent firewalld rich rules allowing only source `192.168.1.114`.

Installed package lock:

```text
nginx=1.26.3-9.module+el9.8.0+40235+8be1317a.2
```

## Validate Before Publishing DNS

```bash
curl --fail --header 'Host: nginx.example.com' \
  http://192.168.1.114/nginx-health

curl --fail --resolve gitlab.apps.example.com:80:192.168.1.114 \
  http://gitlab.apps.example.com/
```

Do not publish the application records unless both checks pass.

Initial acceptance evidence:

- first Ansible run: `ok=17`, `changed=9`, `failed=0`, `unreachable=0`
- second Ansible run: `ok=12`, `changed=0`, `failed=0`, `unreachable=0`
- `nginx -t`: successful
- NGINX service: enabled and active
- firewalld: HTTP and HTTPS enabled
- SELinux: enforcing with `httpd_can_network_connect --> on`
- `/data`: XFS mounted from `/dev/vdb`
- direct NGINX health: HTTP 200 with body `ok`
- GitLab proxy: HTTP 302 to the expected sign-in URL

Reconciliation evidence from 2026-07-28:

- DNS and NGINX Ansible runs: zero failed and zero unreachable
- AWX route: HTTP 200 through backend port `32000`
- Headlamp route and new DNS record: HTTP 200
- Prometheus, Grafana, GitLab, Jenkins, and Kibana routes: expected
  application status or redirect
- Alertmanager `/-/healthy`: HTTP 200
- MinIO `/minio/health/live`: HTTP 200
- Loki `/ready`: HTTP 200
- Tempo `/ready`: HTTP 200
- unavailable product routes: intentional HTTP 503

Vault route acceptance evidence from 2026-07-29:

- GitLab pipelines 342, 343, and 344 passed the automatic validation, lint,
  and security gates for the route and corrective automation;
- AWX job 407 exposed inactive-firewalld handling and stopped before reload;
- AWX job 412 proved the firewall guard but revealed the prior written
  configuration had not been loaded;
- AWX job 417 activated revision `bc8481a` and restarted NGINX after syntax
  validation;
- AWX job 421 was the accepted second convergence:
  `ok=14`, `changed=0`, `unreachable=0`, `failed=0`, `skipped=5`;
- `vault.apps.example.com/v1/sys/health` returned HTTP 200 with
  `initialized=true`, `sealed=false`, and `standby=false`;
- the root catalog lists 13 active routes and five intentional unavailable
  routes; all active routes returned expected non-5xx application behavior.

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

The first and second BIND runs completed with `failed=0`; the second run
reported `changed=0`. Authoritative forward records for all approved
application names return `.114`, reverse lookup for `.114` returns
`nginx.example.com`, and the Mac supplemental resolver resolves both the VM and
application names.

At the 2026-07-28 reconciliation, all active routes reached their backends.
Unavailable product names remain published so the operator receives a clear
503 state until the corresponding installation runbook is accepted.

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
