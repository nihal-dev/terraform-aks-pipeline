resource "azurerm_resource_group" "az-rg-101-Training" {
  name     = var.rg_name
  location = var.location
  tags = {
    Email   = var.email
    Owner   = var.owner
    Purpose = var.purpose
    Client  = var.client
  }
}