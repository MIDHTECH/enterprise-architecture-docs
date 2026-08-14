# Healthcare AI Platform Domain

**Repository:** `midhhealth/ai-and-ml-platform/healthcare-ai-platform`  
**Current state:** UC-AI-001 source proof implemented locally at `175a39c`;
authoritative GitLab publication is blocked by INC-2026-086; no AI runtime or
employee-facing application is accepted.

## Platform charter

MidhHealth Integrated Care spans provider operations, payer operations, digital
care, shared services, and the teams that operate their technology. Those
groups may benefit from AI-assisted workflows, but they cannot transfer
clinical, payment, privacy, security, or operational accountability to a
model.

The Healthcare AI platform exists to make an AI-assisted workflow governable.
It gives an application or workflow owner a standard way to define intended
use, bind approved knowledge and data, evaluate behavior, control access,
observe cost and reliability, and stop or roll back an unsafe version. It does
not create business demand, own clinical or payer policy, or approve its own
use in a consuming application.

The first capability is intentionally narrower: prove cited retrieval over
synthetic, non-sensitive fixtures before selecting or operating a model
service.

## Enterprise service catalogue

| Platform service | Primary consumers | Enterprise decision enabled | Current state |
| --- | --- | --- | --- |
| Governed retrieval source proof | Platform engineering, operations, architecture, security | Decide whether retrieval respects source revisions, authorization boundaries, citations, failure behavior, and source-performance gates | Implemented locally for UC-AI-001; protected GitLab CI pending |
| Knowledge admission and indexing assurance | Knowledge owners, data stewards, application teams | Decide which source revision may be indexed, for what purpose, until when, and how it is removed | Designed; enterprise corpus not approved |
| AI behavior and safety evaluation | Workflow owners, Security, Risk, application teams | Compare prompt, retrieval, provider, model, and tool revisions against ordinary and adverse cases before release | Designed; deterministic UC-AI-001 cases implemented |
| AI workflow release decision | Application owner, Healthcare AI, DevSecOps, SRE | Promote, restrict, suspend, or restore a complete versioned AI behavior package | Planned; no runtime release path accepted |
| FHIR-aware integration assurance | Care delivery, payer operations, data engineering, integration teams | Confirm that an AI workflow consumes only approved synthetic or governed healthcare API contracts | Planned; no FHIR connection exists |
| AI operational evidence and incident response | Service owner, SRE, Security, support teams | Explain degraded quality, unsafe output, access denial, latency, cost, recent change, and recovery status | Designed; runtime telemetry and service ownership pending |

This catalogue describes services and decisions, not a shopping list. A product
belongs in the architecture only after a service need, target, ownership model,
data boundary, recovery path, and acceptance test exist.

## Consumer journeys

### Operational knowledge journey

An engineer or operations analyst asks a question about an approved runbook,
service standard, or incident pattern. The workflow applies the caller's scope
before retrieval, returns only context from an approved revision, and refuses
when evidence is unavailable. The workflow owner measures whether this reduces
search and verification effort without increasing unsupported decisions.

UC-AI-001 is building the control and measurement mechanism for this journey.
It is not yet an employee-facing assistant, and no time-saving benefit has been
claimed.

### Provider or payer workflow journey

A future application owner may propose assistance for a clinical, claims,
eligibility, authorization, member-service, or care-coordination task. That
proposal must name the human decision, prohibited model action, data purpose,
FHIR or API contract, consequence of error, escalation path, and business
measure. Synthetic fixtures and read-only integration come before protected
data or side effects.

The Healthcare AI platform evaluates and constrains the AI behavior. The
authorized provider, payer, or application owner retains the decision.

## Decision rights and operating model

| Decision | Accountable role | Required contributors | Decision evidence |
| --- | --- | --- | --- |
| Sponsor an AI-assisted employee or application journey | Consuming workflow owner | Product, operations, clinical or payer subject-matter owner | Current task, pain, baseline, intended benefit, prohibited use, funding and support owner |
| Admit knowledge or data | Knowledge or data owner | Security, privacy, Healthcare AI, integration owner | Source revision, classification, permitted purpose, retention, deletion, freshness and lineage |
| Release retrieval, prompt, model or tool behavior | Healthcare AI platform owner | Workflow owner, AI evaluation, Security, DevSecOps and SRE | Versioned evaluation bundle, blocking cases, access policy, cost/latency envelope, rollback eligibility |
| Accept workflow value and residual risk | Consuming workflow owner | Risk, security, service owner and affected business representatives | Task success, human override, unsafe-output results, time saved, cost per accepted result and exception record |
| Operate a runtime service | Named service owner | SRE, infrastructure, Kubernetes or edge owner, Network and Security | SLO, capacity, support hours, dashboard, runbook, incident path, recovery test and shutdown procedure |
| Suspend or recover unsafe behavior | Healthcare AI or incident commander within the approved policy | Workflow owner, Security, SRE and application owner | Trigger, affected revisions, containment, prior safe version, independent verification and corrective action |

No runtime service currently has all of these decisions. Source completion
cannot be used as implied approval.

## Platform boundaries and connected teams

| Platform or owner | What Healthcare AI consumes | What Healthcare AI returns |
| --- | --- | --- |
| Application or workflow owner | Intended use, users, current journey, business baseline, prohibited action and acceptance authority | Versioned AI behavior decision, limitations, human-review requirement and measurable outcome evidence |
| Data Engineering and Integration | Governed dataset or API contract, classification, lineage, quality and reconciliation state | Retrieval or AI consumption identity, evaluation result, access denial and integration feedback |
| DevSecOps Delivery | Reviewed source, immutable artifact, pipeline identity and promotion controls | AI-specific quality/safety gates and the exact behavior package eligible for promotion |
| Governance and Security | Identity, policy, control mapping, exception and evidence-retention rules | Access decisions, unsafe-output evidence, model/tool usage evidence and exception status |
| Observability and SRE | Telemetry standards, SLO method, incident correlation and operational review | AI stage timings, TTFT, token or request usage, evaluation failures, model/provider revision and shutdown state |
| MLOps Model Platform | Approved model record, serving revision, evaluation lineage and rollback candidate | Application-level model acceptance, workflow feedback, quality drift and release restriction |
| Knowledge owner | Approved source, revision, classification, freshness and deletion instruction | Indexing result, citation trace, rejected content and observed knowledge gaps |

The shared control vocabulary is defined once in the
[Cross-Platform Outcome and Control Framework](../cross-platform-outcome-control-framework.md).
This page records how Healthcare AI applies it; detailed use cases should not
repeat the framework verbatim.

## Architecture and request path

![Healthcare AI platform architecture](../assets/project-11-healthcare-ai-architecture.svg)

For a governed retrieval request, ownership and policy move with the
information:

1. A knowledge owner supplies an immutable, classified source revision.
2. Admission checks determine whether that source may enter the corpus.
3. The caller or service identity supplies scopes and metadata partitions.
4. Retrieval filters before scoring, selects bounded context, and records its
   revision.
5. The provider receives only that context. The current CI provider is
   deterministic and offline; no production model is accepted.
6. Citation and safety checks decide whether the response may leave the
   platform boundary.
7. The workflow owner receives the response, limitations, evidence identity,
   and required human action.
8. Telemetry and feedback return to the evaluation and release decision
   without retaining prohibited prompt or record content.

Agentic workflows add a separate authorization decision for every tool. A
write, notification, ticket, clinical action, or payer action requires an
explicit application contract and confirmation rule; model output alone never
authorizes it.

## Value and risk scorecard

| Perspective | Measure for a future consuming workflow | Current evidence state |
| --- | --- | --- |
| Employee or workflow value | Search and verification time, task completion, handoffs removed and user acceptance | Baseline not measured; workflow sponsor not assigned |
| Quality | Required-case success, grounded response rate, citation correctness, unsupported-answer rate and human override | Deterministic UC-AI-001 fixture gates implemented; semantic and workflow quality pending |
| Safety and privacy | Unauthorized retrieval, prohibited-data admission, unsafe output, tool-policy violation and evidence leakage | Negative source fixtures implemented; runtime/privacy review pending |
| Reliability | Availability, provider failure, timeout, fallback success, recovery time and recurrence | Provider-failure refusal implemented; no runtime SLO or recovery exercise |
| Cost and capacity | Cost per accepted result, token/request usage, cache benefit, saturation and forecast variance | Stage and token evidence designed; no runtime cost baseline |
| Governance | Evidence freshness, version traceability, exception age, owner review and shutdown readiness | Source revision evidence implemented; enterprise approval and retention pending |

Targets are set by the consuming workflow and service owners. Architecture
does not invent a percentage improvement or production SLO before a baseline
exists.

## Failure and recovery model

| Failure | Immediate behavior | Accountable follow-up |
| --- | --- | --- |
| Source is unowned, changed, expired or prohibited | Exclude it before indexing and fail the release decision | Knowledge and data owners correct or withdraw the source |
| Caller scope is missing or insufficient | Refuse before scoring and disclose no retrieved content | Security or application owner corrects identity policy; relevance never overrides access |
| Retrieval lacks trustworthy context | Return an explicit limitation with no invented citation | Knowledge owner reviews coverage; Healthcare AI reviews ranking evidence |
| Provider or embedding operation fails | Return unavailable or the documented deterministic fallback | Service owner diagnoses the provider; controls remain enabled |
| Citation does not resolve to selected context | Reject the response | Healthcare AI blocks the revision and preserves the failed case |
| Evaluation gate regresses | Hold promotion and keep the prior accepted package | Healthcare AI and workflow owner review the failed slice, not only the average score |
| Unsafe runtime behavior is suspected | Suspend the affected behavior package and preserve sanitized evidence | Incident commander coordinates Security, SRE, application and workflow owners |

The current source-only slice performs no target mutation. Its recovery action
is to discard generated evidence, restore the prior source revision, and rerun
the fixed fixtures. A future service needs its own rollback, shutdown, data
removal, and independent recovery validation.

## Implementation path

The platform advances through evidence, not through product installation:

1. **Source control:** publish UC-AI-001 commit `175a39c` to the authoritative
   GitLab project and obtain a protected pipeline result.
2. **Knowledge contract:** replace synthetic documents with an explicitly
   approved, immutable, non-sensitive operational corpus.
3. **Workflow contract:** select one employee journey and measure the current
   search, verification, and escalation path.
4. **Provider comparison:** compare the deterministic baseline with a separately
   accepted local provider only after model, license, checksum, capacity,
   endpoint, data, and stop decisions are recorded.
5. **Read-only service design:** define identity, API, SLO, cost, telemetry,
   support, incident, and shutdown contracts without adding side effects.
6. **Application adoption:** link a separate application project to only the
   required platform use cases and obtain workflow-owner acceptance.

The Mac Studio may become a development or edge-evaluation target after its
capacity and handling rules are confirmed. It is not a production data host,
Kubernetes worker, repository, or currently accepted model service. No new
server, vector database, gateway, or cluster component is implied by this
sequence.

## Acceptance evidence

Platform acceptance is specific to a consuming workflow and behavior package.
The evidence must record:

- workflow sponsor, intended use, prohibited use, users, baseline and value
  target;
- source, data, prompt, retrieval, provider, model and tool revisions;
- identity and authorization policy, denied cases and emergency revocation;
- ordinary and adverse evaluation results, including severe-case slices;
- latency, TTFT, usage, cost, capacity and failure behavior;
- human-review decision, limitations and residual-risk owner;
- runtime SLO, dashboard, runbook, incident owner, rollback and shutdown proof;
- immutable pipeline, artifact and application-deployment references.

The detailed implementation and interview scenarios remain in the
[Healthcare AI use-case index](../use-cases/healthcare-ai/README.md).
