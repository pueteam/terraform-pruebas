terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
    }
  }
}


# 🔹 Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.lab_resource_group
  location = var.location
  tags     = var.tags
}

# 🔹 Virtual Network (VNet)
resource "azurerm_virtual_network" "vnet" {
  name                = var.lab_vnet_name
  location            = var.location
  resource_group_name = var.lab_resource_group
  address_space       = var.lab_vnet_address_space
  tags                = var.tags
  depends_on = [azurerm_resource_group.rg]
}

# 🔹 VNet Peering (Hub → Spoke)
resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                      = var.peering_hub_name
  virtual_network_name      = var.core_vnet_name
  resource_group_name       = var.core_resource_group
  remote_virtual_network_id = azurerm_virtual_network.vnet.id
  allow_gateway_transit     = var.gateway_transit_enabled
  allow_forwarded_traffic   = var.gateway_transit_enabled
  provider                  = azurerm.subscriptioncore

  depends_on = [azurerm_virtual_network.vnet]
}

# 🔹 VNet Peering (Spoke → Hub)
resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                      = var.peering_spoke_name
  virtual_network_name      = var.lab_vnet_name
  resource_group_name       = var.lab_resource_group
  remote_virtual_network_id = var.core_vnet_id
  use_remote_gateways       = var.gateway_transit_enabled
  provider                  = azurerm

  depends_on = [azurerm_virtual_network.vnet]
}

variable "lab_resource_group" {}
variable "location" {}
variable "tags" {}
variable "lab_vnet_name" {}
variable "lab_vnet_address_space" {}
variable "core_vnet_name" {}
variable "core_resource_group" {}
variable "core_vnet_id" {}
variable "peering_hub_name" {}
variable "peering_spoke_name" {}
variable "gateway_transit_enabled" {}