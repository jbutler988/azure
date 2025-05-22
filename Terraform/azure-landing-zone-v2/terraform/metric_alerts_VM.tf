

# Virtuam Machine Metric documentation
# https://learn.microsoft.com/en-us/azure/azure-monitor/reference/supported-metrics/microsoft-compute-virtualmachines-metrics


resource "azurerm_monitor_metric_alert" "vm_metrics" {
  name                     = ("CPU-VM-WARNING-ALERT")
  resource_group_name      = azurerm_log_analytics_workspace.la.resource_group_name
  scopes                   = ["/subscriptions/${data.azurerm_subscription.current.subscription_id}"]
  description              = "CPU Metric Alert - Warning - Avg 85%"
  target_resource_type     = "Microsoft.Compute/virtualMachines"
  target_resource_location = var.REGION
  severity                 = 3

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThanOrEqual"
    threshold        = 85
  }


  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }
}