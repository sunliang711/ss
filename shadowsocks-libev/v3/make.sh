#!/bin/bash
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
apt-get update

apt install -y curl gettext build-essential autoconf libtool libpcre3-dev asciidoc xmlto libev-dev libudns-dev automake git

ROOT=~/ss-libev
rm -rf "$ROOT" >/dev/null 2>&1
mkdir -pv "$ROOT"

cd "$ROOT"

git clone https://github.com/shadowsocks/shadowsocks-libev.git  
cd shadowsocks-libev  
git submodule update --init --recursive
cd ..

apt-get remove libsodium*

apt purge libsodium*

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
mkdir /etc/shadowsocks-libev
