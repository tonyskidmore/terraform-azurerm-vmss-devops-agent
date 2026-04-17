provider "azuredevops" {
  org_service_url       = "https://dev.azure.com/fake"
  personal_access_token = "fake"
}

mock_provider "azurerm" {}

override_resource {
  target = azuredevops_elastic_pool.this
  values = {
    id = "00000000-0000-0000-0000-000000000003"
  }
}

variables {
  vmss_resource_group_name            = "rg-test"
  vmss_subnet_id                      = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Network/virtualNetworks/vnet/subnets/snet"
  vmss_admin_password                 = "ExampleP@ssw0rd!"
  elastic_pool_service_endpoint_id    = "00000000-0000-0000-0000-000000000001"
  elastic_pool_service_endpoint_scope = "00000000-0000-0000-0000-000000000002"
}

run "custom_pool_settings_propagate" {
  command = plan

  variables {
    elastic_pool_name                   = "custom-pool"
    elastic_pool_desired_idle           = 1
    elastic_pool_max_capacity           = 5
    elastic_pool_time_to_live_minutes   = 15
    elastic_pool_recycle_after_each_use = true
    elastic_pool_auto_update            = false
    elastic_pool_agent_interactive_ui   = true
  }

  assert {
    condition     = azuredevops_elastic_pool.this.name == "custom-pool"
    error_message = "Expected elastic_pool_name to propagate to the resource."
  }

  assert {
    condition     = azuredevops_elastic_pool.this.desired_idle == 1
    error_message = "Expected elastic_pool_desired_idle=1."
  }

  assert {
    condition     = azuredevops_elastic_pool.this.max_capacity == 5
    error_message = "Expected elastic_pool_max_capacity=5."
  }

  assert {
    condition     = azuredevops_elastic_pool.this.time_to_live_minutes == 15
    error_message = "Expected elastic_pool_time_to_live_minutes=15."
  }

  assert {
    condition     = azuredevops_elastic_pool.this.recycle_after_each_use == true
    error_message = "Expected elastic_pool_recycle_after_each_use=true."
  }

  assert {
    condition     = azuredevops_elastic_pool.this.auto_update == false
    error_message = "Expected elastic_pool_auto_update=false."
  }

  assert {
    condition     = azuredevops_elastic_pool.this.agent_interactive_ui == true
    error_message = "Expected elastic_pool_agent_interactive_ui=true."
  }
}
