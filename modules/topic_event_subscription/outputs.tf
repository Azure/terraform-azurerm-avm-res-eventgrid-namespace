output "delivery_configuration" {
  description = "The delivery configuration of the event subscription."
  value       = try(azapi_resource.event_subscription.output.properties.deliveryConfiguration, null)
}

output "event_delivery_schema" {
  description = "The event delivery schema (CloudEventSchemaV1_0)."
  value       = try(azapi_resource.event_subscription.output.properties.eventDeliverySchema, null)
}

output "filters_configuration" {
  description = "The filters configuration for the event subscription."
  value       = try(azapi_resource.event_subscription.output.properties.filtersConfiguration, null)
}

output "name" {
  description = "The name of the event subscription."
  value       = azapi_resource.event_subscription.name
}

output "resource_id" {
  description = "The resource ID of the event subscription."
  value       = azapi_resource.event_subscription.id
}
