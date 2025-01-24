resource "azurerm_resource_group" "PLATFORM_NETWORK" {
    name        = "${var.resource_group_name_prefix}network${var.resource_group_name_suffix}"
    location    = var.location
    tags = {
        "project" = "MiTek",
        "created_by" = "jeremy_butler"
    }
}

resource "azurerm_resource_group" "PLATFORM_STORAGE" {
    name        = "${var.resource_group_name_prefix}storage${var.resource_group_name_suffix}"
    location    = var.location
    tags = {
        "project" = "MiTek",
        "created_by" = "jeremy_butler"
    }
}

resource "azurerm_resource_group" "PLATFORM_LOGGING" {
    name        = "${var.resource_group_name_prefix}logging${var.resource_group_name_suffix}"
    location    = var.location
    tags = {
        "project" = "MiTek",
        "created_by" = "jeremy_butler"
    }
}

resource "azurerm_resource_group" "PLATFORM_AD_DNS" {
    name        = "${var.resource_group_name_prefix}ad-dns${var.resource_group_name_suffix}"
    location    = var.location
    tags = {
        "project" = "MiTek",
        "created_by" = "jeremy_butler"
    }
}

resource "azurerm_resource_group" "PLATFORM_AVD_MANAGEMENT" {
    name        = "${var.resource_group_name_prefix}avd${var.resource_group_name_suffix}"
    location    = var.location
    tags = {
        "project" = "MiTek",
        "created_by" = "jeremy_butler"
    }
}
