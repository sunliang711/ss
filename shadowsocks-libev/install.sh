#!/bin/bash
if (($EUID!=0));then
    echo "Need Root Privilege!"
    exit 1
fi

#Debian 8
if lsb_release -a 2>/dev/null | grep 'Debian' | grep -q 'jessie';then
    sh -c 'printf "deb http://httpredir.debian.org/debian jessie-backports main" > /etc/apt/sources.list.d/jessie-backports.list'
    apt update -y
    apt -t jessie-backports install shadowsocks-libev -y
#Debian 9
elif lsb_release -a 2>/dev/null | grep 'Debian' | grep -q 'stretch';then
    apt update -y
    apt install shadowsocks-libev -y
else
    echo "Only support Debian 8 and Debian 9 currently!"
    exit 1
fi

#modify config file
local configDir="/etc/shadowsocks-libev"
cat<<EOF>"$configDir/config.json"
{
    "server":"0.0.0.0",
    "server_port":8388,
    "password":"8388",
    "method":"chacha20",
    "local_port":1080,
    "timeout":60
}
EOF

#set iptables to allow ss-server port
cat>"$configDir"/firewall<<EOF
*filter
:INPUT DROP [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
-A INPUT -i lo -j ACCEPT
-A INPUT -p icmp -j ACCEPT

EOF
cat>"$configDir"/otherRule<<EOF
#otherRule begin
#http port
-A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
#https port
-A INPUT -p tcp -m tcp --dport 443 -j ACCEPT

##the following four rules are proxy basic for redirect
#http port
-A INPUT -p tcp -m tcp --sport 80 -j ACCEPT
#https port
-A INPUT -p tcp -m tcp --sport 443 -j ACCEPT
#DNS port
-A INPUT -p tcp -m tcp --sport 53 -j ACCEPT
-A INPUT -p udp -m udp --sport 53 -j ACCEPT
#otherRule end
EOF

##custom rule
echo '#SSH port' >>"$configDir"/firewall
echo "-A INPUT -p tcp --dport 22 -j ACCEPT" >>"$configDir"/firewall

##shadowsocks port from 'config.json'
#newline
echo >>"$configDir"/firewall
echo '#Shadowsocks port' >>"$configDir"/firewall
#grep -oP '(?<=")[0-9]+(?=":)' "$configDir"/config.json |awk '{print "-A INPUT -p tcp --dport "$0" -j ACCEPT"}' >>"$configDir"/firewall
grep '"server_port"' "$configDir"/config.json | grep -oP '\d+' | awk '{print "-A INPUT -p tcp --dport "$0" -j ACCEPT"}' >> "$configDir"/firewall
#newline
echo >>"$configDir"/firewall

if [ -f "$configDir"/otherRule ];then
    cat "$configDir"/otherRule >> "$configDir"/firewall
fi

#footer
cat >>"$configDir"/firewall<<EOF2
COMMIT
EOF2
iptables-restore <"$configDir"/firewall

editor=vi
if command -v vim>/dev/null 2>&1;then
    editor=vim
fi
read -p "Edit firewall file (view or add custom rule)?[y/N]"  -t 3 fw
if [[ "$fw" != [yY] ]];then
    exit 0
else
    "$editor" "$configDir"/firewall
    sed -n "/#otherRule begin/,/#otherRule end/w $configDir/otherRule" "$configDir"/firewall
    iptables-restore <"$configDir"/firewall
fi

#restart service
systemctl restart shadowsocks-libev.service
