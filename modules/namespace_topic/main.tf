resource "azapi_resource" "namespace_topics" {
  name      = var.name
  parent_id = var.namespace_id
  type      = "Microsoft.EventGrid/namespaces/topics@2025-04-01-preview"
  body = {
    properties = {
      eventRetentionInDays = var.event_retention_in_days
      inputSchema          = var.input_schema
      publisherType        = var.publisher_type
      schemaValidation = var.schema_validation != null ? {
        type       = var.schema_validation.type
        properties = var.schema_validation.properties
      } : null
      autoCreateTopic = var.auto_create_topic
      description     = var.description
    }
  }
  schema_validation_enabled = false
}
