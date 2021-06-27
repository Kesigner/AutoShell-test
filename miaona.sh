#!/bin/bash
if [[ $EUID -ne 0 ]]; then
    clear
    echo "错误：本脚本需要 root 权限执行。" 1>&2
    exit 1
fi

download_miaona(){
	echo "正在安装v2ray-posidon . . ."
	curl -L -s https://raw.githubusercontent.com/ColetteContreras/v2ray-poseidon/master/install-release.sh | sudo bash
	rm -f /etc/v2ray/config.json
	wget -P /etc/v2ray https://raw.githubusercontent.com/mps1209/miaoconfig/master/config.json
	cd /etc/v2ray
	printf "请输入nodeid："
	read -r nodeId <&1
	sed -i "s/ID_HERE/$nodeId/" config.json
	service v2ray restart
	shon_online
}

start_miaona(){
	echo "正在启动v2ray-posidon . . ."
	service v2ray restart
	shon_online
}

shon_online(){
echo "请选择您需要进行的操作:"
echo "1) 安装 V2ray-posidon"
echo "2) 卸载 V2ray-posidon"
echo "3) 重启 V2ray-posidon"
echo "4) 查看 V2ray状态"
echo "5) 退出脚本"
echo "   Version：1.0.0"
echo ""
echo -n "   请输入编号: "
read N
case $N in
  1) download_miaona ;;
  2) curl -L -s https://raw.githubusercontent.com/ColetteContreras/v2ray-poseidon/master/uninstall.sh ;;
  3) start_miaona ;;
  4) service v2ray status ;;
  5) exit ;;
  *) echo "Wrong input!" ;;
esac 
}

shon_online