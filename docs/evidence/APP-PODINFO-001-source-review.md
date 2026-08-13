# APP-PODINFO-001 Podinfo Source Review

Date: 2026-08-13

## Decision

Podinfo release `6.14.1` is the pinned source candidate for the first
application-project deployment. The source was cloned directly from the
maintainer's public repository and inspected at the exact tag and commit below.
This review approves the source identity for an internal import; it does not
claim that the GitLab project, image, release, telemetry, or rollback exists.

| Field | Verified value |
| --- | --- |
| Upstream | `https://github.com/stefanprodan/podinfo` |
| Branch at review | `master` |
| Release tag | `6.14.1` |
| Commit | `eec06d1ea459af4cb4e10e806f8be7c7bd58b361` |
| Commit date | `2026-07-22T10:23:32+02:00` |
| Commit subject | `Merge pull request #511 from stefanprodan/release-6.14.1` |
| License | Apache License 2.0 |
| `LICENSE` SHA-256 | `00b6239a0f738010ba96855ac4c63fc221bc2875d9427e815e519ebae4f71bd1` |

## Why this source fits the first application exercise

The repository contains a multi-stage Dockerfile, Go module lock data, unit
and end-to-end tests, health and readiness behavior, Prometheus metrics,
OpenTelemetry examples, fault injection, Kubernetes manifests and a Helm
chart. That lets one small workload exercise build, supply chain, release,
ingress, telemetry and rollback contracts without pretending to be a clinical
or payer application.

The upstream chart defaults to `ghcr.io/stefanprodan/podinfo:6.14.1`. The
internal deployment must override that value with an image built from the
internal GitLab commit and published to the existing Harbor service. Deploying
the public image directly would fail the enterprise provenance requirement.

## Import boundary

The import may proceed only when `midhhealth/applications/podinfo` is available
through authenticated GitLab access. Its first internal revision must retain
the upstream history and `LICENSE`, add an `UPSTREAM.md` containing the values
above, and make `origin` the internal project while preserving the public URL
as a read-only `upstream` remote.

The application namespace `podinfo` is the planned bounded runtime inside the
existing application cluster. No ingress hostname has been approved yet. DNS,
TLS and edge routing therefore remain fail-closed instead of borrowing the
Headlamp hostname or inventing a production route.

## Current stop

The internal GitLab project has not been proven to exist. On 2026-08-13, the
available workstation SSH identities were rejected by the GitLab SSH endpoint,
and the isolated in-app browser could not reach the internal GitLab network.
No project, credential, namespace, image, DNS record or Kubernetes resource was
changed during those checks.
