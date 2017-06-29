#!/bin/bash

if [ $# != 3 ];then
    echo "Usage: `basename $0` user cfg daemon_opt"
    exit 1
fi

user_as=$1
default_cfg=$2
daemon_opt=$3

pid_file_dir=/var/run/shadowsocks-libev
[ -d $pid_file_dir ] || mkdir $pid_file_dir
cfg_dir=/opt/shadowsocks-libev

echo "start multi_port service:"

