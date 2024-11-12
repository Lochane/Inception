#!/bin/bash

# Initialisation de la base de données
mysql_install_db --user=mysql --datadir=/var/lib/mysql

chmod -R 755 /var/lib/mysql

# Démarre mysqld en premier plan et applique le fichier init.sql si présent
if [ -f /etc/mysql/init.sql ]; then
    mysqld --init-file=/etc/mysql/init.sql --user=mysql --datadir='/var/lib/mysql'
else
    exec mysqld --user=mysql --datadir='/var/lib/mysql'
fi