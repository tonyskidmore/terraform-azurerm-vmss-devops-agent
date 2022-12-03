locals {
  vmss_custom_data_data = base64encode(templatefile("${path.module}/scripts/cloud-init/cloud-init.tpl", {}))
}
