# 网易云音乐自动任务

## 功能

1. 签到领云贝
2. 自动完成云贝任务，并领取云贝
3. 打卡升级
4. 刷指定歌曲的播放量
5. 音乐人自动签到领取云豆
6. 音乐人自动完成任务，并领取云豆
7. 自动领取 vip 成长值
8. 多种[推送方式](#推送)
9. 支持多账号
10. 支持[腾讯云函数](#一部署到腾讯云函数) & [青龙面板](#二部署到青龙面板) & [本地运行](#三本地运行) & [docker 部署](#四使用docker部署)

> 开发不易，如果你觉得本项目对你有用，可以点个 star，也可以到底部给个[赞赏](#赞赏)

## 注意事项

- 默认关闭在网易云音乐中关注作者，如果不想关注，可以在配置文件里[修改](#关注作者)
- 提 issue 之前看看是否有重复的 issue。
- 不要直接在 GitHub 上修改配置文件。已经修改了的，尽快覆盖，并修改密码。
- 转载请注明出处，并保留原作者信息。
- 禁止将代码用于商业用途，包括打包售卖，收费代挂等。
- 为了账号安全考虑，请勿将账号密码交给他人代挂。

### 修改配置

在[函数服务](https://console.cloud.tencent.com/scf/list)点进刚刚创建的函数

![Function](https://cdn.jsdelivr.net/gh/chen310/NeteaseCloudMusicTasks/public/img/function.png)

如果在函数服务里找不到刚刚部署的函数，先到 GitHub Actions 中确认是否部署成功。如果部署成功，则确认页面左上角的地域选择是否正确，默认地域应为广州。如果在 Secrets 中设置了 REGION，则根据自己设置的 REGION 选择相应的地域。

在编辑器里点击 `config.json` 这个文件进行配置

![Config](https://cdn.jsdelivr.net/gh/chen310/NeteaseCloudMusicTasks/public/img/config.png)

可以看到文件中有红色波浪线的错误提示，可以忽略不管，也可以下拉到编辑器的右下角，点击 `JSON` 来更改语言模式，选择 `JSON with Comments`，这样就可以消除错误提示。

![Style](https://cdn.jsdelivr.net/gh/chen310/NeteaseCloudMusicTasks/public/img/style.png)

在 `config.json` 里进行如下的账号配置。运行之后如果发现有些任务没有完成，可能是因为没有开启，将任务对应的 `enable` 字段设置为 `true` 即可开启。

#### 账号密码

```json5
"users": [
    {
        "username": "188xxxx8888",
        "countrycode": "",
        "password": "mypassword",
        "cookie": "MUSIC_U=xxxxxxxxx;",
        "X-Real-IP": "",
        "enable": true
    }
],
// ...
```

`username` 里填写手机号或邮箱，`password` 里填写账号密码或 32 位 md5 加密后的密码，`countrycode` 为手机号前缀，使用非中国大陆的手机号登录需填写。`X-Real-IP` 里填写国内 IP，否则可能会有无法登录等情况出现，可填写本机 IP，[点击](https://www.ip138.com/)可查看本机 IP，填写显示的 ip 即可。`enable` 为该账号的开关，设置为 `false` 表示不运行该账号的任务。

如果同时填写了账号密码和 `cookie`， 会优先使用 cookie 登录，如果 cookie 填写有误或失效，会尝试使用账号密码登录。

cookie 获取方式：首先在网页登录[网易云音乐](https://music.163.com/)，然后按 <kbd>F12</kbd> 打开开发人员工具，再按 <kbd>F5</kbd> 刷新页面，最后按照以下步骤来获取 cookie，可以只复制 `MUSIC_U` 的那部分

![Cookie](https://cdn.jsdelivr.net/gh/chen310/NeteaseCloudMusicTasks/public/img/cookie.png)

#### 签到

```json5
"setting": {
    // ...
    "sign": true,
    // ...
}
```

签到默认开启，连续签到可以获得更多云贝。

#### 刷听歌量

```json5
"setting": {
    // ...
    "daka": {
        "enable": true,
        "full_stop": true,
        "auto": true,
        "tolerance": 10,
        "song_number": 300,
        // ...
    },
    // ...
}
```

每个账号每天最多只计算 300 首的听歌量，而且必须是没有听过的歌曲。`enable` 表示开启刷听歌量的任务，`full_stop` 表示满级后自动停止任务，无需手动将 `enable` 设为 `false`。`song_number` 表示每次要刷的歌曲数量，账号等级较低的时候可以设置得小一点，不然等级高的时候就难刷了，可能较难刷满 300 首。

`auto` 设置为 `true` 的话表示开启自动模式，程序将自动调整每次打卡的歌曲数，`song_number` 参数将失效。此时，每天 0 点时定时触发器会自动运行代码，获取当前的听歌数，并写入环境变量中，这样的话就可以比较精确地计算每次打卡的歌曲数。`tolerance` 表示对打卡误差的容忍度，在自动打卡模式下有效，如果设置为 0 表示必须要达到 300 首才停止打卡，10 表示达到 290 首就可以停止打卡。

#### 云贝任务

```json5
"setting": {
    // ...
    "yunbei_task": {
        "162005": {
            "taskName": "发布动态",
            "module": "publishEvent",
            "enable": false,
            // 需要分享的歌单id
            "id": [],
            "msg": ["每日分享","今日分享","分享歌单"],
            "delete": true
        },
        "216002": {
            "taskName": "访问云音乐商城",
            "module": "visitMall",
            "enable": true
        },
        "200002": {
            "taskName": "云贝推歌",
            "module": "rcmdSong",
            "enable": false,
            // 填写歌曲ID
            "songId": [],
            "yunbeiNum": 10,
            "reason": []
        },
        "162006": {
            "taskName": "发布Mlog",
            "module": "publishMlog",
            "enable": false,
            // 填写歌曲ID
            "songId": [],
            /* 动态内容，随机选取一个，其中$artist会被替换为歌手名，$song会被替换为歌曲名 */
            "text": [
                "分享$artist的歌曲: $song",
                "分享歌曲: $song"
            ],
            /* 图片大小，越大则消耗的外网出流量越多 */
            "size": 500,
            /* 发布成功后是否自动删除该动态 */
            "delete": true
        },
        "166000": {
            "taskName": "分享歌曲/歌单",
            "module": "share",
            "enable": false
        },
        "656007": {
            "taskName": "浏览会员中心",
            "module": "visitVipCenter",
            "enable": false
        }
    },
    // ...
}
```

`发布动态`任务要分享歌单，可获得 5 云贝，可通过将 `enable` 设为 `true` 开启，`id` 要填写需要分享的歌单 id，可不填写，随机送推荐歌单中选取。`delete` 表示动态发布之后自动删除。

`访问云音乐商城`任务可获得 2 云贝。

`云贝推歌`任务使用云贝对喜欢的歌曲进行推荐，可获得 10 云贝。`songId` 填写喜欢的歌曲 id，如`[65528, 64634]`，程序将会随机挑选一首歌，`yunbeiNum` 是要使用的云贝数量，一般为 `10`，`reason` 填写推歌理由。

`发布Mlog` 根据填写的歌曲 ID，自动下载歌曲对应的专辑图片，并上传。`songId` 填写歌曲 id，如`[65528, 64634]`，`text` 填写动态内容

`分享歌曲/歌单`任务并不会真的分享，将 `enable` 设为 `true` 即可开启任务

`浏览会员中心`将 `enable` 设为 `true` 即可开启任务

#### 音乐人任务

```json5
"setting": {
    // ...
    "musician_task": {
        "749006": {
            "taskName": "音乐人中心签到",
            "module": "musicianSignin",
            "enable": true
        },
        "740004": {
            "taskName": "发布动态",
            "module": "publishEvent",
            "enable": false,
            // 自定义要分享的歌单id，用逗号隔开，分享时随机选取一个，若为空，则从每日推荐歌单中随机选取
            "id": [],
            "msg": ["每日分享","今日分享","分享歌单"],
            "delete": true
        },
        "755000": {
            "taskName": "发布主创说",
            "module": "publishComment",
            "enable": false,
            // 填写你自己歌曲的id，如有多首用,隔开，随机挑选一首
            "id": [],
            "msg": ["感谢大家收听"],
            "delete": true
        },
        "732004": {
            "taskName": "回复粉丝评论",
            "module": "replyComment",
            "enable": false,
            // 填写你自己歌曲的id，如有多首用,隔开，随机挑选一首
            "id": [],
            "msg": ["感谢收听"],
            "delete": true
        },
        "755001": {
            "taskName": "回复粉丝私信",
            "module": "sendPrivateMsg",
            "enable": false,
            // 填写粉丝的用户id，如有多个用,隔开，随机挑选一个进行回复,可以用自己的小号
            "id": [],
            "msg": ["你好"]
        },
        "739008": {
            "taskName": "观看课程",
            "module": "watchCollegeLesson",
            "enable": false
        },
        "740005": {
            "taskName": "访问自己的云圈",
            "module": "visitMyCircle",
            "enable": false
        },
        "744005": {
            "taskName": "发布mlog",
            "module": "publishMlog",
            "enable": false,
            // 填写歌曲ID
            "songId": [],
            /* 动态内容，随机选取一个，其中$artist会被替换为歌手名，$song会被替换为歌曲名 */
            "text": [
                "分享$artist的歌曲: $song",
                "分享歌曲: $song"
            ],
            /* 图片大小，越大则消耗的外网出流量越多 */
            "size": 500,
            /* 发布成功后是否自动删除该动态 */
            "delete": true
        },
    },
    // ...
}
```

需要是音乐人才能执行，想要开启相应的任务，需要将 `enable` 由 `false` 改为 `true`，`登录音乐人中心`自动开启，其他任务根据实际情况开启。`登录音乐人中心`即签到获取云豆；`发布动态`即转发歌单；`发布主创说`即在自己的歌曲评论区留言；`回复粉丝评论`即在自己歌曲的评论区回复粉丝留言，该任务是通过回复自己的留言实现的；`回复粉丝私信`需要填写粉丝 id，可用小号。

#### VIP 成长值任务

```json5
"setting": {
    // ...
    "vip_task": {
        "816": {
            "taskName": "创建共享歌单",
            "module": "createSharedPlaylist",
            "enable": false,
            /* 自定义歌单名，用逗号隔开，随机选取一个 */
            "name": [
                "歌单",
                "我的歌单"
            ],
            /* 创建成功后是否自动删除该动态 */
            "delete": true
        }
    },
    // ...
}
```

`创建共享歌单` 任务默认关闭，需要开启的话将 `enable` 设为 `true`，`name` 里填写自定义的歌单名，创建时随机选取一个，`delete`表示歌单创建成功后时候自动删除。

#### 推送

支持多种推送方式，建议使用企业微信进行推送

1. 企业微信
2. [server 酱](https://sct.ftqq.com/)
3. 酷推
4. [pushPlus](https://www.pushplus.plus)
5. Telegram
6. [Bark](https://github.com/Finb/Bark)
7. [pushdeer](https://github.com/easychen/pushdeer)

要使用推送的话将相应的 `enable` 设为 `true`，并填写配置

##### 企业微信

```json5
"WeCom": {
    "module": "WeCom",
    "enable": false,
    "corpid": "",
    "agentid": "",
    "secret": "",
    "userid": "@all",
    "msgtype": "text",
    /* 是否将多个账号的信息合并推送 */
    "merge": false
}
```

注册企业微信账号可参考[这里](https://sct.ftqq.com/forward)

`corpid` 为企业 ID，登录企业微信后在管理后台`我的企业`－`企业信息`下查看；`agentid` 为应用 ID，在`应用管理`里，点进相应的应用可查看；`secret` 为应用密钥，在`应用管理`里，点进相应的应用可查看；`userid` 默认为`@all`，会向该企业应用的全部成员发送；`msgtype` 为消息类型，可填写文本消息 `text`、文本卡片消息 `textcard` 或 markdown 消息 `markdown`，markdown 消息不能在微信里查看，只能在企业微信里查看。

##### server 酱

```json5
"serverChan": {
    "module": "serverChan",
    "enable": false,
    "KEY": "",
    /* 是否将多个账号的信息合并推送 */
    "merge": true
}
```

要使用 server 酱的话需要在 `KEY` 里填写旧版的 SCKEY 或新版的 SendKey。

##### 酷推

```json5
"CoolPush": {
    "module": "CoolPush",
    "enable": false,
    /* 推送方式: send QQ号私人推送 | group QQ群推送 | wx 微信推送 | email 邮件推送 */
    "method": "send",
    "Skey": "",
    /* 是否将多个账号的信息合并推送 */
    "merge": true
}
```

要使用酷推的话需要填写 `Skey`。

##### pushPlus 微信推送

```json5
"pushPlus": {
    "module": "pushPlus",
    "enable": false,
    "pushToken": "",
    /* 消息模板:  markdown | html | txt | json */
    "template": "markdown",
    /* 群组编码，为空时发给自己 */
    "topic": "",
    /* 是否将多个账号的信息合并推送 */
    "merge": true
}
```

要使用酷推的话需要填写 `pushToken`。

##### Telegram 推送

```json5
"Telegram": {
    "module": "Telegram",
    "enable": false,
    /* Telegram账号ID */
    "userId": "",
    /* TG机器人token */
    "botToken": "",
    /* 是否将多个账号的信息合并推送 */
    "merge": true
}
```

要使用 Telegram 的话需要填写 `userId` 和 `botToken`。

##### Bark 推送

```json5
"Bark": {
    "module": "Bark",
    /* 是否启用Bark推送 */
    "enable": false,
    /* Bark的地址 */
    "Bark_url": "",
    /* Bark的API key */
    "Bark_key": "",
    /* 是否将多个账号的信息合并推送, 建议为false，iOS推送消息过长可能会失败 */
    "merge": false
}
```

要使用 Bark 的话需要填写 `Bark_url` 和 `Bark_key`。可以使用 Bark 官方 API 或者自行搭建。

##### pushdeer

```json5
"pushdeer": {
    "module": "pushdeer",
    /* 是否启用推送 */
    "enable": false,
    /* 服务器地址，放空则使用官方服务器: https://api2.pushdeer.com */
    "server": "",
    /* pushkey */
    "pushkey": "",
    /* 是否将多个账号的信息合并推送 */
    "merge": false
}
```

要使用 pushdeer 的话需要填写 `pushkey`。如果使用自己搭建的服务器，请填写 `server`。

#### 刷单曲播放量

```json5
"setting": {
    // ...
    "other": {
        /* 刷歌单中歌曲的播放次数，用来改变听歌风格，仅在需要时使用 */
        "play_playlists": {
            "enable": false,
            /* 歌单id,用逗号隔开,如 [5279371062,5279377564] */
            "playlist_ids": [],
            /* 播放次数 */
            "times": 1
        }
    },
    // ...
}
```

将要刷的歌曲加到歌单中，把歌单 id 填写到 `playlist_ids` 中，可以添加多个歌单 id，用英文逗号隔开，如 `"playlist_ids":[5279371062,5279377564]`。该功能可以用来改变听歌风格。

#### 多账号

```json5
"users": [
    {
        "username": "188xxxx8888",
        "countrycode": "",
        "password": "mypassword",
        "cookie": "",
        "enable": true
    },
    {
        "username": "166xxxx6666",
        "countrycode": "",
        "password": "anotherpassword",
        "cookie": "MUSIC_U=xxxxxxxxx;",
        "X-Real-IP": "",
        "enable": true,
    }
],
// ...
```

在 `users` 内填写多个账号，不同账号之间要用逗号 `,` 隔开。

假如多个账号配置不同可以参照下面

```json5
"users": [
    {
        "username": "188xxxx8888",
        "countrycode": "",
        "password": "mypassword",
        "cookie": "",
        "X-Real-IP": "",
        "enable": true
    },
    {
        "username": "166xxxx6666",
        "countrycode": "",
        "password": "anotherpassword",
        "cookie": "MUSIC_U=xxxxxxxxx;",
        "X-Real-IP": "",
        "enable": true,
        "setting": {
            "push": {
                "serverChan": {
                    "KEY": "xxxxxxxxxx"
                }
            },
            "yunbei_task": {
                "200002": {
                    "songId": [25707139],
                }
            },
        }
    }
],
// ...
```

如上所示，在第二个账号中加入了 `setting` 字段，并填写与公共配置不同的地方。这样一来，两个账号就使用了不同的 server 酱推送，并使用不同的歌曲进行云贝推歌。

#### 关注作者

```json5
"setting": {
    // ...
    "follow": true
    // ...
}
```

默认会在网易云音乐中关注作者，不想关注可将 `true` 改为 `false`。已经关注了的可到网易云音乐 APP 里取消关注。

## 一、部署到青龙面板

### 拉取代码

```shell
ql repo https://github.com/chen310/NeteaseCloudMusicTasks.git "index.py" "" "py"
```

### 生成配置文件

```shell
点击脚本管理找到config.json修改文件即可
```

### 安装依赖

```shell
apk add python3-dev gcc libc-dev
pip3 install requests json5 pycryptodomex
```

### 修改配置文件

对配置文件 `config.json` 进行修改，修改方式可以参考[修改配置](#账号密码)