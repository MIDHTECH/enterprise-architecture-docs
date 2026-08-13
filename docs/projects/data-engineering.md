# Data Engineering and Integration Domain

**Repository:** `midhhealth/data-and-integration/data-engineering-platform`  
**Team size:** 6 engineers

## Team Responsibilities

The data engineering team owns governed movement, transformation, quality,
lineage, and serving of provider and payer data products.

| Team member | Primary responsibility |
| --- | --- |
| Data Platform Lead | Owns data platform roadmap, ownership model, domain contracts, and governance alignment. |
| Ingestion Engineer | Builds batch, streaming, CDC, retry, replay, and source onboarding workflows. |
| Orchestration Engineer | Maintains Airflow-style scheduling, dependencies, backfills, retries, and operational evidence. |
| Transformation Engineer | Owns dbt/SQL transformations, tests, documentation, and dataset versioning. |
| Data Quality and Lineage Engineer | Maintains quality checks, freshness, reconciliation, metadata catalog, lineage, and classifications. |
| Data Access Engineer | Owns dataset access approvals, PII controls, retention, archival, and consumer contracts. |

## Connected Teams

- Consumes source data from databases, applications, partner feeds, and events.
- Provides curated data and features to analytics, healthcare AI, and MLOps.
- Sends quality, lineage, freshness, and access evidence to governance and SRE.

## Executable Use-Case Scope

- Batch ingestion, streaming ingestion, CDC, ETL/ELT, workflow orchestration, and schema evolution.
- Data quality, reconciliation, metadata catalog, lineage, classification, PII controls, and access governance.
- Pipeline monitoring, retry/backfill, dead-letter replay, lakehouse storage, warehouse integration, and DR.
