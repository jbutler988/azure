variable "resource_group_name_prefix" {
    description = "Prefix for the resource group names"
    type        = string
}

variable "resource_group_name_suffix" {
    description = "Suffix for the resource group names"
    type        = string
}

variable "location" {
    description = "The location where the resource groups will be created"
    type        = string
}