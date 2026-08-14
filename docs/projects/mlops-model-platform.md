# MLOps Model Platform Domain

**Repository:** `midhhealth/ai-and-ml-platform/mlops-model-platform`  
**Team size:** 6 engineers

## Team Responsibilities

The MLOps team owns the lifecycle for machine-learning models used by clinical,
operational, financial, payer, and platform use cases.

| Team member | Primary responsibility |
| --- | --- |
| MLOps Platform Lead | Owns model lifecycle standards, promotion policy, governance evidence, and platform roadmap. |
| ML Pipeline Engineer | Builds training, validation, CI/CT/CD, batch scoring, and retraining workflows. |
| Feature Platform Engineer | Owns feature engineering, feature store patterns, feature quality, and reuse contracts. |
| Model Registry Engineer | Maintains model versioning, lineage, artifacts, approvals, rollback, and reproducibility. |
| Model Serving Engineer | Owns real-time inference APIs, batch inference, Kubernetes/cloud serving patterns, and performance. |
| Model Monitoring Engineer | Tracks model quality, latency, errors, drift, fairness, retraining triggers, and ML incident response. |

## Connected Teams

- Consumes curated data and features from data engineering and database reliability.
- Uses delivery, Kubernetes, infrastructure, observability, and governance controls for model promotion.
- Supports healthcare AI when assistants call model endpoints or use model-derived features.

## Outcome and control role

This team owns the reproducible technical lifecycle of a model. The consuming
product owner decides whether its predictions are suitable for the workflow;
MLOps makes the exact training inputs, evaluation, release, runtime behavior
and withdrawal path reviewable.

| Responsibility | MLOps-domain commitment |
| --- | --- |
| Decision owned | Register, validate, promote, serve, retrain, suspend or roll back a versioned model and feature contract. |
| Evidence consumed | Code, dataset and feature lineage, experiment configuration, intended use, validation policy, serving envelope and application acceptance criteria. |
| Evidence published | Reproducible run, model digest/version, metrics by approved cohort, lineage, approval, serving health, drift state and rollback target. |
| Safe-stop boundary | Missing lineage, failed quality/fairness/safety gate, incompatible feature, unexplained drift or unhealthy serving blocks promotion or returns to an approved version. |
| Outcomes measured | Reproducibility, validation pass quality, promotion time, serving latency/cost, drift response, rollback success and product outcome after acceptance. |

The lifecycle uses the common contract and evidence rules in the
[Cross-Platform Outcome and Control Framework](../cross-platform-outcome-control-framework.md).

## Executable Use-Case Scope

- Training pipeline standardization, feature stores, model registry/versioning, validation gates, and CI/CT/CD.
- Batch inference, real-time inference APIs, model observability, drift detection, retraining, and rollback.
- Experiment tracking, ML infrastructure as code, governance evidence, and ML incident response.

## The model lifecycle contract

MLOps exists so a model can be reproduced, judged, promoted, observed and
withdrawn without relying on a notebook or one engineer's memory. It does not
decide whether a clinical, payer or operational use of the model is appropriate;
the product and governance owners retain that decision.

![MLOps model platform architecture](../assets/project-12-mlops-model-architecture.svg)

The repository is scaffolded and runtime implementation is planned. There is no
accepted model registry, feature store, training cluster or serving platform in
the lab. The first slices therefore use small synthetic datasets, local
artifacts and manifests that can later map to an approved product without
claiming that product exists.

## Versioned objects

| Object | Identity that must be preserved |
| --- | --- |
| Dataset | Source, snapshot/range, schema, classification, quality result and lineage |
| Feature definition | Transformation code, inputs, point-in-time rule, owner and compatibility version |
| Training run | Code/environment revision, parameters, random seed, data/features and execution identity |
| Model artifact | Digest, format, framework/runtime compatibility and scan result |
| Evaluation | Test-set revision, metrics by slice, thresholds, safety/fairness review and decision |
| Deployment | Model and serving-image digests, configuration, target, approval and rollback predecessor |
| Observation | Prediction/input drift summaries, quality signals, latency/errors and model/release identity |

Experiment tracking records attempts; the registry records candidates and
their decisions. A model reaches an approved stage only when the evaluation,
lineage, security and owner evidence is complete. Renaming a file or copying it
to a serving directory is not promotion.

## Train-to-serve flow

1. Validate the dataset contract and create an immutable training snapshot.
2. Build features with shared definitions and point-in-time correctness tests
   to prevent leakage.
3. Run training in a pinned environment and capture parameters, metrics and
   artifacts even when the run fails.
4. Evaluate against baselines and slices, then conduct the required product,
   safety and governance review.
5. Register the model digest and approval; build a serving image or batch job
   that declares model/runtime compatibility.
6. Promote through the delivery platform using the same immutable identity;
   deploy canary/shadow only where the workload contract allows it.
7. Observe service health and model behavior, then trigger investigation or
   retraining from evidence rather than an unexplained schedule.

## Serving and monitoring boundaries

Real-time inference has latency, concurrency, availability and fallback needs.
Batch inference has scheduling, partition, idempotency and reconciliation
needs. Both require input/output schema versions and a caller identity. A
health endpoint proves the server responds, not that predictions remain useful.

Drift indicates distribution change, not automatically model failure.
Performance decay requires delayed ground truth or a defensible proxy. The
response can be investigate, restrict, fall back, retrain, recalibrate or roll
back; automatic retraining is not automatic promotion.

## Failure behavior

| Failure | Safe response |
| --- | --- |
| Dataset/feature validation fails | Stop training and return the failing contract to its owner |
| Run cannot be reproduced | Reject promotion until environment, data and parameters are captured |
| Model improves average metric but harms a critical slice | Hold for owner/governance decision; averages do not override safety |
| Serving latency or errors breach the gate | Stop rollout and restore the prior compatible model/image pair |
| Drift fires without ground truth | Investigate source and feature changes; do not claim accuracy loss |
| Registry or artifact store is unavailable | Preserve local immutable evidence and stop promotion; do not invent a version |

## Build and acceptance

The initial repository implementation can provide dataset/feature contracts,
a deterministic training fixture, run manifest, artifact digest, evaluation
report, registry-style metadata, a local inference API, drift fixture and
rollback test. Later product and Kubernetes integration adds actual storage,
identity, capacity, service telemetry and recovery evidence through separate
changes.

Acceptance binds every versioned object above, successful and adverse cases,
security/privacy checks, reproducibility, serving compatibility, rollback and
the accountable human decision. Detailed scenarios remain in the
[MLOps use-case index](../use-cases/mlops/README.md).
