# UC-AI-012: AI Release Governance

Last reviewed: 2026-08-13

## Use-case record

| Field | Value |
| --- | --- |
| Canonical portfolio use case | AI Release Governance |
| Primary platform | Enterprise Healthcare AI Platform |
| Supporting use cases | [UC-CICD-001](../devsecops/UC-CICD-001-end-to-end-cicd-pipeline.md), [UC-CICD-007](../devsecops/UC-CICD-007-environment-based-release-promotion.md), [UC-OBS-008](../observability/UC-OBS-008-deployment-health-scoring.md), [UC-DATA-015](../data/UC-DATA-015-data-classification.md) |
| Enterprise alignment | Provider operations, payer operations, shared digital platform, risk and compliance |
| Enterprise outcome | provide bounded and reviewable AI assistance without delegating regulated decisions |
| Primary implementation repository | `midhhealth/ai-and-ml-platform/healthcare-ai-platform` |
| Jira epic | `EPIC-AI-012` — Implement AI Release Governance |
| Change record | Required before any mutating or runtime action; not required for fixture-only CI |
| Target | existing GitLab shared runner, approved repository content, synthetic fixtures, and protected CI artifacts |
| Current state | **Planned — detailed design only; implementation and runtime evidence are not claimed** |
| Infrastructure boundary | Reuse the existing lab; do not create a new model server, vector database, VM, GPU host, cluster workload, cloud API, live clinical integration, or protected data |
| Owner | Enterprise Healthcare AI Platform team |

## Purpose

AI Release Governance defines the healthcare-safe behavior needed for **Reviewable promotion across development, QA, stage and production** before AI output can influence an enterprise workflow.

For AI Release Governance, the design fixes the contract, dependency handoffs, target boundary, evidence, decision owners, and recovery path before implementation. Those choices keep the eventual build grounded in the lab that actually exists.

## Expected outcome

The first delivery slice proves **Reviewable promotion across development, QA, stage and production** on the documented
existing target boundary. It uses a versioned contract plus positive, negative,
malformed-input, unauthorized-scope, and recovery fixtures, then publishes an
attributable machine-readable result.

Acceptance for AI Release Governance requires rejected cases to stop safely and unrelated
state to remain unchanged. Live integration or mutation still requires the
separate approval, identity, canary, and rollback controls named below; this
design does not authorize a product installation, new capacity, or an unlisted
endpoint.

## Platform and enterprise fit

| Relationship | Architecture fit |
| --- | --- |
| Owning responsibility | **Enterprise Healthcare AI Platform** owns the contract, control behavior, evidence schema, and recovery boundary for AI Release Governance. |
| Enterprise use | provide bounded and reviewable AI assistance without delegating regulated decisions. |
| Required inputs | behavior contract, approved corpus/data digest, component version, user role, and evaluation cases. |
| Produced handoff | offline safety and quality decision with human-review and shutdown requirements. |
| Supporting platforms | The dependency table below names the exact use cases and artifacts; passing this page never implies that those controls passed. |
| Existing-lab boundary | Reuse the existing lab; do not create a new model server, vector database, VM, GPU host, cluster workload, cloud API, live clinical integration, or protected data. |

## Trigger and actors

| Item | Definition |
| --- | --- |
| Trigger | Merge request, protected scheduled evaluation, approved operator request, source/data event, or monitored condition defined by the implementation contract |
| Primary actors | clinical/product owner, AI engineer, data steward, security/privacy reviewer, and model-risk reviewer |
| Request owner | States the desired outcome, scope, urgency, and enterprise consumer |
| Platform owner | Owns the policy, accepted execution path, target boundary, and safe-stop behavior |
| Reviewer or approver | Confirms risk, prerequisites, evidence requirements, and any exception before a mutating step |
| Evidence consumer | Uses the result for human review, safety, privacy, model-risk, release, monitoring, and incident decisions |

## Preconditions

- The named repository, source revision, and target resolve to current
  enterprise inventory; synthetic fixtures are permitted for source-only tests.
- The implementation contract defines the scope required to demonstrate:
  **Reviewable promotion across development, QA, stage and production**
- Credentials, if later required, come only from an existing protected
  credential boundary and are never stored in source, logs, screenshots, or
  result artifacts.
- Protected healthcare data is excluded unless a separate approved data
  classification and handling design explicitly permits it.
- Tool, API, schema, rule, query, model, or configuration versions that affect
  the decision are pinned or recorded.
- A non-mutating plan, fixture, query, or dry-run path is available before any
  approved bounded change.
- Recovery means either a verified zero-change stop or an identified restore
  source and tested reversal procedure.

## Scope and exclusions

In scope:

- the versioned contract for AI Release Governance;
- explicit input, owner, target, policy, threshold, and decision semantics;
- positive, negative, missing-input, unauthorized-target, and malformed-result
  fixture behavior;
- read-only evaluation or an approved bounded action on an existing target;
- sanitized machine-readable evidence and reviewer-visible diagnostics;
- exception ownership and expiry; and
- safe stop, idempotence, rollback, restore, or reconciliation evidence as
  appropriate to the activity.

Out of scope:

- installing a product, creating a VM/runner/cluster/database/service, or
  allocating new capacity;
- treating a provisioned-only, planned, or unverified product as available;
- broad production rollout, unrestricted remediation, or bypass of change
  approval;
- embedding credentials or protected data in source and evidence;
- claiming source completion, runtime verification, or acceptance from this
  documentation; and
- replacing adjacent platform gates owned by other use cases.

## Design walkthrough

A useful way for a new engineer to understand AI Release Governance is to follow an approved
question and evidence source through retrieval, review and a bounded answer. The result
MidhHealth needs is to provide bounded and reviewable AI assistance without delegating regulated
decisions. Enterprise Healthcare AI Platform team owns the platform decision, while the
consuming service or business owner still accepts the effect on its workflow.

Follow the information rather than the products: ownership and classification travel with it,
including on rejected and replayed paths. In this page, **UC-CICD-001: End-to-End CI/CD Pipeline
Setup** contributes source-to-artifact pipeline provenance and stage outcome; **UC-CICD-007:
Environment-Based Release Promotion** contributes environment promotion contract and approval
evidence. The first buildable boundary is existing GitLab shared runner, approved repository
content, synthetic fixtures, and protected CI artifacts. The design stops at this rule: Reuse
the existing lab; do not create a new model server, vector database, VM, GPU host, cluster
workload, cloud API, live clinical integration, or protected data.

The walkthrough becomes useful when the happy path breaks. If contract or policy is
missing/invalid, the expected response is to Correct through reviewed source and rerun fixtures.
The leading design threat is prompt, retrieved content, model output, or tool request crossing a
data or authorization boundary; therefore a green source job, screenshot or reachable endpoint
is supporting evidence, not acceptance by itself.

## Architecture context

AI Release Governance is evaluated inside the existing enterprise lab and the owning
platform's current source-control and execution boundaries. The architectural
unit is the governed outcome—**Reviewable promotion across development, QA, stage and production**—rather than a new product or
environment.

| Context element | Architecture statement |
| --- | --- |
| Business and operational setting | Enterprise consumers: Provider operations, payer operations, shared digital platform, risk and compliance. The result must be explainable, repeatable, and owned. |
| Current state | **Planned — detailed design only; implementation and runtime evidence are not claimed** |
| Desired state | A reviewed contract drives a bounded result, machine-readable evidence, and a safe stop or recovery decision. |
| Existing target boundary | existing GitLab shared runner, approved repository content, synthetic fixtures, and protected CI artifacts |
| Infrastructure constraint | Reuse the existing lab; do not create a new model server, vector database, VM, GPU host, cluster workload, cloud API, live clinical integration, or protected data |
| Accountable platform owner | Enterprise Healthcare AI Platform team; the consuming service, data, security, or workflow owner remains accountable for accepting business impact. |

The page owns the contract, control logic, evidence, and recovery behavior for
AI Release Governance. It does not absorb the responsibilities of the dependency use cases
listed below.

## Architecture diagram

![UC-AI-012 architecture showing demand, source contracts, planned control, existing target, evidence, and recovery](../../assets/use-cases/UC-AI-012/UC-AI-012-architecture.svg)

Follow the information, not the boxes. The main route keeps contract, classification, processing, and consumption visible; the orange route is where refused or replayable work waits for a human decision.

## Dependencies and handoffs

AI Release Governance remains accountable to its primary platform. The dependencies below
provide explicit contracts or assurance evidence; they do not become alternate owners.

| Relationship | Use case | Required handoff | Failure propagation |
| --- | --- | --- | --- |
| Required upstream contract | [UC-CICD-001: End-to-End CI/CD Pipeline Setup](../devsecops/UC-CICD-001-end-to-end-cicd-pipeline.md) | source-to-artifact pipeline provenance and stage outcome | Missing, stale, or failed evidence blocks promotion or runtime action. |
| Required upstream contract | [UC-CICD-007: Environment-Based Release Promotion](../devsecops/UC-CICD-007-environment-based-release-promotion.md) | environment promotion contract and approval evidence | Missing, stale, or failed evidence blocks promotion or runtime action. |
| Coordinated assurance handoff | [UC-OBS-008: Deployment Health Scoring](../observability/UC-OBS-008-deployment-health-scoring.md) | deployment-health score and promotion/rollback signal | Missing, stale, or failed evidence blocks promotion or runtime action. |
| Coordinated assurance handoff | [UC-DATA-015: Data Classification](../data/UC-DATA-015-data-classification.md) | data classification and permitted handling rules | Missing, stale, or failed evidence blocks promotion or runtime action. |

Before AI Release Governance is implemented, every handoff must resolve to an immutable
revision and machine-readable artifact. A URL, screenshot, or verbal approval
alone is not sufficient dependency evidence.

## Quality attributes

For AI Release Governance, quality is measured against the bounded enterprise outcome—not
document length or a green job. Unapproved business thresholds remain explicit
decisions and must not be invented.

| Attribute | Required measure or invariant | Decision state |
| --- | --- | --- |
| Functional correctness | Every required input is validated; **Reviewable promotion across development, QA, stage and production** is evaluated against positive, negative, missing-input, and unauthorized-scope cases. | Fixed design requirement |
| Performance and scale | Establish a baseline for safety-case coverage, citation or decision accuracy, latency baseline, and review burden on existing capacity; the owner must approve warning and blocking thresholds before runtime promotion. | Thresholds `TBD` before implementation |
| Reliability | Missing prerequisites, stale dependencies, malformed evidence, and partial results fail closed without widening scope. | Fixed design requirement |
| Recovery | Record the maximum acceptable interruption and recovery time before runtime use; source-only validation must remain zero-change. | Owner decision required before runtime exercise |
| Observability | Emit use-case ID, revision, target, executor, start/end time, duration, decision, reason code, and recovery reference. | Required in the result schema |
| Evidence retention | Assign classification, retention period, and deletion owner before storing runtime evidence. | Security/compliance decision required |

Load, latency, availability, retention, RTO, and RPO values for AI Release Governance become
requirements only after the named service or business owner approves them. Until
then, the implementation gate records them as unresolved instead of quietly
choosing defaults.

## Security and privacy architecture

The AI Release Governance design separates source validation, privileged execution, target
access, and evidence review. Those boundaries remain in force even when one
engineer can access more than one system.

| Trust boundary | Allowed flow | Required control |
| --- | --- | --- |
| Contributor → GitLab | Reviewed source, contract, and synthetic/sanitized fixtures | Protected branch rules, peer review, secret scanning, and immutable commit identity |
| GitLab runner → result artifact | Read-only evaluation inputs and machine-readable output | No target-changing credential; pinned tool versions; artifact checksum and expiry |
| Approval plane → executor | Approved revision, target allowlist, mode, canary, and change reference | Separate authorization through the existing Jenkins/AWX or platform control path |
| Executor → existing target | Minimum commands or API operations required for AI Release Governance | Least-privilege identity, explicit target limit, timeout, and stop condition |
| Target → evidence store | Sanitized metadata, measurements, decision, and recovery result | Exclude credentials, tokens, private keys, kubeconfigs, packet payloads, PHI, PII, and unrelated records |

For AI Release Governance, the primary threat is **prompt, retrieved content, model output, or tool request crossing a data or authorization boundary**. The mandatory response is
synthetic/de-identified fixtures, role-aware policy, untrusted-content isolation, refusal tests, human review, and artifact redaction. Authentication and authorization mappings must name
the existing identity source, principal or service account, permitted actions,
credential owner, rotation path, and emergency revocation procedure before a
runtime story can move beyond `Planned`.

## Architecture decisions and trade-offs

| Decision | Selected architecture | Alternative deferred or rejected | Rationale and status |
| --- | --- | --- | --- |
| First implementation slice | Contract, schema, fixtures, and read-only evidence on the existing GitLab runner | Product installation or broad runtime rollout | Proves behavior without expanding infrastructure; **approved design direction** |
| Runtime execution | Use only Existing GitLab shared runner when current inventory and change approval confirm it is available | Direct operator changes or credentials in CI | Preserves separation of duties; **conditional on implementation review** |
| Evidence | Machine-readable result is authoritative; screenshots are optional supporting material | Screenshot-only acceptance | Enables repeatable audit and automated gates; **approved design direction** |
| Failure handling | Fail closed, preserve bounded diagnostics, and recover only the named scope | Continue with partial or stale evidence | Prevents false success and hidden blast radius; **approved design direction** |
| New capacity or product | Stop and raise a separate architecture decision | Silently add a VM, service, cloud dependency, or cluster add-on | Maintains the existing-lab constraint; **mandatory** |

### Open decisions before implementation

| Open decision | Decision owner | Resolution gate |
| --- | --- | --- |
| Exact inventory object and first canary | Platform owner plus consuming service/data owner | Must resolve before the implementation story leaves `Planned` |
| Performance, scale, and reliability thresholds | Service owner and SRE | Must be recorded before a runtime acceptance run |
| Identity-to-action authorization matrix | Platform owner and security reviewer | Must be approved before target credentials are attached |
| Evidence classification and retention | Data/security owner | Must be approved before runtime artifacts are retained |

If any selected approach changes, record the rationale beside UC-AI-012 in
the implementation repository before code review. A documentation edit alone
does not approve the new architecture.

## Implementation design

The first AI Release Governance implementation is deliberately source-only. Its planned files live in the existing repository; none provisions infrastructure.

| Planned source responsibility | Exact planned location |
| --- | --- |
| Use-case contract and target allowlist | `midhhealth/ai-and-ml-platform/healthcare-ai-platform/contracts/uc-ai-012.yaml` |
| Primary implementation | `midhhealth/ai-and-ml-platform/healthcare-ai-platform/src/evaluations/ai_release_governance.py`; entry point: the `evaluate_ai_release_governance` offline evaluator |
| Machine-readable result schema | `midhhealth/ai-and-ml-platform/healthcare-ai-platform/schemas/uc-ai-012-result.schema.json` |
| Positive, negative, malformed, and recovery fixtures | `midhhealth/ai-and-ml-platform/healthcare-ai-platform/tests/fixtures/uc-ai-012/` |
| GitLab source gate | `midhhealth/ai-and-ml-platform/healthcare-ai-platform/.gitlab/ci/uc-ai-012.yml` |
| Operator diagnosis and recovery | `midhhealth/ai-and-ml-platform/healthcare-ai-platform/docs/runbooks/uc-ai-012.md` |

### Delivery stages

1. **Contract:** add the contract, schema, owners, dependency revisions, target
   allowlist, modes, reason codes, and open-decision values.
2. **Source validation:** lint exact paths, validate schema compatibility, scan
   for sensitive content, and run every fixture on the existing runner.
3. **Read-only proof:** execute the `evaluate_ai_release_governance` offline evaluator, publish a checksummed result, and
   prove that blocked cases cannot reach a mutating path.
4. **Bounded execution:** only after separate approval, pass the immutable
   revision, target, mode, canary, and change ID to Existing GitLab shared runner.
5. **Independent verification:** measure the expected result, confirm unrelated
   state is unchanged, run recovery or zero-change proof, and obtain owner
   review.

The implementation merge request must link this page, the dependency artifacts,
the decision values above, and the eventual pipeline/job/run identifiers. Code
completion alone cannot promote the page to runtime verified.

## Code and configuration map

These are exact **planned** repository-relative locations in the existing
GitLab project. Their inclusion is an implementation contract, not a claim that
the files already exist.

| Repository and planned path | Responsibility | Current state |
| --- | --- | --- |
| `midhhealth/ai-and-ml-platform/healthcare-ai-platform/contracts/uc-ai-012.yaml` | Inputs, owner, dependency revisions, target allowlist, modes, thresholds, and stop conditions | Planned |
| `midhhealth/ai-and-ml-platform/healthcare-ai-platform/src/evaluations/ai-release-governance.py` | Primary implementation through the `evaluate_ai_release_governance` offline evaluator | Planned |
| `midhhealth/ai-and-ml-platform/healthcare-ai-platform/schemas/uc-ai-012-result.schema.json` | Provenance, observations, decision, reason codes, safety, and recovery result | Planned |
| `midhhealth/ai-and-ml-platform/healthcare-ai-platform/tests/fixtures/uc-ai-012/` | Passing, blocking, malformed, unauthorized, stale-dependency, and recovery cases | Planned |
| `midhhealth/ai-and-ml-platform/healthcare-ai-platform/.gitlab/ci/uc-ai-012.yml` | Source validation on an accepted existing runner | Planned |
| `midhhealth/ai-and-ml-platform/healthcare-ai-platform/docs/runbooks/uc-ai-012.md` | Preconditions, execution, diagnosis, evidence review, safe stop, and recovery | Planned |

Implementation must verify the repository and current execution path before
creating these files. Discovery of a missing product or capacity stops the
story and raises a separate decision; it does not change this page's
infrastructure boundary.

## Failure and recovery model

| Failure condition | Expected behavior | Recovery or safe stop |
| --- | --- | --- |
| Contract or policy is missing/invalid | Fail before target access | Correct through reviewed source and rerun fixtures |
| Target is absent, ambiguous, or outside inventory | Deny execution | Update authoritative inventory through separate governance; do not guess |
| Required product or executor is unavailable | Block and report the unmet prerequisite | Wait for separately approved acceptance or select only an already accepted compatible path |
| Read-only result differs from expectation | Stop before mutation | Review baseline, scope, data freshness, and policy; revise source if needed |
| Bounded action partially succeeds | Trigger the documented stop and recovery decision | Restore from the named source or reconcile to the last accepted revision |
| Evidence is missing, malformed, or contains sensitive material | Reject and quarantine the result | Remove exposure, rotate affected credentials if needed, record an incident, and rerun safely |
| Post-check fails or an unrelated object changes | Do not expand beyond the canary | Recover the canary, reconcile unexpected state, and require owner review |
| Recovery cannot be proven | Mark blocked, not accepted | Preserve state/evidence and escalate through incident and change governance |

## Jira breakdown

### STORY-AI-012-001: Define the AI Release Governance contract

**Description:** Exercise one approved scope and publish evidence that the observed result matches the contract, unrelated state remains unchanged, and recovery or zero-change behavior works. The accountable owner records acceptance or rejection.

**Status:** Planned.

**Acceptance criteria:** Given current enterprise inventory, when the contract
is reviewed, then it names the owner, immutable input, accepted target/executor,
coverage statement, policy or threshold, output, evidence, exception process,
and safe stop; it rejects unavailable products, sensitive inputs, and new-
infrastructure actions.

**Implementation steps:** Write `midhhealth/ai-and-ml-platform/healthcare-ai-platform/docs/runbooks/uc-ai-012.md`; reconfirm inventory and dependency evidence; run source and read-only modes; obtain separate approval for one canary if mutation is required; collect the schema-valid result, independent post-check, recovery proof, and owner decision.

**Completed work:** The purpose, platform fit, enterprise outcome, operational
flow, controls, and future delivery contract are documented on this page. No
implementation commit or runtime result is claimed.

**Validation and rollback:** Review the design against the canonical portfolio,
inventory, product state, and no-new-infrastructure rule. Revert the
documentation revision if an incorrect dependency or boundary is found.

**Required attachments:** Future `ART-AI-012-001A` contract and fixture review.

### STORY-AI-012-002: Build the source and evidence gate

**Description:** The implementation owner needs a fail-closed source workflow
that evaluates AI Release Governance, produces normalized evidence, and controls only its
declared downstream decisions.

**Status:** Planned.

**Acceptance criteria:** Given valid fixtures, the future job produces the
expected allow or not-applicable decision and complete provenance; given an
invalid contract, unauthorized target, failed policy, malformed result, or
sensitive output, it fails and blocks the named downstream path.

**Implementation steps:** Implement the reviewed contract and result schema in
the named repository; pin decision-affecting tools; connect an accepted runner;
add fixture and redaction checks; declare downstream dependencies; document
diagnosis and safe stop.

**Completed work:** Source responsibilities and required fixture behaviors are
specified. Implementation is intentionally deferred.

**Validation and rollback:** Exercise positive, blocking, missing-input,
malformed-output, unauthorized-target, exception-expiry, and redaction cases.
Revert the source commit if the new gate misclassifies established behavior.

**Required attachments:** Future `ART-AI-012-002A` source validation and
`ART-AI-012-002B` downstream-block proof.

### STORY-AI-012-003: Verify the bounded outcome and recovery

**Description:** Platform and enterprise reviewers need evidence that the
future workflow satisfies **Reviewable promotion across development, QA, stage and production** on its named scope without hidden
effects and can stop or recover safely.

**Status:** Planned.

**Acceptance criteria:** Given approved prerequisites and target, when the
future evaluation or canary runs, then the observed result is compared with the
expected statement, unrelated objects remain unchanged, recovery or zero-change
is proven, exceptions and incidents are reconciled, and reviewers publish an
explicit acceptance or rejection.

**Implementation steps:** Reconfirm inventory and idle state; run fixture or
read-only mode; obtain change approval if mutation applies; execute one bounded
canary; collect the normalized result; run independent post-check and recovery;
publish evidence and owner decision here.

**Completed work:** Acceptance, evidence, and recovery requirements are fully
planned. No live evaluation, mutation, rollback, or acceptance is claimed.

**Validation and rollback:** Compare expected and observed state, verify the
evidence checksum and sensitive-data boundary, exercise the recovery or non-
mutation proof, and retain incident/action links. Failed recovery leaves the
use case blocked.

**Required attachments:** Future `ART-AI-012-003A` bounded result,
`ART-AI-012-003B` recovery/non-mutation proof, and an optional sanitized
`ATT-AI-012-003A` only when a real capture adds review value.

## Evidence and screenshot register

| ID | Planned evidence | Source | Current status |
| --- | --- | --- | --- |
| `ART-AI-012-001A` | Reviewed contract, inventory, dependency, and fixture design | Architecture and implementation repository review | Pending future implementation |
| `ART-AI-012-002A` | Positive and negative source-gate results | Existing GitLab and accepted runner | Pending future execution |
| `ART-AI-012-002B` | Failed-decision proof showing the declared downstream path blocked | Existing delivery pipeline | Pending future execution |
| `ART-AI-012-003A` | Bounded observed result compared with **Reviewable promotion across development, QA, stage and production** | Approved existing execution path | Pending future execution |
| `ART-AI-012-003B` | Recovery, restore, idempotence, reconciliation, or zero-change proof | Approved existing execution path | Pending future execution |

## Expected versus current result

| Measure | Expected future result | Current result |
| --- | --- | --- |
| Canonical coverage | Reviewable promotion across development, QA, stage and production | Detailed behavior and decision semantics documented |
| Platform fit | Controlled result supports human review, safety, privacy, model-risk, release, monitoring, and incident decisions | Owning-platform relationships documented |
| Enterprise fit | provide bounded and reviewable AI assistance without delegating regulated decisions | Enterprise value, ownership, and evidence contract documented |
| Infrastructure | Existing inventoried targets and accepted execution paths only | No new infrastructure authorized |
| Implementation | Reviewed source contract, schema, fixtures, and fail-closed gate | Not scheduled |
| Runtime or bounded acceptance | Observed result plus recovery/non-mutation evidence and owner review | Not run |

## Acceptance decision

**Planned.** The architecture baseline is documented; implementation and runtime acceptance remain separate governed work. Code complete will require reviewed source and
passing positive and negative validation in `midhhealth/ai-and-ml-platform/healthcare-ai-platform`. Runtime verified requires
the expected result on the named existing scope plus independent post-check and
recovery/non-mutation evidence. Accepted additionally requires owner review,
exception and incident reconciliation, evidence publication, and a clean
architecture repository.

## Operational, security, and follow-up notes

- Move into implementation only through the planned source story; this page does not authorize code execution or a lab change.
- Recheck current environment state before selecting any product, endpoint,
  runner, inventory, cluster, database, model, dataset, or network target.
- Use synthetic or approved de-identified fixtures and sanitize diagnostics.
- Stop when scope, ownership, capacity, data classification, or recovery is
  unclear.
- Preserve the separation between source validation, approval, bounded
  execution, evidence review, and acceptance.
- Return future commit, pipeline/job/run, observed-result, recovery, exception,
  incident, and owner-review evidence to this page.
