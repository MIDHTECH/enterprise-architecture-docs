# Enterprise DevSecOps Delivery Platform: Detailed Use Cases

Last verified: 2026-08-13

This index contains all 16 canonical use cases owned by the
Enterprise DevSecOps Delivery Platform. Together they deliver reviewed changes safely to provider, payer, and shared platform services. Implementation belongs
in `midhhealth/platform-delivery/devsecops-cicd-orchestrator` and must reuse existing GitLab, accepted runners, Jenkins, AWX, and Kubernetes delivery paths.

No page in this directory authorizes a new runner, VM, registry, cluster, or delivery product. All pages begin as
planned specifications; their individual status changes only after source,
runtime, rollback, and evidence gates are met.

| ID | Use case | Canonical coverage |
| --- | --- | --- |
| `UC-CICD-001` | [End-to-End CI/CD Pipeline Setup](UC-CICD-001-end-to-end-cicd-pipeline.md) | Source gates passed; dedicated agent, live Jenkins plan/deploy/rollback, and evidence acceptance remain pending under `CHG-2026-002` |
| `UC-CICD-002` | [Automated Build Pipeline](UC-CICD-002-automated-build-pipeline.md) | Build process runs in pipeline instead of local machines |
| `UC-CICD-003` | [Automated Unit Testing in CI](UC-CICD-003-automated-unit-testing-in-ci.md) | Tests run before package/deploy stages |
| `UC-CICD-004` | [Code Quality Gate Integration](UC-CICD-004-code-quality-gate-integration.md) | Pipeline has a place for quality scans and gating |
| `UC-CICD-005` | [Artifact Management Automation](UC-CICD-005-artifact-management-automation.md) | Build outputs and Docker images can be versioned and published |
| `UC-CICD-006` | [Docker Image Build and Registry Push](UC-CICD-006-docker-image-build-and-registry-push.md) | Pipeline builds container images and can push to registry |
| `UC-CICD-007` | [Environment-Based Release Promotion](UC-CICD-007-environment-based-release-promotion.md) | Pipeline supports environment variables and promotion gates |
| `UC-CICD-008` | [Automated Rollback Controller](UC-CICD-008-automated-rollback-controller.md) | Pipeline reverses deployments when health or SLO checks fail |
| `UC-CICD-009` | [Pipeline Template Standardization](UC-CICD-009-pipeline-template-standardization.md) | Jenkins shared library and job DSL standardize pipelines |
| `UC-CICD-010` | [Secure CI/CD Pipeline Implementation](UC-CICD-010-secure-ci-cd-pipeline-implementation.md) | Security checks are embedded into delivery workflow |
| `UC-CICD-011` | [Secrets Detection in Source Code](UC-CICD-011-secrets-detection-in-source-code.md) | Pipeline can run Gitleaks/TruffleHog-style checks |
| `UC-CICD-012` | [Container Image Vulnerability Scanning](UC-CICD-012-container-image-vulnerability-scanning.md) | Pipeline can scan images before deployment |
| `UC-CICD-013` | [Dependency Vulnerability Management](UC-CICD-013-dependency-vulnerability-management.md) | Dependency scanning fits before image build/deploy |
| `UC-CICD-014` | [Terraform Plan Automation](UC-CICD-014-terraform-plan-automation.md) | Merge requests publish reviewed Terraform plan artifacts |
| `UC-CICD-015` | [Deployment Health Scoring](UC-CICD-015-deployment-health-scoring.md) | Release gates score health, SLO burn, alerts and rollback readiness |
| `UC-CICD-016` | [Cross-Project Release Contract Validation](UC-CICD-016-cross-project-release-contract-validation.md) | Producer, consumer, API, event and migration compatibility is proven before cross-project promotion |

## GitLab handoff

1. Create the epic and stories from the selected page in `midhhealth/platform-delivery/devsecops-cicd-orchestrator`.
2. Implement only the planned paths that fit the repository and current lab.
3. Run fixture or read-only validation before requesting a mutating change.
4. Return commit, pipeline, Jenkins/AWX, runtime, recovery, and incident
   evidence to the architecture page.
5. Stop and request a separate architecture decision if new infrastructure,
   capacity, products, or protected-data integration would be required.
