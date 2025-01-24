resource "azurerm_virtual_desktop_workspace" "AZURE_VIRTUAL_DESKTOP" {
    name                            = var.avd_workspace_name
    location                        = var.location
    resource_group_name             = var.resource_group_name
    description                     = var.avd_workspace_description
    friendly_name                   = var.avd_workspace_name
    public_network_access_enabled   = false
    tags = var.tags
}
