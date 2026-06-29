data "azurerm_subscription" "current" {}

resource "azuread_group" "secops" {
  display_name     = "SecOps-Engineers"
  security_enabled = true
  description      = "Managed via Terraform - Automated Security Incident Response Group."
}

resource "azurerm_role_assignment" "secops_admin" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Security Admin"
  principal_id         = azuread_group.secops.object_id
}