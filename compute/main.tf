# AWS Provider configuration
provider "aws" {
  region = var.aws_region
}

# Data source for the latest Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  owners = ["099720109477"] # Canonical owner ID for Ubuntu AMIs
}

# Launch template for the web instances
resource "aws_launch_template" "web" {
  name_prefix            = "web"
  image_id               = data.aws_ami.ubuntu.id
  instance_type          = var.web_instance_type
  vpc_security_group_ids = [var.web_sg]
  user_data              = filebase64("install_docker.sh")

  tags = {
    Name = "web"
  }
}

# Auto Scaling group for the web instances
resource "aws_autoscaling_group" "web" {
  name                = "web"
  vpc_zone_identifier = tolist(var.public_subnet)
  min_size            = 2
  max_size            = 3
  desired_capacity    = 2

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }
}

# CloudWatch metric alarm for high CPU utilization
resource "aws_cloudwatch_metric_alarm" "high_cpu_utilization" {
  alarm_name                = "high-cpu-utilization-${aws_launch_template.web.name}"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "75"
  alarm_description         = "Alarm when CPU exceeds 75%"
  treat_missing_data        = "missing"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web.name
  }
  actions_enabled           = true
  alarm_actions             = [var.sns_topic_arn]
  ok_actions                = [var.sns_topic_arn]
  insufficient_data_actions = [var.sns_topic_arn]
}

# Variables (make sure to define these in your variables.tf or pass them directly)
variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "web_instance_type" {
  description = "Instance type for the web servers"
  type        = string
}

variable "web_sg" {
  description = "Security group for the web servers"
  type        = list(string)
}

variable "public_subnet" {
  description = "Public subnets for the web servers"
  type        = list(string)
}

variable "sns_topic_arn" {
  description = "SNS topic ARN for alarm actions"
  type        = string
}
