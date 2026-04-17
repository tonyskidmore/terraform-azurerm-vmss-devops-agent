# Integration test for examples/001-admin_password.
#
# Provisions the full dependency graph (RG + vnet + subnet + ADO project +
# AzureRM service connection) via the harness, then runs the example, asserts
# on outputs, and lets `terraform test` destroy everything in reverse order
# on teardown.
#
# Requires:
#   - Azure credentials (ARM_SUBSCRIPTION_ID + SP creds, or `az login`)
#   - Azure DevOps credentials: AZDO_ORG_SERVICE_URL, AZDO_PERSONAL_ACCESS_TOKEN
#   - SP credentials for the AzureRM service connection, supplied as:
#       TF_VAR_serviceprincipalid
#       TF_VAR_serviceprincipalkey
#       TF_VAR_azurerm_spn_tenantid
#       TF_VAR_azurerm_subscription_id
#
# Run via: scripts/test-integration.sh admin_password

variables {
  location                          = "uksouth"
  resource_group_name               = "rg-devops-tftest-adminpw-01"
  vnet_name                         = "vnet-devops-tftest-adminpw-01"
  subnet_name                       = "snet-devops-tftest-01"
  azuredevops_project_name          = "devops-tftest-adminpw-01"
  azuredevops_service_endpoint_name = "devops-tftest-adminpw-01"
  elastic_pool_name                 = "devops-tftest-adminpw-01"
  vmss_name                         = "vmss-devops-tftest-adminpw-01"
  vmss_admin_password               = "Ch@ngeMeTftest01!"
}

run "setup_prereqs" {
  command = apply

  module {
    source = "./tests/integration/harness"
  }
}

run "apply_admin_password_example" {
  command = apply

  module {
    source = "./examples/001-admin_password"
  }

  variables {
    elastic_pool_name                 = var.elastic_pool_name
    azuredevops_project_name          = run.setup_prereqs.azuredevops_project_name
    azuredevops_service_endpoint_name = run.setup_prereqs.azuredevops_service_endpoint_name
    vmss_name                         = var.vmss_name
    vmss_resource_group_name          = run.setup_prereqs.resource_group_name
    vmss_vnet_name                    = run.setup_prereqs.vnet_name
    vmss_subnet_name                  = run.setup_prereqs.subnet_name
    vmss_admin_password               = var.vmss_admin_password
  }

  assert {
    condition     = output.vmss_id != null
    error_message = "Expected vmss_id output to be non-null after apply."
  }

  assert {
    condition     = can(regex("/virtualMachineScaleSets/", output.vmss_id))
    error_message = "Expected vmss_id to be an Azure VMSS resource ID."
  }
}
