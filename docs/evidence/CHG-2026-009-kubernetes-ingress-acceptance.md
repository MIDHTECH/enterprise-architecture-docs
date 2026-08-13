# CHG-2026-009 Kubernetes Ingress Acceptance

Date: 2026-08-03

## Accepted result

The application Kubernetes cluster now runs one ingress-nginx controller
behind NGINX installed locally on `k8s-worker01.example.com`. The only LAN
frontend for Headlamp is `http://headlamp.example.com` on TCP 80. Neither
Headlamp nor ingress-nginx exposes a NodePort, hostPort, or backend host port.

```text
headlamp.example.com -> 192.168.1.108:80 (worker01-local NGINX)
                    -> ingress-nginx-controller.ingress-nginx.svc:80
                    -> headlamp/headlamp ClusterIP:80
```

The shared `nginx.example.com` service remains available for its other managed
routes, but it has no Headlamp server block. The retired
`headlamp.apps.example.com` name returns NXDOMAIN.

## Controlled delivery evidence

| Gate | Jenkins evidence | AWX or Helm evidence | Result |
| --- | --- | --- | --- |
| Corrected PLAN | `projects/deploy-kubernetes-ingress` build 3 | Kubernetes `d206ab3f`; shared library `e9790766` | Passed; rendered ClusterIP-only controller Service and `headlamp.example.com` Ingress |
| Transitional DNS | `projects/configure-headlamp-edge` build 2 | AWX job 760 | Passed; serial `2026080301` |
| Worker-local NGINX | Edge build 3 | AWX job 772 | Passed; TCP 80 only, SELinux enforcing, `httpd_can_network_connect=on` |
| Initial deploy | Ingress build 4 | Helm revision 1 | Passed |
| Deploy convergence | Ingress build 5 | Helm revision 2 | Passed without controller replacement or value drift |
| Rollback proof | Ingress build 6 | Helm revision 3, rollback to revision 1 | Passed; canonical and retained rollback URLs returned HTTP 200 |
| Restore | Ingress build 7 | Helm revision 4 | Passed from accepted source |
| Final DNS | Edge build 4 | AWX job 782 | Passed; serial `2026080302`, legacy name removed |
| Shared-route retirement | Edge build 5 | AWX job 792 | Passed; Headlamp server block absent while shared proxy stayed active |
| ClusterIP cutover | Edge build 6 | AWX job 802 | Passed; NodePort and four firewall admissions removed |
| Cutover idempotence | Edge build 7 | AWX job 812 | Passed; recap `changed: {}`, no dark hosts, no failures |

All Jenkins mutation jobs ran on the exclusive `kubernetes-deployer` agent.
AWX synchronized the exact accepted source before each bounded Ansible action.
Helm planning, deploy, rollback, and restore stayed in the reviewed Jenkins
job; no workstation Helm or direct `kubectl apply` was used.

## Runtime acceptance

- Four of four Kubernetes nodes reported Ready; zero failed, pending, unknown,
  error, or CrashLoopBackOff pods were present.
- `IngressClass/nginx` reports controller `k8s.io/ingress-nginx`.
- `ingress-nginx-controller` is 1/1 Ready with zero restarts. Its Service is
  ClusterIP `10.110.15.196`, with no NodePort.
- `headlamp/headlamp` is ClusterIP `10.107.224.145`, with no NodePort.
- `headlamp/headlamp` Ingress uses class `nginx`, host
  `headlamp.example.com`, and controller address `10.110.15.196`.
- Canonical HTTP returned 200 through worker01-local NGINX. A direct-IP request
  received an empty response from the managed default server.
- TCP 30080, 30081, and 30444 had no listener on the control plane or any of
  the three workers. Firewalld reported TCP 30080 absent on all four nodes.
- Authoritative DNS serial is `2026080302`;
  `headlamp.example.com -> 192.168.1.108`;
  `headlamp.apps.example.com` is NXDOMAIN.
- The shared proxy's rendered NGINX configuration contains no
  `headlamp.apps.example.com`. A forced request reaches only the shared health
  response and not Headlamp.
- Jenkins ended with zero queued or running builds. AWX ended with zero active
  unified jobs.

The Headlamp application pod reports one historical restart from
2026-07-29, before this change. It is Running and Ready; the ingress controller
created by this change has zero restarts.

## Incident closure

- INC-2026-078 is resolved by the corrected ClusterIP-only design,
  worker01-local NGINX, canonical hostname, and negative backend-port checks.
- INC-2026-082 is resolved after existing AWX machine credential 1 retained
  its name and machine type and was assigned to organization 1 through the AWX
  administrative API. Subsequent Jenkins stages attached it successfully.

