output "vnet_id" {
    value = azurerm_virtual_network.PLATFORM_NETWORK_VNET.id
}

output "vnet_name" {
    value = azurerm_virtual_network.PLATFORM_NETWORK_VNET.name
}

output "bastion_subnet_id" {
    value = azurerm_subnet.BASTION_SUBNET.id
}

output "firewall_subnet_id" {
    value = azurerm_subnet.FIREWALL_SUBNET.id
}

output "avd_subnet_id" {
    value = azurerm_subnet.AVD_SUBNET.id
}

output "services_subnet_id" {
    value = azurerm_subnet.SERVICES_SUBNET.id
}

output "avd_subnet_name" {
    value = azurerm_subnet.AVD_SUBNET.name  
}
