#!/bin/bash
if (($EUID!=0));then
    echo "Need $(tput setaf 1)Root$(tput sgr0) privilege!"
    exit 1
fi

if ! command -v pacman >/dev/null 2>&1;then
    echo "Only support $(tput setaf 1)archlinux!"
    exit 1
fi

if [[ -f /etc/systemd/system/docker.service.d/http-proxy.conf ]];then
    echo "Already exist,exit..."
    exit 1
fi

mkdir /etc/systemd/system/docker.service.d
cat >/etc/systemd/system/docker.service.d/http-proxy.conf<<EOF
[Service]
Environment="HTTP_PROXY=127.0.0.1:8118"
EOF

systemctl daemon-reload
systemctl restart docker
systemctl show --property Environment docker

