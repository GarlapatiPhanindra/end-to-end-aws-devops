# Example values for staging
region = "us-east-1"
name_prefix = "staging"
vpc_cidr = "10.10.0.0/16"
azs = ["us-east-1a","us-east-1b"]
public_subnet_cidrs = ["10.10.1.0/24","10.10.2.0/24"]
private_subnet_cidrs = ["10.10.101.0/24","10.10.102.0/24"]
instance_type = "t3.micro"
key_name = ""
asg_min_size = 1
asg_max_size = 2
db_password = "REPLACE_WITH_SECURE_PASSWORD"
allowed_ssh_cidr = "203.0.113.0/32"
alb_internal = false
