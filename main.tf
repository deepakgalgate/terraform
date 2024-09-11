terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "trfm-grp" {
  name     = "trfm-grp"
  location = "South india"
  tags = {
    environment = "dev"
  }
}

resource "azurerm_virtual_network" "trfm-vn" {
  name                = "trfm-network"
  resource_group_name = azurerm_resource_group.trfm-grp.name
  location            = azurerm_resource_group.trfm-grp.location
  address_space       = ["10.123.0.0/16"]

  tags = {
    environment = "dev"
  }
}

resource "azurerm_subnet" "trfm-subnet" {
  name                 = "trfm-subnet"
  resource_group_name  = azurerm_resource_group.trfm-grp.name
  virtual_network_name = azurerm_virtual_network.trfm-vn.name
  address_prefixes     = ["10.123.1.0/24"]
}

resource "azurerm_network_security_group" "trfm-sg" {
  name                = "trfm-sg"
  location            = azurerm_resource_group.trfm-grp.location
  resource_group_name = azurerm_resource_group.trfm-grp.name

  security_rule {
    name                       = "rule-1"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "dev"
  }
}