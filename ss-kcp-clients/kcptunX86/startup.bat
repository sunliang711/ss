@echo off
title Kcptun 开机启动设置
mode con cols=50 lines=20
color A
echo.
echo.                Kcptun 启动项设置
echo.
echo.     此批处理可以将 Kcptun 客户端添加到开机启动
echo.
echo.       请将该文件放到 run.vbs 相同目录后运行
echo.
echo.   查看说明：https://blog.kuoruan.com/102.html
echo.
set /p ST=输入 y 添加开机启动，输入 n 取消开机启动：
if /I "%ST%"=="y" goto addStartup
if /I "%ST%"=="n" goto delStartup
:addStartup
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "Kcptun Client" /t REG_SZ /d "\"%~dp0run.vbs\"" /F>NUL
exit
:delStartup
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "kcptun Client" /F>NUL 2>NUL
exit
