#############################################
# DNS Zone Zones
#############################################


resource "azurerm_private_dns_zone" "private_dns_zone" {
  for_each            = local.private_dns_zones
  name                = each.key
  resource_group_name = azurerm_resource_group.dns.name
  lifecycle {
    ignore_changes = [ tags ]
  }
}

#############################################
# DNS Zone Links
#############################################


resource "azurerm_private_dns_zone_virtual_network_link" "file_link" {
  for_each              = azurerm_private_dns_zone.private_dns_zone
  name                  = "${each.key}_dns_link"
  resource_group_name   = azurerm_resource_group.dns.name
  private_dns_zone_name = each.key
  virtual_network_id    = azurerm_virtual_network.mgmt.id
  registration_enabled  = false
  lifecycle {
    ignore_changes = [ tags ]
  }
}

# All commercial privatelink zones as of January 22, 2024

locals {
  private_dns_zones = toset([
    #############################
    # ** AI + Machine Learning **
    "privatelink.api.azureml.ms",
    "privatelink.notebooks.azure.net",
    "privatelink.cognitiveservices.azure.com",
    "privatelink.openai.azure.com",
    "privatelink.directline.botframework.com",
    "privatelink.token.botframework.com",
    #############################
    # ** Analytics **
    "privatelink.sql.azuresynapse.net",
    "privatelink.dev.azuresynapse.net",
    "privatelink.azuresynapse.net",
    "privatelink.servicebus.windows.net",
    "privatelink.datafactory.azure.net",
    "privatelink.adf.azure.com",
    "privatelink.azurehdinsight.net",
    "privatelink.blob.core.windows.net",
    "privatelink.queue.core.windows.net",
    "privatelink.table.core.windows.net",
    "privatelink.azuredatabricks.net",
    #############################
    # ** Compute **
    "privatelink-global.wvd.microsoft.com",
    "privatelink.wvd.microsoft.com",
    #############################
    # ** Containers **
    "privatelink.azurecr.io",
    #############################
    # ** Databases **
    "privatelink.database.windows.net",
    "privatelink.documents.azure.com",
    "privatelink.mongo.cosmos.azure.com",
    "privatelink.cassandra.cosmos.azure.com",
    "privatelink.gremlin.cosmos.azure.com",
    "privatelink.table.cosmos.azure.com",
    "privatelink.analytics.cosmos.azure.com",
    "privatelink.postgres.cosmos.azure.com",
    "privatelink.postgres.database.azure.com",
    "privatelink.mysql.database.azure.com",
    "privatelink.mariadb.database.azure.com",
    "privatelink.redis.cache.windows.net",
    "privatelink.redisenterprise.cache.azure.net",
    #############################
    # ** Hybrid + multicloud **
    "privatelink.his.arc.azure.com",
    "privatelink.guestconfiguration.azure.com",
    "privatelink.dp.kubernetesconfiguration.azure.com",
    #############################
    # ** Integration **
    "privatelink.servicebus.windows.net",
    "privatelink.eventgrid.azure.net",
    "privatelink.azure-api.net",
    "privatelink.workspace.azurehealthcareapis.com",
    "privatelink.fhir.azurehealthcareapis.com",
    "privatelink.dicom.azurehealthcareapis.com",
    #############################
    # ** Internet of Things (IoT) **
    "privatelink.azure-devices.net",
    "privatelink.servicebus.windows.net",
    "privatelink.azure-devices-provisioning.net",
    "privatelink.api.adu.microsoft.com",
    "privatelink.azureiotcentral.com",
    "privatelink.digitaltwins.azure.net",
    #############################
    # ** Media **
    "privatelink.media.azure.net",
    #############################
    # ** Management and Governance **
    "privatelink.azure-automation.net",
    "privatelink.siterecovery.windowsazure.com",
    "privatelink.oms.opinsights.azure.com",
    "privatelink.ods.opinsights.azure.com",
    "privatelink.agentsvc.azure-automation.net",
    "privatelink.blob.core.windows.net",
    "privatelink.purview.azure.com",
    "privatelink.purviewstudio.azure.com",
    "privatelink.prod.migration.windowsazure.com",
    "privatelink.prod.migration.windowsazure.com",
    "privatelink.grafana.azure.com",
    #############################
    # ** Security **
    "privatelink.vaultcore.azure.net",
    "privatelink.managedhsm.azure.net",
    "privatelink.azconfig.io",
    "privatelink.attest.azure.net",
    #############################
    # ** Storage **
    "privatelink.blob.core.windows.net",
    "privatelink.table.core.windows.net",
    "privatelink.queue.core.windows.net",
    "privatelink.file.core.windows.net",
    "privatelink.web.core.windows.net",
    "privatelink.dfs.core.windows.net",
    "privatelink.afs.azure.net",
    "privatelink.blob.core.windows.net",
    #############################
    # ** WEB **
    "privatelink.search.windows.net",
    "privatelink.servicebus.windows.net",
    "privatelink.azurewebsites.net",
    "privatelink.service.signalr.net",
    "privatelink.azurestaticapps.net",
    "privatelink.servicebus.windows.net",

    ])
}

