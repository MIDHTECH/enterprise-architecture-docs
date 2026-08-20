# Retired Shared NGINX Compatibility Edge

Last verified: 2026-08-20

## Current state

CHG-2026-015 retired the standalone shared reverse proxy. The VM at
`192.168.1.114` remains in libvirt inventory only as a controlled rollback
asset. It is not an active endpoint:

- its management DNS record is absent;
- NGINX is disabled and inactive;
- no product server blocks remain;
- HTTP and HTTPS are absent from its public firewalld policy; and
- every former compatibility service name returns no authoritative A or CNAME
  answer.

Do not add products or routes to this VM. Do not use it as a shared frontend.
Do not delete it outside a separately reviewed decommissioning change.

## Accepted access model

Every installed HTTP product owns its frontend on the same VM as the product,
or uses an already accepted product-embedded frontend. Canonical DNS points
directly to that service VM.

| Canonical endpoint | Frontend boundary | Accepted response |
| --- | --- | --- |
| `http://gitlab.example.com` | GitLab product frontend | HTTP 200 sign-in page |
| `http://jenkins.example.com` | Jenkins VM NGINX to loopback backend | HTTP 200 login page |
| `http://awx.example.com` | AWX VM NGINX to local k3s service | HTTP 200 |
| `http://headlamp.example.com` | worker01-local NGINX to private ingress-nginx ClusterIP | HTTP 200 |
| `http://prometheus.example.com` | Prometheus VM NGINX | HTTP 200 readiness |
| `http://alertmanager.example.com` | Alertmanager VM NGINX to `127.0.0.1:9093` | HTTP 200 readiness |
| `http://grafana.example.com` | Grafana VM NGINX | HTTP 200 health |
| `http://minio.example.com` | MinIO VM NGINX | HTTP 200 live health |
| `http://loki.example.com` | Loki VM NGINX | HTTP 200 readiness |
| `http://tempo.example.com` | Tempo VM NGINX | HTTP 200 readiness |
| `http://otel.example.com` | OpenTelemetry VM NGINX | HTTP 404 at receiver root is expected |
| `http://kibana.example.com` | Kibana VM NGINX | HTTP 302 at root is expected |
| `http://vault.example.com` | Vault VM NGINX | Transport reachable; current sealed/standby health returns HTTP 503 |
| `https://harbor.example.com` | Harbor native HTTPS frontend | HTTP 200 health |

Artifactory, SonarQube, and Splunk are not installed and have no active user
URL. Keycloak requires revalidation before a user URL is accepted.

## Authoritative automation

The accepted implementation is in `cloud-infra-automation-platform`:

```text
ansible/playbooks/retire-apps-edge.yml
ansible/playbooks/retire-apps-edge-validate.yml
ansible/roles/local_http_frontend/
```

Run these playbooks only through the reviewed Jenkins-to-AWX control path. Do
not install or configure NGINX directly from a workstation. A repeated APPLY
must report zero changes before the boundary is accepted.

## Backend privacy

Backend listeners must remain loopback-only or excluded from the public
firewall boundary. Independent CHG-2026-015 acceptance confirmed loopback-only
Alertmanager and no public backend firewall admission for Vault, Prometheus,
or Grafana. Apply the same rule to every future product-local frontend.

## Controlled rollback

Rollback requires a reviewed source change and the AWX control path. Restore
the exact retained route and DNS set, re-enable NGINX and its bounded firewall
services, then validate the prior endpoints. Do not expose backend ports,
install missing products, alter product data, or delete VMs as part of an edge
rollback.

## Acceptance evidence

Jenkins build 11/AWX job 1056 completed the retirement. Jenkins build 13/AWX
job 1076 passed mutation-disabled validation with zero changes and failures on
all 11 hosts. Jenkins build 14/AWX job 1086 passed a zero-change convergence
APPLY on all 11 hosts. See
[CHG-2026-015](change-records/CHG-2026-015-retire-apps-compatibility-edge.md)
for the full correction and runtime record.
