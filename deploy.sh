#!/bin/bash

echo "deleting old app"
sudo rm -rf /home/ec2-user/app/test_app

echo "creating app folder"
sudo mkdir -p /home/ec2-user/app/

echo "moving files to app folder"
sudo mv  * /home/ec2-user/app/

# Navigate to the app directory
cd /home/ec2-user/app/test_app
sudo mv env .env

sudo yum update
echo "installing python and pip"
sudo yum install -y python3 python3-pip

# Creating virtual environment
exho "Setup Venv"
sudo /usr/bin/python3 -m venv -- /home/ec2-user/app/test_app/venv
"source /home/ec2-user/app/test_app/venv/bin/activate"

# Install application dependencies from requirements.txt
echo "Install application dependencies from requirements.txt"
sudo pip install -r requirements.txt

# Update and install Nginx if not already installed
if ! command -v nginx > /dev/null; then
    echo "Installing Nginx"
    sudo yum update
    sudo yum install -y nginx
fi

# Configure Nginx to act as a reverse proxy if not already configured
if [ ! -f /etc/nginx/sites-available/myapp ]; then
    sudo rm -f /etc/nginx/sites-enabled/default
    sudo bash -c 'cat > /etc/nginx/sites-available/myapp <<EOF
server {
    listen 80;
    server_name _;

    location / {
        include proxy_params;
        proxy_pass http://unix:/home/ec2-user/app/test_app/myapp.sock;
    }
}
EOF'

    sudo ln -s /etc/nginx/sites-available/myapp /etc/nginx/sites-enabled
    sudo systemctl restart nginx
else
    echo "Nginx reverse proxy configuration already exists."
fi

# Stop any existing Gunicorn process
sudo pkill gunicorn
sudo rm -rf myapp.sock

# # Start Gunicorn with the Flask application
# # Replace 'server:app' with 'yourfile:app' if your Flask instance is named differently.
# # gunicorn --workers 3 --bind 0.0.0.0:8000 server:app &
echo "starting gunicorn"
# sudo gunicorn --workers 3 --bind unix:myapp.sock  manage:app --user www-data --group www-data --daemon
sudo manage:app --name TEST-FLASK-APP -b 0.0.0.0:8004 --log-file error_logs.log --workers 2 --bind unix:myapp.sock
echo "started gunicorn 🚀"