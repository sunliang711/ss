#!/bin/bash
pid=$(ps aux|grep -v grep|grep server.py|awk '{print $2}')
if [ -z "$pid" ];then
    echo "Warning: No ssr process found!"
    exit 1
fi
kill -9 $pid
if (($?==0));then
    echo "OK: kill process with pid: $pid"
fi
