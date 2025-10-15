output "name" {
  description = "The name of the CA Certificate."
  value       = azapi_resource.ca_certificate.name
}

output "resource" {
  description = "The full CA Certificate resource output (sensitive data excluded)."
  sensitive   = true
  value       = azapi_resource.ca_certificate.output
}

output "resource_id" {
  description = "The resource ID of the CA Certificate."
  value       = azapi_resource.ca_certificate.id
}
