output "key_vault_id" {
  value       = azurerm_key_vault.this.id
  description = "Key Vault resource ID"
}

output "key_vault_name" {
  value       = azurerm_key_vault.this.name
  description = "Key Vault name"
}

output "key_vault_uri" {
  value       = azurerm_key_vault.this.vault_uri
  description = "Key Vault DNS URI"
}

output "private_endpoint_id" {
  value       = azurerm_private_endpoint.kv.id
  description = "Private endpoint ID"
}