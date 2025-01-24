variable "resource_group_name" {
    description = "The name of the resource group in which to create the resources."
    type        = string
}

variable "location" {
    description = "The location/region where the resources will be created."
    type        = string
}

variable "virtual_network_name" {
    description = "The name of the virtual network."
    type        = string
}

variable "subnet_name" {
    description = "The name of the subnet within the virtual network."
    type        = string
}

variable "subnet_id" {
    description = "The ID of the subnet within the virtual network."
    type        = string  
}

variable "tags" {
    description = "A map of tags to assign to the resources."
    type        = map(string)
    default     = {}
}

variable "avd_workspace_name" {
    description = "The name of the Azure Virtual Desktop workspace."
    type        = string
}

variable "avd_workspace_description" {
    description = "The description of the Azure Virtual Desktop workspace."
    type        = string
}

variable "avd_hostpool_name" {
    description = "The name of the Azure Virtual Desktop host pool."
    type        = string
}

variable "host_pool_type" {
    description = "The type of the Azure Virtual Desktop host pool."
    type        = string
}

variable "load_balancer_type" {
    description = "The type of load balancer for the Azure Virtual Desktop host pool."
    type        = string
}

variable "avd_app_group_name" {
    description = "The name of the Azure Virtual Desktop application group."
    type        = string
}

variable "avd_app_group_type" {
    description = "The type of the Azure Virtual Desktop application group."
    type        = string
}
