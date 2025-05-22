#  # This tf file will define everything needed to configure VPN connections

# # Public IP
# resource "azurerm_public_ip" "vpn-pip-1" {
#   name                = ("${var.SVC}-vpn-${var.REGION_ABR}-${var.ENV}-pip1")
#   location            = var.REGION
#   resource_group_name = azurerm_resource_group.hub.name
#   allocation_method   = "Static"
#   sku                 = "Standard"
#   zones               = [1,2,3]
#   lifecycle {
#     ignore_changes = [tags]
#   }
  
# }


# # VPN Gateway Primary
# resource "azurerm_virtual_network_gateway" "vpn-vgw" {
#   name                = ("${var.SVC}-vpn-${var.REGION_ABR}-${var.ENV}-gw")
#   location            = var.REGION
#   resource_group_name = azurerm_resource_group.hub.name
#   lifecycle {
#     ignore_changes = [tags]
#   }

#   type     = "Vpn"
#   vpn_type = "RouteBased"

#   active_active = false
#   enable_bgp    = false
#   sku           = "VpnGw2AZ"

#   ip_configuration {
#     name                          = "vnetGatewayConfig"
#     public_ip_address_id          = azurerm_public_ip.vpn-pip-1.id
#     private_ip_address_allocation = "Dynamic"
#     subnet_id                     = azurerm_subnet.gateway.id
#   }
# }

# # # Local Gateway's for On-Prem Address Prefixes

# # resource "azurerm_local_network_gateway" "vpn-lgw" {
# #   name                = ("${var.SVC}-vpn-${var.REGION_ABR}-${var.ENV}-lgw01")
# #   resource_group_name = azurerm_resource_group.hub.name
# #   location            = var.REGION
# #   gateway_address     = local.settings.vpn_pip1
# #   address_space       = local.settings.vpn_prefix
# #   lifecycle {
# #     ignore_changes = [tags]
# #   }
# # }

# # resource "azurerm_local_network_gateway" "vpn-lgw2" {
# #   name                = ("${var.SVC}-vpn-${var.REGION_ABR}-${var.ENV}-lgw02")
# #   resource_group_name = azurerm_resource_group.hub.name
# #   location            = var.REGION
# #   gateway_address     = local.settings.vpn_pip2
# #   address_space       = local.settings.vpn_prefix
# #   lifecycle {
# #     ignore_changes = [tags]
# #   }
# # }

# # # On-Prem Connections

# # resource "azurerm_virtual_network_gateway_connection" "vpn-gwconn" {
# #   name                = ("${var.SVC}-vpn-${var.REGION_ABR}-${var.ENV}-gwconn01")
# #   location            = var.REGION
# #   resource_group_name = azurerm_resource_group.hub.name
# #   lifecycle {
# #     ignore_changes = [tags]
# #   }

# #   type                       = "IPsec"
# #   virtual_network_gateway_id = azurerm_virtual_network_gateway.vpn-vgw.id
# #   local_network_gateway_id   = azurerm_local_network_gateway.vpn-lgw.id

# #   shared_key = azurerm_key_vault_secret.vpn_psk.value

# #   ipsec_policy {
# #     ike_encryption = "AES256"
# #     ike_integrity = "SHA256"
# #     dh_group = "DHGroup14"
# #     ipsec_encryption = "AES256"
# #     ipsec_integrity = "SHA256"
# #     pfs_group = "PFS24"
# #     sa_datasize = "102400000"
# #     sa_lifetime = "27000"
# #   }

# # }

# # resource "azurerm_virtual_network_gateway_connection" "vpn-gwconn2" {
# #   name                = ("${var.SVC}-vpn-${var.REGION_ABR}-${var.ENV}-gwconn02")
# #   location            = var.REGION
# #   resource_group_name = azurerm_resource_group.hub.name
# #   lifecycle {
# #     ignore_changes = [tags]
# #   }

# #   type                       = "IPsec"
# #   virtual_network_gateway_id = azurerm_virtual_network_gateway.vpn-vgw.id
# #   local_network_gateway_id   = azurerm_local_network_gateway.vpn-lgw2.id

# #   shared_key = azurerm_key_vault_secret.vpn_psk.value
# #   ipsec_policy {
# #     ike_encryption = "AES256"
# #     ike_integrity = "SHA256"
# #     dh_group = "DHGroup14"
# #     ipsec_encryption = "AES256"
# #     ipsec_integrity = "SHA256"
# #     pfs_group = "PFS24"
# #     sa_datasize = "102400000"
# #     sa_lifetime = "27000"
# #   }
# # }



