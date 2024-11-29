#!/bin/bash

# Changer les permissions et propriétaire
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

# Copier wp-config.php
# if [ ! -f /var/www/html/wp-config.php ]; then
#   cp /wp-config.php /var/www/html/wp-config.php
# fi

# Télécharger et configurer WordPress
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar


./wp-cli.phar core download --path=/var/www/html/. --allow-root
  sleep 10

# ./wp-cli.phar db create --path=/var/www/html --allow-root

chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

# if [ ! -f /var/www/html/wp-config.php ]; then
  ./wp-cli.phar config create --path=/var/www/html --dbname=$DB_NAME \ 
  --dbuser=$DB_USER --dbpass=$DB_PASS --dbhost=$DB_HOSTNAME --allow-root
# fi

  ./wp-cli.phar core install --path=/var/www/html --url=$DOMAIN_NAME --title=$WORDPRESS_TITLE \
  --admin_user=$WORDPRESS_ADMIN_USER --admin_password=$WORDPRESS_ADMIN_PASSWORD \
  --admin_email=$WORDPRESS_ADMIN_EMAIL --allow-root

  ./wp-cli.phar user create $WORDPRESS_USER $WORDPRESS_USER_EMAIL --role=author \
  --user_pass=$WORDPRESS_USER_PASSWORD --allow-root --path=/var/www/html



# Lancer php-fpm
exec php-fpm7.4 -F
