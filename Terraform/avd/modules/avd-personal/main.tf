resource "azurerm_virtual_desktop_host_pool" "AZURE_VIRTUAL_DESKTOP_HOST_POOL" {
    name                = var.avd_hostpool_name_prefix_personal
    location            = var.location
    resource_group_name = var.resource_group_name
    type                = var.host_pool_type
    load_balancer_type  = var.load_balancer_type
    friendly_name       = var.avd_hostpool_name_prefix_personal
    tags = var.tags
}

resource "azurerm_virtual_desktop_application_group" "AZURE_VIRTUAL_DESKTOP_APP_GROUP" {
    name                = var.avd_app_group_name
    location            = var.location
    resource_group_name = var.resource_group_name
    type                = var.avd_app_group_type
    host_pool_id        = azurerm_virtual_desktop_host_pool.AZURE_VIRTUAL_DESKTOP_HOST_POOL.id
    friendly_name       = var.avd_app_group_name
    tags = var.tags
}
