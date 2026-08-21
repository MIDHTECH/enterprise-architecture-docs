# UC-AI-001: Retrieval-Augmented Generation

Last verified: 2026-08-14

## Use-case record

| Field | Value |
| --- | --- |
| Canonical portfolio use case | Retrieval-Augmented Generation |
| Primary platform | Enterprise Healthcare AI Platform |
| Supporting use cases | [UC-AI-005](UC-AI-005-healthcare-knowledge-base-indexing.md), [UC-AI-011](UC-AI-011-ai-security-and-access-control.md), [UC-DATA-023](../data/UC-DATA-023-data-access-governance.md), [UC-AI-007](UC-AI-007-ai-prompt-and-response-evaluation.md) |
| Primary implementation repository | `midhhealth/ai-and-ml-platform/healthcare-ai-platform` |
| Enterprise alignment | Provider operations, payer operations, shared digital platform, risk and compliance |
| Enterprise outcome | Help staff locate cited, approved operational knowledge without exposing protected data or trusting uncited output |
| Supporting platforms | Data engineering, governance, DevSecOps delivery, observability |
| Jira epic | `EPIC-AI-001` — Prove governed retrieval over approved documentation |
| Change record | Not required for offline CI evaluation; required before any runtime service or model endpoint |
| Target | Existing healthcare-AI GitLab project, accepted shared runner, and approved documentation snapshots |
| Current state | **Implemented in source locally — GitLab publication, pipeline evidence, and runtime acceptance remain pending** |
| Infrastructure boundary | No model server, vector database, VM, cluster workload, cloud API, or new storage is created |
| Owner | Healthcare AI Platform team |

## Purpose

MidhHealth staff make operational decisions across a provider-payer enterprise,
but the explanation they need may be spread across runbooks, architecture
records, policies, incident notes, and service ownership documents. The first
business capability is therefore **enterprise knowledge access for operational
decision support**: help an engineer or operations analyst find the approved
source behind an answer without turning the system into a clinical or payer
decision maker.

The current slice proves that retrieval can be tested, measured, denied, and
explained before MidhHealth accepts a model service. It includes deterministic
offline embeddings and extractive responses for repeatable evaluation. An
external model endpoint, production assistant, and application integration are
not part of the accepted boundary.

## Expected outcome

For a versioned set of non-sensitive documents, the source proof must answer
three enterprise questions: did the caller receive only knowledge within the
approved scope, can every answer be traced to the exact source revision, and
does the workflow stop cleanly when evidence is missing? The report records
retrieval and citation results, refusal leakage, latency, time to first token,
stage coverage, and the corpus, provider, and retrieval revisions. Queries
outside the approved scope return `insufficient-approved-context`.

## Platform and enterprise fit

| Relationship | Detailed fit |
| --- | --- |
| Owning platform | Healthcare AI owns the retrieval behavior, evaluation contract, release decision, and safe fallback. It does not own the source documents or the consuming workflow. |
| Business capability | Enterprise knowledge access and operational decision support across shared provider, payer, and platform operations. |
| First consumers | Platform engineers and operations analysts working with approved runbooks, service standards, and incident knowledge. Clinical and claims decision support is excluded from this slice. |
| Value hypothesis | Reduce time spent searching across repositories and reduce unsupported operational answers. The baseline and improvement target have not yet been measured, so no time-saving claim is made. |
| Enterprise risk reduced | An answer that crosses an authorization boundary, cites the wrong revision, or appears authoritative without evidence is refused rather than passed to a workflow. |
| Required handoffs | Knowledge owners approve content; Data Governance defines classification; AI Security defines caller scope; AI Evaluation supplies release evidence; the workflow owner decides whether the capability is useful. |
| Infrastructure boundary | The source proof reuses the existing repository and accepted CI path. It does not create a model server, vector database, application, VM, cluster workload, cloud service, or new storage. |

Enterprise acceptance is not “the RAG test passed.” It is a decision by the
workflow owner that cited retrieval improves a named task at an acceptable
quality, risk, latency, and operating cost. The current source proof establishes
the measurement and control mechanism; it does not yet establish that business
value.

## Trigger and actors

| Item | Definition |
| --- | --- |
| Trigger | A reviewed change to corpus policy, chunking, retrieval, provider behavior, evaluation cases, or release thresholds |
| Workflow sponsor | Names the employee task, accepts the value measure, and decides whether the capability should enter a real workflow; not yet assigned for runtime use |
| Knowledge owner | Approves each source, classification, revision, freshness rule, and removal decision |
| Healthcare AI owner | Owns implementation, evaluation, release restriction, suspension, and rollback of the retrieval behavior |
| Security and data owners | Define caller scope, prohibited data, artifact handling, and exception decisions |
| SRE or service owner | Sets runtime SLOs and accepts operational support only when a runtime service is proposed |

## Preconditions

- Corpus files come from approved GitLab repositories at immutable commits.
- Inputs exclude credentials, private keys, tokens, PHI, and production record
  extracts.
- `gitlab-runner-shared01` is the only required compute target.
- No outbound model or embedding API is required by the acceptance path.
- Generated indexes and results expire as CI artifacts and are not runtime
  knowledge services.

## Scope and exclusions

In scope are deterministic offline embeddings, lexical and vector retrieval,
fusion and reranking, bounded context selection, extractive responses, stable
citations, authorization fixtures, failure handling, cache isolation, latency
evidence, and a machine-readable release decision. External model or embedding
services, persistent vector databases, agents, tool execution, FHIR
connections, clinical advice, claims decisions, new compute, and protected data
are excluded.

## Design walkthrough

An operations analyst asks, “What evidence is required before we right-size a
service after a cost anomaly?” The request carries the analyst's approved
scope and an operations or finance partition. Before ranking begins, the
retriever removes every document outside that scope. Lexical and deterministic
vector searches run over the remaining chunks, fusion and reranking choose a
bounded context, and the offline provider returns an extractive response. A
citation is accepted only when its chunk belongs to the context selected for
that request.

That flow is intentionally less impressive than a general assistant. Its value
is that an architecture reviewer can explain why a source was eligible, which
revision supported the response, where time was spent, and why another caller
was denied. If the corpus is stale, authorization is empty, a provider fails,
or a citation is invented, the result is a structured refusal with no leaked
retrieval result.

The current buildable boundary is this offline source proof. The workflow
sponsor still has work to do before runtime use: select a real
employee journey, measure today's search and verification time, approve the
knowledge set, and decide what improvement would justify operating a service.
Until those decisions exist, UC-AI-001 remains an enterprise control and
evaluation capability—not an employee-facing application.

## Architecture context

UC-AI-001 sits between governed knowledge and an eventual employee workflow.
It is not a knowledge owner, identity provider, model platform, or application.
Its architectural responsibility is to turn an approved question, caller
scope, corpus revision, and retrieval policy into either cited context or an
explainable refusal.

| Context element | Architecture statement |
| --- | --- |
| Business and operational setting | MidhHealth Integrated Care shares operational knowledge across provider, payer, and platform teams. The first slice serves platform and operations staff; regulated workflow integration remains future work. |
| Current state | **Implemented in source locally — GitLab publication, pipeline evidence, and runtime acceptance remain pending** |
| Desired state | An approved employee task consumes a governed retrieval service with measurable value, explicit decision rights, runtime SLOs, unit-cost evidence, and a tested shutdown path. |
| Existing target boundary | Existing healthcare-AI GitLab project, accepted shared runner, and approved documentation snapshots |
| Infrastructure constraint | No model server, vector database, VM, cluster workload, cloud API, or new storage is created |
| Accountable platform owner | Healthcare AI Platform team; the consuming service, data, security, or workflow owner remains accountable for accepting business impact. |

The current source proof owns retrieval logic and evaluation evidence only.
The knowledge owner remains accountable for content, Security for access
policy, and the workflow sponsor for business adoption.

## Architecture diagram

![UC-AI-001 architecture showing demand, source contracts, planned control, existing target, evidence, and recovery](../../assets/use-cases/UC-AI-001/UC-AI-001-architecture.svg)

The SVG reads from the approved question and corpus through admission, scoped
retrieval, evidence gates, and the workflow owner. The orange branch shows the
specific conditions that end in refusal or owner review instead of an answer.

## Dependencies and handoffs

These handoffs are part of the service contract. Each contributes different
information; none can be replaced by a generic approval statement.

| Relationship | Use case | Required handoff | Failure propagation |
| --- | --- | --- | --- |
| Required upstream contract | [UC-AI-005: Healthcare Knowledge Base Indexing](UC-AI-005-healthcare-knowledge-base-indexing.md) | Corpus manifest with source owner, immutable revision, classification, checksum, freshness, exclusion, and deletion status | An unowned, changed, expired, or partly indexed corpus blocks evaluation; the prior accepted manifest remains the only eligible input. |
| Required upstream contract | [UC-AI-011: AI Security and Access Control](UC-AI-011-ai-security-and-access-control.md) | Caller or service identity mapped to permitted scopes, metadata partitions, provider actions, and emergency revocation | Missing scope produces a refusal. A scope mismatch is a security failure and cannot be bypassed by retrieval relevance. |
| Coordinated assurance handoff | [UC-DATA-023: Data Access Governance](../data/UC-DATA-023-data-access-governance.md) | Classification, permitted purpose, steward, retention, and evidence-handling decision for every corpus class | Unknown classification or prohibited content blocks ingestion before embedding or retrieval. |
| Coordinated assurance handoff | [UC-AI-007: AI Prompt and Response Evaluation](UC-AI-007-ai-prompt-and-response-evaluation.md) | Versioned ordinary, missing-context, unauthorized, malformed, injection, and provider-failure cases with warning and blocking thresholds | A regression holds promotion and identifies the failed case and revision; an average score cannot waive a blocking safety case. |

The local source implementation uses deterministic fixtures in place of these
enterprise handoffs. Before publication is called code-complete, those fixtures
must pass protected CI. Before runtime promotion, each fixture contract must be
replaced or explicitly approved as a versioned enterprise artifact.

## Quality attributes

Retrieval quality is not the size of the index or a green pipeline. It is the
ability to find the expected approved source, refuse an ineligible request,
bind citations to the selected context, expose latency by stage, and help a
workflow owner judge whether the result is worth using.

| Attribute | Required measure or invariant | Decision state |
| --- | --- | --- |
| Functional correctness | Every required input is validated; **Help staff locate cited, approved operational knowledge without exposing protected data or trusting uncited output** is evaluated against positive, negative, missing-input, and unauthorized-scope cases. | Fixed design requirement |
| Performance and scale | Source gates require 100% fixture-case success, p95 total latency at or below 250 ms, and p95 TTFT at or below 100 ms on the deterministic test set. These thresholds detect source regressions; they are not production SLOs. | Source gates implemented; runtime thresholds `TBD` before runtime implementation |
| Reliability | Missing prerequisites, stale dependencies, malformed evidence, and partial results fail closed without widening scope. | Fixed design requirement |
| Recovery | Record the maximum acceptable interruption and recovery time before runtime use; source-only validation must remain zero-change. | Owner decision required before runtime exercise |
| Observability | Emit use-case ID, revision, target, executor, start/end time, duration, decision, reason code, and recovery reference. | Required in the result schema |
| Evidence retention | Assign classification, retention period, and deletion owner before storing runtime evidence. | Security/compliance decision required |

Runtime availability, concurrency, semantic quality, unit cost, retention,
RTO, and RPO remain unresolved until a workflow sponsor and service owner
approve the employee journey and operating model. The deterministic source
thresholds must never be presented as production performance evidence.

## Security and privacy architecture

The current design has no privileged runtime executor. Its meaningful trust
boundaries are content admission, caller scope, provider access, and evidence
publication.

| Trust boundary | Allowed flow | Required control |
| --- | --- | --- |
| Knowledge source → corpus fixture | Only an approved revision and classification may enter the evaluation set | Manifest, checksum, owner, expiry, prohibited-content scan, and fail-closed classification check |
| Caller fixture → retriever | Query, approved scopes, and metadata filters | Scope and partition filtering occurs before lexical or vector scoring; an empty scope is denied |
| Selected context → provider | Only bounded chunks eligible for that caller | Deterministic provider in CI; optional adapter permits loopback only; no provider credential is present |
| Provider response → result | Answer and citation identifiers | Every citation must resolve to the selected context; invented or missing citations produce a refusal |
| Source job → evidence artifact | Sanitized revisions, decisions, timings, gates, and negative-case results | No protected prompt content, credentials, PHI, PII, or target-changing identity; artifact expires |

For Retrieval-Augmented Generation, the primary threat is **prompt, retrieved content, model output, or tool request crossing a data or authorization boundary**. The mandatory response is
synthetic/de-identified fixtures, role-aware policy, untrusted-content isolation, refusal tests, human review, and artifact redaction. Authentication and authorization mappings must name
the existing identity source, principal or service account, permitted actions,
credential owner, rotation path, and emergency revocation procedure before a
runtime service can be proposed.

## Architecture decisions and trade-offs

| Decision | Selected architecture | Alternative deferred or rejected | Rationale and status |
| --- | --- | --- | --- |
| First implementation slice | Installation-free deterministic evaluator on the existing GitLab runner | Start with an employee-facing assistant | Separates retrieval and policy defects from model behavior; **implemented locally** |
| Retrieval baseline | Parallel lexical and deterministic-vector ranking with reciprocal-rank fusion and bounded reranking | Select a vector database or hosted search product first | Produces comparable evidence without creating a runtime dependency; **implemented locally** |
| Provider boundary | Deterministic CI provider plus a loopback-only OpenAI-compatible adapter | Bind the source proof to Ollama, a hosted API, or a Kubernetes model service | Keeps model selection reversible and blocks accidental remote data transfer; **implemented in source, no model accepted** |
| Evidence | Revision-bound JSON result with case, citation, refusal, latency, TTFT, stage, and source-revision gates | Screenshot or aggregate-score acceptance | Lets Security, SRE, and workflow owners inspect why a release passed or failed; **implemented locally** |
| Failure handling | Refuse on missing scope/context, provider failure, prohibited classification, or invalid citation | Return partial or uncited output | Keeps a retrieval defect from becoming an apparently authoritative enterprise answer; **implemented and tested** |
| Runtime and persistence | Require a new architecture decision before adding a model process, persistent index, API, application, or workload | Treat source completion as deployment authorization | Preserves the current lab boundary and forces an operating model before service creation; **mandatory** |

### Open decisions before runtime promotion

| Open decision | Decision owner | Resolution gate |
| --- | --- | --- |
| First employee journey and canary group | Workflow sponsor plus Healthcare AI owner | Must name the users, current task, baseline, excluded decisions, and stop mechanism before runtime design |
| Performance, scale, and reliability thresholds | Service owner and SRE | Must be recorded before a runtime acceptance run |
| Identity-to-action authorization matrix | Platform owner and security reviewer | Must be approved before target credentials are attached |
| Evidence classification and retention | Data/security owner | Must be approved before runtime artifacts are retained |

Any change to provider boundary, persistence, corpus classification, runtime
placement, or side effects needs an explicit decision in the implementation
repository and this page. Editing the narrative cannot authorize a model
service or employee workflow.

## Implementation design

The implemented boundary is source plus deterministic evaluation. Commit
`175a39c` contains the files below and provisions nothing. It is preserved in a
persistent local checkout because the GitLab endpoint is currently
unreachable. That commit proves what was written and tested locally; it cannot
stand in for a protected pipeline, an approved corpus, or an operated service.

| Source responsibility | Implemented location |
| --- | --- |
| Use-case contract and target allowlist | `midhhealth/ai-and-ml-platform/healthcare-ai-platform/contracts/uc-ai-001.yaml` |
| Primary implementation | `midhhealth/ai-and-ml-platform/healthcare-ai-platform/src/evaluations/retrieval_augmented_generation.py`; entry point: the `evaluate_retrieval_augmented_generation` offline evaluator |
| Machine-readable result schema | `midhhealth/ai-and-ml-platform/healthcare-ai-platform/schemas/uc-ai-001-result.schema.json` |
| Positive, negative, malformed, and recovery fixtures | `midhhealth/ai-and-ml-platform/healthcare-ai-platform/tests/fixtures/uc-ai-001/` |
| GitLab source gate | `midhhealth/ai-and-ml-platform/healthcare-ai-platform/.gitlab/ci/uc-ai-001.yml` |
| Operator diagnosis and recovery | `midhhealth/ai-and-ml-platform/healthcare-ai-platform/docs/runbooks/uc-ai-001.md` |

### Delivery stages

| Stage | Current state | Exit evidence |
| --- | --- | --- |
| Contract and source | Complete locally at `175a39c` | Contract, schema, deterministic provider, retrieval pipeline, tests, and installation-free runbook |
| Local source proof | Complete | 14 tests and five cases pass; quality, p95 latency, TTFT, refusal-leak, and required-stage gates are enforced |
| Authoritative publication | Blocked by INC-2026-091 | Exact commit on protected GitLab branch and successful pipeline artifact |
| Enterprise corpus approval | Not started | Knowledge-owner manifest, classification, checksum, freshness, exclusion, and deletion evidence |
| Employee workflow and runtime | Not designed | Sponsor, baseline, benefit target, identity, runtime SLO, cost envelope, support model, shutdown, and change record |

The first authoritative merge request must carry commit `175a39c` or a
reviewable descendant, link the corpus and access decisions, and retain the
machine-readable result. Later runtime evidence needs a different record with
the employee journey, service target, owner, SLO, cost envelope, and shutdown
proof.

## Code and configuration map

| Repository | Implemented path | Responsibility |
| --- | --- | --- |
| `healthcare-ai-platform` | `contracts/uc-ai-001.yaml` | Allowed classifications, retrieval settings, source thresholds, required evidence, and safe-stop contract |
| same | `src/healthcare_ai/rag/chunking.py` | Stable, revision-bound, structure-aware chunks and duplicate-document rejection |
| same | `src/healthcare_ai/rag/retrieval.py` | Authorization-filtered lexical/vector search, reciprocal-rank fusion, and bounded reranking |
| same | `src/healthcare_ai/rag/pipeline.py` | Cache isolation, context budget, provider call, citation validation, timings, and structured refusals |
| same | `src/healthcare_ai/rag/providers.py` | Deterministic CI provider and loopback-only OpenAI-compatible adapter |
| same | `src/healthcare_ai/rag/evaluation.py` | Case decisions, revision evidence, percentiles, and enforceable release gates |
| same | `tests/fixtures/uc-ai-001/` and `tests/test_pipeline.py` | Synthetic corpus, positive/refusal cases, provider failures, scope isolation, classification rejection, and latency-gate failure |
| same | `schemas/uc-ai-001-result.schema.json` | Machine-readable evidence contract |
| same | `.gitlab/ci/uc-ai-001.yml` and `docs/runbooks/uc-ai-001.md` | Installation-free source gate, artifact path, diagnosis, and zero-change recovery |

## Jira breakdown

### STORY-AI-001: Approve and fingerprint the knowledge corpus

**Description:** Knowledge and security owners need an explicit list of
documents that can be indexed, with immutable revision, ownership, data class,
review date, and checksum.

**Status:** Planned; the source implementation exists, but the corpus approval
decision remains open.

**Acceptance criteria:** Every file is allowlisted and checksummed; denied paths
and secret patterns fail the job; stale approval fails closed; no PHI or
credential-bearing content is included.

**Implementation steps:** Define corpus schema, select approved documentation,
record commits, scan content, and generate a signed/checksummed manifest.

**Completed work:** The source contract, deterministic fixture corpus, validation
script, and ephemeral in-memory index path exist at local commit `175a39c`.
The fixture corpus is test data only; no enterprise corpus approval or durable
index is claimed.

**Validation and rollback:** Test allowed, unlisted, changed, expired, and
secret-bearing fixtures. Remove an artifact and revert the manifest on policy
failure.

**Required attachments:** `ART-AI-001A` approved corpus manifest and scan.

### STORY-AI-002: Retrieve cited passages without a model service

**Description:** Retrieval engineers need a deterministic baseline that ranks
approved passages and exposes exact citations before generation adds risk.

**Status:** Implemented in source locally; GitLab CI proof and reviewed corpus
acceptance remain pending.

**Acceptance criteria:** Results include repository, commit, path, heading,
chunk ID, and score; citations resolve to the indexed text; out-of-scope queries
return insufficient context; no network model call occurs.

**Implementation steps:** Implement chunking and lexical retrieval, build the
index in CI, add citation verification, and expire the index artifact.

**Completed work:** Stable structure-aware chunks, duplicate-document rejection,
lexical and deterministic-vector retrieval, parallel scoring, reciprocal-rank
fusion, bounded reranking, access filtering before scoring, context budgeting,
and citation validation are implemented and covered by local tests at commit
`175a39c`.

**Validation and rollback:** Run deterministic unit tests and compare repeated
results. Revert ranking changes that reduce the accepted baseline.

**Required attachments:** `ART-AI-002A` retrieval and citation test report.

### STORY-AI-003: Evaluate enterprise fit and safety boundaries

**Description:** Workflow and safety owners need evidence that retrieval helps
real staff tasks while refusing unsupported, sensitive, or instruction-
injection requests.

**Status:** Implemented against deterministic fixtures locally; protected CI
evidence and workflow-owner acceptance remain pending.

**Acceptance criteria:** Evaluation spans provider, payer, and platform
questions; relevance and citation thresholds are explicit; prompt-injection,
secret request, clinical advice, and unsupported-answer cases fail closed.

**Implementation steps:** Create reviewed cases, run CI evaluation, publish
aggregate metrics and failures, and document the gate for any later generator.

**Completed work:** Five deterministic cases pass locally, including authorized
retrieval, insufficient context, metadata-partition denial, provider outage,
and invented-citation rejection. The result proves source behavior only; it
does not establish production quality, semantic model quality, or runtime
capacity.

**Validation and rollback:** Re-run the fixed suite for every corpus or ranking
change. Block promotion and restore the prior accepted revision on regression.

**Required attachments:** `ART-AI-003A` evaluation and safety report.

## Evidence and screenshot register

| ID | Evidence | Source | Status |
| --- | --- | --- | --- |
| `ART-AI-001` | Local source implementation, test, boundary, and publication status | [Source implementation evidence](../../evidence/ART-AI-001-source-implementation.md) | Recorded; remote publication pending |
| `ART-AI-001A` | Corpus manifest and content scan | GitLab CI | Pending |
| `ART-AI-002A` | Retrieval/citation tests | GitLab CI | Pending |
| `ART-AI-003A` | Enterprise and safety evaluation | Protected CI artifact | Pending |

## Expected versus current result

| Measure | Expected | Current |
| --- | --- | --- |
| Corpus | Approved, immutable, non-sensitive snapshot | Deterministic fixtures exist; enterprise corpus not approved |
| Retrieval | Stable cited passages and refusal | Implemented and locally tested against fixtures at `175a39c`; protected CI pending |
| Runtime/model | None required for first acceptance | No runtime claimed |

## Acceptance decision

**Source implemented; not accepted.** Accept the offline retrieval slice only
after the local commit is published to the authoritative GitLab project, the
protected source pipeline passes, the corpus is approved, and the evidence is
reviewed. Citation, refusal, provider-outage, access-partition, cache-isolation,
and deterministic evaluation tests pass locally. LLM generation, model
selection, runtime serving, and deployment remain separate work.

## Operational, security, and follow-up notes

- Retrieved text is untrusted content; it cannot override system policy.
- Do not use output for clinical diagnosis, treatment, coverage, or payment
  decisions.
- A later model integration must name endpoint, data boundary, audit, human
  review, observability, cost, and shutdown controls.
- Copy implementation stories to the healthcare-AI GitLab project and return
  CI evidence here.
