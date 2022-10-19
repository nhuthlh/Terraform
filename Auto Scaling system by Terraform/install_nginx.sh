#! /bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo systemctl enable httpd
sudo service httpd start  
sudo mkdir /var/www/html/app1
sudo echo '<h1>Auto Scaling System</h1>' | sudo tee /var/www/html/index.html
