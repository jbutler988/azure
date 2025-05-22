/*

# ########################################
# # Create domain controllers in Availability Zones
# #######################################

locals {
   dc_app_coded_name = "vm-${var.ENV}-mgmt-dc-${var.REGION_ABR}-"
   dc_zones = [1,2,3]
}

resource "random_password" "win_password" {
   length           = 16
   special          = true
   override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azurerm_windows_virtual_machine" "win_az" {
   count                    = local.settings.vm_count
   name                     = format("${local.dc_app_coded_name}%02d", count.index + 1)
   computer_name            = format("vm-${var.ENV}-dc-%02d", count.index + 1)
   resource_group_name      = azurerm_resource_group.dc.name
   location                 = var.REGION
   size                     = local.settings.vm_size1
   admin_username           = "sysuser"
   admin_password           = random_password.win_password.result
   zone                     = element(local.dc_zones,count.index)
   network_interface_ids    = [azurerm_network_interface.win_nic[count.index].id]
   enable_automatic_updates = true
   timezone                 = "Eastern Standard Time"

   lifecycle {
     ignore_changes = [tags]
   }

   boot_diagnostics {
     storage_account_uri = azurerm_storage_account.boot_diag.primary_blob_endpoint
   }

   os_disk {
     caching              = "ReadWrite"
     storage_account_type = "StandardSSD_ZRS"
   }

   source_image_reference {
     publisher = "MicrosoftWindowsServer"
     offer     = "WindowsServer"
     sku       = "2025-Datacenter"
     version   = "latest"
   }
}

resource "azurerm_network_interface" "win_nic" {
   count               = local.settings.vm_count
   name                = format("nic-${var.ENV}-mgmt-dc-${var.REGION_ABR}-%02d", count.index + 1)
   location            = var.REGION
   resource_group_name = azurerm_resource_group.dc.name
   lifecycle {
     ignore_changes = [tags]
   }

   ip_configuration {
     name                          = "nic.ipconfig"
     subnet_id                     = azurerm_subnet.dc.id
     private_ip_address_allocation = "Static"
     private_ip_address            = cidrhost(local.settings.dc_cidr, count.index + 17)
   }
}

resource "azurerm_managed_disk" "dcVM_az-datadisk" {
   count                = var.vm_count
   name                 = format("disk-${var.ENV}-mgmt-dc-${var.REGION_ABR}-%02d", count.index + 1)
   location             = var.REGION
   resource_group_name  = azurerm_resource_group.dc.name
   storage_account_type = "StandardSSD_LRS"
   zone                 = element(local.dc_zones,count.index)
   create_option        = "Empty"
   disk_size_gb         = 40
}

resource "azurerm_virtual_machine_data_disk_attachment" "dcVM_az-dd-attachment" {
   count              = var.vm_count
   managed_disk_id    = azurerm_managed_disk.dcVM_az-datadisk[count.index].id
   virtual_machine_id = azurerm_windows_virtual_machine.win_az[count.index].id
   lun                = "10"
   caching            = "ReadWrite"
}

# resource "azurerm_network_interface_backend_address_pool_association" "dcVM_az_nic_backendpool_assoc" {
#   count                   = var.vm_count
#   network_interface_id    = azurerm_network_interface.nic[count.index].id
#   ip_configuration_name   = "nic.ipconfig"
#   backend_address_pool_id = data.azurerm_lb_backend_address_pool.dc_pool_primary.id
# }
#
# resource "azurerm_backup_protected_vm" "bkup" {
#   count               = var.vm_count
#   resource_group_name = azurerm_resource_group.dc.name
#   recovery_vault_name =
#   source_vm_id        = azurerm_windows_virtual_machine.win_az[count.index].id
#   backup_policy_id    =
# }

resource "azurerm_virtual_machine_extension" "monitor-DependencyAgent" {
   count                      = var.vm_count
   name                       = "DAExtension"
   virtual_machine_id         = azurerm_windows_virtual_machine.win_az[count.index].id
   publisher                  = "Microsoft.Azure.Monitoring.DependencyAgent"
   type                       = "DependencyAgentWindows"
   type_handler_version       = "9.5"
   auto_upgrade_minor_version = true
}

resource "azurerm_virtual_machine_extension" "monitor-agent" {
   count                      = var.vm_count
   name                       = "MonAgentExtension"
   virtual_machine_id         = azurerm_windows_virtual_machine.win_az[count.index].id
   publisher                  = "Microsoft.Azure.Monitor"
   type                       = "AzureMonitorWindowsAgent"
   type_handler_version       = "1.0"
   auto_upgrade_minor_version = true
}

*/