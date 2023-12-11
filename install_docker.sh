#!/bin/bash
apt-get update
apt-get install -y docker.io
systemctl start docker
systemctl enable docker

# Pull a predefined Docker image
docker pull ranbir18/my-class-activity:V2

# Example: Run the pulled Docker image
# docker run -d -p 80:80 ranbir18/my-class-activity:V2

#!/bin/bash

sudo apt install apache2
sudo apt install apache2
sudo systemctl start apache2
sudo ufw allow 'Apache'

echo "Hello World from $(hostname -f)" > /var/www/html/index.html
