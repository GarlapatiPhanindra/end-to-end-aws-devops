variable "vpc_id" {
	type = string
}

variable "allowed_ssh_cidr" {
	type = string
}

variable "name_prefix" {
	type    = string
	default = "e2e"
}

variable "tags" {
	type    = map(string)
	default = {}
}
