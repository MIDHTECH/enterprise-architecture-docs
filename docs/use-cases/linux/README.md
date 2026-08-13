# Linux Use-Case Implementation Pages

The authoritative Linux use-case names, coverage targets, and count remain in
the [enterprise portfolio](../../enterprise-project-portfolio-and-usecases.md#enterprise-linux-systems-engineering-platform).
That table links directly to each detailed page; this directory intentionally
does not maintain a second use-case list.

Each `UC-LNX-*` page is an end-to-end IaC implementation specification and
interview-preparation record. Pages distinguish verified existing source from
planned paths and require GitLab source gates, Jenkins approval/orchestration,
Terraform or image automation where infrastructure changes, AWX/Ansible for
operating-system state, a canary, runtime health, idempotence, recovery, and
evidence before acceptance.

Use the repository-wide [use-case documentation standard](../README.md) for
the required content, evidence naming, Jira story contract, and completion
rules.
