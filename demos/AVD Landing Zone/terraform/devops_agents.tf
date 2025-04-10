# ########################################
# # Create devops agents in Availability Zones
# #######################################


locals {
  app_coded_name = ("vm-${var.SVC}-devops-${var.REGION_ABR}-${var.ENV}-")
  zones = [1,2,3]
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azurerm_linux_virtual_machine" "linux_az" {
  depends_on                      = [ azurerm_key_vault.key-vault ]
  count                           = local.settings.devops_vm_count
  name                            = format("${local.app_coded_name}%02s", count.index + 1)
  resource_group_name             = azurerm_resource_group.devops.name
  location                        = var.REGION
  size                            = local.settings.vm_size1
  admin_username                  = "sysuser"
  admin_password                  = random_password.password.result
  zone                            =  element(local.zones,count.index)
  network_interface_ids           = [azurerm_network_interface.nic[count.index].id]
  disable_password_authentication = false

  lifecycle {
    ignore_changes = [
      identity, tags
    ]
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.boot_diag.primary_blob_endpoint
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_ZRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }
}

resource "azurerm_network_interface" "nic" {
  count               = local.settings.devops_vm_count
  name                = format("${local.app_coded_name}.nic%02s", count.index + 1)
  location            = var.REGION
  resource_group_name = azurerm_resource_group.devops.name
  lifecycle {
    ignore_changes = [tags]
  }

  ip_configuration {
    name                          = "nic.ipconfig"
    subnet_id                     = azurerm_subnet.devops.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine_extension" "devops_agent_config" {
  count                = local.settings.devops_vm_count
  name                 = format("${local.app_coded_name}.devopagent%02s", count.index + 1)
  virtual_machine_id   = azurerm_linux_virtual_machine.linux_az[count.index].id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
      "script": "${base64encode(templatefile("${path.module}/ado.sh", { ADO_TOKEN="${azurerm_key_vault_secret.pat.value}", DEVOPS_ORG="${var.DEVOPS_ORG}", AGENT_POOL="${var.AGENT_POOL}" }))}"
    }
  SETTINGS
}
