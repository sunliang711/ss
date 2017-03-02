#!/bin/bash
if (($EUID!=0));then
    echo "Need root priviledge!" >&2
    exit 1
fi

exeDir=/usr/local/bin
configDir=/etc/ss-go

#如果已经安装了
if [ -x "$exeDir/ss-go" ];then
    read -p "shadowsocks server has already been installed,uninstall old one? [Y/n]" uninstall
    if [[ "$uninstall" != [Nn] ]];then
        "$exeDir/ss-go" uninstall
    else
        echo "bye!"
        exit 1
    fi
fi

# fullpath="$PWD/$0"
# #get this file's path
# realpath=$(dirname "$fullpath")

#创建配置文件目录
mkdir -pv "$configDir"

#install
for eachFile in core/*;do
    if [[ -x "$eachFile" ]];then
        echo "cp $eachFile -> $exeDir"
        cp "$eachFile" "$exeDir"
    else
        echo "cp $eachFile -> $configDir"
        cp "$eachFile" "$configDir"
    fi
done

#auto start on boot
if [ ! -f /etc/rc.local ];then
    echo "***Warning***Cannot found /etc/rc.local,so cannot start ss-go on startup">&2
    echo "***Warning***You can add: $ROOT/ss-go start to startup script manually!">&2
else
    if ! grep -q "ss-go start" /etc/rc.local;then
        sed -i "/^exit 0/i$ROOT/ss-go start" /etc/rc.local
    fi
fi

#add alias for ss-go
if ! grep -q "alias ss-go" ~/.bashrc;then
    echo "alias ss-go=\"$ROOT/ss-go\"">>~/.bashrc
    echo "***Info***Source ~/.bashrc to use alias 'ss-go'"
fi

#start server
"$exeDir/ss-go" start
