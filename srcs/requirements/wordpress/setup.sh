#!/bin/bash

# Changer les permissions et propriétaire
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

# Copier wp-config.php
if [ ! -f /var/www/html/wp-config.php ]; then
  cp /wp-config.php /var/www/html/wp-config.php
fi

# Télécharger et configurer WordPress
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar

if [ ! -d /var/www/html/wp-admin ]; then
  ./wp-cli.phar core download --path=/var/www/html/. --allow-root
fi

if [ ! -f /var/www/html/wp-config.php ]; then
  ./wp-cli.phar config create --path=/var/www/html/. --dbname=wordpress --dbuser=wpuser --dbpass=password --dbhost=mariadb --allow-root
fi

./wp-cli.phar core install --path=/var/www/html/. --url=lsouquie.42.fr --title=inception --admin_user=admin --admin_password=admin --admin_email=admin@admin.com --allow-root

# Lancer php-fpm
exec php-fpm7.4 -F
