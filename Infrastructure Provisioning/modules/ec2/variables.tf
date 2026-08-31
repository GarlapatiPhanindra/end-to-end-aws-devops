variable "name_prefix" {
	type    = string
	default = "app-template"
}

variable "ami_id" {
	type    = string
	default = "ami-040f52d90f7218c06"
}

variable "instance_type" {
	type    = string
	default = "t3.micro"
}

variable "key_name" {
	type    = string
	default = ""
}

variable "private_subnet_ids" {
	type = list(string)
}

variable "app_sg_id" {
	type = string
}

variable "target_group_arn" {
	type = string
}

variable "asg_min_size" {
	type    = number
	default = 1
}

variable "asg_max_size" {
	type    = number
	default = 2
}

variable "user_data" {
	type    = string
	default = "#!/bin/bash"
}

variable "tags" {
	type    = map(string)
	default = {}
}

variable "instance_profile_arn" {
  type    = string
  default = ""
}
