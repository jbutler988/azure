# DNS Resolvers are only needed in a hybrid connectivity topology. They create endpoints where an on-prem dns forwarder can send requests to.
# Likewise the outbound resolver is to forwarder private dns requests outside of Azure to an on-prem dns server.


resource "azurerm_private_dns_resolver" "private_dns_resolver" {
  name                = ("${var.SVC}-dns-${var.REGION_ABR}-${var.ENV}-res-01")
  location            = var.REGION
  resource_group_name = azurerm_resource_group.dns.name
  virtual_network_id  = azurerm_virtual_network.hub.id
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_private_dns_resolver_inbound_endpoint" "dns_inbound_1" {
  depends_on              = [ azurerm_subnet.dns_1 ]
  name                    = ("${var.SVC}-dns-${var.REGION_ABR}-${var.ENV}-inbound-01")
  private_dns_resolver_id = azurerm_private_dns_resolver.private_dns_resolver.id
  location                = var.REGION
  lifecycle {
    ignore_changes = [tags]
  }

  ip_configurations {
    private_ip_allocation_method = "Dynamic" # Dynamic is default and only supported.
    subnet_id                    = azurerm_subnet.dns_1.id
  }
}

resource "azurerm_private_dns_resolver_inbound_endpoint" "dns_inbound_2" {
  depends_on              = [ azurerm_subnet.dns_2 ]
  name                    = ("${var.SVC}-dns-${var.REGION_ABR}-${var.ENV}-inbound-02")
  private_dns_resolver_id = azurerm_private_dns_resolver.private_dns_resolver.id
  location                = var.REGION
  lifecycle {
    ignore_changes = [tags]
  }

  ip_configurations {
    private_ip_allocation_method = "Dynamic" # Dynamic is default and only supported.
    subnet_id                    = azurerm_subnet.dns_2.id
  }
}


# Outbound Endpoints are only needed if forwarding outside of Azure to another private domain. 
# For example, forwarding traffic to an on-premise domain like contoso.com. Or forwarding to another Clouds domain and dns.

# resource "azurerm_private_dns_resolver_outbound_endpoint" "dns_outbound_1" {
#   depends_on              = [ azurerm_subnet.dns_3 ]
#   name                    = ("${var.SVC}-dns-${var.REGION_ABR}-${var.ENV}-outbound-01")
#   private_dns_resolver_id = azurerm_private_dns_resolver.private_dns_resolver.id
#   location                = var.REGION
#   subnet_id               = azurerm_subnet.dns_3.id
#   lifecycle {
#     ignore_changes = [tags]
#   }
# }

# # Creating one or multiple DNS Resolver Forwarding rulesets, there is currently only support for two DNS forwarding rulesets per outbound endpoint
# resource "azurerm_private_dns_resolver_dns_forwarding_ruleset" "forwarding_ruleset" {
#   depends_on                                 = [ azurerm_private_dns_resolver_outbound_endpoint.dns_outbound_1 ]
#   name                                       = ("${var.SVC}-dns-${var.REGION_ABR}-${var.ENV}-ruleset-01")
#   resource_group_name                        = azurerm_resource_group.dns.name
#   location                                   = var.REGION
#   private_dns_resolver_outbound_endpoint_ids = [azurerm_private_dns_resolver_outbound_endpoint.dns_outbound_1.id]
#   lifecycle {
#     ignore_changes = [tags]
#   }
# }

