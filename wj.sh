#!/usr/bin/env bash
###
 # @Author: your name
 # @Date: 2021-11-18 21:25:02
 # @LastEditTime: 2021-11-18 21:25:34
 # @LastEditors: Please set LastEditors
 # @Description: 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 # @FilePath: \Shll-Script\wj.sh
### 
clear

echo -e "\e[36m
   ▄▄▄▄       ██                         ▄▄▄▄                                   
  ██▀▀██      ▀▀                         ▀▀██                                   
 ██    ██   ████     ██▄████▄   ▄███▄██    ██       ▄████▄   ██▄████▄   ▄███▄██ 
 ██    ██     ██     ██▀   ██  ██▀  ▀██    ██      ██▀  ▀██  ██▀   ██  ██▀  ▀██ 
 ██    ██     ██     ██    ██  ██    ██    ██      ██    ██  ██    ██  ██    ██ 
  ██▄▄██▀  ▄▄▄██▄▄▄  ██    ██  ▀██▄▄███    ██▄▄▄   ▀██▄▄██▀  ██    ██  ▀██▄▄███ 
   ▀▀▀██   ▀▀▀▀▀▀▀▀  ▀▀    ▀▀   ▄▀▀▀ ██     ▀▀▀▀     ▀▀▀▀    ▀▀    ▀▀   ▄▀▀▀ ██ 
       ▀                        ▀████▀▀                                 ▀████▀▀
---------------------------------------烟雨阁出品-------------------------------
\e[0m\n"
#用处不大没什么吊用
wget https://gitee.com/yanyuwangluo/onekey/raw/master/wj/JDJRValidator_Aaron.js -O JDJRValidator_Aaron.js 
&& wget https://gitee.com/yanyuwangluo/onekey/raw/master/wj/jdCookie.js -O jdCookie.js 
&& wget https://gitee.com/yanyuwangluo/onekey/raw/master/wj/sendNotify.js -O sendNotify.js 
&& wget -P ~/ql/scripts/utils/ https://gitee.com/yanyuwangluo/onekey/raw/master/wj/USER_AGENTS.js 
&& wget -P ~/ql/scripts/utils/ https://gitee.com/yanyuwangluo/onekey/raw/master/wj/JD_DailyBonus.js 

# 提示配置结束
echo -e "\n吊毛这个脚本是下载.\JDJRValidator_Aaron.js.\jdCookie.js.\sendNotify.js.\JD_DailyBonus.js.\USER_AGENTS.js"
echo -e "\n现在下载完了告辞"