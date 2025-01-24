variable "resource_group_name" {
    description = "The name of the resource group in which to create the resources."
    type        = string
}

variable "location" {
    description = "The location/region where the resources will be created."
    type        = string
}

variable "tags" {
    description = "A map of tags to assign to the resources."
    type        = map(string)  
}

variable "avd_workspace_name" {
    description = "The name of the Azure Virtual Desktop workspace."
    type        = string
}

variable "avd_workspace_description" {
    description = "The description of the Azure Virtual Desktop workspace."
    type        = string
}
