#!/bin/bash
#tested on debian 8.8

#install kernel
cd /tmp
wget -O linux-image-4.10.1-amd64.deb http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.10.1/linux-image-4.10.1-041001-generic_4.10.1-041001.201702260735_amd64.deb
dpkg -i linux-image-4.10.1-amd64.deb 

#delete old kernels
images=$(dpkg -l|grep linux-image|awk '{print $2}'|grep -v linux-image-[4-9].[0-9])
for i in $images;do apt-get purge $i -y; done
update-grub

#enable bbr
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf

echo "reboot yourself manaually!"

##check bbr
#sysctl net.ipv4.tcp_available_congestion_control
#lsmod | grep bbr
