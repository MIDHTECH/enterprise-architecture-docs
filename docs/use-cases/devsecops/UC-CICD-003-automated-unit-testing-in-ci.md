# UC-CICD-003: Automated Unit Testing in CI

Last reviewed: 2026-08-13

## Use-case record

| Field | Value |
| --- | --- |
| Canonical portfolio use case | Automated Unit Testing in CI |
| Primary platform | Enterprise DevSecOps Delivery Platform |
| Supporting use cases | [UC-GOV-002](../governance/UC-GOV-002-secrets-management-automation.md), [UC-INFRA-001](../infrastructure/UC-INFRA-001-terraform-drift-detection.md), [UC-OBS-008](../observability/UC-OBS-008-deployment-health-scoring.md), [UC-RSO-009](../resilience/UC-RSO-009-service-ownership.md) |
| Enterprise outcome | Detect code-level regressions before an artifact can enter the enterprise delivery path |
| Primary actors | Application developer, code reviewer, delivery engineer, platform owner |
| Primary GitLab repository | `midhhealth/platform-delivery/devsecops-cicd-orchestrator` |
| Related capabilities | Automated build, code quality, dependency scanning, artifact management, release promotion |
| Existing execution boundary | GitLab and an accepted tagged runner; no new test service or runner is authorized |
| Current state | **Planned — detailed design only; no implementation or test execution is claimed** |
| Owner | Enterprise DevSecOps Delivery Platform team with participating application owners |

## Purpose

Unit tests give fast feedback on the smallest testable behavior of an
application. When they run only on a developer workstation, the enterprise
cannot prove that the reviewed revision passed, cannot consistently block a
broken package, and cannot compare results across teams.

The unit-test decision runs inside GitLab CI, ahead of package,
image, or deployment work. The platform provides a common contract for when
tests run, what constitutes success, what evidence is retained, and how failure
blocks the delivery graph. Application teams continue to own their test code
and framework-specific assertions.

## Expected outcome

Every eligible merge-request and protected-branch revision runs its complete
declared unit-test suite on an existing accepted runner. A valid passing result
allows only the next source gate; a failed, incomplete, missing, or timed-out
result blocks package, image, artifact-publication, and deployment paths for
that same commit SHA.

## Platform and enterprise fit

| Relationship | Explanation |
| --- | --- |
| Within the DevSecOps platform | Unit testing is the first behavior gate after source/build preparation. Its result controls whether quality, security, artifact, and release stages are eligible to run. |
| Provider and payer systems | Regressions in calculation, validation, authorization, mapping, and workflow logic are detected before they can become deployable artifacts. |
| Shared digital platform | One evidence contract permits consistent review even when applications use different test frameworks. |
| Risk and compliance | The pipeline records that the exact reviewed SHA passed the required suite; exclusions and quarantined tests remain visible. |
| Operational resilience | Fast deterministic tests reduce preventable release failures and provide a safe regression suite for patches and rollback candidates. |

Unit tests do not prove a service works in an environment. Integration,
contract, security, performance, and runtime health validation remain separate
controls.

## Trigger and actors

| Item | Definition |
| --- | --- |
| Trigger | Merge request, protected-branch commit, or approved release tag for an onboarded repository |
| Application developer | Maintains test code, fixtures, and framework configuration |
| Code reviewer | Reviews changed behavior, assertions, skips, and exclusions |
| Delivery engineer | Maintains the shared test-result and pipeline-ordering contract |
| Platform owner | Approves runner class, timeouts, evidence, and exception policy |
| Risk reviewer | Reviews protected-data handling and material exclusions when required |

## Scope and exclusions

In scope:

- discovery and execution of repository-owned unit tests;
- test execution for merge requests and protected branches;
- framework-neutral pass/fail, duration, count, skip, and failure evidence;
- optional coverage collection when the application already defines a coverage
  policy;
- negative-path proof that a failed test blocks package and deployment stages;
- visibility of skipped, quarantined, or excluded tests; and
- reuse of existing accepted GitLab runners.

Out of scope:

- writing application business logic or inventing tests on behalf of product
  owners;
- provisioning a runner, test-management product, SonarQube service, database,
  cluster, or test environment;
- integration, end-to-end, load, chaos, penetration, and production tests;
- using real patient, member, claim, or clinical data; and
- deployment or runtime acceptance.

## Actors and responsibilities

| Actor | Responsibility |
| --- | --- |
| Application developer | Maintains unit tests and fixes failures in the same reviewable repository |
| Code reviewer | Confirms assertions cover the changed behavior and that exclusions are justified |
| Delivery engineer | Maintains the reusable CI contract and job ordering |
| Platform owner | Approves runner class, evidence shape, timeout, and exception policy |
| Security or compliance reviewer | Reviews data handling and high-risk exclusions when applicable |

## Preconditions

- The application repository has an identifiable test command owned by the
  application team.
- Test dependencies are declared and restorable without copying a developer's
  local environment.
- Tests use synthetic, generated, or properly de-identified fixtures committed
  under the repository's data-handling rules.
- The selected image or toolchain and runner tags are declared in source.
- Test execution does not require production credentials or access to runtime
  services; a test needing those dependencies is not a unit test for this gate.
- Package, image, and deployment jobs declare a dependency on the unit-test
  result rather than running independently.

## Detailed functional flow

1. A merge request or protected-branch change starts a GitLab pipeline for an
   immutable commit SHA.
2. The pipeline identifies the repository's declared test command, toolchain,
   and dependency lock state. Missing or ambiguous configuration fails the gate.
3. An existing accepted runner starts an isolated job with no deployment
   credentials and restores only declared test dependencies.
4. The test framework executes the complete required unit-test set. Parallel
   shards are permitted only when their results are recombined and missing
   shards fail the job.
5. The job exports a normalized result containing total, passed, failed,
   skipped, errored, duration, and—when applicable—coverage values.
6. The pipeline evaluates repository policy. Any failed/errored test, missing
   result, timeout, unexpected test-count drop, or unapproved exclusion fails
   the gate.
7. On failure, package, image, publication, and deployment jobs remain blocked.
   The merge request exposes the failed test names and a sanitized diagnostic.
8. On success, the evidence is associated with the source SHA and made
   available to later DevSecOps controls. Success authorizes the next source
   gate; it does not authorize deployment.

```mermaid
flowchart LR
    Change["Merge request revision"] --> Contract["Resolve test contract"]
    Contract --> Test["Run unit tests on existing runner"]
    Test --> Result{"Required suite passed?"}
    Result -->|No| Block["Block build publication and deployment"]
    Result -->|Yes| Report["Publish normalized test evidence"]
    Report --> Next["Quality, security, and artifact gates"]
```

## Test contract

Each onboarded repository should declare the following without forcing every
language to use the same framework:

| Contract item | Required behavior |
| --- | --- |
| Test command | One noninteractive command with meaningful exit codes |
| Test roots | Explicit directories or package selectors so accidental discovery changes are visible |
| Toolchain | Language/runtime and test-framework versions are declared |
| Fixtures | Synthetic or approved de-identified data only |
| Timeout | Bounded value that fails rather than leaving a runner occupied indefinitely |
| Result format | Machine-readable output such as JUnit XML plus a concise human-readable summary |
| Coverage policy | Repository-owned threshold or explicitly `not applicable`; the platform does not invent a universal number |
| Exclusions | Identifier, owner, rationale, expiry, and issue reference for every quarantine or skip policy |

## Evidence contract

The future pipeline result must let a reviewer answer who ran what, against
which source, and why the next stage was allowed or blocked.

Required evidence includes:

- GitLab project, commit SHA, pipeline ID, job ID, and runner identity;
- toolchain and test-framework versions;
- dependency-lock digest when available;
- start/end time and duration;
- test totals: collected, passed, failed, errored, and skipped;
- failed-test identifiers and sanitized failure messages;
- coverage values and threshold decision when coverage is in scope;
- active quarantine/exclusion records; and
- final gate decision with the downstream jobs that were allowed or blocked.

Test logs and reports must not contain secrets or protected healthcare data.
Screenshots may support a review but never replace the machine-readable result.

## Architecture context

Automated Unit Testing in CI is evaluated inside the existing enterprise lab and the owning
platform's current source-control and execution boundaries. The architectural
unit is the governed outcome—**Detect code-level regressions before an artifact can enter the enterprise delivery path**—rather than a new product or
environment.

| Context element | Architecture statement |
| --- | --- |
| Business and operational setting | Enterprise consumers: Enterprise DevSecOps Delivery Platform. The result must be explainable, repeatable, and owned. |
| Current state | **Planned — detailed design only; no implementation or test execution is claimed** |
| Desired state | A reviewed contract drives a bounded result, machine-readable evidence, and a safe stop or recovery decision. |
| Existing target boundary | Approved existing delivery target |
| Infrastructure constraint | Reuse the existing lab; no new infrastructure is authorized |
| Accountable platform owner | Enterprise DevSecOps Delivery Platform team with participating application owners; the consuming service, data, security, or workflow owner remains accountable for accepting business impact. |

The page owns the contract, control logic, evidence, and recovery behavior for
Automated Unit Testing in CI. It does not absorb the responsibilities of the dependency use cases
listed below.

## Architecture diagram

```mermaid
flowchart LR
    subgraph Source["Existing source and intent boundary"]
        A["Reviewed application and pipeline source"]
    end
    subgraph Planned["Planned Automated Unit Testing in CI control"]
        B["GitLab source gate"]
        C["Contract, policy, and negative fixtures"]
        D{"Evidence satisfies the use-case gate?"}
    end
    subgraph Runtime["Existing approved execution boundary"]
        E["Jenkins shared-library workflow"]
        F["Approved existing delivery target"]
    end
    subgraph Assurance["Evidence and recovery boundary"]
        G["Build, artifact, promotion, and recovery evidence"]
        H["Owner review, safe stop, or recovery"]
    end

    A --> B --> C --> D
    D -->|No| G --> H
    D -->|Yes; read-only| G
    D -->|Yes; separately approved action| E --> F --> G
    H -. recover accepted revision .-> A
```

The diagram distinguishes existing boundaries from the planned use-case
control. The arrow into the execution boundary is conditional: documentation,
source validation, or a passing fixture never authorizes a runtime change.

### Operating sequence

1. The request binds Automated Unit Testing in CI to immutable source, an inventory-resolved target,
   an accountable owner, and the expected enterprise result.
2. GitLab validates the contract, exact scope, dependency evidence, and positive
   and negative fixtures without target-changing credentials.
3. The use-case control produces a machine-readable result with provenance,
   decision reasons, timing, and the next permitted action.
4. Read-only evidence can complete on the accepted runner. Any mutation waits
   for the existing change, approval, credential, and canary controls.
5. Independent post-checks compare expected and observed state. Failure stops
   expansion, preserves diagnostics, and invokes the page's recovery boundary.

## Dependencies and handoffs

Automated Unit Testing in CI remains accountable to its primary platform. The dependencies below
provide explicit contracts or assurance evidence; they do not become alternate owners.

| Relationship | Use case | Required handoff | Failure propagation |
| --- | --- | --- | --- |
| Required upstream contract | [UC-GOV-002: Secrets Management Automation](../governance/UC-GOV-002-secrets-management-automation.md) | approved secret reference, redaction rule, and rotation owner | Missing, stale, or failed evidence blocks promotion or runtime action. |
| Required upstream contract | [UC-INFRA-001: Terraform Drift Detection](../infrastructure/UC-INFRA-001-terraform-drift-detection.md) | desired/observed infrastructure identity and drift result | Missing, stale, or failed evidence blocks promotion or runtime action. |
| Coordinated assurance handoff | [UC-OBS-008: Deployment Health Scoring](../observability/UC-OBS-008-deployment-health-scoring.md) | deployment-health score and promotion/rollback signal | Missing, stale, or failed evidence blocks promotion or runtime action. |
| Coordinated assurance handoff | [UC-RSO-009: Service Ownership](../resilience/UC-RSO-009-service-ownership.md) | accountable service owner and operational tier | Missing, stale, or failed evidence blocks promotion or runtime action. |

Before Automated Unit Testing in CI is implemented, every handoff must resolve to an immutable
revision and machine-readable artifact. A URL, screenshot, or verbal approval
alone is not sufficient dependency evidence.

## Quality attributes

For Automated Unit Testing in CI, quality is measured against the bounded enterprise outcome—not
document length or a green job. Unapproved business thresholds remain explicit
decisions and must not be invented.

| Attribute | Required measure or invariant | Decision state |
| --- | --- | --- |
| Functional correctness | Every required input is validated; **Detect code-level regressions before an artifact can enter the enterprise delivery path** is evaluated against positive, negative, missing-input, and unauthorized-scope cases. | Fixed design requirement |
| Performance and scale | Establish a baseline for pipeline duration, queue delay, reproducibility, and false-pass rate on existing capacity; the owner must approve warning and blocking thresholds before runtime promotion. | Thresholds `TBD` before implementation |
| Reliability | Missing prerequisites, stale dependencies, malformed evidence, and partial results fail closed without widening scope. | Fixed design requirement |
| Recovery | Record the maximum acceptable interruption and recovery time before runtime use; source-only validation must remain zero-change. | Owner decision required before runtime exercise |
| Observability | Emit use-case ID, revision, target, executor, start/end time, duration, decision, reason code, and recovery reference. | Required in the result schema |
| Evidence retention | Assign classification, retention period, and deletion owner before storing runtime evidence. | Security/compliance decision required |

Load, latency, availability, retention, RTO, and RPO values for Automated Unit Testing in CI become
requirements only after the named service or business owner approves them. Until
then, the implementation gate records them as unresolved instead of quietly
choosing defaults.

## Security and privacy architecture

The Automated Unit Testing in CI design separates source validation, privileged execution, target
access, and evidence review. Those boundaries remain in force even when one
engineer can access more than one system.

| Trust boundary | Allowed flow | Required control |
| --- | --- | --- |
| Contributor → GitLab | Reviewed source, contract, and synthetic/sanitized fixtures | Protected branch rules, peer review, secret scanning, and immutable commit identity |
| GitLab runner → result artifact | Read-only evaluation inputs and machine-readable output | No target-changing credential; pinned tool versions; artifact checksum and expiry |
| Approval plane → executor | Approved revision, target allowlist, mode, canary, and change reference | Separate authorization through the existing Jenkins/AWX or platform control path |
| Executor → existing target | Minimum commands or API operations required for Automated Unit Testing in CI | Least-privilege identity, explicit target limit, timeout, and stop condition |
| Target → evidence store | Sanitized metadata, measurements, decision, and recovery result | Exclude credentials, tokens, private keys, kubeconfigs, packet payloads, PHI, PII, and unrelated records |

For Automated Unit Testing in CI, the primary threat is **untrusted source or dependency content reaching a privileged runner**. The mandatory response is
protected refs, isolated build context, pinned dependencies, least-privilege credentials, and artifact provenance. Authentication and authorization mappings must name
the existing identity source, principal or service account, permitted actions,
credential owner, rotation path, and emergency revocation procedure before a
runtime story can move beyond `Planned`.

## Architecture decisions and trade-offs

| Decision | Selected architecture | Alternative deferred or rejected | Rationale and status |
| --- | --- | --- | --- |
| First implementation slice | Contract, schema, fixtures, and read-only evidence on the existing GitLab runner | Product installation or broad runtime rollout | Proves behavior without expanding infrastructure; **approved design direction** |
| Runtime execution | Use only Jenkins shared-library workflow when current inventory and change approval confirm it is available | Direct operator changes or credentials in CI | Preserves separation of duties; **conditional on implementation review** |
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

If any selected approach changes, record the rationale beside UC-CICD-003 in
the implementation repository before code review. A documentation edit alone
does not approve the new architecture.

## Implementation design

The first Automated Unit Testing in CI implementation is deliberately source-only. Its planned files live in the existing repository; none provisions infrastructure.

| Planned source responsibility | Exact planned location |
| --- | --- |
| Use-case contract and target allowlist | `midhhealth/platform-delivery/devsecops-cicd-orchestrator/contracts/uc-cicd-003.yaml` |
| Primary implementation | `midhhealth/platform-delivery/devsecops-cicd-orchestrator/jobs/automated-unit-testing-in-ci.groovy`; entry point: the `automated-unit-testing-in-ci` Jenkins job and its shared-library step |
| Machine-readable result schema | `midhhealth/platform-delivery/devsecops-cicd-orchestrator/schemas/uc-cicd-003-result.schema.json` |
| Positive, negative, malformed, and recovery fixtures | `midhhealth/platform-delivery/devsecops-cicd-orchestrator/tests/fixtures/uc-cicd-003/` |
| GitLab source gate | `midhhealth/platform-delivery/devsecops-cicd-orchestrator/.gitlab/ci/uc-cicd-003.yml` |
| Operator diagnosis and recovery | `midhhealth/platform-delivery/devsecops-cicd-orchestrator/docs/runbooks/uc-cicd-003.md` |

### Delivery stages

1. **Contract:** add the contract, schema, owners, dependency revisions, target
   allowlist, modes, reason codes, and open-decision values.
2. **Source validation:** lint exact paths, validate schema compatibility, scan
   for sensitive content, and run every fixture on the existing runner.
3. **Read-only proof:** execute the `automated-unit-testing-in-ci` Jenkins job and its shared-library step, publish a checksummed result, and
   prove that blocked cases cannot reach a mutating path.
4. **Bounded execution:** only after separate approval, pass the immutable
   revision, target, mode, canary, and change ID to Jenkins shared-library workflow.
5. **Independent verification:** measure the expected result, confirm unrelated
   state is unchanged, run recovery or zero-change proof, and obtain owner
   review.

The implementation merge request must link this page, the dependency artifacts,
the decision values above, and the eventual pipeline/job/run identifiers. Code
completion alone cannot promote the page to runtime verified.

## Code and configuration map

The following entries describe future implementation responsibilities only.
No path is represented as implemented until a reviewed commit is recorded.

| Planned location | Responsibility |
| --- | --- |
| `.gitlab-ci.yml` or an included CI template | Run unit testing before package, image, publication, and deployment jobs |
| Application test configuration | Declare test roots, framework behavior, timeout, coverage, and result output |
| Application dependency lock file | Constrain the test dependency state |
| Planned normalized result schema | Capture provenance, counts, duration, failures, skips, coverage, and gate decision |
| Planned positive and negative fixtures | Prove pass, fail, zero-test, timeout, shard-loss, redaction, and downstream blocking behavior |
| Planned operating notes | Explain diagnosis, quarantine review, rerun, evidence review, and safe stop |

## Decision rules

- A nonzero framework exit code fails the gate.
- Zero tests collected fails unless the repository contract explicitly proves
  that no unit-test scope exists and the platform owner approves the exception.
- Skipped tests are reported; an unexpected increase or expired quarantine
  fails review.
- Coverage is evaluated only against a reviewed repository policy. A lower
  threshold requires a reviewed source change, not a pipeline variable override.
- Retries do not silently turn a flaky test green. Both the initial result and
  retry are retained, and persistent flakiness creates follow-up work.
- Package, container, artifact publication, and deployment stages require this
  job's successful result for the same commit SHA.
- Fork or untrusted-branch pipelines do not receive protected variables.

## Failure and troubleshooting model

| Symptom | First checks | Required outcome |
| --- | --- | --- |
| No tests collected | Test roots, naming rules, checkout contents, framework configuration | Fix discovery or approve a documented no-test exception; never report a false pass |
| Dependency restore fails | Lock file, approved source reachability, pinned toolchain | Correct reviewed source or retry an established transient failure |
| Test passes locally but fails in CI | Uncommitted files, local cache, timezone/locale, concurrency, hidden service dependencies | Remove environmental dependence or reclassify the test |
| Suite times out | Hanging test, accidental integration call, resource usage, timeout value | Isolate the cause; do not simply remove the bound |
| Test count drops | Renames, selection filters, shard loss, quarantine changes | Explain the delta and restore omitted coverage before accepting |
| Sensitive data appears in logs | Fixture source and assertion output | Stop publication, remove the data, rotate exposed credentials if any, and open an incident |
| Runner unavailable | Runner status and declared tags | Wait or use another already accepted compatible runner; do not create infrastructure here |

Because unit tests do not mutate a runtime target, recovery consists of
discarding results from the failed revision, correcting the reviewed source,
and rerunning the complete required suite. Bypassing the gate is not recovery.

## Jira breakdown

### STORY-CICD-003-001: Define repository unit-test contracts

**Outcome:** Participating repositories declare a repeatable test command,
toolchain, fixtures, timeout, result format, coverage policy, and exclusions.

**Description:** Application and delivery owners need a framework-neutral test
contract that preserves application ownership while creating one enterprise
gate decision.

**Status:** Planned.

**Acceptance criteria:** Given an onboarding request, when the contract is
reviewed, then it resolves to an existing repository and runner class, contains
no runtime mutation or protected data, and a positive and intentionally failing
fixture produce distinct, machine-readable decisions.

**Implementation steps:** Confirm the existing repository and runner class;
record the command, roots, toolchain, dependency state, fixtures, timeout,
result format, coverage policy, and exclusions; review positive and intentional
failure fixtures with the application owner.

**Completed work:** The required contract and boundaries are documented here.
No pipeline source or test result is claimed.

**Validation and rollback:** Future validation must exercise valid, failing,
zero-test, timeout, and sensitive-output fixtures. Revert the source contract
if it does not preserve the repository's established test behavior.

**Required attachments:** Future `ART-CICD-003-001A` contract and fixture report.

### STORY-CICD-003-002: Enforce test-before-package ordering

**Outcome:** Package, image, artifact publication, and deployment work cannot
run for a commit whose required unit tests failed or produced no valid result.

**Description:** The delivery engineer needs an explicit dependency graph so a
broken revision cannot bypass testing by reaching a later independent job.

**Status:** Planned.

**Acceptance criteria:** Given a passing suite, the next source gate becomes
eligible; given a failed, timed-out, missing, or incomplete suite, every
downstream packaging and deployment job remains blocked for that SHA.

**Implementation steps:** Add the unit-test job on an accepted runner; declare
all downstream `needs` or stage dependencies; fail closed on missing or invalid
results; exercise passing, failing, timed-out, and canceled paths.

**Completed work:** The intended gate ordering and decision rules are designed.
Implementation is deferred.

**Validation and rollback:** Use an intentionally failing assertion to prove
every later packaging and deployment path remains blocked, then restore the
fixture and prove only the next source gate is eligible. Revert the pipeline
change if it incorrectly blocks unchanged repositories.

**Required attachments:** Future `ART-CICD-003-002A` pipeline dependency graph
and `ART-CICD-003-002B` negative-path result.

### STORY-CICD-003-003: Publish reviewable unit-test evidence

**Outcome:** Developers and reviewers can diagnose a failure and auditors can
reconstruct the gate decision without depending on a screenshot.

**Description:** Developers need actionable diagnostics while platform and
risk reviewers need a durable, sanitized decision tied to the exact revision.

**Status:** Planned.

**Acceptance criteria:** The retained result includes provenance, counts,
duration, sanitized failures, coverage decision when applicable, exclusions,
and the allow/block decision; secret and protected-data fixtures are rejected.

**Implementation steps:** Generate the normalized result; publish framework
reports using existing GitLab artifact handling; enforce redaction checks;
record exclusions and coverage decisions; link evidence to the source SHA.

**Completed work:** Required evidence fields are documented. No execution
evidence is claimed.

**Validation and rollback:** Verify counts against raw framework output, test a
sensitive fixture rejection, and confirm reports resolve to the exact pipeline
and SHA. Discard invalid reports and correct source before rerunning.

**Required attachments:** Future `ART-CICD-003-003A` normalized result and
`ART-CICD-003-003B` redaction decision.

## Evidence and screenshot register

| ID | Planned evidence | Source | Current status |
| --- | --- | --- | --- |
| `ART-CICD-003-001A` | Test contract plus positive and negative fixture decisions | GitLab CI in the implementation repository | Pending future implementation |
| `ART-CICD-003-002A` | Pipeline graph showing test-before-package ordering | GitLab pipeline | Pending future execution |
| `ART-CICD-003-002B` | Deliberate test failure blocking all downstream jobs | Existing accepted GitLab runner | Pending future execution |
| `ART-CICD-003-003A` | Normalized test result tied to the source SHA | Existing accepted GitLab runner | Pending future execution |
| `ART-CICD-003-003B` | Sensitive-output fixture rejection | GitLab CI | Pending future execution |

## Expected versus current result

| Measure | Expected future result | Current result |
| --- | --- | --- |
| Platform fit | Unit-test result controls later quality, security, packaging, and release eligibility | Detailed relationship documented |
| Enterprise fit | Code-level regressions are detected and auditable before deployable output exists | Outcome and control model documented |
| Infrastructure | Existing GitLab and accepted runners only | Boundary documented; no new infrastructure authorized |
| Implementation | Reviewed test contract and pipeline dependency graph | Not scheduled |
| Execution | Positive and negative evidence, including downstream blocking | Not run |

## Acceptance decision

**Planned.** This document explains the intended behavior and separates it from
future implementation. Code complete will require reviewed pipeline source and
passing positive and negative CI fixtures in the named repository. Acceptance
will additionally require evidence that a deliberately failing test blocks all
package and deployment paths, a valid suite enables only the next source gate,
the runner and data boundaries are respected, and the result is linked here.

## Related use cases

- `UC-CICD-002` provides the controlled source/build context.
- `UC-CICD-004` evaluates code quality after the unit-test gate.
- `UC-CICD-005` publishes only outputs associated with passing required gates.
- `UC-CICD-010` composes unit, quality, secret, dependency, and image controls
  into the secure delivery workflow.
- `UC-CICD-015` uses later runtime evidence; it is not replaced by unit tests.
