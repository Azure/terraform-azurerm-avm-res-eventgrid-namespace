variable "delivery_mode" {
  type        = string
  description = "Delivery mode: 'Push' or 'Queue'."

  validation {
    condition     = contains(["Push", "Queue"], var.delivery_mode)
    error_message = "Delivery mode must be 'Push' or 'Queue'."
  }
}

variable "name" {
  type        = string
  description = "Name of the event subscription (3-50 characters)."

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{3,50}$", var.name))
    error_message = "Name must be 3-50 characters, alphanumeric and hyphens only."
  }
}

variable "namespace_topic_id" {
  type        = string
  description = "Resource ID of the parent namespace topic."
}

variable "dead_letter_destination" {
  type = object({
    storage_account_id        = string
    blob_container_name       = string
    identity_type             = optional(string, "SystemAssigned")
    user_assigned_identity_id = optional(string)
  })
  default     = null
  description = "Dead letter storage configuration."
}

variable "delivery_identity" {
  type = object({
    type                      = string
    user_assigned_identity_id = optional(string)
  })
  default     = null
  description = "Managed identity for delivery. Type: SystemAssigned or UserAssigned."
}

variable "destination" {
  type = object({
    endpointType = string
    properties   = map(any)
  })
  default     = null
  description = "Push destination configuration (EventHub, ServiceBusQueue, WebHook, etc.)."
}

variable "event_delivery_schema" {
  type        = string
  default     = "CloudEventSchemaV1_0"
  description = "Event delivery schema."
}

variable "event_time_to_live" {
  type        = string
  default     = "P1D"
  description = "Event TTL in ISO 8601 duration format (e.g., P1D, PT1H)."
}

variable "expiration_time_utc" {
  type        = string
  default     = null
  description = "Expiration time in UTC ISO 8601 format."
}

variable "filters_configuration" {
  type = object({
    included_event_types = optional(list(string))
    filters = optional(list(object({
      key           = string
      operator_type = string
      value         = optional(any)
      values        = optional(list(any))
    })))
  })
  default     = null
  description = "Event filtering configuration."
}

variable "max_delivery_count" {
  type        = number
  default     = 30
  description = "Maximum delivery attempts."
}

variable "receive_lock_duration_in_seconds" {
  type        = number
  default     = 60
  description = "Lock duration for Queue mode (60-300 seconds)."

  validation {
    condition     = var.receive_lock_duration_in_seconds >= 60 && var.receive_lock_duration_in_seconds <= 300
    error_message = "Must be between 60 and 300 seconds."
  }
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "Resource tags."
}
