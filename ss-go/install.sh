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
cp ss-go.sh "$ROOT"

ln -sf "$ROOT/ss-go.sh" /etc/init.d/ss-go.sh
