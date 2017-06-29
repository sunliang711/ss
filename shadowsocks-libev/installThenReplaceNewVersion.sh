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

    systemctl stop shadowsocks-libev
    # cp ./make-bin/ss-local /usr/bin/ss-local
    # cp ./make-bin/ss-nat /usr/bin/ss-nat
    cp ./make-bin/ss-server /usr/bin/ss-server
    # cp ./make-bin/ss-manager /usr/bin/ss-manager
    # cp ./make-bin/ss-redir /usr/bin/ss-redir
    # cp ./make-bin/ss-tunnel /usr/bin/ss-tunnel

    configDir="/etc/shadowsocks-libev"
    cat>"$configDir/config.json"<<EOF
    {
        "server":"0.0.0.0",
        "server_port":8388,
        "password":"8388",
        "method":"chacha20",
        "local_port":1080,
        "timeout":60
    }
EOF
    apt install -y rng-tools
    read -p "enable multi-port support? [Y/n]" multiport
    if [[ "$multiport" != [nN] ]];then
        while read -p "how many ports to add? [default:5]" portcount;do
            if echo "$portcount" | grep -qP '^\s*\d*\s*$';then
                break
            fi
            echo "invalid number,retry :"
        done
        if echo "$portcount" | grep -qP '^\s*$';then
            portcount=5
        fi
        # read -p "how many ports to add? [default:5]" portcount
        root=/opt/shadowsocks-libev
        if [ -d "$root" ];then
            rm -rf "$root"
        fi
        mkdir -p "$root" >/dev/null 2>&1
        for i in $(seq "$portcount");do
            cp /etc/shadowsocks-libev/config.json "$root/config$i.json"
        done
        editor=vi
        if command -v vim >/dev/null 2>&1;then
            editor=vim
        fi
        read -p "edit config file" -t 2 xxyy
        cmd="$editor"
        for i in $(seq "$portcount");do
            cmd="${cmd} $root/config$i.json"
        done
        eval "$cmd"

        #modify /lib/systemd/system/shadowsocks-libev.service file
        service_file=/lib/systemd/system/shadowsocks-libev.service
        mv "${service_file}" "${service_file}.bak"
        cp shadowsocks-libev.service "${service_file}"
        cp ./ss_multi_port.sh "$root"
        for i in $(seq "$portcount");do
            echo "pidfile$i=\$pid_file_dir/ss_$i.pid" >> "$root/ss_multi_port.sh"
        done
        echo >> "$root/ss_multi_port.sh"

        for i in $(seq "$portcount");do
            echo "cfgfile$i=\$cfg_dir/config$i.json" >> "$root/ss_multi_port.sh"
        done
        echo >> "$root/ss_multi_port.sh"

        for i in $(seq "$portcount");do
            echo "/usr/bin/ss-server -a \$user_as -c \$cfgfile$i -f \$pidfile$i \$daemon_opt" >> "$root/ss_multi_port.sh"
        done
        echo >> "$root/ss_multi_port.sh"

        echo "exit 0" >>"$root/ss_multi_port.sh"
        echo "install successfully!"
        systemctl daemon-reload
    fi
    echo "start shadowsocks-libev service..."
    systemctl start shadowsocks-libev
    echo "enable shadowsocks-libev..."
    systemctl enable shadowsocks-libev
    echo "restart rng-tools service..."
    systemctl restart rng-tools
    echo "enabhle rng-tools"
    systemctl enable rng-tools
fi

