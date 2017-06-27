#!/bin/bash

if (($EUID!=0));then
    echo "need root privilege!"
    exit 1
fi
#stop service if exists
systemctl stop ss-libev >/dev/null 2>&1

root=/opt/ss-libev
if [ -d "$root" ];then
    rm -rf "$root" >/dev/null 2>&1
fi
mkdir -p "$root"

#cp ss-server
bindir=/usr/local/bin
mkdir -p "$bindir" >/dev/null 2>&1
cp ./ss-server "$bindir"

#environment file
cp ./ss-libev.environment /etc/default

#service file
cp ./ss_multi_port.sh /lib/systemd/system

systemctl daemon-reload
systemctl restart ss-libev


