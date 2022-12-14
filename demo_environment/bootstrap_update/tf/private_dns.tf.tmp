resource "azurerm_private_dns_zone" "blob" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.demo-vmss.name

  tags = var.tags
}

resource "azurerm_private_dns_a_record" "tf" {
  name                = azurerm_storage_account.demo-vmss.name
  zone_name           = azurerm_private_dns_zone.blob.name
  resource_group_name = azurerm_resource_group.demo-vmss.name
  ttl                 = 3600
  records             = [azurerm_private_endpoint.demo-vmss.private_service_connection.0.private_ip_address]

  tags = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "demo-vmss" {
  name                  = "blob_dns_vnet_link"
  resource_group_name   = azurerm_resource_group.demo-vmss.name
  private_dns_zone_name = azurerm_private_dns_zone.blob.name
  virtual_network_id    = azurerm_virtual_network.demo-vmss.id
  registration_enabled  = false

  tags = var.tags
}
