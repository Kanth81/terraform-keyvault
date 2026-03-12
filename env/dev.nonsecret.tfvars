environment                  = "dev"
location                     = "westeurope"
resource_group_name          = "rg-dev-shared-keyvault"
vnet_resource_group_name     = "rg-dev-network"
vnet_name                    = "vnet-dev-core"
private_endpoint_subnet_name = "snet-private-endpoints"
key_vault_name               = "kv-dev-shared-01"

tags = {
  owner       = "platform-team"
  environment = "dev"
}
