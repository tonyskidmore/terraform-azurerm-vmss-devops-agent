resource "azurerm_resource_group" "demo-vmss" {
  name     = var.resource_group_name
  location = var.location
}

resource "random_string" "build_index" {
  length      = 6
  min_numeric = 6
  special     = false
}

resource "azurerm_virtual_network" "demo-vmss" {
  name                = var.vnet_name
  resource_group_name = azurerm_resource_group.demo-vmss.name
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.demo-vmss.location
  tags                = var.tags
}

resource "azurerm_subnet" "demo-vmss" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.demo-vmss.name
  address_prefixes     = var.subnet_address_prefixes
  virtual_network_name = azurerm_virtual_network.demo-vmss.name
}

resource "azurerm_network_security_group" "demo-vmss" {
  name                = var.nsg_name
  location            = azurerm_resource_group.demo-vmss.location
  resource_group_name = azurerm_resource_group.demo-vmss.name
  tags                = var.tags
}

resource "azurerm_subnet_network_security_group_association" "demo-vmss" {
  subnet_id                 = azurerm_subnet.demo-vmss.id
  network_security_group_id = azurerm_network_security_group.demo-vmss.id
}

resource "azurerm_storage_account" "demo-vmss" {
  name                          = "sademovmss${local.build_index}"
  resource_group_name           = azurerm_resource_group.demo-vmss.name
  location                      = azurerm_resource_group.demo-vmss.location
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
  public_network_access_enabled = false

  tags = var.tags
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.demo-vmss.name
  container_access_type = "private"
}

resource "azurerm_private_endpoint" "demo-vmss" {
  name                = "pe-${azurerm_storage_account.demo-vmss.name}"
  location            = azurerm_resource_group.demo-vmss.location
  resource_group_name = azurerm_resource_group.demo-vmss.name
  subnet_id           = azurerm_subnet.demo-vmss.id

  private_service_connection {
    name                           = "pe-${azurerm_storage_account.demo-vmss.name}"
    private_connection_resource_id = azurerm_storage_account.demo-vmss.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  tags = var.tags

}


# resource "azurerm_private_dns_zone" "blob" {
#   name                = local.blob_private_dns_name
#   resource_group_name = azurerm_resource_group.demo-vmss.name

#   tags = var.tags
# }


# resource "azurerm_private_dns_a_record" "tf" {
#   name                = azurerm_storage_account.demo-vmss.name
#   zone_name           = azurerm_private_dns_zone.blob.name
#   resource_group_name = azurerm_resource_group.demo-vmss.name
#   ttl                 = 3600
#   records             = [azurerm_private_endpoint.demo-vmss.private_service_connection.0.private_ip_address]

#   tags = var.tags
# }

# resource "azurerm_private_dns_a_record" "diag" {
#   name                = azurerm_storage_account.diag.name
#   zone_name           = azurerm_private_dns_zone.blob.name
#   resource_group_name = azurerm_resource_group.demo-vmss.name
#   ttl                 = 3600
#   records             = [azurerm_private_endpoint.diag.private_service_connection.0.private_ip_address]

#   tags = var.tags
# }


# resource "azurerm_private_dns_zone_virtual_network_link" "demo-vmss" {
#   name                  = local.blob_private_dns_link_name
#   resource_group_name   = azurerm_resource_group.demo-vmss.name
#   private_dns_zone_name = azurerm_private_dns_zone.blob.name
#   virtual_network_id    = azurerm_virtual_network.demo-vmss.id
#   registration_enabled  = false

#   tags = var.tags
# }