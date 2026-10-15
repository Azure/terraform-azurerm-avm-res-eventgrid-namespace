variable "location" {
  type        = string
  description = "The Azure region for this module's resources or telemetry deployment."
  nullable    = false
}

variable "name" {
  type        = string
  description = "The name of the Client Group."

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{3,50}$", var.name))
    error_message = "The name must be between 3 and 50 characters and can contain only letters, numbers, and hyphens."
  }
}

variable "namespace_id" {
  type        = string
  description = "The resource ID of the EventGrid Namespace."
}

variable "query" {
  type        = string
  description = "The query that defines the Client Group membership."
}

variable "description" {
  type        = string
  default     = null
  description = "Description for the Client Group resource."
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
