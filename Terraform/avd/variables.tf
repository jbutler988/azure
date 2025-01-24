### Shared Variables
variable "subscription_id" {
    description = "The subscription ID"
    type        = string  
}

# variable "resource_group_name_prefix" {
#     description = "The name of the resource group"
#     type        = string
# }
# 
# variable "resource_group_name_suffix" {
#     description = "The name of the resource group"
#     type        = string
# }
variable "resource_group_name" {
    description = "The name of the resource group"
    type        = string  
}

variable "location" {
    description = "The location of the resources"
    type        = string
}

variable "tags" {
    description = "The tags for the resources"
    type        = map(string)  
}

### Network Variables
variable "vnet_name" {
    description = "The name of the virtual network"
    type        = string
}

# variable "vnet_address_space" {
#     description = "The address space of the virtual network"
#     type        = list(string)
# }

# variable "bastion_subnet_name" {
#     description = "The name of the Azure Bastion subnet"
#     type        = string  
# }

# variable "bastion_address_prefix" {
#     description = "The address prefixes of the subnet"
#     type        = string
# }

variable "subnet_name" {
    description = "The name of the services subnet"
    type        = string  
}

variable "subnet_id" {
    description = "The ID of the subnet"
    type        = string  
}

# variable "services_subnet_address_prefix" {
#     description = "The address prefixes of the subnet"
#     type        = string
# }


### AVD Variables
## Workspace Variables
variable "avd_workspace_name" {
    description = "The name of the AVD workspace"
    type        = string
}

variable "avd_workspace_description" {
    description = "The description of the AVD workspace"
    type        = string
}

variable "avd_subnet_name" {
    description = "The name of the AVD subnet"
    type        = string  
}

variable "avd_subnet_address_prefix" {
    description = "The address prefix of the AVD subnet"
    type        = string  
}

# # Session Host VM Variables
# variable "host_vm_name" {
#     description = "The name of the session host VM"
#     type        = string  
# }
# 
# variable "host_vm_size" {
#     description = "The size of the VM"
#     type        = string  
# }
# 
# variable "host_vm_image_publisher" {
#     description = "The publisher of the VM image"
#     type        = string  
# }
# 
# variable "host_vm_image_offer" {
#     description = "The offer of the VM image"
#     type        = string  
# }
# 
# variable "host_vm_image_sku" {
#     description = "The SKU of the VM image"
#     type        = string  
# }
# 
# variable "host_vm_image_version" {
#     description = "The version of the VM image"
#     type        = string  
# }
# 
# variable "host_vm_managed_disk_type" {
#     description = "The type of the managed disk"
#     type        = string  
# }
# 
# variable "admin_username" {
#     description = "The admin username of the VM"
#     type        = string  
# }
# 
# variable "admin_password" {
#     description = "The admin password of the VM"
#     type        = string  
# }


## Host Pool Variables
variable "avd_hostpool_name" {
    description = "The name of the AVD host pool"
    type        = string  
}

variable "host_pool_type" {
    description = "The type of the host pool"
    type        = string  
}

variable "load_balancer_type" {
    description = "The type of the load balancer"
    type        = string  
}

### Application Group Variables
variable "avd_app_group_name" {
    description = "The name of the AVD application group"
    type        = string  
}

variable "avd_app_group_type" {
    description = "The type of the AVD application group"
    type        = string  
}


# ### Storage Account Variables
# variable "storage_account_name" {
#     description = "The name of the storage account"
#     type        = list(string)
# }
# 
# variable "storage_account_tier" {
#     description = "The tier of the storage account"
#     type        = list(string)
# }
# 
# variable "storage_account_replication_type" {
#     description = "The replication type of the storage account"
#     type        = list(string)
# }
# 
# variable "storage_account_kind" {
#     description = "The kind of the storage account"
#     type        = list(string)  
# }
# 
# 
# ### Azure Firewall Variables
# ## Public IP Variables
# variable "public_ip_name" {
#     description = "The name of the public IP"
#     type        = string  
# }
# 
# variable "public_ip_sku" {
#     description = "The SKU of the public IP"
#     type        = string  
# }
# 
# variable "public_ip_allocation_method" {
#     description = "The allocation method of the public IP"
#     type        = string  
# }
# 
# variable "firewall_subnet_name" {
#     description = "The name of the Azure Firewall subnet"
#     type        = string  
# }
# 
# ## Firewall Variables
# variable "firewall_name" {
#     description = "The name of the Azure Firewall"
#     type        = string
# }
# 
# variable "firewall_sku_tier" {
#     description = "The tier of the Azure Firewall"
#     type        = string
# }
# 
# variable "firewall_sku_name" {
#     description = "The name of the Azure Firewall SKU"
#     type        = string
# }
# 
# variable "ip_configuration_name" {
#     description = "The name of the IP configuration"
#     type        = string  
# }
# 
# ## Firewall Policy Variables
# variable "firewall_policy_name" {
#     description = "The name of the Azure Firewall Policy"
#     type        = string
# }
# 
# variable "firewall_subnet_address_prefix" {
#     description = "The address prefix of the Azure Firewall subnet"
#     type        = string  
# }
# 
# 
# ### Log Analytics Variables
# variable "log_analytics_workspace_name" {
#     description = "The name of the Log Analytics workspace"
#     type        = string
# }
# 
# variable "log_analytics_workspace_sku" {
#     description = "The SKU of the Log Analytics workspace"
#     type        = string  
# }
# 
# variable "log_analytics_workspace_retention_in_days" {
#     description = "The retention in days of the Log Analytics workspace"
#     type        = number
#     default     = 30
# }
# 
# 
# ### DNS Variables
# ## Private DNS Zone Variables
# variable "private_dns_zone_names" {
#     description = "The name of the private DNS zone"
#     type        = list(string)
# }
# 
# variable "private_dns_zone_vnet_link_name" {
#     description = "The name of the virtual network link for the private DNS zone"
#     type        = list(string)
# }
# 
# variable "private_dns_zone_vnet_link_registration_enabled" {
#     description = "Whether registration is enabled for the virtual network link"
#     type        = bool
#     default     = false
# }
# 
# ## Domain Controller Variables
# variable "dc_name" {
#     description = "The name of the domain controller"
#     type        = list(string)  
# }
# 
# variable "dc_vm_name" {
#     description = "The name of the domain controller VM"
#     type        = list(string)  
# }
# 
# variable "dc_vm_size" {
#     description = "The size of the domain controller VM"
#     type        = list(string) 
# }
# 
# variable "dc_admin_username" {
#     description = "value of the domain controller admin username"
#     type        = string
# }
# 
# variable "dc_admin_password" {
# description = "value of the domain controller admin password"
# type        = string  
# }
# 
# variable "domain_controller_image_publisher" {
#     description = "The publisher of the domain controller image"
#     type        = string  
# }
# 
# variable "domain_controller_image_offer" {
#     description = "The offer of the domain controller image"
#     type        = string  
# }
# 
# variable "domain_controller_image_sku" {
#     description = "The SKU of the domain controller image"
#     type        = string  
# }
# 
# variable "domain_controller_image_version" {
#     description = "The version of the domain controller image"
#     type        = string  
# }
# 
# variable "managed_disk_type" {
#     description = "The type of the managed disk"
#     type        = string  
# }
