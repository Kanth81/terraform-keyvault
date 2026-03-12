environment                  = "prod"
location                     = "westeurope"
resource_group_name          = "rg-prod-shared-keyvault"
vnet_resource_group_name     = "rg-prod-network"
vnet_name                    = "vnet-prod-core"
private_endpoint_subnet_name = "snet-private-endpoints"
key_vault_name               = "kv-prod-shared-01"

tags = {
  owner       = "platform-team"
  environment = "prod"
}
