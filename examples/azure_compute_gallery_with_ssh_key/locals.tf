locals {
  vmss_source_image_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/${var.vm_image_version_path}/${var.vm_image_version}"
}
