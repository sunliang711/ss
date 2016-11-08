#!/bin/bash
ROOT=/kcptun

if [ -d "$ROOT" ];then
    rm -rf "$ROOT"
fi

if grep -q "kcptun start" /etc/rc.local;then
    sed -i "/kcptun start/d" /etc/rc.local
fi

if grep -q "alias kcptun" ~/.bashrc;then
    sed -i "/alias kcptun/d" ~/.bashrc
fi
