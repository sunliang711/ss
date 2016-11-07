#!/bin/bash
prgname=shadowsocks-server-linux64-1.1.5
#prgname=max_server
pid=`ps -ef | grep ${prgname} | grep -v grep | awk '{print $2}'`
if [ -n $pid ];then
    echo "$prgname is running with pid: $pid"
else
    echo "$prgname is not running"
fi
