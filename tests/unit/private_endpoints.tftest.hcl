mock_provider "azapi" {
  mock_resource "azapi_resource" {
    defaults = {
      id = "/subscriptions/00000000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.EventGrid/namespaces/validname"
    }
  }
  mock_data "azapi_client_config" {
    defaults = {
      subscription_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000"
    }
  }
}

mock_provider "azurerm" {}

variables {
  enable_telemetry = false
  location         = "eastus"
  name             = "validname"
  parent_id        = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg"
}

run "no_private_endpoints_by_default" {
  command = plan

  assert {
    condition = (
      length(azurerm_private_endpoint.this_managed_dns_zone_groups) == 0 &&
      length(azurerm_private_endpoint.this_unmanaged_dns_zone_groups) == 0 &&
      length(azurerm_private_endpoint_application_security_group_association.this) == 0 &&
      length(azurerm_role_assignment.private_endpoints) == 0 &&
      length(azurerm_management_lock.private_endpoints) == 0 &&
      length(output.private_endpoints) == 0
    )
    error_message = "Omitting private endpoints must not create endpoint resources or optional extensions."
  }
}

run "legacy_endpoint_defaults_are_preserved" {
  command = plan

  variables {
    private_endpoints = {
      test = {
        subnet_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/network-rg/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/test-subnet"
        ip_configurations = {
          primary = {
            name               = "legacy-ip"
            private_ip_address = "10.0.0.10"
          }
        }
      }
    }
  }

  assert {
    condition = (
      length(azurerm_private_endpoint.this_managed_dns_zone_groups) == 1 &&
      length(azurerm_private_endpoint.this_unmanaged_dns_zone_groups) == 0 &&
      azurerm_private_endpoint.this_managed_dns_zone_groups["test"].name == "pe-validname" &&
      azurerm_private_endpoint.this_managed_dns_zone_groups["test"].location == "eastus" &&
      azurerm_private_endpoint.this_managed_dns_zone_groups["test"].resource_group_name == "test-rg" &&
      azurerm_private_endpoint.this_managed_dns_zone_groups["test"].private_service_connection[0].name == "pse-validname" &&
      azurerm_private_endpoint.this_managed_dns_zone_groups["test"].private_service_connection[0].subresource_names == tolist(["namespace"]) &&
      azurerm_private_endpoint.this_managed_dns_zone_groups["test"].ip_configuration[0].member_name == "default" &&
      azurerm_private_endpoint.this_managed_dns_zone_groups["test"].ip_configuration[0].subresource_name == "namespace" &&
      length(azurerm_private_endpoint.this_managed_dns_zone_groups["test"].private_dns_zone_group) == 0 &&
      length(azurerm_role_assignment.private_endpoints) == 0 &&
      length(azurerm_management_lock.private_endpoints) == 0
    )
    error_message = "Legacy callers must retain their endpoint address, names, scope, service and IP member defaults."
  }
}

run "managed_endpoint_settings_and_extensions_are_forwarded" {
  command = apply

  variables {
    private_endpoints = {
      target = {
        name                            = "custom-endpoint"
        subnet_resource_id              = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/network-rg/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/test-subnet"
        subresource_name                = "custom-service"
        location                        = "westus"
        resource_group_name             = "endpoint-rg"
        network_interface_name          = "custom-nic"
        private_service_connection_name = "custom-connection"
        private_dns_zone_group_name     = "custom-dns-group"
        private_dns_zone_resource_ids   = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/network-rg/providers/Microsoft.Network/privateDnsZones/privatelink.eventgrid.azure.net"]
        tags                            = { owner = "endpoint" }
        application_security_group_associations = {
          security = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/network-rg/providers/Microsoft.Network/applicationSecurityGroups/endpoint-asg"
        }
        ip_configurations = {
          primary = {
            name               = "custom-ip"
            private_ip_address = "10.0.0.11"
            member_name        = "custom-member"
          }
        }
        lock = {
          kind  = "CanNotDelete"
          name  = "custom-lock"
          notes = "Protect this endpoint."
        }
        role_assignments = {
          reader = {
            name                                   = "11111111-1111-1111-1111-111111111111"
            role_definition_id_or_name             = "/subscriptions/00000000-0000-0000-0000-000000000000/providers/Microsoft.Authorization/roleDefinitions/acdd72a7-3385-48ef-bd42-f606fba81ae7"
            principal_id                           = "22222222-2222-2222-2222-222222222222"
            principal_type                         = "ServicePrincipal"
            description                            = "Endpoint reader."
            skip_service_principal_aad_check       = true
            condition                              = "!(ActionMatches{'Microsoft.Authorization/roleAssignments/write'})"
            condition_version                      = "2.0"
            delegated_managed_identity_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/identity-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/delegated"
          }
        }
      }
    }
  }

  override_resource {
    target = azurerm_private_endpoint.this_managed_dns_zone_groups["target"]
    values = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/endpoint-rg/providers/Microsoft.Network/privateEndpoints/custom-endpoint"
    }
  }

  assert {
    condition = (
      length(azurerm_private_endpoint.this_managed_dns_zone_groups) == 1 &&
      length(azurerm_private_endpoint.this_unmanaged_dns_zone_groups) == 0 &&
      azurerm_private_endpoint.this_managed_dns_zone_groups["target"].name == "custom-endpoint" &&
      azurerm_private_endpoint.this_managed_dns_zone_groups["target"].location == "westus" &&
      azurerm_private_endpoint.this_managed_dns_zone_groups["target"].resource_group_name == "endpoint-rg" &&
      azurerm_private_endpoint.this_managed_dns_zone_groups["target"].custom_network_interface_name == "custom-nic" &&
      azurerm_private_endpoint.this_managed_dns_zone_groups["target"].tags == tomap({ owner = "endpoint" }) &&
      azurerm_private_endpoint.this_managed_dns_zone_groups["target"].private_service_connection[0].name == "custom-connection" &&
      azurerm_private_endpoint.this_managed_dns_zone_groups["target"].private_service_connection[0].subresource_names == tolist(["custom-service"]) &&
      azurerm_private_endpoint.this_managed_dns_zone_groups["target"].ip_configuration[0].member_name == "custom-member" &&
      azurerm_private_endpoint.this_managed_dns_zone_groups["target"].ip_configuration[0].subresource_name == "custom-service" &&
      azurerm_private_endpoint.this_managed_dns_zone_groups["target"].ip_configuration[0].name == "custom-ip" &&
      azurerm_private_endpoint.this_managed_dns_zone_groups["target"].ip_configuration[0].private_ip_address == "10.0.0.11" &&
      azurerm_private_endpoint.this_managed_dns_zone_groups["target"].private_dns_zone_group[0].name == "custom-dns-group" &&
      toset(azurerm_private_endpoint.this_managed_dns_zone_groups["target"].private_dns_zone_group[0].private_dns_zone_ids) == var.private_endpoints["target"].private_dns_zone_resource_ids
    )
    error_message = "Managed endpoints must forward all authored endpoint and DNS settings without creating an unmanaged duplicate."
  }

  assert {
    condition = (
      azurerm_role_assignment.private_endpoints[jsonencode(["target", "reader"])].scope == output.private_endpoints["target"].id &&
      azurerm_role_assignment.private_endpoints[jsonencode(["target", "reader"])].name == "11111111-1111-1111-1111-111111111111" &&
      azurerm_role_assignment.private_endpoints[jsonencode(["target", "reader"])].role_definition_id == var.private_endpoints["target"].role_assignments["reader"].role_definition_id_or_name &&
      azurerm_role_assignment.private_endpoints[jsonencode(["target", "reader"])].principal_id == "22222222-2222-2222-2222-222222222222" &&
      azurerm_role_assignment.private_endpoints[jsonencode(["target", "reader"])].principal_type == "ServicePrincipal" &&
      azurerm_role_assignment.private_endpoints[jsonencode(["target", "reader"])].description == "Endpoint reader." &&
      azurerm_role_assignment.private_endpoints[jsonencode(["target", "reader"])].skip_service_principal_aad_check &&
      azurerm_role_assignment.private_endpoints[jsonencode(["target", "reader"])].condition == var.private_endpoints["target"].role_assignments["reader"].condition &&
      azurerm_role_assignment.private_endpoints[jsonencode(["target", "reader"])].condition_version == "2.0" &&
      azurerm_role_assignment.private_endpoints[jsonencode(["target", "reader"])].delegated_managed_identity_resource_id == var.private_endpoints["target"].role_assignments["reader"].delegated_managed_identity_resource_id
    )
    error_message = "Endpoint role assignments must preserve all supported role assignment fields and target the endpoint, not the namespace."
  }

  assert {
    condition = (
      azurerm_management_lock.private_endpoints["target"].scope == output.private_endpoints["target"].id &&
      azurerm_management_lock.private_endpoints["target"].name == "custom-lock" &&
      azurerm_management_lock.private_endpoints["target"].lock_level == "CanNotDelete" &&
      azurerm_management_lock.private_endpoints["target"].notes == "Protect this endpoint." &&
      azurerm_private_endpoint_application_security_group_association.this["target-security"].private_endpoint_id == output.private_endpoints["target"].id &&
      azurerm_private_endpoint_application_security_group_association.this["target-security"].application_security_group_id == var.private_endpoints["target"].application_security_group_associations["security"]
    )
    error_message = "Endpoint locks and application security group associations must target the selected managed endpoint."
  }
}

run "unmanaged_endpoint_settings_and_extensions_are_forwarded" {
  command = apply

  variables {
    private_endpoints_manage_dns_zone_group = false
    private_endpoints = {
      target = {
        subnet_resource_id            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/network-rg/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/test-subnet"
        subresource_name              = "external-service"
        private_dns_zone_resource_ids = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/network-rg/providers/Microsoft.Network/privateDnsZones/privatelink.eventgrid.azure.net"]
        ip_configurations = {
          primary = {
            name               = "external-ip"
            private_ip_address = "10.0.0.12"
            member_name        = "external-member"
          }
        }
        application_security_group_associations = {
          security = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/network-rg/providers/Microsoft.Network/applicationSecurityGroups/endpoint-asg"
        }
        lock = {
          kind  = "ReadOnly"
          name  = "external-lock"
          notes = "Externally managed DNS."
        }
        role_assignments = {
          reader = {
            role_definition_id_or_name = "Reader"
            principal_id               = "33333333-3333-3333-3333-333333333333"
            principal_type             = "User"
          }
        }
      }
    }
  }

  override_resource {
    target = azurerm_private_endpoint.this_unmanaged_dns_zone_groups["target"]
    values = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/privateEndpoints/external-endpoint"
    }
  }

  assert {
    condition = (
      length(azurerm_private_endpoint.this_managed_dns_zone_groups) == 0 &&
      length(azurerm_private_endpoint.this_unmanaged_dns_zone_groups) == 1 &&
      length(azurerm_private_endpoint.this_unmanaged_dns_zone_groups["target"].private_dns_zone_group) == 0 &&
      azurerm_private_endpoint.this_unmanaged_dns_zone_groups["target"].private_service_connection[0].subresource_names == tolist(["external-service"]) &&
      azurerm_private_endpoint.this_unmanaged_dns_zone_groups["target"].ip_configuration[0].subresource_name == "external-service" &&
      azurerm_private_endpoint.this_unmanaged_dns_zone_groups["target"].ip_configuration[0].member_name == "external-member" &&
      output.private_endpoints["target"].id == azurerm_private_endpoint.this_unmanaged_dns_zone_groups["target"].id
    )
    error_message = "Unmanaged DNS must create only the unmanaged endpoint, forward service/member overrides and leave zone groups external."
  }

  assert {
    condition = (
      azurerm_management_lock.private_endpoints["target"].scope == output.private_endpoints["target"].id &&
      azurerm_management_lock.private_endpoints["target"].lock_level == "ReadOnly" &&
      azurerm_management_lock.private_endpoints["target"].notes == "Externally managed DNS." &&
      azurerm_role_assignment.private_endpoints[jsonencode(["target", "reader"])].scope == output.private_endpoints["target"].id &&
      azurerm_role_assignment.private_endpoints[jsonencode(["target", "reader"])].role_definition_name == "Reader" &&
      azurerm_role_assignment.private_endpoints[jsonencode(["target", "reader"])].principal_type == "User" &&
      !azurerm_role_assignment.private_endpoints[jsonencode(["target", "reader"])].skip_service_principal_aad_check &&
      azurerm_private_endpoint_application_security_group_association.this["target-security"].private_endpoint_id == output.private_endpoints["target"].id
    )
    error_message = "Every optional extension must target the selected unmanaged endpoint and retain omitted role assignment defaults."
  }
}

run "null_service_and_member_use_legacy_defaults" {
  command = plan

  variables {
    private_endpoints_manage_dns_zone_group = false
    private_endpoints = {
      test = {
        subnet_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/network-rg/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/test-subnet"
        subresource_name   = null
        ip_configurations = {
          primary = {
            name               = "legacy-ip"
            private_ip_address = "10.0.0.10"
            member_name        = null
          }
        }
      }
    }
  }

  assert {
    condition = (
      azurerm_private_endpoint.this_unmanaged_dns_zone_groups["test"].private_service_connection[0].subresource_names == tolist(["namespace"]) &&
      azurerm_private_endpoint.this_unmanaged_dns_zone_groups["test"].ip_configuration[0].subresource_name == "namespace" &&
      azurerm_private_endpoint.this_unmanaged_dns_zone_groups["test"].ip_configuration[0].member_name == "default"
    )
    error_message = "Explicitly null overrides must retain legacy service and IP member defaults in the unmanaged branch."
  }
}

run "lock_name_defaults_to_kind" {
  command = plan

  variables {
    private_endpoints = {
      test = {
        subnet_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/network-rg/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/test-subnet"
        lock               = { kind = "ReadOnly" }
      }
    }
  }

  assert {
    condition = (
      azurerm_management_lock.private_endpoints["test"].name == "lock-ReadOnly" &&
      azurerm_management_lock.private_endpoints["test"].notes == null
    )
    error_message = "An endpoint lock must generate its name from kind and permit omitted notes."
  }
}

run "none_lock_creates_no_resource" {
  command = plan

  variables {
    private_endpoints = {
      test = {
        subnet_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/network-rg/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/test-subnet"
        lock               = { kind = "None" }
      }
    }
  }

  assert {
    condition     = length(azurerm_management_lock.private_endpoints) == 0
    error_message = "The documented None lock setting must not create an invalid management lock."
  }
}

run "multiple_roles_are_scoped_to_their_endpoint" {
  command = apply

  variables {
    private_endpoints = {
      first = {
        name               = "first-endpoint"
        subnet_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/network-rg/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/test-subnet"
        role_assignments = {
          reader = {
            role_definition_id_or_name = "Reader"
            principal_id               = "44444444-4444-4444-4444-444444444444"
          }
          contributor = {
            role_definition_id_or_name = "Contributor"
            principal_id               = "55555555-5555-5555-5555-555555555555"
          }
        }
      }
      second = {
        name               = "second-endpoint"
        subnet_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/network-rg/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/test-subnet"
        role_assignments = {
          reader = {
            role_definition_id_or_name = "Reader"
            principal_id               = "66666666-6666-6666-6666-666666666666"
          }
        }
      }
    }
  }

  override_resource {
    target = azurerm_private_endpoint.this_managed_dns_zone_groups["first"]
    values = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/privateEndpoints/first-endpoint"
    }
  }

  override_resource {
    target = azurerm_private_endpoint.this_managed_dns_zone_groups["second"]
    values = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/privateEndpoints/second-endpoint"
    }
  }

  assert {
    condition = (
      length(azurerm_role_assignment.private_endpoints) == 3 &&
      azurerm_role_assignment.private_endpoints[jsonencode(["first", "reader"])].scope == output.private_endpoints["first"].id &&
      azurerm_role_assignment.private_endpoints[jsonencode(["first", "contributor"])].scope == output.private_endpoints["first"].id &&
      azurerm_role_assignment.private_endpoints[jsonencode(["second", "reader"])].scope == output.private_endpoints["second"].id &&
      azurerm_role_assignment.private_endpoints[jsonencode(["first", "reader"])].name != null &&
      azurerm_role_assignment.private_endpoints[jsonencode(["second", "reader"])].name != null
    )
    error_message = "Multiple roles must have independent endpoint scopes and allow the provider to generate omitted assignment names."
  }
}

run "arbitrary_endpoint_and_role_keys_do_not_collide" {
  command = plan

  variables {
    private_endpoints = {
      a-b = {
        name               = "first-endpoint"
        subnet_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/network-rg/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/test-subnet"
        role_assignments = {
          c = {
            role_definition_id_or_name = "Reader"
            principal_id               = "44444444-4444-4444-4444-444444444444"
          }
        }
      }
      a = {
        name               = "second-endpoint"
        subnet_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/network-rg/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/test-subnet"
        role_assignments = {
          b-c = {
            role_definition_id_or_name = "Reader"
            principal_id               = "55555555-5555-5555-5555-555555555555"
          }
        }
      }
    }
  }

  assert {
    condition = (
      length(azurerm_role_assignment.private_endpoints) == 2 &&
      azurerm_role_assignment.private_endpoints[jsonencode(["a-b", "c"])].principal_id == "44444444-4444-4444-4444-444444444444" &&
      azurerm_role_assignment.private_endpoints[jsonencode(["a", "b-c"])].principal_id == "55555555-5555-5555-5555-555555555555"
    )
    error_message = "Arbitrary map keys must not collide when endpoint role assignments are flattened."
  }
}

run "invalid_subnet_resource_id_is_rejected" {
  command = plan

  variables {
    private_endpoints = {
      test = { subnet_resource_id = "not-a-subnet-id" }
    }
  }

  expect_failures = [var.private_endpoints]
}

run "invalid_private_dns_zone_resource_id_is_rejected" {
  command = plan

  variables {
    private_endpoints = {
      test = {
        subnet_resource_id            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/network-rg/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/test-subnet"
        private_dns_zone_resource_ids = ["not-a-private-dns-zone-id"]
      }
    }
  }

  expect_failures = [var.private_endpoints]
}

run "invalid_application_security_group_resource_id_is_rejected" {
  command = plan

  variables {
    private_endpoints = {
      test = {
        subnet_resource_id                      = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/network-rg/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/test-subnet"
        application_security_group_associations = { invalid = "not-an-application-security-group-id" }
      }
    }
  }

  expect_failures = [var.private_endpoints]
}

run "invalid_delegated_identity_resource_id_is_rejected" {
  command = plan

  variables {
    private_endpoints = {
      test = {
        subnet_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/network-rg/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/test-subnet"
        role_assignments = {
          reader = {
            role_definition_id_or_name             = "Reader"
            principal_id                           = "44444444-4444-4444-4444-444444444444"
            delegated_managed_identity_resource_id = "not-a-managed-identity-id"
          }
        }
      }
    }
  }

  expect_failures = [var.private_endpoints]
}
