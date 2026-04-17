output "vmss_id" {
  value       = module.terraform-azurerm-vmss-devops-agent.vmss_id
  description = "Virtual Machine Scale Set ID"
}

output "vmss_name" {
  value       = module.terraform-azurerm-vmss-devops-agent.vmss_name
  description = "Virtual Machine Scale Set name"
}

output "vmss_location" {
  value       = module.terraform-azurerm-vmss-devops-agent.vmss_location
  description = "Azure region"
}

output "vmss_sku" {
  value       = module.terraform-azurerm-vmss-devops-agent.vmss_sku
  description = "VM SKU"
}

output "elastic_pool" {
  value       = module.terraform-azurerm-vmss-devops-agent.elastic_pool
  description = "Azure DevOps elastic pool attributes"
}
