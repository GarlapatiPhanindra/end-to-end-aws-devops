variable "name_prefix" {
  type = string
}

variable "tags" {
  type = map(string)
  default = {}
}

variable "log_retention_days" {
  type = number
  default = 14
}

variable "infrastructure_dashboard" {
  type = any
  default = {}
}

variable "application_dashboard" {
  type = any
  default = {}
}
