module "client_groups" {
  source   = "./modules/client_group"
  for_each = var.client_groups

  name             = each.value.name
  namespace_id     = azapi_resource.eventgrid_namespace.id
  query            = each.value.query
  description      = each.value.description
  enable_telemetry = var.enable_telemetry
  location         = var.location
}
