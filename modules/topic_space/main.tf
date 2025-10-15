resource "azapi_resource" "topic_space" {
  name      = var.name
  parent_id = var.namespace_id
  type      = "Microsoft.EventGrid/namespaces/topicSpaces@2024-06-01-preview"
  body = {
    properties = {
      description    = var.description
      topicTemplates = var.topic_templates
    }
  }
}
