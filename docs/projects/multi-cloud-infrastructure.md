# Multi-Cloud Infrastructure Domain

**Repository:** `midhhealth/platform-engineering/cloud-infra-automation-platform`  
**Team size:** 6 engineers

## Team Responsibilities

The infrastructure team owns repeatable cloud and on-prem infrastructure
patterns. It turns approved architecture into Terraform modules, plans,
impact analysis, drift checks, and Ansible-ready inventory.

| Team member | Primary responsibility |
| --- | --- |
| Infrastructure Platform Lead | Owns cloud/on-prem standards, module roadmap, landing-zone patterns, and capacity decisions. |
| Terraform Module Engineer | Builds reusable VPC/VNet, compute, storage, database, and Kubernetes foundation modules. |
| Cloud Network Engineer | Designs cloud routing, subnetting, security groups, private endpoints, and hybrid connectivity with the network team. |
| Infrastructure Automation Engineer | Connects Terraform outputs to Ansible/AWX workflows and post-provision configuration. |
| Policy and Drift Engineer | Maintains plan review, drift detection, state integrity, tagging, and policy-as-code gates. |
| Cost and Capacity Engineer | Reviews sizing, utilization, tagging, forecasts, and cloud cost controls. |

## Connected Teams

- Feeds Kubernetes, Linux systems, database, network, and AI/MLOps runtime needs.
- Depends on governance for policy, identity, secrets, cost, and compliance controls.
- Sends infrastructure change context to observability and resilience for incident correlation.

## Executable Use-Case Scope

- Terraform drift detection, health assessment, reconciliation, and plan analysis.
- AWS, Azure, and GCP landing-zone foundations.
- Policy-driven provisioning and tagging.
- Terraform state integrity monitoring.
- Infrastructure change impact analysis.
- Self-service infrastructure request templates after governance approval.

## The infrastructure promise

This domain turns an approved runtime need into a reviewable plan and, only
when a target is authorized, a controlled apply. The useful output is not
“Terraform ran.” It is a durable explanation of the target, module version,
state lineage, expected impact, policy result, owner, cost envelope, and
recovery choice.

![Hybrid infrastructure architecture](../assets/project-2-hybrid-infrastructure-architecture.svg)

## Composition model

Reusable modules and environment roots have different jobs. A module expresses
one tested capability such as network, compute, storage, database foundation,
or Kubernetes foundation. An environment root selects versions, connects
modules, supplies target-specific values, and owns one state boundary. Teams
must not place environment credentials, backend configuration, or production
addresses inside reusable modules.

| Concern | Design rule |
| --- | --- |
| Module interface | Typed inputs, explicit outputs, examples, validation and a versioned compatibility contract |
| Environment root | One accountable owner, target account/subscription/project, region, data class and environment |
| State | Isolated per root, remote when an approved backend exists, locked during mutation, encrypted and access logged |
| Planning | Pinned provider/module versions, saved plan, policy result, cost estimate and resource-to-service impact |
| Applying | Same reviewed revision and saved plan, short-lived identity, explicit approval and bounded target |
| Recovery | State backup/version, import or state repair procedure, and resource-specific rollback or replacement decision |

Provider-specific modules may implement a common contract, but AWS, Azure and
GCP are not presented as identical. Identity, network semantics, managed
service behavior, quotas and recovery differ. An architecture decision records
why a provider and service fit the workload before an environment root is
created.

## Current boundary and future targets

The active lab is the on-premises KVM/libvirt environment managed through the
existing GitLab, Jenkins and AWX path. The infrastructure repository can build
and validate fixtures for cloud plans, drift, state and impact analysis, but a
successful fixture is not a cloud deployment.

Real AWS, Azure or GCP execution remains conditional on named accounts,
approved short-lived identity, state backend, network integration, budget,
destroy/recovery workflow and per-provider acceptance. No cloud resource is
needed to make the repository structure, validation, plan parser or decision
records buildable today.

## Request-to-runtime flow

1. An application or platform owner supplies capacity, availability, data,
   connectivity, recovery and cost requirements.
2. Infrastructure engineering compares placement options against current lab
   capacity and records the decision. “Multi-cloud” alone is not a reason.
3. A merge request changes a module or environment root. CI validates format,
   interfaces, tests, policies, secrets and fixtures.
4. Jenkins creates a plan with a read-only or plan-scoped identity. The plan is
   reduced into additions, changes, deletions, sensitive paths, cost movement
   and affected services.
5. Governance and the target owner review the same saved plan. Apply cannot
   silently re-plan a different revision.
6. After an approved apply, AWX performs only the operating-system handoff that
   Terraform outputs explicitly describe. Observability verifies the target;
   the evidence record binds all three stages.

## Drift and state handling

A scheduled drift run is read-only. It refreshes known resources, classifies
the difference as expected, benign, risky or unknown, maps affected resources
to service owners, and opens a decision record. It never auto-applies a plan to
erase an unexplained change. Urgent security drift can launch a separately
approved bounded remediation, followed by service validation.

State incidents are handled before resource incidents. Lock contention stops
mutation; a missing or stale lock is investigated rather than force-unlocked
by default. State recovery uses backend versions and recorded lineage. Import,
move and removal operations require peer review because they change ownership
without necessarily changing a live resource.

## Cost-overrun response

Cost response begins with attribution, not shutdown. The team joins the bill or
fixture, required tags, service owner, recent infrastructure changes and
utilization. It compares rightsizing, scheduling, retention, commitment and
architecture options, records service risk, obtains owner approval, applies a
bounded change, and verifies both health and realized savings. Kubernetes
showback is labeled separately from provider billing. Forecast savings never
become “savings achieved” without a later measurement.

## Failure behavior and recovery

| Situation | Platform response |
| --- | --- |
| Validation or policy failure | No plan or apply; return the exact module, rule and corrective owner |
| State lock held | Stop mutation, identify the active operation, and preserve the lock until ownership is clear |
| Plan differs at approval | Discard it and produce a new review; never apply an unreviewed replacement |
| Partial apply | Capture state and provider operation status, block concurrent work, and choose complete, replace or roll back per resource |
| Post-change health regression | Freeze further infrastructure work and hand the mapped service impact to SRE and resilience |
| Unexpected spend | Preserve critical-service availability while a human approves the least risky mitigation |

## Buildable first slices and acceptance

The first slices are repository-native: module contract tests, example roots,
mock provider fixtures, plan normalization, lock-contention simulation, state
lineage checks, drift classification and impact reports. Acceptance requires
deterministic tests, negative cases, secret-free evidence and a recovery
exercise. A real provider apply adds identity, backend, bill, runtime and
destroy evidence; it does not replace the fixture tests. Detailed work remains
linked from the [infrastructure use-case index](../use-cases/infrastructure/README.md).

## Interview-led project leadership

The [cloud and Kubernetes leadership track](../platform-engineering-interview-learning-labs.md#cloud-kubernetes-leadership-track)
adds an end-to-end project narrative without changing the execution boundary.
The infrastructure lead moves from business workflow, data classification,
availability, recovery, compliance and cost requirements into measurable
quality attributes, option analysis, architecture decisions, thin delivery
slices, threat/operability review, source and fixture validation, bounded
runtime evidence, readiness and operating handoff.

Architecture disagreement is resolved through shared criteria and evidence.
For example, module ownership, environment-root boundaries or managed-service
selection should be compared for isolation, operability, reversibility, skill,
cost and current-environment fit. The decision record captures the selected
option, rejected alternatives, experiment or measurement, consequences and
revisit trigger. Seniority does not replace that record.

The current defensible implementation story remains the repository first
slices for plan analysis, drift and impact mapping. Azure, AWS and GCP runtime
deployment must be described as future reference architecture until execution
and acceptance evidence exists.
