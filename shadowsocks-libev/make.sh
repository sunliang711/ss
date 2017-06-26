#!/bin/bash
proxy=0
if [[ "$1" == "-p" ]];then
	proxy=1
fi
shopt -s expand_aliases
if (("$proxy"==1));then
	echo "Using proxy..."
	git config --global http.proxy "192.168.1.120:1080"
	git config --global https.proxy "192.168.1.120:1080"
	alias curl='curl --socks5 "192.168.1.120:1080"'
fi
#sh -c 'printf "deb http://httpredir.debian.org/debian jessie-backports main" > /etc/apt/sources.list.d/jessie-backports.list'
apt-get update -y

apt install -y curl gettext build-essential autoconf libtool libpcre3-dev asciidoc xmlto libev-dev libudns-dev automake git

ROOT=~/ss-libev
rm -rf "$ROOT" >/dev/null 2>&1
mkdir -pv "$ROOT"

cd "$ROOT"

git clone https://github.com/shadowsocks/shadowsocks-libev.git  
cd shadowsocks-libev  
git submodule update --init --recursive
cd ..

apt-get remove libsodium* -y

apt purge libsodium* -y

curl  https://download.libsodium.org/libsodium/releases/libsodium-1.0.11.tar.gz -O

tar xvf libsodium-1.0.11.tar.gz

cd libsodium-1.0.11

./configure --prefix=/usr && make

make install

cd ..

curl  https://tls.mbed.org/download/mbedtls-2.4.0-gpl.tgz -O

tar xvf mbedtls-2.4.0-gpl.tgz

cd mbedtls-2.4.0

make SHARED=1 CFLAGS=-fPIC

make install

ldconfig

cd ..

cd shadowsocks-libev  
./autogen.sh && ./configure && make
make install

apt install -y rng-tools
systemctl start rng-tools
systemctl enable rng-tools

local configDir="/etc/shadowsocks-libev"
mkdir "$configDir"
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



# 然后进入 shadowsocks-libev 目录下进行编译
# $ cd shadowsocks-libev
# $ dpkg-buildpackage -b -us -uc -i
# $ cd ..
# $ dpkg -i shadowsocks-libev*.deb
# 编译是通过生成 deb 包然后进行安装，其实也可以通过 make 的方式来进行安装，但使用 deb 包安装会自动生成开启启动的脚步在 /etc/init.d 目录下,采用哪种方式安装就因人而异了
