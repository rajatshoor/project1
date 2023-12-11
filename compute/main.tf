# --- compute/main.tf ---

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Canonical owner ID for Ubuntu AMIs
}

resource "aws_launch_template" "web" {
  name_prefix            = "web"
  image_id               = data.aws_ami.ubuntu.id
  instance_type          = var.web_instance_type
  vpc_security_group_ids = [var.web_sg]
  user_data              = filebase64("install_apache.sh")

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
