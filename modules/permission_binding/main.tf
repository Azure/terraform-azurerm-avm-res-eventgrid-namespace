resource "azapi_resource" "permission_binding" {
  name      = var.name
  parent_id = var.namespace_id
  type      = "Microsoft.EventGrid/namespaces/permissionBindings@2025-04-01-preview"
  body = {
    properties = {
      description     = var.description
      clientGroupName = var.client_group_name
      topicSpaceName  = var.topic_space_name
      permission      = var.permission
    }
  }
}
