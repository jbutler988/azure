resource "azurerm_storage_account" "boot_diag" {
  name                     = ("${var.ORG}diag${var.REGION_ABR}${var.ENV}sa")
  location                 = var.REGION
  resource_group_name      = azurerm_resource_group.logs.name
  account_tier             = "Standard"
  access_tier              = "Hot"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  is_hns_enabled           = false
  nfsv3_enabled            = false
  public_network_access_enabled = local.settings.paas_public

  lifecycle {
    ignore_changes = [tags]
  }

  network_rules {
     default_action = local.settings.network_rules
     bypass         = ["Logging","Metrics","AzureServices"]
     virtual_network_subnet_ids = []
     ip_rules = []
  }
}

resource "azurerm_private_endpoint" "boot_diag_endpoint" {
   depends_on          = [ azurerm_private_dns_zone.private_dns_zone ]
   name                = "${azurerm_storage_account.boot_diag.name}-pe"
   location            = var.REGION
   resource_group_name = azurerm_storage_account.boot_diag.resource_group_name
   subnet_id           = azurerm_subnet.pe.id
   lifecycle {
    ignore_changes = [tags]
  }

   private_service_connection {
     name                              = "${azurerm_storage_account.boot_diag.name}-prvcon"
     private_connection_resource_id    = azurerm_storage_account.boot_diag.id
     is_manual_connection              = false
     subresource_names                 = ["blob"]
   }

   private_dns_zone_group {
     name                 = "privatelink.blob.core.windows.net"
     private_dns_zone_ids = ["/subscriptions/${var.SUB}/resourceGroups/${azurerm_resource_group.dns.name}/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"]
   }
 }


 # Logging Storage Account
 resource "azurerm_storage_account" "logs" {
  name                     = ("${var.ORG}logs${var.REGION_ABR}${var.ENV}sa")
  location                 = var.REGION
  resource_group_name      = azurerm_resource_group.logs.name
  account_tier             = "Standard"
  access_tier              = "Hot"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  is_hns_enabled           = false
  nfsv3_enabled            = false
  public_network_access_enabled = local.settings.paas_public

  lifecycle {
    ignore_changes = [tags]
  }

  network_rules {
     default_action = local.settings.network_rules
     bypass         = ["Logging","Metrics","AzureServices"]
     virtual_network_subnet_ids = []
     ip_rules = []
  }
}

resource "azurerm_private_endpoint" "logs_endpoint" {
   depends_on          = [ azurerm_private_dns_zone.private_dns_zone ]
   name                = "${azurerm_storage_account.logs.name}-pe"
   location            = var.REGION
   resource_group_name = azurerm_storage_account.logs.resource_group_name
   subnet_id           = azurerm_subnet.pe.id
   lifecycle {
    ignore_changes = [tags]
  }

   private_service_connection {
     name                              = "${azurerm_storage_account.logs.name}-prvconn"
     private_connection_resource_id    = azurerm_storage_account.logs.id
     is_manual_connection              = false
     subresource_names                 = ["blob"]
   }

   private_dns_zone_group {
     name                 = "privatelink.blob.core.windows.net"
     private_dns_zone_ids = ["/subscriptions/${var.SUB}/resourceGroups/${azurerm_resource_group.dns.name}/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"]
   }
 }