
# ## Management Virtual Network

resource "azurerm_virtual_network" "mgmt" {
  name                = ("${var.SVC}-mgmt-${var.REGION_ABR}-${var.ENV}-vnet")
  location            = var.REGION
  resource_group_name = azurerm_resource_group.hub.name
  address_space       = [local.settings.mgmt_cidr]
  dns_servers = local.settings.dns
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_subnet" "pe" {
  name                 = "private-endpoints"
  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.mgmt.name
  address_prefixes     = [local.settings.pe_cidr]
}

resource "azurerm_subnet" "devops" {
  name                 = "devops"
  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.mgmt.name
  address_prefixes     = [local.settings.devops_cidr]
}

resource "azurerm_subnet" "shared" {
  name                 = "shared"
  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.mgmt.name
  address_prefixes     = [local.settings.shared_cidr]
}


# General Route Table
resource "azurerm_route_table" "mgmt" {
  depends_on                    = [ azurerm_firewall.azfw ]
  name                          = ("${var.SVC}-mgmt-${var.REGION_ABR}-${var.ENV}-rt")
  location                      = var.REGION
  resource_group_name           = azurerm_resource_group.hub.name

  route {
    name                   = "default"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.azfw.ip_configuration[0].private_ip_address
  }
}


resource "azurerm_subnet_route_table_association" "devops" {
  subnet_id           = azurerm_subnet.devops.id
  route_table_id      = azurerm_route_table.mgmt.id
}

resource "azurerm_subnet_route_table_association" "shared" {
  subnet_id           = azurerm_subnet.shared.id
  route_table_id      = azurerm_route_table.mgmt.id
}

resource "azurerm_subnet_route_table_association" "pe" {
  subnet_id           = azurerm_subnet.pe.id
  route_table_id      = azurerm_route_table.mgmt.id
}

# NSG Definition

 resource "azurerm_network_security_group" "mgmt_nsg" {
   name                  = ("${var.SVC}-mgmt-${var.REGION_ABR}-${var.ENV}-nsg")
   resource_group_name   = azurerm_resource_group.hub.name
   location              = var.REGION

   lifecycle {
     ignore_changes = [tags]
   }
 }


# NSG Association

 resource "azurerm_subnet_network_security_group_association" "nsg-to-devops" {
   subnet_id                 = azurerm_subnet.devops.id
   network_security_group_id = azurerm_network_security_group.mgmt_nsg.id
 }

 resource "azurerm_subnet_network_security_group_association" "nsg-to-shared" {
   subnet_id                 = azurerm_subnet.shared.id
   network_security_group_id = azurerm_network_security_group.mgmt_nsg.id
 }

 resource "azurerm_subnet_network_security_group_association" "nsg-to-pe" {
   subnet_id                 = azurerm_subnet.pe.id
   network_security_group_id = azurerm_network_security_group.mgmt_nsg.id
 }

## Virtual Network Diagnostics
resource "azurerm_monitor_diagnostic_setting" "mgmt_vnet" {
  name               = "diagset-tf"
  target_resource_id = azurerm_virtual_network.mgmt.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.la.id

  enabled_log {
    category_group = "allLogs"
  }

  metric {
    category = "AllMetrics"
  }
}