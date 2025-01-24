resource "azurerm_public_ip" "FIREWALL_PIP" {
    name                = var.public_ip_name
    location            = var.location
    resource_group_name = var.resource_group_name
    allocation_method   = var.public_ip_allocation_method
    sku                 = var.public_ip_sku
    depends_on          = [ var.network_id ]
}

resource "azurerm_firewall" "AZURE_FIREWALL" {
    name                = var.firewall_name
    location            = var.location
    resource_group_name = var.resource_group_name
    sku_tier            = var.firewall_sku_tier
    sku_name            = var.firewall_sku_name
    depends_on          = [ azurerm_public_ip.FIREWALL_PIP ]

    ip_configuration {
        name                 = var.ip_configuration_name
        subnet_id            = var.subnet_id
        public_ip_address_id = azurerm_public_ip.FIREWALL_PIP.id
    }
}

resource "azurerm_firewall_policy" "FIREWALL_POLICY-001" {
    name                = var.firewall_policy_name
    location            = var.location
    resource_group_name = var.resource_group_name
    depends_on          = [ azurerm_firewall.AZURE_FIREWALL ]
}
