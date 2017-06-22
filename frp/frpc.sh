#!/bin/sh
#this file must in /usr/local/bin

frpc=/volume1/public/frp-bin-linux64/frpc
cfg=/volume1/public/frp-bin-linux64/frpc.ini

start(){
        nohup $frpc -c $cfg >/dev/null 2>&1 &
}

stop(){
        pid=$(ps | grep 'frpc -c' | grep -v grep | awk '{print $1}')
        if [ ! -z "$pid" ];then
            kill $pid
        fi
}

status(){
        pid=$(ps | grep 'frpc -c' | grep -v grep | awk '{print $1}')
        if [  -z "$pid" ];then
                echo "frpc is not running!"
        else
                echo "frpc is running with pid $pid"
        fi

}

case $1 in
        start)
                start
                ;;
        stop)
                stop
                ;;
        restart)
                stop
                start
                ;;
        config)
                vi $cfg
                ;;
        status)
                status
                ;;
        *)
                echo "Usage: frpc.sh start|stop|restart|config|status"
                ;;
esac
