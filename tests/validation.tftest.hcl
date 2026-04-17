# Variable-validation tests. Validation failures are surfaced before any
# provider configuration, so no provider or mock blocks are required.

variables {
  vmss_resource_group_name            = "rg-test"
  vmss_subnet_id                      = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Network/virtualNetworks/vnet/subnets/snet"
  elastic_pool_service_endpoint_id    = "00000000-0000-0000-0000-000000000001"
  elastic_pool_service_endpoint_scope = "00000000-0000-0000-0000-000000000002"
}

run "invalid_os_is_rejected" {
  command = plan

  variables {
    vmss_os = "mac"
  }

  expect_failures = [var.vmss_os]
}

run "negative_max_capacity_is_rejected" {
  command = plan

  variables {
    elastic_pool_max_capacity = -1
  }

  expect_failures = [var.elastic_pool_max_capacity]
}

run "negative_desired_idle_is_rejected" {
  command = plan

  variables {
    elastic_pool_desired_idle = -1
  }

  expect_failures = [var.elastic_pool_desired_idle]
}

run "invalid_identity_type_is_rejected" {
  command = plan

  variables {
    vmss_identity = {
      type = "SomethingElse"
    }
  }

  expect_failures = [var.vmss_identity]
}

run "user_assigned_requires_identity_ids" {
  command = plan

  variables {
    vmss_identity = {
      type = "UserAssigned"
    }
  }

  expect_failures = [var.vmss_identity]
}

run "invalid_os_disk_caching_is_rejected" {
  command = plan

  variables {
    vmss_os_disk_caching = "Bogus"
  }

  expect_failures = [var.vmss_os_disk_caching]
}

run "excessive_instances_is_rejected" {
  command = plan

  variables {
    vmss_instances = 99999
  }

  expect_failures = [var.vmss_instances]
}

run "negative_time_to_live_minutes_is_rejected" {
  command = plan

  variables {
    elastic_pool_time_to_live_minutes = -1
  }

  expect_failures = [var.elastic_pool_time_to_live_minutes]
}

run "invalid_os_disk_storage_account_type_is_rejected" {
  command = plan

  variables {
    vmss_os_disk_storage_account_type = "NotAType"
  }

  expect_failures = [var.vmss_os_disk_storage_account_type]
}
