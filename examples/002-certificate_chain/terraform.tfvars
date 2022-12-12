ado_pool_name            = "vmss-agent-pool-linux-002"
ado_project              = "demo-vmss"
ado_service_connection   = "demo-vmss"
vmss_name                = "vmss-agent-pool-linux-002"
vmss_resource_group_name = "rg-demo-azure-devops-vmss"
vmss_vnet_name           = "vnet-demo-azure-devops-vmss"
vmss_subnet_name         = "snet-demo-azure-devops-vmss"
# Ubuntu 22.04 is not yet a supported OS
# https://learn.microsoft.com/en-us/azure/devops/pipelines/agents/v2-linux?view=azure-devops
# vmss_source_image_offer  = "0001-com-ubuntu-server-jammy"
# vmss_source_image_sku    = "22_04-lts"
vmss_source_image_offer = "0001-com-ubuntu-server-focal"
vmss_source_image_sku   = "20_04-lts"
