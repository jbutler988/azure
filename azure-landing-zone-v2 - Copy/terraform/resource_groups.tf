
resource "azurerm_resource_group" "hub" {
  name = ("rg-${var.SVC}-hub-${var.REGION_ABR}-${var.ENV}")
  location = var.REGION
  
   lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_resource_group" "shared" {
  name = ("rg-${var.SVC}-shared-${var.REGION_ABR}-${var.ENV}")
  location = var.REGION
  
   lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_resource_group" "dns" {
  name = ("rg-${var.SVC}-dns-${var.REGION_ABR}-${var.ENV}")
  location = var.REGION
  
   lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_resource_group" "logs" {
  name = ("rg-${var.SVC}-logs-${var.REGION_ABR}-${var.ENV}")
  location = var.REGION
  
   lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_resource_group" "devops" {
  name = ("rg-${var.SVC}-devops-${var.REGION_ABR}-${var.ENV}")
  location = var.REGION
  
   lifecycle {
    ignore_changes = [tags]
  }
}
