Dim RunKcptun
Set fso = CreateObject("Scripting.FileSystemObject")
Set WshShell = WScript.CreateObject("WScript.Shell")
'获取文件路径
currentPath = fso.GetFile(Wscript.ScriptFullName).ParentFolder.Path & "\"


'软件运行参数
'说明：-l 后面跟的表示本地监听端口号，本地的shadowsocks客户端要连接它，就是用这个端口作为服务器端口
'-r后面表示要连接的远程服务器中的kcp服务器的监听端口
'exeConfig = "client_windows_386.exe -l :124 -r 45.32.66.165:1240 -key test -mtu 1400 -sndwnd 256 -rcvwnd 2048 -mode fast2 -dscp 46"
exeConfig = "client_windows_386.exe -c config.json"
'日志文件
logFile = "kcptun.log"
'拼接命令行
cmdLine = "cmd /c " & currentPath & exeConfig  & " >> " & currentPath & logFile & " 2>&1"
'启动软件
WshShell.Run cmdLine, 0, False


'等待1秒
'WScript.Sleep 1000
'打印运行命令
'Wscript.echo cmdLine
Set WshShell = Nothing
Set fso = Nothing
'退出脚本
WScript.quit