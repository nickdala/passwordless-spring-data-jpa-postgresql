terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.100.0"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "1.2.26"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    } 
  }
}

resource "azurecaf_name" "resource_group" {
  name          = var.environment_name
  resource_type = "azurerm_resource_group"
}

resource "azurerm_resource_group" "resource_group" {
  name     = azurecaf_name.resource_group.result
  location = var.location
}