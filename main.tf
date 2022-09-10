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
    subscription_id = TF_VAR_subscriptionId
    tenant_id       = TF_VAR_tenantId
    client_id       = TF_VAR_clientId
    client_secret   = TF_VAR_client_secret
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}

  subscription_id = TF_VAR_subscriptionId
  tenant_id       = TF_VAR_tenantId
  client_id       = TF_VAR_clientId
  client_secret   = TF_VAR_client_secret
}

# Create the Linux App Service Plan
resource "azurerm_container_registry" "acr" {
  name                = "crispyregistry"
  resource_group_name = "resource-msa"
  location            = "eastus"
  sku                 = "Standard"
  admin_enabled       = true
}

# Create the Linux App Service Plan
resource "azurerm_service_plan" "appserviceplan" {
  name                = "webapp-asp-crispy-msa"
  location            = "eastus"
  resource_group_name = "resource-msa"
  os_type             = "Linux"
  sku_name            = "F1"
}

# Create the web app, pass in the App Service Plan ID
resource "azurerm_linux_web_app" "webapp" {
  name                = "webapp-msa-crispy-frontend-wings"
  location            = "eastus"
  resource_group_name = "resource-msa"
  service_plan_id     = azurerm_service_plan.appserviceplan.id
  https_only          = true
  site_config {
    minimum_tls_version = "1.2"
    always_on=false
  }
}

# Create the web app, pass in the App Service Plan ID
resource "azurerm_linux_web_app" "webapp-backend" {
  name                = "webapp-msa-crispy-backend-wings"
  location            = "eastus"
  resource_group_name = "resource-msa"
  service_plan_id     = azurerm_service_plan.appserviceplan.id
  https_only          = true
  site_config {
    minimum_tls_version = "1.2"
    always_on=false
  }
}
