# ss-go
optimize目录中是优化加速的功能,其中:
    1. better.sh只在搭建好服务之后执行一次。以后就不需要执行了。
    2. kcptun是服务端加速软件,在开启ss的时候开启它
    3. 锐速是个加速服务,开启ss的时候开启

install.sh会把ss-go安装到/ss-go目录中，并且在/etc/rc.local中添加了开机自启动ss-go
常用命令：/ss-go/ss-go {start|stop|status|restart}分别启动、停止、查看状态、重启ss-go
