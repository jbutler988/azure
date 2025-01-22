
# resource "azurerm_public_ip" "bastion" {
#   name                = ("${var.SVC}-bastion-${var.REGION_ABR}-${var.ENV}-pip")
#   location            = var.REGION
#   resource_group_name = azurerm_resource_group.hub.name
#   allocation_method   = "Static"
#   sku                 = "Standard"

#   # tags = {
#   #   "ApplicationOwner" = local.settings.ApplicationOwner
#   #   "Service-Name"     = local.settings.Service-Name
#   #   "Environment"      = var.ENV
#   # }
# }

# # this is the bastion service, tf calls is bastion_host
# resource "azurerm_bastion_host" "bastion" {
#   name                = ("${var.SVC}-${var.REGION_ABR}-${var.ENV}-bastion")
#   location            = var.REGION
#   resource_group_name = azurerm_resource_group.hub.name
#   sku                 = "Standard"
#   scale_units         = 2
#   tunneling_enabled   = true
#   copy_paste_enabled  = true
#   file_copy_enabled   = true

#   ip_configuration {
#     name                 = "bastion_ip_config"
#     subnet_id            = azurerm_subnet.bastion.id
#     public_ip_address_id = azurerm_public_ip.bastion.id
#   }

#   # tags = {
#   #   "ApplicationOwner" = local.settings.ApplicationOwner
#   #   "Service-Name"     = local.settings.Service-Name
#   #   "Environment"      = var.ENV
#   # }
# }