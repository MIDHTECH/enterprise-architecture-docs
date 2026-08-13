# CHG-2026-002 Jenkins Portless Access Acceptance

Date: 2026-08-01

## Architecture and scope

Jenkins remains on its established controller backend at
`http://127.0.0.1:8080`. A controller-local NGINX instance publishes the
canonical `http://jenkins.example.com` endpoint on port 80 and forwards HTTP
and WebSocket upgrade traffic to that backend. The change targeted exactly
one controller, one agent, one DNS server, and the shared proxy only to remove
the retired Jenkins route. No ingress, storage, runner, or product deployment
started.

## Source and CI evidence

- AWX inventory commit `f19c57925f2d1affbedff4c5dbef9c9b47d8e22e`
  added the exact one-host `jenkins_servers` scope. Branch pipeline 387 and
  main pipeline 391 passed.
- Jenkins automation commits `cb9fc7383f681a7e890848dd20a681ca2c3783fa`
  and `15d61a61d19f5886f24e96ee0e940ffc7534f24a` added the local proxy,
  moved the agent default to the portless URL, and established the firewall
  prerequisite. Branch pipelines 389/394 and main pipelines 392/395 passed;
  protected controller-deploy jobs remained manual.
- Cloud commits `19f5fee0df09b8c078ca93fdff4bb448ce2a4df6` and
  `331b928a14bd7ef5d24912c655cbb64a2d143889` retired the Jenkins `.apps`
  DNS record and shared NGINX route. Branch pipelines 397/399 and main
  pipelines 398/400 passed every automatic Terraform, layout, Ansible, and
  IaC gate; all apply/bootstrap/plan/smoke jobs remained manual.

## AWX deployment and idempotence

- Inventory update 546 produced exactly one `jenkins_servers` group and host.
- Project update 549 selected `cb9fc738`; template 30 was created with
  inventory 2, project 28, execution environment 1, and machine credential 1.
- Initial proxy job 550 stopped at `ok=11 changed=4 failed=1` when it found
  firewalld inactive. INC-2026-067 records the source correction; no direct
  workaround was used.
- Project update 555 selected corrected revision `15d61a6`. Proxy job 556
  succeeded at `ok=23 changed=5 failed=0`; job 561 converged at
  `ok=21 changed=0 failed=0`.
- Agent job 566 changed the unit and restarted it at
  `ok=18 changed=2 failed=0`; job 571 converged at
  `ok=17 changed=0 failed=0`.
- Cloud project update 576 selected `19f5fee`. DNS job 577 retired the record
  at `ok=15 changed=3 failed=0`; job 582 converged at
  `ok=14 changed=0 failed=0`.
- Cloud project update 587 selected `331b928`. Shared-proxy job 588 removed
  the Jenkins route at `ok=15 changed=2 failed=0`; job 593 converged at
  `ok=14 changed=0 failed=0`.

## Runtime acceptance

- Authoritative DNS and Kubernetes CoreDNS return
  `jenkins.example.com -> 192.168.1.102` and NXDOMAIN for
  `jenkins.apps.example.com`.
- An infra01 client received HTTP 200 from
  `http://jenkins.example.com/login` at `192.168.1.102:80` without an
  explicit-port redirect.
- NGINX and Jenkins are active; NGINX is enabled, its configuration test
  passes, and runtime/permanent firewalld policy contains `80/tcp`.
- `jenkins-agent01` is online with one executor and labels
  `kubernetes-deployer` and `jenkins-agent01`. Its service unit uses exactly
  `http://jenkins.example.com`, and the service log reports `Connected`.
- The shared NGINX catalog has 12 remaining active routes, reports no Jenkins
  `.apps` route, and the live configuration contains no
  `server_name jenkins.apps.example.com` stanza.

## Rollback

Rollback remains source-controlled: revert the relevant Jenkins and cloud
commits, require branch/main CI, synchronize the exact revisions in AWX, and
run the same scoped templates twice. The Jenkins port-8080 backend remained
healthy throughout, so a proxy rollback does not require controller data or
plugin restoration. DNS serials must always advance during any DNS rollback.
No secret, password, deploy key, agent secret, or kubeconfig content is
recorded in this evidence.
