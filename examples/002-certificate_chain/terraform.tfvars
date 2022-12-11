ado_pool_name            = "vmss-agent-pool-linux-002"
ado_project              = "demo-vmss"
ado_service_connection   = "demo-vmss"
vmss_name                = "vmss-agent-pool-linux-002"
vmss_resource_group_name = "rg-demo-azure-devops-vmss"
vmss_vnet_name           = "vnet-demo-azure-devops-vmss"
vmss_subnet_name         = "snet-demo-azure-devops-vmss"
# Unable to install on 22.04 in initial testing
# VM has reported a failure when processing extension 'Microsoft.Azure.DevOps.Pipelines.Agent'
# Unable to install "Unable to locate package liblttng-ust0" as part of dotnet core dependencies
# https://docs.microsoft.com/dotnet/core/install/linux
# vmss_source_image_offer  = "0001-com-ubuntu-server-jammy"
# vmss_source_image_sku    = "22_04-lts"
vmss_source_image_offer = "0001-com-ubuntu-server-focal"
vmss_source_image_sku   = "20_04-lts"
