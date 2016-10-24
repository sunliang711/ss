#!/bin/bash
pid=`ps -ef | grep shadowsocks-server-linux | grep -v grep | awk '{print $2}'`
if [[ "$pid" != ""  ]];then
    echo "Stoping shadowsocks-server with pid: $pid"
    kill -9 $pid
    echo "Stoped!"
else
    echo "shadowsocks-server is not running!"
    echo "Exit!"
fi

