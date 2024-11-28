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

if ! $(wp-cli.phar core is-installed --allow-root --path='/var/www/wordpress'); then
  ./wp-cli.phar core install --path=/var/www/html/. --url=$DOMAIN_NAME --title=$WORDPRESS_TITLE \
  --admin_user=$WORDPRESS_ADMIN_USER --admin_password=$WORDPRESS_ADMIN_PASSWORD \ 
  --admin_email=$WORDPRESS_ADMIN_EMAIL --allow-root
  ./wp-cli.phar config create --dbname=wordpress --dbuser=wpuser --dbpass=password --dbhost=mariadb --allow-root
  ./wp-cli.phar user create --path=/var/www/html/. $WORDPRESS_USER $WORDPRESS_USER_EMAIL \ 
  --role=author --user_pass=$WORDPRESS_USER_PASSWORD --allow-root
fi
# Lancer php-fpm
exec php-fpm7.4 -F
