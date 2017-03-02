# ss
##shadowsocks-go
shadowsocks golang版本，里面有锐速加速，更换内核，优化ss等;

安装完之后可以使用
```
ss-go {start|stop|restart|status|config|uninstall}
kcptun {start|stop|restart|status|config|uninstall}
```
来启动、停止、重启、查看状态、修改配置文件、卸载服务。
开机时这两个服务是自动启动的，唯一需要的可能是使用ss-go config修改ss配置文件。kcptun config命令修改kcptun配置文件。

##allClients
包含ss客户端 kcp客户端

##shadowsocksR/ssr
别人的一键安装shadowsocksR脚本

##shadowsocksR/ssr-manual
从ssr作者那里更新来建立ssr服务端

##kcp-server
一键安装ss和kcp合成版服务端

##optimize/kcpserver
梅林路由器中使用的kcp客户端对应的服务端软件
##optimize/kcptun
单独的kcptun加速服务端，配合shadowsocks使用
##optimize/enableBBROfArch.sh
archlinux中开启tcp的bbr加速 （需要内核4.9,目前只有archlinux适用），bbr加速类似锐速，目前来说效果不如锐速
