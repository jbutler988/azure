#############################################
# Data Collection Rule - Linux
#############################################

resource "azurerm_monitor_data_collection_rule" "lin_dcr" {
  name                = ("dcr-lin-${var.SVC}-logs-${var.REGION_ABR}-${var.ENV}")
  location            = var.REGION
  resource_group_name = azurerm_resource_group.hub.name

  destinations {
    log_analytics {
      workspace_resource_id = azurerm_log_analytics_workspace.la.id
      name                  = azurerm_log_analytics_workspace.la.name
    }

  }

  data_flow {
    streams       = ["Microsoft-Syslog"]
    destinations  = ["${azurerm_log_analytics_workspace.la.name}"]
    output_stream = "Microsoft-Syslog"
    
  }

  data_sources {
    syslog {
      facility_names = ["*"]
      log_levels     = ["Error","Critical"]
      name           = "default-datasource-syslog"
      streams        = ["Microsoft-Syslog"]
    }
  }
  identity {
    type         = "SystemAssigned"
  }

  description = "default linux data collection rule"
  lifecycle {
    ignore_changes = [ tags ]
  }
  depends_on = [
    azurerm_log_analytics_workspace.la
  ]
}