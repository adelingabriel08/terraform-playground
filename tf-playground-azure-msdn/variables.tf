variable "resource_group_name" {
  default = "tf-playground"
}

variable "location" {
  type        = string
  default     = "UK South"
  description = "The location where the resources will be provisioned."
}

variable "cosmos_account_name" {
  type        = string
  default     = "tf-cosmos-playground"
  description = "The name of the Cosmos Account"
}

variable "azurerm_cosmosdb_sql_database_name" {
  type        = string
  default     = "Workspace"
  description = "The name of the Cosmos Database"
}

variable "azurerm_cosmosdb_sql_container_name" {
  type        = string
  default     = "WorkspaceSnapshots"
  description = "The name of the Cosmos Container"
}

variable "azurerm_cosmosdb_sql_container_partition_key_path" {
  type        = string
  default     = "/pkey"
  description = "The partition key path of the Cosmos Container"
}

variable "throughput" {
  type        = number
  default     = 400
  description = "Cosmos db database throughput"
  validation {
    condition     = var.throughput >= 400 && var.throughput <= 1000000
    error_message = "Cosmos db manual throughput should be equal to or greater than 400 and less than or equal to 1000000."
  }
  validation {
    condition     = var.throughput % 100 == 0
    error_message = "Cosmos db throughput should be in increments of 100."
  }
}
