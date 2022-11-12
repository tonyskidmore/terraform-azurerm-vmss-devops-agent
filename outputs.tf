output "ado_vmss_pool_output" {
  value       = module.azure-devops-elasticpool.ado_vmss_pool_output
  description = "Azure DevOps VMSS Agent Pool output"
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
