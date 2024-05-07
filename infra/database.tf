resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azurecaf_name" "postgresql_server" {
  name          = var.environment_name
  resource_type = "azurerm_postgresql_flexible_server"
}

resource "azurerm_postgresql_flexible_server" "postgresql_database" {
  name                = azurecaf_name.postgresql_server.result
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = var.location

  administrator_login    = "pgadmin"
  administrator_password = random_password.password.result

  sku_name                     = local.postgresql_sku_name
  version                      = "16"

  geo_redundant_backup_enabled = false

  storage_mb = 32768

  authentication {
    active_directory_auth_enabled  = true
    password_auth_enabled          = true # TOD - turn this off
    tenant_id = data.azuread_client_config.current.tenant_id
  }

   lifecycle {
    ignore_changes = [ zone, high_availability.0.standby_availability_zone ]
  }
}

# assign current user as admin to the created DB
resource "azurerm_postgresql_flexible_server_active_directory_administrator" "contoso-ad-admin" {
  server_name         = azurerm_postgresql_flexible_server.postgresql_database.name
  resource_group_name = azurerm_resource_group.resource_group.name
  tenant_id           = data.azuread_client_config.current.tenant_id
  object_id           = data.azuread_client_config.current.object_id
  principal_name      = data.azuread_user.current.user_principal_name 
  principal_type      = "User"
}

resource "azurerm_postgresql_flexible_server_database" "postresql_database" {
  name                = "${var.environment_name}db"
  server_id           = azurerm_postgresql_flexible_server.postgresql_database.id
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "dev_postresql_database_allow_access_rule" {
  name             = "allow-access-from-azure-services"
  server_id        = azurerm_postgresql_flexible_server.postgresql_database.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "local_postresql_database_allow_access_rule" {
  name             = "allow-access-from-local-ip"
  server_id        = azurerm_postgresql_flexible_server.postgresql_database.id
  start_ip_address = local.myip
  end_ip_address   = local.myip
}
