resource "azurerm_key_vault" "key_vault" {
  name                        = "rhp-hub-eus-prod-kv"
  location                    = azurerm_resource_group.shared.location
  resource_group_name         = azurerm_resource_group.shared.name
  tenant_id                   = var.ENTRA_ID
  sku_name                    = "standard"
  public_network_access_enabled = false  # Disable public network access
  enable_rbac_authorization   = true

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"

    ip_rules = []

    virtual_network_subnet_ids = [
      azurerm_subnet.keyvault_subnet.id
    ]
  }
}

resource "azurerm_private_endpoint" "keyvault_endpoint" {
  depends_on          = [ azurerm_private_dns_zone.private_dns_zone]
  name                = "${azurerm_key_vault.key_vault.name}-pe"
  location            = var.REGION
  resource_group_name = azurerm_resource_group.shared.name
  subnet_id           = azurerm_subnet.devops.id
  lifecycle {
    ignore_changes = [tags]
  }

  private_service_connection {
    name                              = "${azurerm_key_vault.key_vault.name}-prvcon"
    private_connection_resource_id    = azurerm_key_vault.key_vault.id
    is_manual_connection              = false
    subresource_names                 = ["vault"]
  }

  private_dns_zone_group {
    name                 = "privatelink.vaultcore.azure.net"
    private_dns_zone_ids = ["/subscriptions/${var.SUB}/resourceGroups/${azurerm_resource_group.dns.name}/providers/Microsoft.Network/privateDnsZones/privatelink.vaultcore.azure.net"]
  }
}

resource "azurerm_key_vault_access_policy" "service_connection_policy" {
  key_vault_id = azurerm_key_vault.key_vault.id
  tenant_id    = var.HUB_SUBSCRIPTION_ID
  object_id    = var.service_principal_object_id  # The object ID of the service principal

  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete",
    "Recover",
    "Backup",
    "Restore"
  ]
}

resource "azurerm_key_vault_secret" "pat" {
  name         = "devops-pat"
  value        = var.PAT
  key_vault_id = azurerm_key_vault.key_vault.id
}

# No VPN is planned to be used for this landing zone
# resource "azurerm_key_vault_secret" "vpn_psk" {
#   depends_on = [ azurerm_role_assignment.build_spn ]
#   name         = "vpn-psk"
#   value        = var.VPN_PSK
#   key_vault_id = azurerm_key_vault.key_vault.id
# }
