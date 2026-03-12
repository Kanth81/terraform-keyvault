variable "environment" {
  description = "Environment name such as dev, test, prod"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group where Key Vault resources will be created"
  type        = string
}

variable "vnet_resource_group_name" {
  description = "Resource group containing the VNet"
  type        = string
}

variable "vnet_name" {
  description = "Existing VNet name"
  type        = string
}

variable "private_endpoint_subnet_name" {
  description = "Subnet name for private endpoint"
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics Workspace ID for diagnostic logs"
  type        = string
}

variable "tenant_id" {
  description = "Azure tenant ID"
  type        = string
}

variable "key_vault_name" {
  description = "Globally unique Key Vault name"
  type        = string
}

variable "sku_name" {
  description = "Key Vault SKU: standard or premium"
  type        = string
  default     = "premium"

  validation {
    condition     = contains(["standard", "premium"], lower(var.sku_name))
    error_message = "sku_name must be either standard or premium."
  }
}

variable "soft_delete_retention_days" {
  description = "Retention for soft deleted items"
  type        = number
  default     = 90

  validation {
    condition     = var.soft_delete_retention_days >= 7 && var.soft_delete_retention_days <= 90
    error_message = "Retention days must be between 7 and 90."
  }
}

variable "secrets_user_principal_ids" {
  description = "List of Entra object IDs that should read secrets"
  type        = list(string)
  default     = []
}

variable "secrets_officer_principal_ids" {
  description = "List of Entra object IDs that should manage secrets"
  type        = list(string)
  default     = []
}

variable "admin_principal_ids" {
  description = "List of Entra object IDs that should administer the vault"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}