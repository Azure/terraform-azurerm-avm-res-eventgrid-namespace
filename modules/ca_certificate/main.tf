resource "azapi_resource" "ca_certificate" {
  name      = var.name
  parent_id = var.namespace_id
  type      = "Microsoft.EventGrid/namespaces/caCertificates@2025-04-01-preview"
  body = {
    properties = {
      description        = var.description
      encodedCertificate = var.encoded_certificate
    }
  }
  response_export_values = []
}
