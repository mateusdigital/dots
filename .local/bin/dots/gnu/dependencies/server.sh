
#!/usr/bin/env bash

set -e; ## Stop on errors.
echo "Installing server dependencies...";

sudo apt-get install -y   \
    lynx                  \
    nginx                 \
    certbot               \
    python3-certbot-nginx \
    ;


## Allow NGINX
sudo ufw allow 'Nginx Full'
sudo ufw allow 'Nginx HTTP'
systemctl enable nginx