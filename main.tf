module "vmss" {
  # TEMP: local path while sibling v1.0.0 is not yet on the Registry.
  # Revert to `source = "tonyskidmore/vmss/azurerm"` + `version = "1.0.0"` before tagging v1.0.0.
  source = "../terraform-azurerm-vmss"
  # required variables
  vmss_resource_group_name = var.vmss_resource_group_name
  vmss_subnet_id           = var.vmss_subnet_id
  # variables with predefined defaults
  tags                                        = var.tags
  vmss_admin_password                         = var.vmss_admin_password
  vmss_admin_username                         = var.vmss_admin_username
  vmss_custom_data                            = local.vmss_custom_data
  vmss_data_disks                             = var.vmss_data_disks
  vmss_disk_size_gb                           = var.vmss_disk_size_gb
  vmss_encryption_at_host_enabled             = var.vmss_encryption_at_host_enabled
  vmss_identity                               = var.vmss_identity
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
  vmss_user_data                              = var.vmss_user_data
  vmss_zones                                  = var.vmss_zones
}

resource "azuredevops_elastic_pool" "this" {
  name                   = var.elastic_pool_name
  azure_resource_id      = module.vmss.vmss_id
  service_endpoint_id    = var.elastic_pool_service_endpoint_id
  service_endpoint_scope = var.elastic_pool_service_endpoint_scope
  project_id             = var.elastic_pool_project_id
  desired_idle           = var.elastic_pool_desired_idle
  max_capacity           = var.elastic_pool_max_capacity
  recycle_after_each_use = var.elastic_pool_recycle_after_each_use
  time_to_live_minutes   = var.elastic_pool_time_to_live_minutes
  agent_interactive_ui   = var.elastic_pool_agent_interactive_ui
  auto_provision         = var.elastic_pool_auto_provision
  auto_update            = var.elastic_pool_auto_update

  lifecycle {
    precondition {
      condition     = var.elastic_pool_desired_idle <= var.elastic_pool_max_capacity
      error_message = "The elastic_pool_desired_idle value must be less than or equal to elastic_pool_max_capacity."
    }
  }
}
