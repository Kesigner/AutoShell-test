#!/bin/bash
if [[ $EUID -ne 0 ]]; then
    clear
    echo "错误：本脚本需要 root 权限执行。" 1>&2
    exit 1
fi

download_unicorn(){
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
	wget -P /etc/soga https://raw.githubusercontent.com/Kesigner/unicorn/main/unicorn-config/soga.conf
	wget -P /etc/soga https://raw.githubusercontent.com/Kesigner/unicorn/main/unicorn-config/blockList
	cd /etc/soga
	printf "请输入节点ID："
	read -r nodeId <&1
	sed -i "s/ID_HERE/$nodeId/" soga.conf
	printf "请输入节点域名："
	read -r certDomain <&1
	sed -i "s/ID_YM/$certDomain/" soga.conf
	soga start
	shon_online
}

start_unicorn(){
	echo "正在启动soga . . ."
	soga start
	shon_online
}

restart_unicorn(){
	echo "正在重启soga . . ."
	soga restart
	shon_online
}

add_shenji(){
	echo "正在添加审计 . . ."
    	rm -f /etc/soga/blockList
    	wget -P /etc/soga https://raw.githubusercontent.com/Kesigner/unicorn/main/unicorn-config/blockList
    	soga restart
	shon_online
}

shon_online(){
echo "请选择您需要进行的操作:"
echo "1) 安装 soga"
echo "2) 启动 soga"
echo "3) 重启 soga"
echo "4) 查看 soga状态"
echo "5) 查看 soga日志"
echo "6) 添加审计"
echo "7) 退出脚本"
echo "   Version：1.0.0"
echo ""
echo -n "   请输入编号: "
read N
case $N in
  1) download_unicorn ;;
  2) start_unicorn ;;
  3) restart_unicorn ;;
  4) soga status ;;
  5) soga loga ;;
  6) add_shenji ;;
  7) exit ;;
  *) echo "Wrong input!" ;;
esac 
}

shon_online
