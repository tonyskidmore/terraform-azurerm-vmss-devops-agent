data "http" "ifconfig" {
  url = "https://ifconfig.me/ip"
}

resource "azurerm_storage_account" "demo-vmss" {
  name                          = "sademovmss${random_string.build_index.result}"
  resource_group_name           = azurerm_resource_group.demo-vmss.name
  location                      = azurerm_resource_group.demo-vmss.location
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
  public_network_access_enabled = true

  network_rules {
    default_action             = "Deny"
    ip_rules                   = [data.http.ifconfig.body]
    virtual_network_subnet_ids = [azurerm_subnet.demo-vmss.id]
  }

  tags = var.tags
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.demo-vmss.name
  container_access_type = "private"
}
