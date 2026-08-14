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

## Outcome and control role

This team owns whether an AI-assisted workflow is useful, grounded and safe
for its approved purpose. It never transfers clinical, payer, privacy or
operational accountability to a model. Human review is placed where an error
could materially affect a person, payment, authorization or privileged action.

| Responsibility | Healthcare-AI commitment |
| --- | --- |
| Decision owned | Evaluate, release, restrict, suspend or roll back a versioned prompt, retrieval, tool and model combination for an approved workflow. |
| Evidence consumed | Workflow owner, intended use, prohibited use, data/knowledge classification, FHIR/API contract, model record, access policy and evaluation thresholds. |
| Evidence published | Prompt/retrieval/model/tool versions, citations, safety and quality results, human decision, latency/cost, audit trace and rollback eligibility. |
| Safe-stop boundary | Missing citation, unauthorized context/tool, unsafe response, evaluation regression, excessive uncertainty or unavailable human review blocks consequential action. |
| Outcomes measured | Task success, groundedness, unsafe-output rate, human override, workflow time saved, latency, cost per accepted result and incident recurrence. |

AI evidence and decisions follow the
[Cross-Platform Outcome and Control Framework](../cross-platform-outcome-control-framework.md)
without implying a new AI gateway or production model service.

## Executable Use-Case Scope

- Clinical and payer AI assistants, RAG, healthcare knowledge indexing, FHIR-aware AI APIs, and agentic workflows.
- Prompt/response evaluation, responsible AI controls, audit logging, security, access control, and release governance.
- AI observability, cost/latency optimization, workflow integration, and AI incident response.

## A narrow, evidence-led starting point

The healthcare AI platform begins with a workflow decision, not a model demo.
It asks what task needs help, who remains accountable, what approved knowledge
is needed, what an unsafe answer looks like, and how quality will be measured.
Clinical or payer decisions remain with authorized people and systems.

![Healthcare AI platform architecture](../assets/project-11-healthcare-ai-architecture.svg)

The first UC-AI-001 source slice is implemented and locally tested at commit
`175a39c`; publication to the authoritative GitLab project and protected CI
evidence remain pending. No production AI runtime is accepted. The planned Mac
Studio can support local development and evaluation after its
capacity and handling rules are confirmed; it is not a repository, a clinical
system, or part of the Kubernetes worker pool. Initial builds use synthetic or
explicitly approved non-production documents and do not introduce protected
health information.

## AI application contract

| Concern | Decision before implementation |
| --- | --- |
| Workflow | User, task, current pain, human-review point and action the system must never take |
| Knowledge | Approved sources, owner, classification, freshness, deletion and citation requirements |
| Model | Provider/runtime choice, version, context limits, latency/cost envelope and fallback |
| Retrieval | Chunking, metadata, access filtering, ranking, citation and stale-source behavior |
| Tools | Explicit allowlist, input schema, identity, side-effect boundary and confirmation rule |
| Evaluation | Representative cases, expected evidence, refusal/unsafe cases and release threshold |
| Operation | Service identity, audit events, telemetry, feedback, incident and rollback owner |

## Retrieval and response path

1. Ingest an approved document revision and preserve its ownership and access
   metadata.
2. Parse, chunk and embed it with versioned code; record failed or excluded
   content rather than silently omitting it.
3. At request time, authenticate the caller and apply source access before
   retrieval.
4. Retrieve and rank bounded context, then call the pinned model with the
   prompt and policy revision.
5. Return citations and uncertainty appropriate to the workflow. A missing
   source produces a clear limitation, not an invented answer.
6. Record latency, token/cost estimate, retrieval/result identifiers, safety
   decision and user feedback without logging sensitive prompt content.

Agentic workflows add a separate decision for each tool. Read operations come
first. A write, notification, ticket, clinical action or payer action requires
explicit authorization and confirmation; model output alone cannot approve it.

## Evaluation and release

Evaluation datasets are versioned and separated from training or tuning data.
They include ordinary cases, ambiguous requests, missing evidence, conflicting
sources, prompt injection, unauthorized knowledge, harmful instructions and
tool misuse. Results are sliced by failure type so an average score cannot hide
a severe safety regression.

AI-assisted code is treated as untrusted contribution: deterministic tests,
type/schema validation, dependency/security checks, peer review and bounded
runtime evaluation decide whether it is acceptable. A persuasive explanation
from the model is not validation.

## Failure behavior

| Failure | Safe behavior |
| --- | --- |
| Retrieval has no trustworthy source | State the limitation, cite nothing false and route the user to the authoritative workflow |
| Source access is uncertain | Deny retrieval and record the policy decision |
| Model or embedding endpoint fails | Use the documented fallback or return unavailable; do not bypass controls |
| Safety/evaluation gate regresses | Hold promotion and restore the prior prompt/model/index combination |
| Tool call is malformed or risky | Reject schema validation and require human confirmation where applicable |
| Sensitive content reaches telemetry | Restrict evidence, stop the flow, and follow the privacy/security incident path |

## Buildable implementation path

The first slice is a local, read-only RAG service over approved architecture
documents: versioned ingestion, a small API, citations, access fixtures,
evaluation cases, traces and a reproducible report. Later slices add FHIR-aware
synthetic interfaces and read-only tools before any side effect. Kubernetes or
edge deployment is planned only after resource, identity, observability and
recovery contracts pass review.

## Acceptance evidence

Acceptance records source/data/model/prompt/index revisions, test set and
metrics, adverse-case results, citations, access denials, latency/cost,
telemetry privacy checks, rollback and human owner decision. Detailed scenarios
remain in the [healthcare AI use-case index](../use-cases/healthcare-ai/README.md).
