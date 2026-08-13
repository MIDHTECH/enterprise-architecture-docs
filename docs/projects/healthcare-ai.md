# Healthcare AI Platform Domain

**Repository:** `midhhealth/ai-and-ml-platform/healthcare-ai-platform`  
**Team size:** 6 engineers

## Team Responsibilities

The healthcare AI team builds governed AI application capabilities for care
delivery, payer operations, support teams, and platform engineering workflows.
The domain starts with approved, non-production knowledge sources and expands
only after data, security, evaluation, and audit controls are in place.

| Team member | Primary responsibility |
| --- | --- |
| Healthcare AI Product Engineer | Owns AI use-case selection, workflow fit, human-review points, and business acceptance. |
| AI Application Engineer | Builds FastAPI services, assistant flows, tool calls, RAG APIs, and application integration. |
| Retrieval Engineer | Owns document processing, embeddings, vector indexes, ranking, citations, and retrieval quality. |
| AI Safety and Evaluation Engineer | Maintains prompt tests, response evaluation, guardrails, bias checks, and unsafe-output handling. |
| Healthcare Integration Engineer | Owns FHIR-aware APIs, workflow events, access boundaries, and integration with provider/payer systems. |
| AI Observability Engineer | Tracks latency, cost, failures, traces, user feedback, audit logs, and incident response. |

## Connected Teams

- Consumes governed data products from data engineering and approved knowledge sources from architecture/governance.
- Uses Kubernetes, delivery pipelines, observability, and governance controls before wider rollout.
- Works with MLOps when AI workflows include trained models or model-serving backends.

## Executable Use-Case Scope

- Clinical and payer AI assistants, RAG, healthcare knowledge indexing, FHIR-aware AI APIs, and agentic workflows.
- Prompt/response evaluation, responsible AI controls, audit logging, security, access control, and release governance.
- AI observability, cost/latency optimization, workflow integration, and AI incident response.
