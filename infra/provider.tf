terraform {
  backend "remote" {
    organization = "OSS-integrations"

    workspaces {
      name = "java-demo"
    }
  }
}

provider "azurerm" {
    features {}
}