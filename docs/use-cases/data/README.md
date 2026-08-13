# Enterprise Data Engineering and Integration Platform: Detailed Use Cases

Last verified: 2026-08-13

This index contains all 25 canonical use cases owned by the
Enterprise Data Engineering and Integration Platform. Together they move and validate healthcare data safely before downstream enterprise decisions use it. Implementation belongs
in `midhhealth/data-and-integration/data-engineering-platform` and must reuse existing GitLab shared runner, synthetic fixtures, PostgreSQL where approved, and current evidence paths.

No page in this directory authorizes a new data platform, Kafka, Airflow, lakehouse, VM, bucket, live feed, or protected healthcare dataset. All pages begin as
planned specifications; their individual status changes only after source,
runtime, rollback, and evidence gates are met.

| ID | Use case | Canonical coverage |
| --- | --- | --- |
| `UC-DATA-002` | [Batch Data Ingestion](UC-DATA-002-batch-data-ingestion.md) | Scheduled and recoverable source ingestion |
| `UC-DATA-003` | [Streaming Data Ingestion](UC-DATA-003-streaming-data-ingestion.md) | Durable event-driven data movement |
| `UC-DATA-004` | [Change-Data Capture](UC-DATA-004-change-data-capture.md) | Database changes published without application coupling |
| `UC-DATA-005` | [ETL and ELT Pipelines](UC-DATA-005-etl-and-elt-pipelines.md) | Standard extract, load and transform patterns |
| `UC-DATA-006` | [Workflow Orchestration](UC-DATA-006-workflow-orchestration.md) | Dependency, retry and scheduling control |
| `UC-DATA-001` | [Data Quality Validation](UC-DATA-001-healthcare-feed-quality.md) | Automated completeness, validity and freshness checks |
| `UC-DATA-007` | [Schema Registry and Evolution](UC-DATA-007-schema-registry-and-evolution.md) | Compatible event and dataset contracts |
| `UC-DATA-008` | [Event-Contract Management](UC-DATA-008-event-contract-management.md) | Ownership and versioning of event interfaces |
| `UC-DATA-009` | [dbt Data Transformation](UC-DATA-009-dbt-data-transformation.md) | Tested SQL transformation and documentation |
| `UC-DATA-010` | [Distributed Data Processing](UC-DATA-010-distributed-data-processing.md) | Scalable batch or stream computation |
| `UC-DATA-011` | [Data Lake and Lakehouse Storage](UC-DATA-011-data-lake-and-lakehouse-storage.md) | Governed object and table storage |
| `UC-DATA-012` | [Data Warehouse Integration](UC-DATA-012-data-warehouse-integration.md) | Controlled analytical serving |
| `UC-DATA-013` | [Metadata Catalog and Discovery](UC-DATA-013-metadata-catalog-and-discovery.md) | Searchable datasets and ownership |
| `UC-DATA-014` | [Data Lineage](UC-DATA-014-data-lineage.md) | Source-to-consumer traceability |
| `UC-DATA-015` | [Data Classification](UC-DATA-015-data-classification.md) | Sensitivity and regulatory metadata |
| `UC-DATA-016` | [PII Controls](UC-DATA-016-pii-controls.md) | Restricted handling of personal data |
| `UC-DATA-017` | [Data Retention and Archival](UC-DATA-017-data-retention-and-archival.md) | Policy-driven dataset lifecycle |
| `UC-DATA-018` | [Pipeline Monitoring and Alerting](UC-DATA-018-pipeline-monitoring-and-alerting.md) | Freshness, failure and latency signals |
| `UC-DATA-019` | [Pipeline Retry and Backfill](UC-DATA-019-pipeline-retry-and-backfill.md) | Safe historical reprocessing |
| `UC-DATA-020` | [Dead-Letter Queues and Replay](UC-DATA-020-dead-letter-queues-and-replay.md) | Recoverable event-processing failures |
| `UC-DATA-021` | [Data Reconciliation](UC-DATA-021-data-reconciliation.md) | Source and target correctness validation |
| `UC-DATA-022` | [Dataset Ownership](UC-DATA-022-dataset-ownership.md) | Data-product accountability and support |
| `UC-DATA-023` | [Data Access Governance](UC-DATA-023-data-access-governance.md) | Approved, auditable consumer access |
| `UC-DATA-024` | [Data-Pipeline Disaster Recovery](UC-DATA-024-data-pipeline-disaster-recovery.md) | Restored orchestration, state and data |
| `UC-DATA-025` | [Data Performance and Cost Optimization](UC-DATA-025-data-performance-and-cost-optimization.md) | Efficient compute, storage and retention |

## GitLab handoff

1. Create the epic and stories from the selected page in `midhhealth/data-and-integration/data-engineering-platform`.
2. Implement only the planned paths that fit the repository and current lab.
3. Run fixture or read-only validation before requesting a mutating change.
4. Return commit, pipeline, Jenkins/AWX, runtime, recovery, and incident
   evidence to the architecture page.
5. Stop and request a separate architecture decision if new infrastructure,
   capacity, products, or protected-data integration would be required.

