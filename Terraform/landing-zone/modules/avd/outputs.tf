output "vm_ids" {
    description = "The IDs of the virtual machines"
    value       = azurerm_windows_virtual_machine.AVD_SESSION_HOST.id
}

output "avd_workspace_id" {
    description = "The ID of the Azure Virtual Desktop workspace"
    value       = azurerm_virtual_desktop_workspace.AZURE_VIRTUAL_DESKTOP.id
}

output "avd_host_pool_id" {
    description = "The ID of the Azure Virtual Desktop host pool"
    value       = azurerm_virtual_desktop_host_pool.AZURE_VIRTUAL_DESKTOP_HOST_POOL.id
}

output "avd_app_group_id" {
    description = "The ID of the Azure Virtual Desktop application group"
    value       = azurerm_virtual_desktop_application_group.AZURE_VIRTUAL_DESKTOP_APP_GROUP.id
}

output "avd_session_host_nic_id" {
    description = "The ID of the network interface for the AVD session host"
    value       = azurerm_network_interface.AVD_SESSION_HOST_NIC.id
}

output "avd_session_host_vm_id" {
    description = "The ID of the AVD session host virtual machine"
    value       = azurerm_windows_virtual_machine.AVD_SESSION_HOST.id
}
