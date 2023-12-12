# --- compute/main.tf ---

provider "aws" {
  region = "us-east-1" # or your preferred region
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical owner ID for Ubuntu AMIs

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_instance" "web" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro" # or your preferred instance type
  monitoring             = true       # Enable detailed monitoring
  vpc_security_group_ids = ["sg-12345678"] # Replace with your security group ID
  subnet_id              = "subnet-eddcdzz4" # Replace with your subnet ID

  tags = {
    Name = "web-instance"
  }
}

resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "high-cpu-utilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors ec2 cpu utilization"
  actions_enabled     = true

  dimensions = {
    InstanceId = aws_instance.web.id
  }

  # Assuming you have an SNS topic for notifications
  alarm_actions = ["arn:aws:sns:us-east-1:123456789012:my-sns-topic"]
}

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


