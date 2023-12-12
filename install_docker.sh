#!/bin/bash

# Update package lists
apt-get update

# Install Docker
apt-get install -y docker.io

# Start the Docker service
systemctl start docker

# Enable Docker to start on boot
systemctl enable docker

# Pull a Docker image
docker pull ranbir18/my-class-activity:V2

# Run the Docker container
docker run ranbir18/my-class-activity:V2
chmod +x docker_script.sh
./docker_script.sh



#!/bin/bashsudo apt-get update
sudo apt-get install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2
echo "Hello, World! from our test server." | sudo tee /var/www/html/index.html



