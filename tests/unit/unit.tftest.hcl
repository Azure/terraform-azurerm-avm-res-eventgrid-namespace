mock_provider "azurerm" {}
mock_provider "azapi" {}

variables {
  enable_telemetry = false
  parent_id        = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg"
  name             = "validname"
  location         = "eastus"
}

run "name_too_long" {
  command = plan

  variables {
    name = "abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz"
  }

  expect_failures = [var.name]
}

run "name_too_short" {
  command = plan

  variables {
    name = "abc"
  }

  expect_failures = [var.name]
}

run "name_invalid_chars_hyphen" {
  command = plan

  variables {
    name = "invalid-name"
  }

  expect_failures = [var.name]
}

run "name_valid_minimum_length" {
  command = plan

  variables {
    name = "abcde"
  }
}

run "name_valid_maximum_length" {
  command = plan

  variables {
    name = "abcdefghijklmnopqrstuvwxyz012345678901234567890123"
  }
}

run "namespace_topic_event_retention_is_passed_through" {
  command = plan

  variables {
    namespace_topics = {
      notifications = {
        name                 = "notifications-topic"
        event_retention_days = 3
      }
    }
  }

  assert {
    condition     = module.namespace_topics["notifications"].event_retention_in_days == 3
    error_message = "Expected namespace topic event retention to be 3 days."
  }
}
