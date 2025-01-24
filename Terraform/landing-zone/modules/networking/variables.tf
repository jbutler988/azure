variable "vnet_name" {
    description = "The name of the virtual network"
    type        = string
}

variable "vnet_address_space" {
    description = "The address space for the virtual network"
    type        = list(string)
}

variable "bastion_subnet_name" {
    description = "The name of the Bastion subnet"
    type        = string
}

variable "bastion_address_prefix" {
    description = "The address prefix for the Bastion subnet"
    type        = string
}

variable "firewall_subnet_name" {
    description = "The name of the Firewall subnet"
    type        = string
}

variable "firewall_subnet_address_prefix" {
    description = "The address prefix for the Firewall subnet"
    type        = string
}

variable "avd_subnet_name" {
    description = "The name of the AVD subnet"
    type        = string
}

variable "avd_subnet_address_prefix" {
    description = "The address prefix for the AVD subnet"
    type        = string
}

variable "services_subnet_name" {
    description = "The name of the Services subnet"
    type        = string
}

variable "services_subnet_address_prefix" {
    description = "The address prefix for the Services subnet"
    type        = string
}

variable "location" {
    description = "The location of the resources"
    type        = string  
}

variable "resource_group_name" {
    description = "The name of the resource group"
    type        = string
}
