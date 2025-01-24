output "firewall_public_ip_id" {
    value = azurerm_public_ip.FIREWALL_PIP.id
}

output "firewall_public_ip_address" {
    value = azurerm_public_ip.FIREWALL_PIP.ip_address
}

output "firewall_id" {
    value = azurerm_firewall.AZURE_FIREWALL.id
}

output "firewall_name" {
    value = azurerm_firewall.AZURE_FIREWALL.name
}

output "firewall_policy_id" {
    value = azurerm_firewall_policy.FIREWALL_POLICY-001.id
}

output "firewall_policy_name" {
    value = azurerm_firewall_policy.FIREWALL_POLICY-001.name
}