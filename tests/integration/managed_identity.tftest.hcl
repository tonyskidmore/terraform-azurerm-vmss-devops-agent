# Integration test for examples/006-managed_identity.
#
# Provisions the harness, then runs the example with a SystemAssigned
# managed identity (via the new 1.0.0 `vmss_identity` object), and asserts
# the identity is exposed on the module output. The example's optional
# RBAC role assignment is disabled for this test (rbac = false).
#
# See admin_password.tftest.hcl for prerequisites.
# Run via: scripts/test-integration.sh managed_identity

variables {
  location                          = "uksouth"
  resource_group_name               = "rg-devops-tftest-mi-01"
  vnet_name                         = "vnet-devops-tftest-mi-01"
  subnet_name                       = "snet-devops-tftest-01"
  azuredevops_project_name          = "devops-tftest-mi-01"
  azuredevops_service_endpoint_name = "devops-tftest-mi-01"
  elastic_pool_name                 = "devops-tftest-mi-01"
  vmss_name                         = "vmss-devops-tftest-mi-01"
  vmss_admin_password               = "Ch@ngeMeTftest01!"
}

run "setup_prereqs" {
  command = apply

  module {
    source = "./tests/integration/harness"
  }
}

run "apply_managed_identity_example" {
  command = apply

  module {
    source = "./examples/006-managed_identity"
  }

  variables {
    elastic_pool_name                 = var.elastic_pool_name
    elastic_pool_desired_idle         = 0
    azuredevops_project_name          = run.setup_prereqs.azuredevops_project_name
    azuredevops_service_endpoint_name = run.setup_prereqs.azuredevops_service_endpoint_name
    vmss_name                         = var.vmss_name
    vmss_resource_group_name          = run.setup_prereqs.resource_group_name
    vmss_vnet_name                    = run.setup_prereqs.vnet_name
    vmss_subnet_name                  = run.setup_prereqs.subnet_name
    vmss_admin_password               = var.vmss_admin_password
    rbac                              = false
  }

  assert {
    condition     = output.vmss_id != null
    error_message = "Expected vmss_id output to be non-null after apply."
  }

  assert {
    condition     = output.vmss_name == var.vmss_name
    error_message = "Expected vmss_name output to equal the name we passed in."
  }

  assert {
    condition     = output.vmss_identity.principal_id != null
    error_message = "Expected vmss_identity.principal_id to be non-null when SystemAssigned identity is enabled."
  }

  assert {
    # When only SystemAssigned is configured, the azurerm VMSS resource
    # renders identity[0].identity_ids as null rather than an empty list,
    # so the sibling's `try(..., [])` returns null (try only catches errors,
    # not null values). Treat null and [] as equivalent "no user-assigned
    # identities" here.
    condition     = length(coalesce(output.vmss_identity.user_assigned_identity_ids, [])) == 0
    error_message = "Expected no user-assigned identities when only SystemAssigned is configured."
  }
}
