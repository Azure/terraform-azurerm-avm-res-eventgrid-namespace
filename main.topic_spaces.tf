module "topic_spaces" {
  source   = "./modules/topic_space"
  for_each = var.topic_spaces

  name            = each.value.name
  namespace_id    = azapi_resource.eventgrid_namespace.id
  topic_templates = each.value.topic_templates
  description     = each.value.description
}
