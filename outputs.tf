output "elastic_pool_id" {
  value       = azuredevops_elastic_pool.this.id
  description = "Azure DevOps VM scale set agent pool ID"
}

output "elastic_pool" {
  value = {
    id                     = azuredevops_elastic_pool.this.id
    name                   = azuredevops_elastic_pool.this.name
    azure_resource_id      = azuredevops_elastic_pool.this.azure_resource_id
    service_endpoint_id    = azuredevops_elastic_pool.this.service_endpoint_id
    service_endpoint_scope = azuredevops_elastic_pool.this.service_endpoint_scope
    project_id             = azuredevops_elastic_pool.this.project_id
    desired_idle           = azuredevops_elastic_pool.this.desired_idle
    max_capacity           = azuredevops_elastic_pool.this.max_capacity
    recycle_after_each_use = azuredevops_elastic_pool.this.recycle_after_each_use
    time_to_live_minutes   = azuredevops_elastic_pool.this.time_to_live_minutes
    agent_interactive_ui   = azuredevops_elastic_pool.this.agent_interactive_ui
    auto_provision         = azuredevops_elastic_pool.this.auto_provision
    auto_update            = azuredevops_elastic_pool.this.auto_update
  }
  description = "Azure DevOps VM scale set agent pool attributes"
}

output "vmss_id" {
  value       = module.vmss.vmss_id
  description = "Virtual Machine Scale Set ID"
}

output "vmss_name" {
  value       = module.vmss.vmss_name
  description = "Virtual Machine Scale Set name"
}

output "vmss_location" {
  value       = module.vmss.vmss_location
  description = "Azure region the VMSS was deployed to"
}

output "vmss_sku" {
  value       = module.vmss.vmss_sku
  description = "VM SKU in use by the VMSS"
}

output "vmss_instances" {
  value       = module.vmss.vmss_instances
  description = "Number of instances configured on the VMSS"
}

output "vmss_zones" {
  value       = module.vmss.vmss_zones
  description = "Availability zones the VMSS instances are spread across"
}

output "vmss_unique_id" {
  value       = module.vmss.vmss_unique_id
  description = "The generated unique identifier of the Virtual Machine Scale Set"
}

output "vmss_data_disks" {
  value       = module.vmss.vmss_data_disks
  description = "Data disks configured on the Virtual Machine Scale Set, as accepted by Azure post-apply"
}

output "vmss_identity" {
  value       = module.vmss.vmss_identity
  description = "Flattened managed identity details for the Virtual Machine Scale Set (principal_id, tenant_id, user_assigned_identity_ids)"
}
