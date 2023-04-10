# output "admin_client_certificate" {
#   value = try(module.aks.admin_client_certificate, mull)
# }

# output "admin_client_key" {
#   value = try(module.aks.admin_client_key, mull)
# }

# output "client_certificate" {
#   value     = try(module.aks.client_certificate, mull)
#   sensitive = true
# }

# output "client_key" {
#   value     = try(module.aks.client_key, mull)
#   sensitive = true
# }

# output "cluster_ca_certificate" {
#   value     = try(module.aks.cluster_ca_certificate, mull)
#   sensitive = true
# }

# output "cluster_password" {
#   value     = try(module.aks.password, mull)
#   sensitive = true
# }

# output "cluster_username" {
#   value     = try(module.aks.username, mull)
#   sensitive = true
# }

# output "host" {
#   value     = try(module.aks.host, mull)
#   sensitive = true
# }

# output "kube_config" {
#   value     = try(module.aks.kube_config_raw, mull)
#   sensitive = true
# }
