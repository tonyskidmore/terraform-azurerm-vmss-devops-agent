# Integration test for examples/004-docker_data_disk.
#
# Provisions the harness, then runs the example with a single 10 GB data
# disk, asserts the data disk is attached with the right size (validates
# the 1.0.0 string → number disk_size_gb breaking change), and lets
# `terraform test` destroy everything in reverse order on teardown.
#
# See admin_password.tftest.hcl for prerequisites.
# Run via: scripts/test-integration.sh docker_data_disk

variables {
  location                          = "uksouth"
  resource_group_name               = "rg-devops-tftest-datadisk-01"
  vnet_name                         = "vnet-devops-tftest-datadisk-01"
  subnet_name                       = "snet-devops-tftest-01"
  azuredevops_project_name          = "devops-tftest-datadisk-01"
  azuredevops_service_endpoint_name = "devops-tftest-datadisk-01"
  elastic_pool_name                 = "devops-tftest-datadisk-01"
  vmss_name                         = "vmss-devops-tftest-datadisk-01"
  vmss_admin_password               = "Ch@ngeMeTftest01!"
}

run "setup_prereqs" {
  command = apply

  module {
    source = "./tests/integration/harness"
  }
}

run "apply_docker_data_disk_example" {
  command = apply

  module {
    source = "./examples/004-docker_data_disk"
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
    vmss_data_disks = [
      {
        caching              = "None"
        create_option        = "Empty"
        disk_size_gb         = 10
        lun                  = 1
        storage_account_type = "Standard_LRS"
      }
    ]
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
    condition     = length(output.vmss_data_disks) == 1
    error_message = "Expected exactly one data disk on the VMSS."
  }

  assert {
    condition     = one([for d in output.vmss_data_disks : d.disk_size_gb]) == 10
    error_message = "Expected the data disk to be 10 GB (validates the string → number breaking change)."
  }

  assert {
    condition     = one([for d in output.vmss_data_disks : d.lun]) == 1
    error_message = "Expected the data disk to be on LUN 1."
  }

  # Note: with vmss_instances = 0 (module default) no actual VM instances
  # run, so the Azure portal's "Disks" view will show nothing. The
  # data_disk block lives on the VMSS template and only materialises once
  # instances scale up.
}
