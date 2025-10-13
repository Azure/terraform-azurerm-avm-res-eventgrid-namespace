mock_provider "azurerm" {}

variables {
  enable_telemetry    = false
  resource_group_name = "test"
  name                = "validName"
  location            = "eastus"
}

run "name_regex_length_long" {
  command = plan

  variables {
    name = "abcdefghijklmnopqrstuvwxy"
  }

  expect_failures = [var.name]
}
