# Engineering Documentation Standard

Observability documentation must compare the Prometheus/Grafana/Loki/Tempo path,
the three-node Elastic Stack, and the standalone Splunk exercise. Learners
must distinguish VM provisioning from product installation and use the
incident register whenever source-of-truth drift is discovered.

Use this standard for every enterprise platform project. The portfolio contains
ten capability projects. Projects 6–10 are active first implementation slices
for Linux systems, database reliability, resilience/service operations, data
engineering, and network engineering. An engineer should be
able to explain the project clearly, defend the architecture, describe
repository ownership, and answer practical operating questions from multiple
angles.

Never present a first-slice repository as a completed product deployment.
Documentation must distinguish evidence automation from repository, VM,
product, and operational acceptance.

The expected voice is a senior DevOps, cloud, platform, or SRE engineer with
6-8 years of hands-on experience. Documentation should sound like the team has
owned production delivery, made tradeoffs, worked with cross-functional teams,
supported audits, handled incidents, and improved reliability, security, and
automation outcomes. Avoid entry-level or academic phrasing. Use language that
shows practical ownership, decision-making, risk awareness, and measurable
business impact.

## Required Project Documentation Sections

Every project must have these sections:

1. **Project Summary**
   - What the project does.
   - Which enterprise problem it solves.
   - Where it fits in the larger enterprise platform portfolio.

2. **Client Problem**
   - What was manual, slow, risky, inconsistent, insecure, or hard to operate before the project.

3. **Business Goal**
   - What the client wanted to improve, such as delivery speed, governance, reliability, standardization, auditability, cost control, or operational efficiency.

4. **Architecture**
   - Main components.
   - Data/control flow.
   - Integration points with GitLab, Jenkins, AWX, Terraform, Ansible, Kubernetes, observability, or governance tooling.
   - Environment model for dev, QA, stage, and production where applicable.

5. **System Design**
   - Why the repository is structured this way.
   - How the design supports scale, reuse, automation, security, and team ownership.
   - What tradeoffs were made.

6. **Team Model**
   - Roles involved in delivery.
   - Example: cloud architect, DevOps engineer, platform engineer, SRE,
     database reliability engineer, Linux systems engineer, data engineer,
     network engineer, security engineer, QA engineer, release manager, and
     compliance analyst.

7. **Repository Responsibilities**
   - What the repository designs, implements, automates, documents, tests, validates, or improves.
   - This section must be specific enough to support review and operational handoff.
   - Write this in a senior engineer voice: explain the decision, the implementation, the control used, and the operational outcome.

8. **Tools and Technologies**
   - Tools used.
   - Why each tool was selected.
   - How the tools integrate with each other.

9. **Enterprise Controls**
   - GitLab source control.
   - Merge requests and approvals.
   - Protected branches.
   - CI/CD validation.
   - Security scanning.
   - Deployment evidence.
   - Runbooks and operational documentation.

10. **Business Outcome**
    - What improved for the client.
    - Examples: faster provisioning, safer releases, lower MTTR, stronger compliance, better audit evidence, reduced manual work, reduced configuration drift.

## Required Engineering Question Bank

Every project must include a project-specific engineering question bank with
these categories:

| Category | Required count | Purpose |
| --- | ---: | --- |
| Skill, tool, and project questions | 30 | Tests practical knowledge of the tools, repo, workflow, and repository responsibilities |
| Architecture questions | 10 | Tests whether the engineer can explain components, flow, integrations, and enterprise fit |
| System design questions | 10 | Tests design decisions, scalability, security, reliability, and tradeoffs |
| Behavioral questions | 10 | Tests communication, ownership, collaboration, conflict handling, and client-facing maturity |
| Troubleshooting questions | 10 | Tests practical debugging, incident response, logs, rollback, and root cause thinking |
| Scenario-based questions | 10 | Tests how the engineer handles realistic client situations |

This creates **80 project-specific engineering questions per project**.

The first 30 questions should be based on the project's skills, tools,
implementation, and repository responsibilities. The remaining 50 questions are
grouped into the five operating categories.

## Standard Operating Answer Format

Use this format for every answer:

> The platform had [problem]. The team built [solution] using [tools]. The repository owns [specific work]. Enterprise controls include [GitLab, merge requests, CI/CD gates, security scans, approvals, and runbooks]. The outcome was [business value].

For a senior engineer answer, add the tradeoff or operational control behind the decision:

> I chose [approach] because [reason]. I considered [tradeoff/risk], controlled it with [guardrail], and validated the result through [test, metric, evidence, or runbook].

## Required Question Types

### Architecture Questions

Architecture questions should test:

- How components connect.
- Why the design is split across repositories.
- How GitLab, Jenkins, AWX, Terraform, Ansible, Kubernetes, observability, and governance fit together.
- How environments are separated.
- Where security and approval controls are enforced.

### System Design Questions

System design questions should test:

- Scalability.
- Reusability.
- Reliability.
- Security.
- Failure handling.
- Repository structure.
- Pipeline structure.
- Deployment strategy.
- Auditability.
- Operational ownership.

### Behavioral Questions

Behavioral questions should test:

- Ownership.
- Team collaboration.
- Explaining technical work to non-technical stakeholders.
- Handling production pressure.
- Handling disagreements.
- Learning a new tool.
- Supporting junior team members.
- Working with security/compliance teams.
- Client communication.
- Prioritization.

### Troubleshooting Questions

Troubleshooting questions should test:

- How to debug failed pipelines.
- How to investigate failed Terraform plans or applies.
- How to troubleshoot AWX/Ansible failures.
- How to debug Kubernetes deployment issues.
- How to read logs, metrics, traces, and alerts.
- How to isolate IAM, networking, certificate, DNS, or secret issues.
- How to roll back safely.
- How to collect evidence for RCA.

### Scenario-Based Questions

Scenario questions should test:

- What to do when a client asks for faster delivery but security controls fail.
- What to do when production deployment fails.
- What to do when Terraform drift is detected.
- What to do when Kubernetes pods are crashing.
- What to do when alerts are noisy.
- What to do when audit evidence is missing.
- What to do when teams disagree about ownership.
- What to do when a cost spike appears.
- What to do when secrets are exposed.
- What to do when a client asks how the platform scales.

## Project Completion Standard

A project is training-ready only when it has:

- Project-local documentation.
- Architecture explanation.
- Role and contribution mapping.
- Plain-spoken interview explanation.
- Team model.
- Tool explanation.
- Enterprise controls explanation.
- Business outcome explanation.
- 80-question interview bank with 30 skill/tool/project questions and 10 questions each for architecture, system design, behavioral, troubleshooting, and scenario-based categories.

For a planned project, “training-ready” means its architecture and question
bank are ready for design review. It does not mean the implementation is
complete.
