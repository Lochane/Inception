#!/bin/bash

chown mysql:mysql /var/lib/mysql
chmod 755 /var/lib/mysql

mkdir -p /run/mysqld 
chown -R mysql:mysql /run/mysqld
chmod 755 /run/mysqld


if ! ls /var/lib/mysql | grep ".*"  > /dev/null
then
    echo Installing Databases
    mariadb-install-db --datadir=/var/lib/mysql
    chown -R mysql:mysql /var/lib/mysql
else
    echo Databases already installed
fi

mysqld --user=mysql &
PID=$!

# Attente que MariaDB soit prêt
while [ ! -e /run/mysqld/mysqld.sock ]
do
    sleep 2
done

echo "FLUSH PRIVILEGES;" > /var/lib/mysql/init.sql
echo "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('${DB_ROOT_PASS}');" >> /var/lib/mysql/init.sql
echo "CREATE DATABASE ${DB_NAME};" >> /var/lib/mysql/init.sql
echo "CREATE USER '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}';" >> /var/lib/mysql/init.sql
echo "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';" >> /var/lib/mysql/init.sql


chown mysql:mysql /var/lib/mysql/init.sql
chmod 644 /var/lib/mysql/init.sql

mysql < /var/lib/mysql/init.sql

kill -9 $PID
wait $PID

exec mysqld --user=mysql
