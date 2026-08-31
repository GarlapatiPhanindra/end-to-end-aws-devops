variable "name_prefix" {
	type    = string
	default = "e2e"
}

variable "private_subnet_ids" {
	type = list(string)
}

variable "db_sg_id" {
	type = string
}

variable "db_name" {
	type    = string
	default = "appdb"
}

variable "username" {
	type    = string
	default = "appuser"
}

variable "password" {
	type = string
}

variable "instance_class" {
	type    = string
	default = "db.t3.micro"
}

variable "allocated_storage" {
	type    = number
	default = 20
}

variable "backup_retention" {
	type    = number
	default = 7
}

variable "tags" {
	type    = map(string)
	default = {}
}
