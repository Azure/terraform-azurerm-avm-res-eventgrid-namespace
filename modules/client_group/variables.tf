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
