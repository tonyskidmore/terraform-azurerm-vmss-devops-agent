variable "resource_group_name" {
  type        = string
  description = "Existing resource group name of where the demo-vmss resources will be created"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "subnet_name" {
  type        = string
  description = "Name of subnet where the vmss will be connected"
}

variable "subnet_address_prefixes" {
  type        = list(string)
  description = "Subnet address prefixes"
}

variable "vnet_name" {
  type        = string
  description = "Name of the Vnet that the target subnet is a member of"
}

variable "vnet_address_space" {
  type        = list(string)
  description = "Vnet network address spaces"
}

variable "nsg_name" {
  type        = string
  description = "Name of the Network Security Group"
}

variable "tags" {
  type        = map(string)
  description = "Map of the tags to use for the resources that are deployed"
  default     = {}
}