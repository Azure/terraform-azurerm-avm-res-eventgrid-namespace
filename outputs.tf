output "private_endpoints" {
  description = "A map of private endpoints. The map key is the supplied input to var.private_endpoints. The map value is the entire azurerm_private_endpoint resource."
  value       = var.private_endpoints_manage_dns_zone_group ? azurerm_private_endpoint.this_managed_dns_zone_groups : azurerm_private_endpoint.this_unmanaged_dns_zone_groups
}

output "eventgrid_namespace_id" {
  value = azapi_resource.eventgrid_namespace.id
  description = "The ID of the EventGrid Namespace."
}

output "eventgrid_namespace_name" {
  value = azapi_resource.eventgrid_namespace.name
  description = "The name of the EventGrid Namespace."
}

output "eventgrid_namespace_identity" {
  value = azapi_resource.eventgrid_namespace.identity
  description = "The identiy of the EventGrid Namespace."
}

output "eventgrid_namespace_location" {
  value = azapi_resource.eventgrid_namespace.location
  description = "The location of the EventGrid Namespace."
}

output "eventgrid_namespace_tags" {
  value = azapi_resource.eventgrid_namespace.tags
  description = "The tags of the EventGrid Namespace."
}
