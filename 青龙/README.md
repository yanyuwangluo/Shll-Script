# 青龙脚本

## 拉取地址

### 一键还原青龙bot
```
wget https://git.yanyu.ltd/yanyu/toulu/raw/branch/master/%E9%9D%92%E9%BE%99/bot.sh -O bot.sh && bash bot.sh
```
### diybot替换青龙机器人一键脚本跑完后，后续可以用ql bot更新或重启机器人

##### 使用手册：https://github.com/chiupam/JD_Diy/wiki/%E4%BD%BF%E7%94%A8%E6%89%8B%E5%86%8C
```
wget https://git.yanyu.ltd/yanyu/toulu/raw/branch/master/%E9%9D%92%E9%BE%99/diybot.sh -O bot.sh && bash bot.sh
```

### diybot拓展
#### 拓展名`cxjc.py` `cxjc_kill.py`
##### diybot的任务查询跟强制结束模块，会用的自取
##### 给机器人发送cx会获取青龙正在运行的js和py，点击脚本前的蓝字强制结束进程。
```
食用方法 安装好diybot后把上面的两个脚本扔到`ql\jbot\diy`下然后重启机器人
```

##### diybot_patches_fixed.zip
```
修复补丁
解压覆盖到repo文件夹再ql bot
```
### 快捷指令清单：
```
a - 自定义快捷按钮
addcron - 增加定时
addenv - 青龙新增环境变量
bean - 获取收支
blockcookie - 屏蔽账号
chart - 统计收支变化
check - 测试user连接
checkcookie - 检测过期
clearboard - 删除快捷输入按钮
cmd - 执行cmd命令
cron - 管理定时设定
dl - 下载文件
edit - 编辑文件
env - 管理环境变量
help - 获取帮助
getfile - 获取目录下文件
log - 选择日志
node - 执行js脚本文件，绝对路径
restart - 重启本程序
repo - 仓库管理
set - BOT设置
setname - 设置命令别名
setshort - 设置自定义按钮
snode - 选择脚本后台运行
start - 开始使用本程序
upbot - 升级机器人
ver - 版本
```