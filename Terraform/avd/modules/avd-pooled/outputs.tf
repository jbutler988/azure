output "avd_host_pool_id" {
    description = "The ID of the Azure Virtual Desktop host pool"
    value       = azurerm_virtual_desktop_host_pool.AZURE_VIRTUAL_DESKTOP_HOST_POOL.id
}

output "avd_app_group_id" {
    description = "The ID of the Azure Virtual Desktop application group"
    value       = azurerm_virtual_desktop_application_group.AZURE_VIRTUAL_DESKTOP_APP_GROUP.id
}
