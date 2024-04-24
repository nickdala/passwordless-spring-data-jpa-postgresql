resource "azurecaf_name" "app_service_plan" {
  name          = var.environment_name
  resource_type = "azurerm_app_service_plan"
}

resource "azurerm_service_plan" "application" {
  location            = var.location
  name                = azurecaf_name.app_service_plan.result
  resource_group_name = azurerm_resource_group.resource_group.name
  sku_name            = "P1v3"
  os_type             = "Linux"
}


resource "azurecaf_name" "app_service" {
  name          = var.environment_name
  resource_type = "azurerm_app_service"
}

resource "azurerm_linux_web_app" "application" {
  location            = var.location
  name                = azurecaf_name.app_service.result
  resource_group_name = azurerm_resource_group.resource_group.name
  service_plan_id     = azurerm_service_plan.application.id

  identity {
    type = "SystemAssigned"
  }

  site_config {
    application_stack {
      java_server = "JAVA"
      java_server_version = "17"
      java_version = "17"
    }

  }

  app_settings = {
  }
}

resource "azurerm_app_service_connection" "application" {
  name               = "example_serviceconnector"
  app_service_id     = azurerm_linux_web_app.application.id
  target_resource_id = azurerm_postgresql_flexible_server_database.postresql_database.id
  authentication {
    type = "systemAssignedIdentity"
  }
  client_type = "springBoot"
}
