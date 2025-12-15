terraform {
  required_version = "~> 1.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.21"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

provider "azurerm" {
  features {}
}

module "regions" {
  source  = "Azure/avm-utl-regions/azurerm"
  version = "0.9.0"
}

resource "random_integer" "region_index" {
  max = length(module.regions.regions) - 1
  min = 0
}

resource "random_string" "suffix" {
  length  = 5
  special = false
  upper   = false
}

module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.4.2"
}

resource "azurerm_resource_group" "this" {
  location = module.regions.regions[random_integer.region_index.result].name
  name     = module.naming.resource_group.name_unique
}

locals {
  eventgrid_namespace_name = "egns${random_string.suffix.result}"
}

module "eventgrid_namespace" {
  source = "../../"

  location                   = azurerm_resource_group.this.location
  name                       = local.eventgrid_namespace_name
  parent_id                  = azurerm_resource_group.this.id
  enable_telemetry           = false
  topic_spaces_configuration = var.topic_spaces_configuration
}
