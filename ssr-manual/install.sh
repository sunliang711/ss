#!/bin/bash

if ! command -v git>/dev/null 2>&1;then
	echo "没有发现git,请先安装git"
	exit 1
fi

cp user-config.json /tmp
cp start.sh /tmp
cp stop.sh /tmp
rm -rf /root/shadowsocks
cd /root
git clone -b manyuser https://github.com/breakwa11/shadowsocks.git
cd shadowsocks
cp /tmp/user-config.json .
cp /tmp/start.sh shadowsocks/
cp /tmp/stop.sh shadowsocks/
rm /tmp/user-config.json
rm /tmp/start.sh
rm /tmp/stop.sh

if ! grep 'shadowsocks/shadowsocks/start.sh' /etc/rc.local;then
    sed -i '$i /bin/bash /root/shadowsocks/shadowsocks/start.sh' /etc/rc.local
fi
