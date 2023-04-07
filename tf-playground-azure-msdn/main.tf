# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_cosmosdb_account" "cosmos_account" {
  name                      = var.cosmos_account_name
  location                  = var.location
  resource_group_name       = azurerm_resource_group.rg.name
  offer_type                = "Standard"
  kind                      = "GlobalDocumentDB"
  enable_automatic_failover = false
  enable_free_tier          = true
  geo_location {
    location          = var.location
    failover_priority = 0
  }
  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000
  }
  depends_on = [
    azurerm_resource_group.rg
  ]
}

resource "azurerm_cosmosdb_sql_database" "cosmos_database" {
  name                = var.azurerm_cosmosdb_sql_database_name
  resource_group_name = azurerm_resource_group.rg.name
  account_name        = azurerm_cosmosdb_account.cosmos_account.name
  throughput          = var.throughput
}

resource "azurerm_cosmosdb_sql_container" "database_container" {
  name                  = var.azurerm_cosmosdb_sql_container_name
  resource_group_name   = azurerm_resource_group.rg.name
  account_name          = azurerm_cosmosdb_account.cosmos_account.name
  database_name         = azurerm_cosmosdb_sql_database.cosmos_database.name
  partition_key_path    = var.azurerm_cosmosdb_sql_container_partition_key_path
  partition_key_version = 1
  throughput            = var.throughput

  indexing_policy {
    indexing_mode = "consistent"

    included_path {
      path = "/*"
    }

    included_path {
      path = "/included/?"
    }

    excluded_path {
      path = "/excluded/?"
    }
  }
}
