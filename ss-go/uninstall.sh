#!/bin/bash
ROOT=/ss-go
if [ -d "$ROOT" ];then
    rm -rf "$ROOT"
fi

if grep -q "ss-go start" /etc/rc.local;then
    sed -i "/ss-go start/d" /etc/rc.local
fi

if grep -q "alias ss-go" ~/.bashrc;then
    sed -i "/alias ss-go/d" ~/.bashrc
fi

