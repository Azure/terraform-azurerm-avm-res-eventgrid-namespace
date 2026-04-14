module "namespace_topics" {
  source   = "./modules/namespace_topic"
  for_each = var.namespace_topics

  name                    = each.value.name
  namespace_id            = azapi_resource.eventgrid_namespace.id
  event_retention_in_days = each.value.event_retention_days
}
