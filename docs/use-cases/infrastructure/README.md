# Enterprise Multi-Cloud Infrastructure Platform: Detailed Use Cases

Last verified: 2026-08-13

This index contains all 12 canonical use cases owned by the
Enterprise Multi-Cloud Infrastructure Platform. Together they keep the existing lab foundation repeatable, attributable, and recoverable. Implementation belongs
in `midhhealth/platform-engineering/cloud-infra-automation-platform` and must reuse existing GitLab infrastructure runner, Terraform source, AWX, and canonical inventory.

No page in this directory authorizes a new VM, physical host, IP address, cloud account, state backend, or infrastructure product. All pages begin as
planned specifications; their individual status changes only after source,
runtime, rollback, and evidence gates are met.

| ID | Use case | Canonical coverage |
| --- | --- | --- |
| `UC-INFRA-001` | [Terraform Drift Detection](UC-INFRA-001-terraform-drift-detection.md) | Scheduled Terraform plan detects resources changed outside approved code |
| `UC-INFRA-002` | [Azure Infrastructure Provisioning Using Terraform](UC-INFRA-002-azure-infrastructure-provisioning-using-terraform.md) | Azure stack covers resource group, VNet, VM, storage, database, container platform |
| `UC-INFRA-003` | [AWS VPC Landing Zone Setup](UC-INFRA-003-aws-vpc-landing-zone-setup.md) | AWS stack covers VPC, subnet, security group, storage, database, compute |
| `UC-INFRA-004` | [Terraform Plan Analyzer](UC-INFRA-004-terraform-plan-analyzer.md) | Plan output summarizes creates, updates, destroys and replacement risk |
| `UC-INFRA-005` | [Server Configuration Automation Using Ansible](UC-INFRA-005-server-configuration-automation-using-ansible.md) | Ansible configures Linux hosts after provisioning |
| `UC-INFRA-006` | [Linux Server Patch Automation](UC-INFRA-006-linux-server-patch-automation.md) | Ansible common role handles package baseline and can run patching |
| `UC-INFRA-007` | [Infrastructure Change Impact Analysis](UC-INFRA-007-infrastructure-change-impact-analysis.md) | Planned changes map to services, owners, SLOs, data feeds and runbooks |
| `UC-INFRA-008` | [Cloud Resource Tagging Automation](UC-INFRA-008-cloud-resource-tagging-automation.md) | Terraform variables and common tags standardize ownership/cost metadata |
| `UC-INFRA-009` | [Terraform State Integrity Monitoring](UC-INFRA-009-terraform-state-integrity-monitoring.md) | State backend, lock behavior and unexpected modifications are validated |
| `UC-INFRA-010` | [Environment Standardization Across Dev/Test/Prod](UC-INFRA-010-environment-standardization-across-dev-test-prod.md) | Same modules and variables can drive multiple environments |
| `UC-INFRA-011` | [Infrastructure Reconciliation Loop](UC-INFRA-011-infrastructure-reconciliation-loop.md) | Desired and actual infrastructure state are compared on a schedule |
| `UC-INFRA-012` | [Policy-Driven Provisioning](UC-INFRA-012-policy-driven-provisioning.md) | Terraform changes are blocked when they violate standards |

## GitLab handoff

1. Create the epic and stories from the selected page in `midhhealth/platform-engineering/cloud-infra-automation-platform`.
2. Implement only the planned paths that fit the repository and current lab.
3. Run fixture or read-only validation before requesting a mutating change.
4. Return commit, pipeline, Jenkins/AWX, runtime, recovery, and incident
   evidence to the architecture page.
5. Stop and request a separate architecture decision if new infrastructure,
   capacity, products, or protected-data integration would be required.

