output "PLATFORM_NETWORK_id" {
    value = azurerm_resource_group.PLATFORM_NETWORK.id
}

output "PLATFORM_STORAGE_id" {
    value = azurerm_resource_group.PLATFORM_STORAGE.id
}

output "PLATFORM_LOGGING_id" {
    value = azurerm_resource_group.PLATFORM_LOGGING.id
}

output "PLATFORM_AD_DNS_id" {
    value = azurerm_resource_group.PLATFORM_AD_DNS.id
}

output "PLATFORM_AVD_MANAGEMENT_id" {
    value = azurerm_resource_group.PLATFORM_AVD_MANAGEMENT.id
}

output "PLATFORM_NETWORK_NAME" {
    value = azurerm_resource_group.PLATFORM_NETWORK.name  
}

output "PLATFORM_STORAGE_NAME" {
    value = azurerm_resource_group.PLATFORM_STORAGE.name
}

output "PLATFORM_LOGGING_NAME" {
    value = azurerm_resource_group.PLATFORM_LOGGING.name
}

output "PLATFORM_AD_DNS_NAME" {
    value = azurerm_resource_group.PLATFORM_AD_DNS.name
}

output "PLATFORM_AVD_MANAGEMENT_NAME" {
    value = azurerm_resource_group.PLATFORM_AVD_MANAGEMENT.name
}

output "location" {
    value = azurerm_resource_group.PLATFORM_NETWORK.location  
}