output "name" {
  description = "The name of the Client."
  value       = azapi_resource.client.name
}

output "resource" {
  description = "The full Client resource output."
  value       = azapi_resource.client.output
}

output "resource_id" {
  description = "The resource ID of the Client."
  value       = azapi_resource.client.id
}
