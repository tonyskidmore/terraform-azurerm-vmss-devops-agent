resource "azurerm_virtual_network" "demo-vmss" {
  name                = var.vmss_vnet_name
  resource_group_name = azurerm_resource_group.demo-vmss.name
  address_space       = var.vmss_vnet_address_space
  location            = azurerm_resource_group.demo-vmss.location
  tags                = var.tags
}

resource "azurerm_subnet" "demo-vmss" {
  name                 = var.vmss_subnet_name
  resource_group_name  = azurerm_resource_group.demo-vmss.name
  address_prefixes     = var.vmss_subnet_address_prefixes
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
