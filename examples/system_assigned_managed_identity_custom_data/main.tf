locals {
  vmss_custom_data_data = base64encode(templatefile("${path.module}/cloud-init.tpl", {
    STORAGE_ACCOUNT = random_string.random.result
    FILE_PATH       = "/${var.blob_container}/${var.blob_name}"
    })
  )
}

output "azure_storage_account" {
  value       = random_string.random.result
  description = "Azure storage account created"
}

output "azure_blob_path" {
  value       = "https://${random_string.random.result}.blob.core.windows.net/${var.blob_container}/${var.blob_name}"
  description = "Full HTTPS path of Azure storage blob file created"
}

data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "rg" {
  name = "rg-vmss-azdo-agents-01"
}

resource "random_string" "random" {
  length  = 24
  special = false
  upper   = false
}

resource "azurerm_storage_account" "example" {
  name                     = random_string.random.result
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "example" {
  name                  = var.blob_container
  storage_account_name  = azurerm_storage_account.example.name
  container_access_type = "blob"
}

resource "azurerm_role_assignment" "example" {
  scope                = azurerm_storage_account.example.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = module.terraform-azurerm-vmss-devops-agent.vmss_system_assigned_identity_id
}

module "terraform-azurerm-vmss-devops-agent" {
  source = "../../"
  # this will be supplied by exporting TF_VAR_ado_ext_pat before running terraform
  # this an Azure DevOps Personal Access Token to create and manage the agent pool
  ado_ext_pat            = var.ado_ext_pat
  ado_org                = "https://dev.azure.com/tonyskidmore"
  ado_project            = "ve-vmss"
  ado_service_connection = "ve-vmss"
  ado_pool_name          = "vmss-mkt-image-002"
  # use the ado_pool_desired_idle variable to control VMSS instances, not the vmss_instances variable
  ado_pool_desired_idle         = 1
  ado_pool_ttl_mins             = 15
  vmss_name                     = "vmss-mkt-image-002"
  vmss_ssh_public_key           = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDeww5Jfj/kYfBEqdsQtfRUGtnCjdbiIpL4N0XD46IMJuzUKjDI3NJIMCRw59r90cZxuY5poks5/24FcLZUtguZTkT0gupx6lp8F16zadAgEPmV9J9N6xhGyzK4dOjEiJuTu3f4jrFvs4pyphPT/gni4DBMOMOQb8v2ili20qJ8ew964d88fplrwwtKFdR5RI4AXNvDc8iWsbmbej1azXERcu485Hj3ThPNyXu2tfi7PvzYmVZlhlYKCtvh0DWW/BKPXuM8wT/ASM0e7maKSTvL1uhTUuhAicDRkwLFKP5o0vm6s3ERgWCOmhWMklS/pbCWLfjXcgs8rb7F5iiy9xcCT1Ud9SL+rZdQAOhT6Shx0OXQUJRLiMtEh6KD3YC95EHJQ8tYn3dspM1SsO6n4XmnzXT2fjvfpPF4DKdXA9tVmbfK2UscdumMqaFwka7KAiwMtHBgQkCGOPTjGfDTrJn9RovG1ifvzWlCGHwFLl1JmbaE8Cz6Rw4Gm1I7X3aRIHk= vmss test"
  vmss_resource_group_name      = "rg-vmss-azdo-agents-01"
  vmss_subnet_name              = "snet-azdo-agents-01"
  vmss_vnet_resource_group_name = "rg-azdo-agents-networks-01"
  vmss_vnet_name                = "vnet-azdo-agents-01"
  # send custom_data from local file
  vmss_custom_data_data = local.vmss_custom_data_data
  vmss_identity_type    = "SystemAssigned"
}
