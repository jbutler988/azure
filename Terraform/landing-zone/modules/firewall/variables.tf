variable "public_ip_name" {
    description = "The name of the public IP address."
    type        = string
}

variable "public_ip_allocation_method" {
    description = "The allocation method for the public IP address."
    type        = string
    default     = "Static"
}

variable "public_ip_sku" {
    description = "The SKU of the public IP address."
    type        = string
    default     = "Standard"
}

variable "firewall_name" {
    description = "The name of the Azure Firewall."
    type        = string
}

variable "firewall_sku_tier" {
    description = "The SKU tier of the Azure Firewall."
    type        = string
    default     = "Standard"
}

variable "firewall_sku_name" {
    description = "The SKU name of the Azure Firewall."
    type        = string
    default     = "AZFW_VNet"
}

variable "ip_configuration_name" {
    description = "The name of the IP configuration for the Azure Firewall."
    type        = string
}

variable "firewall_policy_name" {
    description = "The name of the Azure Firewall policy."
    type        = string
}

variable "location" {
    description = "The location/region where the Azure Firewall resources will be deployed."
    type        = string
}

variable "resource_group_name" {
    description = "The name of the resource group in which the Azure Firewall resources will be deployed."
    type        = string
}

variable "subnet_id" {
    description = "The ID of the subnet in which the Azure Firewall will be deployed."
    type        = string  
}

variable "network_id" {
    description = "The ID of the virtual network in which the Azure Firewall will be deployed."
    type        = string  
}
