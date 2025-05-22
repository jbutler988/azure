#############################################
# Data Collection Rule - Windows
#############################################

resource "azurerm_monitor_data_collection_rule" "win_dcr" {
  name                = ("dcr-win-${var.SVC}-logs-${var.REGION_ABR}-${var.ENV}")
  location            = var.REGION
  resource_group_name = azurerm_resource_group.hub.name

  destinations {
    log_analytics {
      workspace_resource_id = azurerm_log_analytics_workspace.la.id
      name                  = azurerm_log_analytics_workspace.la.name
    }

  }

  data_flow {
    streams       = ["Microsoft-Event"]
    destinations  = ["${azurerm_log_analytics_workspace.la.name}"]
    output_stream = "Microsoft-Event"
    
  }

  data_sources {
    windows_event_log {
      streams        = ["Microsoft-WindowsEvent"]
      x_path_queries = ["*![System[(Level = 1 or Level 2)]]"]
      name           = "default-datasource-wineventlog"
    }
  }


  identity {
    type         = "SystemAssigned"
  }

  description = "default windows data collection rule"
  lifecycle {
    ignore_changes = [ tags ]
  }
  depends_on = [
    azurerm_log_analytics_workspace.la
  ]
}