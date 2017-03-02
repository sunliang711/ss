#!/bin/sh

if (($EUID!=0));then
    echo -e "Need run as $(tput setaf 1)root \u2717"
    exit 1
fi

echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
sysctl -p

#echo "net.ipv4.tcp_congestion_control=bbr" >  /etc/sysctl.d/80-bbr.conf

