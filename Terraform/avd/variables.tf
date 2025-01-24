### Shared Variables
variable "subscription_id" {
    description = "The subscription ID"
    type        = string  
}

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


## Host Pool Variables
variable "avd_hostpool_name_prefix_pooled" {
    description = "The name of the AVD host pool"
    type        = string  
}

variable "avd_hostpool_name_prefix_personal" {
    description = "The name of the AVD host pool"
    type        = string  
}

variable "load_balancer_type" {
    description = "The type of the load balancer"
    type        = string  
}

### Application Group Variables
variable "avd_pooled_app_group_name" {
    description = "The name of the AVD application group"
    type        = string  
}

variable "avd_pooled_app_group_type" {
    description = "The type of the AVD application group"
    type        = string  
}

variable "avd_personal_app_group_name" {
    description = "The name of the AVD application group"
    type        = string  
}

variable "avd_personal_app_group_type" {
    description = "The type of the AVD application group"
    type        = string  
}
