# Enterprise, Platform, and Use-Case Traceability

Last verified: 2026-08-13

This register keeps the portfolio aligned from enterprise outcomes down to
implementable engineering work. The canonical list and count of all 226 use
cases remains in
[Enterprise Project Portfolio and Use Case Coverage](../enterprise-project-portfolio-and-usecases.md).
Detailed pages add execution depth; they do not create a separate backlog.

The [Application Project Architecture and Linkage Register](../application-project-deployment-register.md)
connects those platform capabilities to independently owned application
projects. It deliberately keeps application repositories, platform
implementation repositories and running platform products as three separate
inventories so that platform readiness is never reported as application
deployment.

The [Application-to-Use-Case Coverage](../application-usecase-coverage.md)
classifies all 226 detailed pages for every registered application as directly
required, platform-managed, conditional, or not applicable to that verified
application shape.

The [Platform and Use-Case Learning Enhancement Plan](../platform-usecase-learning-enhancement-plan.md)
sequences interview-driven improvements without changing this operating goal:
independent application projects consume accepted platform contracts, and all
platform contracts remain traceable to the integrated enterprise.

## Enterprise capability model

MidhHealth is an integrated provider-payer organization. Every platform must
support at least one enterprise value stream and every use case must improve a
measurable platform responsibility within that value stream.

| Enterprise capability | Required platform contribution |
| --- | --- |
| Provider operations | Keep hospital, clinical, digital-care, patient-access, and care-operation services available, secure, observable, and recoverable. |
| Payer operations | Support claims, eligibility, authorization, member-service, payment-integrity, and analytical workflows with governed delivery and data movement. |
| Shared digital platform | Provide reusable infrastructure, delivery, Kubernetes, Linux, database, network, data, AI, and model-lifecycle capabilities instead of application-specific snowflakes. |
| Risk and compliance | Enforce least privilege, change review, audit evidence, protected-data boundaries, retention, rollback, and incident accountability. |
| Operational resilience | Detect degradation, identify ownership and dependencies, restore service safely, and measure recovery against SLO, RTO, and RPO targets. |

## Platform fit register

| Platform | Canonical backlog | Enterprise fit | Flagship detailed page |
| --- | ---: | --- | --- |
| DevSecOps delivery | 16 | Converts reviewed provider, payer, and shared-service source into traceable releases with security, cross-project compatibility and rollback gates. | [UC-CICD-001](devsecops/UC-CICD-001-end-to-end-cicd-pipeline.md) |
| Multi-cloud infrastructure | 12 | Governs the existing on-prem source and state while exposing drift, ownership, and change impact; cloud execution remains deferred. | [UC-INFRA-001](infrastructure/UC-INFRA-001-terraform-drift-detection.md) |
| Kubernetes with GitOps | 13 | Provides a reconciled workload platform for care, payer, data, and AI services with bounded tenancy and recovery. | [UC-K8S-001](kubernetes/UC-K8S-001-kubernetes-configuration-drift.md) |
| Observability and SRE | 16 | Turns service telemetry into SLO evidence, actionable alerts, incident context, and release feedback. | [UC-OBS-001](observability/UC-OBS-001-slo-as-code.md) |
| Governance and operations | 19 | Applies identity, secret, policy, compliance, and approved-remediation controls to the existing lab through current GitLab and AWX execution paths. | [UC-GOV-001](governance/UC-GOV-001-compliance-evidence-collection.md) |
| Linux systems engineering | 24 | Maintains the secure, repeatable operating-system foundation beneath on-prem and hybrid enterprise services. | [Linux detailed index](linux/README.md) |
| Database reliability | 19 | Protects transactional and operational data through controlled lifecycle, performance, security, backup, and recovery practices. | [UC-DB-001](database/UC-DB-001-backup-restore-validation.md) |
| Resilience and service operations | 21 | Connects service ownership, SLOs, dependency containment, incidents, exercises, and recovery into an operational readiness model. | [UC-RSO-001](resilience/UC-RSO-001-operational-readiness-review.md) |
| Data engineering and integration | 25 | Moves provider and payer data through governed, observable, quality-controlled products with lineage and replay. | [UC-DATA-001](data/UC-DATA-001-healthcare-feed-quality.md) |
| Network engineering and automation | 31 | Maintains the trusted connectivity, naming, segmentation, ingress, egress, and diagnostic paths used by every enterprise workflow. | [UC-NET-001](network/UC-NET-001-network-change-validation.md) |
| Healthcare AI | 15 | Adds constrained, cited, human-reviewed knowledge retrieval over approved repository content using existing GitLab CI capacity. | [UC-AI-001](healthcare-ai/UC-AI-001-retrieval-augmented-generation.md) |
| MLOps model platform | 15 | Makes model artifacts reproducible and governable with repository metadata and existing GitLab artifacts before any serving platform is approved. | [UC-MLOPS-001](mlops/UC-MLOPS-001-model-registry-versioning.md) |
| **Total** | **226** | The 12 platforms collectively cover delivery, runtime, data, intelligence, governance, and recovery for the integrated enterprise. | — |

## Fit rules for every use case

A proposed use case belongs in the portfolio only when all of these statements
are true:

1. It has exactly one primary platform owner and may name supporting platforms.
2. Its trigger, target, action, evidence, safety boundary, and rollback or safe
   stop are specific enough to automate or rehearse.
3. It advances a provider, payer, shared-platform, compliance, or resilience
   outcome named above.
4. It does not claim a product, environment, repository, integration, or runtime
   result that has not been verified.
5. It produces reusable platform capability or evidence rather than a one-off
   technology demonstration.
6. Cross-platform dependencies are explicit, but accountability remains with
   the primary platform.

## Existing-lab execution boundary

These pages are designed to be copied into the corresponding private GitLab
repositories and implemented through the lab's existing GitLab, three accepted
GitLab runners, Jenkins, AWX, application Kubernetes cluster, observability
services, PostgreSQL service, DNS, NGINX, and VM fleet.

- Do not add a VM, IP address, physical host, cloud account, Kubernetes
  cluster, or storage system from a use-case page.
- Do not report Argo CD or another absent Kubernetes add-on as installed.
- Do not treat a provisioned-only product VM as an installed product.
- Prefer read-only evidence collection and repository artifacts for the first
  slice.
- A required new product or capacity change must stop at a documented approval
  gate and be handled through a separate architecture and change record.
- Cloud execution, protected healthcare data, and production integration are
  out of scope until separately authorized.

## GitLab implementation handoff

The architecture repository defines scope and acceptance. Implementation code
belongs in the platform repository named below. Copy the relevant detailed
page into the GitLab issue or epic, implement the planned paths there, and send
the resulting commit, pipeline, Jenkins, AWX, and runtime evidence back to this
repository.

| Platform | GitLab implementation repository | First existing-lab artifact |
| --- | --- | --- |
| DevSecOps delivery | `midhhealth/platform-delivery/jenkins-jobs` and `midhhealth/platform-delivery/jenkins-shared-library` | Controlled job and shared-library source |
| Multi-cloud infrastructure | `midhhealth/platform-engineering/cloud-infra-automation-platform` | Read-only Terraform drift target map and CI job |
| Kubernetes with GitOps | `midhhealth/platform-engineering/kubernetes-platform-gitops` | Application-cluster identity guard and read-only drift report |
| Observability and SRE | `midhhealth/reliability-operations/observability-sre-platform` plus the existing Ansible observability repositories | SLO definition, rule fixtures, and generated rule source |
| Governance and operations | `midhhealth/security-governance/cloud-governance-ops-automation` | Control map and sanitized evidence manifest |
| Linux systems engineering | `midhhealth/platform-engineering/linux-systems-platform` | Existing IaC stories, playbooks, and evidence reports |
| Database reliability | `midhhealth/data-and-integration/database-reliability-platform` | Backup target map and guarded restore-validation playbook |
| Resilience and service operations | `midhhealth/reliability-operations/resilience-service-operations` | Service record and readiness evidence schema |
| Data engineering and integration | `midhhealth/data-and-integration/data-engineering-platform` | Synthetic feed contract, fixtures, and CI validator |
| Network engineering and automation | `midhhealth/platform-engineering/network-engineering-platform` | Existing-path map and read-only validation role |
| Healthcare AI | `midhhealth/ai-and-ml-platform/healthcare-ai-platform` | Approved corpus manifest and offline retrieval evaluation |
| MLOps model platform | `midhhealth/ai-and-ml-platform/mlops-model-platform` | Synthetic model package schema and CI validation fixtures |

The first artifact for every domain must run on the existing source-control,
runner, Jenkins, AWX, Kubernetes, or service capacity documented in
`current-environment-state.md`. If implementation discovers a need for new
capacity, it stops and raises a separate architecture decision instead of
silently expanding the lab.

## Detailed-page traceability contract

Every detailed page must identify:

- the canonical portfolio use-case name and primary platform;
- the enterprise capability and provider/payer/shared-service outcome;
- the current environment boundary and the infrastructure it is not authorized
  to create;
- a use-case-specific, repository-owned SVG architecture diagram with actors,
  component interactions, control and runtime boundaries, assurance inputs,
  evidence flow, and recovery feedback;
- linked supporting use cases, the artifact exchanged at each handoff, and the
  failure behavior when dependency evidence is missing or stale;
- measurable quality attributes, including named owners for thresholds that
  remain undecided;
- trust boundaries, least-privilege execution, evidence classification, and
  credential revocation expectations;
- selected architecture decisions, rejected or deferred alternatives, and the
  decision gate for every unresolved choice;
- the Jira epic and testable implementation stories;
- exact planned contract, implementation, result-schema, fixture, CI, and
  runbook paths in the existing platform repository;
- the runtime evidence required for acceptance; and
- the rollback, recovery, or non-mutating stop point.

When a detailed page and the canonical portfolio disagree, the portfolio is
authoritative until both are reconciled in one reviewed change.
