#!/bin/bash

# Initialisation de la base de données
mysql_install_db --user=mysql --datadir=/var/lib/mysql

chown mysql:mysql /etc/mysql/init.sql
chmod 600 /etc/mysql/init.sql

# Démarre mysqld en premier plan et applique le fichier init.sql si présent
if [ -f /etc/mysql/init.sql ]; then
    exec mysqld --init-file=/etc/mysql/init.sql --user=mysql --datadir='/var/lib/mysql'
    echo "launched mariadb with init file" > /check_mariadb/
else
    exec mysqld --user=mysql --datadir='/var/lib/mysql'
    echo "launched mariadb without init file" > /check_mariadb/
fi
