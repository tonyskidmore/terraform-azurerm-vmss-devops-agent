mock_provider "azuredevops" {}
mock_provider "azurerm" {}

variables {
  vmss_resource_group_name            = "rg-test"
  vmss_subnet_id                      = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Network/virtualNetworks/vnet/subnets/snet"
  vmss_admin_password                 = "ExampleP@ssw0rd!"
  elastic_pool_service_endpoint_id    = "00000000-0000-0000-0000-000000000001"
  elastic_pool_service_endpoint_scope = "00000000-0000-0000-0000-000000000002"
}

# Valid identity configurations must plan without error. Resource-level
# assertions live inside the sibling module and cannot be inspected directly
# from a consuming module's tftest; plan success is itself the signal.

run "no_identity_by_default" {
  command = plan
}

run "system_assigned_plans_cleanly" {
  command = plan

  variables {
    vmss_identity = {
      type = "SystemAssigned"
    }
  }
}

run "user_assigned_plans_cleanly" {
  command = plan

  variables {
    vmss_identity = {
      type         = "UserAssigned"
      identity_ids = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.ManagedIdentity/userAssignedIdentities/uai"]
    }
  }
}

run "combined_system_and_user_assigned_plans_cleanly" {
  command = plan

  variables {
    vmss_identity = {
      type         = "SystemAssigned, UserAssigned"
      identity_ids = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.ManagedIdentity/userAssignedIdentities/uai"]
    }
  }
}
