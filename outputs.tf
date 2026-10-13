output "identity" {
  description = "The identity of the EventGrid Namespace."
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
  value       = local.private_endpoints
}

output "resource_id" {
  description = "The resource ID of the Event Grid Namespace."
  value       = azapi_resource.eventgrid_namespace.id
}

output "tags" {
  description = "The tags of the EventGrid Namespace."
  value       = azapi_resource.eventgrid_namespace.tags
}
