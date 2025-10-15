output "name" {
  description = "The name of the Topic Space."
  value       = azapi_resource.topic_space.name
}

output "resource" {
  description = "The full Topic Space resource output."
  value       = azapi_resource.topic_space.output
}

output "resource_id" {
  description = "The resource ID of the Topic Space."
  value       = azapi_resource.topic_space.id
}
