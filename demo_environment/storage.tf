resource "azurerm_storage_account" "demo-vmss" {
  name                     = "sademovmss${random_string.build_index.result}"
  resource_group_name      = azurerm_resource_group.demo-vmss.name
  location                 = azurerm_resource_group.demo-vmss.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  # public_network_access_enabled = false
  public_network_access_enabled = true

  tags = var.tags
}

resource "azurerm_storage_container" "tfstate" {
  name                 = "tfstate"
  storage_account_name = azurerm_storage_account.demo-vmss.name
  # container_access_type = "container"
  container_access_type = "private"
}
