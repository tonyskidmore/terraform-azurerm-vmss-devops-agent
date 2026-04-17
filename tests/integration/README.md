# Integration tests

These tests use the native `terraform test` framework with `command = apply`
to deploy each example against a real Azure subscription and a real Azure
DevOps organization, assert on outputs, then let Terraform destroy the
resources on teardown.

Unlike the unit tests in `tests/*.tftest.hcl` (which are scaffolded but
limited by Terraform 1.14's inability to mock the third-party
`microsoft/azuredevops` provider), integration tests:

* Require **Azure credentials** — either `az login` or the full
  `ARM_SUBSCRIPTION_ID` / `ARM_CLIENT_ID` / `ARM_CLIENT_SECRET` /
  `ARM_TENANT_ID` env var set.
* Require **Azure DevOps credentials**:
  * `AZDO_ORG_SERVICE_URL` (e.g. `https://dev.azure.com/<org>`)
  * `AZDO_PERSONAL_ACCESS_TOKEN`
* Require **SP credentials for the AzureRM service connection**, supplied
  as `TF_VAR_*` env vars because the service endpoint resource needs them
  injected directly:
  * `TF_VAR_serviceprincipalid`
  * `TF_VAR_serviceprincipalkey`
  * `TF_VAR_azurerm_spn_tenantid`
  * `TF_VAR_azurerm_subscription_id`
* Incur a small Azure cost per run (a few minutes of a non-running VMSS
  with `vmss_instances = 0`, plus an ephemeral ADO project).
* Take several minutes each (provider download + resource create +
  destroy).

## Running

Use the wrapper, which validates credentials and prompts before applying:

```bash
# All integration tests (prompts once for confirmation)
scripts/test-integration.sh

# Just one test
scripts/test-integration.sh admin_password

# Skip the confirmation prompt (for CI)
scripts/test-integration.sh --yes

# Show the full plan + state per run
scripts/test-integration.sh --verbose
```

## What's covered

| Test file                     | Exercises                                                                                  |
|-------------------------------|--------------------------------------------------------------------------------------------|
| admin_password.tftest.hcl     | Baseline: RG + vnet + ADO project + SE + VMSS + elastic pool, name / location / SKU asserts |
| docker_data_disk.tftest.hcl   | `examples/004-docker_data_disk` with a 10 GB data disk — validates number `disk_size_gb`    |
| managed_identity.tftest.hcl   | `examples/006-managed_identity` with SystemAssigned identity — asserts `principal_id`       |
| multi_zone.tftest.hcl         | `examples/003-multi_zone` with zones `["1","2"]` and a customised `time_to_live_minutes`    |

The `additional_packages` and `certificate_chain` examples (005 / 002)
aren't integration-tested yet — they only differ from
`admin_password` by cloud-init content, so the marginal value of running
them through a live apply/destroy cycle is low. Add them the same way if
you want coverage.

## Harness

`tests/integration/harness/` provisions the prerequisites that every
integration test needs:

* Azure resource group, virtual network, subnet
* Azure DevOps project
* Azure DevOps AzureRM service connection

Each integration `.tftest.hcl` first applies the harness, then applies the
example under test with the harness's outputs (subnet name, project name,
service-connection name) threaded in as variables. `terraform test`
destroys in reverse order, so the elastic pool and VMSS come down before
the ADO project and service connection.

## If a test fails mid-apply

`terraform test` attempts to destroy on failure. If destroy also fails
(Azure throttling, ADO project stuck in delete, etc.), clean up manually:

```bash
# Azure side
az group delete --name rg-devops-tftest-adminpw-01 --yes --no-wait

# Azure DevOps side
# Delete via the Azure DevOps UI or:
#   az devops project delete --id <project-id> --yes
```

Resource group and ADO project names follow
`*-devops-tftest-<suffix>-01` for easy cleanup.
