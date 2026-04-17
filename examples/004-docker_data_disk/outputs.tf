output "vmss_id" {
  value       = module.terraform-azurerm-vmss-devops-agent.vmss_id
  description = "Virtual Machine Scale Set ID"
}

output "vmss_name" {
  value       = module.terraform-azurerm-vmss-devops-agent.vmss_name
  description = "Virtual Machine Scale Set name"
}

output "vmss_data_disks" {
  value       = module.terraform-azurerm-vmss-devops-agent.vmss_data_disks
  description = "Data disks configured on the Virtual Machine Scale Set"
}

output "elastic_pool" {
  value       = module.terraform-azurerm-vmss-devops-agent.elastic_pool
  description = "Azure DevOps elastic pool attributes"
}
