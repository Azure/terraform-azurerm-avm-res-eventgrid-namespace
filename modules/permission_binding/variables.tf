variable "client_group_name" {
  type        = string
  description = "The name of the client group to bind permissions to."
}

variable "location" {
  type        = string
  description = "The Azure region for this module's resources or telemetry deployment."
  nullable    = false
}

variable "name" {
  type        = string
  description = "The name of the Permission Binding."

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{3,50}$", var.name))
    error_message = "The name must be between 3 and 50 characters and can contain only letters, numbers, and hyphens."
  }
}

variable "namespace_id" {
  type        = string
  description = "The resource ID of the EventGrid Namespace."
}

variable "permission" {
  type        = string
  description = "The permission to grant. Possible values: 'Publisher', 'Subscriber'."

  validation {
    condition     = contains(["Publisher", "Subscriber"], var.permission)
    error_message = "Permission must be either 'Publisher' or 'Subscriber'."
  }
}

variable "topic_space_name" {
  type        = string
  description = "The name of the topic space to grant permissions on."
}

variable "description" {
  type        = string
  default     = null
  description = "Description for the Permission Binding resource."
}

variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see <https://aka.ms/avm/telemetryinfo>.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
  nullable    = false
}
