# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.0"
    }
  }
  required_version = ">= 0.14.9"

  backend "azurerm" {
    resource_group_name  = "resource-msa"
    storage_account_name = "terraformstate235"
    container_name       = "terraform"
    key                  = "terraform.tfstate"
    # subscription_id = "233fe509-b301-45fa-afe1-0a36da827a22"
    # tenant_id       = "838496ea-98af-4183-b5ae-f395ecc5080a"
    # client_id       = "c406a1ad-6c4a-4f3c-9f2f-e3cf2992365f"
    # client_secret   = "HTC8Q~.gF5UPV0nRcP2k-flb-AfcZsL9YjEqBb1C"
    subscription_id = "963666b0-eab5-411a-8b3a-b5dc5d4be6e5"
    tenant_id       = "d1b36e95-0d50-42e9-958f-b63fa906beaa"
    client_id       = "ad61c79f-200d-4821-8327-a2b811d5d041"
    client_secret   = "XVi8Q~XDx8UpxKC.TcTM~IJaytVBIs2pnDKOmckV"
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}

  subscription_id = "963666b0-eab5-411a-8b3a-b5dc5d4be6e5"
  tenant_id       = "d1b36e95-0d50-42e9-958f-b63fa906beaa"
  client_id       = "ad61c79f-200d-4821-8327-a2b811d5d041"
  client_secret   = "XVi8Q~XDx8UpxKC.TcTM~IJaytVBIs2pnDKOmckV"
  # subscription_id = "233fe509-b301-45fa-afe1-0a36da827a22"
  # tenant_id       = "838496ea-98af-4183-b5ae-f395ecc5080a"
  # client_id       = "c406a1ad-6c4a-4f3c-9f2f-e3cf2992365f"
  # client_secret   = "HTC8Q~.gF5UPV0nRcP2k-flb-AfcZsL9YjEqBb1C"
}

# Generate a random integer to create a globally unique name
resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

# Create the resource group
# resource "azurerm_resource_group" "rg" {
#   name     = "resource-msa"
#   location = "eastus"
# }

# Create the Linux App Service Plan
resource "azurerm_container_registry" "acr" {
  name                = "crispyregistry"
  resource_group_name = "resource-msa"
  location            = "eastus"
  sku                 = "Standard"
  admin_enabled       = false
}


resource "azurerm_container_group" "containers" {
  name                = "cripsy-frontend-instance"
  location            = "eastus"
  resource_group_name = "resource-msa"
  ip_address_type     = "Public"
  dns_name_label      = "aci-label"
  os_type             = "Linux"

  container {
    name   = "hello-world"
    image  = "mcr.microsoft.com/azuredocs/aci-helloworld:latest"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 443
      protocol = "TCP"
    }
  }

  tags = {
    environment = "testing"
  }
}
