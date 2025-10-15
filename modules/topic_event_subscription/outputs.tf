output "name" {
  description = "The name of the event subscription."
  value       = azapi_resource.event_subscription.name
}

output "resource" {
  description = "The full event subscription resource."
  value       = azapi_resource.event_subscription.output
}

output "resource_id" {
  description = "The resource ID of the event subscription."
  value       = azapi_resource.event_subscription.id
}
