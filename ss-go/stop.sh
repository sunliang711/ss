#!/bin/bash
prgname=shadowsocks-server-linux64-1.1.5
#prgname=max_server
pid=`ps -ef | grep ${prgname} | grep -v grep | awk '{print $2}'`
if [[ "$pid" != ""  ]];then
    echo "Stoping ${prgname} with pid: $pid"
    kill -9 $pid
    echo "Stoped!"
else
    echo "Warning:${prgname} is not running!"
    echo "Exit!"
fi

