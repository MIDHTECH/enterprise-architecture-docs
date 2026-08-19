# CHG-2026-015: Retire `.apps.example.com` Compatibility Edge

## Change metadata

| Field | Value |
| --- | --- |
| Number | `CHG-2026-015` |
| Type | Controlled edge migration and retirement |
| State | Design recorded; implementation pending |
| Risk | High |
| Impact | Canonical product access must remain available while every legacy shared-proxy name is removed |
| Owner | Platform Engineering |

## Purpose and evidence

Retire the transitional `.apps.example.com` namespace and the standalone
`nginx.example.com` reverse-proxy service. Every accepted HTTP product must be
reached by its canonical `<product>.example.com` name through an NGINX frontend
on its own service VM or a product-embedded NGINX already accepted on that VM.

The authoritative zone still publishes 15 legacy records to
`192.168.1.114`. The shared proxy has 16 product server blocks because it also
retains an obsolete AWX route. GitLab and Harbor already have embedded local
frontends. AWX, Jenkins, and Headlamp already have accepted host-local
frontends. Vault, Grafana, MinIO, Loki, Tempo, and OpenTelemetry are reachable
and require local frontend reconciliation. Prometheus and Kibana are not
reachable by SSH at design time. Artifactory, SonarQube, and Splunk are not
installed. Placeholder or unreachable routes must be removed without claiming
or installing those products.

## Exact scope and sequence

1. Publish reviewed source and pass CI before runtime mutation.
2. Reconcile service-local NGINX only on reachable, installed services that do
   not already have an accepted local or embedded frontend.
3. Validate canonical DNS, local NGINX, backend privacy, firewall policy, and
   product health. A failing service stops the cutover.
4. Remove all `.apps.example.com` service records from BIND and all product
   server blocks from the standalone proxy.
5. Prove every legacy name is NXDOMAIN, revalidate all accepted canonical
   endpoints, then disable the standalone NGINX service. Retain the VM and
   reviewed rollback configuration; do not delete the VM.
6. Repeat APPLY and require zero changes before closure.

Unreachable or uninstalled VMs receive no package, service, or product change.
Their compatibility DNS and placeholder routes are removed because those
routes are not accepted product endpoints.

## Control path

- Canonical implementation source: `cloud-infra-automation-platform`.
- Source validation: repository layout, YAML/Ansible syntax, lint, and security
  CI on the reviewed branch and canonical main.
- Runtime mutation: Jenkins-controlled AWX jobs using the reviewed Git revision
  and the existing production inventory and machine credential.
- Direct workstation Ansible, package installation, SSH mutation, or manual
  NGINX/DNS editing is prohibited.

## Acceptance

1. Each installed service in scope answers through its canonical hostname on
   its own VM frontend; accepted existing endpoints remain healthy.
2. Backend HTTP ports are loopback-only or excluded from the public firewalld
   zone; only documented frontend services are admitted.
3. The authoritative DNS server returns no A or CNAME answer for any name below
   `.apps.example.com` and retains all canonical A records.
4. `nginx.example.com` has no product server block and its NGINX service is
   disabled and inactive. The VM is retained for controlled rollback.
5. Artifactory, SonarQube, and Splunk remain correctly reported as not
   installed; unreachable products are not promoted to accepted state.
6. Validation and the second APPLY report no failure; convergence APPLY reports
   zero changes.
7. Environment pages contain no active `.apps.example.com` endpoint.

## Rollback

Rollback is staged. Before DNS removal, restore or remove only the failing
service-local frontend through the reviewed AWX rollback path. After cutover,
re-enable the standalone NGINX service and restore the exact reviewed route and
DNS record set through AWX, then verify the prior legacy endpoints. Do not
delete VMs, alter product data, reinstall products, or expose backend ports.
