resource "aws_iam_role" "ec2_cw_agent" {
  name = "ec2-cw-agent-role-${var.name_prefix}"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "cw_agent_attach" {
  role       = aws_iam_role.ec2_cw_agent.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-cw-agent-profile-${var.name_prefix}"
  role = aws_iam_role.ec2_cw_agent.name
}

resource "aws_cloudwatch_log_group" "app_logs" {
  name              = "/${var.name_prefix}/app"
  retention_in_days = var.log_retention_days
  tags = var.tags
}

resource "aws_cloudwatch_log_group" "system_logs" {
  name              = "/${var.name_prefix}/system"
  retention_in_days = var.log_retention_days
  tags = var.tags
}

resource "aws_cloudwatch_log_group" "access_logs" {
  name              = "/${var.name_prefix}/access"
  retention_in_days = var.log_retention_days
  tags = var.tags
}

resource "aws_cloudwatch_dashboard" "infrastructure" {
  dashboard_name = "${var.name_prefix}-infrastructure"
  dashboard_body = jsonencode(var.infrastructure_dashboard)
}

resource "aws_cloudwatch_dashboard" "application" {
  dashboard_name = "${var.name_prefix}-application"
  dashboard_body = jsonencode(var.application_dashboard)
}

data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
