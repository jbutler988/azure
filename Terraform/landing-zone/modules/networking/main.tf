resource "azurerm_virtual_network" "PLATFORM_NETWORK_VNET" {
    name                = var.vnet_name
    address_space       = var.vnet_address_space
    location            = var.location
    resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "BASTION_SUBNET" {
    name                 = var.bastion_subnet_name
    resource_group_name  = var.resource_group_name
    virtual_network_name = var.vnet_name
    address_prefixes     = [var.bastion_address_prefix]
    depends_on           = [ azurerm_virtual_network.PLATFORM_NETWORK_VNET ]
}

resource "azurerm_subnet" "FIREWALL_SUBNET" {
    name                 = var.firewall_subnet_name
    resource_group_name  = var.resource_group_name
    virtual_network_name = var.vnet_name
    address_prefixes     = [var.firewall_subnet_address_prefix]
    depends_on           = [ azurerm_virtual_network.PLATFORM_NETWORK_VNET ]
}

resource "azurerm_subnet" "AVD_SUBNET" {
    name                 = var.avd_subnet_name
    resource_group_name  = var.resource_group_name
    virtual_network_name = var.vnet_name
    address_prefixes     = [var.avd_subnet_address_prefix]
    depends_on           = [ azurerm_virtual_network.PLATFORM_NETWORK_VNET ]
}

resource "azurerm_subnet" "SERVICES_SUBNET" {
    name                 = var.services_subnet_name
    resource_group_name  = var.resource_group_name
    virtual_network_name = var.vnet_name
    address_prefixes     = [ var.services_subnet_address_prefix ]
    depends_on           = [ azurerm_virtual_network.PLATFORM_NETWORK_VNET ]
}

