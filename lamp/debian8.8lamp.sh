#tested on debian 8.8
apt-get update
apt-get install apache2 php5 mysql-server
mysql_secure_installation
apt-get install phpmyadmin
a2enmod rewrite

service apache2 restart
echo '<?php phpinfo();?>'>/var/www/html/info.php

#config phpmyadmin
cp /etc/phpmyadmin/config.inc.php{,.bak}
sed -ri 's=([ ]+)//(.+AllowNoPassword.+)=\1\2=' /etc/phpmyadmin/config.inc.php

echo 'Include /etc/phpmyadmin/apache.conf' >> /etc/apache2/apache2.conf
service apache2 restart
