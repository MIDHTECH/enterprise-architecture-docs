# GitLab Organization Model

## Purpose

MidhHealth Integrated Care should not use a MAAS-branded GitLab namespace.
MAAS is only a reference workload. The source-control model should look like a
real integrated care delivery and health insurance organization with platform,
security, reliability, data, provider, and payer domains.

## Target Organization

Top-level GitLab group:

```text
midhhealth
```

Display name:

```text
MidhHealth
```

## Subgroups

| Subgroup | Ownership model |
| --- | --- |
| `midhhealth/enterprise-architecture` | Architecture, standards, portfolio, diagrams, training and interview material |
| `midhhealth/platform-delivery` | CI/CD, Jenkins, shared libraries, release controls, artifact and deployment automation |
| `midhhealth/platform-engineering` | Hybrid infrastructure, Kubernetes, Linux systems, network engineering and core runtime platforms |
| `midhhealth/reliability-operations` | Observability, SRE, incident operations, resilience exercises and service readiness |
| `midhhealth/security-governance` | IAM, secrets, policy, compliance, backup, DR, cost and certificate governance |
| `midhhealth/data-and-integration` | Database reliability, data engineering, lineage, quality, integration and analytics foundations |
| `midhhealth/ai-and-ml-platform` | Healthcare AI applications, MLOps, model governance, model serving and responsible AI controls |
| `midhhealth/care-delivery-platform` | Future hospital operations, clinical platforms, patient access and digital care applications |
| `midhhealth/payer-operations-platform` | Future claims, eligibility, prior authorization, member services and payment integrity applications |

## Repository Placement

| Current repository | Target GitLab path |
| --- | --- |
| `enterprise-architecture-docs` | `midhhealth/enterprise-architecture/enterprise-architecture-docs` |
| `devsecops-cicd-orchestrator` | `midhhealth/platform-delivery/devsecops-cicd-orchestrator` |
| `jenkins_jobs` | `midhhealth/platform-delivery/jenkins-jobs` |
| `jenkins-shared-library` | `midhhealth/platform-delivery/jenkins-shared-library` |
| `cloud-infra-automation-platform` | `midhhealth/platform-engineering/cloud-infra-automation-platform` |
| `kubernetes-platform-gitops` | `midhhealth/platform-engineering/kubernetes-platform-gitops` |
| `linux-systems-platform` | `midhhealth/platform-engineering/linux-systems-platform` |
| `network-engineering-platform` | `midhhealth/platform-engineering/network-engineering-platform` |
| `observability-sre-platform` | `midhhealth/reliability-operations/observability-sre-platform` |
| `resilience-service-operations` | `midhhealth/reliability-operations/resilience-service-operations` |
| `ansible-observability` | `midhhealth/reliability-operations/ansible-observability` |
| `ansible-prometheus` | `midhhealth/reliability-operations/ansible-prometheus` |
| `cloud-governance-ops-automation` | `midhhealth/security-governance/cloud-governance-ops-automation` |
| `database-reliability-platform` | `midhhealth/data-and-integration/database-reliability-platform` |
| `data-engineering-platform` | `midhhealth/data-and-integration/data-engineering-platform` |
| `healthcare-ai-platform` | `midhhealth/ai-and-ml-platform/healthcare-ai-platform` |
| `mlops-model-platform` | `midhhealth/ai-and-ml-platform/mlops-model-platform` |

## Migration Guardrails

Do not move GitLab projects one by one without updating consumers. A safe
migration has to update these in the same change window:

1. Create `midhhealth` and all subgroups.
2. Transfer projects from the bootstrap namespace to their target subgroups.
3. Update local `origin` remotes.
4. Update Jenkins seed job SCM URL.
5. Update `jenkins-shared-library` AWX project SCM URLs.
6. Update Linux systems AWX/Jenkins runbook references.
7. Run Jenkins Job DSL validation and shared-library validation.
8. Run the Jenkins seed job.
9. Run AWX project syncs and Project 6-10 preflight smoke tests.
10. Keep the old namespace only as a temporary redirect or archive.
