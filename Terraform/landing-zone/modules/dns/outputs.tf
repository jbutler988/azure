output "dns_zone_names" {
    value = azurerm_dns_zone.DNS_ZONE_LOOP[*].name
}

output "network_interface_ids" {
    value = azurerm_network_interface.DOMAIN_CONTROLER_NIC_LOOP[*].id
}

output "virtual_machine_ids" {
    value = azurerm_virtual_machine.DOMAIN_CONTROLER_LOOP[*].id
}

output "virtual_machine_names" {
    value = azurerm_virtual_machine.DOMAIN_CONTROLER_LOOP[*].name
}
