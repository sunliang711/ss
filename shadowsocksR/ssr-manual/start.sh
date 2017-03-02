#!/bin/bash
ulimit -n 51200
pid=$(ps aux|grep -v grep|grep server.py|awk '{print $2}')
if [ -z "$pid" ];then
    cd /root/shadowsocks/shadowsocks/
    python ./server.py -d start
fi
