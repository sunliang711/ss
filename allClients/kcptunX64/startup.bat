@echo off
title Kcptun ������������
mode con cols=50 lines=20
color A
echo.
echo.                Kcptun ����������
echo.
echo.     ����������Խ� Kcptun �ͻ�����ӵ���������
echo.
echo.       �뽫���ļ��ŵ� run.vbs ��ͬĿ¼������
echo.
echo.   �鿴˵����https://blog.kuoruan.com/102.html
echo.
set /p ST=���� y ��ӿ������������� n ȡ������������
if /I "%ST%"=="y" goto addStartup
if /I "%ST%"=="n" goto delStartup
:addStartup
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "Kcptun Client" /t REG_SZ /d "\"%~dp0run.vbs\"" /F>NUL
exit
:delStartup
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "kcptun Client" /F>NUL 2>NUL
exit
