output "name" {
  description = "The name of the namespace topic."
  value       = azapi_resource.namespace_topics.name
}

output "resource_id" {
  description = "The resource ID of the namespace topic."
  value       = azapi_resource.namespace_topics.id
}
