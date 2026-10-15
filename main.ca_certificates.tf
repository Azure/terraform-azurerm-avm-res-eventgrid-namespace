module "ca_certificates" {
  source   = "./modules/ca_certificate"
  for_each = var.ca_certificates

  encoded_certificate = each.value.encoded_certificate
  location            = var.location
  name                = each.value.name
  namespace_id        = azapi_resource.eventgrid_namespace.id
  description         = each.value.description
  enable_telemetry    = var.enable_telemetry
}
