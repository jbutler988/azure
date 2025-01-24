resource "azurerm_storage_account" "STORAGE_ACCOUNT_LOOP" {
    count                    = length(var.storage_account_name)
    name                     = var.storage_account_name[count.index]
    resource_group_name      = var.resource_group_name
    location                 = var.location
    account_tier             = var.storage_account_tier[count.index]
    account_replication_type = var.storage_account_replication_type[count.index]
    account_kind             = var.storage_account_kind[count.index]
}


resource "azurerm_private_endpoint" "STOREAGE_ACCOUNT_PRIVATE_ENDPOINT" {
    count                      = length(var.storage_account_name)
    name                       = "pe-${var.storage_account_name[count.index]}"
    location                   = var.location
    resource_group_name        = var.resource_group_name
    subnet_id                  = var.subnet_id
    private_service_connection {
        name                            = "${var.storage_account_name[count.index]}-private-endpoint-connection"
        private_connection_resource_id  = azurerm_storage_account.STORAGE_ACCOUNT_LOOP[count.index].id
        subresource_names               = ["blob"]
        is_manual_connection            = false
    }
    depends_on = [ azurerm_storage_account.STORAGE_ACCOUNT_LOOP ]  
}
