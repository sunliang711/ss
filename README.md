# ss
kcp-server:一键安装ss和kcp合成版服务端

ss-go:shadowsocks golang版本，里面有锐速加速，更换内核，优化ss等;
一键安装ss-go和kcptun的命令：
```
if [ -d /tmp/ss ];then rm -rf /tmp/ss;fi && cd /tmp && git clone https://github.com/sunliang711/ss.git && cd ss/ss-go && bash install.sh &&
cd optimize/kcptun && bash install.sh && reboot
```

重启之后就可以使用：
```
ss-go {start|stop|restart|status|config|uninstall}
kcptun {start|stop|restart|status|config|uninstall}
```
来启动、停止、重启、查看状态、修改配置文件、卸载服务。
开机时这两个服务是自动启动的，唯一需要的可能是使用ss-go config修改ss配置文件。kcptun config命令修改kcptun配置文件。

ss-kcp-clients: 包含ss客户端 kcp客户端

ssr:别人的一键安装shadowsocksR脚本

ssr-manual:从ssr作者那里更新来建立ssr服务端
