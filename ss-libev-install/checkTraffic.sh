#!/bin/bash
#放到cron中定期执行，监控每个端口的流量
#如果流量超过限制（限制值在ss-libev每个配置文件中），则修改配置文件名（目前的想法是
#没超限的文件开头是on，超限的文件开头是off),然后ss-libev启动时候，只启动文件名开头是on
#的配置文件
root=/opt/ss-libev

#如果iptables.service重启，则需要把当前的流量保存起来
trafficDir=/opt/traffic

changed=0
outputTraffic=$(/sbin/iptables -n -v -x -L OUTPUT)
allOnCfg=$(ls $root/on*.json)
for c in $allOnCfg;do
    port=$(grep 'server_port' $c | grep -oP '\d+')
    trafficLimit=$(grep 'traffic_limit' $c | grep -oP ':.+' | grep -oP '(?<=")[^"]+(?=")')
    portTraffic=$(echo "$outputTraffic" | grep ":$port" | awk '{print $2}' )

    #savedPortTraffic是重启iptables.service时保存在$trafficDir/目录下的端口流量
    savedPortTraffic=$(cat $trafficDir/tcp$port)
    ((portTraffic += savedPortTraffic))
    echo "port:$port"
    echo "trafficLimit:$trafficLimit GB"
    echo "portTraffic:$portTraffic B"
    if (($portTraffic >= $trafficLimit*1024*1024*1024));then
        mv $c ${c/on/off}
        changed=1
        echo "changed"
    fi
done

if (($changed==1));then
    systemctl restart ss-libev
fi
