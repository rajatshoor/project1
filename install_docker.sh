#!/bin/bash

# Update package lists
apt-get update
mkdir ranbir
cd ranbir

# Install Docker
apt-get install -y docker.io

# Start the Docker service
systemctl start docker

# Enable Docker to start on boot
systemctl enable docker

# Pull a Docker image
docker pull ranbir18/my-class-activity:V2

# Run the Docker container
docker run -t ranbir18/my-class-activity:V2




#!/bin/bash
sudo apt-get update
sudo apt-get install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2
echo "Hello, World! from our test server." | sudo tee /var/www/html/index.html

resource "aws_instance" "example" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.web_instance_type
  subnet_id     = var.public_subnet

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y docker.io

              # Install AWS CloudWatch agent
              sudo apt-get install -y unzip
              wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
              sudo dpkg -i -E ./amazon-cloudwatch-agent.deb

              # Configure CloudWatch agent
              sudo tee /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json <<EOL
              {
                "metrics": {
                  "metrics_collected": {
                    "mem": {
                      "measurement": [
                        "mem_used_percent"
                      ]
                    }
                  }
                }
              }
              EOL

              # Start CloudWatch agent
              sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json -s
              EOF
}


