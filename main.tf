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
    storage_account_name = "terraformstate23"
    container_name       = "terraform"
    key                  = "terraform.tfstate"
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}

  subscription_id = "233fe509-b301-45fa-afe1-0a36da827a22"
  tenant_id       = "838496ea-98af-4183-b5ae-f395ecc5080a"
  client_id       = "c406a1ad-6c4a-4f3c-9f2f-e3cf2992365f"
  client_secret   = "HTC8Q~.gF5UPV0nRcP2k-flb-AfcZsL9YjEqBb1C"
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
resource "azurerm_service_plan" "appserviceplan" {
  name                = "webapp-asp-msa"
  location            = "eastus"
  resource_group_name = "resource-msa"
  os_type             = "Linux"
  sku_name            = "F1"
}

# Create the web app, pass in the App Service Plan ID
resource "azurerm_linux_web_app" "webapp" {
  name                = "webapp-msa-crispy-wings"
  location            = "eastus"
  resource_group_name = "resource-msa"
  service_plan_id     = azurerm_service_plan.appserviceplan.id
  https_only          = true
  site_config {
    minimum_tls_version = "1.2"
  }
}
