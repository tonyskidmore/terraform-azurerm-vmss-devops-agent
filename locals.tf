locals {
  vmss_custom_data = try(coalesce(var.vmss_custom_data_data, filebase64("${path.module}/${var.vmss_custom_data_script}")), null)
}
