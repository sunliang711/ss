#!/bin/bash

if ! command -v git;then
	echo "没有发现git,请先安装git"
	exit 1
fi

cd /root
git clone -b manyuser https://github.com/breakwa11/shadowsocks.git
cd shadowsocks
cp /root/ssr-manual/user-config.json .

cat<<EOF>shadowsocks/start.sh
#!/bin/bash
ulimit -n 51200
cd /root/shadowsocks/shadowsocks/
python ./server.py -d start
EOF

sed -i '$i /bin/bash /root/shadowsocks/shadowsocks/start.sh' /etc/rc.local
