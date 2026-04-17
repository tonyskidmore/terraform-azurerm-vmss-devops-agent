mock_provider "azuredevops" {}
mock_provider "azurerm" {}

variables {
  vmss_resource_group_name            = "rg-test"
  vmss_subnet_id                      = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Network/virtualNetworks/vnet/subnets/snet"
  vmss_admin_password                 = "ExampleP@ssw0rd!"
  elastic_pool_service_endpoint_id    = "00000000-0000-0000-0000-000000000001"
  elastic_pool_service_endpoint_scope = "00000000-0000-0000-0000-000000000002"
}

run "elastic_pool_is_planned_with_defaults" {
  command = plan

  assert {
    condition     = azuredevops_elastic_pool.this.name == "azdo-vmss-pool-001"
    error_message = "Expected default elastic_pool_name \"azdo-vmss-pool-001\"."
  }

  assert {
    condition     = azuredevops_elastic_pool.this.desired_idle == 0
    error_message = "Expected default elastic_pool_desired_idle=0."
  }

  assert {
    condition     = azuredevops_elastic_pool.this.max_capacity == 2
    error_message = "Expected default elastic_pool_max_capacity=2."
  }

  assert {
    condition     = azuredevops_elastic_pool.this.auto_update == true
    error_message = "Expected default elastic_pool_auto_update=true."
  }

  assert {
    condition     = azuredevops_elastic_pool.this.recycle_after_each_use == false
    error_message = "Expected default elastic_pool_recycle_after_each_use=false."
  }

  assert {
    condition     = azuredevops_elastic_pool.this.time_to_live_minutes == 30
    error_message = "Expected default elastic_pool_time_to_live_minutes=30."
  }

  assert {
    condition     = azuredevops_elastic_pool.this.auto_provision == false
    error_message = "Expected default elastic_pool_auto_provision=false."
  }

  assert {
    condition     = azuredevops_elastic_pool.this.agent_interactive_ui == false
    error_message = "Expected default elastic_pool_agent_interactive_ui=false."
  }
}

run "outputs_are_exposed" {
  command = plan

  assert {
    condition     = output.elastic_pool.name == "azdo-vmss-pool-001"
    error_message = "Expected elastic_pool output.name to match default elastic_pool_name."
  }
}
