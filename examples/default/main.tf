terraform {
  required_version = "~> 1.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.21"
    }
    modtm = {
      source  = "azure/modtm"
      version = "~> 0.3"
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


## Section to provide a random Azure region for the resource group
# This allows us to randomize the region for the resource group.
module "regions" {
  source  = "Azure/avm-utl-regions/azurerm"
  version = "~> 0.1"
}

# This allows us to randomize the region for the resource group.
resource "random_integer" "region_index" {
  max = length(module.regions.regions) - 1
  min = 0
}
## End of section to provide a random Azure region for the resource group

# This ensures we have unique CAF compliant names for our resources.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "~> 0.3"
}

# This is required for resource modules
resource "azurerm_resource_group" "this" {
  location = module.regions.regions[random_integer.region_index.result].name
  name     = module.naming.resource_group.name_unique
}

# This is the module call
# Do not specify location here due to the randomization above.
# Leaving location as `null` will cause the module to use the resource group location
# with a data source.
module "eventgrid_namespace" {
  source = "../eventgrid-namespace"

  # Required parameters
  location            = azurerm_resource_group.this.location
  name                = module.naming.eventgrid_namespace.name_unique
  resource_group_name = azurerm_resource_group.this.name

  # Identity configuration
  managed_identities = var.managed_identities

  # Topic spaces configuration (optional)
  topic_spaces_configuration = var.topic_spaces_configuration

  # Network configuration
  public_network_access = var.public_network_access
  inbound_ip_rules      = var.inbound_ip_rules

  # Optional configurations
  capacity                     = var.capacity
  is_zone_redundant            = var.is_zone_redundant
  minimum_tls_version_allowed  = var.minimum_tls_version_allowed

  # Optional telemetry
  enable_telemetry = var.enable_telemetry
}
