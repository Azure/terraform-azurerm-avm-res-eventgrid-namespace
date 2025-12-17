mock_provider "azurerm" {}

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
