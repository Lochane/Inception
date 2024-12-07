#!/bin/bash

# Configuration des permissions
chown -R www-data:www-data /var/www/html
chmod -R 777 /var/www/html

# Télécharger et configurer WP-CLI
if [ ! -f /usr/local/bin/wp ]; then
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
fi

# Télécharger WordPress
./wp-cli.phar core download --path=/var/www/html --allow-root

sleep 10

chown -R www-data:www-data /var/www/html
chmod -R 777 /var/www/html

if [ -f /var/www/html/wp-config.php ]; then
    echo "Un fichier wp-config.php existant a été trouvé. Suppression."
    rm /var/www/html/wp-config.php
fi

# Créer le fichier de configuration
./wp-cli.phar config create --path=/var/www/html \
    --dbname="$DB_NAME" \
    --dbuser="$DB_USER" \
    --dbpass="$DB_PASS" \
    --dbhost="$DB_HOSTNAME" \
    --allow-root

sleep 1

# Installer WordPress
./wp-cli.phar core install \
    --path=/var/www/html \
    --url="$DOMAIN_NAME" \
    --title="$WORDPRESS_TITLE" \
    --admin_user="$WORDPRESS_ADMIN_USER" \
    --admin_password="$WORDPRESS_ADMIN_PASSWORD" \
    --admin_email="$WORDPRESS_ADMIN_EMAIL" \
    --allow-root

sleep 1

./wp-cli.phar theme install twentytwentyfour --activate --path=/var/www/html --allow-root

# Créer un utilisateur supplémentaire
./wp-cli.phar user create \
    "$WORDPRESS_USER" "$WORDPRESS_USER_EMAIL" \
    --role=author \
    --user_pass="$WORDPRESS_USER_PASSWORD" \
    --allow-root \
    --path=/var/www/html

sleep 1


chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

sleep 1

# Démarrer PHP-FPM
exec php-fpm7.4 -F