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

#all file begin with config and end with .json can be used as a config file of an instance
allCfgFiles=$(ls "$cfg_dir/config*.json")
index=1
for c in "$allCfgFiles";do
    /usr/bin/ss-server -a $user_as -c $c -f "${pid_file_dir}/ss_${index}.pid" $daemon_opt
    ((index+=1))
done

exit 0
