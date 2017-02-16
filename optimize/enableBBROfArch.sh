#!/bin/sh

if (($EUID!=0));then
    echo "Need run as root"
    exit 1
fi

echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
sysctl -p
