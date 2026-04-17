# Development

## Required tooling

| Tool       | Minimum version | Notes                                                                                     |
|------------|-----------------|-------------------------------------------------------------------------------------------|
| Terraform  | 1.12            | 1.10 is the module's `required_version`; 1.12+ is needed for the `terraform test` suite   |
| Python     | 3.12            | For the pre-commit toolchain                                                              |
| pre-commit | 4.5             | Pinned in `requirements.txt`                                                              |
| tflint     | latest          | The `azurerm` ruleset is pinned in `.tflint.hcl`                                          |
| Trivy      | latest          | Pre-commit hook runs `terraform_trivy` with `--severity=HIGH,CRITICAL`                    |
| Azure CLI  | latest          | Optional — convenient for `az login` + integration tests                                  |

Provider versions are pinned at the module root in `versions.tf`
(`azurerm ~> 4.0`, `azuredevops ~> 1.15`). Each example ships its own
`versions.tf` and `providers.tf`.

## Local verification (no Azure credentials required)

Three layers of local checks, all runnable offline:

```bash
# 1. Pre-commit: fmt, validate, tflint, trivy, terraform-docs
pre-commit run --all-files

# 2. Example validation: init -backend=false + validate every example
scripts/test-examples.sh

# 3. Top-level wrapper: fmt -check -recursive, root validate,
#    native `terraform test`, and test-examples.sh in sequence.
scripts/test.sh
```

`terraform test` — about the unit tests under `tests/*.tftest.hcl`

All four files (`defaults`, `elastic_pool`, `identity`, `validation`) run
offline via `mock_provider "azuredevops" {}` and `mock_provider "azurerm"
{}`. No real Azure or Azure DevOps credentials are touched. `scripts/
test.sh` and the `terraform-validate` CI job both run `terraform test`.

## Integration tests (real Azure + Azure DevOps apply/destroy)

Under `tests/integration/` there are opt-in `terraform test` files that use
`command = apply` to deploy examples against a real Azure subscription and
Azure DevOps organisation. A harness submodule
(`tests/integration/harness/`) provisions the prerequisite resource group,
virtual network, subnet, Azure DevOps project, and AzureRM service
connection; each integration test then composes the harness with an
example and asserts on outputs. Terraform destroys everything in reverse
order on teardown.

They are not part of `scripts/test.sh` because they incur Azure cost and
take several minutes per test.

```bash
# All integration tests (prompts once for confirmation)
scripts/test-integration.sh

# Just one example
scripts/test-integration.sh admin_password

# Skip the confirmation prompt (e.g. for CI)
scripts/test-integration.sh --yes

# Show the full plan + state per run (what Azure + ADO actually created)
scripts/test-integration.sh --verbose
```

What each integration test currently asserts:

| Test               | Assertions beyond apply/destroy succeeding                                                                                    |
|--------------------|-------------------------------------------------------------------------------------------------------------------------------|
| admin_password     | `vmss_id` ends with the expected VMSS name; `vmss_name`, `vmss_location`, `vmss_sku` match inputs; `elastic_pool.name` OK     |
| docker_data_disk   | Exactly one data disk on the VMSS, `disk_size_gb == 10`, `lun == 1` (validates string → number breaking change)               |
| managed_identity   | `vmss_identity.principal_id != null` (SystemAssigned wired up); `user_assigned_identity_ids` empty                            |
| multi_zone         | `vmss_location == "uksouth"`; `elastic_pool.time_to_live_minutes == 15` (confirms non-default pool setting propagated)        |

The `additional_packages` and `certificate_chain` examples (005 / 002)
aren't integration-tested — they differ from `admin_password` only by
cloud-init content, so the marginal value of a live apply/destroy is low.

### Required environment

- **Azure** — `ARM_SUBSCRIPTION_ID` (or `az login`) plus the usual
  `ARM_CLIENT_ID` / `ARM_CLIENT_SECRET` / `ARM_TENANT_ID` if not using
  CLI auth.
- **Azure DevOps provider** — `AZDO_ORG_SERVICE_URL`
  (e.g. `https://dev.azure.com/<org>`) and `AZDO_PERSONAL_ACCESS_TOKEN`.
- **Service principal credentials for the AzureRM service connection** —
  passed as `TF_VAR_*` because the service endpoint resource needs the
  client secret injected directly:
  - `TF_VAR_serviceprincipalid`
  - `TF_VAR_serviceprincipalkey`
  - `TF_VAR_azurerm_spn_tenantid`
  - `TF_VAR_azurerm_subscription_id`

See `tests/integration/README.md` for what each test covers and how to
clean up resources after a failed run.

## GitHub Actions

`.github/workflows/ci.yml` runs three jobs on push and pull request:

- **build** — GitHub `super-linter@v7` with config from
  `.github/super-linter.env`.
- **pre-commit** — all the hooks in `.pre-commit-config.yaml`
  (`terraform_fmt`, `terraform_validate`, `terraform_tflint`,
  `terraform_trivy`, `checkov`, `terraform-docs`, etc.).
- **terraform-validate** — `terraform fmt -check -recursive`, module-root
  `terraform init -backend=false && terraform validate`, and
  `scripts/test-examples.sh` across every example.

Integration tests are not run in CI by default — they require real Azure
and Azure DevOps credentials plus an SP secret that a public repo's
`GITHUB_TOKEN` does not have. Run them locally or wire up
`scripts/test-integration.sh --yes` into an internal pipeline with the
env vars above set as repo secrets.

## Migrating code that uses this module

If you are updating from `tonyskidmore/vmss-devops-agent/azurerm` 0.2.x /
0.3.x to 1.0.0, these are the caller-facing changes you need to make.
See also the "Migrating from 0.2.x / 0.3.x to 1.0.0" section of the
top-level `README.md` for the fuller narrative.

### Identity inputs — two variables → one object

```hcl
# Before (0.2.x / 0.3.x)
module "agent" {
  source             = "tonyskidmore/vmss-devops-agent/azurerm"
  vmss_identity_type = "UserAssigned"
  vmss_identity_ids  = [azurerm_user_assigned_identity.agents.id]
}

# After (1.0.0)
module "agent" {
  source  = "tonyskidmore/vmss-devops-agent/azurerm"
  version = "~> 1.0"
  vmss_identity = {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.agents.id]
  }
}
```

### Identity outputs — read from `vmss_identity`

```hcl
# Before
principal_id = module.agent.vmss_system_assigned_identity_id
user_ids     = module.agent.vmss_user_assigned_identity_ids

# After
principal_id = module.agent.vmss_identity.principal_id
user_ids     = module.agent.vmss_identity.user_assigned_identity_ids
```

### Data disks — `disk_size_gb` is now a number

```hcl
vmss_data_disks = [{
  caching              = "None"
  create_option        = "Empty"
  disk_size_gb         = 10         # was "10" (string) in 0.2.x / 0.3.x
  lun                  = 1
  storage_account_type = "Standard_LRS"
}]
```

### SSH key — `null` instead of `""`

`vmss_ssh_public_key` now defaults to `null`. Callers that explicitly
passed `""` to opt out should pass `null` or simply omit the input.

### Provider and Terraform constraints

```hcl
terraform {
  required_version = ">= 1.10.0"
  required_providers {
    azurerm     = { source = "hashicorp/azurerm",     version = "~> 4.0" }
    azuredevops = { source = "microsoft/azuredevops", version = "~> 1.15" }
  }
}
```

### Output shape

The 1.0.0 surface exposes granular outputs rather than a single leaked
resource object:

- `elastic_pool_id`, `elastic_pool` (full attribute object for the pool)
- `vmss_id`, `vmss_name`, `vmss_location`, `vmss_sku`, `vmss_instances`,
  `vmss_unique_id`, `vmss_data_disks`
- `vmss_identity` — flat object: `principal_id`, `tenant_id`,
  `user_assigned_identity_ids`. The sibling normalizes AzureRM's `""`
  sentinels to `null`, so consumers can do
  `output.vmss_identity.principal_id != null` as a predicate for
  "SystemAssigned is enabled".

## Devcontainer

When [Developing inside a Container](https://code.visualstudio.com/docs/devcontainers/containers)
has been enabled, in VS Code open `Dev Containers: Reopen in Container`.

Pre-commit hooks should be installed automatically, but if not run:

```bash
pre-commit install
pre-commit install-hooks
```

## Super-Linter (local)

Download the super-linter container image:

```bash
docker pull ghcr.io/super-linter/super-linter:latest
```

> Note: `.github/super-linter.env` is shared between local and GitHub
> Actions scans.

Run locally:

```bash
docker run \
  -e ACTIONS_RUNNER_DEBUG=true \
  -e RUN_LOCAL=true \
  --env-file ".github/super-linter.env" \
  -v "$PWD":/tmp/lint \
  ghcr.io/super-linter/super-linter:latest
```

See the [super-linter local instructions][gha-super-linter-local] for
more detail.

[gha-super-linter-local]: https://github.com/super-linter/super-linter/blob/main/docs/run-linter-locally.md
