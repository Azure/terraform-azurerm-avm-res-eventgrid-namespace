output "description" {
  description = "The description of the CA Certificate."
  value       = try(jsondecode(azapi_resource.ca_certificate.output).properties.description, null)
}

output "encoded_certificate" {
  description = "The base64 encoded certificate (PEM or DER format)."
  sensitive   = true
  value       = try(jsondecode(azapi_resource.ca_certificate.output).properties.encodedCertificate, null)
}

output "name" {
  description = "The name of the CA Certificate."
  value       = azapi_resource.ca_certificate.name
}

output "resource_id" {
  description = "The resource ID of the CA Certificate."
  value       = azapi_resource.ca_certificate.id
}
