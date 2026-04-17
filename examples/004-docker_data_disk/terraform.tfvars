elastic_pool_name                 = "vmss-agent-pool-linux-004"
azuredevops_project_name          = "demo-vmss"
elastic_pool_desired_idle         = 2
azuredevops_service_endpoint_name = "demo-vmss"
vmss_admin_password               = "Sup3rS3cr3tP@55w0rd!"
vmss_name                         = "vmss-agent-pool-linux-004"
vmss_resource_group_name          = "rg-demo-azure-devops-vmss"
vmss_vnet_name                    = "vnet-demo-azure-devops-vmss"
vmss_subnet_name                  = "snet-demo-azure-devops-vmss"
vmss_data_disks = [
  {
    caching              = "None"
    create_option        = "Empty"
    disk_size_gb         = 10
    lun                  = 1
    storage_account_type = "Standard_LRS"
  }
]
