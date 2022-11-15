data "azurerm_client_config" "current" {}

module "terraform-azurerm-vmss-devops-agent" {
  source = "../../"
  # this will be supplied by exporting TF_VAR_ado_ext_pat before running terraform
  # this an Azure DevOps Personal Access Token to create and manage the agent pool
  ado_ext_pat            = var.ado_ext_pat
  ado_org                = "https://dev.azure.com/tonyskidmore"
  ado_project            = "ve-vmss"
  ado_service_connection = "ve-vmss"
  ado_pool_name          = "vmss-acg-image-002"
  # use the ado_pool_desired_idle variable to control VMSS instances, not the vmss_instances variable
  ado_pool_desired_idle         = 1
  vmss_name                     = "vmss-acg-image-001"
  vmss_ssh_public_key           = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDeww5Jfj/kYfBEqdsQtfRUGtnCjdbiIpL4N0XD46IMJuzUKjDI3NJIMCRw59r90cZxuY5poks5/24FcLZUtguZTkT0gupx6lp8F16zadAgEPmV9J9N6xhGyzK4dOjEiJuTu3f4jrFvs4pyphPT/gni4DBMOMOQb8v2ili20qJ8ew964d88fplrwwtKFdR5RI4AXNvDc8iWsbmbej1azXERcu485Hj3ThPNyXu2tfi7PvzYmVZlhlYKCtvh0DWW/BKPXuM8wT/ASM0e7maKSTvL1uhTUuhAicDRkwLFKP5o0vm6s3ERgWCOmhWMklS/pbCWLfjXcgs8rb7F5iiy9xcCT1Ud9SL+rZdQAOhT6Shx0OXQUJRLiMtEh6KD3YC95EHJQ8tYn3dspM1SsO6n4XmnzXT2fjvfpPF4DKdXA9tVmbfK2UscdumMqaFwka7KAiwMtHBgQkCGOPTjGfDTrJn9RovG1ifvzWlCGHwFLl1JmbaE8Cz6Rw4Gm1I7X3aRIHk= vmss test"
  vmss_resource_group_name      = "rg-vmss-azdo-agents-01"
  vmss_subnet_name              = "snet-azdo-agents-01"
  vmss_vnet_resource_group_name = "rg-azdo-agents-networks-01"
  vmss_vnet_name                = "vnet-azdo-agents-01"
  # locals construction of Azure Container Gallery image
  vmss_source_image_id = local.vmss_source_image_id
  # enable the script extension which by default will use the script: scripts/vmss_se/vmss-startup.sh
  vmss_se_enabled = true
  # zero out vmss_custom_data because we are using the script extension with Microsoft image
  # https://www.skidmore.co.uk/post/2022_04_20_azure_devops_vmss_agents_part2/#path-issue
  vmss_custom_data_script = ""
}
