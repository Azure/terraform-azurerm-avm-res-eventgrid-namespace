resource "azapi_resource" "client_group" {
  name      = var.name
  parent_id = var.namespace_id
  type      = "Microsoft.EventGrid/namespaces/clientGroups@2025-04-01-preview"
  body = {
    properties = {
      description = var.description
      query       = var.query
    }
  }
}
