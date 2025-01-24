
resource "azurerm_virtual_desktop_workspace" "AZURE_VIRTUAL_DESKTOP" {
    name                = var.avd_workspace_name
    location            = var.location
    resource_group_name = var.resource_group_name
    description         = var.avd_workspace_description
    friendly_name       = var.avd_workspace_name
}

resource "azurerm_virtual_desktop_host_pool" "AZURE_VIRTUAL_DESKTOP_HOST_POOL" {
    name                = var.avd_hostpool_name
    location            = var.location
    resource_group_name = var.resource_group_name
    type                = var.host_pool_type
    load_balancer_type  = var.load_balancer_type
    friendly_name       = var.avd_hostpool_name
}

resource "azurerm_virtual_desktop_application_group" "AZURE_VIRTUAL_DESKTOP_APP_GROUP" {
    name                = var.avd_app_group_name
    location            = var.location
    resource_group_name = var.resource_group_name
    type                = var.avd_app_group_type
    host_pool_id        = azurerm_virtual_desktop_host_pool.AZURE_VIRTUAL_DESKTOP_HOST_POOL.id
    friendly_name       = var.avd_app_group_name
}

resource "azurerm_network_interface" "AVD_SESSION_HOST_NIC" {
    name                      = "avd-session-host-nic"
    location                  = var.location
    resource_group_name       = var.resource_group_name
    ip_configuration {
        name                          = "internal"
        subnet_id                     = var.subnet_id
        private_ip_address_allocation = "Dynamic"
    }  
}

resource "azurerm_windows_virtual_machine" "AVD_SESSION_HOST" {
    name                  = "avdsessionhost"
    resource_group_name   = var.resource_group_name
    location              = var.location
    size                  = var.host_vm_size
    admin_username        = var.admin_username
    admin_password        = var.admin_password
    network_interface_ids = [ azurerm_network_interface.AVD_SESSION_HOST_NIC.id ]

    os_disk {
        name                    = "osdisk-${var.host_vm_name}"
        caching                 = "ReadWrite"
        storage_account_type    = "Standard_LRS"
    }

    source_image_reference {
        publisher = "MicrosoftWindowsDesktop"
        offer     = "windows-10"
        sku       = "win10-21h2-avd"
        version   = "latest"
    }
}
