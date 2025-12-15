output "description" {
  description = "The description of the topic space."
  value       = try(jsondecode(azapi_resource.topic_space.output).properties.description, null)
}

output "name" {
  description = "The name of the Topic Space."
  value       = azapi_resource.topic_space.name
}

output "resource_id" {
  description = "The resource ID of the Topic Space."
  value       = azapi_resource.topic_space.id
}

output "topic_templates" {
  description = "The topic templates defining the topic space."
  value       = try(jsondecode(azapi_resource.topic_space.output).properties.topicTemplates, [])
}
