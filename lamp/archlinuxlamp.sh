#!/bin/bash
if (($EUID != 0));then
    echo "Need root priviledge!"
    exit 1
fi

if ! command -v pacman>/dev/null 2>&1;then
    echo "Only works in ArchLinux!"
    exit 1
fi

pacman -Syu --no-confirm
pacman -S nginx-mainline --no-confirm
pacman -S mariadb --no-confirm
pacman -S php-fpm --no-confirm

mysql_install_db --user=mysql  --basedir=/usr --datadir=/var/lib/mysql
systemctl start mysqld
cat>mysql_secure_installation.sh<<'EOF'
#!/bin/bash
read -p "Input new password for root: " passwd
sudo mysql_secure_installation<<end

y
$passwd
$passwd
y
y
y
y
end
EOF
bash mysql_secure_installation.sh

mv /etc/nginx/nginx.conf{,.bak}
cp ./nginx.conf /etc/nginx/nginx.conf

systemctl restart nginx php-fpm mysqld
