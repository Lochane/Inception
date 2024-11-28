#!/bin/bash

# Initialisation de la base de données
mysql_install_db --user=mysql --datadir=/var/lib/mysql

chown mysql:mysql /etc/mysql/init.sql
chmod 600 /etc/mysql/init.sql

# Démarre mysqld en premier plan
echo "Démarrage de MariaDB..."
if ! pgrep -x "mysqld" > /dev/null; then
    exec mysqld --user=mysql --datadir='/var/lib/mysql' &
    sleep 10  # Attendre que MariaDB démarre complètement (ajuster si nécessaire)
fi

# Création de la base de données et de l'utilisateur via la commande mysql
mysql -u root -p <<EOF
CREATE USER '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON *.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;
EOF

# Vérification de l'état de MariaDB
if [ $? -eq 0 ]; then
    echo "Base de données et utilisateur créés avec succès."
else
    echo "Erreur lors de la création de la base de données ou de l'utilisateur."
fi
# Démarre mysqld en premier plan et applique le fichier init.sql si présent
# if [ -f /etc/mysql/init.sql ]; then
#     exec mysqld --init-file=/etc/mysql/init.sql --user=mysql --datadir='/var/lib/mysql'
#     echo "launched mariadb with init file" > /check_mariadb/
# else
#     exec mysqld --user=mysql --datadir='/var/lib/mysql'
#     echo "launched mariadb without init file" > /check_mariadb/
# fi
