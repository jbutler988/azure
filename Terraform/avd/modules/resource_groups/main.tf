resource "azurerm_resource_group" "AVD_RG" {
    name        = var.resource_group_name
    location    = var.location
    tags = var.tags
}
