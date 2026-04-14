variable "location" {
  type        = string
  description = "Azure region where the EventGrid Namespace will be deployed."
  nullable    = false
}

variable "name" {
  type        = string
  description = "The name of the EventGrid Namespace."

  validation {
    condition     = can(regex("^[a-z0-9]{5,50}$", var.name))
    error_message = "The name must be between 5 and 50 characters long and can only contain lowercase letters and numbers."
  }
}

# This is required for most resource modules
variable "parent_id" {
  type        = string
  description = "The parent resource ID where the EventGrid Namespace will be deployed."
}

variable "ca_certificates" {
  type = map(object({
    name                = string
    description         = optional(string, null)
    encoded_certificate = string
  }))
  default     = {}
  description = <<DESCRIPTION
  (Optional) A map of CA certificates to create in the EventGrid Namespace. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time."
Each object in the map supports the following attributes:
- `name` - (Required) The name of the CA certificate resource.
- `description` - (Optional) A description for the CA certificate.
- `encoded_certificate` - (Required) The base64-encoded CA certificate data.
  DESCRIPTION
}

# Optional basic variables
variable "capacity" {
  type        = number
  default     = 1
  description = "(Optional) Specifies the Capacity / Throughput Units for an Eventgrid Namespace. Valid values can be between 1 and 40."

  validation {
    condition     = var.capacity >= 1 && var.capacity <= 40
    error_message = "Capacity must be between 1 and 40."
  }
}

variable "client_groups" {
  type = map(object({
    name        = string
    description = optional(string, null)
    query       = string
  }))
  default     = {}
  description = <<DESCRIPTION
(Optional) A map of client groups to create in the EventGrid Namespace. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time."
Each object in the map supports the following attributes:
- `name` - (Required) The name of the client group.
- `description` - (Optional) A description for the client group.
- `query` - (Required) The query used to select clients for this client group.
DESCRIPTION
}

variable "clients" {
  type = map(object({
    name                = string
    authentication_name = string
    description         = optional(string, null)
    state               = optional(string, "Enabled")
    client_certificate_authentication = optional(object({
      validation_scheme   = string
      allowed_thumbprints = optional(list(string))
    }), null)
    attributes = optional(map(string), {})
  }))
  default     = {}
  description = <<DESCRIPTION
(Optional) A map of clients to create in the EventGrid Namespace. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time."
Each object in the map supports the following attributes:
- `name` - (Required) The name of the client.
- `authentication_name` - (Required) The name of the authentication method to use for the client.
- `description` - (Optional) A description for the client.
- `state` - (Optional) The state of the client. Defaults to "Enabled".
- `client_certificate_authentication` - (Optional) Client certificate authentication settings.
- `attributes` - (Optional) A map of additional attributes for the client.
DESCRIPTION
}

# required AVM interfaces
# remove only if not supported by the resource
# tflint-ignore: terraform_unused_declarations
variable "customer_managed_key" {
  type = object({
    key_vault_resource_id = string
    key_name              = string
    key_version           = optional(string, null)
    user_assigned_identity = optional(object({
      resource_id = string
    }), null)
  })
  default     = null
  description = <<DESCRIPTION
A map describing customer-managed keys to associate with the resource. This includes the following properties:
- `key_vault_resource_id` - The resource ID of the Key Vault where the key is stored.
- `key_name` - The name of the key.
- `key_version` - (Optional) The version of the key. If not specified, the latest version is used.
- `user_assigned_identity` - (Optional) An object representing a user-assigned identity with the following properties:
  - `resource_id` - The resource ID of the user-assigned identity.
DESCRIPTION
}

variable "diagnostic_settings" {
  type = map(object({
    name                                     = optional(string, null)
    log_categories                           = optional(set(string), [])
    log_groups                               = optional(set(string), ["allLogs"])
    metric_categories                        = optional(set(string), ["AllMetrics"])
    log_analytics_destination_type           = optional(string, "Dedicated")
    workspace_resource_id                    = optional(string, null)
    storage_account_resource_id              = optional(string, null)
    event_hub_authorization_rule_resource_id = optional(string, null)
    event_hub_name                           = optional(string, null)
    marketplace_partner_resource_id          = optional(string, null)
  }))
  default     = {}
  description = <<DESCRIPTION
A map of diagnostic settings to create on the Key Vault. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `name` - (Optional) The name of the diagnostic setting. One will be generated if not set, however this will not be unique if you want to create multiple diagnostic setting resources.
- `log_categories` - (Optional) A set of log categories to send to the log analytics workspace. Defaults to `[]`.
- `log_groups` - (Optional) A set of log groups to send to the log analytics workspace. Defaults to `["allLogs"]`.
- `metric_categories` - (Optional) A set of metric categories to send to the log analytics workspace. Defaults to `["AllMetrics"]`.
- `log_analytics_destination_type` - (Optional) The destination type for the diagnostic setting. Possible values are `Dedicated` and `AzureDiagnostics`. Defaults to `Dedicated`.
- `workspace_resource_id` - (Optional) The resource ID of the log analytics workspace to send logs and metrics to.
- `storage_account_resource_id` - (Optional) The resource ID of the storage account to send logs and metrics to.
- `event_hub_authorization_rule_resource_id` - (Optional) The resource ID of the event hub authorization rule to send logs and metrics to.
- `event_hub_name` - (Optional) The name of the event hub. If none is specified, the default event hub will be selected.
- `marketplace_partner_resource_id` - (Optional) The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic LogsLogs.
DESCRIPTION
  nullable    = false

  validation {
    condition     = alltrue([for _, v in var.diagnostic_settings : contains(["Dedicated", "AzureDiagnostics"], v.log_analytics_destination_type)])
    error_message = "Log analytics destination type must be one of: 'Dedicated', 'AzureDiagnostics'."
  }
  validation {
    condition = alltrue(
      [
        for _, v in var.diagnostic_settings :
        v.workspace_resource_id != null || v.storage_account_resource_id != null || v.event_hub_authorization_rule_resource_id != null || v.marketplace_partner_resource_id != null
      ]
    )
    error_message = "At least one of `workspace_resource_id`, `storage_account_resource_id`, `marketplace_partner_resource_id`, or `event_hub_authorization_rule_resource_id`, must be set."
  }
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

variable "inbound_ip_rules" {
  type = list(object({
    ip_mask = string                    # Required - The IP mask (CIDR) to match on
    action  = optional(string, "Allow") # Optional - The action to take when the rule is matched
  }))
  default     = null
  description = <<DESCRIPTION
(Optional) One or more inbound_ip_rule blocks as defined below.
Each object in the list supports the following attributes:
- `ip_mask` - (Required) The IP mask (CIDR) to match on.
- `action` - (Optional) The action to take when the rule is matched. Possible values are 'Allow' and 'Deny'. Defaults to 'Allow'.
DESCRIPTION
}

variable "lock" {
  type = object({
    kind = string
    name = optional(string, null)
  })
  default     = null
  description = <<DESCRIPTION
Controls the Resource Lock configuration for this resource. The following properties can be specified:

- `kind` - (Required) The type of lock. Possible values are `\"CanNotDelete\"` and `\"ReadOnly\"`.
- `name` - (Optional) The name of the lock. If not specified, a name will be generated based on the `kind` value. Changing this forces the creation of a new resource.
DESCRIPTION

  validation {
    condition     = var.lock != null ? contains(["CanNotDelete", "ReadOnly"], var.lock.kind) : true
    error_message = "The lock level must be one of: 'None', 'CanNotDelete', or 'ReadOnly'."
  }
}

# tflint-ignore: terraform_unused_declarations
variable "managed_identities" {
  type = object({
    system_assigned            = optional(bool, false)
    user_assigned_resource_ids = optional(set(string), [])
  })
  default     = {}
  description = <<DESCRIPTION
Controls the Managed Identity configuration on this resource. The following properties can be specified:

- `system_assigned` - (Optional) Specifies if the System Assigned Managed Identity should be enabled.
- `user_assigned_resource_ids` - (Optional) Specifies a list of User Assigned Managed Identity resource IDs to be assigned to this resource.
DESCRIPTION
  nullable    = false
}

variable "namespace_topics" {
  type = map(object({
    name                 = string
    event_retention_days = optional(number, 7)
  }))
  default     = {}
  description = <<DESCRIPTION
(Optional) A map of namespace topics to create in the EventGrid Namespace. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.
Each object in the map supports the following attributes:
- `name` - (Required) The name of the namespace topic.
- `event_retention_days` - (Optional) The number of days to retain events for the topic. Defaults to 7 days.
DESCRIPTION
}

variable "permission_bindings" {
  type = map(object({
    name             = string
    description      = optional(string, null)
    client_group_key = string
    topic_space_key  = string
    permission       = string
  }))
  default     = {}
  description = <<DESCRIPTION
(Optional) A map of permission bindings to create in the EventGrid Namespace. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.
Each object in the map supports the following attributes:
- `name` - (Required) The name of the permission binding.
- `description` - (Optional) A description for the permission binding.
- `client_group_key` - (Required) The map key of the client group from var.client_groups.
- `topic_space_key` - (Required) The map key of the topic space from var.topic_spaces.
- `permission` - (Required) The permission to grant. Possible values are 'Publisher' and 'Subscriber'.
DESCRIPTION
}

variable "private_endpoints" {
  type = map(object({
    name = optional(string, null)
    role_assignments = optional(map(object({
      role_definition_id_or_name             = string
      principal_id                           = string
      description                            = optional(string, null)
      skip_service_principal_aad_check       = optional(bool, false)
      condition                              = optional(string, null)
      condition_version                      = optional(string, null)
      delegated_managed_identity_resource_id = optional(string, null)
      principal_type                         = optional(string, null)
    })), {})
    lock = optional(object({
      kind = string
      name = optional(string, null)
    }), null)
    tags                                    = optional(map(string), null)
    subnet_resource_id                      = string
    private_dns_zone_group_name             = optional(string, "default")
    private_dns_zone_resource_ids           = optional(set(string), [])
    application_security_group_associations = optional(map(string), {})
    private_service_connection_name         = optional(string, null)
    network_interface_name                  = optional(string, null)
    location                                = optional(string, null)
    resource_group_name                     = optional(string, null)
    ip_configurations = optional(map(object({
      name               = string
      private_ip_address = string
    })), {})
  }))
  default     = {}
  description = <<DESCRIPTION
A map of private endpoints to create on this resource. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `name` - (Optional) The name of the private endpoint. One will be generated if not set.
- `role_assignments` - (Optional) A map of role assignments to create on the private endpoint. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time. See `var.role_assignments` for more information.
- `lock` - (Optional) The lock level to apply to the private endpoint. Default is `None`. Possible values are `None`, `CanNotDelete`, and `ReadOnly`.
- `tags` - (Optional) A mapping of tags to assign to the private endpoint.
- `subnet_resource_id` - The resource ID of the subnet to deploy the private endpoint in.
- `private_dns_zone_group_name` - (Optional) The name of the private DNS zone group. One will be generated if not set.
- `private_dns_zone_resource_ids` - (Optional) A set of resource IDs of private DNS zones to associate with the private endpoint. If not set, no zone groups will be created and the private endpoint will not be associated with any private DNS zones. DNS records must be managed external to this module.
- `application_security_group_resource_ids` - (Optional) A map of resource IDs of application security groups to associate with the private endpoint. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.
- `private_service_connection_name` - (Optional) The name of the private service connection. One will be generated if not set.
- `network_interface_name` - (Optional) The name of the network interface. One will be generated if not set.
- `location` - (Optional) The Azure location where the resources will be deployed. Defaults to the location of the resource group.
- `resource_group_name` - (Optional) The resource group where the resources will be deployed. Defaults to the resource group of this resource.
- `ip_configurations` - (Optional) A map of IP configurations to create on the private endpoint. If not specified the platform will create one. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.
  - `name` - The name of the IP configuration.
  - `private_ip_address` - The private IP address of the IP configuration.
DESCRIPTION
  nullable    = false
}

# This variable is used to determine if the private_dns_zone_group block should be included,
# or if it is to be managed externally, e.g. using Azure Policy.
# https://github.com/Azure/terraform-azurerm-avm-res-keyvault-vault/issues/32
# Alternatively you can use AzAPI, which does not have this issue.
variable "private_endpoints_manage_dns_zone_group" {
  type        = bool
  default     = true
  description = "Whether to manage private DNS zone groups with this module. If set to false, you must manage private DNS zone groups externally, e.g. using Azure Policy."
  nullable    = false
}

# Network configuration
variable "public_network_access" {
  type        = string
  default     = "Enabled"
  description = "(Optional) Whether or not public network access is allowed for this namespace. Defaults to Enabled."

  validation {
    condition     = contains(["Enabled", "Disabled"], var.public_network_access)
    error_message = "Public network access must be Enabled or Disabled."
  }
}

variable "role_assignments" {
  type = map(object({
    role_definition_id_or_name             = string
    principal_id                           = string
    description                            = optional(string, null)
    skip_service_principal_aad_check       = optional(bool, false)
    condition                              = optional(string, null)
    condition_version                      = optional(string, null)
    delegated_managed_identity_resource_id = optional(string, null)
    principal_type                         = optional(string, null)
  }))
  default     = {}
  description = <<DESCRIPTION
A map of role assignments to create on this resource. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `role_definition_id_or_name` - The ID or name of the role definition to assign to the principal.
- `principal_id` - The ID of the principal to assign the role to.
- `description` - The description of the role assignment.
- `skip_service_principal_aad_check` - If set to true, skips the Azure Active Directory check for the service principal in the tenant. Defaults to false.
- `condition` - The condition which will be used to scope the role assignment.
- `condition_version` - The version of the condition syntax. Valid values are '2.0'.
- `delegated_managed_identity_resource_id` - The delegated Azure Resource Id which contains a Managed Identity. Changing this forces a new resource to be created.
- `principal_type` - The type of the principal_id. Possible values are `User`, `Group` and `ServicePrincipal`. Changing this forces a new resource to be created. It is necessary to explicitly set this attribute when creating role assignments if the principal creating the assignment is constrained by ABAC rules that filters on the PrincipalType attribute.

> Note: only set `skip_service_principal_aad_check` to true if you are assigning a role to a service principal.
DESCRIPTION
  nullable    = false
}

variable "sku" {
  type        = string
  default     = "Standard"
  description = "The SKU of the EventGrid Namespace (Standard or Premium)"

  validation {
    condition     = contains(["Standard", "Premium"], var.sku)
    error_message = "The SKU must be either 'Standard' or 'Premium'."
  }
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "(Optional) Tags of the resource."
}

variable "topic_event_subscriptions" {
  type = map(object({
    topic_key                        = string
    name                             = string
    delivery_mode                    = string
    event_delivery_schema            = optional(string, "CloudEventSchemaV1_0")
    expiration_time_utc              = optional(string)
    event_time_to_live               = optional(string, "P1D")
    max_delivery_count               = optional(number, 30)
    receive_lock_duration_in_seconds = optional(number, 60)

    destination = optional(object({
      endpointType = string
      properties   = map(any)
    }))

    delivery_identity = optional(object({
      type                      = string
      user_assigned_identity_id = optional(string)
    }))

    dead_letter_destination = optional(object({
      storage_account_id        = string
      blob_container_name       = string
      identity_type             = optional(string, "SystemAssigned")
      user_assigned_identity_id = optional(string)
    }))

    filters_configuration = optional(object({
      included_event_types = optional(list(string))
      filters = optional(list(object({
        key           = string
        operator_type = string
        value         = optional(any)
        values        = optional(list(any))
      })))
    }))

    tags = optional(map(string), {})
  }))
  default     = {}
  description = <<DESCRIPTION
Map of event subscriptions for namespace topics.
Each object in the map supports the following attributes:
- `topic_key` - (Required) The key of the topic to subscribe to.
- `name` - (Required) The name of the event subscription.
- `delivery_mode` - (Required) The delivery mode for the event subscription. Possible values are `WebHook` and `Queue`.
- `event_delivery_schema` - (Optional) The event delivery schema. Possible values are `CloudEventSchemaV1_0`, `EventGridSchema` and `CustomEventSchema`. Default is `CloudEventSchemaV1_0`.
- `expiration_time_utc` - (Optional) The expiration time of the event subscription in UTC.
- `event_time_to_live` - (Optional) The time to live for events in the event subscription. Default is `P1D`.
- `max_delivery_count` - (Optional) The maximum delivery count for events in the event subscription. Default is `30`.
- `receive_lock_duration_in_seconds` - (Optional) The receive lock duration in seconds for events in the event subscription. Default  is `60`.
- `destination` - (Optional) The destination for the event subscription. This is required if `delivery_identity` is not specified.
  - `endpointType` - (Required) The type of the endpoint. Possible values are `WebHook`, `EventHub`, `StorageQueue`, `ServiceBusQueue`, `ServiceBusTopic` and `HybridConnection`.
  - `properties` - (Required) A map of properties for the endpoint.
- `delivery_identity` - (Optional) The delivery identity for the event subscription. This is required if `destination` is not specified.
  - `type` - (Required) The type of the identity. Possible values are `SystemAssigned`, `UserAssigned` and `SystemAssigned, UserAssigned`.
  - `user_assigned_identity_id` - (Optional) The resource ID of the user assigned identity. This is required if `type` is `UserAssigned` or `SystemAssigned, UserAssigned`.
- `dead_letter_destination` - (Optional) The dead letter destination for the event subscription.
  - `storage_account_id` - (Required) The resource ID of the storage account to use for dead lettering.
  - `blob_container_name` - (Required) The name of the blob container to use for dead lettering.
  - `identity_type` - (Optional) The type of the identity to use for dead lettering. Possible values are `SystemAssigned` and `UserAssigned`. Default is `SystemAssigned`.
  - `user_assigned_identity_id` - (Optional) The resource ID of the user assigned identity to use for dead lettering. This is required if `identity_type` is `UserAssigned`.
- `filters_configuration` - (Optional) The filters configuration for the event subscription.
  - `included_event_types` - (Optional) A list of event types to include in the event subscription.
  - `filters` - (Optional) A list of filters to apply to the event subscription.
    - `key` - (Required) The key of the filter.
    - `operator_type` - (Required) The operator type of the filter. Possible values are `StringEquals`, `StringContains`, `StringBeginsWith`, `StringEndsWith`, `NumberEquals`, `NumberGreaterThan`, `NumberLessThan`, `BoolEquals` and `Advanced`.
    - `value` - (Optional) The value of the filter. Required for all operator types except `Advanced`.
    - `values` - (Optional) A list of values for the filter. Required for the `Advanced` operator type.
- `tags` - (Optional) A map of tags to assign to the event subscription.
DESCRIPTION
  nullable    = false
}

variable "topic_spaces" {
  type = map(object({
    name            = string
    description     = optional(string, null)
    topic_templates = list(string)
  }))
  default     = {}
  description = <<DESCRIPTION
(Optional) A map of topic spaces to create in the EventGrid Namespace. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time."
Each object in the map supports the following attributes:
- `name` - (Required) The name of the topic space.
- `description` - (Optional) A description for the topic space.
- `topic_templates` - (Required) A list of topic templates associated with the topic space.
DESCRIPTION
}

# Topic spaces configuration - simplified without validations
variable "topic_spaces_configuration" {
  type = object({
    alternative_authentication_name_source          = optional(list(string), [])
    maximum_client_sessions_per_authentication_name = optional(number, null)
    maximum_session_expiry_in_hours                 = optional(number, null)
    route_topic_resource_id                         = optional(string, null)
    dynamic_routing_enrichment                      = optional(list(object({ key = string, value = string })), [])
    static_routing_enrichment                       = optional(list(object({ key = string, value = string })), [])
  })
  default     = null
  description = <<DESCRIPTION
(Optional) Topic spaces configuration for MQTT and message routing. The following properties can be specified:
- `alternative_authentication_name_source` - (Optional) A list of alternative authentication name sources.
- `maximum_client_sessions_per_authentication_name` - (Optional) The maximum number of client sessions per authentication name.
- `maximum_session_expiry_in_hours` - (Optional) The maximum session expiry time in hours.
- `route_topic_resource_id` - (Optional) The resource ID of the route topic.
- `dynamic_routing_enrichment` - (Optional) A list of key-value pairs for dynamic routing enrichment.
- `static_routing_enrichment` - (Optional) A list of key-value pairs for static routing enrichment.
DESCRIPTION
}
