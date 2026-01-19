variable "encoded_certificate" {
  type        = string
  description = "The base64 encoded PEM (Privacy Enhanced Mail) format certificate data."
  sensitive   = true
}

variable "name" {
  type        = string
  description = "The name of the CA Certificate."

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{3,50}$", var.name))
    error_message = "The name must be between 3 and 50 characters and can contain only letters, numbers, and hyphens."
  }
}

variable "namespace_id" {
  type        = string
  description = "The resource ID of the EventGrid Namespace."
}

variable "description" {
  type        = string
  default     = null
  description = "Description for the CA Certificate resource."
}
