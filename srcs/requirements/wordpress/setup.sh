#!/bin/bash

# Changer le propriétaire et les permissions du répertoire HTML
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

cd /var/www/html
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
<<<<<<< HEAD
./wp-cli.phar core download --path=/var/www/html/.  --allow-root
./wp-cli.phar config create --path=/var/www/html/. --dbname=wordpress --dbuser=wpuser --dbpass=password --dbhost=mariadb --allow-root
./wp-cli.phar core install --path=/var/www/html/. --url=localhost --title=inception --admin_user=admin --admin_password=admin --admin_email=admin@admin.com --allow-root

# cp wp-config.php /var/www/html/wp-config.php

exec php-fpm7.4 -F
=======
./wp-cli.phar core download --allow-root
./wp-cli.phar config create --dbname=wordpress --dbuser=wpuser --dbpass=password --dbhost=mariadb --allow-root
./wp-cli.phar core install --url=localhost --title=inception --admin_user=admin --admin_password=admin --admin_email=admin@admin.com --allow-root

exec php-fpm7.4 -F
>>>>>>> 6a88fb7a33647dc41da42d8da47aa161501229dc
