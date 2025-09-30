output "identity" {
  description = "The identiy of the EventGrid Namespace."
  value       = azapi_resource.eventgrid_namespace.identity
}

output "location" {
  description = "The location of the EventGrid Namespace."
  value       = azapi_resource.eventgrid_namespace.location
}

output "name" {
  description = "The name of the EventGrid Namespace."
  value       = azapi_resource.eventgrid_namespace.name
}

output "private_endpoints" {
  description = "A map of private endpoints. The map key is the supplied input to var.private_endpoints. The map value is the entire azurerm_private_endpoint resource."
  value       = var.private_endpoints_manage_dns_zone_group ? azurerm_private_endpoint.this_managed_dns_zone_groups : azurerm_private_endpoint.this_unmanaged_dns_zone_groups
}

output "resource_id" {
  description = "The resource ID of the Event Grid Namespace."
  value       = azapi_resource.eventgrid_namespace.id
}

output "tags" {
  description = "The tags of the EventGrid Namespace."
  value       = azapi_resource.eventgrid_namespace.tags
}
