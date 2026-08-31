variable "name_prefix" {
	type    = string
	default = "e2e"
}

variable "vpc_id" {
	type = string
}

variable "subnet_ids" {
	type = list(string)
}

variable "alb_sg_id" {
	type = string
}

variable "internal" {
	type    = bool
	default = false
}

variable "target_port" {
	type    = number
	default = 80
}

variable "tags" {
	type    = map(string)
	default = {}
}
