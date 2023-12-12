# --- compute/main.tf ---

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Canonical owner ID for Ubuntu AMIs
}

# IAM Role for CloudWatch
resource "aws_iam_role" "cloudwatch_role" {
  name = "CloudWatchEC2Role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cloudwatch_attachment" {
  policy_arn = "arn:aws:iam::383010649018:user/project"
  role       = aws_iam_role.cloudwatch_role.name
}

resource "aws_launch_template" "web" {
  name_prefix            = "web"
  image_id               = data.aws_ami.ubuntu.id
  instance_type          = var.web_instance_type
  vpc_security_group_ids = [var.web_sg]
  user_data              = filebase64("install_docker.sh")

  iam_instance_profile {
    name = aws_iam_role.cloudwatch_role.name
  }

  tags = {
    Name = "web"
  }
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
