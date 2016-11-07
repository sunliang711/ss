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

#auto start on boot
if ! grep -q "ss-go start" /etc/rc.local;then
    sed -i "/^exit 0/i$ROOT/ss-go start" /etc/rc.local
fi

#add alias for ss-go
if ! grep -q "alias ss-go" ~/.bashrc;then
    echo "alias ss-go='/ss-go/ss-go'">>~/.bashrc
fi
