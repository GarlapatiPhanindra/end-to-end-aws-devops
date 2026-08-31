output "alb_dns_name" { value = module.alb.alb_dns_name }
output "rds_endpoint" { value = module.rds.rds_endpoint }
output "asg_name" { value = module.ec2.asg_name }
output "vpc_id" { value = module.vpc.vpc_id }
