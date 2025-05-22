################
# Hub Networking
################

# Defining the Virtual Hub Network Connected to the Hub-Net

resource "azurerm_virtual_network" "hub" {
  name                = ("vnet-${var.SVC}-con-${var.REGION_ABR}-${var.ENV}")
  location            = var.REGION
  resource_group_name = azurerm_resource_group.hub.name
  address_space       = [local.settings.hub_cidr]
  #dns_servers         = local.settings.dns
  lifecycle {
    ignore_changes = [tags]
  }
}

# # Subnet Definition


resource "azurerm_subnet" "gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [local.settings.gateway_cidr]
}

resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [local.settings.bastion_cidr]
}

resource "azurerm_subnet" "azfw" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [local.settings.azfw_cidr]
}
  

# Firewall Route Table

resource "azurerm_route_table" "azfw" {
  name                = ("rt-${var.SVC}-azfw-${var.REGION_ABR}-${var.ENV}")
  location            = var.REGION
  resource_group_name = azurerm_resource_group.hub.name

  route {
    name                   = "internet"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "Internet"
  }

  # route {
  #   name                   = "hub_onprem01"
  #   address_prefix         = local.settings.onprem01
  #   next_hop_type          = "VirtualNetworkGateway"
  # }

  # route {
  #   name                   = "hub_onprem02"
  #   address_prefix         = local.settings.onprem02
  #   next_hop_type          = "VirtualNetworkGateway"
  # }
}

resource "azurerm_subnet_route_table_association" "azfw" {
  subnet_id      = azurerm_subnet.azfw.id
  route_table_id = azurerm_route_table.azfw.id
}


# Gateway Route Table
resource "azurerm_route_table" "gw" {
  name                = ("rt-${var.SVC}-gateway-${var.REGION_ABR}-${var.ENV}")
  location            = var.REGION
  resource_group_name = azurerm_resource_group.hub.name

  route {
    name                   = "RouteToFW"
    address_prefix         = local.settings.hub_cidr
    next_hop_type          = "VnetLocal"
  }

  route {
    name                   = "FWRouteToManagement"
    address_prefix         = local.settings.mgmt_cidr
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.azfw.ip_configuration[0].private_ip_address
  }
}

resource "azurerm_subnet_route_table_association" "gw" {
  subnet_id      = azurerm_subnet.gateway.id
  route_table_id = azurerm_route_table.gw.id
}

## Virtual Network Diagnostics

 resource "azurerm_monitor_diagnostic_setting" "hub_vnet" {
  name               = "diagset-tf"
  target_resource_id = azurerm_virtual_network.hub.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.la.id

  enabled_log {
    category_group = "allLogs"
  }

  metric {
    category = "AllMetrics"
  }
}
