#!/bin/bash

if (($EUID!=0));then
    echo "Need root priviledge!" >&2
    exit 1
fi

ROOT=/ss-go
if [ -d "$ROOT" ];then
    rm -rf "$ROOT"
fi


fullpath="$PWD/$0"
echo "fullpath:$fullpath"
#get this file's path
realpath=$(dirname "$fullpath")
echo "realpath:$realpath"

#install shadowsocks
mkdir -pv "$ROOT"
cd "$realpath"
cp core/shadowsocks-server-linux64* "$ROOT"
cp core/config.json "$ROOT"
cp ss-go "$ROOT"

#ln -sf "$ROOT/ss-go.sh" /etc/init.d/ss-go.sh
#ln -sf /etc/init.d/ss-go.sh /etc/rc3.d/S03ss-go.sh
#ln -sf /etc/init.d/ss-go.sh /etc/rc5.d/S03ss-go.sh

if ! grep -q "ss-go start" /etc/rc.local;then
    sed -i "/^exit 0/i$ROOT/ss-go start" /etc/rc.local
fi
