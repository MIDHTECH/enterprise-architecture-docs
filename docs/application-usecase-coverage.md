# Application-to-Use-Case Coverage

Last verified: 2026-08-13

## Why this register exists

The enterprise portfolio contains 226 detailed use cases. They collectively
describe the shared platforms, but it would be misleading to attach every use
case directly to every application. A stateless Kubernetes service should not
pretend to own database failover, a Linux host baseline, a healthcare data
pipeline, or model rollback.

This register gives every use case a deliberate place for each real
application:

- **Required** means the application record directly depends on that detailed
  page and names the platform contract owner.
- **Platform-managed or conditional** means the capability remains available
  through the shared platform, but direct application adoption depends on a
  later characteristic or design decision.
- **Platform-managed** means the application consumes an existing platform
  outcome but does not own that platform lifecycle use case.
- **Not applicable to the current application** means a verified application
  characteristic makes the use case irrelevant today. It does not remove the
  use case from the enterprise portfolio.

The machine-readable rules live in
[`application-usecase-applicability.json`](application-usecase-applicability.json).
The 31 directly required pages come from the six owned contracts in
[`application-integration-contracts.json`](application-integration-contracts.json).

## Podinfo coverage

Podinfo is the only registered real application. Its documented slice is a
stateless, non-PHI Kubernetes reference workload with no business-data or
model responsibilities. Those facts—not a desire to maximize green checks—set
its applicability.

| Platform domain | Portfolio pages | Directly required | Remaining classification | Architectural reason |
| --- | ---: | ---: | --- | --- |
| DevSecOps delivery | 16 | 8 | 8 platform-managed or conditional | The application needs the core build, quality, artifact, promotion, security and rollback path; cross-project compatibility becomes directly required only after another real application contract is registered. |
| Multi-cloud infrastructure | 12 | 0 | 12 platform-managed | Podinfo is documented against an existing target and owns no infrastructure provisioning. |
| Kubernetes | 13 | 5 | 8 platform-managed or conditional | Workload deployment, security, ingress, sizing and image supply chain apply directly; cluster lifecycle stays with the platform. |
| Observability and SRE | 16 | 5 | 11 platform-managed or conditional | Release-correlated signals, logs, alerts and health apply; broader practices depend on future criticality. |
| Governance and operations | 19 | 3 | 16 platform-managed or conditional | Secrets, application identity and RBAC apply; other controls depend on later risk and data scope. |
| Linux systems | 24 | 0 | 24 not applicable to the current application | The application does not own a VM or native service; the Kubernetes platform still owns its Linux foundation. |
| Database reliability | 19 | 0 | 19 not applicable to the current application | The documented slice is stateless. |
| Resilience and service operations | 21 | 6 | 15 platform-managed or conditional | Readiness, SLO intent, escalation, ownership, dependency mapping and secret-expiry response apply directly; dependency containment becomes required when a real critical edge is registered. |
| Data engineering and integration | 25 | 0 | 25 not applicable to the current application | No provider, payer or analytical business data crosses the Podinfo boundary. |
| Network engineering | 31 | 4 | 27 platform-managed or conditional | DNS, ingress/egress, TLS routing and availability testing apply; broader network lifecycle stays platform-owned. |
| Healthcare AI | 15 | 0 | 15 not applicable to the current application | No clinical knowledge or AI-assisted behavior exists in scope. |
| MLOps | 15 | 0 | 15 not applicable to the current application | No model artifact or serving lifecycle exists in scope. |
| **Total** | **226** | **31** | **195 classified by application-domain rules** | Every detailed page is accounted for without making irrelevant use cases mandatory. |

## The 31 direct requirements

The six application-to-platform contracts are the readable grouping:

| Contract chain | Required pages | Why Podinfo needs them |
| --- | ---: | --- |
| Delivery spine | 8 | Preserve source, build, test, quality, artifact, promotion, security and rollback meaning. |
| Identity and secrets | 4 | Bound application and delivery identities and retain rotation and expiry ownership. |
| Network and service access | 4 | Define DNS, ingress/egress, TLS and positive/denied-path expectations. |
| Operational readiness | 5 | Name service ownership, dependencies, SLO intent, readiness and escalation. |
| Telemetry and release feedback | 5 | Connect logs, traces, alerts and health decisions to the future release identity. |
| Kubernetes workload | 5 | Describe the workload, pod security, ingress, resource and image-supply-chain boundaries. |

The exact page paths are stored once in the integration-contract manifest and
validated against the filesystem. This avoids a second hand-maintained list
silently drifting from the application record.

## How future applications are classified

When a real care or payer application is registered, its owner first records
facts: runtime style, statefulness, data producer/consumer role, protected-data
scope, AI/model use and operational criticality. Those characteristics turn
conditional chains on or off. The team then selects exact detailed pages and
records why each is required.

For example, an actual stateful application would evaluate the Stateful
Application chain; an application publishing healthcare events would evaluate
the Data-Producing or Consuming chain; a model-enabled workflow would evaluate
both Healthcare AI and MLOps chains. Those are rules for future documentation,
not invented claims about applications that have not been named.

## Scope boundary

This coverage is complete as documentation classification. It does not mean
31 use cases are implemented or that 195 use cases were executed elsewhere.
Podinfo remains not deployed, runtime evidence is not collected, and the care
and payer portfolio classification remains deferred until real application
projects and owners are registered.
