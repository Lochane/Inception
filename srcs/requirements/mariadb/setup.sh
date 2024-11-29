#!/bin/bash

set -x

chown mysql:mysql /var/lib/mysql
chmod 755 /var/lib/mysql

mkdir -p /run/mysqld 
chown -R mysql:mysql /run/mysqld
chmod 755 /run/mysqld

# Initialisation de la base de données
mysql_upgrade --datadir=/var/lib/mysql



mysqld --datadir='/var/lib/mysql' &

PID=$!
while ! ps -p $PID > /dev/null; do
    sleep 1
done

mysql -u root -p << EOF
FLUSH PRIVILEGES;

DELETE FROM mysql.user WHERE User = 'root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
SET PASSWORD FOR 'root'@'localhost' = PASSWORD '${DB_ROOT_PASS}';

CREATE DATABASE ${DB_NAME};
CREATE USER '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}';

GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}';

FLUSH PRIVILEGES;
EOF

rm -f tmp_file
kill $PID

exec mysqld --datadir='/var/lib/mysql'

# /usr/bin/mysqld --user=mysql --console --skip-name-resolve --skip-networking=0