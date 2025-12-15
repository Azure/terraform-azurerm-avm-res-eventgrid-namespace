variable "capacity" {
  type        = number
  default     = 1
  description = "Capacity / throughput units for the EventGrid Namespace."
}

variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see <https://aka.ms/avm/telemetryinfo>.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
}

variable "inbound_ip_rules" {
  type        = list(object({ ip_mask = string, action = optional(string, "Allow") }))
  default     = []
  description = "Optional inbound IP rules."
}

variable "is_zone_redundant" {
  type        = bool
  default     = false
  description = "Enable zone redundancy."
}

# Managed identities configuration
variable "managed_identities" {
  type = object({
    system_assigned            = bool
    user_assigned_resource_ids = optional(list(string), [])
  })
  default = {
    system_assigned            = true
    user_assigned_resource_ids = []
  }
  description = "Managed identity configuration for the EventGrid Namespace."
}

# Network & security
variable "public_network_access" {
  type        = string
  default     = "Enabled"
  description = "Allow public network access."
}
