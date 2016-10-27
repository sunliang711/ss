#!/bin/bash
source common.sh
ulimit -n 51200

if ps aux | grep -v grep | grep  ${prgname};then
    echo "Warning: ${prgname} is already running"
    exit 1
fi
fullpath="$(pwd)/$0"
#cd 到本脚本所在的目录
cd $(dirname $fullpath)
cd core
./${prgname} >../log 2>&1 &
if ps aux | grep -v grep | grep  ${prgname};then
    echo "OK: ${prgname} has started"
else
    echo "Failed: ${prgname} start failed!"
fi
