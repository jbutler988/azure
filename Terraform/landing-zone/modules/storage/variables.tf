variable "storage_account_name" {
    description = "List of storage account names"
    type        = list(string)
}

variable "storage_account_tier" {
    description = "List of storage account tiers"
    type        = list(string)
}

variable "storage_account_replication_type" {
    description = "List of storage account replication types"
    type        = list(string)
}

variable "location" {
    description = "Location of the resource group"
    type        = string
}

variable "resource_group_name" {
    description = "Name of the resource group"
    type        = string
}

variable "storage_account_kind" {
    description = "List of storage account kinds"
    type        = list(string)  
}

variable "subnet_id" {
    description = "ID of the subnet"
    type        = string  
}