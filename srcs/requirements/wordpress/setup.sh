#!/bin/bash

# Changer le propriétaire et les permissions du répertoire HTML
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

exec php-fpm7.4 -F