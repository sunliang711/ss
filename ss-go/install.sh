#!/bin/bash
if (($EUID!=0));then
    echo "Need root priviledge!" >&2
    exit 1
fi

ROOT=/ss-go
if [ -d "$ROOT" ];then
    "$ROOT/ss-go" stop
    rm -rf "$ROOT"
fi


fullpath="$PWD/$0"
#get this file's path
realpath=$(dirname "$fullpath")

#install shadowsocks
mkdir -pv "$ROOT"
#先cd到install.sh所在的目录然后再cp的目的是可以在其它路径通过相对路径或者绝对路径执行install.sh也可以，当然在本目录执行最好
cd "$realpath"
cp core/shadowsocks-server-linux64* "$ROOT"
cp core/config.json "$ROOT"
cp core/otherRule "$ROOT"
cp core/ss-go "$ROOT"
cp core/max_server "$ROOT"

#auto start on boot
if [ ! -f /etc/rc.local ];then
    echo "***Warning***Cannot found /etc/rc.local,so cannot start ss-go on startup">&2
    echo "***Warning***You can add: $ROOT/ss-go start to startup script manually!">&2
else
    if ! grep -q "ss-go start" /etc/rc.local;then
        sed -i "/^exit 0/i$ROOT/ss-go start" /etc/rc.local
    fi
fi

#add alias for ss-go
if ! grep -q "alias ss-go" ~/.bashrc;then
    echo "alias ss-go=\"$ROOT/ss-go\"">>~/.bashrc
    echo "***Info***Source ~/.bashrc to use alias 'ss-go'"
fi

#start server
"$ROOT/ss-go" start
