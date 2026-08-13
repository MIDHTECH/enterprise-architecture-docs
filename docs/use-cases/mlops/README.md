# Enterprise MLOps Model Platform: Detailed Use Cases

Last verified: 2026-08-13

This index contains all 15 canonical use cases owned by the
Enterprise MLOps Model Platform. Together they make model lifecycle evidence reproducible before any model can affect an enterprise workflow. Implementation belongs
in `midhhealth/ai-and-ml-platform/mlops-model-platform` and must reuse existing GitLab shared runner, synthetic datasets, locked dependencies, and protected CI artifacts.

No page in this directory authorizes a new registry service, feature store, model server, VM, cluster workload, cloud ML service, or live-data scoring. All pages begin as
planned specifications; their individual status changes only after source,
runtime, rollback, and evidence gates are met.

| ID | Use case | Canonical coverage |
| --- | --- | --- |
| `UC-MLOPS-002` | [ML Training Pipeline Standardization](UC-MLOPS-002-ml-training-pipeline-standardization.md) | Repeatable training workflows |
| `UC-MLOPS-003` | [Feature Engineering and Feature Stores](UC-MLOPS-003-feature-engineering-and-feature-stores.md) | Governed reusable features |
| `UC-MLOPS-001` | [Model Registry and Versioning](UC-MLOPS-001-model-registry-versioning.md) | Traceable model lineage and promotion |
| `UC-MLOPS-004` | [Model Validation Gates](UC-MLOPS-004-model-validation-gates.md) | Accuracy, fairness, safety and performance checks |
| `UC-MLOPS-005` | [CI/CT/CD for ML](UC-MLOPS-005-ci-ct-cd-for-ml.md) | Automated train, test, validate, deploy and promote workflows |
| `UC-MLOPS-006` | [Batch Inference](UC-MLOPS-006-batch-inference.md) | Scheduled scoring and downstream delivery |
| `UC-MLOPS-007` | [Real-Time Inference APIs](UC-MLOPS-007-real-time-inference-apis.md) | Low-latency model serving |
| `UC-MLOPS-008` | [Model Observability](UC-MLOPS-008-model-observability.md) | Latency, errors, throughput and quality signals |
| `UC-MLOPS-009` | [Drift Detection](UC-MLOPS-009-drift-detection.md) | Data, prediction and concept drift monitoring |
| `UC-MLOPS-010` | [Automated Retraining](UC-MLOPS-010-automated-retraining.md) | Controlled retraining triggers and approvals |
| `UC-MLOPS-011` | [Model Rollback](UC-MLOPS-011-model-rollback.md) | Safe recovery to a prior approved model |
| `UC-MLOPS-012` | [Experiment Tracking](UC-MLOPS-012-experiment-tracking.md) | Metrics, artifacts, parameters and reproducibility |
| `UC-MLOPS-013` | [ML Infrastructure as Code](UC-MLOPS-013-ml-infrastructure-as-code.md) | Reproducible cloud and Kubernetes model environments |
| `UC-MLOPS-014` | [Model Governance Evidence](UC-MLOPS-014-model-governance-evidence.md) | Audit records for regulated model operation |
| `UC-MLOPS-015` | [ML Incident Response](UC-MLOPS-015-ml-incident-response.md) | Runbooks for degraded, biased or unavailable models |

## GitLab handoff

1. Create the epic and stories from the selected page in `midhhealth/ai-and-ml-platform/mlops-model-platform`.
2. Implement only the planned paths that fit the repository and current lab.
3. Run fixture or read-only validation before requesting a mutating change.
4. Return commit, pipeline, Jenkins/AWX, runtime, recovery, and incident
   evidence to the architecture page.
5. Stop and request a separate architecture decision if new infrastructure,
   capacity, products, or protected-data integration would be required.

