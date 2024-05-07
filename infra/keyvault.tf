resource "azurecaf_name" "key_vault" {
  name          = var.environment_name
  resource_type = "azurerm_key_vault"
}

resource "azurerm_key_vault" "application" {
  name                = azurecaf_name.key_vault.result
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = var.location

  tenant_id                  = data.azuread_client_config.current.tenant_id
  soft_delete_retention_days = 90

  sku_name = "standard"
}

resource "azurerm_key_vault_access_policy" "client" {
  key_vault_id = azurerm_key_vault.application.id
  tenant_id    = data.azuread_client_config.current.tenant_id
  object_id    = data.azuread_client_config.current.object_id

  secret_permissions = [
    "Set",
    "Get",
    "List",
    "Delete"
  ]
}

resource "azurerm_key_vault_secret" "database_password" {
  name         = "database-password"
  value        = random_password.password.result
  key_vault_id = azurerm_key_vault.application.id

  depends_on = [ azurerm_key_vault_access_policy.client ]
}

