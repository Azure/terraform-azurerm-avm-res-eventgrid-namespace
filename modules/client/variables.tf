variable "authentication_name" {
  type        = string
  description = "The name used for client authentication. This is the identity that will be used in authentication."
}

variable "location" {
  type        = string
  description = "The Azure region for this module's resources or telemetry deployment."
  nullable    = false
}

variable "name" {
  type        = string
  description = "The name of the Client."

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{3,128}$", var.name))
    error_message = "The name must be between 3 and 128 characters and can contain only letters, numbers, and hyphens."
  }
}

variable "namespace_id" {
  type        = string
  description = "The resource ID of the EventGrid Namespace."
}

variable "attributes" {
  type        = map(string)
  default     = {}
  description = "Custom attributes for the client. These can be used in client group queries."
}

variable "client_certificate_authentication" {
  type = object({
    validation_scheme   = string
    allowed_thumbprints = list(string)
  })
  default     = null
  description = "Optional settings for client certificate authentication."
}

variable "description" {
  type        = string
  default     = null
  description = "Description for the Client resource."
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

variable "state" {
  type        = string
  default     = "Enabled"
  description = "The state of the client. Possible values: 'Enabled', 'Disabled'."

  validation {
    condition     = contains(["Enabled", "Disabled"], var.state)
    error_message = "State must be either 'Enabled' or 'Disabled'."
  }
}
