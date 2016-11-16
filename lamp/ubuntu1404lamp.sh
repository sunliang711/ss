#!/bin/bash
if (($EUID!=0));then
    echo "need root priviledge!"
    exit 1
fi

apt-get update
apt-get -y install apache2 mysql-server php5-mysql php5 libapache2-mod-auth-mysql libapache2-mod-php5 php5-mcrypt
mysql_install_db
mysql_secure_installation

sed -i 's/\(^.*DirectoryIndex \)\(.*$\)/\1 index.php \2/' /etc/apache2/mods-enabled/dir.conf
