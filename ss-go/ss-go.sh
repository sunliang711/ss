#!/bin/bash
. /etc/init.d/functions

ROOT=/ss-go
cd "$ROOT"
prgname=$(ls shadowsocks-server*)
echo "shadowsocks app name is: $prgname"
start(){
    ulimit -n 51200
    if [ -z "$prgname" ];then
        echo "shadowsocks-server not found in $ROOT">&2 
        exit 1
    fi
    if ps aux | grep -v grep | grep  ${prgname};then
        echo "Warning: ${prgname} is already running"
        exit 1
    fi
    ./${prgname} > /dev/null  2>&1 &
    if ps aux | grep -v grep | grep  ${prgname};then
        echo "OK: ${prgname} has started"
    else
        echo "Failed: ${prgname} start failed!"
    fi
}
stop(){
pid=`ps -ef | grep ${prgname} | grep -v grep | awk '{print $2}'`
if [[ "$pid" != ""  ]];then
    echo "Stoping ${prgname} with pid: $pid"
    kill -9 $pid
    echo "Stoped!"
else
    echo "Warning:${prgname} is not running!"
    echo "Exit!"
fi
}
restart(){
    stop
    start
}
status(){
pid=`ps -ef | grep ${prgname} | grep -v grep | awk '{print $2}'`
if [ -n $pid ];then
    echo "$prgname is running with pid: $pid"
else
    echo "$prgname is not running"
fi
}

usage(){
    echo "Usage: $0 {start|stop|status|restart}">&2
    exit 1
}

case "$1" in
    start)
        start
        ;;
    stop)
        stop
	;;
    status)
        status
        ;;
    restart)
        restart
        ;;
    *)
        usage
        ;;
esac
exit 0
