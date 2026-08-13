# Platform Engineering Interview Learning Labs

Last verified: 2026-08-13

## Purpose and boundary

These labs close practical interview gaps in the MidhTech Integrated Care
platform portfolio. They turn existing use-case designs into concrete exercises
for Jenkins execution capacity, pipeline-tool selection, native builds,
Terraform state, multi-account cloud auditing, cost incidents and incident
command.

This is a documentation-only specification. It does not install a Jenkins
plugin, create an agent, start a Kubernetes pod, access a cloud account, change
a billable resource, inject a fault or authorize a production action. Every
runtime exercise requires its own reviewed change and must reuse the existing
environment unless a separate architecture decision approves otherwise.

The claim boundary is as important as the exercise:

| Evidence available | Honest interview language |
| --- | --- |
| Design and fixtures only | “I designed the control and tested its decision logic with fixtures.” |
| Executed in the enterprise lab | “I implemented and exercised it in a production-like enterprise lab.” |
| Executed against a real cloud account | “I executed it in the named non-production cloud scope and retained the billing/runtime evidence.” |
| Executed in production as part of accountable employment | “I handled this in production,” only when the individual can truthfully substantiate that experience. |

## Learning map

| Learning lab | Primary use cases | Result the learner must be able to defend |
| --- | --- | --- |
| Elastic Jenkins execution capacity | `UC-CICD-002`, `UC-CICD-009`, `UC-CICD-015` | Why work runs on a particular agent, how capacity expands safely, how secrets and workspaces disappear, and what happens when capacity cannot start |
| Pipeline-tool selection | `UC-CICD-001`, `UC-CICD-009` | Why GitLab CI, Jenkins, AWX, Helm and future GitOps each own a different decision |
| Native C/C++ build | `UC-CICD-002`, `UC-CICD-003`, `UC-CICD-005` | How compilation, dependency caching, tests and binary provenance differ from container-only builds |
| Terraform state integrity | `UC-INFRA-001`, `UC-INFRA-009`, `UC-CICD-014` | How roots, modules, backend identity, locking, state lineage and drift remain separate across environments |
| Multi-account S3 audit with Boto3 | `UC-GOV-004`, `UC-GOV-006` | How to discover accounts, assume a bounded role, audit every bucket, survive partial access and produce an attributable report without changing AWS |
| Cost-overrun response | `UC-GOV-016`, `UC-GOV-017`, `UC-K8S-013` | How a cost spike is detected, owned, correlated, mitigated, validated and measured without turning recommendations into uncontrolled shutdowns |
| Incident command and learning | `UC-OBS-007`, `UC-OBS-014`, `UC-RSO-004` through `007`, `008`, `014`, `019` | How a team declares, diagnoses, mitigates, verifies and learns from a production-grade incident exercise |
| Cross-project release compatibility | `UC-CICD-016`, `UC-CICD-007`, `UC-DATA-007`, `UC-DATA-008`, `UC-DB-004` | How separately owned producers and consumers prove interface, schema and migration compatibility before promotion |
| Dependency failure containment | `UC-RSO-021`, `UC-RSO-010`, `UC-OBS-009`, `UC-OBS-001`, `UC-K8S-005` | How deadlines, retries, idempotency, concurrency, degradation and recovery prevent one failed edge from exhausting the platform |

<a id="elastic-jenkins-agents"></a>

## Lab 1: Elastic Jenkins execution capacity

### Start from what exists

The verified baseline is one Jenkins controller with zero executors and one
exclusive Rocky Linux WebSocket agent with one `kubernetes-deployer` executor.
That is a deliberate separation-of-duty and blast-radius choice. It is not an
autoscaling fleet, an EC2 agent pool or proof of simultaneous Jenkins builds.

The first exercise is therefore a capacity decision, not an installation:

1. Record the current queue, executor, label and controller state.
2. Classify build workloads as source validation, native compilation,
   container build, infrastructure plan or Kubernetes deployment.
3. Assign each class a required label, image/toolchain, credential scope,
   network path, CPU/memory envelope and maximum execution time.
4. Define an owner-approved concurrency ceiling. The documentation must not
   invent a number.
5. Compare three options: retain the static agent, use ephemeral pods on the
   existing application cluster, or defer provider-native cloud agents until a
   cloud account is explicitly in scope.

### Conditional ephemeral-pod design

If separately approved, Jenkins may create short-lived agents in a dedicated
namespace on the existing four-node application cluster. The design requires:

- a pinned, scanned agent image identified by digest;
- a dedicated Kubernetes service account with no application-management
  privilege;
- namespace quota, limit range and network policy;
- pod templates selected by allowlisted Jenkins labels;
- `emptyDir` or equivalent disposable workspaces with no cross-build reuse;
- short-lived credentials injected only for the stage that needs them;
- controller-to-agent connectivity that does not expose the Jenkins controller;
- startup, idle and absolute execution timeouts;
- cleanup for successful, failed, aborted and orphaned agents; and
- a static-agent fallback only for explicitly compatible workloads.

This option reuses the existing cluster but still changes Jenkins and
Kubernetes configuration. Documentation does not authorize it.

### Capacity exercise

Use synthetic, non-deploying jobs with unique correlation IDs. The future
approved run should submit more work than the static executor can immediately
accept, then observe queueing and, if the ephemeral design is approved,
controlled agent creation.

| Step | Evidence |
| --- | --- |
| Baseline | Controller executor count, static agent label/capacity, queue depth and active build count |
| Submit load | Job IDs, immutable source revision, requested label and enqueue time |
| Place work | Agent/pod identity, image digest, node, start latency and credential class |
| Execute | Per-stage duration, CPU/memory high-water marks and result |
| Remove capacity | Agent disconnect, pod deletion, workspace deletion and orphan scan |
| Degraded mode | Behavior when image pull, scheduling, agent handshake or credential retrieval fails |
| Recovery | Queue drains, controller stays at zero executors, static agent remains healthy and unrelated namespaces do not change |

The learner must explain the difference between parallel stages, multiple
executors, multiple static agents and elastic agents. More executors can improve
throughput but also increase contention, secret exposure, downstream load and
the number of simultaneous failures.

<a id="pipeline-tool-selection"></a>

## Lab 2: Choosing the pipeline tool and job type

### Control-plane ownership

| Tool | Owns | Does not own |
| --- | --- | --- |
| GitLab CI | Fast source validation, lint, unit tests, policy checks and review artifacts | Unrestricted production mutation |
| Jenkins | Approved orchestration, parameters, promotion, evidence joins and rollback workflow | Host configuration hidden inside pipeline shell commands |
| AWX and Ansible | Inventory-bounded host/service configuration and idempotent verification | Application Helm release ownership |
| Helm through Jenkins | Reviewed bootstrap/application release lifecycle while Jenkins is the declared reconciler | Concurrent reconciliation with GitOps |
| Argo CD, when separately installed and accepted | Pull-based desired-state reconciliation after an explicit ownership handoff | Co-ownership of the same release with Jenkins |

### Jenkins job-type decision

| Job type | Select it when | Guardrail |
| --- | --- | --- |
| Multibranch Pipeline | Branch and merge-request discovery should create isolated runs from a repository-owned Jenkinsfile | Limit discovery scope, trust rules and credentials; prune stale branch jobs |
| Declarative Pipeline | The workflow has a predictable staged lifecycle and benefits from visible policy | Keep stages, agents, timeouts and post-actions explicit |
| Scripted Pipeline/shared library | Reusable orchestration needs controlled programmatic behavior | Pin the library revision and test backward compatibility |
| Freestyle | A legacy or bootstrap task cannot yet move to Pipeline | Record an owner and migration decision; do not add an unreviewed workaround |
| Job DSL | Jobs and folders must be generated from reviewed source | Seed only approved scripts and validate generated XML/objects before reconciliation |

For a question such as “which pipeline tool do you use?”, the answer should
start with the decision being controlled—not a list of products.

<a id="native-cpp-build"></a>

## Lab 3: Native C/C++ build profile

The existing delivery model can teach a native build without creating new
infrastructure. A future fixture repository may use the accepted application
runner for a small, non-networked CMake project.

Required pipeline stages:

1. Pin the compiler image and record compiler, CMake and dependency versions.
2. Configure an out-of-tree build directory.
3. Compile with warnings enabled and treat the owner-approved warning set as
   errors.
4. Run unit tests through CTest and publish machine-readable results.
5. Run a sanitizer build where the selected compiler supports it.
6. Cache only dependency/build inputs whose keys include toolchain, lock data
   and source revision; never cache credentials or final provenance.
7. Package the binary, debug symbols, license notice, checksum and software
   bill of materials as immutable artifacts.
8. Rebuild the same revision to evaluate reproducibility and explain any
   unavoidable differences.

Expected failure drills include a compiler error, missing native library, stale
cache, failing test, sanitizer finding and architecture mismatch. No C/C++
experience should be claimed until the fixture exists and its pipeline evidence
is retained.

<a id="terraform-state-drift"></a>

## Lab 4: Terraform modules, state, locking and drift

### Repository structure to defend

- Reusable modules own network, compute, storage, database, Kubernetes, IAM and
  monitoring patterns.
- Environment roots own dev, QA, stage and production composition and values.
- A module must not choose an environment-specific backend or silently share
  state with another root.
- Provider and module versions are pinned; environment branches are not used as
  a substitute for separate state identity.

### Backend identity contract

Before any real backend is used, record:

| Field | Requirement |
| --- | --- |
| Environment | Exact dev/QA/stage/prod identity |
| Backend | Approved existing endpoint and backend type |
| State key | Stable path that cannot collide with another root |
| Locking | Mechanism, timeout, owner and stale-lock recovery procedure |
| Encryption | At-rest and in-transit controls plus key owner |
| Identity | Read/plan principal separated from apply principal where supported |
| Backup | Version history or snapshot source and restore procedure |
| Lineage | Expected state lineage/serial and migration record |
| Evidence | Init output with secrets removed, lock contention result, backup/restore and drift report |

The architecture mentions remote state, but the current historical LocalStack
roots do not prove it. A future exercise may use an approved existing
S3-compatible endpoint only after backend compatibility and locking are
reviewed; the documentation must not silently treat MinIO as an accepted
Terraform backend.

### Failure exercises

1. Start two fixture operations against the same state and prove the second
   cannot mutate while the first holds the lock.
2. Present a wrong environment/key combination and require an identity mismatch
   before planning.
3. Change an allowlisted fixture resource outside Terraform, run a read-only
   plan, and produce a drift report without automatic apply.
4. Restore a backed-up fixture state into an isolated test key, validate
   lineage and outputs, then remove the isolated copy.
5. Demonstrate that a stale-lock recovery requires owner evidence rather than a
   blind force-unlock command.

<a id="boto3-s3-audit"></a>

## Lab 5: Read-only multi-account S3 audit with Boto3

The learning goal is a safe audit, not an AWS mutation. The script must work
first against fixtures and mocked clients. A real run remains deferred until an
AWS organization, audit role and evidence-retention owner are approved.

### Required behavior

- Paginate AWS Organizations accounts rather than assuming one response.
- Skip suspended accounts and preserve the account ID/name mapping.
- Assume a named read-only role with an external ID when policy requires it.
- Create a regional session from temporary credentials.
- Paginate or enumerate every visible S3 bucket.
- Evaluate public-access block, default encryption, versioning, ownership
  controls, logging and optional replication/lifecycle requirements.
- Treat `AccessDenied` as a finding for that control, not as permission to drop
  the account or bucket from the report.
- Never read object content.
- Emit account, bucket, region, control, status, reason and collection time.
- Return a distinct exit code for findings, partial coverage and fatal setup
  failure.

### Interview-sized reference skeleton

```python
from __future__ import annotations

import boto3
from botocore.exceptions import ClientError


def pages(client, operation: str, result_key: str, **kwargs):
    paginator = client.get_paginator(operation)
    for page in paginator.paginate(**kwargs):
        yield from page.get(result_key, [])


def account_session(sts, account_id: str, role_name: str, external_id: str | None):
    request = {
        "RoleArn": f"arn:aws:iam::{account_id}:role/{role_name}",
        "RoleSessionName": "midhhealth-s3-audit",
    }
    if external_id:
        request["ExternalId"] = external_id
    credentials = sts.assume_role(**request)["Credentials"]
    return boto3.Session(
        aws_access_key_id=credentials["AccessKeyId"],
        aws_secret_access_key=credentials["SecretAccessKey"],
        aws_session_token=credentials["SessionToken"],
    )


def read_control(callable_, *, missing="not-configured"):
    try:
        return "observed", callable_()
    except ClientError as error:
        code = error.response.get("Error", {}).get("Code", "Unknown")
        if code in {"NoSuchConfiguration", "NoSuchPublicAccessBlockConfiguration"}:
            return missing, None
        if code in {"AccessDenied", "AccessDeniedException"}:
            return "access-denied", None
        raise


def audit_bucket(s3, bucket_name: str) -> dict:
    public_state, public = read_control(
        lambda: s3.get_public_access_block(Bucket=bucket_name)["PublicAccessBlockConfiguration"]
    )
    encryption_state, encryption = read_control(
        lambda: s3.get_bucket_encryption(Bucket=bucket_name)["ServerSideEncryptionConfiguration"]
    )
    versioning_state, versioning = read_control(
        lambda: s3.get_bucket_versioning(Bucket=bucket_name), missing="disabled"
    )
    return {
        "bucket": bucket_name,
        "public_access_block": {"state": public_state, "value": public},
        "encryption": {"state": encryption_state, "value": encryption},
        "versioning": {"state": versioning_state, "value": versioning},
    }
```

The complete exercise must add ownership controls, logging, lifecycle,
replication, region discovery, normalized findings, tests for paginated and
denied responses, and a main program with safe exit codes. The skeleton is not
presented as a finished production auditor.

<a id="cost-overrun-remediation"></a>

## Lab 6: Cost-overrun detection and remediation

### One coherent incident

The scenario begins with a service that normally stays within an owner-approved
cost envelope. A release or configuration change increases compute, storage,
telemetry or data-transfer usage. The workflow must answer five questions in
order:

1. **Is the increase real?** Check data completeness, currency, credits,
   amortization, time zone and delayed billing records.
2. **Who owns it?** Resolve account/project, environment, service, cost center,
   repository and accountable owner.
3. **What changed?** Correlate the first abnormal interval with deployments,
   Terraform plans, scaling changes, retention changes and workload demand.
4. **What is safe to do?** Compare stopping waste, scheduling non-production
   capacity, rightsizing, lowering replica count, changing retention or doing
   nothing because demand is legitimate.
5. **Did mitigation work?** Verify service health first, then measure cost and
   usage during a comparable interval.

### Existing-environment exercise

Before cloud billing is available, use the existing Kubernetes and Prometheus
data to build a showback fixture:

- namespace, workload and owner labels;
- requested and observed CPU/memory;
- persistent-volume allocation;
- an owner-approved static rate card used only for training;
- baseline, anomaly, forecast and right-sizing recommendation;
- one simulated approval and one rejected high-risk remediation; and
- a report separating estimated showback from an actual provider bill.

This creates defensible cost-engineering practice without claiming a cloud
cost saving. The page may move to real-cloud evidence only when read-only
billing data and an approved target exist.

### Real-cloud acceptance evidence

| Artifact | Required content |
| --- | --- |
| Billing slice | Provider, payer account, interval, currency, amortization rule and completeness time |
| Anomaly | Baseline, observed value, deviation, forecast exposure and confidence/reason |
| Ownership | Resource/service tags, repository and accountable owner |
| Change correlation | Commit, pipeline/plan/deployment and timing relationship |
| Decision | Options considered, business risk, approver and chosen action |
| Remediation | Exact bounded target, before state, command/job identity and rollback |
| Validation | Service health, performance, security and unrelated-resource checks |
| Savings | Comparable post-change interval and actual—not merely forecast—difference |

<a id="incident-command"></a>

## Lab 7: Production-grade incident command

These exercises use production disciplines in the enterprise lab. They are not
represented as employment production incidents.

### Roles and common clock

Every exercise names an incident commander, technical lead, communications
owner, service owner and scribe. One timeline records detection, acknowledgement,
declaration, hypotheses, decisions, mitigation, recovery, monitoring and closure.

Required evidence fields:

- incident ID, service, severity and customer/business impact statement;
- detection source and first useful signal;
- recent change IDs and dependency map;
- hypotheses, confirming/refuting evidence and decision owner;
- commands/jobs executed with target and operator identity;
- time to acknowledge, mitigate, recover and verify;
- rollback or safe-stop proof;
- post-incident causes, contributing conditions and corrective actions; and
- a repeat exercise proving the correction.

### Exercise A: Jenkins capacity unavailable

Make a synthetic job request a label that no online agent currently satisfies.
The learner must distinguish a source error from queue/capacity state, trace the
label through Job DSL and shared-library behavior, avoid enabling controller
executors as a shortcut, restore the intended agent path, and verify that the
queue drains without duplicate mutation.

### Exercise B: Kubernetes service path failure

Use a disposable canary and an approved reversible mismatch such as a selector
that has no matching pod. The learner correlates ingress/service/endpoints,
pod readiness, synthetic checks, logs and the recent change; chooses rollback
or fix-forward; verifies the user path and confirms unrelated namespaces did
not change.

### Exercise C: Shared dependency recovery

Use a safe, pre-approved dependency scenario derived from existing experience,
such as a sealed Vault after restart, DNS resolution disagreement or a
database connection-saturation fixture. The learner declares impact, identifies
the dependency owner, follows the recovery runbook, validates consumers and
records why alert clearance alone is not proof of recovery.

### Post-incident review standard

The review is blameless but specific. “Human error” is not a root cause. The
review identifies the conditions that made the action possible, why detection
did or did not work, which guardrail changes, who owns each action, when it is
due and how a later exercise will prove effectiveness.

<a id="cloud-kubernetes-leadership-track"></a>

## Track 2: Cloud, Kubernetes and technical leadership

These questions test architecture judgment as much as tool knowledge. A strong
answer keeps three threads together: the enterprise requirement, the technical
decision and the evidence that would prove the result. The answer must also
state whether it describes completed lab work, an approved design or a future
cloud reference pattern.

### Question-to-architecture map

| Interview question | Primary pages | What the answer must make clear |
| --- | --- | --- |
| Walk through a cloud infrastructure project you designed and implemented. | `UC-INFRA-001`, `004`, `007`, `009`, `010`, `012` | Problem, boundaries, module/root structure, plan and policy gates, drift/impact evidence, Ansible handoff and the exact implementation limit. |
| Design a secure Azure environment for a healthcare application. | `UC-INFRA-002`, `UC-GOV-004`, `005`, `007`, `008`, `UC-NET-023`, `UC-DB-017` | Data classification, identity, network/data isolation, private access, secrets, policy, telemetry, recovery and regulated evidence. |
| Design and operate Kubernetes clusters at scale. | `UC-K8S-002`, `004`, `005`, `006`, `009`, `010`, `012`, `013` | Fleet contract, tenancy, upgrades, policy, capacity, release ownership, observability, cost and recovery without claiming an unbuilt managed fleet. |
| Troubleshoot a Kubernetes application that suddenly becomes unavailable. | `UC-OBS-002`, `007`, `012`, `014`, `UC-NET-019`, `UC-RSO-004` through `007` | User impact first, path-by-path diagnosis, recent-change correlation, safe mitigation, recovery verification and incident evidence. |
| Structure Terraform for multiple teams and environments. | `UC-INFRA-001`, `007`, `009`, `010`, `012`, `UC-CICD-014` | Module ownership, environment roots, state identity, versioning, policy, promotion, drift and team boundaries. |
| Build observability for Azure and Kubernetes workloads. | `UC-OBS-001` through `004`, `006`, `007`, `011`, `013`, `014`, `016` | Common telemetry identity, provider/platform sources, SLOs, cardinality/retention, routing and one incident workspace. |
| Describe a complex production incident and its resolution. | `UC-RSO-004` through `008`, `014`, `019`, `UC-OBS-007`, `014` | Impact, role, timeline, hypotheses, evidence, mitigation, verification and lesson—with the environment truth stated plainly. |
| Lead a cloud project from requirements through production. | Application deployment register plus infrastructure, delivery, governance, observability and resilience chains | Requirements, decisions, backlog, delivery gates, readiness, cutover, recovery, acceptance and operating ownership. |
| Disagree with another engineer about cloud architecture. | Architecture decisions in every detailed page; `UC-INFRA-007`, `012` | Shared criteria, evidence, reversible experiment, recorded decision and team outcome rather than winning an argument. |
| Mentor junior cloud engineers while protecting quality and security. | Engineer training standard plus delivery, governance and operational-readiness chains | Progressive responsibility, pairing, review automation, safe sandbox/fixtures, feedback and measured independence. |

### 1. Cloud infrastructure project walkthrough

Use one coherent MidhHealth example rather than listing every cloud product.
The defensible current story is the multi-cloud infrastructure automation
project: reusable Terraform intent, separate environment roots, plan analysis,
drift detection, impact mapping, policy checks and the Ansible/AWX handoff.

A clear answer follows this arc:

1. **Problem:** manual infrastructure work lacked consistent state, review,
   ownership and recovery evidence.
2. **Design:** reusable modules remain separate from environment roots; plans
   carry target/state identity; privileged apply remains separately approved.
3. **Implementation:** source-level first slices exist for plan analysis, drift
   and impact mapping in the named platform repository.
4. **Verification:** positive and blocking fixtures prove decision behavior;
   repository, runtime and acceptance states remain separate.
5. **Boundary:** the lab does not provide evidence of a real AWS, Azure or GCP
   deployment, so the answer must not claim one.

The useful follow-up is not “which services did you use?” but “show how an
application request becomes an owned plan, a safe change and recoverable
evidence.”

### 2. Secure Azure healthcare reference design

Start with workload and data classification before drawing Azure components.
The reference design must decide:

- tenant, management-group, subscription, region and environment isolation;
- human and workload identities, privileged access, break-glass ownership and
  separation between plan and apply;
- VNet/subnet and routing boundaries, private service access, DNS resolution,
  controlled egress and hybrid connectivity requirements;
- approved compute profile—such as AKS, VM or managed application service—only
  after availability, data and operational requirements are known;
- Key Vault secret/key/certificate ownership, rotation and application access;
- encryption, database identity, backup, restore, retention and data-residency
  decisions;
- Azure Policy and infrastructure-code checks for allowed regions, public
  exposure, encryption, diagnostic settings and required ownership metadata;
- metrics, logs, traces, activity/resource changes, SLOs and incident routing;
- zone/region failure behavior, RTO/RPO, recovery authority and evidence; and
- cost ownership, budgets and anomaly response.

HIPAA eligibility or a cloud provider control does not make the application
compliant by itself. MidhHealth still needs its own access, configuration,
logging, retention, risk and operating evidence. This is a design exercise;
Azure deployment remains deferred in the current environment.

### 3. Kubernetes fleet design and operation

At scale, standardize the cluster and workload contracts rather than treating
every cluster as a hand-built server. The design covers:

- fleet inventory, purpose, environment, region, version, owner and lifecycle;
- control-plane and node-pool separation, availability domains, capacity
  reserve and disruption budgets;
- namespace tenancy, workload identity, RBAC, admission policy, image trust,
  network policy and secret delivery;
- one declared release reconciler per object, versioned add-ons and staged
  cluster/application upgrades;
- autoscaling limits, quota, right-sizing and cost allocation;
- API, node, storage, DNS, ingress, workload and dependency telemetry;
- backup/restore and region/cluster failure decisions tied to application data
  and SLOs; and
- canary clusters or upgrade rings, conformance tests, rollback and acceptance
  evidence.

The current accepted target is one four-node on-premises application cluster.
AKS/EKS/GKE remain portable design patterns, not a running fleet.

### 4. Kubernetes unavailability investigation

Use a timed decision tree instead of beginning with random pod commands:

1. Confirm the user-visible symptom, affected routes/tenants and incident
   severity; preserve a working comparison if one exists.
2. Check synthetic and ingress signals, DNS/TLS, load-balancer or proxy health,
   Kubernetes Service and EndpointSlice membership.
3. Inspect Deployment/StatefulSet desired versus available replicas, pod phase,
   readiness, restarts, events, image pull, scheduling and resource pressure.
4. Check node readiness, CNI/network policy, storage attachment/mount, service
   account/secret availability and shared dependencies.
5. Correlate the start time with application, configuration, policy, ingress,
   secret, node and infrastructure changes.
6. Choose rollback, fix-forward, traffic isolation or dependency recovery based
   on evidence and blast radius.
7. Verify the user path, error/latency recovery, backlog drain, data integrity
   and unrelated workloads before closing.

An alert returning green is not enough. The incident record needs commands or
queries, results, decisions, operator/target identity and follow-up ownership.

### 5. Terraform collaboration model

- Platform teams own small, versioned modules and compatibility promises.
- Environment or product teams own roots that compose modules and declare
  values; modules never select an environment backend.
- Each root has a unique backend identity, state key, lock and apply identity.
- Provider/module locks and a reviewed upgrade path prevent invisible version
  changes.
- Merge requests run format, validate, unit/fixture, security/policy, plan and
  impact checks before an expiring approval.
- CODEOWNERS or equivalent review maps module, environment, security and service
  responsibility without creating a shared superuser team.
- Drift is detected read-only and routed to the owner; it is not silently
  repaired across every environment.

### 6. Azure and Kubernetes observability design

Join provider, platform and application signals through common service,
environment, cluster, namespace, release and correlation identities. Azure
resource/activity signals and approved Azure Monitor sources can cover managed
resource health, while Prometheus/OpenTelemetry, Kubernetes events, logs and
traces cover cluster and workload behavior. The exact bridge is selected only
after source, volume, retention, residency and cost requirements are known.

Dashboards follow questions: Is the user journey failing? Which release or
dependency changed? Is the cluster or provider unhealthy? Can the service meet
its SLO? Alerts route to the service owner and include a runbook and recent
change context. Cardinality budgets, sampling, redaction and retention are part
of the architecture—not later cleanup.

### 7. Incident answer without invented production history

Use a bounded lab incident when that is the available evidence. A strong
answer still includes impact, assigned role, detection, timeline, competing
hypotheses, decisive evidence, safe mitigation, user-path verification and the
control changed afterward. State “production-grade lab exercise” rather than
“production incident” unless the individual has accountable real-production
experience that can be substantiated.

### 8. Leading work from requirements to operation

1. Identify business workflow, users, data classification, availability,
   recovery, compliance, cost and ownership requirements.
2. Convert them into measurable quality attributes and application/platform
   contracts; make unknown thresholds owned decisions.
3. Compare options against security, operability, reversibility, team skill and
   existing-environment fit; record the decision and rejected alternatives.
4. Create thin vertical milestones that include source, policy, telemetry,
   recovery and evidence—not infrastructure construction alone.
5. Run design, threat, operability and capacity reviews before privileged work.
6. Validate source and fixtures, then non-production runtime, failure/recovery,
   readiness, cutover and rollback under separate gates.
7. Transfer dashboards, alerts, runbooks, access, cost ownership and follow-up
   risks to the operating team before acceptance.

### 9. Architecture disagreement

Frame the disagreement around a decision such as Jenkins-managed Helm versus
GitOps ownership, one large cluster versus bounded clusters, or centralized
versus team-owned Terraform roots. Establish shared criteria, surface the
operating risks, gather measurements, run a reversible experiment where useful
and record one accountable decision. Explain what changed in your own view and
how the team worked afterward. Avoid casting the other engineer as the problem.

### 10. Mentoring with quality and security intact

Give junior engineers progressively wider responsibility: read an existing
contract, reproduce a fixture, make a small reviewed change, own its failure
test and runbook, then lead a bounded implementation. Pair on threat modeling
and incident reasoning; automate formatting, policy, secret and contract checks;
use review comments to explain risk rather than merely prescribe syntax. Track
independence through successful changes, recovery drills and fewer repeated
review findings—not through the number of training sessions.

<a id="ai-pipeline-dependency-track"></a>

## Track 3: AI-assisted pipeline and dependency analysis

This question set contains three different interviews at once: personal fit,
ownership of a measured engineering problem, and a deep technical review of a
pipeline/dependency-analysis implementation. Keep those threads separate so a
personal answer does not become an invented platform claim.

### Personal questions are not architecture content

`Tell me about yourself`, motivation for a new role, current location,
relocation/onsite availability and questions for the interviewer require the
individual’s own facts. The architecture repository cannot supply them.

A useful introduction connects three truthful points: present engineering
scope, one or two relevant outcomes and why the role is the next logical step.
Location and relocation answers should be direct. Good closing questions ask
about the first six months, platform ownership, production/on-call expectations,
decision authority, security review, team interfaces and how success is
measured.

### The project story and claim boundary

The proposed MidhHealth learning project is a deterministic pipeline-feedback
and dependency-analysis capability in
`midhhealth/platform-delivery/devsecops-cicd-orchestrator`. It is not a
Buildkite deployment and is not currently implemented. GitLab CI and Jenkins
are the accepted delivery tools. A candidate may discuss Buildkite steps,
agents, plugins, dynamic pipelines, concurrency groups or artifact handling
only when they have real Buildkite experience and can identify the exact
configuration they changed.

The story becomes defensible after implementation evidence exists:

1. Developers report or pipeline data shows slow actionable feedback.
2. The engineer defines start/end events and separates queue, setup,
   dependency, validation, test and artifact time.
3. A Python analyzer normalizes pipeline timing and multi-ecosystem dependency
   fixtures into stable result schemas.
4. Pipeline structure changes move deterministic, cheap validation earlier and
   avoid repeating dependency setup without weakening required gates.
5. Baseline and post-change samples use the same inclusion rules and report
   median, tail distribution, failures and sample count.
6. AI may assist with skeletons, test cases or review, but deterministic tests,
   human review and runtime evidence establish correctness.

### What “developer waiting time” means

Never quote one improvement number without defining the clock. Record at least:

| Metric | Start | End | Why it matters |
| --- | --- | --- | --- |
| Queue delay | Job enqueued | Agent begins execution | Shows capacity/label scheduling delay |
| Time to first actionable failure | Pipeline creation | First required failing gate completes | Shows how quickly a developer can correct a change |
| Time to minimum trusted feedback | Pipeline creation | Required lint/config/unit/security set completes | Shows the useful inner-loop wait |
| Dependency setup time | Install/restore step begins | Validated environment is ready | Exposes resolution, download and cache cost |
| Full pipeline duration | Pipeline creation | Final required gate completes | Shows release-path throughput, not just developer feedback |

Collection uses CI/job timestamps and structured step results. Every sample
records project, revision, pipeline/job ID, executor class, outcome, cache state,
toolchain revision and excluded intervals. Compare the same branch/event type
and gate set before and after a change. Report sample count and percentiles;
do not present one unusually fast run as the outcome.

### Pipeline change and configuration validation

The buildable MidhHealth equivalent uses GitLab/Jenkins, not Buildkite:

- separate configuration/lint, dependency inventory, unit test, security,
  package and deployment stages;
- run deterministic cheap gates early and compatible read-only gates in
  parallel;
- pin job/shared-library and toolchain versions;
- use cache keys derived from ecosystem, lockfile, runtime and architecture;
- never cache credentials or treat a cache as release provenance;
- validate CI YAML, Jenkins job generation, shared-library interfaces, required
  stages, dependencies, timeouts, retry policy, artifact expiry and credential
  references with positive and negative fixtures; and
- deploy the template through the existing Job DSL/shared-library path, then
  compare generated configuration and run a synthetic project before wider
  adoption.

For a real Buildkite answer, name the repository and exact changes—such as
`pipeline.yml` steps, `depends_on`, `if`, concurrency, agents/queues, plugins,
artifact paths, environment hooks or dynamically uploaded steps—and show how
`buildkite-agent pipeline upload` or the organization’s accepted validator was
used. Without that evidence, say the experience is transferable rather than
claiming Buildkite implementation.

### Python dependency normalization design

The analyzer uses adapters behind one normalized model. Initial fixture support
may cover:

- Python: `requirements*.txt`, `pyproject.toml`, `poetry.lock` and
  `Pipfile.lock` where present;
- Node.js: `package.json` with `package-lock.json` or an explicitly supported
  lock format; and
- later ecosystems only through separate parser fixtures and schema review.

Manifest declarations establish direct intent; lock/resolver graphs establish
resolved and transitive packages. The normalized record includes repository,
ecosystem, manifest, lockfile, package, requested constraint, resolved version,
direct/transitive classification, parent chain, scope, source and parse
warnings. Unsupported syntax produces partial coverage or a blocking result
according to policy; it is never silently dropped.

Use Python standard parsers such as `json`, `tomllib`, `configparser` or
`xml.etree.ElementTree` where the format permits. Requirements and lock formats
that are not fully standardized need dedicated tokenization/adapters and
golden-file tests; unsafe evaluation of repository content is prohibited.

The remediation output has two forms:

- schema-valid JSON for pipeline decisions and later automation; and
- reviewer-oriented Markdown grouping direct and transitive findings by
  repository, severity/policy, dependency path, installed/requested version,
  recommended action, owner, exception and coverage gap.

Dependency inventory alone does not prove vulnerability. Advisory identity,
feed timestamp/version, affected-version logic and coverage status must be
present before the report labels a package vulnerable.

### AI-assisted engineering evidence

AI may generate a parser interface, dataclass/schema skeleton, fixture matrix,
test skeleton, documentation draft or alternative refactoring. Record the tool,
model/version where available, purpose, sanitized input class, output commit or
diff and human reviewer. Do not send credentials, proprietary source, PHI or
unapproved repository content to an external model.

Correctness comes from:

- manually reviewed invariants and threat boundaries;
- unit and golden-file tests for every supported format;
- malformed, ambiguous, adversarial and unsupported fixtures;
- schema validation and deterministic reruns;
- comparison with the ecosystem’s trusted resolver on bounded fixtures;
- code/security review and secret/license checks; and
- a baseline-versus-change pipeline result on the intended existing runner.

“AI generated it” is provenance, not validation. The engineer remains the
author of the accepted design and responsible for every changed line.

### Question-to-evidence map

| Interview follow-up | Evidence needed before answering as completed work |
| --- | --- |
| Why investigate, and was it assigned? | Problem signal, issue/decision record and the individual’s actual role; do not invent initiative. |
| What was measured, with what start/end? | Versioned metric definition, raw pipeline/job timestamps, inclusion rules and baseline window. |
| What tools analyzed it? | Exact collection/export code, Python modules/notebook/report and pinned dependencies actually used. |
| Who participated and what did you own? | Real contributors, reviews, commits and decision responsibility. |
| What pipeline configuration changed? | Diff, generated configuration, stage graph and before/after run IDs. |
| How was configuration/dependency installation validated? | Schema/static checks, negative fixtures, clean install, lock consistency, cache-miss run and reproducibility evidence. |
| What did AI produce? | Sanitized prompt/task record, generated skeleton/diff and the tests/review that accepted or rejected it. |
| How were direct/transitive dependencies distinguished? | Manifest adapter, lock/resolver graph, parent-chain fixtures and normalized JSON. |
| What did the remediation report look like? | Checksummed JSON and Markdown artifacts with ownership, coverage and reason codes. |
| What did you personally improve? | Specific authored diff, review record and measured result tied to the same definition. |
| What complicated Python did you write? | Parser/adapters, graph normalization, error model and tests—not a vague claim about scripting. |

<a id="supported-reliability-operations-track"></a>

## Track 4: Reliability work we can build on the current platform

The strongest scenarios in the interview material are ordinary production
problems: a service spends its error budget too quickly, a Kubernetes node
drifts, PostgreSQL runs short of connections, a batch job crowds out an online
workload, or a well-intended repair makes the incident worse. MidhHealth
already has enough platform to build honest lab versions of those problems.
They belong in existing repositories and use the accepted GitLab runner,
Jenkins/AWX paths, four-node kubeadm cluster, PostgreSQL 18 service, and
Prometheus/Grafana stack.

| Scenario accepted for enhancement | Pages that own it | Buildable evidence on the current platform |
| --- | --- | --- |
| SLOs and fast/slow error-budget burn | `UC-OBS-001`, `UC-OBS-006`, `UC-OBS-016`, `UC-RSO-002` | Versioned SLI/SLO contract, Prometheus recording and multi-window alert rules, Grafana source, synthetic time-series fixtures and alert-routing proof |
| Node and service configuration drift | `UC-K8S-001`, `UC-LNX-015`, `UC-LNX-019` | Read-only collectors for kubelet/containerd/systemd facts, expected-state comparison, reason-coded report, AWX check-mode job and recovery runbook |
| PostgreSQL connection saturation | `UC-DB-008`, `UC-DB-011`, `UC-DB-019`, `UC-OBS-010` | Safe `pg_stat_activity` queries, connection-budget contract, exporter/rule/dashboard source, blocked and recovery fixtures, and an operator decision record |
| Batch workload isolation and queue health | `UC-K8S-006`, `UC-K8S-010`, `UC-DATA-018`, `UC-RSO-012` | Resource-policy fixtures, namespace quota/limit checks, queue-age and completion metrics, bounded load profile and a no-impact acceptance report |
| Capacity forecasting | `UC-DB-014`, `UC-LNX-014`, `UC-RSO-012` | Prometheus query definitions, forecast window and confidence metadata, saturation fixtures and reviewed capacity recommendation |
| Incident triage and guarded repair | `UC-OBS-015`, `UC-GOV-011`, `UC-GOV-012`, `UC-GOV-014` | Correlated evidence bundle, decision state machine, dry-run AWX action, canary/approval gates and recovery or zero-change proof |
| Cross-project compatibility | `UC-CICD-016`, `UC-DATA-007`, `UC-DATA-008`, `UC-DB-004`, `UC-RSO-010` | Producer and consumer fixture projects, API/event/migration adapters, consumer-coverage report, blocking result and last-compatible revision |
| Dependency failure containment | `UC-RSO-021`, `UC-OBS-009`, `UC-OBS-001`, `UC-K8S-005`, `UC-CICD-015` | Virtual-time slow/error/duplicate scenarios, bounded retry and concurrency profile, user outcome, saturation evidence and recovery result |

### Boundaries learned from the scenarios

- A burn-rate alert uses paired short and long windows so one noisy interval
  does not page the team by itself. The SLO owner defines the indicator,
  objective, window, exclusions and missing-data behavior.
- Node checks are read-only first. A mismatch in kubelet, containerd or systemd
  state produces evidence; it does not restart a node during diagnosis.
- PostgreSQL is the verified database. Pool health is expressed as application
  and database connection budgets. pgBouncer-specific configuration remains
  conditional because no current pgBouncer deployment is recorded.
- Batch isolation uses requests, limits, quotas, node labels, affinity and—only
  where justified—taints/tolerations. Values come from repeated measurements,
  not copied percentages from an interview story.
- Detection and repair stay separate. Automation may recommend or stage a
  bounded action; mutation needs the named target, immutable revision, canary,
  authorization, stop condition and recovery proof.

### Scenarios deliberately not added

GPU placement, GPU memory-fit checks and NVIDIA/DCGM monitoring are not current
MidhHealth capabilities. Adding those pages would invent hardware and runtime
that are absent from the verified inventory. Buildkite is also outside the
documented delivery toolchain. Candidate employers, production numbers and
incident outcomes from interview material are not architecture evidence and
must not appear as MidhHealth claims.

## Build and deployment gate for every learning enhancement

Interview depth is accepted only when it changes a buildable platform
contract. Every linked use-case page binds its added behavior to the existing
contract, implementation, schema, fixture, CI and runbook locations already
listed under `Implementation design`.

| Learning enhancement | Buildable unit | Intended deployment or execution path | Runtime boundary |
| --- | --- | --- | --- |
| Pipeline selection and native builds | Jenkins job/shared-library behavior, native fixture, test/provenance schema and CI cases in the delivery repositories | Existing GitLab runners and approved Jenkins agent path | Elastic agents remain conditional; controller executors remain zero |
| Terraform state and drift | Backend-identity contract, plan/drift evaluator, lock/recovery fixtures and result schema in `cloud-infra-automation-platform` | Existing infrastructure runner for source/read-only proof; privileged action separately approved | No cloud backend or account is assumed |
| Boto3 S3 audit | Read-only auditor, mocked clients, policy schema and partial-coverage fixtures in `cloud-governance-ops-automation` | Existing GitLab runner for fixtures; approved STS role only after a real AWS scope exists | No object reads or bucket mutation |
| Cost response | Anomaly/showback evaluator, decision schema, right-sizing recommendation and recovery fixtures across governance and Kubernetes repositories | Existing runner and Prometheus-derived fixture path | Showback is not a provider bill; mutations need owner approval |
| Incident command | Service record, scenario fixtures, evidence collector, dashboard/rules and guarded remediation source | Existing observability, GitLab and approved Jenkins/AWX paths | Fault injection and production action require separate change approval |
| Secure Azure design | Azure contract, module/root fixtures, policy/plan evidence and runbook in `cloud-infra-automation-platform` | Source and fixture CI only until Azure identity, account, state and network are approved | No Azure runtime currently exists |
| Kubernetes fleet and troubleshooting | Cluster/workload profile, conformance and verification fixtures, monitoring rules and recovery runbook | Existing four-node cluster only for separately approved bounded tests | AKS/EKS/GKE remain reference patterns |
| Azure/Kubernetes observability | Common telemetry schema, queries/rules, dashboard source, alert fixtures and retention/cardinality policy | Existing observability path; Azure collectors only after a real source is approved | No invented telemetry source or backend |
| Pipeline feedback and dependency analysis | Python timing/dependency adapters, normalized schema, report renderer, job/shared-library integration and fixtures | Existing GitLab runner and approved Jenkins template path | Buildkite remains outside the MidhHealth toolchain unless separately approved |
| Cross-project release compatibility | Contract adapters, consumer fixtures, coverage evaluator, result schema and blocking CI include | Existing GitLab runners first; approved Jenkins promotion may consume an immutable result later | No real application-to-application claim until two registered projects and owners exist |
| Dependency failure containment | Resilience profile validator, virtual-time scenario runner, result schema and recovery runbook | Existing GitLab runner first; bounded application-cluster exercise only after separate approval | No service mesh, new queue, cache, gateway or fault-injection product is implied |

An enhancement cannot move to `Implemented in code` until all changed artifacts
pass repository validation. It cannot move to `Runtime verified` until the
named target records current execution and independent recovery or non-mutation
evidence. It cannot move to `Accepted` until the application or platform owner
reviews the outcome.

## Completion rubric

| Level | Required proof |
| --- | --- |
| Designed | Scenario, architecture, roles, inputs, controls, failure behavior, recovery and evidence contract are reviewed |
| Fixture-tested | Positive, blocking, partial, malformed and recovery cases pass in source CI |
| Lab-exercised | Approved bounded run on the intended existing target plus independent recovery evidence |
| Cloud-exercised | Read-only or bounded run in an explicitly approved cloud scope with account and provider evidence |
| Interview-ready | Learner can explain the problem, decision, implementation, failure, recovery, measured result and claim boundary without memorized tool lists |

No exercise is complete merely because this page exists. Status remains on the
individual use-case pages and in the central implementation-status record.
