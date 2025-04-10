

resource "azurerm_key_vault" "key-vault" {
  name                        = ("kv-${var.ORG}-${var.SVC}-${var.REGION_ABR}-${var.ENV}")
  location                    = var.REGION
  resource_group_name         = azurerm_resource_group.shared.name
  tenant_id                   = data.azurerm_client_config.current_client.tenant_id
  sku_name                    = "standard"
  enabled_for_disk_encryption = false
  purge_protection_enabled    = false
  enable_rbac_authorization   = true
  public_network_access_enabled = local.settings.paas_public
  lifecycle {
    ignore_changes = [tags]
  }

  network_acls {
     default_action = local.settings.network_rules
     bypass = "AzureServices"
     virtual_network_subnet_ids = []
     ip_rules = []
  }
}


resource "azurerm_private_endpoint" "keyvault_endpoint" {
  depends_on          = [ azurerm_private_dns_zone.private_dns_zone]
  name                = "pe-${azurerm_key_vault.key-vault.name}"
  location            = var.REGION
  resource_group_name = azurerm_resource_group.shared.name
  subnet_id           = azurerm_subnet.devops.id
  lifecycle {
    ignore_changes = [tags]
  }

  private_service_connection {
    name                              = "prvcon-${azurerm_key_vault.key-vault.name}"
    private_connection_resource_id    = azurerm_key_vault.key-vault.id
    is_manual_connection              = false
    subresource_names              = ["vault"]
  }

  private_dns_zone_group {
    name                 = "privatelink.vaultcore.azure.net"
    private_dns_zone_ids = ["/subscriptions/${var.SUB}/resourceGroups/${azurerm_resource_group.dns.name}/providers/Microsoft.Network/privateDnsZones/privatelink.vaultcore.azure.net"]
  }
}

resource "azurerm_key_vault_secret" "vpn_psk" {
  depends_on = [ azurerm_role_assignment.build_spn ]
  name         = "vpn-psk"
  value        = var.VPN_PSK
  key_vault_id = azurerm_key_vault.key-vault.id
}

resource "azurerm_key_vault_secret" "pat" {
  depends_on = [ azurerm_role_assignment.build_spn ]
  name         = "devops-pat"
  value        = var.PAT
  key_vault_id = azurerm_key_vault.key-vault.id
}

