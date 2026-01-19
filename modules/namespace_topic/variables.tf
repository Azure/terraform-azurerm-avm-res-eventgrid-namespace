variable "name" {
  type        = string
  description = "The name of the Namespace Topic."

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{3,50}$", var.name))
    error_message = "The name must be between 3 and 50 characters and can contain only letters, numbers, and hyphens."
  }
}

variable "namespace_id" {
  type        = string
  description = "The resource ID of the EventGrid Namespace."
}

variable "auto_create_topic" {
  type        = bool
  default     = false
  description = "Whether the topic should be automatically created when a matching event is published."
}

variable "description" {
  type        = string
  default     = null
  description = "An optional description for the topic."
}

variable "event_retention_in_days" {
  type        = number
  default     = 7
  description = "Number of days to retain events for this topic."
}

variable "input_schema" {
  type        = string
  default     = "EventGridSchema"
  description = "The input schema for the topic (e.g. EventGridSchema, CloudEventSchemaV1_0, CustomEventSchema)."
}

variable "publisher_type" {
  type        = string
  default     = "Custom"
  description = "The type of publisher for this topic. Allowed values: 'Custom' or 'Microsoft'."
}

variable "schema_validation" {
  type = object({
    type       = string
    properties = map(any)
  })
  default     = null
  description = "Optional schema validation settings."
}
