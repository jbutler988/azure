resource "azurerm_dns_zone" "DNS_ZONE_LOOP" {
    count                   = length(var.private_dns_zone_names)
    name                    = var.private_dns_zone_names[count.index]
    resource_group_name     = var.resource_group_name
}

resource "azurerm_network_interface" "DOMAIN_CONTROLER_NIC_LOOP" {
    count               = length(var.dc_name)
    name                = "${var.dc_name[count.index]}-nic"
    location            = var.location
    resource_group_name = var.resource_group_name
    ip_configuration {
        name                          = var.dc_name[count.index]
        subnet_id                     = var.subnet_id
        private_ip_address_allocation = "Dynamic"
    }
    depends_on = [ var.subnet_id ]
}

resource "azurerm_virtual_machine" "DOMAIN_CONTROLER_LOOP" {
    count                   = length(var.dc_name)
    name                    = var.dc_name[count.index]
    resource_group_name     = var.resource_group_name
    location                = var.location
    network_interface_ids   = [azurerm_network_interface.DOMAIN_CONTROLER_NIC_LOOP[count.index].id]
    vm_size                 = var.dc_vm_size[count.index]
    delete_os_disk_on_termination = true
    delete_data_disks_on_termination = false
    os_profile {
        computer_name   = var.dc_vm_name[count.index]
        admin_username  = var.dc_admin_username
        admin_password  = var.dc_admin_password
    }
    os_profile_windows_config {
        provision_vm_agent = true
    }
    storage_image_reference {
        publisher = var.domain_controller_image_publisher
        offer     = var.domain_controller_image_offer
        sku       = var.domain_controller_image_sku
        version   = var.domain_controller_image_version
    }
    storage_os_disk {
        name              = "${var.dc_name[count.index]}-os-disk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = var.managed_disk_type
    }
    depends_on  = [ var.subnet_id ]
    }
