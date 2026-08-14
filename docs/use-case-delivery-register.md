# Use-Case Project and Delivery Register

Last generated: 2026-08-13

## Purpose and boundary

This register tells an engineer which existing documented GitLab project will receive each
use-case implementation and where its first six source artifacts are planned. It is a design
handoff, not evidence that the repository paths, code, jobs, products, or runtime outcomes
already exist. It creates no project and authorizes no lab change.

Every use case owns one contract and target allowlist, one primary implementation, one result
schema, one fixture family, one GitLab source gate, and one diagnosis/recovery runbook. The
register validates all six paths even though the detailed tables below show the four paths an
implementer normally opens first. The detailed use-case page remains authoritative for scope,
identity, target, change, recovery, evidence, and acceptance.

## Delivery facts

| Measure | Value |
| --- | ---: |
| Detailed use cases | 226 |
| Dependency-safe waves | 12 |
| Primary implementation projects | 13 |
| Planned source artifacts | 1356 |
| Planned path collisions | 0 |

The 12 platform domains use 13 primary implementation projects because the end-to-end CI/CD
demonstration is intentionally delivered through the existing `jenkins-jobs` control project
instead of pretending that all delivery logic belongs in one platform repository.

## Project summary

| Primary implementation project | Owning platform domain(s) | Use cases | Waves used |
| --- | --- | ---: | --- |
| `midhhealth/ai-and-ml-platform/healthcare-ai-platform` | Healthcare AI | 15 | 5, 6, 7, 9, 10 |
| `midhhealth/ai-and-ml-platform/mlops-model-platform` | MLOps model platform | 15 | 5, 6, 7, 8, 9 |
| `midhhealth/data-and-integration/data-engineering-platform` | Data engineering and integration | 25 | 3, 4, 5, 6, 7, 9 |
| `midhhealth/data-and-integration/database-reliability-platform` | Database reliability | 19 | 4, 6, 7, 9 |
| `midhhealth/platform-delivery/devsecops-cicd-orchestrator` | DevSecOps delivery | 15 | 4, 5, 6, 7, 8, 9, 10, 11 |
| `midhhealth/platform-delivery/jenkins-jobs` | DevSecOps delivery | 1 | 4 |
| `midhhealth/platform-engineering/cloud-infra-automation-platform` | Multi-cloud infrastructure | 12 | 3, 5, 6, 7, 8, 10 |
| `midhhealth/platform-engineering/kubernetes-platform-gitops` | Kubernetes with GitOps | 13 | 4, 5, 6, 7, 10, 11, 12 |
| `midhhealth/platform-engineering/linux-systems-platform` | Linux systems engineering | 24 | 4, 5, 6, 7, 9 |
| `midhhealth/platform-engineering/network-engineering-platform` | Network engineering and automation | 31 | 1, 2, 3, 4, 5, 6, 7 |
| `midhhealth/reliability-operations/observability-sre-platform` | Observability and SRE | 16 | 3, 4, 5, 6, 7, 8, 10 |
| `midhhealth/reliability-operations/resilience-service-operations` | Resilience and service operations | 21 | 1, 2, 3, 4, 5, 6, 8 |
| `midhhealth/security-governance/cloud-governance-ops-automation` | Governance and operations | 19 | 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 |

## Project delivery maps

Paths are repository-relative below. Result schemas and fixture directories are also
validated for uniqueness and remain visible on each linked detail page.

### `midhhealth/ai-and-ml-platform/healthcare-ai-platform`

| Wave | Use case | Contract | Primary implementation | GitLab source gate | Recovery runbook |
| ---: | --- | --- | --- | --- | --- |
| 5 | [UC-AI-002: Clinical AI Assistant Platform](use-cases/healthcare-ai/UC-AI-002-clinical-ai-assistant-platform.md) | `contracts/uc-ai-002.yaml` | `src/evaluations/clinical-ai-assistant-platform.py` | `.gitlab/ci/uc-ai-002.yml` | `docs/runbooks/uc-ai-002.md` |
| 5 | [UC-AI-003: Payer AI Assistant Platform](use-cases/healthcare-ai/UC-AI-003-payer-ai-assistant-platform.md) | `contracts/uc-ai-003.yaml` | `src/evaluations/payer-ai-assistant-platform.py` | `.gitlab/ci/uc-ai-003.yml` | `docs/runbooks/uc-ai-003.md` |
| 5 | [UC-AI-011: AI Security and Access Control](use-cases/healthcare-ai/UC-AI-011-ai-security-and-access-control.md) | `contracts/uc-ai-011.yaml` | `src/evaluations/ai-security-and-access-control.py` | `.gitlab/ci/uc-ai-011.yml` | `docs/runbooks/uc-ai-011.md` |
| 5 | [UC-AI-013: AI Observability](use-cases/healthcare-ai/UC-AI-013-ai-observability.md) | `contracts/uc-ai-013.yaml` | `src/evaluations/ai-observability.py` | `.gitlab/ci/uc-ai-013.yml` | `docs/runbooks/uc-ai-013.md` |
| 6 | [UC-AI-005: Healthcare Knowledge Base Indexing](use-cases/healthcare-ai/UC-AI-005-healthcare-knowledge-base-indexing.md) | `contracts/uc-ai-005.yaml` | `src/evaluations/healthcare-knowledge-base-indexing.py` | `.gitlab/ci/uc-ai-005.yml` | `docs/runbooks/uc-ai-005.md` |
| 6 | [UC-AI-006: FHIR-Aware AI APIs](use-cases/healthcare-ai/UC-AI-006-fhir-aware-ai-apis.md) | `contracts/uc-ai-006.yaml` | `src/evaluations/fhir-aware-ai-apis.py` | `.gitlab/ci/uc-ai-006.yml` | `docs/runbooks/uc-ai-006.md` |
| 6 | [UC-AI-015: AI Incident Response](use-cases/healthcare-ai/UC-AI-015-ai-incident-response.md) | `contracts/uc-ai-015.yaml` | `src/evaluations/ai-incident-response.py` | `.gitlab/ci/uc-ai-015.yml` | `docs/runbooks/uc-ai-015.md` |
| 7 | [UC-AI-001: Retrieval-Augmented Generation](use-cases/healthcare-ai/UC-AI-001-retrieval-augmented-generation.md) | `contracts/uc-ai-001.yaml` | `src/evaluations/retrieval-augmented-generation.py` | `.gitlab/ci/uc-ai-001.yml` | `docs/runbooks/uc-ai-001.md` |
| 7 | [UC-AI-012: AI Release Governance](use-cases/healthcare-ai/UC-AI-012-ai-release-governance.md) | `contracts/uc-ai-012.yaml` | `src/evaluations/ai-release-governance.py` | `.gitlab/ci/uc-ai-012.yml` | `docs/runbooks/uc-ai-012.md` |
| 7 | [UC-AI-014: Clinical and Payer Workflow Integration](use-cases/healthcare-ai/UC-AI-014-clinical-and-payer-workflow-integration.md) | `contracts/uc-ai-014.yaml` | `src/evaluations/clinical-and-payer-workflow-integration.py` | `.gitlab/ci/uc-ai-014.yml` | `docs/runbooks/uc-ai-014.md` |
| 9 | [UC-AI-004: Agentic Workflow Automation](use-cases/healthcare-ai/UC-AI-004-agentic-workflow-automation.md) | `contracts/uc-ai-004.yaml` | `src/evaluations/agentic-workflow-automation.py` | `.gitlab/ci/uc-ai-004.yml` | `docs/runbooks/uc-ai-004.md` |
| 9 | [UC-AI-008: Responsible AI Controls](use-cases/healthcare-ai/UC-AI-008-responsible-ai-controls.md) | `contracts/uc-ai-008.yaml` | `src/evaluations/responsible-ai-controls.py` | `.gitlab/ci/uc-ai-008.yml` | `docs/runbooks/uc-ai-008.md` |
| 9 | [UC-AI-009: AI Workflow Audit Logging](use-cases/healthcare-ai/UC-AI-009-ai-workflow-audit-logging.md) | `contracts/uc-ai-009.yaml` | `src/evaluations/ai-workflow-audit-logging.py` | `.gitlab/ci/uc-ai-009.yml` | `docs/runbooks/uc-ai-009.md` |
| 10 | [UC-AI-007: AI Prompt and Response Evaluation](use-cases/healthcare-ai/UC-AI-007-ai-prompt-and-response-evaluation.md) | `contracts/uc-ai-007.yaml` | `src/evaluations/ai-prompt-and-response-evaluation.py` | `.gitlab/ci/uc-ai-007.yml` | `docs/runbooks/uc-ai-007.md` |
| 10 | [UC-AI-010: AI Cost and Latency Optimization](use-cases/healthcare-ai/UC-AI-010-ai-cost-and-latency-optimization.md) | `contracts/uc-ai-010.yaml` | `src/evaluations/ai-cost-and-latency-optimization.py` | `.gitlab/ci/uc-ai-010.yml` | `docs/runbooks/uc-ai-010.md` |

### `midhhealth/ai-and-ml-platform/mlops-model-platform`

| Wave | Use case | Contract | Primary implementation | GitLab source gate | Recovery runbook |
| ---: | --- | --- | --- | --- | --- |
| 5 | [UC-MLOPS-013: ML Infrastructure as Code](use-cases/mlops/UC-MLOPS-013-ml-infrastructure-as-code.md) | `contracts/uc-mlops-013.yaml` | `src/lifecycle/ml-infrastructure-as-code.py` | `.gitlab/ci/uc-mlops-013.yml` | `docs/runbooks/uc-mlops-013.md` |
| 6 | [UC-MLOPS-001: Model Registry and Versioning](use-cases/mlops/UC-MLOPS-001-model-registry-versioning.md) | `contracts/uc-mlops-001.yaml` | `src/lifecycle/model-registry-versioning.py` | `.gitlab/ci/uc-mlops-001.yml` | `docs/runbooks/uc-mlops-001.md` |
| 6 | [UC-MLOPS-003: Feature Engineering and Feature Stores](use-cases/mlops/UC-MLOPS-003-feature-engineering-and-feature-stores.md) | `contracts/uc-mlops-003.yaml` | `src/lifecycle/feature-engineering-and-feature-stores.py` | `.gitlab/ci/uc-mlops-003.yml` | `docs/runbooks/uc-mlops-003.md` |
| 6 | [UC-MLOPS-015: ML Incident Response](use-cases/mlops/UC-MLOPS-015-ml-incident-response.md) | `contracts/uc-mlops-015.yaml` | `src/lifecycle/ml-incident-response.py` | `.gitlab/ci/uc-mlops-015.yml` | `docs/runbooks/uc-mlops-015.md` |
| 7 | [UC-MLOPS-004: Model Validation Gates](use-cases/mlops/UC-MLOPS-004-model-validation-gates.md) | `contracts/uc-mlops-004.yaml` | `src/lifecycle/model-validation-gates.py` | `.gitlab/ci/uc-mlops-004.yml` | `docs/runbooks/uc-mlops-004.md` |
| 7 | [UC-MLOPS-008: Model Observability](use-cases/mlops/UC-MLOPS-008-model-observability.md) | `contracts/uc-mlops-008.yaml` | `src/lifecycle/model-observability.py` | `.gitlab/ci/uc-mlops-008.yml` | `docs/runbooks/uc-mlops-008.md` |
| 8 | [UC-MLOPS-002: ML Training Pipeline Standardization](use-cases/mlops/UC-MLOPS-002-ml-training-pipeline-standardization.md) | `contracts/uc-mlops-002.yaml` | `src/lifecycle/ml-training-pipeline-standardization.py` | `.gitlab/ci/uc-mlops-002.yml` | `docs/runbooks/uc-mlops-002.md` |
| 8 | [UC-MLOPS-005: CI/CT/CD for ML](use-cases/mlops/UC-MLOPS-005-ci-ct-cd-for-ml.md) | `contracts/uc-mlops-005.yaml` | `src/lifecycle/ci-ct-cd-for-ml.py` | `.gitlab/ci/uc-mlops-005.yml` | `docs/runbooks/uc-mlops-005.md` |
| 8 | [UC-MLOPS-006: Batch Inference](use-cases/mlops/UC-MLOPS-006-batch-inference.md) | `contracts/uc-mlops-006.yaml` | `src/lifecycle/batch-inference.py` | `.gitlab/ci/uc-mlops-006.yml` | `docs/runbooks/uc-mlops-006.md` |
| 8 | [UC-MLOPS-007: Real-Time Inference APIs](use-cases/mlops/UC-MLOPS-007-real-time-inference-apis.md) | `contracts/uc-mlops-007.yaml` | `src/lifecycle/real-time-inference-apis.py` | `.gitlab/ci/uc-mlops-007.yml` | `docs/runbooks/uc-mlops-007.md` |
| 8 | [UC-MLOPS-009: Drift Detection](use-cases/mlops/UC-MLOPS-009-drift-detection.md) | `contracts/uc-mlops-009.yaml` | `src/lifecycle/drift-detection.py` | `.gitlab/ci/uc-mlops-009.yml` | `docs/runbooks/uc-mlops-009.md` |
| 8 | [UC-MLOPS-011: Model Rollback](use-cases/mlops/UC-MLOPS-011-model-rollback.md) | `contracts/uc-mlops-011.yaml` | `src/lifecycle/model-rollback.py` | `.gitlab/ci/uc-mlops-011.yml` | `docs/runbooks/uc-mlops-011.md` |
| 8 | [UC-MLOPS-014: Model Governance Evidence](use-cases/mlops/UC-MLOPS-014-model-governance-evidence.md) | `contracts/uc-mlops-014.yaml` | `src/lifecycle/model-governance-evidence.py` | `.gitlab/ci/uc-mlops-014.yml` | `docs/runbooks/uc-mlops-014.md` |
| 9 | [UC-MLOPS-010: Automated Retraining](use-cases/mlops/UC-MLOPS-010-automated-retraining.md) | `contracts/uc-mlops-010.yaml` | `src/lifecycle/automated-retraining.py` | `.gitlab/ci/uc-mlops-010.yml` | `docs/runbooks/uc-mlops-010.md` |
| 9 | [UC-MLOPS-012: Experiment Tracking](use-cases/mlops/UC-MLOPS-012-experiment-tracking.md) | `contracts/uc-mlops-012.yaml` | `src/lifecycle/experiment-tracking.py` | `.gitlab/ci/uc-mlops-012.yml` | `docs/runbooks/uc-mlops-012.md` |

### `midhhealth/data-and-integration/data-engineering-platform`

| Wave | Use case | Contract | Primary implementation | GitLab source gate | Recovery runbook |
| ---: | --- | --- | --- | --- | --- |
| 3 | [UC-DATA-015: Data Classification](use-cases/data/UC-DATA-015-data-classification.md) | `contracts/uc-data-015.yaml` | `src/use_cases/data-classification.py` | `.gitlab/ci/uc-data-015.yml` | `docs/runbooks/uc-data-015.md` |
| 4 | [UC-DATA-007: Schema Registry and Evolution](use-cases/data/UC-DATA-007-schema-registry-and-evolution.md) | `contracts/uc-data-007.yaml` | `src/use_cases/schema-registry-and-evolution.py` | `.gitlab/ci/uc-data-007.yml` | `docs/runbooks/uc-data-007.md` |
| 4 | [UC-DATA-023: Data Access Governance](use-cases/data/UC-DATA-023-data-access-governance.md) | `contracts/uc-data-023.yaml` | `src/use_cases/data-access-governance.py` | `.gitlab/ci/uc-data-023.yml` | `docs/runbooks/uc-data-023.md` |
| 5 | [UC-DATA-001: Healthcare Feed Quality Validation](use-cases/data/UC-DATA-001-healthcare-feed-quality.md) | `contracts/uc-data-001.yaml` | `src/use_cases/healthcare-feed-quality.py` | `.gitlab/ci/uc-data-001.yml` | `docs/runbooks/uc-data-001.md` |
| 5 | [UC-DATA-005: ETL and ELT Pipelines](use-cases/data/UC-DATA-005-etl-and-elt-pipelines.md) | `contracts/uc-data-005.yaml` | `src/use_cases/etl-and-elt-pipelines.py` | `.gitlab/ci/uc-data-005.yml` | `docs/runbooks/uc-data-005.md` |
| 5 | [UC-DATA-006: Workflow Orchestration](use-cases/data/UC-DATA-006-workflow-orchestration.md) | `contracts/uc-data-006.yaml` | `src/use_cases/workflow-orchestration.py` | `.gitlab/ci/uc-data-006.yml` | `docs/runbooks/uc-data-006.md` |
| 5 | [UC-DATA-008: Event-Contract Management](use-cases/data/UC-DATA-008-event-contract-management.md) | `contracts/uc-data-008.yaml` | `src/use_cases/event-contract-management.py` | `.gitlab/ci/uc-data-008.yml` | `docs/runbooks/uc-data-008.md` |
| 5 | [UC-DATA-013: Metadata Catalog and Discovery](use-cases/data/UC-DATA-013-metadata-catalog-and-discovery.md) | `contracts/uc-data-013.yaml` | `src/use_cases/metadata-catalog-and-discovery.py` | `.gitlab/ci/uc-data-013.yml` | `docs/runbooks/uc-data-013.md` |
| 5 | [UC-DATA-014: Data Lineage](use-cases/data/UC-DATA-014-data-lineage.md) | `contracts/uc-data-014.yaml` | `src/use_cases/data-lineage.py` | `.gitlab/ci/uc-data-014.yml` | `docs/runbooks/uc-data-014.md` |
| 5 | [UC-DATA-016: PII Controls](use-cases/data/UC-DATA-016-pii-controls.md) | `contracts/uc-data-016.yaml` | `src/use_cases/pii-controls.py` | `.gitlab/ci/uc-data-016.yml` | `docs/runbooks/uc-data-016.md` |
| 5 | [UC-DATA-020: Dead-Letter Queues and Replay](use-cases/data/UC-DATA-020-dead-letter-queues-and-replay.md) | `contracts/uc-data-020.yaml` | `src/use_cases/dead-letter-queues-and-replay.py` | `.gitlab/ci/uc-data-020.yml` | `docs/runbooks/uc-data-020.md` |
| 6 | [UC-DATA-002: Batch Data Ingestion](use-cases/data/UC-DATA-002-batch-data-ingestion.md) | `contracts/uc-data-002.yaml` | `src/use_cases/batch-data-ingestion.py` | `.gitlab/ci/uc-data-002.yml` | `docs/runbooks/uc-data-002.md` |
| 6 | [UC-DATA-003: Streaming Data Ingestion](use-cases/data/UC-DATA-003-streaming-data-ingestion.md) | `contracts/uc-data-003.yaml` | `src/use_cases/streaming-data-ingestion.py` | `.gitlab/ci/uc-data-003.yml` | `docs/runbooks/uc-data-003.md` |
| 6 | [UC-DATA-004: Change-Data Capture](use-cases/data/UC-DATA-004-change-data-capture.md) | `contracts/uc-data-004.yaml` | `src/use_cases/change-data-capture.py` | `.gitlab/ci/uc-data-004.yml` | `docs/runbooks/uc-data-004.md` |
| 6 | [UC-DATA-009: dbt Data Transformation](use-cases/data/UC-DATA-009-dbt-data-transformation.md) | `contracts/uc-data-009.yaml` | `src/use_cases/dbt-data-transformation.py` | `.gitlab/ci/uc-data-009.yml` | `docs/runbooks/uc-data-009.md` |
| 6 | [UC-DATA-010: Distributed Data Processing](use-cases/data/UC-DATA-010-distributed-data-processing.md) | `contracts/uc-data-010.yaml` | `src/use_cases/distributed-data-processing.py` | `.gitlab/ci/uc-data-010.yml` | `docs/runbooks/uc-data-010.md` |
| 6 | [UC-DATA-011: Data Lake and Lakehouse Storage](use-cases/data/UC-DATA-011-data-lake-and-lakehouse-storage.md) | `contracts/uc-data-011.yaml` | `src/use_cases/data-lake-and-lakehouse-storage.py` | `.gitlab/ci/uc-data-011.yml` | `docs/runbooks/uc-data-011.md` |
| 6 | [UC-DATA-012: Data Warehouse Integration](use-cases/data/UC-DATA-012-data-warehouse-integration.md) | `contracts/uc-data-012.yaml` | `src/use_cases/data-warehouse-integration.py` | `.gitlab/ci/uc-data-012.yml` | `docs/runbooks/uc-data-012.md` |
| 6 | [UC-DATA-017: Data Retention and Archival](use-cases/data/UC-DATA-017-data-retention-and-archival.md) | `contracts/uc-data-017.yaml` | `src/use_cases/data-retention-and-archival.py` | `.gitlab/ci/uc-data-017.yml` | `docs/runbooks/uc-data-017.md` |
| 6 | [UC-DATA-021: Data Reconciliation](use-cases/data/UC-DATA-021-data-reconciliation.md) | `contracts/uc-data-021.yaml` | `src/use_cases/data-reconciliation.py` | `.gitlab/ci/uc-data-021.yml` | `docs/runbooks/uc-data-021.md` |
| 6 | [UC-DATA-022: Dataset Ownership](use-cases/data/UC-DATA-022-dataset-ownership.md) | `contracts/uc-data-022.yaml` | `src/use_cases/dataset-ownership.py` | `.gitlab/ci/uc-data-022.yml` | `docs/runbooks/uc-data-022.md` |
| 6 | [UC-DATA-025: Data Performance and Cost Optimization](use-cases/data/UC-DATA-025-data-performance-and-cost-optimization.md) | `contracts/uc-data-025.yaml` | `src/use_cases/data-performance-and-cost-optimization.py` | `.gitlab/ci/uc-data-025.yml` | `docs/runbooks/uc-data-025.md` |
| 7 | [UC-DATA-018: Pipeline Monitoring and Alerting](use-cases/data/UC-DATA-018-pipeline-monitoring-and-alerting.md) | `contracts/uc-data-018.yaml` | `src/use_cases/pipeline-monitoring-and-alerting.py` | `.gitlab/ci/uc-data-018.yml` | `docs/runbooks/uc-data-018.md` |
| 7 | [UC-DATA-019: Pipeline Retry and Backfill](use-cases/data/UC-DATA-019-pipeline-retry-and-backfill.md) | `contracts/uc-data-019.yaml` | `src/use_cases/pipeline-retry-and-backfill.py` | `.gitlab/ci/uc-data-019.yml` | `docs/runbooks/uc-data-019.md` |
| 9 | [UC-DATA-024: Data-Pipeline Disaster Recovery](use-cases/data/UC-DATA-024-data-pipeline-disaster-recovery.md) | `contracts/uc-data-024.yaml` | `src/use_cases/data-pipeline-disaster-recovery.py` | `.gitlab/ci/uc-data-024.yml` | `docs/runbooks/uc-data-024.md` |

### `midhhealth/data-and-integration/database-reliability-platform`

| Wave | Use case | Contract | Primary implementation | GitLab source gate | Recovery runbook |
| ---: | --- | --- | --- | --- | --- |
| 4 | [UC-DB-012: TLS and Credential Rotation](use-cases/database/UC-DB-012-tls-and-credential-rotation.md) | `contracts/uc-db-012.yaml` | `playbooks/tls-and-credential-rotation.yml` | `.gitlab/ci/uc-db-012.yml` | `docs/runbooks/uc-db-012.md` |
| 6 | [UC-DB-004: Schema Migration Automation](use-cases/database/UC-DB-004-schema-migration-automation.md) | `contracts/uc-db-004.yaml` | `playbooks/schema-migration-automation.yml` | `.gitlab/ci/uc-db-004.yml` | `docs/runbooks/uc-db-004.md` |
| 6 | [UC-DB-018: Data Retention and Archival](use-cases/database/UC-DB-018-data-retention-and-archival.md) | `contracts/uc-db-018.yaml` | `playbooks/data-retention-and-archival.yml` | `.gitlab/ci/uc-db-018.yml` | `docs/runbooks/uc-db-018.md` |
| 6 | [UC-DB-019: Database Incident Runbooks](use-cases/database/UC-DB-019-database-incident-runbooks.md) | `contracts/uc-db-019.yaml` | `playbooks/database-incident-runbooks.yml` | `.gitlab/ci/uc-db-019.yml` | `docs/runbooks/uc-db-019.md` |
| 7 | [UC-DB-001: Automated PostgreSQL Restore Validation](use-cases/database/UC-DB-001-backup-restore-validation.md) | `contracts/uc-db-001.yaml` | `playbooks/backup-restore-validation.yml` | `.gitlab/ci/uc-db-001.yml` | `docs/runbooks/uc-db-001.md` |
| 7 | [UC-DB-002: PostgreSQL Installation Through AWX](use-cases/database/UC-DB-002-postgresql-installation-through-awx.md) | `contracts/uc-db-002.yaml` | `playbooks/postgresql-installation-through-awx.yml` | `.gitlab/ci/uc-db-002.yml` | `docs/runbooks/uc-db-002.md` |
| 7 | [UC-DB-003: Database and Role Provisioning](use-cases/database/UC-DB-003-database-and-role-provisioning.md) | `contracts/uc-db-003.yaml` | `playbooks/database-and-role-provisioning.yml` | `.gitlab/ci/uc-db-003.yml` | `docs/runbooks/uc-db-003.md` |
| 7 | [UC-DB-006: Major-Version Upgrade Automation](use-cases/database/UC-DB-006-major-version-upgrade-automation.md) | `contracts/uc-db-006.yaml` | `playbooks/major-version-upgrade-automation.yml` | `.gitlab/ci/uc-db-006.yml` | `docs/runbooks/uc-db-006.md` |
| 7 | [UC-DB-007: Minor Patching](use-cases/database/UC-DB-007-minor-patching.md) | `contracts/uc-db-007.yaml` | `playbooks/minor-patching.yml` | `.gitlab/ci/uc-db-007.yml` | `docs/runbooks/uc-db-007.md` |
| 7 | [UC-DB-008: Database Performance Monitoring](use-cases/database/UC-DB-008-database-performance-monitoring.md) | `contracts/uc-db-008.yaml` | `playbooks/database-performance-monitoring.yml` | `.gitlab/ci/uc-db-008.yml` | `docs/runbooks/uc-db-008.md` |
| 7 | [UC-DB-009: Slow-Query Analysis](use-cases/database/UC-DB-009-slow-query-analysis.md) | `contracts/uc-db-009.yaml` | `playbooks/slow-query-analysis.yml` | `.gitlab/ci/uc-db-009.yml` | `docs/runbooks/uc-db-009.md` |
| 7 | [UC-DB-010: Index and Statistics Maintenance](use-cases/database/UC-DB-010-index-and-statistics-maintenance.md) | `contracts/uc-db-010.yaml` | `playbooks/index-and-statistics-maintenance.yml` | `.gitlab/ci/uc-db-010.yml` | `docs/runbooks/uc-db-010.md` |
| 7 | [UC-DB-011: Connection Pooling](use-cases/database/UC-DB-011-connection-pooling.md) | `contracts/uc-db-011.yaml` | `playbooks/connection-pooling.yml` | `.gitlab/ci/uc-db-011.yml` | `docs/runbooks/uc-db-011.md` |
| 7 | [UC-DB-013: Database Auditing](use-cases/database/UC-DB-013-database-auditing.md) | `contracts/uc-db-013.yaml` | `playbooks/database-auditing.yml` | `.gitlab/ci/uc-db-013.yml` | `docs/runbooks/uc-db-013.md` |
| 7 | [UC-DB-014: Capacity Forecasting](use-cases/database/UC-DB-014-capacity-forecasting.md) | `contracts/uc-db-014.yaml` | `playbooks/capacity-forecasting.yml` | `.gitlab/ci/uc-db-014.yml` | `docs/runbooks/uc-db-014.md` |
| 7 | [UC-DB-017: Application Database Onboarding](use-cases/database/UC-DB-017-application-database-onboarding.md) | `contracts/uc-db-017.yaml` | `playbooks/application-database-onboarding.yml` | `.gitlab/ci/uc-db-017.yml` | `docs/runbooks/uc-db-017.md` |
| 9 | [UC-DB-005: Backup and Point-in-Time Recovery](use-cases/database/UC-DB-005-backup-and-point-in-time-recovery.md) | `contracts/uc-db-005.yaml` | `playbooks/backup-and-point-in-time-recovery.yml` | `.gitlab/ci/uc-db-005.yml` | `docs/runbooks/uc-db-005.md` |
| 9 | [UC-DB-015: Replication and Failover Exercises](use-cases/database/UC-DB-015-replication-and-failover-exercises.md) | `contracts/uc-db-015.yaml` | `playbooks/replication-and-failover-exercises.yml` | `.gitlab/ci/uc-db-015.yml` | `docs/runbooks/uc-db-015.md` |
| 9 | [UC-DB-016: RPO and RTO Validation](use-cases/database/UC-DB-016-rpo-and-rto-validation.md) | `contracts/uc-db-016.yaml` | `playbooks/rpo-and-rto-validation.yml` | `.gitlab/ci/uc-db-016.yml` | `docs/runbooks/uc-db-016.md` |

### `midhhealth/platform-delivery/devsecops-cicd-orchestrator`

| Wave | Use case | Contract | Primary implementation | GitLab source gate | Recovery runbook |
| ---: | --- | --- | --- | --- | --- |
| 4 | [UC-CICD-011: Secrets Detection in Source Code](use-cases/devsecops/UC-CICD-011-secrets-detection-in-source-code.md) | `contracts/uc-cicd-011.yaml` | `jobs/secrets-detection-in-source-code.groovy` | `.gitlab/ci/uc-cicd-011.yml` | `docs/runbooks/uc-cicd-011.md` |
| 4 | [UC-CICD-014: Terraform Plan Automation](use-cases/devsecops/UC-CICD-014-terraform-plan-automation.md) | `contracts/uc-cicd-014.yaml` | `jobs/terraform-plan-automation.groovy` | `.gitlab/ci/uc-cicd-014.yml` | `docs/runbooks/uc-cicd-014.md` |
| 5 | [UC-CICD-015: Deployment Health Scoring](use-cases/devsecops/UC-CICD-015-deployment-health-scoring.md) | `contracts/uc-cicd-015.yaml` | `jobs/deployment-health-scoring.groovy` | `.gitlab/ci/uc-cicd-015.yml` | `docs/runbooks/uc-cicd-015.md` |
| 6 | [UC-CICD-007: Environment-Based Release Promotion](use-cases/devsecops/UC-CICD-007-environment-based-release-promotion.md) | `contracts/uc-cicd-007.yaml` | `jobs/environment-based-release-promotion.groovy` | `.gitlab/ci/uc-cicd-007.yml` | `docs/runbooks/uc-cicd-007.md` |
| 7 | [UC-CICD-002: Automated Build Pipeline](use-cases/devsecops/UC-CICD-002-automated-build-pipeline.md) | `contracts/uc-cicd-002.yaml` | `jobs/automated-build-pipeline.groovy` | `.gitlab/ci/uc-cicd-002.yml` | `docs/runbooks/uc-cicd-002.md` |
| 7 | [UC-CICD-008: Automated Rollback Controller](use-cases/devsecops/UC-CICD-008-automated-rollback-controller.md) | `contracts/uc-cicd-008.yaml` | `jobs/automated-rollback-controller.groovy` | `.gitlab/ci/uc-cicd-008.yml` | `docs/runbooks/uc-cicd-008.md` |
| 7 | [UC-CICD-009: Pipeline Template Standardization](use-cases/devsecops/UC-CICD-009-pipeline-template-standardization.md) | `contracts/uc-cicd-009.yaml` | `jobs/pipeline-template-standardization.groovy` | `.gitlab/ci/uc-cicd-009.yml` | `docs/runbooks/uc-cicd-009.md` |
| 7 | [UC-CICD-010: Secure CI/CD Pipeline Implementation](use-cases/devsecops/UC-CICD-010-secure-ci-cd-pipeline-implementation.md) | `contracts/uc-cicd-010.yaml` | `jobs/secure-ci-cd-pipeline-implementation.groovy` | `.gitlab/ci/uc-cicd-010.yml` | `docs/runbooks/uc-cicd-010.md` |
| 7 | [UC-CICD-016: Cross-Project Release Contract Validation](use-cases/devsecops/UC-CICD-016-cross-project-release-contract-validation.md) | `contracts/uc-cicd-016.yaml` | `src/release_contracts/evaluate.py` | `.gitlab/ci/uc-cicd-016.yml` | `docs/runbooks/uc-cicd-016.md` |
| 8 | [UC-CICD-005: Artifact Management Automation](use-cases/devsecops/UC-CICD-005-artifact-management-automation.md) | `contracts/uc-cicd-005.yaml` | `jobs/artifact-management-automation.groovy` | `.gitlab/ci/uc-cicd-005.yml` | `docs/runbooks/uc-cicd-005.md` |
| 9 | [UC-CICD-004: Code Quality Gate Integration](use-cases/devsecops/UC-CICD-004-code-quality-gate-integration.md) | `contracts/uc-cicd-004.yaml` | `jobs/code-quality-gate-integration.groovy` | `.gitlab/ci/uc-cicd-004.yml` | `docs/runbooks/uc-cicd-004.md` |
| 10 | [UC-CICD-003: Automated Unit Testing in CI](use-cases/devsecops/UC-CICD-003-automated-unit-testing-in-ci.md) | `contracts/uc-cicd-003.yaml` | `jobs/automated-unit-testing-in-ci.groovy` | `.gitlab/ci/uc-cicd-003.yml` | `docs/runbooks/uc-cicd-003.md` |
| 10 | [UC-CICD-012: Container Image Vulnerability Scanning](use-cases/devsecops/UC-CICD-012-container-image-vulnerability-scanning.md) | `contracts/uc-cicd-012.yaml` | `jobs/container-image-vulnerability-scanning.groovy` | `.gitlab/ci/uc-cicd-012.yml` | `docs/runbooks/uc-cicd-012.md` |
| 10 | [UC-CICD-013: Dependency Vulnerability Management](use-cases/devsecops/UC-CICD-013-dependency-vulnerability-management.md) | `contracts/uc-cicd-013.yaml` | `jobs/dependency-vulnerability-management.groovy` | `.gitlab/ci/uc-cicd-013.yml` | `docs/runbooks/uc-cicd-013.md` |
| 11 | [UC-CICD-006: Docker Image Build and Registry Push](use-cases/devsecops/UC-CICD-006-docker-image-build-and-registry-push.md) | `contracts/uc-cicd-006.yaml` | `jobs/docker-image-build-and-registry-push.groovy` | `.gitlab/ci/uc-cicd-006.yml` | `docs/runbooks/uc-cicd-006.md` |

### `midhhealth/platform-delivery/jenkins-jobs`

| Wave | Use case | Contract | Primary implementation | GitLab source gate | Recovery runbook |
| ---: | --- | --- | --- | --- | --- |
| 4 | [UC-CICD-001: End-to-End CI/CD Pipeline Setup](use-cases/devsecops/UC-CICD-001-end-to-end-cicd-pipeline.md) | `contracts/uc-cicd-001.yaml` | `jobs/end-to-end-cicd-pipeline.groovy` | `.gitlab/ci/uc-cicd-001.yml` | `docs/runbooks/uc-cicd-001.md` |

### `midhhealth/platform-engineering/cloud-infra-automation-platform`

| Wave | Use case | Contract | Primary implementation | GitLab source gate | Recovery runbook |
| ---: | --- | --- | --- | --- | --- |
| 3 | [UC-INFRA-008: Cloud Resource Tagging Automation](use-cases/infrastructure/UC-INFRA-008-cloud-resource-tagging-automation.md) | `contracts/uc-infra-008.yaml` | `automation/cloud-resource-tagging-automation/main.yml` | `.gitlab/ci/uc-infra-008.yml` | `docs/runbooks/uc-infra-008.md` |
| 3 | [UC-INFRA-009: Terraform State Integrity Monitoring](use-cases/infrastructure/UC-INFRA-009-terraform-state-integrity-monitoring.md) | `contracts/uc-infra-009.yaml` | `automation/terraform-state-integrity-monitoring/main.yml` | `.gitlab/ci/uc-infra-009.yml` | `docs/runbooks/uc-infra-009.md` |
| 5 | [UC-INFRA-001: Terraform Drift Detection](use-cases/infrastructure/UC-INFRA-001-terraform-drift-detection.md) | `contracts/uc-infra-001.yaml` | `automation/terraform-drift-detection/main.yml` | `.gitlab/ci/uc-infra-001.yml` | `docs/runbooks/uc-infra-001.md` |
| 5 | [UC-INFRA-002: Azure Infrastructure Provisioning Using Terraform](use-cases/infrastructure/UC-INFRA-002-azure-infrastructure-provisioning-using-terraform.md) | `contracts/uc-infra-002.yaml` | `automation/azure-infrastructure-provisioning-using-terraform/main.yml` | `.gitlab/ci/uc-infra-002.yml` | `docs/runbooks/uc-infra-002.md` |
| 5 | [UC-INFRA-004: Terraform Plan Analyzer](use-cases/infrastructure/UC-INFRA-004-terraform-plan-analyzer.md) | `contracts/uc-infra-004.yaml` | `automation/terraform-plan-analyzer/main.yml` | `.gitlab/ci/uc-infra-004.yml` | `docs/runbooks/uc-infra-004.md` |
| 5 | [UC-INFRA-005: Server Configuration Automation Using Ansible](use-cases/infrastructure/UC-INFRA-005-server-configuration-automation-using-ansible.md) | `contracts/uc-infra-005.yaml` | `automation/server-configuration-automation-using-ansible/main.yml` | `.gitlab/ci/uc-infra-005.yml` | `docs/runbooks/uc-infra-005.md` |
| 5 | [UC-INFRA-007: Infrastructure Change Impact Analysis](use-cases/infrastructure/UC-INFRA-007-infrastructure-change-impact-analysis.md) | `contracts/uc-infra-007.yaml` | `automation/infrastructure-change-impact-analysis/main.yml` | `.gitlab/ci/uc-infra-007.yml` | `docs/runbooks/uc-infra-007.md` |
| 6 | [UC-INFRA-011: Infrastructure Reconciliation Loop](use-cases/infrastructure/UC-INFRA-011-infrastructure-reconciliation-loop.md) | `contracts/uc-infra-011.yaml` | `automation/infrastructure-reconciliation-loop/main.yml` | `.gitlab/ci/uc-infra-011.yml` | `docs/runbooks/uc-infra-011.md` |
| 7 | [UC-INFRA-003: AWS VPC Landing Zone Setup](use-cases/infrastructure/UC-INFRA-003-aws-vpc-landing-zone-setup.md) | `contracts/uc-infra-003.yaml` | `automation/aws-vpc-landing-zone-setup/main.yml` | `.gitlab/ci/uc-infra-003.yml` | `docs/runbooks/uc-infra-003.md` |
| 7 | [UC-INFRA-006: Linux Server Patch Automation](use-cases/infrastructure/UC-INFRA-006-linux-server-patch-automation.md) | `contracts/uc-infra-006.yaml` | `automation/linux-server-patch-automation/main.yml` | `.gitlab/ci/uc-infra-006.yml` | `docs/runbooks/uc-infra-006.md` |
| 8 | [UC-INFRA-010: Environment Standardization Across Dev/Test/Prod](use-cases/infrastructure/UC-INFRA-010-environment-standardization-across-dev-test-prod.md) | `contracts/uc-infra-010.yaml` | `automation/environment-standardization-across-dev-test-prod/main.yml` | `.gitlab/ci/uc-infra-010.yml` | `docs/runbooks/uc-infra-010.md` |
| 10 | [UC-INFRA-012: Policy-Driven Provisioning](use-cases/infrastructure/UC-INFRA-012-policy-driven-provisioning.md) | `contracts/uc-infra-012.yaml` | `automation/policy-driven-provisioning/main.yml` | `.gitlab/ci/uc-infra-012.yml` | `docs/runbooks/uc-infra-012.md` |

### `midhhealth/platform-engineering/kubernetes-platform-gitops`

| Wave | Use case | Contract | Primary implementation | GitLab source gate | Recovery runbook |
| ---: | --- | --- | --- | --- | --- |
| 4 | [UC-K8S-001: Kubernetes Configuration Drift](use-cases/kubernetes/UC-K8S-001-kubernetes-configuration-drift.md) | `contracts/uc-k8s-001.yaml` | `use-cases/kubernetes-configuration-drift/policy.yaml` | `.gitlab/ci/uc-k8s-001.yml` | `docs/runbooks/uc-k8s-001.md` |
| 5 | [UC-K8S-003: Kubernetes Application Deployment](use-cases/kubernetes/UC-K8S-003-kubernetes-application-deployment.md) | `contracts/uc-k8s-003.yaml` | `use-cases/kubernetes-application-deployment/policy.yaml` | `.gitlab/ci/uc-k8s-003.yml` | `docs/runbooks/uc-k8s-003.md` |
| 6 | [UC-K8S-002: AKS/EKS/GKE Cluster Provisioning Automation](use-cases/kubernetes/UC-K8S-002-aks-eks-gke-cluster-provisioning-automation.md) | `contracts/uc-k8s-002.yaml` | `use-cases/aks-eks-gke-cluster-provisioning-automation/policy.yaml` | `.gitlab/ci/uc-k8s-002.yml` | `docs/runbooks/uc-k8s-002.md` |
| 6 | [UC-K8S-005: Continuous Verification](use-cases/kubernetes/UC-K8S-005-continuous-verification.md) | `contracts/uc-k8s-005.yaml` | `use-cases/continuous-verification/policy.yaml` | `.gitlab/ci/uc-k8s-005.yml` | `docs/runbooks/uc-k8s-005.md` |
| 6 | [UC-K8S-009: Ingress and Traffic Management Standardization](use-cases/kubernetes/UC-K8S-009-ingress-and-traffic-management-standardization.md) | `contracts/uc-k8s-009.yaml` | `use-cases/ingress-and-traffic-management-standardization/policy.yaml` | `.gitlab/ci/uc-k8s-009.yml` | `docs/runbooks/uc-k8s-009.md` |
| 6 | [UC-K8S-010: Workload Right-Sizing](use-cases/kubernetes/UC-K8S-010-workload-right-sizing.md) | `contracts/uc-k8s-010.yaml` | `use-cases/workload-right-sizing/policy.yaml` | `.gitlab/ci/uc-k8s-010.yml` | `docs/runbooks/uc-k8s-010.md` |
| 6 | [UC-K8S-012: Event-Driven Autoscaling](use-cases/kubernetes/UC-K8S-012-event-driven-autoscaling.md) | `contracts/uc-k8s-012.yaml` | `use-cases/event-driven-autoscaling/policy.yaml` | `.gitlab/ci/uc-k8s-012.yml` | `docs/runbooks/uc-k8s-012.md` |
| 7 | [UC-K8S-004: GitOps Reconciliation](use-cases/kubernetes/UC-K8S-004-gitops-reconciliation.md) | `contracts/uc-k8s-004.yaml` | `use-cases/gitops-reconciliation/policy.yaml` | `.gitlab/ci/uc-k8s-004.yml` | `docs/runbooks/uc-k8s-004.md` |
| 10 | [UC-K8S-006: Kubernetes Security Baseline Implementation](use-cases/kubernetes/UC-K8S-006-kubernetes-security-baseline-implementation.md) | `contracts/uc-k8s-006.yaml` | `use-cases/kubernetes-security-baseline-implementation/policy.yaml` | `.gitlab/ci/uc-k8s-006.yml` | `docs/runbooks/uc-k8s-006.md` |
| 10 | [UC-K8S-013: Kubernetes Cost Allocation](use-cases/kubernetes/UC-K8S-013-kubernetes-cost-allocation.md) | `contracts/uc-k8s-013.yaml` | `use-cases/kubernetes-cost-allocation/policy.yaml` | `.gitlab/ci/uc-k8s-013.yml` | `docs/runbooks/uc-k8s-013.md` |
| 11 | [UC-K8S-007: Kubernetes Security Policy Enforcement](use-cases/kubernetes/UC-K8S-007-kubernetes-security-policy-enforcement.md) | `contracts/uc-k8s-007.yaml` | `use-cases/kubernetes-security-policy-enforcement/policy.yaml` | `.gitlab/ci/uc-k8s-007.yml` | `docs/runbooks/uc-k8s-007.md` |
| 11 | [UC-K8S-011: Container Registry and Image Supply Chain Security](use-cases/kubernetes/UC-K8S-011-container-registry-and-image-supply-chain-security.md) | `contracts/uc-k8s-011.yaml` | `use-cases/container-registry-and-image-supply-chain-security/policy.yaml` | `.gitlab/ci/uc-k8s-011.yml` | `docs/runbooks/uc-k8s-011.md` |
| 12 | [UC-K8S-008: Kubernetes Policy-as-Code Governance](use-cases/kubernetes/UC-K8S-008-kubernetes-policy-as-code-governance.md) | `contracts/uc-k8s-008.yaml` | `use-cases/kubernetes-policy-as-code-governance/policy.yaml` | `.gitlab/ci/uc-k8s-008.yml` | `docs/runbooks/uc-k8s-008.md` |

### `midhhealth/platform-engineering/linux-systems-platform`

| Wave | Use case | Contract | Primary implementation | GitLab source gate | Recovery runbook |
| ---: | --- | --- | --- | --- | --- |
| 4 | [UC-LNX-005: AWX and Ansible Configuration Management](use-cases/linux/UC-LNX-005-awx-ansible-configuration-management.md) | `contracts/uc-lnx-005.yaml` | `roles/awx-ansible-configuration-management/tasks/main.yml` | `.gitlab/ci/uc-lnx-005.yml` | `docs/runbooks/uc-lnx-005.md` |
| 5 | [UC-LNX-008: SELinux and Firewall Management](use-cases/linux/UC-LNX-008-selinux-firewall-management.md) | `contracts/uc-lnx-008.yaml` | `roles/selinux-firewall-management/tasks/main.yml` | `.gitlab/ci/uc-lnx-008.yml` | `docs/runbooks/uc-lnx-008.md` |
| 5 | [UC-LNX-011: DNS, NTP and Host Networking](use-cases/linux/UC-LNX-011-dns-ntp-host-networking.md) | `contracts/uc-lnx-011.yaml` | `roles/dns-ntp-host-networking/tasks/main.yml` | `.gitlab/ci/uc-lnx-011.yml` | `docs/runbooks/uc-lnx-011.md` |
| 5 | [UC-LNX-020: Hybrid-Cloud and Container Host Engineering](use-cases/linux/UC-LNX-020-hybrid-cloud-container-host-engineering.md) | `contracts/uc-lnx-020.yaml` | `roles/hybrid-cloud-container-host-engineering/tasks/main.yml` | `.gitlab/ci/uc-lnx-020.yml` | `docs/runbooks/uc-lnx-020.md` |
| 6 | [UC-LNX-001: Ubuntu and Rocky Linux Installation Standards](use-cases/linux/UC-LNX-001-os-installation-standards.md) | `contracts/uc-lnx-001.yaml` | `roles/os-installation-standards/tasks/main.yml` | `.gitlab/ci/uc-lnx-001.yml` | `docs/runbooks/uc-lnx-001.md` |
| 6 | [UC-LNX-002: KVM and libvirt Virtualization](use-cases/linux/UC-LNX-002-kvm-libvirt-virtualization.md) | `contracts/uc-lnx-002.yaml` | `roles/kvm-libvirt-virtualization/tasks/main.yml` | `.gitlab/ci/uc-lnx-002.yml` | `docs/runbooks/uc-lnx-002.md` |
| 6 | [UC-LNX-003: VM Provisioning with cloud-init](use-cases/linux/UC-LNX-003-vm-provisioning-cloud-init.md) | `contracts/uc-lnx-003.yaml` | `roles/vm-provisioning-cloud-init/tasks/main.yml` | `.gitlab/ci/uc-lnx-003.yml` | `docs/runbooks/uc-lnx-003.md` |
| 6 | [UC-LNX-006: Operating-System Patching](use-cases/linux/UC-LNX-006-operating-system-patching.md) | `contracts/uc-lnx-006.yaml` | `roles/operating-system-patching/tasks/main.yml` | `.gitlab/ci/uc-lnx-006.yml` | `docs/runbooks/uc-lnx-006.md` |
| 6 | [UC-LNX-007: Kernel and Major-Version Upgrades](use-cases/linux/UC-LNX-007-kernel-major-version-upgrades.md) | `contracts/uc-lnx-007.yaml` | `roles/kernel-major-version-upgrades/tasks/main.yml` | `.gitlab/ci/uc-lnx-007.yml` | `docs/runbooks/uc-lnx-007.md` |
| 6 | [UC-LNX-009: systemd Service Management](use-cases/linux/UC-LNX-009-systemd-service-management.md) | `contracts/uc-lnx-009.yaml` | `roles/systemd-service-management/tasks/main.yml` | `.gitlab/ci/uc-lnx-009.yml` | `docs/runbooks/uc-lnx-009.md` |
| 6 | [UC-LNX-010: Filesystem, LVM and Storage Management](use-cases/linux/UC-LNX-010-filesystem-lvm-storage-management.md) | `contracts/uc-lnx-010.yaml` | `roles/filesystem-lvm-storage-management/tasks/main.yml` | `.gitlab/ci/uc-lnx-010.yml` | `docs/runbooks/uc-lnx-010.md` |
| 6 | [UC-LNX-012: SSH, sudo and Service Accounts](use-cases/linux/UC-LNX-012-ssh-sudo-service-accounts.md) | `contracts/uc-lnx-012.yaml` | `roles/ssh-sudo-service-accounts/tasks/main.yml` | `.gitlab/ci/uc-lnx-012.yml` | `docs/runbooks/uc-lnx-012.md` |
| 6 | [UC-LNX-013: Package Repository Management](use-cases/linux/UC-LNX-013-package-repository-management.md) | `contracts/uc-lnx-013.yaml` | `roles/package-repository-management/tasks/main.yml` | `.gitlab/ci/uc-lnx-013.yml` | `docs/runbooks/uc-lnx-013.md` |
| 6 | [UC-LNX-014: Performance and Capacity Troubleshooting](use-cases/linux/UC-LNX-014-performance-capacity-troubleshooting.md) | `contracts/uc-lnx-014.yaml` | `roles/performance-capacity-troubleshooting/tasks/main.yml` | `.gitlab/ci/uc-lnx-014.yml` | `docs/runbooks/uc-lnx-014.md` |
| 6 | [UC-LNX-015: Configuration-Drift Detection](use-cases/linux/UC-LNX-015-configuration-drift-detection.md) | `contracts/uc-lnx-015.yaml` | `roles/configuration-drift-detection/tasks/main.yml` | `.gitlab/ci/uc-lnx-015.yml` | `docs/runbooks/uc-lnx-015.md` |
| 6 | [UC-LNX-016: Server Compliance Evidence](use-cases/linux/UC-LNX-016-server-compliance-evidence.md) | `contracts/uc-lnx-016.yaml` | `roles/server-compliance-evidence/tasks/main.yml` | `.gitlab/ci/uc-lnx-016.yml` | `docs/runbooks/uc-lnx-016.md` |
| 6 | [UC-LNX-017: Break-Glass Recovery](use-cases/linux/UC-LNX-017-break-glass-recovery.md) | `contracts/uc-lnx-017.yaml` | `roles/break-glass-recovery/tasks/main.yml` | `.gitlab/ci/uc-lnx-017.yml` | `docs/runbooks/uc-lnx-017.md` |
| 6 | [UC-LNX-018: Linux Automation and Tooling Development](use-cases/linux/UC-LNX-018-linux-automation-tooling-development.md) | `contracts/uc-lnx-018.yaml` | `roles/linux-automation-tooling-development/tasks/main.yml` | `.gitlab/ci/uc-lnx-018.yml` | `docs/runbooks/uc-lnx-018.md` |
| 6 | [UC-LNX-019: Linux Monitoring and Incident Operations](use-cases/linux/UC-LNX-019-linux-monitoring-incident-operations.md) | `contracts/uc-lnx-019.yaml` | `roles/linux-monitoring-incident-operations/tasks/main.yml` | `.gitlab/ci/uc-lnx-019.yml` | `docs/runbooks/uc-lnx-019.md` |
| 6 | [UC-LNX-022: Vulnerability Remediation Lifecycle](use-cases/linux/UC-LNX-022-vulnerability-remediation-lifecycle.md) | `contracts/uc-lnx-022.yaml` | `roles/vulnerability-remediation-lifecycle/tasks/main.yml` | `.gitlab/ci/uc-lnx-022.yml` | `docs/runbooks/uc-lnx-022.md` |
| 6 | [UC-LNX-024: Git-Based Linux Change Validation](use-cases/linux/UC-LNX-024-git-based-linux-change-validation.md) | `contracts/uc-lnx-024.yaml` | `roles/git-based-linux-change-validation/tasks/main.yml` | `.gitlab/ci/uc-lnx-024.yml` | `docs/runbooks/uc-lnx-024.md` |
| 7 | [UC-LNX-004: Server Build and Retirement](use-cases/linux/UC-LNX-004-server-build-retirement.md) | `contracts/uc-lnx-004.yaml` | `roles/server-build-retirement/tasks/main.yml` | `.gitlab/ci/uc-lnx-004.yml` | `docs/runbooks/uc-lnx-004.md` |
| 7 | [UC-LNX-021: Enterprise Identity Integration](use-cases/linux/UC-LNX-021-enterprise-identity-integration.md) | `contracts/uc-lnx-021.yaml` | `roles/enterprise-identity-integration/tasks/main.yml` | `.gitlab/ci/uc-lnx-021.yml` | `docs/runbooks/uc-lnx-021.md` |
| 9 | [UC-LNX-023: Backup, Restore, Disaster Recovery and HA Testing](use-cases/linux/UC-LNX-023-backup-restore-disaster-recovery-ha-testing.md) | `contracts/uc-lnx-023.yaml` | `roles/backup-restore-disaster-recovery-ha-testing/tasks/main.yml` | `.gitlab/ci/uc-lnx-023.yml` | `docs/runbooks/uc-lnx-023.md` |

### `midhhealth/platform-engineering/network-engineering-platform`

| Wave | Use case | Contract | Primary implementation | GitLab source gate | Recovery runbook |
| ---: | --- | --- | --- | --- | --- |
| 1 | [UC-NET-003: VLAN and Subnet Design](use-cases/network/UC-NET-003-vlan-and-subnet-design.md) | `contracts/uc-net-003.yaml` | `playbooks/vlan-and-subnet-design.yml` | `.gitlab/ci/uc-net-003.yml` | `docs/runbooks/uc-net-003.md` |
| 2 | [UC-NET-005: Authoritative and Recursive DNS](use-cases/network/UC-NET-005-authoritative-and-recursive-dns.md) | `contracts/uc-net-005.yaml` | `playbooks/authoritative-and-recursive-dns.yml` | `.gitlab/ci/uc-net-005.yml` | `docs/runbooks/uc-net-005.md` |
| 2 | [UC-NET-012: Firewall Policy Management](use-cases/network/UC-NET-012-firewall-policy-management.md) | `contracts/uc-net-012.yaml` | `playbooks/firewall-policy-management.yml` | `.gitlab/ci/uc-net-012.yml` | `docs/runbooks/uc-net-012.md` |
| 3 | [UC-NET-002: Enterprise IP Address Management](use-cases/network/UC-NET-002-enterprise-ip-address-management.md) | `contracts/uc-net-002.yaml` | `playbooks/enterprise-ip-address-management.yml` | `.gitlab/ci/uc-net-002.yml` | `docs/runbooks/uc-net-002.md` |
| 3 | [UC-NET-004: DHCP Reservation Management](use-cases/network/UC-NET-004-dhcp-reservation-management.md) | `contracts/uc-net-004.yaml` | `playbooks/dhcp-reservation-management.yml` | `.gitlab/ci/uc-net-004.yml` | `docs/runbooks/uc-net-004.md` |
| 3 | [UC-NET-010: Layer 2 Bridge Management](use-cases/network/UC-NET-010-layer-2-bridge-management.md) | `contracts/uc-net-010.yaml` | `playbooks/layer-2-bridge-management.yml` | `.gitlab/ci/uc-net-010.yml` | `docs/runbooks/uc-net-010.md` |
| 3 | [UC-NET-011: Layer 3 Routing](use-cases/network/UC-NET-011-layer-3-routing.md) | `contracts/uc-net-011.yaml` | `playbooks/layer-3-routing.yml` | `.gitlab/ci/uc-net-011.yml` | `docs/runbooks/uc-net-011.md` |
| 3 | [UC-NET-015: VPN and Remote Access](use-cases/network/UC-NET-015-vpn-and-remote-access.md) | `contracts/uc-net-015.yaml` | `playbooks/vpn-and-remote-access.yml` | `.gitlab/ci/uc-net-015.yml` | `docs/runbooks/uc-net-015.md` |
| 3 | [UC-NET-018: Kubernetes Networking](use-cases/network/UC-NET-018-kubernetes-networking.md) | `contracts/uc-net-018.yaml` | `playbooks/kubernetes-networking.yml` | `.gitlab/ci/uc-net-018.yml` | `docs/runbooks/uc-net-018.md` |
| 4 | [UC-NET-020: Ingress and Egress Controls](use-cases/network/UC-NET-020-ingress-and-egress-controls.md) | `contracts/uc-net-020.yaml` | `playbooks/ingress-and-egress-controls.yml` | `.gitlab/ci/uc-net-020.yml` | `docs/runbooks/uc-net-020.md` |
| 4 | [UC-NET-024: Certificate and TLS Routing](use-cases/network/UC-NET-024-certificate-and-tls-routing.md) | `contracts/uc-net-024.yaml` | `playbooks/certificate-and-tls-routing.yml` | `.gitlab/ci/uc-net-024.yml` | `docs/runbooks/uc-net-024.md` |
| 5 | [UC-NET-006: Forward and Reverse DNS Automation](use-cases/network/UC-NET-006-forward-and-reverse-dns-automation.md) | `contracts/uc-net-006.yaml` | `playbooks/forward-and-reverse-dns-automation.yml` | `.gitlab/ci/uc-net-006.yml` | `docs/runbooks/uc-net-006.md` |
| 5 | [UC-NET-013: NAT and Egress Management](use-cases/network/UC-NET-013-nat-and-egress-management.md) | `contracts/uc-net-013.yaml` | `playbooks/nat-and-egress-management.yml` | `.gitlab/ci/uc-net-013.yml` | `docs/runbooks/uc-net-013.md` |
| 5 | [UC-NET-019: CNI Policy and Troubleshooting](use-cases/network/UC-NET-019-cni-policy-and-troubleshooting.md) | `contracts/uc-net-019.yaml` | `playbooks/cni-policy-and-troubleshooting.yml` | `.gitlab/ci/uc-net-019.yml` | `docs/runbooks/uc-net-019.md` |
| 5 | [UC-NET-022: Network Segmentation](use-cases/network/UC-NET-022-network-segmentation.md) | `contracts/uc-net-022.yaml` | `playbooks/network-segmentation.yml` | `.gitlab/ci/uc-net-022.yml` | `docs/runbooks/uc-net-022.md` |
| 5 | [UC-NET-023: Private Endpoint and Private DNS](use-cases/network/UC-NET-023-private-endpoint-and-private-dns.md) | `contracts/uc-net-023.yaml` | `playbooks/private-endpoint-and-private-dns.yml` | `.gitlab/ci/uc-net-023.yml` | `docs/runbooks/uc-net-023.md` |
| 5 | [UC-NET-028: Network Availability Testing](use-cases/network/UC-NET-028-network-availability-testing.md) | `contracts/uc-net-028.yaml` | `playbooks/network-availability-testing.yml` | `.gitlab/ci/uc-net-028.yml` | `docs/runbooks/uc-net-028.md` |
| 6 | [UC-NET-001: Network Change Validation and Rollback](use-cases/network/UC-NET-001-network-change-validation.md) | `contracts/uc-net-001.yaml` | `playbooks/network-change-validation.yml` | `.gitlab/ci/uc-net-001.yml` | `docs/runbooks/uc-net-001.md` |
| 6 | [UC-NET-008: Network Configuration Automation](use-cases/network/UC-NET-008-network-configuration-automation.md) | `contracts/uc-net-008.yaml` | `playbooks/network-configuration-automation.yml` | `.gitlab/ci/uc-net-008.yml` | `docs/runbooks/uc-net-008.md` |
| 6 | [UC-NET-009: Network Configuration-Drift Detection](use-cases/network/UC-NET-009-network-configuration-drift-detection.md) | `contracts/uc-net-009.yaml` | `playbooks/network-configuration-drift-detection.yml` | `.gitlab/ci/uc-net-009.yml` | `docs/runbooks/uc-net-009.md` |
| 6 | [UC-NET-014: Load Balancer and Reverse Proxy Configuration](use-cases/network/UC-NET-014-load-balancer-and-reverse-proxy-configuration.md) | `contracts/uc-net-014.yaml` | `playbooks/load-balancer-and-reverse-proxy-configuration.yml` | `.gitlab/ci/uc-net-014.yml` | `docs/runbooks/uc-net-014.md` |
| 6 | [UC-NET-016: Cloud VPC and VNet Networking](use-cases/network/UC-NET-016-cloud-vpc-and-vnet-networking.md) | `contracts/uc-net-016.yaml` | `playbooks/cloud-vpc-and-vnet-networking.yml` | `.gitlab/ci/uc-net-016.yml` | `docs/runbooks/uc-net-016.md` |
| 6 | [UC-NET-017: Hybrid-Cloud Connectivity](use-cases/network/UC-NET-017-hybrid-cloud-connectivity.md) | `contracts/uc-net-017.yaml` | `playbooks/hybrid-cloud-connectivity.yml` | `.gitlab/ci/uc-net-017.yml` | `docs/runbooks/uc-net-017.md` |
| 6 | [UC-NET-021: MetalLB Address Management](use-cases/network/UC-NET-021-metallb-address-management.md) | `contracts/uc-net-021.yaml` | `playbooks/metallb-address-management.yml` | `.gitlab/ci/uc-net-021.yml` | `docs/runbooks/uc-net-021.md` |
| 6 | [UC-NET-025: Network Performance Monitoring](use-cases/network/UC-NET-025-network-performance-monitoring.md) | `contracts/uc-net-025.yaml` | `playbooks/network-performance-monitoring.yml` | `.gitlab/ci/uc-net-025.yml` | `docs/runbooks/uc-net-025.md` |
| 6 | [UC-NET-026: Flow-Log Analysis](use-cases/network/UC-NET-026-flow-log-analysis.md) | `contracts/uc-net-026.yaml` | `playbooks/flow-log-analysis.yml` | `.gitlab/ci/uc-net-026.yml` | `docs/runbooks/uc-net-026.md` |
| 6 | [UC-NET-027: Packet Capture and Troubleshooting](use-cases/network/UC-NET-027-packet-capture-and-troubleshooting.md) | `contracts/uc-net-027.yaml` | `playbooks/packet-capture-and-troubleshooting.yml` | `.gitlab/ci/uc-net-027.yml` | `docs/runbooks/uc-net-027.md` |
| 6 | [UC-NET-029: Network Configuration Compliance](use-cases/network/UC-NET-029-network-configuration-compliance.md) | `contracts/uc-net-029.yaml` | `playbooks/network-configuration-compliance.yml` | `.gitlab/ci/uc-net-029.yml` | `docs/runbooks/uc-net-029.md` |
| 6 | [UC-NET-030: Network Incident Response](use-cases/network/UC-NET-030-network-incident-response.md) | `contracts/uc-net-030.yaml` | `playbooks/network-incident-response.yml` | `.gitlab/ci/uc-net-030.yml` | `docs/runbooks/uc-net-030.md` |
| 6 | [UC-NET-031: Capacity and Bandwidth Planning](use-cases/network/UC-NET-031-capacity-and-bandwidth-planning.md) | `contracts/uc-net-031.yaml` | `playbooks/capacity-and-bandwidth-planning.yml` | `.gitlab/ci/uc-net-031.yml` | `docs/runbooks/uc-net-031.md` |
| 7 | [UC-NET-007: Router and Switch Configuration Backup](use-cases/network/UC-NET-007-router-and-switch-configuration-backup.md) | `contracts/uc-net-007.yaml` | `playbooks/router-and-switch-configuration-backup.yml` | `.gitlab/ci/uc-net-007.yml` | `docs/runbooks/uc-net-007.md` |

### `midhhealth/reliability-operations/observability-sre-platform`

| Wave | Use case | Contract | Primary implementation | GitLab source gate | Recovery runbook |
| ---: | --- | --- | --- | --- | --- |
| 3 | [UC-OBS-001: SLO as Code](use-cases/observability/UC-OBS-001-slo-as-code.md) | `contracts/uc-obs-001.yaml` | `rules/slo-as-code.yaml` | `.gitlab/ci/uc-obs-001.yml` | `docs/runbooks/uc-obs-001.md` |
| 3 | [UC-OBS-003: OpenTelemetry Auto-Instrumentation](use-cases/observability/UC-OBS-003-opentelemetry-auto-instrumentation.md) | `contracts/uc-obs-003.yaml` | `rules/opentelemetry-auto-instrumentation.yaml` | `.gitlab/ci/uc-obs-003.yml` | `docs/runbooks/uc-obs-003.md` |
| 4 | [UC-OBS-004: Centralized Log Management](use-cases/observability/UC-OBS-004-centralized-log-management.md) | `contracts/uc-obs-004.yaml` | `rules/centralized-log-management.yaml` | `.gitlab/ci/uc-obs-004.yml` | `docs/runbooks/uc-obs-004.md` |
| 4 | [UC-OBS-009: API Error Rate Monitoring](use-cases/observability/UC-OBS-009-api-error-rate-monitoring.md) | `contracts/uc-obs-009.yaml` | `rules/api-error-rate-monitoring.yaml` | `.gitlab/ci/uc-obs-009.yml` | `docs/runbooks/uc-obs-009.md` |
| 5 | [UC-OBS-002: Kubernetes Cluster Health Monitoring](use-cases/observability/UC-OBS-002-kubernetes-cluster-health-monitoring.md) | `contracts/uc-obs-002.yaml` | `rules/kubernetes-cluster-health-monitoring.yaml` | `.gitlab/ci/uc-obs-002.yml` | `docs/runbooks/uc-obs-002.md` |
| 5 | [UC-OBS-008: Deployment Health Scoring](use-cases/observability/UC-OBS-008-deployment-health-scoring.md) | `contracts/uc-obs-008.yaml` | `rules/deployment-health-scoring.yaml` | `.gitlab/ci/uc-obs-008.yml` | `docs/runbooks/uc-obs-008.md` |
| 5 | [UC-OBS-012: Synthetic Monitoring](use-cases/observability/UC-OBS-012-synthetic-monitoring.md) | `contracts/uc-obs-012.yaml` | `rules/synthetic-monitoring.yaml` | `.gitlab/ci/uc-obs-012.yml` | `docs/runbooks/uc-obs-012.md` |
| 5 | [UC-OBS-014: Change-to-Incident Correlation](use-cases/observability/UC-OBS-014-change-to-incident-correlation.md) | `contracts/uc-obs-014.yaml` | `rules/change-to-incident-correlation.yaml` | `.gitlab/ci/uc-obs-014.yml` | `docs/runbooks/uc-obs-014.md` |
| 5 | [UC-OBS-016: Burn-Rate Alerting](use-cases/observability/UC-OBS-016-burn-rate-alerting.md) | `contracts/uc-obs-016.yaml` | `rules/burn-rate-alerting.yaml` | `.gitlab/ci/uc-obs-016.yml` | `docs/runbooks/uc-obs-016.md` |
| 6 | [UC-OBS-006: Alerting and On-Call Notification](use-cases/observability/UC-OBS-006-alerting-and-on-call-notification.md) | `contracts/uc-obs-006.yaml` | `rules/alerting-and-on-call-notification.yaml` | `.gitlab/ci/uc-obs-006.yml` | `docs/runbooks/uc-obs-006.md` |
| 6 | [UC-OBS-007: Production Incident Troubleshooting Dashboard](use-cases/observability/UC-OBS-007-production-incident-troubleshooting-dashboard.md) | `contracts/uc-obs-007.yaml` | `rules/production-incident-troubleshooting-dashboard.yaml` | `.gitlab/ci/uc-obs-007.yml` | `docs/runbooks/uc-obs-007.md` |
| 6 | [UC-OBS-015: Automated Incident Triage](use-cases/observability/UC-OBS-015-automated-incident-triage.md) | `contracts/uc-obs-015.yaml` | `rules/automated-incident-triage.yaml` | `.gitlab/ci/uc-obs-015.yml` | `docs/runbooks/uc-obs-015.md` |
| 7 | [UC-OBS-005: eBPF Observability](use-cases/observability/UC-OBS-005-ebpf-observability.md) | `contracts/uc-obs-005.yaml` | `rules/ebpf-observability.yaml` | `.gitlab/ci/uc-obs-005.yml` | `docs/runbooks/uc-obs-005.md` |
| 8 | [UC-OBS-010: Database Performance Monitoring](use-cases/observability/UC-OBS-010-database-performance-monitoring.md) | `contracts/uc-obs-010.yaml` | `rules/database-performance-monitoring.yaml` | `.gitlab/ci/uc-obs-010.yml` | `docs/runbooks/uc-obs-010.md` |
| 8 | [UC-OBS-013: Cloud-Native Monitoring](use-cases/observability/UC-OBS-013-cloud-native-monitoring.md) | `contracts/uc-obs-013.yaml` | `rules/cloud-native-monitoring.yaml` | `.gitlab/ci/uc-obs-013.yml` | `docs/runbooks/uc-obs-013.md` |
| 10 | [UC-OBS-011: Telemetry Cost Optimization](use-cases/observability/UC-OBS-011-telemetry-cost-optimization.md) | `contracts/uc-obs-011.yaml` | `rules/telemetry-cost-optimization.yaml` | `.gitlab/ci/uc-obs-011.yml` | `docs/runbooks/uc-obs-011.md` |

### `midhhealth/reliability-operations/resilience-service-operations`

| Wave | Use case | Contract | Primary implementation | GitLab source gate | Recovery runbook |
| ---: | --- | --- | --- | --- | --- |
| 1 | [UC-RSO-009: Service Ownership](use-cases/resilience/UC-RSO-009-service-ownership.md) | `contracts/uc-rso-009.yaml` | `playbooks/service-ownership.yml` | `.gitlab/ci/uc-rso-009.yml` | `docs/runbooks/uc-rso-009.md` |
| 2 | [UC-RSO-010: Dependency Mapping](use-cases/resilience/UC-RSO-010-dependency-mapping.md) | `contracts/uc-rso-010.yaml` | `playbooks/dependency-mapping.yml` | `.gitlab/ci/uc-rso-010.yml` | `docs/runbooks/uc-rso-010.md` |
| 3 | [UC-RSO-015: Backup and Recovery Orchestration](use-cases/resilience/UC-RSO-015-backup-and-recovery-orchestration.md) | `contracts/uc-rso-015.yaml` | `playbooks/backup-and-recovery-orchestration.yml` | `.gitlab/ci/uc-rso-015.yml` | `docs/runbooks/uc-rso-015.md` |
| 4 | [UC-RSO-001: Operational Readiness Review](use-cases/resilience/UC-RSO-001-operational-readiness-review.md) | `contracts/uc-rso-001.yaml` | `playbooks/operational-readiness-review.yml` | `.gitlab/ci/uc-rso-001.yml` | `docs/runbooks/uc-rso-001.md` |
| 4 | [UC-RSO-002: SLI and SLO Governance](use-cases/resilience/UC-RSO-002-sli-and-slo-governance.md) | `contracts/uc-rso-002.yaml` | `playbooks/sli-and-slo-governance.yml` | `.gitlab/ci/uc-rso-002.yml` | `docs/runbooks/uc-rso-002.md` |
| 4 | [UC-RSO-004: Incident Detection and Classification](use-cases/resilience/UC-RSO-004-incident-detection-and-classification.md) | `contracts/uc-rso-004.yaml` | `playbooks/incident-detection-and-classification.yml` | `.gitlab/ci/uc-rso-004.yml` | `docs/runbooks/uc-rso-004.md` |
| 4 | [UC-RSO-008: Problem Management](use-cases/resilience/UC-RSO-008-problem-management.md) | `contracts/uc-rso-008.yaml` | `playbooks/problem-management.yml` | `.gitlab/ci/uc-rso-008.yml` | `docs/runbooks/uc-rso-008.md` |
| 4 | [UC-RSO-011: Synthetic Monitoring](use-cases/resilience/UC-RSO-011-synthetic-monitoring.md) | `contracts/uc-rso-011.yaml` | `playbooks/synthetic-monitoring.yml` | `.gitlab/ci/uc-rso-011.yml` | `docs/runbooks/uc-rso-011.md` |
| 4 | [UC-RSO-012: Capacity and Saturation Testing](use-cases/resilience/UC-RSO-012-capacity-and-saturation-testing.md) | `contracts/uc-rso-012.yaml` | `playbooks/capacity-and-saturation-testing.yml` | `.gitlab/ci/uc-rso-012.yml` | `docs/runbooks/uc-rso-012.md` |
| 4 | [UC-RSO-013: Load and Performance Testing](use-cases/resilience/UC-RSO-013-load-and-performance-testing.md) | `contracts/uc-rso-013.yaml` | `playbooks/load-and-performance-testing.yml` | `.gitlab/ci/uc-rso-013.yml` | `docs/runbooks/uc-rso-013.md` |
| 4 | [UC-RSO-014: Chaos and Failure Exercises](use-cases/resilience/UC-RSO-014-chaos-and-failure-exercises.md) | `contracts/uc-rso-014.yaml` | `playbooks/chaos-and-failure-exercises.yml` | `.gitlab/ci/uc-rso-014.yml` | `docs/runbooks/uc-rso-014.md` |
| 4 | [UC-RSO-016: Disaster-Recovery Exercises](use-cases/resilience/UC-RSO-016-disaster-recovery-exercises.md) | `contracts/uc-rso-016.yaml` | `playbooks/disaster-recovery-exercises.yml` | `.gitlab/ci/uc-rso-016.yml` | `docs/runbooks/uc-rso-016.md` |
| 4 | [UC-RSO-018: Certificate and Secret Expiry Response](use-cases/resilience/UC-RSO-018-certificate-and-secret-expiry-response.md) | `contracts/uc-rso-018.yaml` | `playbooks/certificate-and-secret-expiry-response.yml` | `.gitlab/ci/uc-rso-018.yml` | `docs/runbooks/uc-rso-018.md` |
| 4 | [UC-RSO-019: AWX Automated Remediation](use-cases/resilience/UC-RSO-019-awx-automated-remediation.md) | `contracts/uc-rso-019.yaml` | `playbooks/awx-automated-remediation.yml` | `.gitlab/ci/uc-rso-019.yml` | `docs/runbooks/uc-rso-019.md` |
| 4 | [UC-RSO-020: Maintenance-Window Management](use-cases/resilience/UC-RSO-020-maintenance-window-management.md) | `contracts/uc-rso-020.yaml` | `playbooks/maintenance-window-management.yml` | `.gitlab/ci/uc-rso-020.yml` | `docs/runbooks/uc-rso-020.md` |
| 5 | [UC-RSO-003: Error-Budget Management](use-cases/resilience/UC-RSO-003-error-budget-management.md) | `contracts/uc-rso-003.yaml` | `playbooks/error-budget-management.yml` | `.gitlab/ci/uc-rso-003.yml` | `docs/runbooks/uc-rso-003.md` |
| 5 | [UC-RSO-005: On-Call and Escalation Workflows](use-cases/resilience/UC-RSO-005-on-call-and-escalation-workflows.md) | `contracts/uc-rso-005.yaml` | `playbooks/on-call-and-escalation-workflows.yml` | `.gitlab/ci/uc-rso-005.yml` | `docs/runbooks/uc-rso-005.md` |
| 5 | [UC-RSO-021: Dependency Failure Containment](use-cases/resilience/UC-RSO-021-dependency-failure-containment.md) | `contracts/uc-rso-021.yaml` | `src/dependency_resilience/evaluate.py` | `.gitlab/ci/uc-rso-021.yml` | `docs/runbooks/uc-rso-021.md` |
| 6 | [UC-RSO-006: Automated Incident Evidence Collection](use-cases/resilience/UC-RSO-006-automated-incident-evidence-collection.md) | `contracts/uc-rso-006.yaml` | `playbooks/automated-incident-evidence-collection.yml` | `.gitlab/ci/uc-rso-006.yml` | `docs/runbooks/uc-rso-006.md` |
| 6 | [UC-RSO-007: Post-Incident Review](use-cases/resilience/UC-RSO-007-post-incident-review.md) | `contracts/uc-rso-007.yaml` | `playbooks/post-incident-review.yml` | `.gitlab/ci/uc-rso-007.yml` | `docs/runbooks/uc-rso-007.md` |
| 8 | [UC-RSO-017: RTO and RPO Measurement](use-cases/resilience/UC-RSO-017-rto-and-rpo-measurement.md) | `contracts/uc-rso-017.yaml` | `playbooks/rto-and-rpo-measurement.yml` | `.gitlab/ci/uc-rso-017.yml` | `docs/runbooks/uc-rso-017.md` |

### `midhhealth/security-governance/cloud-governance-ops-automation`

| Wave | Use case | Contract | Primary implementation | GitLab source gate | Recovery runbook |
| ---: | --- | --- | --- | --- | --- |
| 2 | [UC-GOV-004: Cloud IAM and RBAC Standardization](use-cases/governance/UC-GOV-004-cloud-iam-and-rbac-standardization.md) | `contracts/uc-gov-004.yaml` | `playbooks/cloud-iam-and-rbac-standardization.yml` | `.gitlab/ci/uc-gov-004.yml` | `docs/runbooks/uc-gov-004.md` |
| 3 | [UC-GOV-002: Secrets Management Automation](use-cases/governance/UC-GOV-002-secrets-management-automation.md) | `contracts/uc-gov-002.yaml` | `playbooks/secrets-management-automation.yml` | `.gitlab/ci/uc-gov-002.yml` | `docs/runbooks/uc-gov-002.md` |
| 4 | [UC-GOV-003: Secure Secrets Management for Applications](use-cases/governance/UC-GOV-003-secure-secrets-management-for-applications.md) | `contracts/uc-gov-003.yaml` | `playbooks/secure-secrets-management-for-applications.yml` | `.gitlab/ci/uc-gov-003.yml` | `docs/runbooks/uc-gov-003.md` |
| 4 | [UC-GOV-005: Secrets Management with Key Vault](use-cases/governance/UC-GOV-005-secrets-management-with-key-vault.md) | `contracts/uc-gov-005.yaml` | `playbooks/secrets-management-with-key-vault.yml` | `.gitlab/ci/uc-gov-005.yml` | `docs/runbooks/uc-gov-005.md` |
| 5 | [UC-GOV-009: DNS and Certificate Management](use-cases/governance/UC-GOV-009-dns-and-certificate-management.md) | `contracts/uc-gov-009.yaml` | `playbooks/dns-and-certificate-management.yml` | `.gitlab/ci/uc-gov-009.yml` | `docs/runbooks/uc-gov-009.md` |
| 5 | [UC-GOV-010: Certificate Expiry Monitoring](use-cases/governance/UC-GOV-010-certificate-expiry-monitoring.md) | `contracts/uc-gov-010.yaml` | `playbooks/certificate-expiry-monitoring.yml` | `.gitlab/ci/uc-gov-010.yml` | `docs/runbooks/uc-gov-010.md` |
| 6 | [UC-GOV-008: Private Endpoint Implementation](use-cases/governance/UC-GOV-008-private-endpoint-implementation.md) | `contracts/uc-gov-008.yaml` | `playbooks/private-endpoint-implementation.yml` | `.gitlab/ci/uc-gov-008.yml` | `docs/runbooks/uc-gov-008.md` |
| 6 | [UC-GOV-011: Runbook Automation](use-cases/governance/UC-GOV-011-runbook-automation.md) | `contracts/uc-gov-011.yaml` | `playbooks/runbook-automation.yml` | `.gitlab/ci/uc-gov-011.yml` | `docs/runbooks/uc-gov-011.md` |
| 7 | [UC-GOV-012: Event-Driven Remediation](use-cases/governance/UC-GOV-012-event-driven-remediation.md) | `contracts/uc-gov-012.yaml` | `playbooks/event-driven-remediation.yml` | `.gitlab/ci/uc-gov-012.yml` | `docs/runbooks/uc-gov-012.md` |
| 7 | [UC-GOV-018: Automated Root-Cause Analysis](use-cases/governance/UC-GOV-018-automated-root-cause-analysis.md) | `contracts/uc-gov-018.yaml` | `playbooks/automated-root-cause-analysis.yml` | `.gitlab/ci/uc-gov-018.yml` | `docs/runbooks/uc-gov-018.md` |
| 7 | [UC-GOV-019: Intelligent Alert Deduplication](use-cases/governance/UC-GOV-019-intelligent-alert-deduplication.md) | `contracts/uc-gov-019.yaml` | `playbooks/intelligent-alert-deduplication.yml` | `.gitlab/ci/uc-gov-019.yml` | `docs/runbooks/uc-gov-019.md` |
| 8 | [UC-GOV-001: Automated Compliance Evidence Collection](use-cases/governance/UC-GOV-001-compliance-evidence-collection.md) | `contracts/uc-gov-001.yaml` | `playbooks/compliance-evidence-collection.yml` | `.gitlab/ci/uc-gov-001.yml` | `docs/runbooks/uc-gov-001.md` |
| 8 | [UC-GOV-013: Human-in-the-Loop Remediation](use-cases/governance/UC-GOV-013-human-in-the-loop-remediation.md) | `contracts/uc-gov-013.yaml` | `playbooks/human-in-the-loop-remediation.yml` | `.gitlab/ci/uc-gov-013.yml` | `docs/runbooks/uc-gov-013.md` |
| 9 | [UC-GOV-007: Infrastructure Security Hardening](use-cases/governance/UC-GOV-007-infrastructure-security-hardening.md) | `contracts/uc-gov-007.yaml` | `playbooks/infrastructure-security-hardening.yml` | `.gitlab/ci/uc-gov-007.yml` | `docs/runbooks/uc-gov-007.md` |
| 9 | [UC-GOV-014: Closed-Loop Automation](use-cases/governance/UC-GOV-014-closed-loop-automation.md) | `contracts/uc-gov-014.yaml` | `playbooks/closed-loop-automation.yml` | `.gitlab/ci/uc-gov-014.yml` | `docs/runbooks/uc-gov-014.md` |
| 9 | [UC-GOV-016: Cloud Cost Anomaly Detection](use-cases/governance/UC-GOV-016-cloud-cost-anomaly-detection.md) | `contracts/uc-gov-016.yaml` | `playbooks/cloud-cost-anomaly-detection.yml` | `.gitlab/ci/uc-gov-016.yml` | `docs/runbooks/uc-gov-016.md` |
| 10 | [UC-GOV-015: Self-Healing Infrastructure](use-cases/governance/UC-GOV-015-self-healing-infrastructure.md) | `contracts/uc-gov-015.yaml` | `playbooks/self-healing-infrastructure.yml` | `.gitlab/ci/uc-gov-015.yml` | `docs/runbooks/uc-gov-015.md` |
| 10 | [UC-GOV-017: Resource Right-Sizing Automation](use-cases/governance/UC-GOV-017-resource-right-sizing-automation.md) | `contracts/uc-gov-017.yaml` | `playbooks/resource-right-sizing-automation.yml` | `.gitlab/ci/uc-gov-017.yml` | `docs/runbooks/uc-gov-017.md` |
| 11 | [UC-GOV-006: Cloud Misconfiguration Detector](use-cases/governance/UC-GOV-006-cloud-misconfiguration-detector.md) | `contracts/uc-gov-006.yaml` | `playbooks/cloud-misconfiguration-detector.yml` | `.gitlab/ci/uc-gov-006.yml` | `docs/runbooks/uc-gov-006.md` |

## Handoff rule

Before a row is started, its required contracts must be available from earlier waves in
the [dependency-safe implementation sequence](use-case-implementation-sequence.md). The
team then creates or confirms only the six planned paths inside the named project. If the
project, ownership, runner, target, product, or identity does not match current inventory,
the implementation stops and the design record is corrected; the discrepancy is not solved
by silently creating infrastructure or moving the work to another repository.

Application repositories remain separate. They consume published platform contracts through
the application deployment register; platform source must not be copied into an application
project, and placeholder provider or payer applications must not be invented.
