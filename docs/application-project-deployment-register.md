# Application Project Architecture and Linkage Register

Last verified: 2026-08-13

## Goal

Document each application as an independent project and show how its business,
delivery, runtime, data, security, observability and recovery contracts fit
together. Implementation and deployment are later activities and are not
authorized by this register.

This is not a plan for one repository or one shared release. A clinical
application, payer service, data product, AI workflow and platform component
keep separate source, ownership, versions, pipelines and rollback histories.
They become an enterprise system through versioned contracts and evidence
links between projects.

The machine-readable inventory is maintained in
[`application-projects.json`](application-projects.json). Its state values are
acceptance facts, not aspirations.

The [cross-project linkage blueprint](application-project-linkage-blueprint.md)
defines how independently owned application projects participate in one
enterprise workflow without becoming a monorepo or a shared release.
The [application-to-use-case coverage](application-usecase-coverage.md)
classifies all 224 detailed pages for each registered real application.

![Separate application projects connected by shared platform contracts](assets/application-project-deployment-model.svg)

## Keep the three inventories separate

Three kinds of things meet in this plan, but they are not interchangeable:

| Inventory | What it contains | Why it stays separate |
| --- | --- | --- |
| Application projects | Independently owned care, payer, data, AI or internal-service repositories that produce deployable releases. | A project has its own business outcome, release decision, dependencies and recovery history. |
| Platform implementation projects | The 20 repositories that provide shared delivery, runtime, data, security and operating capabilities. | A platform release changes a shared contract and must not be mistaken for an application release. |
| Runtime products | GitLab, Jenkins, AWX, Vault, Harbor, Kubernetes, PostgreSQL and the existing observability services documented in the current environment. | A running product is a deployment target or shared dependency; its presence does not prove that an application project is onboarded. |

This distinction prevents a common false-positive: a healthy Kubernetes cluster
and green platform pipeline do not mean that a claims application, clinical
service or data product has been deployed. The application project must still
produce its own release and operating evidence.

## Documentation unit

One row in this register represents one independently owned application
project. Its architecture is detailed enough for later implementation only
when it names:

- one accountable application or platform owner;
- one primary runtime target already present in the environment;
- an immutable source revision and independently versioned release;
- the platform use-case chain required before, during and after deployment;
- upstream and downstream project contracts;
- service identity, secrets, network and data boundaries;
- telemetry, SLO, incident ownership and a runbook;
- deployment, verification and recovery evidence; and
- a safe stop when the existing platform cannot satisfy the requirement.

Projects may consume the same platform capability, but one project's green
pipeline never proves another project is healthy.

## Reusable use-case chains

The chains below are references, not centrally executed mega-pipelines. Each
application project imports or calls the relevant shared contract and records
the exact revision it consumed.

| Chain | Required linked use cases | What the application project must prove |
| --- | --- | --- |
| Delivery spine | [UC-CICD-001](use-cases/devsecops/UC-CICD-001-end-to-end-cicd-pipeline.md), [UC-CICD-002](use-cases/devsecops/UC-CICD-002-automated-build-pipeline.md), [UC-CICD-003](use-cases/devsecops/UC-CICD-003-automated-unit-testing-in-ci.md), [UC-CICD-004](use-cases/devsecops/UC-CICD-004-code-quality-gate-integration.md), [UC-CICD-005](use-cases/devsecops/UC-CICD-005-artifact-management-automation.md), [UC-CICD-007](use-cases/devsecops/UC-CICD-007-environment-based-release-promotion.md), [UC-CICD-008](use-cases/devsecops/UC-CICD-008-automated-rollback-controller.md), [UC-CICD-010](use-cases/devsecops/UC-CICD-010-secure-ci-cd-pipeline-implementation.md) | A reviewed project revision becomes one identifiable artifact, moves through explicit gates and can return to its prior release. |
| Identity and secrets | [UC-GOV-002](use-cases/governance/UC-GOV-002-secrets-management-automation.md), [UC-GOV-003](use-cases/governance/UC-GOV-003-secure-secrets-management-for-applications.md), [UC-GOV-004](use-cases/governance/UC-GOV-004-cloud-iam-and-rbac-standardization.md), [UC-RSO-018](use-cases/resilience/UC-RSO-018-certificate-and-secret-expiry-response.md) | The project has its own principal, permitted actions, secret references, rotation owner and revocation path. |
| Network and service access | [UC-NET-005](use-cases/network/UC-NET-005-authoritative-and-recursive-dns.md), [UC-NET-020](use-cases/network/UC-NET-020-ingress-and-egress-controls.md), [UC-NET-024](use-cases/network/UC-NET-024-certificate-and-tls-routing.md), [UC-NET-028](use-cases/network/UC-NET-028-network-availability-testing.md) | The expected source, destination, identity, protocol, DNS and TLS path work; explicitly denied paths remain denied. |
| Operational readiness | [UC-RSO-001](use-cases/resilience/UC-RSO-001-operational-readiness-review.md), [UC-RSO-002](use-cases/resilience/UC-RSO-002-sli-and-slo-governance.md), [UC-RSO-005](use-cases/resilience/UC-RSO-005-on-call-and-escalation-workflows.md), [UC-RSO-009](use-cases/resilience/UC-RSO-009-service-ownership.md), [UC-RSO-010](use-cases/resilience/UC-RSO-010-dependency-mapping.md) | The deployed service has an owner, dependency map, SLO, escalation path, runbook and readiness decision. |
| Telemetry and release feedback | [UC-OBS-003](use-cases/observability/UC-OBS-003-opentelemetry-auto-instrumentation.md), [UC-OBS-004](use-cases/observability/UC-OBS-004-centralized-log-management.md), [UC-OBS-006](use-cases/observability/UC-OBS-006-alerting-and-on-call-notification.md), [UC-OBS-008](use-cases/observability/UC-OBS-008-deployment-health-scoring.md), [UC-OBS-014](use-cases/observability/UC-OBS-014-change-to-incident-correlation.md) | Metrics, logs and traces carry project and release identity; alerts route to the owner and can be traced back to the change. |
| Kubernetes workload | [UC-K8S-003](use-cases/kubernetes/UC-K8S-003-kubernetes-application-deployment.md), [UC-K8S-006](use-cases/kubernetes/UC-K8S-006-kubernetes-security-baseline-implementation.md), [UC-K8S-009](use-cases/kubernetes/UC-K8S-009-ingress-and-traffic-management-standardization.md), [UC-K8S-010](use-cases/kubernetes/UC-K8S-010-workload-right-sizing.md), [UC-K8S-011](use-cases/kubernetes/UC-K8S-011-container-registry-and-image-supply-chain-security.md) | The workload uses an owned namespace, trusted image, resource boundary, ClusterIP ingress pattern and verified rollback on the existing application cluster. |
| VM or native service | [UC-LNX-005](use-cases/linux/UC-LNX-005-awx-ansible-configuration-management.md), [UC-LNX-009](use-cases/linux/UC-LNX-009-systemd-service-management.md), [UC-LNX-012](use-cases/linux/UC-LNX-012-ssh-sudo-service-accounts.md), [UC-LNX-015](use-cases/linux/UC-LNX-015-configuration-drift-detection.md), [UC-LNX-019](use-cases/linux/UC-LNX-019-linux-monitoring-incident-operations.md) | The service is converged through reviewed AWX/Ansible source, runs with a bounded identity and exposes health, drift and recovery evidence. |
| Stateful application | [UC-DB-017](use-cases/database/UC-DB-017-application-database-onboarding.md), [UC-DB-012](use-cases/database/UC-DB-012-tls-and-credential-rotation.md), [UC-DB-008](use-cases/database/UC-DB-008-database-performance-monitoring.md), [UC-DB-005](use-cases/database/UC-DB-005-backup-and-point-in-time-recovery.md), [UC-RSO-017](use-cases/resilience/UC-RSO-017-rto-and-rpo-measurement.md) | Database identity, schema change, performance, backup, restore, RTO and RPO belong to the application release rather than an anonymous shared database. |
| Data-producing or consuming application | [UC-DATA-007](use-cases/data/UC-DATA-007-schema-registry-and-evolution.md), [UC-DATA-014](use-cases/data/UC-DATA-014-data-lineage.md), [UC-DATA-015](use-cases/data/UC-DATA-015-data-classification.md), [UC-DATA-018](use-cases/data/UC-DATA-018-pipeline-monitoring-and-alerting.md), [UC-DATA-021](use-cases/data/UC-DATA-021-data-reconciliation.md), [UC-DATA-023](use-cases/data/UC-DATA-023-data-access-governance.md) | Every dataset or event has a contract, classification, owner, lineage, quality signal, access decision and reconciliation rule. |
| AI or model-enabled application | [UC-AI-007](use-cases/healthcare-ai/UC-AI-007-ai-prompt-and-response-evaluation.md), [UC-AI-008](use-cases/healthcare-ai/UC-AI-008-responsible-ai-controls.md), [UC-AI-011](use-cases/healthcare-ai/UC-AI-011-ai-security-and-access-control.md), [UC-MLOPS-001](use-cases/mlops/UC-MLOPS-001-model-registry-versioning.md), [UC-MLOPS-004](use-cases/mlops/UC-MLOPS-004-model-validation-gates.md), [UC-MLOPS-008](use-cases/mlops/UC-MLOPS-008-model-observability.md), [UC-MLOPS-011](use-cases/mlops/UC-MLOPS-011-model-rollback.md) | The project binds the approved model, data and prompt revisions to evaluation, access, human review, monitoring and rollback evidence. |

## Known project register

These are the concrete projects already named by the enterprise architecture.
The `Required chains` column establishes the initial relationship among
projects; it does not claim the use cases are implemented.

| Project | Deployable responsibility | Primary target | Required chains | Current deployment state | Next acceptance boundary |
| --- | --- | --- | --- | --- | --- |
| `midhhealth/platform-delivery/devsecops-cicd-orchestrator` | Application build, scan and release orchestration | Existing GitLab runners and Jenkins | Delivery spine; Identity and secrets; Telemetry and release feedback | Active implementation | Prove one project release from immutable source through rollback evidence. |
| `midhhealth/platform-delivery/jenkins-jobs` | Versioned Jenkins Job DSL | `jenkins.example.com` | Delivery spine; VM or native service | Implemented source and active controller | Prove generated jobs, configuration convergence and job-level recovery. |
| `midhhealth/platform-delivery/jenkins-shared-library` | Reusable pipeline behavior | Jenkins controller and `jenkins-agent01` | Delivery spine; Operational readiness | Used by accepted Kubernetes delivery | Pin the library revision in every consuming project and record compatibility. |
| `midhhealth/platform-delivery/ansible-jenkins` | Jenkins controller and dedicated-agent desired state | Existing Jenkins controller and `jenkins-agent01` | VM or native service; Identity and secrets; Operational readiness | Dedicated Kubernetes deployer accepted | Keep controller and agent changes source-managed, bounded and independently recoverable. |
| `midhhealth/platform-delivery/ansible-awx` | AWX controller and execution-plane desired state | Existing AWX controller and `awx-execution.example.com` | VM or native service; Identity and secrets; Operational readiness | Execution plane accepted | Preserve the controller/runtime separation and exact offline dependency bundle. |
| `midhhealth/platform-engineering/cloud-infra-automation-platform` | Terraform plans and approved infrastructure automation | `gitlab-runner-infra01`, AWX and existing inventory | Delivery spine; Identity and secrets; VM or native service; Operational readiness | Active implementation; cloud execution deferred | Link every applied plan to owner, impact, target, evidence and recovery. |
| `midhhealth/platform-engineering/kubernetes-platform-gitops` | Kubernetes platform and application delivery contracts | Existing four-node application cluster | Delivery spine; Kubernetes workload; Network and service access; Operational readiness | Base cluster, ingress and Longhorn accepted; several planned add-ons absent | Onboard projects without claiming Argo CD or another uninstalled add-on. |
| `midhhealth/platform-engineering/ansible-kubernetes` | Kubernetes host prerequisites and reviewed cluster configuration | Existing control plane and three workers | VM or native service; Kubernetes workload; Operational readiness | Ingress and storage source revisions accepted | Keep host configuration in AWX/Ansible and application Helm releases in Jenkins. |
| `midhhealth/platform-engineering/awx-inventory` | Canonical product host groups consumed by AWX | Existing product inventory and synchronized source | VM or native service; Operational readiness | Production inventory synchronization accepted | Reject any playbook whose target group is absent or silently skipped. |
| `midhhealth/platform-engineering/linux-systems-platform` | Host lifecycle and desired state | Existing hypervisors and Rocky Linux VM inventory | Delivery spine; VM or native service; Operational readiness | Active first slices | Make every product service traceable to a role, inventory limit and recovery task. |
| `midhhealth/platform-engineering/network-engineering-platform` | DNS, TLS, ingress, egress and reachability contracts | Existing BIND, NGINX, KVM and Kubernetes paths | Network and service access; Operational readiness; Telemetry and release feedback | Active first slices | Give each project an owned service-path record with positive and denied-path evidence. |
| `midhhealth/reliability-operations/observability-sre-platform` | Project telemetry, SLOs, alerts and release health | Existing Prometheus, Grafana, Loki, Tempo, OpenTelemetry and Elastic services | Telemetry and release feedback; Operational readiness | Shared telemetry foundations accepted | Add project/release identity, dashboard, alert and SLO evidence per application. |
| `midhhealth/reliability-operations/resilience-service-operations` | Service catalog, dependency, incident and recovery records | Existing GitLab runner, Jenkins/AWX and evidence paths | Operational readiness; Telemetry and release feedback | Active first slices | Create one service record per deployed project and reject deployments without an owner. |
| `midhhealth/reliability-operations/ansible-observability` | Native logging, tracing and alerting installation | Existing observability VMs | VM or native service; Telemetry and release feedback | Elastic and correlated telemetry slices accepted | Link installed service revisions to consuming project telemetry contracts. |
| `midhhealth/reliability-operations/ansible-prometheus` | Prometheus, Grafana and host metrics installation | Existing Prometheus/Grafana VMs and managed hosts | VM or native service; Telemetry and release feedback | Host metrics and dashboard baseline accepted | Add service-level scrape and dashboard ownership for each application project. |
| `midhhealth/security-governance/cloud-governance-ops-automation` | Identity, secret, policy and compliance evidence | Existing GitLab validation, Vault and approved AWX paths | Identity and secrets; Operational readiness | Active implementation; Vault accepted | Issue project-scoped identities and evidence without introducing a shared superuser. |
| `midhhealth/data-and-integration/database-reliability-platform` | Database onboarding, migration, performance and recovery | Existing PostgreSQL 18 service and approved AWX path | Stateful application; Identity and secrets; Operational readiness | Active first slices | Create a separate database/service identity and restore proof for each stateful project. |
| `midhhealth/data-and-integration/data-engineering-platform` | Data contracts, quality, lineage and replay | Existing shared runner and approved existing data paths | Data-producing or consuming application; Operational readiness | Design and first-slice automation; no new data platform authorized | Link each producer and consumer project through immutable contracts and reconciliation evidence. |
| `midhhealth/ai-and-ml-platform/healthcare-ai-platform` | Healthcare AI application and workflow controls | Existing shared runner; approved edge development only | AI or model-enabled application; Data-producing or consuming application; Identity and secrets | Planned/offline evaluation boundary | Name a concrete AI application project before any runtime deployment. |
| `midhhealth/ai-and-ml-platform/mlops-model-platform` | Model lifecycle, validation, registry metadata and rollback | Existing shared runner; runtime promotion separately approved | AI or model-enabled application; Delivery spine; Operational readiness | Planned repository evidence boundary | Bind every model release to one consuming application and rollback decision. |

## Application portfolios that still need project names

The architecture names the application domains below but does not yet contain
their individual repositories. They are not deployable inventory until each
real project is registered.

| Portfolio | What is known | What is missing before deployment |
| --- | --- | --- |
| `midhhealth/care-delivery-platform` | Future hospital operations, clinical, patient-access and digital-care projects belong here. | Repository path, application name, owner, users, runtime, data classification, dependencies and acceptance outcome for each separate project. |
| `midhhealth/payer-operations-platform` | Future claims, eligibility, authorization, member-service and payment-integrity projects belong here. | Repository path, application name, owner, users, runtime, data classification, dependencies and acceptance outcome for each separate project. |

No placeholder application name should be invented merely to fill this table.
When a real project is identified, add one row to the register below and link
its real GitLab repository. Start its handoff from the
[application deployment record template](projects/application-deployment-record-template.md).

## Verified internal application suite

The local and GitHub repository audit found eight real MIDHTECH applications
that form a workforce and placement workflow. They are documented separately
in the [Workforce and Placement Application Suite](workforce-placement-application-suite.md)
because they are not clinical or payer systems. Their discovery does not close
the care-delivery or payer-operations inventory gaps.

These applications are at `discovered-detailed-page-pending`: repository,
revision, purpose and relationship evidence exist, but application-specific
architecture pages, exact interface contracts and runtime verification are
still required before they join the per-application documentation register.

## Per-application documentation register

| Application project | Business capability | Owner | Runtime | Required chains | Upstream/downstream projects | Release evidence | Recovery evidence | Status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| [`midhhealth/applications/podinfo`](projects/applications/podinfo.md) | Non-PHI reference workload documenting the shared application-delivery path | Platform Delivery team | Existing application Kubernetes cluster is the documented future target; planned `podinfo` namespace does not exist | Delivery spine; Identity and secrets; Network and service access; Operational readiness; Telemetry and release feedback; Kubernetes workload | Upstream Podinfo source; nine named platform projects in the project record | [Pinned source](evidence/APP-PODINFO-001-source-review.md), [historical internal CI](evidence/APP-PODINFO-002-internal-project-ci.md), [release-contract source](evidence/APP-PODINFO-003-release-contract-source.md), and [scope stop](evidence/APP-PODINFO-004-documentation-scope-stop.md); no runtime evidence | Documented stateless rollback design; no recovery execution | **Detailed and linked; not deployed** |

Podinfo is the first registered application project, but it does not fill the
care-delivery or payer-operations portfolios. Those remain inventory gaps until
their real repositories and owners are known.

## Documentation sequence

1. **Make project identity real.** Register every known application repository,
   owner, users and business outcome. Leave unknown projects as named gaps.
2. **Describe the application boundary.** Record the intended runtime, data
   classification, service identity and trust boundaries without creating them.
3. **Link independent projects.** Name each API, event, data and identity
   contract, its producer, consumer, owner, versioning rule and failure behavior.
4. **Map platform use cases.** Attach only the chains needed by that project and
   explain what each platform contributes to the enterprise outcome.
5. **Write the operating story.** Document SLO intent, telemetry correlation,
   incident ownership, degraded behavior, rollback and recovery expectations.
6. **Define future evidence.** State what a later implementation must prove,
   while keeping every execution and deployment gate pending.
7. **Review an enterprise workflow on paper.** Walk a provider or payer journey
   across the separate project records and resolve missing ownership or contracts.

## Completion rule

The documentation goal is complete only when:

- every real application project has one register row and no project is hidden
  behind a portfolio label;
- every required use-case chain is explained in the owning application record;
- every cross-project dependency names its producer, consumer, contract owner,
  versioning rule, failure behavior and future evidence;
- every service has a documented rollback or recovery path and decision owner;
- at least one provider workflow and one payer workflow can be traced on paper
  across the linked projects without an unnamed handoff; and
- documentation readiness, implementation status and runtime status are never
  collapsed into one misleading state.

Deployment, runtime testing and acceptance are explicitly outside this
documentation goal and require a later implementation decision.
