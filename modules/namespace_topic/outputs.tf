output "event_retention_in_days" {
  description = "The event retention period in days."
  value       = azapi_resource.namespace_topics.body.properties.eventRetentionInDays
}

output "input_schema" {
  description = "The input schema of the namespace topic (CloudEventSchemaV1_0)."
  value       = try(jsondecode(azapi_resource.namespace_topics.output).properties.inputSchema, null)
}

output "name" {
  description = "The name of the namespace topic."
  value       = azapi_resource.namespace_topics.name
}

output "publisher_type" {
  description = "The publisher type of the namespace topic (Custom)."
  value       = try(jsondecode(azapi_resource.namespace_topics.output).properties.publisherType, null)
}

output "resource_id" {
  description = "The resource ID of the namespace topic."
  value       = azapi_resource.namespace_topics.id
}
