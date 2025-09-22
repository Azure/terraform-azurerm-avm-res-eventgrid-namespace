variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see <https://aka.ms/avm/telemetryinfo>.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
}

# Managed identities configuration
variable "managed_identities" {
  type = object({
    system_assigned            = bool
    user_assigned_resource_ids = optional(list(string), [])
  })
  description = "Managed identity configuration for the EventGrid Namespace."
  default = {
    system_assigned            = true
    user_assigned_resource_ids = []
  }
}

# Topic spaces configuration (optional)
variable "topic_spaces_configuration" {
  type = object({
    alternative_authentication_name_source = optional(list(string), [])
    maximum_client_sessions_per_authentication_name = optional(number)
    maximum_session_expiry_in_hours        = optional(number)
    route_topic_resource_id                = optional(string)
    dynamic_routing_enrichment             = optional(list(object({ key = string, value = string })), [])
    static_routing_enrichment              = optional(list(object({ key = string, value = string })), [])
  })
  description = "(Optional) Topic spaces configuration for EventGrid MQTT/topics."
  default = null
}

# Network & security
variable "public_network_access" {
  type        = string
  description = "Allow public network access."
  default     = "Enabled"
}

variable "inbound_ip_rules" {
  type        = list(object({ ip_mask = string, action = optional(string, "Allow") }))
  description = "Optional inbound IP rules."
  default     = []
}

variable "capacity" {
  type        = number
  description = "Capacity / throughput units for the EventGrid Namespace."
  default     = 1
}

variable "is_zone_redundant" {
  type        = bool
  description = "Enable zone redundancy."
  default     = false
}

variable "minimum_tls_version_allowed" {
  type        = string
  description = "Minimum TLS version allowed for connections."
  default     = "1.2"
}
