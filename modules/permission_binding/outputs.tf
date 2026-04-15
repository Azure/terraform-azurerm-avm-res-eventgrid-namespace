output "client_group_name" {
  description = "The client group name associated with this permission binding."
  value       = try(azapi_resource.permission_binding.output.properties.clientGroupName, null)
}

output "description" {
  description = "The description of the permission binding."
  value       = try(azapi_resource.permission_binding.output.properties.description, null)
}

output "name" {
  description = "The name of the Permission Binding."
  value       = azapi_resource.permission_binding.name
}

output "permission" {
  description = "The permission granted (Publisher/Subscriber)."
  value       = try(azapi_resource.permission_binding.output.properties.permission, null)
}

output "resource_id" {
  description = "The resource ID of the Permission Binding."
  value       = azapi_resource.permission_binding.id
}

output "topic_space_name" {
  description = "The topic space name associated with this permission binding."
  value       = try(azapi_resource.permission_binding.output.properties.topicSpaceName, null)
}
