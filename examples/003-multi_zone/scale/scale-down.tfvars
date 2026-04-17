elastic_pool_name                 = "vmss-agent-pool-linux-003"
azuredevops_project_name          = "demo-vmss"
azuredevops_service_endpoint_name = "demo-vmss"
elastic_pool_desired_idle         = 0
elastic_pool_max_capacity         = 2
elastic_pool_time_to_live_minutes = 10
vmss_name                         = "vmss-agent-pool-linux-003"
vmss_resource_group_name          = "rg-demo-azure-devops-vmss"
vmss_vnet_name                    = "vnet-demo-azure-devops-vmss"
vmss_subnet_name                  = "snet-demo-azure-devops-vmss"
# split the nodes over 3 availability zones
# vmss_zones = ["1", "2", "3"]
# vmss_sku   = "Standard_D2as_v4"
# split the nodes over 2 availability zones (reduced cost)
vmss_zones = ["1", "2"]
vmss_sku   = "Standard_B1s"
