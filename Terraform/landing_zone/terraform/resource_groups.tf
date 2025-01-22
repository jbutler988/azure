
resource "azurerm_resource_group" "hub" {
  name = ("${var.SVC}-conn-${var.REGION_ABR}-${var.ENV}-rg")
  location = var.REGION
  
   lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_resource_group" "shared" {
  name = ("${var.SVC}-shared-${var.REGION_ABR}-${var.ENV}-rg")
  location = var.REGION
  
   lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_resource_group" "dns" {
  name = ("${var.SVC}-dns-${var.REGION_ABR}-${var.ENV}-rg")
  location = var.REGION
  
   lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_resource_group" "logs" {
  name = ("${var.SVC}-logs-${var.REGION_ABR}-${var.ENV}-rg")
  location = var.REGION
  
   lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_resource_group" "devops" {
  name = ("${var.SVC}-devops-${var.REGION_ABR}-${var.ENV}-rg")
  location = var.REGION
  
   lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_resource_group" "dev_devops" {
  name = ("${var.SVC}-dev-devops-${var.REGION_ABR}-${var.ENV}-rg")
  location = var.REGION
  
  lifecycle {
    ignore_changes = [tags]
  }
}