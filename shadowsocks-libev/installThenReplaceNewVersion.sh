#!/bin/bash
if (($EUID!=0));then
    echo "Need Root Privilege!"
    exit 1
fi

#Debian 8
if lsb_release -a 2>/dev/null | grep 'Debian' | grep -q 'jessie';then
    sh -c 'printf "deb http://httpredir.debian.org/debian jessie-backports main" > /etc/apt/sources.list.d/jessie-backports.list'
    apt update -y
    apt -t jessie-backports install shadowsocks-libev -y

    systemctl stop shadowsocks-libev
    # cp ./make-bin/ss-local /usr/bin/ss-local
    # cp ./make-bin/ss-nat /usr/bin/ss-nat
    cp ./make-bin/ss-server /usr/bin/ss-server
    # cp ./make-bin/ss-manager /usr/bin/ss-manager
    # cp ./make-bin/ss-redir /usr/bin/ss-redir
    # cp ./make-bin/ss-tunnel /usr/bin/ss-tunnel

    configDir="/etc/shadowsocks-libev"
    cat<<EOF>"$configDir/config.json"
    {
        "server":"0.0.0.0",
        "server_port":8388,
        "password":"8388",
        "method":"chacha20",
        "local_port":1080,
        "timeout":60
    }
EOF
    systemctl start shadowsocks-libev
    systemctl enable shadowsocks-libev
fi
