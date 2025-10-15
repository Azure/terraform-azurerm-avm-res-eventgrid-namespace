output "name" {
  description = "The name of the Permission Binding."
  value       = azapi_resource.permission_binding.name
}

output "resource" {
  description = "The full Permission Binding resource output."
  value       = azapi_resource.permission_binding.output
}

output "resource_id" {
  description = "The resource ID of the Permission Binding."
  value       = azapi_resource.permission_binding.id
}
