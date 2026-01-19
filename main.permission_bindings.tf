module "permission_bindings" {
  source   = "./modules/permission_binding"
  for_each = var.permission_bindings

  client_group_name = module.client_groups[each.value.client_group_key].name
  name              = each.value.name
  namespace_id      = azapi_resource.eventgrid_namespace.id
  permission        = each.value.permission
  topic_space_name  = module.topic_spaces[each.value.topic_space_key].name
  description       = each.value.description
}
