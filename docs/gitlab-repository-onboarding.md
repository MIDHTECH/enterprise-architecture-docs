# GitLab Repository Onboarding

## Purpose

This runbook defines how the `workspace.training` source repositories are
hosted in the on-premises GitLab service. GitLab is the system of record for
platform automation before AWX is introduced.

## Service and Namespace

- GitLab URL: `http://gitlab.example.com`
- GitLab VM: `gitlab.example.com` (`192.168.1.101`)
- Top-level group: `maas-enterprise-cloud-platform`
- Default branch: `main`
- Project visibility: private

HTTP is temporary during bootstrap. Do not place tokens in remote URLs, shell
history, repository files, or staff documentation. The bootstrap token is held
in the macOS credential store and must be replaced with normal user or service
account credentials after TLS and the permanent identity model are configured.

## Registered Projects

| Local repository | GitLab project |
| --- | --- |
| `cloud-governance-ops-automation` | `maas-enterprise-cloud-platform/cloud-governance-ops-automation` |
| `cloud-infra-automation-platform` | `maas-enterprise-cloud-platform/cloud-infra-automation-platform` |
| `devsecops-cicd-orchestrator` | `maas-enterprise-cloud-platform/devsecops-cicd-orchestrator` |
| `enterprise-architecture-docs` | `maas-enterprise-cloud-platform/enterprise-architecture-docs` |
| `jenkins-shared-library` | `maas-enterprise-cloud-platform/jenkins-shared-library` |
| `jenkins_jobs` | `maas-enterprise-cloud-platform/jenkins-jobs` |
| `kubernetes-platform-gitops` | `maas-enterprise-cloud-platform/kubernetes-platform-gitops` |
| `observability-sre-platform` | `maas-enterprise-cloud-platform/observability-sre-platform` |

The local directory `jenkins_jobs` intentionally maps to the hyphenated GitLab
path `jenkins-jobs`.

## Remote Policy

Every repository must have one writable remote named `origin`, and it must
target the on-premises GitLab group:

```bash
git -C workspace.training/<repository> remote -v
```

Do not add direct GitHub, public GitLab, Bitbucket, or server-local filesystem
remotes. External dependencies belong in a controlled dependency mirror or
artifact repository and must be pinned.

The root AWX bootstrap currently references the upstream AWX Operator
kustomization on GitHub. This is a build dependency, not a Git remote. Mirror
or vendor it into the on-premises supply chain before disconnected operation.

## Staff Clone and Push Workflow

After workstation DNS and GitLab access are working:

```bash
git clone \
  http://gitlab.example.com/maas-enterprise-cloud-platform/<project>.git
cd <project>
git switch main
git pull --ff-only
```

Create a feature branch for normal changes. Do not commit passwords, tokens,
private keys, `.env` files, Terraform state, provider caches, or workstation
metadata. Run the repository validation documented in its README before
opening a merge request.

## Bootstrap Validation

For every project, compare the local and remote `main` commit:

```bash
git -C workspace.training/<repository> rev-parse HEAD
git -C workspace.training/<repository> \
  ls-remote origin refs/heads/main
```

The hashes must match. Also verify that `git remote -v` contains no destination
outside `gitlab.example.com`.

## Follow-up Hardening

1. Configure TLS for `gitlab.example.com`.
2. Expose Git-over-SSH on a deliberate port or standardize HTTPS access.
3. Replace the temporary administrator bootstrap token with named staff and
   least-privilege automation identities.
4. Protect `main`, require merge requests and successful pipelines, and define
   CODEOWNERS.
5. Back up GitLab repositories and configuration, then perform a restore test.
6. Mirror or vendor the AWX Operator dependency before disconnected builds.
