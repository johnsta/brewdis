variable "redisRegions" {
  type            = list(string)
  description     = "Regions to deploy Redis Caches into"
}

variable "rgName" {
  type            = string
  description     = "Name of resource group"
}

variable "svcName" {
  type            = string
  description     = "Name of Spring Cloud Service"
}

variable "appName" {
  type            = string
  description     = "Name of Spring Cloud App"
}