data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "rg" {
  name = "rg-vmss-azdo-agents-01"
}

output "user_managed_identities" {
  value       = module.terraform-azurerm-vmss-devops-agent.vmss_user_assigned_identity_ids
  description = "The output of the user assigned identities assign to the VMSS"
}

output "build-index" {
  value       = random_string.build-index.result
  description = "The build-index used for naming"
}

locals {
  key_vault_name = "kv-${random_string.build-index.result}-example"
}

resource "random_string" "build-index" {
  length  = 6
  special = false
  upper   = false
}

resource "random_password" "password" {
  length  = 16
  special = true
}

resource "azurerm_user_assigned_identity" "uami" {
  count               = var.user_assigned_identity_count
  name                = "id-${random_string.build-index.result}-${count.index}"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
}

resource "azurerm_key_vault" "example" {
  name                       = local.key_vault_name
  location                   = data.azurerm_resource_group.rg.location
  resource_group_name        = data.azurerm_resource_group.rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  sku_name = "standard"
}

resource "azurerm_key_vault_access_policy" "example" {
  key_vault_id = azurerm_key_vault.example.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete",
    "Backup",
    "Purge",
    "Recover",
    "Restore"
  ]
}

resource "azurerm_key_vault_access_policy" "vmss" {
  count        = var.user_assigned_identity_count
  key_vault_id = azurerm_key_vault.example.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.uami[count.index].principal_id

  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete"
  ]
}

resource "azurerm_key_vault_secret" "example" {
  name         = "admin-password"
  value        = random_password.password.result
  key_vault_id = azurerm_key_vault.example.id

  depends_on = [
    azurerm_key_vault_access_policy.example
  ]
}

module "terraform-azurerm-vmss-devops-agent" {
  source = "../../"
  # this will be supplied by exporting TF_VAR_ado_ext_pat before running terraform
  # this an Azure DevOps Personal Access Token to create and manage the agent pool
  ado_ext_pat                   = var.ado_ext_pat
  ado_org                       = "https://dev.azure.com/tonyskidmore"
  ado_project                   = "ve-vmss"
  ado_service_connection        = "ve-vmss"
  ado_pool_name                 = "vmss-mkt-image-003"
  vmss_name                     = "vmss-mkt-image-003"
  vmss_ssh_public_key           = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDeww5Jfj/kYfBEqdsQtfRUGtnCjdbiIpL4N0XD46IMJuzUKjDI3NJIMCRw59r90cZxuY5poks5/24FcLZUtguZTkT0gupx6lp8F16zadAgEPmV9J9N6xhGyzK4dOjEiJuTu3f4jrFvs4pyphPT/gni4DBMOMOQb8v2ili20qJ8ew964d88fplrwwtKFdR5RI4AXNvDc8iWsbmbej1azXERcu485Hj3ThPNyXu2tfi7PvzYmVZlhlYKCtvh0DWW/BKPXuM8wT/ASM0e7maKSTvL1uhTUuhAicDRkwLFKP5o0vm6s3ERgWCOmhWMklS/pbCWLfjXcgs8rb7F5iiy9xcCT1Ud9SL+rZdQAOhT6Shx0OXQUJRLiMtEh6KD3YC95EHJQ8tYn3dspM1SsO6n4XmnzXT2fjvfpPF4DKdXA9tVmbfK2UscdumMqaFwka7KAiwMtHBgQkCGOPTjGfDTrJn9RovG1ifvzWlCGHwFLl1JmbaE8Cz6Rw4Gm1I7X3aRIHk= vmss test"
  vmss_resource_group_name      = "rg-vmss-azdo-agents-01"
  vmss_subnet_name              = "snet-azdo-agents-01"
  vmss_vnet_resource_group_name = "rg-azdo-agents-networks-01"
  vmss_vnet_name                = "vnet-azdo-agents-01"
  # user assigned managed identity configuration
  vmss_identity_type = "UserAssigned"
  vmss_identity_ids  = azurerm_user_assigned_identity.uami.*.id
}
