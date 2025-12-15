variable "topic_spaces_configuration" {
  type = object({
    alternative_authentication_name_source          = optional(list(string), [])
    maximum_client_sessions_per_authentication_name = optional(number)
    maximum_session_expiry_in_hours                 = optional(number)
    route_topic_resource_id                         = optional(string)
    dynamic_routing_enrichment                      = optional(list(object({ key = string, value = string })), [])
    static_routing_enrichment                       = optional(list(object({ key = string, value = string })), [])
  })
  default     = null
  description = "(Optional) Topic spaces configuration for EventGrid MQTT/topics."
}
