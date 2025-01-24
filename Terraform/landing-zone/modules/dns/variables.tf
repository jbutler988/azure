variable "private_dns_zone_names" {
    description = "List of private DNS zone names"
    type        = list(string)
}

variable "dc_name" {
    description = "List of domain controller names"
    type        = list(string)
}

variable "dc_vm_size" {
    description = "List of VM sizes for domain controllers"
    type        = list(string)
}

variable "dc_vm_name" {
    description = "List of VM names for domain controllers"
    type        = list(string)
}

variable "dc_admin_username" {
    description = "Admin username for domain controllers"
    type        = string
}

variable "dc_admin_password" {
    description = "Admin password for domain controllers"
    type        = string
    sensitive   = true
}

variable "domain_controller_image_publisher" {
    description = "Publisher of the domain controller image"
    type        = string
}

variable "domain_controller_image_offer" {
    description = "Offer of the domain controller image"
    type        = string
}

variable "domain_controller_image_sku" {
    description = "SKU of the domain controller image"
    type        = string
}

variable "domain_controller_image_version" {
    description = "Version of the domain controller image"
    type        = string
}

variable "managed_disk_type" {
    description = "Managed disk type for the domain controllers"
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

variable "subnet_id" {
    description = "The ID of the subnet"
    type        = string  
}
