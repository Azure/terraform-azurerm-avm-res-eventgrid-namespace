module "clients" {
  source   = "./modules/client"
  for_each = var.clients

  authentication_name               = each.value.authentication_name
  location                          = var.location
  name                              = each.value.name
  namespace_id                      = azapi_resource.eventgrid_namespace.id
  attributes                        = each.value.attributes
  client_certificate_authentication = each.value.client_certificate_authentication
  description                       = each.value.description
  enable_telemetry                  = var.enable_telemetry
  state                             = each.value.state
}
