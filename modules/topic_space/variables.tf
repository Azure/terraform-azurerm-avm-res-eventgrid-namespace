variable "name" {
  type        = string
  description = "The name of the Topic Space."

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{3,50}$", var.name))
    error_message = "The name must be between 3 and 50 characters and can contain only letters, numbers, and hyphens."
  }
}

variable "namespace_id" {
  type        = string
  description = "The resource ID of the EventGrid Namespace."
}

variable "topic_templates" {
  type        = list(string)
  description = "The topic filters in the topic space."

  validation {
    condition     = length(var.topic_templates) > 0
    error_message = "At least one topic template must be specified."
  }
}

variable "description" {
  type        = string
  default     = null
  description = "Description for the Topic Space resource."
}
