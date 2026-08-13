# APP-PODINFO-002 Internal Project and CI Evidence

Date: 2026-08-13

## Decision

Podinfo now has its own private internal project and a protected default branch.
The imported source passed the project's provenance policy and application test
suite on the existing application runner. This closes the internal-source and
initial-CI gates; it does not claim an image was published or an application was
deployed.

| Field | Verified value |
| --- | --- |
| GitLab group | `midhhealth/applications`, group ID `46`, private |
| GitLab project | `midhhealth/applications/podinfo`, project ID `29`, private |
| Default branch | `main`, protected; Maintainers may merge and push; force push disabled |
| Internal commit | `b8dceac72494313eca3ab388a20ad06867675224` |
| Upstream baseline | tag `6.14.1`, commit `eec06d1ea459af4cb4e10e806f8be7c7bd58b361` |
| Import completeness | `1,197` commits and `109` upstream tags retained |
| Pipeline | GitLab pipeline `653` |
| Source-policy job | `1943`, passed |
| Unit-test job | `1944`, passed |
| Application-binary job | `1945`, passed; `bin/` and `evidence/` artifacts retained |
| Application runner | runner ID `3`, `gitlab-runner-app01.example.com`, exact tags `app,docker`, Docker executor |

## What the internal revision adds

The internal commit adds a small delivery contract around the unchanged
upstream application: `UPSTREAM.md`, a source validator, GitLab CI, and
MidhHealth Helm values. The chart can now consume an immutable image digest.
The MidhHealth values fail closed with `PENDING_INTERNAL_IMAGE_DIGEST`; public
ingress, Gateway API routes, Redis, and ServiceMonitor remain disabled. The pod
security context requires non-root execution, a read-only root filesystem, no
privilege escalation, and all Linux capabilities dropped.

## Job evidence

The source-policy job proved the pinned upstream commit and Apache-2.0 license
hash, required the internal values file, and rejected any deployable value that
still points at the public default image. Its evidence artifact was accepted by
GitLab.

The unit-test job checked out the exact internal commit, verified the Go module
graph, ran `go test ./...` with coverage, ran `go vet ./...`, and retained
coverage and dependency-module artifacts. The runner log identifies GitLab
Runner `19.2.0` and the dedicated application runner.

The package job built the application from the same internal commit, generated
its SHA-256 checksum and build metadata, and retained the binary and evidence
directories as GitLab artifacts. Pipeline `653` passed all three jobs in
sequence.

## Deliberate stop

Pipeline `653` proves source and code execution, not container provenance. The
existing Harbor service has not yet received a Podinfo repository or digest,
and no Harbor credential has been assumed. No GitLab runner configuration,
Harbor repository, namespace, DNS, ingress, Jenkins job, or Kubernetes resource
was changed while collecting this evidence.
