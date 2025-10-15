output "name" {
  description = "The name of the Client Group."
  value       = azapi_resource.client_group.name
}

output "resource" {
  description = "The full Client Group resource output."
  value       = azapi_resource.client_group.output
}

output "resource_id" {
  description = "The resource ID of the Client Group."
  value       = azapi_resource.client_group.id
}
