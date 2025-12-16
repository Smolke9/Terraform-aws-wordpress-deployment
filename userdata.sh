#!/bin/bash
apt update -y

# Install Apache, PHP, MySQL
apt install apache2 php php-mysql mysql-server unzip wget -y

systemctl start apache2 mysql
systemctl enable apache2 mysql

# MySQL Setup
mysql -e "CREATE DATABASE wpdb;"
mysql -e "CREATE USER 'wpuser'@'localhost' IDENTIFIED BY 'password';"
mysql -e "GRANT ALL PRIVILEGES ON wpdb.* TO 'wpuser'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"

# Download WordPress
cd /var/www/html
wget https://wordpress.org/latest.zip
unzip latest.zip
chown -R www-data:www-data wordpress

# WordPress Config
cp wordpress/wp-config-sample.php wordpress/wp-config.php
sed -i "s/database_name_here/wpdb/" wordpress/wp-config.php
sed -i "s/username_here/wpuser/" wordpress/wp-config.php
sed -i "s/password_here/password/" wordpress/wp-config.php

systemctl restart apache2
