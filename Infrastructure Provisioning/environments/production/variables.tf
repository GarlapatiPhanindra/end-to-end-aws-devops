variable "region" {
	type    = string
	default = "us-east-1"
}

variable "name_prefix" {
	type    = string
	default = "prod"
}

variable "vpc_cidr" {
	type    = string
	default = "10.20.0.0/16"
}

variable "azs" {
	type    = list(string)
	default = ["us-east-1a","us-east-1b"]
}

variable "public_subnet_cidrs" {
	type    = list(string)
	default = ["10.20.1.0/24","10.20.2.0/24"]
}

variable "private_subnet_cidrs" {
	type    = list(string)
	default = ["10.20.101.0/24","10.20.102.0/24"]
}

variable "instance_type" {
	type    = string
	default = "t3.micro"
}

variable "key_name" {
	type    = string
	default = ""
}

variable "asg_min_size" {
	type    = number
	default = 2
}

variable "asg_max_size" {
	type    = number
	default = 4
}

variable "user_data" {
	type    = string
	default = "#!/bin/bash\nyum update -y"
}

variable "db_name" {
	type    = string
	default = "appdb"
}

variable "db_username" {
	type    = string
	default = "appuser"
}

variable "db_password" {
	type = string
}

variable "db_instance_class" {
	type    = string
	default = "db.t3.small"
}

variable "db_allocated_storage" {
	type    = number
	default = 20
}

variable "allowed_ssh_cidr" {
	type    = string
	default = "203.0.113.0/32"
}

variable "alb_internal" {
	type    = bool
	default = false
}

variable "tags" {
	type    = map(string)
	default = {}
}
