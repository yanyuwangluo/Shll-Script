#!/bin/sh
###
 # @Author: 烟雨
 # @Date: 2022-04-26 16:43:45
 # @LastEditors: 烟雨
 # @LastEditTime: 2022-04-26 18:04:28
 # @FilePath: \undefinedc:\Users\Administrator\Desktop\frp.sh
 # @Description: 
 # 
 # Copyright (c) 2022 by 烟雨, All Rights Reserved. 
### 

read -p "请输入要下载的frp版本$0 :" frp
if  [ ! -n "$frp" ] ;then
	echo ---------------------------
	echo -e "\033[31m对不起你没有输入frp版本，脚本中断\033[0m"
	echo "目前推荐版本 
	0.42.0 
	0.41.0
	0.40.0
	0.39.0
	0.39.1
 只输入 0.xx.0 这一段就行"
else
echo -e "\033[31m*********欢迎使用frp一键脚本*********\033[0m"
echo "正在下载frp文件"
wget https://yanyu.ltd/https://github.com/fatedier/frp/releases/download/v${frp}/frp_${frp}_linux_amd64.tar.gz && tar -xzvf frp_${frp}_linux_amd64.tar.gz && cd frp_${frp}_linux_amd64
echo "正在下载服务端配置文件"
wget https://gitee.com/yanyuwangluo/onekey/raw/master/frp/frps.ini -O frps.ini

echo -e "\033[31m开始启动frp服务端\033[0m"
sleep 1

echo -e "     \033[35m-----------
  服务端网页管理面板端口为：7500
  账号及密码都是 yanyu
  token = yanyuwangluo
  需开放 7000-9000端口
     ------------\033[0m"

echo -e "\033[43;31m正在赋予服务端启动权限！\033[0m"

chmod +x frps

echo -e "\033[35m正在启动frp服务端\033[0m"

./frps -c frps.ini
fi