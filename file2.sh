#! /bin/bash
sudo amazon-linux-extras install nginx1
sudo systemctl start nginx
sudo chmod 777 /usr/share/nginx/html/index.html 
sudo echo "<body style='background-color:blue;'><h1>first ec2</h1></body>"  > /usr/share/nginx/html/index.html
