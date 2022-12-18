ado_pool_name            = "vmss-agent-pool-linux-003"
ado_project              = "demo-vmss"
ado_service_connection   = "demo-vmss"
ado_pool_desired_idle    = 3
ado_pool_max_capacity    = 5
ado_pool_ttl_mins        = 15
vmss_name                = "vmss-agent-pool-linux-003"
vmss_resource_group_name = "rg-demo-azure-devops-vmss"
vmss_vnet_name           = "vnet-demo-azure-devops-vmss"
vmss_subnet_name         = "snet-demo-azure-devops-vmss"
# split the nodes over 3 availability zones
# vmss_zones = ["1", "2", "3"]
# vmss_sku   = "Standard_D2as_v4"
# split the nodes over 2 availability zones (reduced cost)
vmss_zones = ["1", "2"]
vmss_sku   = "Standard_B1s"
