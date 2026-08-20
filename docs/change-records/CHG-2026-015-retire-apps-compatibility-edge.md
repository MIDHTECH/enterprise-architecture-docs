# CHG-2026-015: Retire `.apps.example.com` Compatibility Edge

## Change metadata

| Field | Value |
| --- | --- |
| Number | `CHG-2026-015` |
| Type | Controlled edge migration and retirement |
| State | Closed successfully on 2026-08-20 |
| Risk | High |
| Impact | Canonical product access must remain available while every legacy shared-proxy name is removed |
| Owner | Platform Engineering |

## Purpose and evidence

Retire the transitional `.apps.example.com` namespace and the standalone
`nginx.example.com` reverse-proxy service. Every accepted HTTP product must be
reached by its canonical `<product>.example.com` name through an NGINX frontend
on its own service VM or a product-embedded NGINX already accepted on that VM.

At design time, the authoritative zone still published 15 legacy records to
`192.168.1.114`. The shared proxy had 16 product server blocks because it also
retained an obsolete AWX route. GitLab and Harbor already had embedded local
frontends. AWX, Jenkins, and Headlamp already had accepted host-local
frontends. Vault, Grafana, MinIO, Loki, Tempo, and OpenTelemetry required local
frontend reconciliation. Prometheus and Kibana were not reachable by SSH at
design time. Artifactory, SonarQube, and Splunk were not installed. The
implementation removed placeholder and unreachable routes without claiming or
installing those products.

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

## Implementation and correction history

The reviewed implementation merged to
`cloud-infra-automation-platform` main as `d0333fbb`; protected-main pipeline
725 passed. Jenkins build 8 stopped during AWX project update 1030 because the
project still selected SCM credential 6. No host task ran. The project was
corrected to the approved SCM credential 3 before retry.

Jenkins build 9/AWX job 1036 reached the service VMs and stopped on a transient
Loki HTTP 503 after partially reconciling local frontends. DNS and the shared
proxy were untouched. Merge request !10 added bounded health retries; branch
and main pipelines 726 and 727 passed. Jenkins build 10/AWX job 1046 then
stopped safely on Vault HTTP 503 while Vault was sealed/standby. Merge request
!11 accepted Vault's documented health-state responses without treating an
HTTP 503 as transport failure; pipelines 728 and 729 passed.

Jenkins build 11/AWX job 1056 completed the cutover. It reconciled the local
frontends, removed the compatibility DNS records, removed the standalone
proxy routes, disabled the standalone NGINX service, and closed its frontend
firewall services. Jenkins build 12/AWX job 1066 then found a source-only
validation defect: Tempo had no value for the optional retired-firewall-port
list. No runtime correction was required. Merge request !12 added the empty
default; pipelines 730 and 731 passed, producing canonical main revision
`eea40a7588e9959364abf22b69b700203bc1a4d6`.

Documentation pipeline 732 then failed because the current Vault health
downgrade had not yet been propagated into the generated implementation
sequence and the design-consistency expected-state map. The generated file and
validator contract were corrected together; the complete local documentation
validator passed with the same Python generation used by CI. This source-only
correction did not alter runtime state.

Jenkins build 13/AWX job 1076 passed mutation-disabled validation with zero
changes and zero failures on all 11 hosts. Jenkins build 14/AWX job 1086 then
passed the required convergence APPLY with zero changes and zero failures on
all 11 hosts. Build 14 is the accepted idempotence result.

## Runtime acceptance

Independent checks from the authoritative DNS host found no A or CNAME answer
for any retired compatibility name or the standalone shared-proxy hostname.
Canonical records remained exact for GitLab, Jenkins, AWX, Headlamp, Vault,
Prometheus, Alertmanager, MinIO, Kibana, Harbor, Grafana, Loki, Tempo, and
OpenTelemetry.

Canonical HTTP acceptance returned 200 for GitLab, Jenkins, AWX, Headlamp,
Prometheus readiness, Alertmanager readiness, Grafana health, MinIO live
health, Loki readiness, Tempo readiness, and Harbor HTTPS health. Kibana's
root returned its expected 302 and OpenTelemetry's receiver root returned its
expected 404. Vault's health endpoint returned HTTP 503 for its current
sealed/standby state; the local proxy transport is reachable, but healthy
unsealed Vault operation requires a separate change.

On the retained `.114` rollback VM, NGINX is inactive and disabled, no product
server blocks remain, and neither HTTP nor HTTPS is admitted by firewalld.
Alertmanager listens on `127.0.0.1:9093`. The inspected Vault, Prometheus, and
Grafana backend ports are not admitted by the public firewall policy. These
results satisfy the edge-retirement boundary without deleting the rollback VM
or installing any deferred product.
