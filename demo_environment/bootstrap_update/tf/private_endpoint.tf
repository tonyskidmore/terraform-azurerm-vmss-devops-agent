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
