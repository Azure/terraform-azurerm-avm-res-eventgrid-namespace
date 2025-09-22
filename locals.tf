locals {
  managed_identities = {
    system_assigned_user_assigned = (var.managed_identities.system_assigned || length(var.managed_identities.user_assigned_resource_ids) > 0) ? {
      this = {
        type                       = var.managed_identities.system_assigned && length(var.managed_identities.user_assigned_resource_ids) > 0 ? "SystemAssigned, UserAssigned" : length(var.managed_identities.user_assigned_resource_ids) > 0 ? "UserAssigned" : "SystemAssigned"
        user_assigned_resource_ids = var.managed_identities.user_assigned_resource_ids
      }
    } : {}
    system_assigned = var.managed_identities.system_assigned ? {
      this = {
        type = "SystemAssigned"
      }
    } : {}
    user_assigned = length(var.managed_identities.user_assigned_resource_ids) > 0 ? {
      this = {
        type                       = "UserAssigned"
        user_assigned_resource_ids = var.managed_identities.user_assigned_resource_ids
      }
    } : {}
  }
  # All EventGrid Namespace properties organized by category
  eventgrid_properties = {
    # Network & Security properties
    inboundIpRules              = var.inbound_ip_rules
    publicNetworkAccess         = var.public_network_access
    minimumTlsVersionAllowed    = var.minimum_tls_version_allowed
    isZoneRedundant             = var.is_zone_redundant

    # Topic spaces configuration
    topicSpacesConfiguration = var.topic_spaces_configuration != null ? {
     maximumClientSessionsPerAuthenticationName = var.topic_spaces_configuration.maximum_client_sessions_per_authentication_name
     maximumSessionExpiryInHours         = var.topic_spaces_configuration.maximum_session_expiry_in_hours
     routeTopicResourceId                = var.topic_spaces_configuration.route_topic_resource_id

     # Optional client authentication
     clientAuthentication = var.topic_spaces_configuration.alternative_authentication_name_source

     # Optional message routing
     routingEnrichments = {
       dynamic = var.topic_spaces_configuration.dynamic_routing_enrichment
       static  = var.topic_spaces_configuration.static_routing_enrichment
     }
     }: null
  }
  # SKU configuration
  eventgrid_sku = {
    capacity = var.capacity
    name     = var.sku
  }

  # Private endpoint application security group associations.
  # We merge the nested maps from private endpoints and application security group associations into a single map.
  private_endpoint_application_security_group_associations = { for assoc in flatten([
    for pe_k, pe_v in var.private_endpoints : [
      for asg_k, asg_v in pe_v.application_security_group_associations : {
        asg_key         = asg_k
        pe_key          = pe_k
        asg_resource_id = asg_v
      }
    ]
  ]) : "${assoc.pe_key}-${assoc.asg_key}" => assoc }
  role_definition_resource_substring = "/providers/Microsoft.Authorization/roleDefinitions"
}
