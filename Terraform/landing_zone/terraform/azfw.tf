# This will define the Azure Firewall

# Azure Firewall Definition
  

resource "azurerm_public_ip" "azfw-pip" {
  name                = ("${var.SVC}-azfw-${var.REGION_ABR}-${var.ENV}-pip")
  location            = var.REGION
  resource_group_name = azurerm_resource_group.hub.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = local.settings.azfw_zones

  lifecycle {
    ignore_changes = [ tags ]
  }
}

resource "azurerm_firewall" "azfw" {
  name                = ("${var.SVC}-conn-${var.REGION_ABR}-${var.ENV}-azfw")
  location            = var.REGION
  resource_group_name = azurerm_resource_group.hub.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"
  zones               = local.settings.azfw_zones
  firewall_policy_id = azurerm_firewall_policy.azfw_policy.id

  lifecycle {
    ignore_changes = [ tags ]
  }
  

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.azfw.id    
    public_ip_address_id = azurerm_public_ip.azfw-pip.id
  }
}

resource "azurerm_firewall_policy" "azfw_policy" {
  name                     = "default-policy"
  location                 = var.REGION
  resource_group_name      = azurerm_resource_group.hub.name
  sku                      = "Standard"
  threat_intelligence_mode = "Alert"
  dns { servers = local.settings.dns }
}

resource "azurerm_firewall_policy_rule_collection_group" "net_policy_rule_collection_group" {
  name               = "Spoke_to_hub_collection"
  firewall_policy_id = azurerm_firewall_policy.azfw_policy.id
  priority           = 200
  network_rule_collection {
    name     = "DefaultNetworkRuleCollection"
    action   = "Allow"
    priority = 210
    rule {
      name                   = "Azure_to_All_Allowed"
      protocols              = ["UDP","TCP","ICMP"]
      source_addresses       = ["*"]
      destination_ports      = ["*"]
      destination_addresses  = ["*"]
    }
  }
  
}

resource "azurerm_firewall_policy_rule_collection_group" "app_policy_rule_collection_group" {
  name               = "DefaulApplicationtRuleCollectionGroup"
  firewall_policy_id = azurerm_firewall_policy.azfw_policy.id
  priority           = 300
  application_rule_collection {
    name     = "DefaultApplicationRuleCollection"
    action   = "Allow"
    priority = 500
    rule {
      name = "AllowInternet"

      description = "Allow all outbound Internet Traffic"
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses     = ["*"]
      destination_fqdns    = ["*"]
    }
  }
}



## Firewall Diagnostics

 resource "azurerm_monitor_diagnostic_setting" "hub_azfw" {
  name               = "diagset-tf"
  target_resource_id = azurerm_firewall.azfw.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.la.id

  enabled_log {
    category_group = "allLogs"
  }

  metric {
    category = "AllMetrics"
  }
}
