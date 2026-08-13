# Enterprise Healthcare AI Platform: Detailed Use Cases

Last verified: 2026-08-13

This index contains all 15 canonical use cases owned by the
Enterprise Healthcare AI Platform. Together they provide bounded and reviewable AI assistance without delegating regulated decisions. Implementation belongs
in `midhhealth/ai-and-ml-platform/healthcare-ai-platform` and must reuse existing GitLab shared runner, approved repository content, synthetic fixtures, and protected CI artifacts.

No page in this directory authorizes a new model server, vector database, VM, GPU host, cluster workload, cloud API, live clinical integration, or protected data. All pages begin as
planned specifications; their individual status changes only after source,
runtime, rollback, and evidence gates are met.

| ID | Use case | Canonical coverage |
| --- | --- | --- |
| `UC-AI-002` | [Clinical AI Assistant Platform](UC-AI-002-clinical-ai-assistant-platform.md) | Secure assistants for clinical workflow support |
| `UC-AI-003` | [Payer AI Assistant Platform](UC-AI-003-payer-ai-assistant-platform.md) | Claims, eligibility, authorization and member-service support |
| `UC-AI-001` | [Retrieval-Augmented Generation](UC-AI-001-retrieval-augmented-generation.md) | Governed document and knowledge retrieval |
| `UC-AI-004` | [Agentic Workflow Automation](UC-AI-004-agentic-workflow-automation.md) | Tool-calling workflows with safe execution boundaries |
| `UC-AI-005` | [Healthcare Knowledge Base Indexing](UC-AI-005-healthcare-knowledge-base-indexing.md) | Chunking, embeddings, ranking and searchable knowledge stores |
| `UC-AI-006` | [FHIR-Aware AI APIs](UC-AI-006-fhir-aware-ai-apis.md) | Auditable clinical-data exchange for AI workflows |
| `UC-AI-007` | [AI Prompt and Response Evaluation](UC-AI-007-ai-prompt-and-response-evaluation.md) | Regression, safety and quality evaluation |
| `UC-AI-008` | [Responsible AI Controls](UC-AI-008-responsible-ai-controls.md) | Bias, transparency, approval and human-review guardrails |
| `UC-AI-009` | [AI Workflow Audit Logging](UC-AI-009-ai-workflow-audit-logging.md) | Traceable prompts, context, tools and responses |
| `UC-AI-010` | [AI Cost and Latency Optimization](UC-AI-010-ai-cost-and-latency-optimization.md) | Token, model, cache and inference performance controls |
| `UC-AI-011` | [AI Security and Access Control](UC-AI-011-ai-security-and-access-control.md) | Least-privilege access to tools, data and model endpoints |
| `UC-AI-012` | [AI Release Governance](UC-AI-012-ai-release-governance.md) | Reviewable promotion across development, QA, stage and production |
| `UC-AI-013` | [AI Observability](UC-AI-013-ai-observability.md) | Metrics, traces, evaluations, failures and user feedback |
| `UC-AI-014` | [Clinical and Payer Workflow Integration](UC-AI-014-clinical-and-payer-workflow-integration.md) | API-first integration into provider and insurance workflows |
| `UC-AI-015` | [AI Incident Response](UC-AI-015-ai-incident-response.md) | Playbooks for unsafe output, tool failure and degraded models |

## GitLab handoff

1. Create the epic and stories from the selected page in `midhhealth/ai-and-ml-platform/healthcare-ai-platform`.
2. Implement only the planned paths that fit the repository and current lab.
3. Run fixture or read-only validation before requesting a mutating change.
4. Return commit, pipeline, Jenkins/AWX, runtime, recovery, and incident
   evidence to the architecture page.
5. Stop and request a separate architecture decision if new infrastructure,
   capacity, products, or protected-data integration would be required.

