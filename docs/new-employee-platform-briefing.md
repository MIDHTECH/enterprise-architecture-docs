# MidhHealth Integrated Care Reference Architecture

Last verified: 2026-08-13

## About this reference organization

MidhHealth Integrated Care is the worked example used throughout this
repository. It represents one organization that combines provider operations,
digital care and health-insurance services. The name gives new employees a
stable company, set of users and set of engineering problems to follow while
they learn the platform.

This is similar to the way Microsoft reference architectures use Contoso: the
company narrative makes the architecture concrete. It does not turn an example
business capability into a deployed application, and it does not make a target
cloud service part of the current environment. The authoritative deployment
facts remain in [Current Environment State](current-environment-state.md),
using the state vocabulary in
[`environment-capability-status.json`](environment-capability-status.json).

### Organization profile

| Item | MidhHealth reference scenario |
| --- | --- |
| Organization | Integrated care delivery and health-insurance enterprise |
| Provider side | Hospital operations, clinical workflows, digital care, patient access and care operations |
| Payer side | Claims, eligibility, authorizations, member services, payment integrity and payer analytics |
| Partners | Laboratories, pharmacies and other approved data or service exchanges |
| Shared functions | Security, compliance, platform engineering, data, AI/ML, enterprise architecture and reliability operations |
| Technology direction | Active on-premises integration lab with governed AWS, Azure and GCP extension patterns |
| Platform objective | Let independently owned applications use one repeatable delivery, runtime, security, telemetry and recovery model |

MidhHealth does not have one giant application. Care, payer and shared-service
applications remain separate projects with their own repositories, owners,
release schedules, data contracts and recovery decisions. The platform gives
them a common road, not common ownership.

## Business users and journeys

The architecture begins with people and work rather than products:

| Actor | What they need from the enterprise | What the platform must make possible |
| --- | --- | --- |
| Patient or member | Reliable access to the appropriate care or insurance workflow | Available, secure applications with clear failure and support paths |
| Clinician or care-operations staff | Timely, trustworthy workflow and information | Traceable application, data and dependency behavior without exposing unnecessary patient data |
| Claims or authorization staff | Consistent payer processing and auditable decisions | Versioned interfaces, controlled access, reliable data and recoverable services |
| Partner organization | A defined, secure exchange rather than informal connectivity | Named API/event/data contracts, identity, validation, monitoring and replay behavior |
| Application engineer | A fast way to build and release without becoming a platform specialist | Reusable pipeline, runtime, database, network and telemetry contracts |
| Platform engineer | A controlled way to change shared foundations | Source-managed automation, bounded credentials, canaries, evidence and rollback |
| SRE or on-call engineer | A trustworthy path from user symptom to service and dependency | Release-aware telemetry, service ownership, runbooks and recovery authority |
| Security, privacy or audit reviewer | Proof of which control applied to which asset and decision | Identity, policy, exception and evidence records without secrets or protected payloads |

These are reference personas, not proof that a named clinical or payer
application exists. A real application enters the architecture only after its
repository and accountable owners are registered.

## Architecture goals

The platform is designed to satisfy six enterprise requirements:

1. **Independent applications, shared controls.** A care or payer project can
   release independently while using the same review, identity and evidence
   standards.
2. **One artifact through promotion.** The revision built and tested is the
   revision presented to the runtime; later environments do not rebuild it.
3. **Clear ownership between tools.** GitLab validates source, Jenkins
   orchestrates, AWX/Ansible configures hosts, and one named reconciler owns a
   Kubernetes resource set.
4. **Hybrid without pretending every target is live.** The active on-premises
   platform proves the contracts. AWS, Azure and GCP adopt the same contracts
   only after accounts, identity, networking, state, budget and recovery are
   approved.
5. **Operation is part of delivery.** A release is incomplete without service
   identity, telemetry, dependency health and a recovery decision.
6. **Evidence is a product.** The exact source, pipeline, executor, target,
   control result and recovery outcome must be understandable after the work.

## Architecture at a glance

The platform is not twelve unrelated technology demonstrations. It is one
engineering operating model split into twelve ownership domains. Application
teams own software and business outcomes. Platform teams publish reusable
contracts for source, infrastructure, runtime, data, security and operations.
Git history, pipeline results and runtime evidence connect the work.

![MidhHealth component architecture](assets/component-architecture.svg)

Read the diagram from the outside in:

1. **Business operations create demand.** Provider, payer, digital-care and
   partner workflows create application and platform requirements.
2. **Applications retain business ownership.** Care, payer, shared API and
   analytics projects own their behavior and interfaces.
3. **GitLab records intent.** Each project keeps source, contract, review,
   protected-branch and validation history in its own repository.
4. **The delivery control plane executes the approved revision.** Jenkins
   coordinates the longer workflow. AWX/Ansible handles host prerequisites;
   Terraform represents infrastructure; Helm or a delegated GitOps reconciler
   owns Kubernetes desired state.
5. **The runtime foundation hosts the service.** The active lab uses KVM,
   Rocky Linux VMs and the kubeadm cluster. A future approved target can map the
   same contract to AWS, Azure or GCP without rewriting application ownership.
6. **Data, AI and MLOps consume governed inputs.** They cannot bypass source,
   identity, privacy, release or operating controls.
7. **Enterprise controls judge the outcome.** Security, compliance,
   observability and resilience return evidence to the owner.
8. **Evidence closes the loop.** Incidents, drift, cost and recovery results
   become the next reviewed change.

## The reference application estate

The company story describes business capability groups; the application
inventory contains only real registered projects.

| Portfolio area | What the architecture reserves space for | Current documented truth |
| --- | --- | --- |
| Care delivery | Clinical workflow, hospital operations, digital-care and patient-access applications | Capability area only; no real application repository is registered |
| Payer operations | Claims, eligibility, authorization, member-service and payment-integrity applications | Capability area only; no real application repository is registered |
| Shared platform APIs | Identity, workflow, integration and event interfaces | Platform contract category; no generic integration product is claimed |
| Analytics and decision support | Provider, payer and operational insight consumers | Capability area; data-platform products remain uninstalled |
| Reference workload | A non-PHI service that can exercise delivery and runtime contracts | `midhhealth/applications/podinfo` is registered and documented but not deployed |
| Healthcare AI and models | Governed retrieval, assistant and model-backed workflows | Platform repositories are scaffolded; runtime and protected-data use remain planned |

This prevents a common reference-architecture mistake: boxes make room for the
enterprise, but only the application register can claim a project is real.

## Platform foundation

The MidhHealth foundation plays the role that a landing-zone foundation plays
in a cloud reference architecture, but its active implementation is on premises.

| Foundation | Current implementation | Responsibility |
| --- | --- | --- |
| Source and review | GitLab CE and the `midhhealth` organization model | Repository ownership, merge requests, protected branches and source evidence |
| Delivery orchestration | Jenkins controller, dedicated agent, Job DSL and shared libraries | Build, test, policy, package, approval, release and rollback coordination |
| Configuration execution | AWX and Ansible | Bounded VM and operating-system convergence with job evidence |
| Compute and operating system | KVM/libvirt hosts and Rocky Linux VMs | Product and platform VM lifecycle, services, storage and host security |
| Container runtime | Four-node kubeadm cluster | Shared workload runtime with explicit namespace and ownership contracts |
| Application entry | BIND DNS, NGINX and private ingress-nginx | Named, testable producer-to-consumer service paths |
| Persistent Kubernetes storage | Longhorn on the three worker storage paths | Node-level replicated block storage; off-cluster backup is a separate decision |
| Telemetry | Prometheus, Alertmanager, Grafana, Loki, Tempo, OpenTelemetry and Elastic | Metrics, logs, traces, synthetic signals and incident evidence |
| Data and secrets | PostgreSQL 18, MinIO and Vault on documented paths | Approved relational, object and secret foundations within their accepted boundaries |
| Governance | GitLab/Jenkins/AWX policy and evidence workflows | Identity, policy, exceptions, audit evidence, cost and safe remediation decisions |
| Cloud extension | Terraform/Ansible patterns for AWS, Azure and GCP | Target architecture only until provider foundations are separately accepted |

Harbor is installed and healthy on its accepted native HTTPS endpoint; its
legacy shared-proxy route is not accepted. Keycloak requires revalidation, and
Artifactory, SonarQube and Splunk remain provisioned-only. Argo CD, managed
Kubernetes and cloud accounts are target architecture and must not be promoted
by their appearance in a diagram.

## Environment model

Applications are documented to move through development, QA, stage and a
production-simulation boundary. The current design uses Kubernetes namespace
separation rather than claiming four physical clusters.

| Environment | Intended decision | Promotion behavior |
| --- | --- | --- |
| Development | Does the change run and produce useful developer feedback? | Automated only inside the approved development boundary |
| QA | Does the release satisfy functional, contract and security validation? | Uses the same immutable candidate after required checks |
| Stage | Does it behave like the intended operational configuration? | Requires explicit promotion approval and health evidence |
| Production simulation | Can the lab demonstrate controlled release, failure and recovery? | Manual approval, evidence and rollback; not a claim of healthcare production |

Separation by namespace reduces lab cost and complexity but does not provide
the failure or security isolation of independent production clusters. A future
production design must revisit that trade-off.

## The short explanation

### In one sentence

> MidhHealth is a hybrid enterprise platform where application and platform
> projects remain independently owned, while GitLab, Jenkins, AWX, Kubernetes,
> observability and governance connect every reviewed change to a secure
> runtime outcome and a recoverable operating record.

### In about 30 seconds

> We designed MidhHealth around one question: how can different healthcare
> applications move safely from source code to an operated service without
> every team rebuilding the delivery and control path? GitLab is the reviewed
> source of truth, Jenkins coordinates builds and releases, AWX and Ansible own
> host configuration, Kubernetes is the shared container runtime, and the
> observability and governance layers decide whether a change is healthy and
> compliant. Twelve platform domains own different pieces, but they exchange
> versioned contracts and evidence. The active lab is on premises; AWS, Azure
> and GCP remain governed extension designs until they are approved and proven.

### In about two minutes

> I describe it as a provider-payer engineering platform, not as a collection
> of tools. A change begins in an independently owned GitLab repository. Fast
> source checks run before merge. Jenkins then selects a dedicated execution
> path for the longer build, security, packaging, promotion and verification
> work. If a host must change, Jenkins invokes an approved AWX job and Ansible
> converges that host. If a Kubernetes component or application is released,
> Helm currently owns the reviewed release until a specific resource set is
> handed to Argo CD; we avoid two reconcilers managing the same object.
>
> Under that delivery path, infrastructure, Linux, network, database and
> Kubernetes teams provide the runtime contracts. Above it, observability joins
> metrics, logs, traces, synthetic checks and release identity, while resilience
> owns incident and recovery decisions. Governance supplies identity, secret,
> policy, cost and evidence boundaries. Data engineering, healthcare AI and
> MLOps add governed information and model lifecycles without bypassing those
> controls.
>
> The practical discipline is as important as the architecture: documentation
> is not implementation, a running VM is not an installed product, and a green
> pipeline is not runtime acceptance. We preserve the exact revision, executor,
> target, health result and rollback evidence before calling a capability done.

## Worked scenario 1: release an application

A new employee can understand most of the design by following a single
application release:

1. **Register the application.** Name its repository, owner, business purpose,
   consumers, data class and target platform. The application stays a separate
   project from the platform repositories.
2. **Review the source.** GitLab protects the branch and runs quick tests,
   schema checks, policy checks and secret detection against an immutable
   revision.
3. **Build once.** Jenkins uses a dedicated agent and versioned shared-library
   logic to test and package the selected revision. Promotion reuses the same
   artifact; environments do not rebuild different bits.
4. **Prepare the target.** Terraform represents infrastructure when an approved
   target exists. AWX and Ansible own the operating-system configuration.
   Neither silently takes ownership of application or Kubernetes state.
5. **Release to the runtime.** The Kubernetes contract supplies namespace,
   identity, image, resource, network, storage, health and rollback decisions.
6. **Judge operation.** Prometheus, logs, traces and synthetic checks carry the
   service and release identity. A health gate can stop promotion, but a human
   retains authority where evidence is ambiguous or service risk is material.
7. **Recover and learn.** The service record connects the owner, dependencies,
   SLO, previous release, runbook, backup and incident evidence. Recovery is
   verified from the user and data paths—not from a successful command alone.

That path forms a closed loop: operating evidence and incidents become the
next reviewed platform or application change.

## Worked scenario 2: exchange provider or payer data

This scenario shows the intended contract flow. It does not claim a live EHR,
claims feed or data-platform product.

1. A source owner registers the business meaning, schema, delivery expectation,
   data classification and consumers.
2. Network and governance teams approve the identity and minimum path needed to
   exchange the data.
3. The data-engineering project validates an immutable synthetic fixture for
   schema, quality, freshness and duplicate behavior before any live source is
   considered.
4. A versioned ingestion or event contract records checksum, source revision,
   transform lineage, rejected records and reconciliation results.
5. Database reliability protects any stateful destination with separate
   identities, performance limits, backup and tested restoration.
6. Observability detects late, incomplete or failed delivery from the consumer
   perspective. Resilience defines replay, degradation and incident ownership.
7. A future real provider or payer feed can adopt the proven contract only
   after its data owner and privacy approval are recorded.

The architectural point is that “data arrived” is not the outcome. The result
must retain meaning, ownership, quality, privacy, lineage and replay behavior.

## Worked scenario 3: investigate a service outage

1. A synthetic check or user report establishes the failed journey; process
   health alone does not close the question.
2. The incident lead names severity, roles and the service owner, then freezes
   risky concurrent changes.
3. The team follows the path through authoritative DNS, NGINX or ingress,
   Service/endpoints, pods or VM service, storage, database and downstream
   dependencies.
4. Release identity and recent GitLab, Jenkins, AWX, Terraform, Helm or future
   GitOps changes are placed on the same timeline as metrics, logs and traces.
5. The incident lead chooses a reversible mitigation—rollback, restore,
   failover, traffic control or deliberate degradation—based on data safety and
   user impact.
6. Recovery is verified at the user path, and stateful workflows also reconcile
   data or backlog before resolution.
7. The post-incident review records contributing conditions and owned platform
   or application changes without manufacturing blame or certainty.

The lab can inject bounded versions of this scenario. Those exercises build
incident skill but remain labeled as exercises, not production history.

## Worked scenario 4: evaluate an AI workflow

1. A care, payer or platform owner states the task, user, human-review point and
   action the AI system must never take.
2. The data owner approves non-production knowledge sources and their access,
   freshness, retention and deletion rules.
3. The healthcare-AI repository versions ingestion, prompts, retrieval,
   citations and evaluation. The MLOps repository versions a trained model
   lifecycle only when a trained model is actually part of the workflow.
4. Tests cover ordinary requests, ambiguity, missing evidence, prompt
   injection, unauthorized sources, harmful output and tool misuse.
5. Delivery and governance gates bind the approved prompt, model, index and
   policy revisions to a candidate release.
6. Observability records latency, failures, retrieval and safety decisions
   without placing protected prompts or responses into telemetry.
7. Human owners accept, restrict, roll back or reject the workflow. Model output
   cannot approve its own release or a clinical/payer action.

The buildable first slice uses approved architecture documents or synthetic
data locally. It does not require a production AI endpoint or protected health
information.

## The twelve domains in plain language

| Domain | What it owns | What it hands to the next team |
| --- | --- | --- |
| [DevSecOps delivery](projects/devsecops-delivery.md) | The reviewed path from commit through build, security, artifact, approval, release and rollback | An immutable release identity and evidence manifest |
| [Multi-cloud infrastructure](projects/multi-cloud-infrastructure.md) | Terraform modules, environment roots, plan/state integrity, drift, placement, capacity and cost decisions | A named target, plan/state lineage and resource-to-service map |
| [Kubernetes platform](projects/kubernetes-platform.md) | Cluster components and the namespace, identity, image, resource, network, storage and rollout contract | Accepted desired state, runtime identity, route, health and rollback evidence |
| [Observability and SRE](projects/observability-sre.md) | Metrics, logs, traces, synthetic checks, dashboards, SLO rules and actionable alerting | Release-aware health and incident evidence |
| [Governance and operations](projects/governance-operations.md) | Identity, secrets, policy, compliance evidence, exceptions, cost decisions and bounded remediation | A control decision with scope, owner and expiry |
| [Linux systems](projects/linux-systems.md) | VM/host lifecycle, operating-system baseline, services, patching, access and recovery | A converged, observable host with job and recovery evidence |
| [Database reliability](projects/database-reliability.md) | Database identity, schema-change safety, performance, backup, restore and recovery objectives | A recoverable data-service contract |
| [Resilience operations](projects/resilience-service-operations.md) | Service ownership, readiness, incident command, recovery exercises and learning | A service decision grounded in user, dependency and data outcomes |
| [Data engineering](projects/data-engineering.md) | Ingestion, schema, quality, lineage, reconciliation, privacy, replay and data-product ownership | A versioned dataset or event contract with quality evidence |
| [Network engineering](projects/network-engineering.md) | DNS, addressing, routing, firewall, proxy, Kubernetes and hybrid connectivity paths | A tested producer-to-consumer path and reversal record |
| [Healthcare AI](projects/healthcare-ai.md) | Governed retrieval, assistants, tools, evaluation, safety and human-review boundaries | A cited, evaluated AI workflow whose limitations remain visible |
| [MLOps](projects/mlops-model-platform.md) | Reproducible data/feature/training/model identities, promotion, serving, drift and rollback | An approved model artifact and lifecycle evidence |

No domain is complete by itself. For example, Kubernetes can run a pod but
cannot decide whether its database migration is safe. Jenkins can deploy a
release but cannot define the application's SLO. Observability can detect a
symptom but does not own the service recovery decision. The handoffs prevent a
tool from quietly becoming an owner.

### Ownership across a workload lifecycle

| Lifecycle moment | Primary owner | Required platform partners |
| --- | --- | --- |
| Define business behavior | Application/product team | Architecture, data/privacy and service owner |
| Validate and package source | DevSecOps delivery | Application, security and artifact owner |
| Select placement and capacity | Multi-cloud infrastructure | Linux, network, Kubernetes, database, governance and cost owner |
| Configure a VM or host service | Linux systems through AWX | Infrastructure, network, product owner and SRE |
| Run a containerized workload | Kubernetes platform | DevSecOps, network, governance, observability and application owner |
| Provide application data | Database reliability or data engineering | Application, governance, network, resilience and data owner |
| Judge health and release risk | Application owner with Observability/SRE | DevSecOps, dependencies and resilience operations |
| Respond and recover | Resilience/incident lead with service owner | Every affected platform owner |
| Evaluate an AI/model change | Healthcare AI or MLOps plus workflow owner | Data, governance, delivery, runtime and observability |

The “primary owner” is the team that answers for the decision. Partners provide
contracts and evidence; they do not dilute accountability.

## Important architecture decisions

| Decision | Why MidhHealth chose it | Trade-off |
| --- | --- | --- |
| Separate application and platform repositories | Preserves business ownership and lets reusable platform work evolve independently | Cross-project contracts and release evidence must be explicit |
| GitLab for source gates; Jenkins for longer orchestration | Keeps review feedback close to source while centralizing credentialed multi-stage work | Two pipeline surfaces require a clear division and shared identity |
| AWX/Ansible for host state | Gives inventory limits, credential control, events, idempotence and reusable roles | Adds a control-plane dependency compared with direct SSH |
| One reconciler per Kubernetes resource | Prevents Jenkins, Helm and GitOps from fighting over desired state | Ownership handoffs must be planned component by component |
| Active on-premises lab before cloud execution | Lets the team build and test portable contracts without creating unapproved spend | Provider-specific identity, network and managed-service behavior remains unproven |
| Namespace-based lab environments | Reuses the four-node cluster and limits infrastructure sprawl | Does not reproduce production-grade environment isolation |
| Evidence-gated acceptance | Makes security, operation and recovery claims reproducible | Delivery takes longer than declaring success from a green job |
| Synthetic data first | Allows data, AI and recovery logic to be built without privacy risk | Real-source behavior and scale require later authorization and testing |

These are current decisions, not permanent truths. A change in capacity,
regulation, workload criticality, product maturity or operating evidence can
trigger a new architecture record.

## What is real today and what is still a design

### Active and evidenced foundations

- KVM/libvirt hosts and the documented Rocky Linux VM fleet.
- GitLab CE, Jenkins with a dedicated agent, AWX and the accepted AWX execution
  boundary.
- BIND DNS, NGINX paths and the four-node kubeadm cluster.
- Private ingress-nginx and worker-only Longhorn storage on the current
  Kubernetes cluster.
- Prometheus, Alertmanager, Grafana, Loki, Tempo, OpenTelemetry, MinIO and the
  Elastic Stack, with bounded metrics, fleet logging and trace/log evidence.
- PostgreSQL 18 and Vault on their documented accepted paths.

### Planned, conditional or separately unaccepted capabilities

- Harbor through the legacy shared-proxy application route; Artifactory,
  SonarQube and Splunk product operation; and Keycloak revalidation.
- Argo CD beyond its separately controlled bootstrap and ownership handoff.
- Elastic Jenkins cloud agents, managed Kubernetes and live AWS/Azure/GCP
  execution.
- A deployed data-platform product stack, model registry, feature store or AI
  serving platform.
- Production healthcare applications and protected-data AI workflows.

This distinction is part of the platform design. In an interview, say “the
architecture defines” or “the repository can validate” for planned work. Say
“the lab accepted” only when the documentation contains runtime and recovery
evidence.

## How to explain your contribution honestly

Use the level of evidence you actually have:

| Evidence level | Defensible language |
| --- | --- |
| Architecture only | “I designed the contract and the failure boundaries.” |
| Implemented in source | “I implemented and tested it in the repository with fixtures.” |
| Runtime verified | “I ran it against the bounded lab target and captured the result.” |
| Accepted | “We exercised success, failure, recovery and repeat convergence, then recorded acceptance.” |

Do not turn a lab exercise into a fictional production incident. You can still
give a strong answer: explain the realistic trigger, the architecture you
chose, the failure you injected, the signals you followed, the recovery you
proved, and what would change for a production environment.

## A useful interview answer shape

For a platform or use-case question, answer in this order:

1. **Outcome:** What user, service or operator result are we protecting?
2. **Boundary:** What does this domain own, and which teams own the handoffs?
3. **Design:** What are the main components and why are they separated?
4. **Control:** How do identity, review, secrets, policy and approvals work?
5. **Failure:** What breaks, how is blast radius limited, and who can stop it?
6. **Evidence:** Which revision, job, metric, test and recovery result prove it?
7. **Trade-off:** What simpler or faster alternative was rejected, and why?
8. **Current truth:** Is this designed, source-implemented, runtime-verified or
   accepted in the lab?

This sounds more natural than reciting a tool list because it follows the way
engineers make and defend decisions.

## Example: explaining a Kubernetes application release

> The goal is not merely to apply YAML; it is to release one reviewed artifact
> through a path we can observe and reverse. GitLab owns source review, Jenkins
> selects the immutable revision and invokes the release workflow, and Helm is
> the current release owner for that component. AWX configures only host
> prerequisites. The Kubernetes team supplies the namespace, service account,
> image, resources, route, storage and probes. We verify the external DNS and
> ingress path, rollout, telemetry and negative port exposure, then exercise a
> rollback to the previous digest. The main trade-off is that this creates more
> evidence than a direct `kubectl apply`, but it prevents hidden state and makes
> recovery attributable. In the current lab, the cluster, ingress and Longhorn
> foundations are accepted; an application release remains documentation until
> its own runtime evidence is completed.

## Where to go next

- Start with the [platform domain index](projects/README.md), then read the page
  for the domain you will own.
- Use the [enterprise portfolio](enterprise-project-portfolio-and-usecases.md)
  to see why that domain exists and which use cases it owns.
- Use the [use-case interview question bank](use-case-interview-question-bank.md)
  to practice architecture, implementation, troubleshooting and evidence
  conversations.
- Verify claims in [Current Environment State](current-environment-state.md)
  and [Use-Case Implementation Status](use-case-implementation-status.md).
- Before implementing anything, read the selected detailed use-case page and
  its dependency handoffs, planned source locations, stories and acceptance
  decision.

## A new employee's first-week tour

### Day 1: learn the company and boundaries

Read this reference architecture, the application register and current-state
page. Be able to explain the provider, payer and platform relationship and say
which capability areas do not yet have real application projects.

### Day 2: follow source to execution

Choose a small repository change. Locate its GitLab validation, Jenkins job or
Job DSL, shared-library call, agent label, credential class and evidence. Do not
run a mutation merely to complete the tour.

### Day 3: follow a request to the runtime

Trace one documented endpoint from authoritative DNS through NGINX or ingress
to the service. Then locate the VM or Kubernetes owner, storage dependency and
negative exposure checks.

### Day 4: follow signals back to ownership

Find the relevant Prometheus target, Grafana view, log path and trace path.
Ask what release and owner labels exist, what is still missing, and which alert
would lead to an actionable runbook.

### Day 5: defend one use case

Select a question from the use-case bank. Explain the outcome, ownership,
design, current boundary, failure modes, recovery and acceptance evidence.
Finish by identifying the smallest next implementation slice that uses existing
infrastructure.
