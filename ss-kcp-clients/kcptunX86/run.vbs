Dim RunKcptun
Set fso = CreateObject("Scripting.FileSystemObject")
Set WshShell = WScript.CreateObject("WScript.Shell")
'��ȡ�ļ�·��
currentPath = fso.GetFile(Wscript.ScriptFullName).ParentFolder.Path & "\"


'������в���
'˵����-l ������ı�ʾ���ؼ����˿ںţ����ص�shadowsocks�ͻ���Ҫ������������������˿���Ϊ�������˿�
'-r�����ʾҪ���ӵ�Զ�̷������е�kcp�������ļ����˿�
'exeConfig = "client_windows_386.exe -l :124 -r 45.32.66.165:1240 -key test -mtu 1400 -sndwnd 256 -rcvwnd 2048 -mode fast2 -dscp 46"
exeConfig = "client_windows_386.exe -c config.json"
'��־�ļ�
logFile = "kcptun.log"
'ƴ��������
cmdLine = "cmd /c " & currentPath & exeConfig  & " >> " & currentPath & logFile & " 2>&1"
'�������
WshShell.Run cmdLine, 0, False


'�ȴ�1��
'WScript.Sleep 1000
'��ӡ��������
'Wscript.echo cmdLine
Set WshShell = Nothing
Set fso = Nothing
'�˳��ű�
WScript.quit