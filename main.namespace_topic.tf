module "namespace_topics" {
  source   = "./modules/namespace_topic"
  for_each = var.namespace_topics

  location                = var.location
  name                    = each.value.name
  namespace_id            = azapi_resource.eventgrid_namespace.id
  enable_telemetry        = var.enable_telemetry
  event_retention_in_days = try(each.value.event_retention_days, null)
  input_schema            = each.value.input_schema
}
