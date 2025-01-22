

resource "azurerm_log_analytics_workspace" "la" {
name                = ("${var.SVC}-logs-${var.REGION_ABR}-${var.ENV}-la")
resource_group_name = azurerm_resource_group.logs.name
location            = var.REGION
lifecycle {
  ignore_changes = [ tags ]
}
}