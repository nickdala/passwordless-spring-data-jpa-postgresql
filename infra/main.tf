terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.107.0"
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

# Access client_id, tenant_id, subscription_id and object_id configuration values
data "azuread_client_config" "current" {}

data "azuread_user" "current" {
  object_id = data.azuread_client_config.current.object_id
}

data "http" "myip" {
  url = "https://api.ipify.org"
}


locals {
  postgresql_sku_name = "GP_Standard_D4s_v3"
  myip = chomp(data.http.myip.response_body)
}


resource "azurecaf_name" "resource_group" {
  name          = var.environment_name
  resource_type = "azurerm_resource_group"
}

resource "azurerm_resource_group" "resource_group" {
  name     = azurecaf_name.resource_group.result
  location = var.location
}

# Run the scrip locally to set up service connector
#resource "local-exec" "service_connector" {
#  command = "az webapp connection create postgres-flexible --connection postgresql_05019 --source-id /subscriptions/a1fe858c-e1c9-4131-8937-14ef521502fd/resourceGroups/rg-nick-pass7/providers/Microsoft.Web/sites/app-nick-pass7 --target-id /subscriptions/a1fe858c-e1c9-4131-8937-14ef521502fd/resourceGroups/rg-nick-pass7/providers/Microsoft.DBforPostgreSQL/flexibleServers/psqlf-nick-pass7/databases/nick-pass7db --client-type springBoot --system-identity"

  # az login --service-principal -u ${data.azuread_client_config.current.client_id} -p ${var.client_secret} --tenant ${data.azuread_client_config.current.tenant_id} && az service-connector create --service main --provider Microsoft.DBforPostgreSQL --service-name ${azurerm_postgresql_flexible_server.postgresql_database.name} --resource-group ${azurerm_resource_group.resource_group.name}"
#}


resource "null_resource" "service_connector" {
  #triggers = {
  #  always_run = "${timestamp()}"
  #}

  provisioner "local-exec" {
    command = "bash ./scripts/setup-service-connector.sh ${azurerm_linux_web_app.application.id} ${azurerm_postgresql_flexible_server_database.postresql_database.id}"
  }

  depends_on = [
    azurerm_linux_web_app.application,
    azurerm_postgresql_flexible_server_database.postresql_database,
    azurerm_postgresql_flexible_server_active_directory_administrator.contoso-ad-admin
  ]
}
