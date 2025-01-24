output "storage_account_ids" {
    description = "The IDs of the storage accounts"
    value       = [for sa in azurerm_storage_account.STORAGE_ACCOUNT_LOOP : sa.id]
}

output "storage_account_names" {
    description = "The names of the storage accounts"
    value       = [for sa in azurerm_storage_account.STORAGE_ACCOUNT_LOOP : sa.name]
}

output "private_endpoint_ids" {
    description = "The IDs of the private endpoints"
    value       = [for pe in azurerm_private_endpoint.STOREAGE_ACCOUNT_PRIVATE_ENDPOINT : pe.id]
}

output "private_endpoint_names" {
    description = "The names of the private endpoints"
    value       = [for pe in azurerm_private_endpoint.STOREAGE_ACCOUNT_PRIVATE_ENDPOINT : pe.name]
}