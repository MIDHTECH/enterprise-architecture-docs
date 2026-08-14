# UC-GOV-010: Certificate Expiry Monitoring

Last reviewed: 2026-08-13

## Use-case record

| Field | Value |
| --- | --- |
| Canonical portfolio use case | Certificate Expiry Monitoring |
| Primary platform | Enterprise Cloud Governance and Operations Automation |
| Supporting use cases | [UC-NET-005](../network/UC-NET-005-authoritative-and-recursive-dns.md), [UC-NET-024](../network/UC-NET-024-certificate-and-tls-routing.md), [UC-CICD-010](../devsecops/UC-CICD-010-secure-ci-cd-pipeline-implementation.md), [UC-RSO-009](../resilience/UC-RSO-009-service-ownership.md) |
| Enterprise alignment | Risk and compliance, shared digital platform, operational resilience |
| Enterprise outcome | apply traceable controls to platform work that supports provider and payer operations |
| Primary implementation repository | `midhhealth/security-governance/cloud-governance-ops-automation` |
| Jira epic | `EPIC-GOV-010` — Implement Certificate Expiry Monitoring |
| Change record | Required before any mutating or runtime action; not required for fixture-only CI |
| Target | existing GitLab runners, AWX inventories, Vault boundary, repository scanners, and evidence artifacts |
| Current state | **Planned — detailed design only; implementation and runtime evidence are not claimed** |
| Infrastructure boundary | Reuse the existing lab; do not create a new governance VM, scanner service, cloud account, identity platform, or automatic high-risk remediation |
| Owner | Enterprise Cloud Governance and Operations Automation team |

## Purpose

Certificate Expiry Monitoring makes **Alerts before certificate expiration** enforceable and reviewable without turning policy evaluation into unrestricted remediation.

For Certificate Expiry Monitoring, the design fixes the contract, dependency handoffs, target boundary, evidence, decision owners, and recovery path before implementation. Those choices keep the eventual build grounded in the lab that actually exists.

## Expected outcome

The first delivery slice proves **Alerts before certificate expiration** on the documented
existing target boundary. It uses a versioned contract plus positive, negative,
malformed-input, unauthorized-scope, and recovery fixtures, then publishes an
attributable machine-readable result.

Acceptance for Certificate Expiry Monitoring requires rejected cases to stop safely and unrelated
state to remain unchanged. Live integration or mutation still requires the
separate approval, identity, canary, and rollback controls named below; this
design does not authorize a product installation, new capacity, or an unlisted
endpoint.

## Platform and enterprise fit

| Relationship | Architecture fit |
| --- | --- |
| Owning responsibility | **Enterprise Cloud Governance and Operations Automation** owns the contract, control behavior, evidence schema, and recovery boundary for Certificate Expiry Monitoring. |
| Enterprise use | apply traceable controls to platform work that supports provider and payer operations. |
| Required inputs | control revision, target identity, evidence requirements, and owned exception policy. |
| Produced handoff | explainable compliance or remediation decision with expiry and recovery state. |
| Supporting platforms | The dependency table below names the exact use cases and artifacts; passing this page never implies that those controls passed. |
| Existing-lab boundary | Reuse the existing lab; do not create a new governance VM, scanner service, cloud account, identity platform, or automatic high-risk remediation. |

## Trigger and actors

| Item | Definition |
| --- | --- |
| Trigger | Merge request, protected scheduled evaluation, approved operator request, source/data event, or monitored condition defined by the implementation contract |
| Primary actors | platform owner, control owner, operations engineer, security reviewer, and change approver |
| Request owner | States the desired outcome, scope, urgency, and enterprise consumer |
| Platform owner | Owns the policy, accepted execution path, target boundary, and safe-stop behavior |
| Reviewer or approver | Confirms risk, prerequisites, evidence requirements, and any exception before a mutating step |
| Evidence consumer | Uses the result for approval, remediation, audit, exception, risk, and service-management decisions |

## Preconditions

- The named repository, source revision, and target resolve to current
  enterprise inventory; synthetic fixtures are permitted for source-only tests.
- The implementation contract defines the scope required to demonstrate:
  **Alerts before certificate expiration**
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

- the versioned contract for Certificate Expiry Monitoring;
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

For design review, walk through Certificate Expiry Monitoring by trying to separate what is
observed, what policy decides, who authorizes action and what evidence survives. The result
MidhHealth needs is to apply traceable controls to platform work that supports provider and
payer operations. Enterprise Cloud Governance and Operations Automation team owns the platform
decision, while the consuming service or business owner still accepts the effect on its
workflow.

Begin with the observation, then follow the decision and action back to a new observation; the
loop is incomplete until the owner sees the effect. In this page, **UC-NET-005: Authoritative
and Recursive DNS** contributes layered path decision with before/after reachability and restore
proof; **UC-NET-024: Certificate and TLS Routing** contributes layered path decision with
before/after reachability and restore proof. The first buildable boundary is existing GitLab
runners, AWX inventories, Vault boundary, repository scanners, and evidence artifacts. The
design stops at this rule: Reuse the existing lab; do not create a new governance VM, scanner
service, cloud account, identity platform, or automatic high-risk remediation.

The walkthrough becomes useful when the happy path breaks. If contract or policy is
missing/invalid, the expected response is to Correct through reviewed source and rerun fixtures.
The leading design threat is a governance workflow receiving broader privileges than the control
scope requires; therefore a green source job, screenshot or reachable endpoint is supporting
evidence, not acceptance by itself.

## Architecture context

Certificate Expiry Monitoring is evaluated inside the existing enterprise lab and the owning
platform's current source-control and execution boundaries. The architectural
unit is the governed outcome—**Alerts before certificate expiration**—rather than a new product or
environment.

| Context element | Architecture statement |
| --- | --- |
| Business and operational setting | Enterprise consumers: Risk and compliance, shared digital platform, operational resilience. The result must be explainable, repeatable, and owned. |
| Current state | **Planned — detailed design only; implementation and runtime evidence are not claimed** |
| Desired state | A reviewed contract drives a bounded result, machine-readable evidence, and a safe stop or recovery decision. |
| Existing target boundary | existing GitLab runners, AWX inventories, Vault boundary, repository scanners, and evidence artifacts |
| Infrastructure constraint | Reuse the existing lab; do not create a new governance VM, scanner service, cloud account, identity platform, or automatic high-risk remediation |
| Accountable platform owner | Enterprise Cloud Governance and Operations Automation team; the consuming service, data, security, or workflow owner remains accountable for accepting business impact. |

The page owns the contract, control logic, evidence, and recovery behavior for
Certificate Expiry Monitoring. It does not absorb the responsibilities of the dependency use cases
listed below.

## Architecture diagram

![UC-GOV-010 architecture showing demand, source contracts, planned control, existing target, evidence, and recovery](../../assets/use-cases/UC-GOV-010/UC-GOV-010-architecture.svg)

The center is the outcome the team cares about. The surrounding loop senses, compares, decides, verifies, and learns; it only closes when an accountable owner accepts the evidence.

## Dependencies and handoffs

Certificate Expiry Monitoring remains accountable to its primary platform. The dependencies below
provide explicit contracts or assurance evidence; they do not become alternate owners.

| Relationship | Use case | Required handoff | Failure propagation |
| --- | --- | --- | --- |
| Required upstream contract | [UC-NET-005: Authoritative and Recursive DNS](../network/UC-NET-005-authoritative-and-recursive-dns.md) | layered path decision with before/after reachability and restore proof | Missing, stale, or contradictory handoff stops the dependent decision and is recorded for the accountable owner. |
| Required upstream contract | [UC-NET-024: Certificate and TLS Routing](../network/UC-NET-024-certificate-and-tls-routing.md) | layered path decision with before/after reachability and restore proof | Missing, stale, or contradictory handoff stops the dependent decision and is recorded for the accountable owner. |
| Coordinated assurance handoff | [UC-CICD-010: Secure CI/CD Pipeline Implementation](../devsecops/UC-CICD-010-secure-ci-cd-pipeline-implementation.md) | immutable build or gate result with promotion and rollback eligibility | Missing, stale, or contradictory handoff stops the dependent decision and is recorded for the accountable owner. |
| Coordinated assurance handoff | [UC-RSO-009: Service Ownership](../resilience/UC-RSO-009-service-ownership.md) | readiness or exercise result tied to observed service recovery | Missing, stale, or contradictory handoff stops the dependent decision and is recorded for the accountable owner. |

Before Certificate Expiry Monitoring is implemented, every handoff must resolve to an immutable
revision and machine-readable artifact. A URL, screenshot, or verbal approval
alone is not sufficient dependency evidence.

## Quality attributes

For Certificate Expiry Monitoring, quality is measured against the bounded enterprise outcome—not
document length or a green job. Unapproved business thresholds remain explicit
decisions and must not be invented.

| Attribute | Required measure or invariant | Decision state |
| --- | --- | --- |
| Functional correctness | Every required input is validated; **Alerts before certificate expiration** is evaluated against positive, negative, missing-input, and unauthorized-scope cases. | Fixed design requirement |
| Performance and scale | Establish a baseline for control coverage, false-positive rate, evidence freshness, and exception age on existing capacity; the owner must approve warning and blocking thresholds before runtime promotion. | Thresholds `TBD` before implementation |
| Reliability | Missing prerequisites, stale dependencies, malformed evidence, and partial results fail closed without widening scope. | Fixed design requirement |
| Recovery | Record the maximum acceptable interruption and recovery time before runtime use; source-only validation must remain zero-change. | Owner decision required before runtime exercise |
| Observability | Emit use-case ID, revision, target, executor, start/end time, duration, decision, reason code, and recovery reference. | Required in the result schema |
| Evidence retention | Assign classification, retention period, and deletion owner before storing runtime evidence. | Security/compliance decision required |

Load, latency, availability, retention, RTO, and RPO values for Certificate Expiry Monitoring become
requirements only after the named service or business owner approves them. Until
then, the implementation gate records them as unresolved instead of quietly
choosing defaults.

## Security and privacy architecture

The Certificate Expiry Monitoring design separates source validation, privileged execution, target
access, and evidence review. Those boundaries remain in force even when one
engineer can access more than one system.

| Trust boundary | Allowed flow | Required control |
| --- | --- | --- |
| Contributor → GitLab | Reviewed source, contract, and synthetic/sanitized fixtures | Protected branch rules, peer review, secret scanning, and immutable commit identity |
| GitLab runner → result artifact | Read-only evaluation inputs and machine-readable output | No target-changing credential; pinned tool versions; artifact checksum and expiry |
| Approval plane → executor | Approved revision, target allowlist, mode, canary, and change reference | Separate authorization through the existing Jenkins/AWX or platform control path |
| Executor → existing target | Minimum commands or API operations required for Certificate Expiry Monitoring | Least-privilege identity, explicit target limit, timeout, and stop condition |
| Target → evidence store | Sanitized metadata, measurements, decision, and recovery result | Exclude credentials, tokens, private keys, kubeconfigs, packet payloads, PHI, PII, and unrelated records |

For Certificate Expiry Monitoring, the primary threat is **a governance workflow receiving broader privileges than the control scope requires**. The mandatory response is
separation of evaluation and remediation, expiring exceptions, target allowlists, protected credentials, and review evidence. Authentication and authorization mappings must name
the existing identity source, principal or service account, permitted actions,
credential owner, rotation path, and emergency revocation procedure before a
runtime story can move beyond `Planned`.

## Architecture decisions and trade-offs

| Decision | Selected architecture | Alternative deferred or rejected | Rationale and status |
| --- | --- | --- | --- |
| First implementation slice | Contract, schema, fixtures, and read-only evidence on the existing GitLab runner | Product installation or broad runtime rollout | Proves behavior without expanding infrastructure; **approved design direction** |
| Runtime execution | Use only Approved read-only or AWX control path when current inventory and change approval confirm it is available | Direct operator changes or credentials in CI | Preserves separation of duties; **conditional on implementation review** |
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

If any selected approach changes, record the rationale beside UC-GOV-010 in
the implementation repository before code review. A documentation edit alone
does not approve the new architecture.

## Implementation design

The first Certificate Expiry Monitoring implementation is deliberately source-only. Its planned files live in the existing repository; none provisions infrastructure.

| Planned source responsibility | Exact planned location |
| --- | --- |
| Use-case contract and target allowlist | `midhhealth/security-governance/cloud-governance-ops-automation/contracts/uc-gov-010.yaml` |
| Primary implementation | `midhhealth/security-governance/cloud-governance-ops-automation/playbooks/certificate-expiry-monitoring.yml`; entry point: the `certificate-expiry-monitoring` control evaluator and bounded remediation entry point |
| Machine-readable result schema | `midhhealth/security-governance/cloud-governance-ops-automation/schemas/uc-gov-010-result.schema.json` |
| Positive, negative, malformed, and recovery fixtures | `midhhealth/security-governance/cloud-governance-ops-automation/tests/fixtures/uc-gov-010/` |
| GitLab source gate | `midhhealth/security-governance/cloud-governance-ops-automation/.gitlab/ci/uc-gov-010.yml` |
| Operator diagnosis and recovery | `midhhealth/security-governance/cloud-governance-ops-automation/docs/runbooks/uc-gov-010.md` |

### Delivery stages

1. **Contract:** add the contract, schema, owners, dependency revisions, target
   allowlist, modes, reason codes, and open-decision values.
2. **Source validation:** lint exact paths, validate schema compatibility, scan
   for sensitive content, and run every fixture on the existing runner.
3. **Read-only proof:** execute the `certificate-expiry-monitoring` control evaluator and bounded remediation entry point, publish a checksummed result, and
   prove that blocked cases cannot reach a mutating path.
4. **Bounded execution:** only after separate approval, pass the immutable
   revision, target, mode, canary, and change ID to Approved read-only or AWX control path.
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
| `midhhealth/security-governance/cloud-governance-ops-automation/contracts/uc-gov-010.yaml` | Inputs, owner, dependency revisions, target allowlist, modes, thresholds, and stop conditions | Planned |
| `midhhealth/security-governance/cloud-governance-ops-automation/playbooks/certificate-expiry-monitoring.yml` | Primary implementation through the `certificate-expiry-monitoring` control evaluator and bounded remediation entry point | Planned |
| `midhhealth/security-governance/cloud-governance-ops-automation/schemas/uc-gov-010-result.schema.json` | Provenance, observations, decision, reason codes, safety, and recovery result | Planned |
| `midhhealth/security-governance/cloud-governance-ops-automation/tests/fixtures/uc-gov-010/` | Passing, blocking, malformed, unauthorized, stale-dependency, and recovery cases | Planned |
| `midhhealth/security-governance/cloud-governance-ops-automation/.gitlab/ci/uc-gov-010.yml` | Source validation on an accepted existing runner | Planned |
| `midhhealth/security-governance/cloud-governance-ops-automation/docs/runbooks/uc-gov-010.md` | Preconditions, execution, diagnosis, evidence review, safe stop, and recovery | Planned |

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

### STORY-GOV-010-001: Define the Certificate Expiry Monitoring contract

**Description:** Exercise one approved scope and publish evidence that the observed result matches the contract, unrelated state remains unchanged, and recovery or zero-change behavior works. The accountable owner records acceptance or rejection.

**Status:** Planned.

**Acceptance criteria:** Given current enterprise inventory, when the contract
is reviewed, then it names the owner, immutable input, accepted target/executor,
coverage statement, policy or threshold, output, evidence, exception process,
and safe stop; it rejects unavailable products, sensitive inputs, and new-
infrastructure actions.

**Implementation steps:** Write `midhhealth/security-governance/cloud-governance-ops-automation/docs/runbooks/uc-gov-010.md`; reconfirm inventory and dependency evidence; run source and read-only modes; obtain separate approval for one canary if mutation is required; collect the schema-valid result, independent post-check, recovery proof, and owner decision.

**Completed work:** The purpose, platform fit, enterprise outcome, operational
flow, controls, and future delivery contract are documented on this page. No
implementation commit or runtime result is claimed.

**Validation and rollback:** Review the design against the canonical portfolio,
inventory, product state, and no-new-infrastructure rule. Revert the
documentation revision if an incorrect dependency or boundary is found.

**Required attachments:** Future `ART-GOV-010-001A` contract and fixture review.

### STORY-GOV-010-002: Build the source and evidence gate

**Description:** The implementation owner needs a fail-closed source workflow
that evaluates Certificate Expiry Monitoring, produces normalized evidence, and controls only its
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

**Required attachments:** Future `ART-GOV-010-002A` source validation and
`ART-GOV-010-002B` downstream-block proof.

### STORY-GOV-010-003: Verify the bounded outcome and recovery

**Description:** Platform and enterprise reviewers need evidence that the
future workflow satisfies **Alerts before certificate expiration** on its named scope without hidden
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

**Required attachments:** Future `ART-GOV-010-003A` bounded result,
`ART-GOV-010-003B` recovery/non-mutation proof, and an optional sanitized
`ATT-GOV-010-003A` only when a real capture adds review value.

## Evidence and screenshot register

| ID | Planned evidence | Source | Current status |
| --- | --- | --- | --- |
| `ART-GOV-010-001A` | Reviewed contract, inventory, dependency, and fixture design | Architecture and implementation repository review | Pending future implementation |
| `ART-GOV-010-002A` | Positive and negative source-gate results | Existing GitLab and accepted runner | Pending future execution |
| `ART-GOV-010-002B` | Failed-decision proof showing the declared downstream path blocked | Existing delivery pipeline | Pending future execution |
| `ART-GOV-010-003A` | Bounded observed result compared with **Alerts before certificate expiration** | Approved existing execution path | Pending future execution |
| `ART-GOV-010-003B` | Recovery, restore, idempotence, reconciliation, or zero-change proof | Approved existing execution path | Pending future execution |

## Expected versus current result

| Measure | Expected future result | Current result |
| --- | --- | --- |
| Canonical coverage | Alerts before certificate expiration | Detailed behavior and decision semantics documented |
| Platform fit | Controlled result supports approval, remediation, audit, exception, risk, and service-management decisions | Owning-platform relationships documented |
| Enterprise fit | apply traceable controls to platform work that supports provider and payer operations | Enterprise value, ownership, and evidence contract documented |
| Infrastructure | Existing inventoried targets and accepted execution paths only | No new infrastructure authorized |
| Implementation | Reviewed source contract, schema, fixtures, and fail-closed gate | Not scheduled |
| Runtime or bounded acceptance | Observed result plus recovery/non-mutation evidence and owner review | Not run |

## Acceptance decision

**Planned.** The architecture baseline is documented; implementation and runtime acceptance remain separate governed work. Code complete will require reviewed source and
passing positive and negative validation in `midhhealth/security-governance/cloud-governance-ops-automation`. Runtime verified requires
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
