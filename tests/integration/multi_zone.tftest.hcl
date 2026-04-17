# Integration test for examples/003-multi_zone.
#
# Provisions the harness, then runs the example with zone-redundant VMSS
# placement across two availability zones. Asserts the elastic pool was
# wired to the VMSS and the outputs surface correctly.
#
# Availability zones must be supported in the target region — uksouth
# supports zones 1/2/3.
#
# See admin_password.tftest.hcl for prerequisites.
# Run via: scripts/test-integration.sh multi_zone

variables {
  location                          = "uksouth"
  resource_group_name               = "rg-devops-tftest-mz-02"
  vnet_name                         = "vnet-devops-tftest-mz-02"
  subnet_name                       = "snet-devops-tftest-02"
  azuredevops_project_name          = "devops-tftest-mz-02"
  azuredevops_service_endpoint_name = "devops-tftest-mz-02"
  elastic_pool_name                 = "devops-tftest-mz-02"
  vmss_name                         = "vmss-devops-tftest-mz-02"
}

run "setup_prereqs" {
  command = apply

  module {
    source = "./tests/integration/harness"
  }
}

run "apply_multi_zone_example" {
  command = apply

  module {
    source = "./examples/003-multi_zone"
  }

  variables {
    elastic_pool_name                 = var.elastic_pool_name
    elastic_pool_desired_idle         = 0
    elastic_pool_max_capacity         = 2
    elastic_pool_time_to_live_minutes = 15
    azuredevops_project_name          = run.setup_prereqs.azuredevops_project_name
    azuredevops_service_endpoint_name = run.setup_prereqs.azuredevops_service_endpoint_name
    vmss_name                         = var.vmss_name
    vmss_resource_group_name          = run.setup_prereqs.resource_group_name
    vmss_vnet_name                    = run.setup_prereqs.vnet_name
    vmss_subnet_name                  = run.setup_prereqs.subnet_name
    vmss_sku                          = "Standard_B2s"
    vmss_zones                        = ["1", "2"]
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
    condition     = output.vmss_location == "uksouth"
    error_message = "Expected VMSS to be deployed in uksouth."
  }

  assert {
    condition     = length(output.vmss_zones) == 2
    error_message = "Expected the VMSS to be spread across exactly 2 availability zones."
  }

  assert {
    condition     = sort(output.vmss_zones) == ["1", "2"]
    error_message = "Expected the VMSS zones output to be [\"1\", \"2\"]."
  }

  assert {
    condition     = output.elastic_pool.time_to_live_minutes == 15
    error_message = "Expected elastic_pool time_to_live_minutes to equal the input value (15)."
  }
}
