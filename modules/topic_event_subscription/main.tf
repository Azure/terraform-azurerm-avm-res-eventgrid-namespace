resource "azapi_resource" "event_subscription" {
  name      = var.name
  parent_id = var.namespace_topic_id
  type      = "Microsoft.EventGrid/namespaces/topics/eventSubscriptions@2025-04-01-preview"
  body = {
    properties = {
      deliveryConfiguration = {
        deliveryMode = var.delivery_mode

        push = var.delivery_mode == "Push" ? {
          deadLetterDestinationWithResourceIdentity = var.dead_letter_destination != null ? {
            deadLetterDestination = {
              endpointType = "StorageBlob"
              properties = {
                resourceId        = var.dead_letter_destination.storage_account_id
                blobContainerName = var.dead_letter_destination.blob_container_name
              }
            }
            identity = {
              type                 = var.dead_letter_destination.identity_type
              userAssignedIdentity = var.dead_letter_destination.user_assigned_identity_id
            }
          } : null

          deliveryWithResourceIdentity = var.delivery_identity != null ? {
            destination = var.destination
            identity = {
              type                 = var.delivery_identity.type
              userAssignedIdentity = var.delivery_identity.user_assigned_identity_id
            }
          } : null

          destination = var.delivery_identity == null ? var.destination : null

          eventTimeToLive  = var.event_time_to_live
          maxDeliveryCount = var.max_delivery_count
        } : null

        queue = var.delivery_mode == "Queue" ? {
          deadLetterDestinationWithResourceIdentity = var.dead_letter_destination != null ? {
            deadLetterDestination = {
              endpointType = "StorageBlob"
              properties = {
                resourceId        = var.dead_letter_destination.storage_account_id
                blobContainerName = var.dead_letter_destination.blob_container_name
              }
            }
            identity = {
              type                 = var.dead_letter_destination.identity_type
              userAssignedIdentity = var.dead_letter_destination.user_assigned_identity_id
            }
          } : null

          eventTimeToLive              = var.event_time_to_live
          maxDeliveryCount             = var.max_delivery_count
          receiveLockDurationInSeconds = var.receive_lock_duration_in_seconds
        } : null
      }

      eventDeliverySchema = var.event_delivery_schema
      expirationTimeUtc   = var.expiration_time_utc

      filtersConfiguration = var.filters_configuration != null ? {
        filters = var.filters_configuration.filters != null ? [
          for filter in var.filters_configuration.filters : {
            key          = filter.key
            operatorType = filter.operator_type
            value        = try(filter.value, null)
            values       = try(filter.values, null)
          }
        ] : null
        includedEventTypes = var.filters_configuration.included_event_types
      } : null

      tags = var.tags
    }
  }
  response_export_values    = []
  schema_validation_enabled = false
}
