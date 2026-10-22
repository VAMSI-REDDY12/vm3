variable "resource_group_name" {
  type    = string
  default = "task3-rg"
}

variable "location" {
  type    = string
  default = "East US 2"
}

variable "admin_username" {
  type    = string
  default = "azureadmin"
}

variable "admin_password" {
  type      = string
  sensitive = true
}
