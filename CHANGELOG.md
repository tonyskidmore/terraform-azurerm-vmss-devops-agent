# CHANGELOG

Format based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [1.0.0] - 2026-04-17

Major release bringing the module up to 2026 standards and aligning with
`tonyskidmore/vmss/azurerm` v1.0.0. This release contains breaking changes
— see the "Migrating from 0.2.x / 0.3.x to 1.0.0" section of the README.

### Breaking

* Azure DevOps elastic pool is now managed directly in this module via the
  `microsoft/azuredevops` provider's `azuredevops_elastic_pool` resource.
  The previous shell-based wrapper module has been removed.
* Sibling `tonyskidmore/vmss/azurerm` upgraded from `0.3.2` to `1.0.0`.
* **Terraform core** minimum bumped from `>= 1.5.0` to `>= 1.10.0`.
* **AzureRM provider** constraint tightened from `>= 4.69.0, < 5.0.0` to
  `~> 4.0`.
* **AzureDevOps provider** constraint tightened from `>= 1.15.0, < 2.0.0`
  to `~> 1.15`.
* **Identity inputs** `vmss_identity_type` and `vmss_identity_ids` replaced
  by a single object input
  `vmss_identity = { type = optional(string), identity_ids = optional(list(string), []) }`.
* **`vmss_data_disks[].disk_size_gb`** is now `number` (was `string`).
* **`vmss_ssh_public_key`** default changed from `""` to `null`.
* **Outputs removed:** `vmss_system_assigned_identity_id`,
  `vmss_user_assigned_identity_ids`. Read
  `vmss_identity.principal_id` and `vmss_identity.user_assigned_identity_ids`
  from the new `vmss_identity` output instead.

### Added

* Elastic pool inputs and the azuredevops_elastic_pool resource surface
  (`elastic_pool_name`, `elastic_pool_project_id`,
  `elastic_pool_service_endpoint_id`, `elastic_pool_service_endpoint_scope`,
  `elastic_pool_desired_idle`, `elastic_pool_max_capacity`,
  `elastic_pool_recycle_after_each_use`, `elastic_pool_time_to_live_minutes`,
  `elastic_pool_agent_interactive_ui`, `elastic_pool_auto_provision`,
  `elastic_pool_auto_update`) including a lifecycle precondition enforcing
  `desired_idle <= max_capacity`.
* New outputs: `elastic_pool_id`, `elastic_pool`, `vmss_name`,
  `vmss_unique_id`, flat `vmss_identity`.
* Native `terraform test` suite scaffolded under `tests/` — variable
  validation tests ready to run locally, and plan-assertion tests
  prepared for when Terraform's test framework supports mocking
  third-party providers cleanly (Terraform 1.14 cannot disambiguate
  `microsoft/azuredevops` from the default `hashicorp/*` namespace in
  `mock_provider` blocks). CI currently exercises `terraform validate`
  across the module and all examples instead.
* `scripts/test.sh` and `scripts/test-examples.sh` for local verification
  (fmt / validate / validate every example).
* Variable validation for `vmss_os`, `vmss_instances`, `vmss_disk_size_gb`,
  `vmss_sku`, `elastic_pool_desired_idle`, `elastic_pool_max_capacity`,
  `elastic_pool_time_to_live_minutes`, `vmss_identity`, and more.
* `.github/super-linter.env` for super-linter configuration.
* `terraform-validate` job in CI that runs `terraform fmt -check`,
  module-root `terraform validate`, and iterates `scripts/test-examples.sh`.

### Changed

* Cloud-init templates in `examples/` modernized for Ubuntu 24.04 "noble":
  WALinuxAgent `After=cloud-final.service` override (a workaround for
  older Ubuntu releases) removed from example templates and retained
  defensively only in `scripts/cloud-init/cloud-init`. `$RELEASE`
  placeholder in `examples/004-docker_data_disk/cloud-init.tpl` replaced
  with the literal `noble`.
* Every example now splits `versions.tf` (required providers, backend)
  from `providers.tf` (provider configuration) for clarity.
* Pre-commit, TFLint, Checkov, terraform-docs, and GitHub Actions
  versions bumped: `pre-commit-hooks v5.0.0`, `checkov 3.2.382`,
  `pre-commit-terraform v1.96.2`, `terraform-docs v0.19.0`, TFLint
  AzureRM plugin `0.28.0`, super-linter `v7`, Terraform `1.10.5` in CI.
  Trivy added; terraform-validate patch removed from CI.

### Fixed

* Duplicate `system_info` block in
  `examples/004-docker_data_disk/cloud-init.tpl`.
* Removed the `Patch .pre-commit-config.yaml` step that disabled
  `terraform_validate` in CI.
* `vmss_admin_password` marked `sensitive = true`.

## [0.2.5]
- Adding `007-aks-agents` example

## [0.2.4]
- Adding `user_data` argument

## [0.2.3]
- Adding `006-managed_identity` example

## [0.2.2]
- Adding `005-additional_packages` example

## [0.2.1]
- Minor documentation updates

## [0.2.0]
- Adding support for VMSS data disks
- Added `004-docker_data_disk`, which uses a data disk to store Docker data e.g. container images

## [0.1.0]
Initial version
