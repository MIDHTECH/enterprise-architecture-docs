# Consultant Training Standard

Use this standard for every enterprise platform project. A consultant should be able to explain the project clearly, defend the architecture, describe their contribution, and answer practical interview questions from multiple angles.

## Required Project Training Sections

Every project must have these training sections:

1. **Project Summary**
   - What the project does.
   - Which enterprise problem it solves.
   - Where it fits in the larger MAAS Enterprise Cloud Platform program.

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
   - Example: cloud architect, DevOps engineer, platform engineer, SRE, security engineer, QA engineer, release manager, compliance analyst.

7. **My Contribution**
   - What the consultant personally designed, built, automated, documented, tested, validated, or improved.
   - This section must be specific enough to answer interview follow-up questions.

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

## Required Interview Question Bank

Every project must include a project-specific interview question bank with these categories:

| Category | Required count | Purpose |
| --- | ---: | --- |
| Architecture questions | 10 | Tests whether the consultant can explain components, flow, integrations, and enterprise fit |
| System design questions | 10 | Tests design decisions, scalability, security, reliability, and tradeoffs |
| Behavioral questions | 10 | Tests communication, ownership, collaboration, conflict handling, and client-facing maturity |
| Troubleshooting questions | 10 | Tests practical debugging, incident response, logs, rollback, and root cause thinking |
| Scenario-based questions | 10 | Tests how the consultant handles realistic client situations |

This creates **50 project-specific interview questions per project**.

If a shorter mock interview is needed, choose 30 questions from the full bank:

- 6 architecture questions
- 6 system design questions
- 6 behavioral questions
- 6 troubleshooting questions
- 6 scenario-based questions

## Standard Interview Answer Format

Use this format for every answer:

> The client had [problem]. Our team built [solution] using [tools]. I contributed by [specific work]. We followed enterprise controls like [GitLab, merge requests, CI/CD gates, security scans, approvals, and runbooks]. The outcome was [business value].

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
- Consultant talk track.
- Team model.
- Tool explanation.
- Enterprise controls explanation.
- Business outcome explanation.
- 50-question interview bank, or a documented 30-question mock interview subset.
