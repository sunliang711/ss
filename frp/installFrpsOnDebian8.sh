#!/bin/bash
#stop service if needed
systemctl stop frps.service >/dev/null 2>&1

root=/opt/frps
if [ -d "$root" ];then
    rm -rf "$root"
fi
mkdir -p "$root"

#pidfiledir=/var/run/frp
#if [ ! -d "$pidfiledir" ];then
    #mkdir "$pidfiledir"
#fi

#exe and config file
cp -r ./frp-bin-linux64/* "$root"

#service file
cat > /lib/systemd/system/frps.service <<EOF
[Unit]
Description=frps
After=network.target

[Service]
Type=simple
#PIDFile=$pidfiledir/frps.pid
ExecStart=$root/frps -c $root/frps.ini

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
#start service
systemctl start frps.service

#enable service
systemctl enable frps.service
