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
