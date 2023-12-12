#!/bin/bash
apt-get update
apt-get install -y docker.io
systemctl start docker
systemctl enable docker

# Pull a predefined Docker image
docker pull ranbir18/my-class-activity:V2
docker run -t ranbir18/my-class-activity:V2

# Example: Run the pulled Docker image
# docker run -d -p 80:80 ranbir18/my-class-activity:V2

#!/bin/bashsudo apt-get update
sudo apt-get install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2
echo "Hello, World! from our test server." | sudo tee /var/www/html/index.html



