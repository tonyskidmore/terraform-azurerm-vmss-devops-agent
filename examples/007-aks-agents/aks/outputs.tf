output "cluster_identity" {
  value = try(module.aks.cluster_identity, null)
}

output "cluster_portal_fqdn" {
  value = try(module.aks.cluster_portal_fqdn, null)
}
