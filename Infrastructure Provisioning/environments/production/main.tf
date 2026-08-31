provider "aws" {
  region = var.region
}

data "aws_ami" "amzn2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

module "vpc" {
  source = "../../modules/vpc"
  name_prefix = var.name_prefix
  vpc_cidr = var.vpc_cidr
  azs = var.azs
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  tags = var.tags
}

module "sg" {
  source = "../../modules/security-groups"
  vpc_id = module.vpc.vpc_id
  allowed_ssh_cidr = var.allowed_ssh_cidr
  name_prefix = var.name_prefix
  tags = var.tags
}

module "alb" {
  source = "../../modules/alb"
  name_prefix = var.name_prefix
  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnet_ids
  alb_sg_id = module.sg.alb_sg_id
  internal = var.alb_internal
  tags = var.tags
}

module "rds" {
  source = "../../modules/rds"
  name_prefix = var.name_prefix
  private_subnet_ids = module.vpc.private_subnet_ids
  db_sg_id = module.sg.db_sg_id
  db_name = var.db_name
  username = var.db_username
  password = random_password.db_password.result
  instance_class = var.db_instance_class
  allocated_storage = var.db_allocated_storage
  tags = var.tags
}

resource "random_password" "db_password" {
  length           = 20
  override_special = "@%+--_#"
}

resource "aws_secretsmanager_secret" "db_credentials" {
  name = "${var.name_prefix}-prod-db-creds"
  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "db_creds_version" {
  secret_id     = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({ username = var.db_username, password = random_password.db_password.result, db_name = var.db_name })
}

module "ec2" {
  source = "../../modules/ec2"
  name_prefix = var.name_prefix
  ami_id = data.aws_ami.amzn2.id
  instance_type = var.instance_type
  key_name = var.key_name
  private_subnet_ids = module.vpc.private_subnet_ids
  app_sg_id = module.sg.app_sg_id
  target_group_arn = module.alb.target_group_arn
  asg_min_size = var.asg_min_size
  asg_max_size = var.asg_max_size
  user_data = local.user_data
  instance_profile_arn = module.monitoring.instance_profile_arn
  tags = var.tags
}

module "monitoring" {
  source = "../../modules/monitoring"
  name_prefix = var.name_prefix
  tags = var.tags
  infrastructure_dashboard = {
    widgets = [
      {
        type = "metric"
        properties = {
          metrics = [["AWS/EC2","CPUUtilization","InstanceId","InstanceId"]]
          period = 300
          stat = "Average"
          view = "timeSeries"
          title = "EC2 CPU"
          region = var.region
          annotations = {}
        }
      }
      ,{
        type = "metric"
        properties = {
          metrics = [["AWS/RDS","CPUUtilization","DBInstanceIdentifier", module.rds.db_identifier]]
          period = 300
          stat = "Average"
          view = "timeSeries"
          title = "RDS CPU"
          region = var.region
          annotations = {}
        }
      }
    ]
  }
  application_dashboard = {
    widgets = [
      {
        type = "metric"
        properties = {
          metrics = [["AWS/ApplicationELB","RequestCount","LoadBalancer","LoadBalancer"]]
          period = 60
          stat = "Sum"
          view = "timeSeries"
          title = "Request Rate"
          region = var.region
          annotations = {}
        }
      }
    ]
  }
}

locals {
  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y amazon-cloudwatch-agent

    cat > /opt/aws/amazon-cloudwatch-agent/bin/config.json <<CWCONF
    {
      "agent": {"metrics_collection_interval": 60},
      "metrics": {
        "append_dimensions": {"InstanceId": "$${aws:InstanceId}"},
        "metrics_collected": {
          "cpu": {"measurement": ["cpu_usage_idle"], "metrics_collection_interval": 60},
          "mem": {"measurement": ["mem_used_percent"], "metrics_collection_interval": 60},
          "disk": {"resources": ["/"], "measurement": ["used_percent"], "metrics_collection_interval": 300}
        }
      },
      "logs": {
        "logs_collected": {
          "files": {
            "collect_list": [
              {"file_path": "/var/log/app.log", "log_group_name": "${module.monitoring.log_group_app}", "log_stream_name": "{instance_id}"},
              {"file_path": "/var/log/messages", "log_group_name": "${module.monitoring.log_group_system}", "log_stream_name": "{instance_id}"},
              {"file_path": "/var/log/nginx/access.log", "log_group_name": "${module.monitoring.log_group_access}", "log_stream_name": "{instance_id}"}
            ]
          }
        }
      }
    }
CWCONF

    /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a stop || true
    /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a start -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json
  EOF
}

/* attach instance profile from monitoring to ec2 */
resource "null_resource" "__monitoring_attach_placeholder" {}
