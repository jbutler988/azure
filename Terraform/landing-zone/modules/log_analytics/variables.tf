variable "log_analytics_workspace_name" {
    description = "The name of the Log Analytics Workspace."
    type        = string
}

variable "log_analytics_workspace_sku" {
    description = "The SKU (pricing tier) of the Log Analytics Workspace."
    type        = string
    default     = "PerGB2018"
}

variable "log_analytics_workspace_retention_in_days" {
    description = "The retention period for the logs in the Log Analytics Workspace, in days."
    type        = number
    default     = 30
}

variable "location" {
    description = "The location of the Log Analytics Workspace."
    type        = string
}

variable "resource_group_name" {
    description = "The name of the resource group in which the Log Analytics Workspace will be created."
    type        = string  
}