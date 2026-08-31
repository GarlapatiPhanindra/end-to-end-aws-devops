resource "aws_launch_template" "app" {
  name_prefix   = "${var.name_prefix}-app-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name != "" ? var.key_name : null

  network_interfaces {
    associate_public_ip_address = false
    security_groups              = [var.app_sg_id]
  }

  user_data = base64encode(var.user_data)

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.name_prefix}-app-instance"
    }
  }

  dynamic "iam_instance_profile" {
    for_each = var.instance_profile_arn != "" ? [1] : []
    content {
      arn = var.instance_profile_arn
    }
  }
}

resource "aws_autoscaling_group" "app_asg" {
  name                      = "${var.name_prefix}-app-asg"
  desired_capacity          = var.asg_min_size
  min_size                  = var.asg_min_size
  max_size                  = var.asg_max_size
  vpc_zone_identifier       = var.private_subnet_ids
  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  target_group_arns = [var.target_group_arn]

  tag {
    key                 = "Name"
    value               = "${var.name_prefix}-app-instance"
    propagate_at_launch = true
  }
}
