#!/bin/bash
#add this file to cron job
nginxConf="/etc/nginx/nginx.conf"
if [ ! -e "$nginxConf" ];then
    echo "$nginxConf does not exist,error!"
    exit 1
fi
logfile=$(grep access_log "$nginxConf"|grep -oP '/.+(?=;)')
echo "logfile: $logfile"
pidfile=$(grep '^pid' "$nginxConf" | grep -oP '/.+(?=;)')
echo "pidfile: $pidfile"
pid=$(cat $pidfile)
echo "pid: $pid"

slientExe(){
    eval "$*" >/dev/null 2>&1
}

slientExe rm -f "${logfile}.7"
slientExe mv "${logfile}.6" "${logfile}.7"
slientExe mv "${logfile}.5" "${logfile}.6"
slientExe mv "${logfile}.4" "${logfile}.5"
slientExe mv "${logfile}.3" "${logfile}.4"
slientExe mv "${logfile}.2" "${logfile}.3"
slientExe mv "${logfile}.1" "${logfile}.2"
slientExe mv "${logfile}" "${logfile}.1"

kill -USR1 "$pid"
