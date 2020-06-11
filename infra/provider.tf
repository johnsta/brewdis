terraform {
  backend "remote" {
    organization = "OSS-integrations"

    workspaces {
      name = "java-demo-dev"
    }
  }
}

provider "azurerm" {
    features {}
}