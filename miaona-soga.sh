#!/bin/bash
if [[ $EUID -ne 0 ]]; then
    clear
    echo "错误：本脚本需要 root 权限执行。" 1>&2
    exit 1
fi

download_miaona(){
	echo "正在安装soga . . ."
	bash <(curl -Ls https://blog.sprov.xyz/soga.sh)
	echo "正在同步时间 . . ."
	yum install -y ntp
	systemctl enable ntpd
	ntpdate -q 0.rhel.pool.ntp.org
	systemctl restart ntpd
	echo "正在更新配置文件 . . ."
	rm -f /etc/soga/soga.conf
	rm -f /etc/soga/blockList
	wget -P /etc/soga https://raw.githubusercontent.com/mps1209/miaoconfig/master/soga.conf
	wget -P /etc/soga https://raw.githubusercontent.com/mps1209/miaoconfig/master/blockList
	cd /etc/soga
	printf "请输入节点ID："
	read -r nodeId <&1
	sed -i "s/ID_HERE/$nodeId/" soga.conf
	soga start
	shon_online
}

start_miaona(){
	echo "正在启动soga . . ."
	soga start
	shon_online
}

uninstall_posidon(){
	echo "正在卸载posidon . . ."
	set -x
	systemctl stop v2ray
	systemctl disable v2ray
	service v2ray stop
	update-rc.d -f v2ray remove
	rm -rf /usr/bin/v2ray /etc/init.d/v2ray /lib/systemd/system/v2ray.service
	set -
	shon_online
}

add_shenji(){
	echo "正在添加审计 . . ."
    	rm -f /etc/soga/blockList
    	wget -P /etc/soga https://raw.githubusercontent.com/mps1209/miaoconfig/master/blockList
    	soga restart
	shon_online
}

shon_online(){
echo "请选择您需要进行的操作:"
echo "1) 安装 soga"
echo "2) 启动 soga"
echo "3) 查看 soga状态"
echo "4) 卸载 posidon"
echo "5) 添加审计"
echo "6) 退出脚本"
echo "   Version：1.0.0"
echo ""
echo -n "   请输入编号: "
read N
case $N in
  1) download_miaona ;;
  2) start_miaona ;;
  3) soga status ;;
  4) uninstall_posidon ;;
  5) add_shenji ;;
  6) exit ;;
  *) echo "Wrong input!" ;;
esac 
}

shon_online
