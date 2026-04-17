output "elastic_pool_id" {
  value       = module.azure-devops-elasticpool.id
  description = "Azure DevOps VM scale set agent pool ID"
}

output "elastic_pool" {
  value       = module.azure-devops-elasticpool.elastic_pool
  description = "Azure DevOps VM scale set agent pool attributes"
}

output "vmss_id" {
  value       = module.vmss.vmss_id
  description = "Virtual Machine Scale Set ID"
}

output "vmss_system_assigned_identity_id" {
  value       = try(module.vmss.vmss_system_assigned_identity_id, null)
  description = "Virtual Machine Scale Set SystemAssigned Identity"
}

output "vmss_user_assigned_identity_ids" {
  value       = try(module.vmss.vmss_user_assigned_identity_ids, null)
  description = "Virtual Machine Scale Set UserAssigned Identities"
}
