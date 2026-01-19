output "description" {
  description = "The description of the client group."
  value       = try(jsondecode(azapi_resource.client_group.output).properties.description, null)
}

output "name" {
  description = "The name of the Client Group."
  value       = azapi_resource.client_group.name
}

output "query" {
  description = "The query used to define client group membership."
  value       = try(jsondecode(azapi_resource.client_group.output).properties.query, null)
}

output "resource_id" {
  description = "The resource ID of the Client Group."
  value       = azapi_resource.client_group.id
}
