#!/bin/bash
root=/opt/ss-libev
#TODO 新增或更新玩一个端口时，要检查冲突

list(){
	allCfgFiles=$(ls ${root}/*.json)
	for cfg in ${allCfgFiles};do
		port=$(grep 'server_port' $cfg | grep -oP ':.+' | grep -oP '\d+')
		#port=$(grep 'server_port' $cfg | grep -oP ':\s*\d+\s*,' | grep -oP '\d+')
		password=$(grep 'password' $cfg | grep -oP ':.+' | grep -oP '(?<=")[^"]+(?=")')
		method=$(grep 'method' $cfg | grep -oP ':.+' | grep -oP '(?<=")[^"]+(?=")')
		owner=$(grep 'owner' $cfg | grep -oP ':.+' | grep -oP '(?<=")[^"]+(?=")')
		echo "****************************************************************"
		echo "cfg file is:$cfg"
		echo "port:$port"
		echo "password:$password"
		echo "method:$method"
		echo "owner:$owner"
	done
}

add(){
	usage='usage: add port password owner(default:nobody) method(default:chacha20)'
	port=$1
	password=$2
	owner=${3:-nobody}
	method=${4:-chacha20}
	if [ -z "$port" ] || [ -z "$password" ];then
		echo "$usage"
		exit 1 
	fi
	cfgfile=$(date +%s).json
	cat > $root/$cfgfile<<EOF
{
	"server":"0.0.0.0",
	"server_port":$port,
	"password":"$password",
	"method":"$method",
	"local_port":1080,
	"owner":"$owner",
	"timeout":60
}
EOF
}

delete(){
	usage="delete port"
	port=$1
	if [ -z "$port" ];then
		echo $usage
		exit 1
	fi
	
	allCfgFiles=$(ls ${root}/*.json)
	for cfg in ${allCfgFiles};do
		p=$(grep 'server_port' $cfg | grep -oP ':\s*\d+\s*,' | grep -oP '\d+')
		if [ "$p" == "$port" ];then
			rm $cfg
			exit 0
		fi
	done
	echo "Not Found port:$port config file"
}


update(){
	usage="usage: update port"
	port=$1
	if [ -z "$port" ];then
		echo $usage
		exit 1
	fi
	
	allCfgFiles=$(ls ${root}/*.json)
	echo "allCfgFiles:$allCfgFiles"
	for cfg in ${allCfgFiles};do
		p=$(grep 'server_port' $cfg | grep -oP ':\s*\d+\s*,' | grep -oP '\d+')
		if [ "$p" == "$port" ];then
			vi $cfg
			exit 0
		fi
	done
	echo "Not Found port:$port config file"

}

usage(){
	echo "usage: $(basename $0) CMD [Parameters]"
	echo "CMD:"
	echo "     list"
	echo "     add port password method(default chacha20)"
	echo "     delete port"
	echo "     update port"
}

warning(){
	echo "Warning: Don't forget to update iptables and restart ss-libev service"
}

case $1 in
	list)
		list
		;;
	add)
		add $2 $3 $4 $5
		warning
		;;
	delete)
		delete $2
		warning
		;;
	update)
		update $2
		warning
		;;
	*)
		usage
		;;
esac

