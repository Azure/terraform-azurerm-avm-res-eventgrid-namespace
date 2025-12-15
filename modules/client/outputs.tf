output "authentication_name" {
  description = "The authentication name of the client."
  value       = try(jsondecode(azapi_resource.client.output).properties.authenticationName, null)
}

output "description" {
  description = "The description of the client."
  value       = try(jsondecode(azapi_resource.client.output).properties.description, null)
}

output "name" {
  description = "The name of the Client."
  value       = azapi_resource.client.name
}

output "resource_id" {
  description = "The resource ID of the Client."
  value       = azapi_resource.client.id
}

output "state" {
  description = "The state of the client (Enabled/Disabled)."
  value       = try(jsondecode(azapi_resource.client.output).properties.state, null)
}
