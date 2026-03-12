data "azurerm_client_config" "current" {}

data "azurerm_virtual_network" "existing" {
  name                = var.vnet_name
  resource_group_name = var.vnet_resource_group_name
}

data "azurerm_subnet" "private_endpoint" {
  name                 = var.private_endpoint_subnet_name
  virtual_network_name = data.azurerm_virtual_network.existing.name
  resource_group_name  = var.vnet_resource_group_name
}

resource "azurerm_resource_group" "kv" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_key_vault" "this" {
  name                          = var.key_vault_name
  location                      = azurerm_resource_group.kv.location
  resource_group_name           = azurerm_resource_group.kv.name
  tenant_id                     = var.tenant_id
  sku_name                      = lower(var.sku_name)
  soft_delete_retention_days    = var.soft_delete_retention_days
  purge_protection_enabled      = true
  rbac_authorization_enabled    = true
  public_network_access_enabled = false

  network_acls {
    default_action = "Deny"
    bypass         = "None"
  }

  tags = merge(
    var.tags,
    {
      environment = var.environment
      workload    = "keyvault"
    }
  )
}

resource "azurerm_management_lock" "kv" {
  name       = "${var.key_vault_name}-cannot-delete"
  scope      = azurerm_key_vault.this.id
  lock_level = "CanNotDelete"
  notes      = "Protects production vault from accidental deletion."
}

resource "azurerm_private_dns_zone" "kv" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = azurerm_resource_group.kv.name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "kv" {
  name                  = "${var.key_vault_name}-vnet-link"
  resource_group_name   = azurerm_resource_group.kv.name
  private_dns_zone_name = azurerm_private_dns_zone.kv.name
  virtual_network_id    = data.azurerm_virtual_network.existing.id
  registration_enabled  = false
  tags                  = var.tags
}

resource "azurerm_private_endpoint" "kv" {
  name                = "${var.key_vault_name}-pe"
  location            = azurerm_resource_group.kv.location
  resource_group_name = azurerm_resource_group.kv.name
  subnet_id           = data.azurerm_subnet.private_endpoint.id
  tags                = var.tags

  private_service_connection {
    name                           = "${var.key_vault_name}-psc"
    private_connection_resource_id = azurerm_key_vault.this.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.kv.id]
  }
}

resource "azurerm_monitor_diagnostic_setting" "kv" {
  name                       = "${var.key_vault_name}-diag"
  target_resource_id         = azurerm_key_vault.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "AuditEvent"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}


resource "azurerm_role_assignment" "kv_admins" {
  for_each             = toset(var.admin_principal_ids)
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = each.value
}

resource "azurerm_role_assignment" "kv_secrets_officers" {
  for_each             = toset(var.secrets_officer_principal_ids)
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = each.value
}

resource "azurerm_role_assignment" "kv_secrets_users" {
  for_each             = toset(var.secrets_user_principal_ids)
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = each.value
}