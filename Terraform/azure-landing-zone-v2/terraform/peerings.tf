

resource "azurerm_virtual_network_peering" "hub-mgmt" {
  name                         = "hub-mgmt-peer"
  resource_group_name          = azurerm_resource_group.hub.name
  virtual_network_name         = azurerm_virtual_network.hub.name
  remote_virtual_network_id    = azurerm_virtual_network.mgmt.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = local.settings.allow_gw_transit
  use_remote_gateways          = false
}

resource "azurerm_virtual_network_peering" "mgmt-hub" {
  #depends_on                   = [azurerm_virtual_network_gateway.vpn-vgw]
  name                         = "mgmt-hub-peer"
  resource_group_name          = azurerm_resource_group.hub.name
  virtual_network_name         = azurerm_virtual_network.mgmt.name
  remote_virtual_network_id    = azurerm_virtual_network.hub.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = true
}


# ## Hub to Spoke Requires Virtual network reader on Spoke RG or subscription
# resource "azurerm_virtual_network_peering" "hub-spoke1" {
#   name                         = "hub-spoke1-peer"
#   resource_group_name          = azurerm_resource_group.hub.name
#   virtual_network_name         = azurerm_virtual_network.hub.name
#   remote_virtual_network_id    = local.settings.spoke1_vnet_id
#   allow_virtual_network_access = true
#   allow_forwarded_traffic      = true
#   allow_gateway_transit        = local.settings.allow_gw_transit
#   use_remote_gateways          = false
# }