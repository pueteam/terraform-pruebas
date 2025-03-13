locals {
  config = yamldecode(file("${path.module}/config.yaml"))
}

provider "azurerm" {
  features {}
  subscription_id = "1b2b4279-1eaf-4a9c-a364-b7c6c9df8bcd"
}

provider "azurerm" {
  alias           = "subscriptioncore"
  features       {}
  subscription_id = "e95bd041-e5b4-43ac-943a-e97c59bbb483"
}


module "core" {
  source = "./modules/deployment/core"

  lab_resource_group       = local.config[var.entorno]["resource-group"]
  location                 = local.config.location
  tags                     = local.config.tags
  lab_vnet_name            = local.config[var.entorno]["vnet-name"]
  lab_vnet_address_space   = local.config[var.entorno]["vnet-address-space"]
  core_vnet_name           = local.config.core["vnet-name"]
  core_resource_group      = local.config.core["resource-group"]
  core_vnet_id             = local.config.core["vnet-id"]
  peering_hub_name         = local.config.core["peering-hub-to-spoke-${var.entorno}"]
  gateway_transit_enabled  = local.config["gateway_transit_enabled"]
  peering_spoke_name       = local.config[var.entorno]["peering_spoke_name"]

  providers = {
    azurerm                  = azurerm
    azurerm.subscriptioncore = azurerm.subscriptioncore
  }
}


variable "entorno" {
    default = "lab"
}