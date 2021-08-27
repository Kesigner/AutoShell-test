#!/bin/bash
if [[ $EUID -ne 0 ]]; then
    clear
    echo "错误：本脚本需要 root 权限执行。" 1>&2
    exit 1
fi

ask_if()
{
    read -p "开启隧道,是否继续？(y/n)" para

    case $para in 
    [yY])
    input_soga
    echo -e "\033[32m 已添加隧道配置~ \033[1m"
    cho -e "\033[32m 正在重启soga服务端~ \033[1m"
    ;;
    [nN])
    sed -i '$a tunnel_enable=false' /etc/soga/soga.conf
    ;;
    *)
    echo "输入错误"
    exit 1
    ;;
    esac # end case
}

input_soga()
{
     sed -i '$a tunnel_enable=true' /etc/soga/soga.conf
     sed -i '$a tunnel_type=ws-tunnel' /etc/soga/soga.conf
     sed -i '$a tunnel_password=3a00afbc-302f-41a5-986c-7bcdda0c83a7' /etc/soga/soga.conf
}

download_unicorn(){
	echo "正在安装soga . . ."
	bash <(curl -Ls https://raw.githubusercontent.com/vaxilu/soga/master/install.sh)
    echo -e "\033[32m 正在更新配置文件 . . . \033[1m"
	rm -f /etc/soga/soga.conf
	rm -f /etc/soga/blockList
	wget -P /etc/soga https://raw.githubusercontent.com/Kesigner/unicorn/main/unicorn-config/soga.conf
    echo -e "\033[32m 已添加soga配置 \033[1m"
	wget -P /etc/soga https://raw.githubusercontent.com/Kesigner/unicorn/main/unicorn-config/blockList
    echo -e "\033[32m 已添加soga审计 \033[1m"
	cd /etc/soga
	printf "请输入节点ID："
	read -r nodeId <&1
	sed -i "s/ID_HERE/$nodeId/" soga.conf
    ask_if
    soga restart
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
        echo -e "\033[32m 已添加soga审计 \033[1m"
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
echo "   Version：2.0.0"
echo ""
echo -n "   请输入编号: "
read N
case $N in
  1) download_unicorn ;;
  2) start_unicorn ;;
  3) restart_unicorn ;;
  4) soga status ;;
  5) soga log ;;
  6) add_shenji ;;
  7) exit ;;
  *) echo "Wrong input!" ;;
esac 
}

shon_online
