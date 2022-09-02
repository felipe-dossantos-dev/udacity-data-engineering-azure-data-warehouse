terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = "9e2c9769-06a8-44ac-a6d2-48e35047775a"
  tenant_id       = "1497bba5-45c5-481c-88dc-e1c1aa1526d2"
}

variable "resource_group_name" {
  default = "synapse-learn"
}

output "resource_group_id" {
  value = azurerm_resource_group.synapse_rg.id
}

resource "azurerm_resource_group" "synapse_rg" {
  name     = var.resource_group_name
  location = "brazilsouth"
}

resource "azurerm_storage_account" "synapse_blob" {
  name                     = "synapselearnblob"
  resource_group_name      = azurerm_resource_group.synapse_rg.name
  location                 = azurerm_resource_group.synapse_rg.location
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled           = "true"
}

resource "azurerm_storage_data_lake_gen2_filesystem" "synapse_fs" {
  name               = "synapselearnfs"
  storage_account_id = azurerm_storage_account.synapse_blob.id
}

resource "azurerm_synapse_workspace" "synapse_workspace" {
  name                                 = "synapse-learn-workspace"
  resource_group_name                  = azurerm_resource_group.synapse_rg.name
  location                             = azurerm_resource_group.synapse_rg.location
  storage_data_lake_gen2_filesystem_id = azurerm_storage_data_lake_gen2_filesystem.synapse_fs.id
  sql_administrator_login              = "sqladminuser"
  sql_administrator_login_password     = "H@Sh1CoR3!"
  managed_virtual_network_enabled      = true
  managed_resource_group_name          = "synapse-learn-workspace-rg-managed"

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_synapse_firewall_rule" "synapse_firewall" {
  name                 = "allowAll"
  synapse_workspace_id = azurerm_synapse_workspace.synapse_workspace.id
  start_ip_address     = "0.0.0.0"
  end_ip_address       = "255.255.255.255"

  depends_on = [
    azurerm_synapse_workspace.synapse_workspace
  ]
}

resource "azurerm_synapse_linked_service" "blob_linked_service" {
  name                 = "synapse_learn_blob_linked_service"
  synapse_workspace_id = azurerm_synapse_workspace.synapse_workspace.id
  type                 = "AzureBlobStorage"
  type_properties_json = <<JSON
{
  "connectionString": "${azurerm_storage_account.synapse_blob.primary_connection_string}"
}
JSON

  depends_on = [
    azurerm_synapse_firewall_rule.synapse_firewall,
  ]
}

data "azurerm_client_config" "current" {
}

resource "azurerm_role_assignment" "synapse_role" {
  scope                = azurerm_storage_account.synapse_blob.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_synapse_sql_pool" "default_pool" {
  name                 = "synapse_test_default_pool"
  synapse_workspace_id = azurerm_synapse_workspace.synapse_workspace.id
  sku_name             = "DW100c"
  create_mode          = "Default"
}
