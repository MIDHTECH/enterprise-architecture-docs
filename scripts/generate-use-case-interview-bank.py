#!/usr/bin/env python3
"""Generate the interview index from canonical detailed use-case documents."""

from pathlib import Path
import re


ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / "docs/use-case-interview-question-bank.md"

DOMAINS = {
    "devsecops": {
        "name": "DevSecOps Delivery",
        "page": "projects/devsecops-delivery.md",
        "opening": [
            "Explain why GitLab, Jenkins, AWX and the runtime have separate responsibilities in this delivery platform.",
            "How would you onboard a new application without copying pipeline logic or giving its build excessive credentials?",
            "A release is fast but difficult to reproduce or roll back. Which platform contract is missing?",
        ],
        "questions": [
            "Where does {title} sit in the path from reviewed source to release decision, and which condition must stop the flow?",
            "How would you implement {title} across several repositories without turning Jenkins into hand-maintained configuration?",
            "Which failure modes in {title} could create a false pass or an unsafe release, and how would you contain them?",
            "What evidence would convince you that {title} protects release speed rather than merely adding another green stage?",
        ],
        "probes": [
            "Separate GitLab, Jenkins, AWX and runtime ownership; name the immutable revision and rollback point.",
            "Discuss Job DSL, shared libraries, agent isolation, credential scope and repository-owned configuration.",
            "Discuss fail-closed behavior, retry boundaries, artifact identity, credential exposure and the previous known-good release.",
            "Ask for a deliberate failure, queue/build timing, policy result, artifact digest and post-release health signal.",
        ],
    },
    "infrastructure": {
        "name": "Multi-Cloud Infrastructure",
        "page": "projects/multi-cloud-infrastructure.md",
        "opening": [
            "How do reusable Terraform modules, environment roots and remote state boundaries fit together?",
            "How would you compare on-premises, AWS, Azure and GCP placement without pretending the providers are identical?",
            "What makes an infrastructure plan safe enough for a human to approve?",
        ],
        "questions": [
            "Where does {title} fit between reusable modules, environment ownership, state and post-provision configuration?",
            "What is the smallest buildable lab slice for {title}, and what remains conditional on an unavailable target or product?",
            "If {title} leaves unexpected or partial state, how do you decide whether to repair, reconcile or stop?",
            "Which plan, state and service-impact evidence must accompany {title} before and after mutation?",
        ],
        "probes": [
            "Cover typed module interfaces, environment roots, backend identity, locking and short-lived execution identity.",
            "Use contracts, fixtures and plan parsing first; do not claim a cloud resource from a local test.",
            "Preserve state lineage, identify the active owner and avoid automatic reconciliation of unexplained differences.",
            "Include module/provider versions, saved-plan digest, policy/cost result, approvals, state serial and health verification.",
        ],
    },
    "kubernetes": {
        "name": "Kubernetes Platform",
        "page": "projects/kubernetes-platform.md",
        "opening": [
            "Describe the namespace and workload contract an application must satisfy before it can run on the shared cluster.",
            "How do Jenkins, Helm and Argo CD avoid becoming competing reconcilers?",
            "A Kubernetes application is unavailable. How do you troubleshoot from the user path inward?",
        ],
        "questions": [
            "Where does {title} fit in the workload or cluster contract, and who owns each side of that boundary?",
            "What is the first safe implementation slice for {title} on the existing four-node cluster without assuming a managed-cloud feature or uninstalled add-on?",
            "The evidence for {title} disagrees with desired state or user experience. Which cluster, path and dependency checks come next?",
            "What success, negative, drift and rollback evidence would you require before accepting {title}?",
        ],
        "probes": [
            "Name namespace, identity, image, resources, network, storage, telemetry and recovery ownership.",
            "Keep the kubeadm, private ingress and Longhorn boundaries explicit; defer AKS/EKS/GKE claims.",
            "Walk DNS, NGINX/ingress, Service, endpoints, pods, nodes, storage and downstream services.",
            "Tie desired-state and image digests to policy, route, rollout, health, exposure and recovery results.",
        ],
    },
    "observability": {
        "name": "Observability and SRE",
        "page": "projects/observability-sre.md",
        "opening": [
            "How do metrics, logs, traces, synthetic checks and release markers become one investigation path?",
            "What information must every application add before a dashboard or alert can be considered owned?",
            "How do you distinguish no telemetry from a healthy service?",
        ],
        "questions": [
            "For {title}, what user or operator decision should the signal support, and how would you keep it release-aware?",
            "How would you build {title} using the existing Prometheus, Grafana, Loki, Tempo, OpenTelemetry and Elastic paths?",
            "{title} becomes noisy, incomplete or contradictory during an incident. How do you protect the telemetry platform and continue diagnosis?",
            "Which query, injected condition, route and recovery evidence would prove {title} is actionable?",
        ],
        "probes": [
            "Require service, environment, owner and artifact/release identity; avoid patient/member data in labels.",
            "Start with fixture-validated configuration and one bounded service pack rather than adding another backend.",
            "Discuss missing coverage, cardinality, sampling, clock alignment, alert grouping and direct source queries.",
            "Ask for source revision, time window, expected/observed result, negative privacy check and rollback.",
        ],
    },
    "governance": {
        "name": "Governance and Operations Automation",
        "page": "projects/governance-operations.md",
        "opening": [
            "How does this platform turn policy intent into an executable control without removing human accountability?",
            "Explain the separation between detection, approval, remediation and acceptance evidence.",
            "When should a governance gate fail closed, and how are time-bound exceptions handled?",
        ],
        "questions": [
            "How would you design {title} so its scope, identity, owner, observation and decision remain auditable?",
            "What can be implemented for {title} with fixtures and read-only checks before any live enforcement is approved?",
            "Automation for {title} has partial coverage or begins harming service health. What stops it, and who takes control?",
            "Which positive, negative, inaccessible-scope and expiry tests would you use to accept {title}?",
        ],
        "probes": [
            "Name the control intent, assets, principals, allowed actions, policy version, evidence and retention owner.",
            "Use schemas, mocked APIs and deterministic policy results; distinguish detection from enforcement.",
            "Require a stop condition, preserve action history and return authority to the service or incident owner.",
            "Do not turn unobserved scope into compliance; include exception and recovery behavior.",
        ],
    },
    "linux": {
        "name": "Linux Systems Engineering",
        "page": "projects/linux-systems.md",
        "opening": [
            "Where does Linux platform ownership begin and end between infrastructure, network, Kubernetes and product teams?",
            "What does a safe Jenkins-to-AWX-to-Ansible change look like across a VM fleet?",
            "How do check mode, canaries, serial rollout and idempotence support different decisions?",
        ],
        "questions": [
            "Walk through {title} as a controlled fleet change. What is inspected, changed, verified and handed back to the service owner?",
            "How would you implement {title} in Ansible and AWX without hiding unsafe shell behavior or widening the inventory scope?",
            "During {title}, the canary becomes unreachable or unhealthy. How do you stop the rollout and recover the host or service?",
            "What host-by-host, security, idempotence and recovery evidence would make {title} defensible?",
        ],
        "probes": [
            "Separate provisioned compute, OS desired state and application ownership; name the inventory limit.",
            "Discuss roles, playbook composition, strict Bash behavior, structured results, credentials and check output.",
            "Use console or break-glass paths where necessary and preserve the failed task, journal and before-state.",
            "Include Git revision, Jenkins/AWX IDs, canary, second convergence, service telemetry and reversal.",
        ],
    },
    "database": {
        "name": "Database Reliability",
        "page": "projects/database-reliability.md",
        "opening": [
            "What must an application provide before it receives a database and runtime role?",
            "How do migration identity, application release identity and backup/restore evidence remain connected?",
            "Why are a successful backup job and a running PostgreSQL process insufficient reliability evidence?",
        ],
        "questions": [
            "Design {title} as a database service contract. Which decisions belong to the application, database, security and SRE owners?",
            "How would you implement {title} against the existing PostgreSQL path using synthetic data and bounded AWX automation?",
            "{title} fails while clients or data are in a mixed state. How do you protect correctness and select recovery?",
            "Which compatibility, performance, security and restore evidence would you require for {title}?",
        ],
        "probes": [
            "Cover schema/database isolation, migration/runtime roles, connection budget, data class and RPO/RTO ownership.",
            "Use source-managed SQL/playbooks, explicit grants, synthetic markers and application-level verification.",
            "Discuss locks, transactions, expand-contract, connection pressure, write safety and previous valid credentials/data.",
            "A job exit code is not enough; require queried restored content, timing, telemetry and consumer verification.",
        ],
    },
    "resilience": {
        "name": "Resilience and Service Operations",
        "page": "projects/resilience-service-operations.md",
        "opening": [
            "What belongs in a service-readiness record before an incident occurs?",
            "How do incident command, technical diagnosis and recovery authority differ?",
            "How can the lab teach production incident skills without inventing production experience?",
        ],
        "questions": [
            "How does {title} improve service readiness, and what operating information or handoffs must exist first?",
            "Which part of {title} can be exercised safely in the shared lab, and what operational learning should it produce?",
            "While applying {title}, telemetry and recent-change evidence point in different directions. How does the team decide what to do next?",
            "What user-path, data, timing, role and recovery evidence would make {title} complete?",
        ],
        "probes": [
            "Name owner, dependencies, SLO, on-call, previous release, runbook, backup and decision authority.",
            "Define injection, blast radius, expected detection, stop condition and restoration before starting.",
            "Keep hypotheses explicit, protect data and prefer reversible mitigation over confident guessing.",
            "Measure from honest start/stop points and distinguish command success from service recovery.",
        ],
    },
    "data": {
        "name": "Data Engineering and Integration",
        "page": "projects/data-engineering.md",
        "opening": [
            "What turns a moved file or completed job into a trusted data product?",
            "How do schema, quality, lineage, privacy and replay contracts travel together?",
            "What can the current lab prove before a data-platform product stack is selected?",
        ],
        "questions": [
            "For {title}, define the producer, consumer and data-product contract before choosing a tool.",
            "How would you build the first testable slice of {title} with schemas and synthetic fixtures in the current lab?",
            "{title} produces late, duplicated, malformed or partially transformed data. How do you contain and replay it safely?",
            "Which quality, lineage, reconciliation, privacy and recovery evidence would prove {title}?",
        ],
        "probes": [
            "Cover meaning, ownership, schema compatibility, delivery expectation, classification and failure behavior.",
            "Use repository validation and approved existing interfaces; do not imply Airflow, Kafka or a lakehouse is installed.",
            "Discuss quarantine, watermarks, idempotency, dead-letter ownership, backfill bounds and consumer impact.",
            "Require source checksum, code/schema revisions, counts, rejected records, lineage and replay result.",
        ],
    },
    "network": {
        "name": "Network Engineering and Automation",
        "page": "projects/network-engineering.md",
        "opening": [
            "How do you describe a service path from the consumer through DNS, routing, firewall and proxy to the workload?",
            "Why are a local listener and a successful ping not proof that an application is reachable?",
            "How do network, Linux, infrastructure and Kubernetes teams avoid conflicting ownership?",
        ],
        "questions": [
            "Design {title} as a producer-to-consumer connectivity contract. What must be named before configuration changes?",
            "How would you implement and canary {title} using the current BIND, NGINX, KVM and Kubernetes boundaries?",
            "Users report failure during {title}, but one local test passes. How do you isolate DNS, route, firewall, TLS, proxy and workload layers?",
            "Which source, path, negative and rollback evidence would you require to accept {title}?",
        ],
        "probes": [
            "Name source, destination, purpose, protocol/port, ownership, trust boundary and removal condition.",
            "Use inventory-driven configuration, pre/post tests and AWX limits; do not assume a cloud/VPN/MetalLB product exists.",
            "Test from the affected source and preserve TTL, SNI, session, MTU and asymmetry evidence where relevant.",
            "Include configuration diff, AWX ID, DNS serial, consumer test, prohibited-path test and restored prior state.",
        ],
    },
    "healthcare-ai": {
        "name": "Healthcare AI",
        "page": "projects/healthcare-ai.md",
        "opening": [
            "How do you decide whether a healthcare workflow should use AI at all?",
            "Where must human review remain when retrieval, model output or tool use is uncertain?",
            "How do access control and citations travel through a RAG request?",
        ],
        "questions": [
            "A care or payer team proposes {title}. What workflow outcome, prohibited action and human-review point would you define first?",
            "What is a safe, buildable first slice for {title} using approved documents or synthetic data?",
            "During {title}, retrieval is stale, access is uncertain or the model response is persuasive but unsupported. What should happen?",
            "Which data, prompt, model, evaluation, citation, denial and rollback evidence would you require for {title}?",
        ],
        "probes": [
            "Separate decision support from clinical/payer authority and name the accountable workflow owner.",
            "Begin read-only, pin every input and keep protected data out until separately authorized.",
            "Fail safely, expose limitations, block unauthorized sources/tools and avoid logging sensitive content.",
            "Test ordinary, ambiguous, missing-source, injection, unauthorized and harmful cases by failure category.",
        ],
    },
    "mlops": {
        "name": "MLOps Model Platform",
        "page": "projects/mlops-model-platform.md",
        "opening": [
            "Which identities must be preserved to reproduce a model from data through serving?",
            "How do experiment tracking, a registry and release promotion serve different purposes?",
            "Why does drift not automatically mean model accuracy has fallen?",
        ],
        "questions": [
            "For {title}, which dataset, feature, code, environment, model and approval identities must remain linked?",
            "How would you prove a local first slice of {title} before a registry, feature store or serving platform is installed?",
            "{title} fails or regresses after promotion. How do you distinguish service health, data drift and model-quality problems?",
            "What reproducibility, slice, security, serving and rollback evidence would make {title} promotable?",
        ],
        "probes": [
            "Include snapshot/schema, transformations, parameters/seed, artifact digest, evaluation and serving-image compatibility.",
            "Use synthetic data, manifests, local artifacts and deterministic tests without naming an uninstalled product as live.",
            "Separate latency/errors from distribution change and ground-truth performance; automatic retraining is not promotion.",
            "Require adverse cases, baseline comparison, lineage, owner decision and prior model/image restoration.",
        ],
    },
}


def clean(value: str) -> str:
    return value.replace("|", "\\|").replace("\n", " ").strip()


def collect(domain: str):
    documents = sorted((ROOT / "docs/use-cases" / domain).glob("UC-*.md"))
    records = []
    for document in documents:
        first_line = document.read_text().splitlines()[0]
        match = re.fullmatch(r"# (UC-[A-Z0-9]+-\d{3}): (.+)", first_line)
        if not match:
            raise SystemExit(f"{document}: unexpected title {first_line!r}")
        records.append((match.group(1), match.group(2), document))
    return sorted(records, key=lambda item: int(item[0].rsplit("-", 1)[1]))


parts = [
    "# MidhHealth Use-Case Interview Question Bank",
    "",
    "Last generated from the canonical detailed pages: 2026-08-13",
    "",
    "## How to use this bank",
    "",
    "This bank is organized by platform and covers every detailed use case exactly once.",
    "The opening questions test whether someone understands the platform boundary; the",
    "use-case questions test whether they can turn that architecture into a safe, buildable",
    "and supportable capability.",
    "",
    "These are conversations, not trivia. A strong answer should name the outcome, owner,",
    "architecture, current lab boundary, security controls, failure behavior, recovery and",
    "evidence. When runtime evidence does not exist, the candidate should say what is designed",
    "or source-testable instead of inventing production experience.",
    "",
    "Use the companion [new-employee platform briefing](new-employee-platform-briefing.md)",
    "for the common architecture story.",
    "",
    "## Follow-up ladder for any question",
    "",
    "1. What user or operating outcome are you protecting?",
    "2. Which platform owns the decision, and what does it consume or emit?",
    "3. What would you implement first in the existing lab?",
    "4. What identity, secret, review and policy boundaries apply?",
    "5. What is the most dangerous plausible failure, and what stops the blast radius?",
    "6. Which negative test, runtime signal and recovery exercise would prove the design?",
    "7. What is the trade-off, and what evidence would cause you to revisit it?",
    "8. Is the answer architecture, source implementation, runtime verification or accepted evidence?",
    "",
    "## Interviewer scoring guide",
    "",
    "| Signal | Weak answer | Strong answer |",
    "| --- | --- | --- |",
    "| Ownership | Lists tools | Separates accountable owner, platform owner and consuming teams |",
    "| Architecture | Draws boxes only | Explains control/data flow, trust boundaries and handoffs |",
    "| Implementation | Says ‘automate it’ | Names source locations, stages, identities and current lab target |",
    "| Reliability | Restarts or retries first | Defines failure modes, stop conditions, rollback and data safety |",
    "| Evidence | Relies on a green job or screenshot | Binds revision, execution, target, result, negative test and recovery |",
    "| Honesty | Presents planned work as production experience | Clearly distinguishes design, source, runtime and acceptance |",
    "",
]

total = 0
for domain, config in DOMAINS.items():
    records = collect(domain)
    total += len(records)
    parts.extend([
        f"## {config['name']}",
        "",
        f"Platform detail: [{config['name']}]({config['page']})",
        "",
        "### Platform questions",
        "",
    ])
    parts.extend(f"- {question}" for question in config["opening"])
    parts.extend([
        "",
        "### Questions tied to detailed use cases",
        "",
        "| Use case | Primary question | Interviewer probe |",
        "| --- | --- | --- |",
    ])
    for index, (use_case_id, title, document) in enumerate(records):
        variant = index % len(config["questions"])
        question = config["questions"][variant].format(title=title)
        probe = config["probes"][variant]
        link = document.relative_to(ROOT / "docs").as_posix()
        parts.append(
            f"| [{use_case_id}: {clean(title)}]({link}) | {clean(question)} | {clean(probe)} |"
        )
    parts.append("")

parts.extend([
    "## Coverage statement",
    "",
    f"This generated bank contains one traceable primary question for all **{total}** detailed",
    "use cases, grouped under all twelve owning platforms. The universal follow-up ladder",
    "turns each primary question into architecture, implementation, security, troubleshooting,",
    "recovery and evidence probes without copying a generic block into every use-case page.",
    "",
    "When a use case is added, renamed or removed, regenerate this document with",
    "`./scripts/generate-use-case-interview-bank.py` and run the local validation suite.",
    "",
])

OUTPUT.write_text("\n".join(parts))
print(f"Generated {OUTPUT.relative_to(ROOT)} with {total} use-case questions.")
