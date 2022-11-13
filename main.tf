module "vmss" {
  source  = "tonyskidmore/vmss/azurerm"
  version = "0.2.1"
  # required variables
  vmss_resource_group_name = var.vmss_resource_group_name
  vmss_subnet_id           = var.vmss_subnet_id
  # variables with predefined defaults
  tags                                        = var.tags
  vmss_admin_password                         = var.vmss_admin_password
  vmss_admin_username                         = var.vmss_admin_username
  vmss_custom_data                            = var.vmss_custom_data
  vmss_disk_size_gb                           = var.vmss_disk_size_gb
  vmss_encryption_at_host_enabled             = var.vmss_encryption_at_host_enabled
  vmss_identity_ids                           = var.vmss_identity_ids
  vmss_identity_type                          = var.vmss_identity_type
  vmss_instances                              = var.vmss_instances
  vmss_load_balancer_backend_address_pool_ids = var.vmss_load_balancer_backend_address_pool_ids
  vmss_location                               = var.vmss_location
  vmss_name                                   = var.vmss_name
  vmss_os                                     = var.vmss_os
  vmss_os_disk_caching                        = var.vmss_os_disk_caching
  vmss_os_disk_storage_account_type           = var.vmss_os_disk_storage_account_type
  vmss_resource_prefix                        = var.vmss_resource_prefix
  vmss_se_enabled                             = var.vmss_se_enabled
  vmss_se_settings_data                       = var.vmss_se_settings_data
  vmss_se_settings_script                     = var.vmss_se_settings_script
  vmss_source_image_id                        = var.vmss_source_image_id
  vmss_source_image_offer                     = var.vmss_source_image_offer
  vmss_source_image_publisher                 = var.vmss_source_image_publisher
  vmss_source_image_sku                       = var.vmss_source_image_sku
  vmss_source_image_version                   = var.vmss_source_image_version
  vmss_sku                                    = var.vmss_sku
  vmss_ssh_public_key                         = var.vmss_ssh_public_key
  vmss_storage_account_uri                    = var.vmss_storage_account_uri
  vmss_zones                                  = var.vmss_zones

}

module "azure-devops-elasticpool" {
  source  = "tonyskidmore/azure-devops-elasticpool/shell"
  version = "0.3.0"
  # required variables
  # ado_ext_pat            = var.ado_ext_pat
  ado_org                = var.ado_org
  ado_project            = var.ado_project
  ado_service_connection = var.ado_service_connection
  ado_vmss_id            = module.vmss.vmss_id
  # variables with predefined defaults
  ado_pool_auth_all_pipelines      = var.ado_pool_auth_all_pipelines
  ado_pool_desired_idle            = var.ado_pool_desired_idle
  ado_pool_desired_size            = var.ado_pool_desired_size
  ado_pool_max_capacity            = var.ado_pool_max_capacity
  ado_pool_max_saved_node_count    = var.ado_pool_max_saved_node_count
  ado_pool_name                    = var.ado_pool_name
  ado_pool_os_type                 = var.ado_pool_os_type
  ado_pool_recycle_after_use       = var.ado_pool_recycle_after_use
  ado_pool_sizing_attempts         = var.ado_pool_sizing_attempts
  ado_pool_ttl_mins                = var.ado_pool_ttl_mins
  ado_pool_auto_provision_projects = var.ado_pool_auto_provision_projects
  ado_project_only                 = var.ado_project_only
}
