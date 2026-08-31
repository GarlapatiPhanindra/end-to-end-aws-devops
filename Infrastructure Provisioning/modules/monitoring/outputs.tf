output "instance_profile_arn" {
  value = aws_iam_instance_profile.ec2_profile.arn
}

output "log_group_app" {
  value = aws_cloudwatch_log_group.app_logs.name
}

output "log_group_system" {
  value = aws_cloudwatch_log_group.system_logs.name
}

output "log_group_access" {
  value = aws_cloudwatch_log_group.access_logs.name
}
