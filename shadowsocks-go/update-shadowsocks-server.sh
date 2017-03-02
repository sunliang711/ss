#!/bin/bash
if  ! command -v go>/dev/null 2>&1;then
    echo -e "$(tput setaf 1)Install go first.\u2717"
    exit 1
fi

if ! command -v pacman >/dev/null 2>&1;then
    echo -e "$(tput setaf 1)在archlinux上执行本脚本来更新吧.\u2717"
    exit 1
fi

export GOPATH=/tmp/go
if [ -d "$GOPATH" ];then
    rm -rf $GOPATH
fi
mkdir -pv $GOPATH/src

sspath=github.com/shadowsocks/shadowsocks-go/cmd/shadowsocks-server
echo "get shadowsocks-server source..."
go get $sspath
cd $GOPATH/src/$sspath
echo "build shadowsocks-server..."
go build
cd -
echo "cp $GOPATH/src/$sspath/shadowsocks-server ./core"
cp $GOPATH/src/$sspath/shadowsocks-server ./core
echo "Done."
