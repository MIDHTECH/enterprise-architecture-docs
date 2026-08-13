# UC-K8S-010: Workload Right-Sizing

Last reviewed: 2026-08-13

## Use-case record

| Field | Value |
| --- | --- |
| Canonical portfolio use case | Workload Right-Sizing |
| Primary platform | Enterprise Kubernetes Platform with GitOps |
| Supporting use cases | [UC-INFRA-001](../infrastructure/UC-INFRA-001-terraform-drift-detection.md), [UC-NET-018](../network/UC-NET-018-kubernetes-networking.md), [UC-GOV-003](../governance/UC-GOV-003-secure-secrets-management-for-applications.md), [UC-OBS-002](../observability/UC-OBS-002-kubernetes-cluster-health-monitoring.md) |
| Enterprise alignment | Shared digital platform, operational resilience, risk and compliance |
| Enterprise outcome | provide a controlled runtime for provider, payer, data, and platform workloads |
| Primary GitLab repository | `midhhealth/platform-engineering/kubernetes-platform-gitops` |
| Jira epic | `EPIC-K8S-010` — Implement Workload Right-Sizing |
| Change record | Required before any mutating or runtime action; not required for fixture-only CI |
| Target | existing four-node application cluster, jenkins-agent01, GitLab, Jenkins, and accepted storage and ingress |
| Current state | **Planned — detailed design only; implementation and runtime evidence are not claimed** |
| Infrastructure boundary | Reuse the existing lab; do not create a new cluster, node, VM, IP address, load balancer, storage system, or unapproved add-on |
| Owner | Enterprise Kubernetes Platform with GitOps team |

## Purpose

Workload Right-Sizing establishes **CPU and memory requests are adjusted from observed utilization** for the existing application cluster while preserving namespace, policy, and recovery boundaries.

For Workload Right-Sizing, the design fixes the contract, dependency handoffs, target boundary, evidence, decision owners, and recovery path before implementation. Those choices keep the eventual build grounded in the lab that actually exists.

## Expected outcome

The first delivery slice proves **CPU and memory requests are adjusted from observed utilization** on the documented
existing target boundary. It uses a versioned contract plus positive, negative,
malformed-input, unauthorized-scope, and recovery fixtures, then publishes an
attributable machine-readable result.

Acceptance for Workload Right-Sizing requires rejected cases to stop safely and unrelated
state to remain unchanged. Live integration or mutation still requires the
separate approval, identity, canary, and rollback controls named below; this
design does not authorize a product installation, new capacity, or an unlisted
endpoint.

## Platform and enterprise fit

| Relationship | Architecture fit |
| --- | --- |
| Owning responsibility | **Enterprise Kubernetes Platform with GitOps** owns the contract, control behavior, evidence schema, and recovery boundary for Workload Right-Sizing. |
| Enterprise use | provide a controlled runtime for provider, payer, data, and platform workloads. |
| Required inputs | immutable workload intent, cluster identity, namespace boundary, and policy set. |
| Produced handoff | validated desired-state decision with bounded reconciliation and recovery evidence. |
| Supporting platforms | The dependency table below names the exact use cases and artifacts; passing this page never implies that those controls passed. |
| Existing-lab boundary | Reuse the existing lab; do not create a new cluster, node, VM, IP address, load balancer, storage system, or unapproved add-on. |

## Trigger and actors

| Item | Definition |
| --- | --- |
| Trigger | Merge request, protected scheduled evaluation, approved operator request, source/data event, or monitored condition defined by the implementation contract |
| Primary actors | platform engineer, application owner, SRE, security reviewer, and change approver |
| Request owner | States the desired outcome, scope, urgency, and enterprise consumer |
| Platform owner | Owns the policy, accepted execution path, target boundary, and safe-stop behavior |
| Reviewer or approver | Confirms risk, prerequisites, evidence requirements, and any exception before a mutating step |
| Evidence consumer | Uses the result for cluster policy, workload health, release, rollback, and service-resilience decisions |

## Preconditions

- The named repository, source revision, and target resolve to current
  enterprise inventory; synthetic fixtures are permitted for source-only tests.
- The implementation contract defines the scope required to demonstrate:
  **CPU and memory requests are adjusted from observed utilization**
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

- the versioned contract for Workload Right-Sizing;
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

## Architecture context

Workload Right-Sizing is evaluated inside the existing enterprise lab and the owning
platform's current source-control and execution boundaries. The architectural
unit is the governed outcome—**CPU and memory requests are adjusted from observed utilization**—rather than a new product or
environment.

| Context element | Architecture statement |
| --- | --- |
| Business and operational setting | Enterprise consumers: Shared digital platform, operational resilience, risk and compliance. The result must be explainable, repeatable, and owned. |
| Current state | **Planned — detailed design only; implementation and runtime evidence are not claimed** |
| Desired state | A reviewed contract drives a bounded result, machine-readable evidence, and a safe stop or recovery decision. |
| Existing target boundary | existing four-node application cluster, jenkins-agent01, GitLab, Jenkins, and accepted storage and ingress |
| Infrastructure constraint | Reuse the existing lab; do not create a new cluster, node, VM, IP address, load balancer, storage system, or unapproved add-on |
| Accountable platform owner | Enterprise Kubernetes Platform with GitOps team; the consuming service, data, security, or workflow owner remains accountable for accepting business impact. |

The page owns the contract, control logic, evidence, and recovery behavior for
Workload Right-Sizing. It does not absorb the responsibilities of the dependency use cases
listed below.

## Architecture diagram

![UC-K8S-010 architecture showing demand, source contracts, planned control, existing target, evidence, and recovery](../../assets/use-cases/UC-K8S-010/UC-K8S-010-architecture.svg)

The center is the outcome the team cares about. The surrounding loop senses, compares, decides, verifies, and learns; it only closes when an accountable owner accepts the evidence.

## Dependencies and handoffs

Workload Right-Sizing remains accountable to its primary platform. The dependencies below
provide explicit contracts or assurance evidence; they do not become alternate owners.

| Relationship | Use case | Required handoff | Failure propagation |
| --- | --- | --- | --- |
| Required upstream contract | [UC-INFRA-001: Terraform Drift Detection](../infrastructure/UC-INFRA-001-terraform-drift-detection.md) | desired/observed infrastructure identity and drift result | Missing, stale, or failed evidence blocks promotion or runtime action. |
| Required upstream contract | [UC-NET-018: Kubernetes Networking](../network/UC-NET-018-kubernetes-networking.md) | cluster network identity and service-path contract | Missing, stale, or failed evidence blocks promotion or runtime action. |
| Coordinated assurance handoff | [UC-GOV-003: Secure Secrets Management for Applications](../governance/UC-GOV-003-secure-secrets-management-for-applications.md) | application secret-injection and workload identity boundary | Missing, stale, or failed evidence blocks promotion or runtime action. |
| Coordinated assurance handoff | [UC-OBS-002: Kubernetes Cluster Health Monitoring](../observability/UC-OBS-002-kubernetes-cluster-health-monitoring.md) | cluster health and workload diagnostic evidence | Missing, stale, or failed evidence blocks promotion or runtime action. |

Before Workload Right-Sizing is implemented, every handoff must resolve to an immutable
revision and machine-readable artifact. A URL, screenshot, or verbal approval
alone is not sufficient dependency evidence.

## Quality attributes

For Workload Right-Sizing, quality is measured against the bounded enterprise outcome—not
document length or a green job. Unapproved business thresholds remain explicit
decisions and must not be invented.

| Attribute | Required measure or invariant | Decision state |
| --- | --- | --- |
| Functional correctness | Every required input is validated; **CPU and memory requests are adjusted from observed utilization** is evaluated against positive, negative, missing-input, and unauthorized-scope cases. | Fixed design requirement |
| Performance and scale | Establish a baseline for reconciliation time, policy accuracy, workload health, and namespace isolation on existing capacity; the owner must approve warning and blocking thresholds before runtime promotion. | Thresholds `TBD` before implementation |
| Reliability | Missing prerequisites, stale dependencies, malformed evidence, and partial results fail closed without widening scope. | Fixed design requirement |
| Recovery | Record the maximum acceptable interruption and recovery time before runtime use; source-only validation must remain zero-change. | Owner decision required before runtime exercise |
| Observability | Emit use-case ID, revision, target, executor, start/end time, duration, decision, reason code, and recovery reference. | Required in the result schema |
| Evidence retention | Assign classification, retention period, and deletion owner before storing runtime evidence. | Security/compliance decision required |

Load, latency, availability, retention, RTO, and RPO values for Workload Right-Sizing become
requirements only after the named service or business owner approves them. Until
then, the implementation gate records them as unresolved instead of quietly
choosing defaults.

## Security and privacy architecture

The Workload Right-Sizing design separates source validation, privileged execution, target
access, and evidence review. Those boundaries remain in force even when one
engineer can access more than one system.

| Trust boundary | Allowed flow | Required control |
| --- | --- | --- |
| Contributor → GitLab | Reviewed source, contract, and synthetic/sanitized fixtures | Protected branch rules, peer review, secret scanning, and immutable commit identity |
| GitLab runner → result artifact | Read-only evaluation inputs and machine-readable output | No target-changing credential; pinned tool versions; artifact checksum and expiry |
| Approval plane → executor | Approved revision, target allowlist, mode, canary, and change reference | Separate authorization through the existing Jenkins/AWX or platform control path |
| Executor → existing target | Minimum commands or API operations required for Workload Right-Sizing | Least-privilege identity, explicit target limit, timeout, and stop condition |
| Target → evidence store | Sanitized metadata, measurements, decision, and recovery result | Exclude credentials, tokens, private keys, kubeconfigs, packet payloads, PHI, PII, and unrelated records |

For Workload Right-Sizing, the primary threat is **a manifest escaping its namespace, identity, image, or network boundary**. The mandatory response is
cluster-identity guards, namespace allowlists, policy checks, immutable images, and least-privilege service accounts. Authentication and authorization mappings must name
the existing identity source, principal or service account, permitted actions,
credential owner, rotation path, and emergency revocation procedure before a
runtime story can move beyond `Planned`.

## Architecture decisions and trade-offs

| Decision | Selected architecture | Alternative deferred or rejected | Rationale and status |
| --- | --- | --- | --- |
| First implementation slice | Contract, schema, fixtures, and read-only evidence on the existing GitLab runner | Product installation or broad runtime rollout | Proves behavior without expanding infrastructure; **approved design direction** |
| Runtime execution | Use only Approved cluster delivery path when current inventory and change approval confirm it is available | Direct operator changes or credentials in CI | Preserves separation of duties; **conditional on implementation review** |
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

If any selected approach changes, record the rationale beside UC-K8S-010 in
the implementation repository before code review. A documentation edit alone
does not approve the new architecture.

## Implementation design

The first Workload Right-Sizing implementation is deliberately source-only. Its planned files live in the existing repository; none provisions infrastructure.

| Planned source responsibility | Exact planned location |
| --- | --- |
| Use-case contract and target allowlist | `midhhealth/platform-engineering/kubernetes-platform-gitops/contracts/uc-k8s-010.yaml` |
| Primary implementation | `midhhealth/platform-engineering/kubernetes-platform-gitops/use-cases/workload-right-sizing/policy.yaml`; entry point: the `workload-right-sizing` validation and reconciliation entry point |
| Machine-readable result schema | `midhhealth/platform-engineering/kubernetes-platform-gitops/schemas/uc-k8s-010-result.schema.json` |
| Positive, negative, malformed, and recovery fixtures | `midhhealth/platform-engineering/kubernetes-platform-gitops/tests/fixtures/uc-k8s-010/` |
| GitLab source gate | `midhhealth/platform-engineering/kubernetes-platform-gitops/.gitlab/ci/uc-k8s-010.yml` |
| Operator diagnosis and recovery | `midhhealth/platform-engineering/kubernetes-platform-gitops/docs/runbooks/uc-k8s-010.md` |

### Delivery stages

1. **Contract:** add the contract, schema, owners, dependency revisions, target
   allowlist, modes, reason codes, and open-decision values.
2. **Source validation:** lint exact paths, validate schema compatibility, scan
   for sensitive content, and run every fixture on the existing runner.
3. **Read-only proof:** execute the `workload-right-sizing` validation and reconciliation entry point, publish a checksummed result, and
   prove that blocked cases cannot reach a mutating path.
4. **Bounded execution:** only after separate approval, pass the immutable
   revision, target, mode, canary, and change ID to Approved cluster delivery path.
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
| `midhhealth/platform-engineering/kubernetes-platform-gitops/contracts/uc-k8s-010.yaml` | Inputs, owner, dependency revisions, target allowlist, modes, thresholds, and stop conditions | Planned |
| `midhhealth/platform-engineering/kubernetes-platform-gitops/use-cases/workload-right-sizing/policy.yaml` | Primary implementation through the `workload-right-sizing` validation and reconciliation entry point | Planned |
| `midhhealth/platform-engineering/kubernetes-platform-gitops/schemas/uc-k8s-010-result.schema.json` | Provenance, observations, decision, reason codes, safety, and recovery result | Planned |
| `midhhealth/platform-engineering/kubernetes-platform-gitops/tests/fixtures/uc-k8s-010/` | Passing, blocking, malformed, unauthorized, stale-dependency, and recovery cases | Planned |
| `midhhealth/platform-engineering/kubernetes-platform-gitops/.gitlab/ci/uc-k8s-010.yml` | Source validation on an accepted existing runner | Planned |
| `midhhealth/platform-engineering/kubernetes-platform-gitops/docs/runbooks/uc-k8s-010.md` | Preconditions, execution, diagnosis, evidence review, safe stop, and recovery | Planned |

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

### STORY-K8S-010-001: Define the Workload Right-Sizing contract

**Description:** Exercise one approved scope and publish evidence that the observed result matches the contract, unrelated state remains unchanged, and recovery or zero-change behavior works. The accountable owner records acceptance or rejection.

**Status:** Planned.

**Acceptance criteria:** Given current enterprise inventory, when the contract
is reviewed, then it names the owner, immutable input, accepted target/executor,
coverage statement, policy or threshold, output, evidence, exception process,
and safe stop; it rejects unavailable products, sensitive inputs, and new-
infrastructure actions.

**Implementation steps:** Write `midhhealth/platform-engineering/kubernetes-platform-gitops/docs/runbooks/uc-k8s-010.md`; reconfirm inventory and dependency evidence; run source and read-only modes; obtain separate approval for one canary if mutation is required; collect the schema-valid result, independent post-check, recovery proof, and owner decision.

**Completed work:** The purpose, platform fit, enterprise outcome, operational
flow, controls, and future delivery contract are documented on this page. No
implementation commit or runtime result is claimed.

**Validation and rollback:** Review the design against the canonical portfolio,
inventory, product state, and no-new-infrastructure rule. Revert the
documentation revision if an incorrect dependency or boundary is found.

**Required attachments:** Future `ART-K8S-010-001A` contract and fixture review.

### STORY-K8S-010-002: Build the source and evidence gate

**Description:** The implementation owner needs a fail-closed source workflow
that evaluates Workload Right-Sizing, produces normalized evidence, and controls only its
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

**Required attachments:** Future `ART-K8S-010-002A` source validation and
`ART-K8S-010-002B` downstream-block proof.

### STORY-K8S-010-003: Verify the bounded outcome and recovery

**Description:** Platform and enterprise reviewers need evidence that the
future workflow satisfies **CPU and memory requests are adjusted from observed utilization** on its named scope without hidden
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

**Required attachments:** Future `ART-K8S-010-003A` bounded result,
`ART-K8S-010-003B` recovery/non-mutation proof, and an optional sanitized
`ATT-K8S-010-003A` only when a real capture adds review value.

## Evidence and screenshot register

| ID | Planned evidence | Source | Current status |
| --- | --- | --- | --- |
| `ART-K8S-010-001A` | Reviewed contract, inventory, dependency, and fixture design | Architecture and implementation repository review | Pending future implementation |
| `ART-K8S-010-002A` | Positive and negative source-gate results | Existing GitLab and accepted runner | Pending future execution |
| `ART-K8S-010-002B` | Failed-decision proof showing the declared downstream path blocked | Existing delivery pipeline | Pending future execution |
| `ART-K8S-010-003A` | Bounded observed result compared with **CPU and memory requests are adjusted from observed utilization** | Approved existing execution path | Pending future execution |
| `ART-K8S-010-003B` | Recovery, restore, idempotence, reconciliation, or zero-change proof | Approved existing execution path | Pending future execution |

## Expected versus current result

| Measure | Expected future result | Current result |
| --- | --- | --- |
| Canonical coverage | CPU and memory requests are adjusted from observed utilization | Detailed behavior and decision semantics documented |
| Platform fit | Controlled result supports cluster policy, workload health, release, rollback, and service-resilience decisions | Owning-platform relationships documented |
| Enterprise fit | provide a controlled runtime for provider, payer, data, and platform workloads | Enterprise value, ownership, and evidence contract documented |
| Infrastructure | Existing inventoried targets and accepted execution paths only | No new infrastructure authorized |
| Implementation | Reviewed source contract, schema, fixtures, and fail-closed gate | Not scheduled |
| Runtime or bounded acceptance | Observed result plus recovery/non-mutation evidence and owner review | Not run |

## Acceptance decision

**Planned.** The architecture baseline is documented; implementation and runtime acceptance remain separate governed work. Code complete will require reviewed source and
passing positive and negative validation in `midhhealth/platform-engineering/kubernetes-platform-gitops`. Runtime verified requires
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

## Enhancement: Size from repeated workload evidence

[Track 4](../../platform-engineering-interview-learning-labs.md#supported-reliability-operations-track)
adds a recommendation based on repeated CPU/memory observations, throttling,
OOM events, queue time and completion latency. It reports percentiles and sample
coverage, preserves startup headroom, and never converts a short quiet window
directly into lower production limits.

### Questions an interviewer can press on

- **“Which percentile and safety margin fit an online service versus a batch job?”**
- **“How do you account for cold start, bursts and memory that cannot be reclaimed?”**
- **“What evidence would make you reject an apparently cheaper setting?”**

### Enhancement build and deployment binding

Extend the policy evaluator and schema with workload class, observation window,
coverage, percentiles, safety margin and rejection reasons. CI replays steady,
bursty, OOM, throttled and sparse fixtures. A reviewed recommendation may be
canaried through the existing cluster delivery path; rollback restores the
previous manifest and verifies latency, errors, restarts and pending pods.
