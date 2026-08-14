# Enterprise Design Readiness Status

Last reviewed: 2026-08-13

## Goal and boundary

The current program phase is **architecture and implementation design**. The
goal is to finish a coherent, buildable design before starting additional lab
implementation. Documentation changes may define contracts, planned source
paths, acceptance evidence and recovery behavior; they do not authorize a
deployment, product installation, cloud resource or application runtime.

The machine-readable environment truth is
[`environment-capability-status.json`](environment-capability-status.json).
Narrative pages must agree with that file and with
[Current Environment State](current-environment-state.md). When an accepted
lab fact changes, update the manifest and the current-state record in the same
documentation change before changing platform or use-case designs.

## Design readiness by scope

| Scope | Design state | What is complete | What still prevents closure |
| --- | --- | --- | --- |
| Enterprise operating model | Ready | MidhHealth provider, payer, platform and governance responsibilities share one delivery and evidence model | No design blocker |
| Twelve platform domains | Ready | Each platform has context, ownership, detailed architecture, failure behavior, implementation guidance and acceptance intent | Runtime acceptance remains a later phase |
| 226 platform use cases | Ready for implementation planning | Every canonical use case has a detailed page, linked dependencies, an SVG, trust boundaries, planned source locations, failure handling and future evidence | Page readiness is not implementation or acceptance |
| Current-versus-target platform truth | Ready | Accepted, partial, uninstalled, provisioned-only and target-only states have one vocabulary and canonical manifest | The manifest must be updated whenever lab evidence changes |
| Application onboarding framework | Ready | Application records, reusable platform chains, applicability rules and future evidence requirements are defined | No implementation authorization |
| Real provider application design | Blocked on inventory | The architecture reserves a care-delivery portfolio and defines its registration contract | Real application name, repository, owner, users, data class and interfaces are not supplied |
| Real payer application design | Blocked on inventory | The architecture reserves a payer portfolio and defines its registration contract | Real application name, repository, owner, users, data class and interfaces are not supplied |
| Cross-application integration design | Blocked on real applications | Producer, consumer, versioning, failure and evidence fields are defined | No real application-to-application contract can be designed without inventing projects |

The three application rows are honest design blockers, not missing platform
use cases. Closing them requires real organizational inventory. Placeholder
clinical, claims or member-service projects must not be created simply to make
the architecture appear complete.

## Design-complete gate for a use case

A detailed use case may be handed to an implementation repository only when a
reviewer can answer all of the following from the page:

1. Which MidhHealth outcome and accountable platform own the capability?
2. What accepted existing boundary can the first slice use, and which products
   or targets are explicitly unavailable?
3. Which upstream artifacts and downstream consumers form the contract?
4. What identity crosses each trust boundary, and who owns issuance,
   rotation, revocation and emergency access?
5. What exact repository paths will hold contract, code, schema, fixtures, CI
   and runbook content?
6. What positive, negative, malformed, unauthorized and dependency-failure
   behaviors must be tested before target access?
7. What stops mutation, limits blast radius and returns to the previous safe
   state?
8. What evidence distinguishes source validation, implemented code, runtime
   verification and owner acceptance?
9. Which decisions remain open, who owns them and what gate resolves them?
10. Does the narrative describe this capability specifically rather than only
    repeating the portfolio template?

## Gate before additional lab implementation

Before work moves from design to lab implementation:

1. the selected use case passes the design-complete gate above;
2. its current and target dependencies agree with the canonical capability
   manifest;
3. the intended repository exists and the planned paths are reviewed with its
   owner;
4. the implementation status ledger still says the work is not runtime
   accepted;
5. any mutating work receives a separate change record, target allowlist,
   identity, canary, stop condition and recovery plan; and
6. no missing application, product or cloud capability is silently created by
   documentation language.

## Completion statement

The shared enterprise and platform design is ready for implementation
planning. Application-specific enterprise design is intentionally incomplete
until real care-delivery and payer projects are registered. This repository
must continue to report that boundary rather than treating platform breadth as
proof of an application estate.
