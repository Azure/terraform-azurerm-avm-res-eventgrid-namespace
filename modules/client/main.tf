resource "azapi_resource" "client" {
  name      = var.name
  parent_id = var.namespace_id
  type      = "Microsoft.EventGrid/namespaces/clients@2025-04-01-preview"
  body = {
    properties = {
      authenticationName = var.authentication_name
      description        = var.description
      state              = var.state
      clientCertificateAuthentication = var.client_certificate_authentication != null ? {
        validationScheme   = var.client_certificate_authentication.validation_scheme
        allowedThumbprints = var.client_certificate_authentication.allowed_thumbprints
      } : null
      attributes = var.attributes
    }
  }
  response_export_values = []
}
