#!/bin/bash
ulimit -n 51200

if ps aux | grep -v grep | grep -q shadowsocks-server-linux64;then
    echo 'shadowsocks-server is already running'
    echo 'Exit'
    exit 1
fi
fullpath="$(pwd)/$0"
#cd 到本脚本所在的目录
cd $(dirname $fullpath)
cd core
./shadowsocks-server-linux64-1.1.5 >/dev/null 2>&1 &
if ps aux | grep -v grep | grep -q shadowsocks-server-linux64;then
    echo "shadowsocks-server-linux64 has started"
else
    echo "shadowsocks-server-linxu64 start failed!"
fi
