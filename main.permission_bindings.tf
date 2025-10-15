module "permission_bindings" {
  source   = "./modules/permission_binding"
  for_each = var.permission_bindings

  client_group_name = each.value.client_group_name
  name              = each.value.name
  namespace_id      = azapi_resource.eventgrid_namespace.id
  permission        = each.value.permission
  topic_space_name  = each.value.topic_space_name
  description       = each.value.description

  depends_on = [
    module.client_groups,
    module.topic_spaces
  ]
}
