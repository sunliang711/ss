# ssr-manual
shadowsocksR

1. 首先手动配置本目录下的user-config.json,不配置也可以使用
2. 执行install.sh
3. 这样会在/root/shadowsocks/shadowsocks下面创建两个文件start.sh stop.sh
用于启动、停止服务
4. 另外在/etc/rc.local中也会加入对start.sh的调用，每次开机时会自动启动。
