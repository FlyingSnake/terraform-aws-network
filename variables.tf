#### General Confing
variable "name_prefix" {
  description = "Resource name prefix"
  type        = string
}
variable "tags" {
  description = "Common resource tags"
  type        = map(string)
}

#### VPC
variable "vpc" {
  type = object({
    name = string
    cidr = string
  })
  validation {
    condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}/[0-9]{1,2}$", var.vpc.cidr))
    error_message = "[var.vpc_cidr] => vpc.cidr is invalid (ex: 10.0.0.0/16)"
  }
}
variable "vpc_option" {
  type = object({
    enable_dns_support   = bool
    enable_dns_hostnames = bool
  })
  default = {
    enable_dns_support   = false
    enable_dns_hostnames = false
  }
}

#### Public Subnets
variable "public_subnets" {
  type = list(object({
    name              = string
    cidr              = string
    availability_zone = string
    nat_gateway       = bool
  }))
  validation {
    condition     = alltrue([for subnet in var.public_subnets : can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}/[0-9]{1,2}$", subnet.cidr))])
    error_message = "[var.public_subnets.cidr] => subnet.cidr is invalid (ex: 10.0.0.0/24)"
  }
  validation {
    condition     = alltrue([for subnet in var.public_subnets : contains(["a", "b", "c", "d", "e", "f"], subnet.availability_zone)])
    error_message = "[var.public_subnets.availability_zone] => Each availability_zone must be in ['a','b','c','d','e','f']"
  }
  validation {
    condition = alltrue([
      for az in toset([for subnet in var.public_subnets : subnet.availability_zone]) :
      length([for subnet in var.public_subnets : subnet if subnet.availability_zone == az && subnet.nat_gateway]) == 1
    ])
    error_message = "[var.public_subnets] => Each availability zone must have exactly one subnet with nat_gateway=true."
  }
}

#### Private Subnets
variable "private_subnets" {
  type = list(object({
    name              = string
    cidr              = string
    availability_zone = string
  }))
  validation {
    condition     = alltrue([for subnet in var.private_subnets : can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}/[0-9]{1,2}$", subnet.cidr))])
    error_message = "[var.private_subnets.cidr] => subnet.cidr is invalid (ex: 10.0.0.0/24)"
  }
  validation {
    condition     = alltrue([for subnet in var.private_subnets : contains(["a", "b", "c", "d", "e", "f"], subnet.availability_zone)])
    error_message = "[var.private_subnets.availability_zone] => Each availability_zone must be in ['a','b','c','d','e','f']"
  }
}


#### Airgapped Subnets
variable "airgapped_subnets" {
  type = list(object({
    name              = string
    cidr              = string
    availability_zone = string
  }))
  validation {
    condition     = alltrue([for subnet in var.airgapped_subnets : can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}/[0-9]{1,2}$", subnet.cidr))])
    error_message = "[var.airgapped_subnets.cidr] => subnet.cidr is invalid (ex: 10.0.0.0/24)"
  }
  validation {
    condition     = alltrue([for subnet in var.airgapped_subnets : contains(["a", "b", "c", "d", "e", "f"], subnet.availability_zone)])
    error_message = "[var.airgapped_subnets.availability_zone] => Each availability_zone must be in ['a','b','c','d','e','f']"
  }
}
