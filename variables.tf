# required variables

# variable "ado_ext_pat" {
#   type        = string
#   description = "Azure DevOps personal access token"
# }

variable "ado_org" {
  type        = string
  description = "Azure DevOps Organization name"
}

variable "ado_project" {
  type        = string
  description = "Azure DevOps project name where service connection exists and optionally where pool will only be created"
}

variable "ado_service_connection" {
  type        = string
  description = "Azure DevOps azure service connection name"
}

variable "vmss_resource_group_name" {
  type        = string
  description = "Existing resource group name of where the VMSS will be created"
}

variable "vmss_subnet_id" {
  type        = string
  description = "Existing subnet ID of where the VMSS will be connected"
}


# variables with predefined defaults

variable "ado_dirty" {
  type        = bool
  description = "Azure DevOps pool settings are dirty"
  default     = false
}

variable "ado_pool_auth_all_pipelines" {
  type        = string
  description = "Setting to determine if all pipelines are authorized to use this TaskAgentPool by default (at create only)"
  default     = "True"

  validation {
    condition     = contains(["True", "False"], var.ado_pool_auth_all_pipelines)
    error_message = "The ado_pool_auth_all_pipelines variable must be True or False."
  }
}

variable "ado_pool_desired_idle" {
  type        = number
  description = "Number of machines to have ready waiting for jobs"
  default     = 0
}

variable "ado_pool_desired_size" {
  type        = number
  description = "The desired size of the pool"
  default     = 0
}

variable "ado_pool_max_capacity" {
  type        = number
  description = "Maximum number of machines that will exist in the elastic pool"
  default     = 2
}

variable "ado_pool_max_saved_node_count" {
  type        = number
  description = "Keep machines in the pool on failure for investigation"
  default     = 0
}

variable "ado_pool_name" {
  type        = string
  description = "Azure DevOps agent pool name"
  default     = "azdo-vmss-pool-001"
}

variable "ado_pool_os_type" {
  type        = string
  description = "Operating system type of the nodes in the pool"
  default     = "linux"

  validation {
    condition     = contains(["linux", "windows"], var.ado_pool_os_type)
    error_message = "The ado_pool_os_type variable must be linux or windows."
  }
}

variable "ado_pool_recycle_after_use" {
  type        = bool
  description = "Discard machines after each job completes"
  default     = false
}

variable "ado_pool_sizing_attempts" {
  type        = number
  description = "The number of sizing attempts executed while trying to achieve a desired size"
  default     = 0
}

variable "ado_pool_ttl_mins" {
  type        = number
  description = "The minimum time in minutes to keep idle agents alive"
  default     = 15
}

variable "ado_pool_auto_provision_projects" {
  type        = string
  description = "Setting to automatically provision TaskAgentQueues in every project for the new pool (at create only)"
  default     = "True"

  validation {
    condition     = contains(["True", "False"], var.ado_pool_auto_provision_projects)
    error_message = "The ado_pool_auto_provision_projects variable must be True or False."
  }
}

variable "ado_project_only" {
  type        = string
  description = "Only create the agent pool in the Azure DevOps pool specified? (at create only)"
  default     = "False"

  validation {
    condition     = contains(["True", "False"], var.ado_project_only)
    error_message = "The ado_project_only variable must be True or False."
  }
}


variable "tags" {
  description = "Tags to apply to Azure Virtual Machine Scale"
  type        = map(string)
  default     = {}
}

# should only really be used in testing from a security perspective
variable "vmss_admin_password" {
  type        = string
  description = "Azure Virtual Machine Scale Set instance administrator password"
  default     = null
}

variable "vmss_admin_username" {
  type        = string
  description = "Azure Virtual Machine Scale Set instance administrator name"
  default     = "adminuser"
}

variable "vmss_custom_data_data" {
  type        = string
  description = "The base64 encoded data to use as custom data for the VMSS instances"
  default     = null
}

variable "vmss_custom_data_script" {
  type        = string
  description = "The path to the script that will be base64 encoded custom data for the VMSS instances"
  default     = "scripts/cloud-init/cloud-init"
}

# TODO: this should be named vmss_disk_size_gb, rename in breaking changes update
variable "vmss_disk_size_gb" {
  type        = number
  description = "The Size of the Internal OS Disk in GB, if you wish to vary from the size used in the image this Virtual Machine Scale Set is sourced from"
  default     = null
}

# needs to be enabled on the subscription, see:
# Use the Azure CLI to enable end-to-end encryption using encryption at host
# https://docs.microsoft.com/en-us/azure/virtual-machines/linux/disks-enable-host-based-encryption-cli
variable "vmss_encryption_at_host_enabled" {
  type        = bool
  description = "Should all of the disks (including the temp disk) attached to this Virtual Machine be encrypted by enabling Encryption at Host?"
  default     = false
}

variable "vmss_identity_ids" {
  type        = list(string)
  description = "Specifies a list of User Assigned Managed Identity IDs to be assigned to this Linux Virtual Machine Scale Set"
  default     = null
}

variable "vmss_identity_type" {
  type        = string
  description = "Specifies the type of Managed Service Identity that should be configured on this Linux Virtual Machine Scale Set`"
  default     = null

  validation {
    condition     = var.vmss_identity_type != null ? alltrue([for v in split(",", var.vmss_identity_type) : contains(["SystemAssigned", "UserAssigned"], trimspace(v))]) : true
    error_message = "The vmss_identity_type must be a valid type."
  }
}

variable "vmss_instances" {
  type        = number
  description = "Azure Virtual Machine Scale Set number of instances"
  default     = 0
}

variable "vmss_load_balancer_backend_address_pool_ids" {
  type        = list(string)
  description = "A list of Backend Address Pools IDs from a Load Balancer which this Virtual Machine Scale Set should be connected to"
  default     = null
}

variable "vmss_location" {
  type        = string
  description = "Existing resource group name of where the VMSS will be created"
  default     = "uksouth"
}

variable "vmss_name" {
  type        = string
  description = "Azure Virtual Machine Scale Set name"
  default     = "azdo-vmss-pool-001"
}

variable "vmss_os" {
  type        = string
  description = "Whether to process the Linux Virtual Machine Scale Set resource"
  default     = "linux"
}

variable "vmss_os_disk_caching" {
  type        = string
  description = "The Type of Caching which should be used for the Internal OS Disk"
  default     = "ReadOnly"

  validation {
    condition     = contains(["None", "ReadOnly", "ReadWrite"], var.vmss_os_disk_caching)
    error_message = "The vmss_os_disk_caching must be a valid type."
  }
}

variable "vmss_os_disk_storage_account_type" {
  type        = string
  description = "The Type of Storage Account which should back this the Internal OS Disk"
  default     = "StandardSSD_LRS"

  validation {
    condition     = contains(["Standard_LRS", "StandardSSD_LRS", "Premium_LRS"], var.vmss_os_disk_storage_account_type)
    error_message = "The vmss_os_disk_storage_account_type must be a valid type."
  }
}

variable "vmss_resource_prefix" {
  type        = string
  description = "Prefix to apply to VMSS resources"
  default     = "vmss"
}

variable "vmss_se_enabled" {
  type        = bool
  description = "Whether to process the Linux Virtual Machine Scale Set extension resource"
  default     = false
}

variable "vmss_se_settings_data" {
  type        = string
  description = "The base64 encoded data to use as the script for the VMSS custom script extension"
  default     = null
}

variable "vmss_se_settings_script" {
  type        = string
  description = "The path of the file to use as the script for the VMSS custom script extension"
  default     = "scripts/vmss-startup.sh"
}

variable "vmss_source_image_id" {
  description = "Azure Virtual Machine Scale Set Image ID"
  type        = string
  default     = null
}

variable "vmss_source_image_offer" {
  description = "Azure Virtual Machine Scale Set Source Image Offer"
  type        = string
  default     = "0001-com-ubuntu-server-focal"
}

variable "vmss_source_image_publisher" {
  description = "Azure Virtual Machine Scale Set Source Image Publisher"
  type        = string
  default     = "Canonical"
}

variable "vmss_source_image_sku" {
  description = "Azure Virtual Machine Scale Set Source Image SKU"
  type        = string
  default     = "20_04-lts"
}

variable "vmss_source_image_version" {
  description = "Azure Virtual Machine Scale Set Source Image Version"
  type        = string
  default     = "latest"
}

variable "vmss_sku" {
  type        = string
  description = "Azure Virtual Machine Scale Set SKU"
  default     = "Standard_B1s"
}

variable "vmss_ssh_public_key" {
  description = "Public key to use for SSH access to VMs"
  type        = string
  default     = ""
}

variable "vmss_storage_account_uri" {
  type        = string
  description = "VMSS boot diagnostics storage account URI"
  default     = null
}

variable "vmss_zones" {
  type        = list(string)
  description = "A collection of availability zones to spread the Virtual Machines over"
  default     = []
}
