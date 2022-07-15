###-------科技玩家签到-------###
#           青龙变量
#
#  export KJWJ_UP=”帐号-密码” 
#
#
###-------------------------###
#!/usr/bin/python3
# -*- coding: utf8 -*-
"""
说明: 环境变量`KJWJ_UP`账号密码`-`分割
cron: 20 */6 * * *
new Env('科技玩家-签到');
"""
import requests
import os
from sendNotify import send
import time

List = []


def login(usr, pwd):
    session = requests.Session()
    login_url = 'https://www.kejiwanjia.com/wp-json/jwt-auth/v1/token'
    headers = {
        'user-agent': 'Mozilla/5.0 (Linux; Android 10; PBEM00) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/93.0.4577.52 Mobile Safari/537.36'
    }
    data = {
        'nickname': '',
        'username': usr,
        'password': pwd,
        'code': '',
        'img_code': '',
        'invitation_code': '',
        'token': '',
        'smsToken': '',
        'luoToken': '',
        'confirmPassword': '',
        'loginType': ''
    }
    res = session.post(login_url, headers=headers, data=data)
    if res.status_code == 200:
        status = res.json()
        List.append(f"账号`{status.get('name')}`登陆成功")
        List.append(f"ID：{status.get('id')}")
        List.append(f"金币：{status.get('credit')}")
        List.append(f"等级：{status.get('lv').get('lv').get('name')}")
        token = status.get('token')
        check_url = 'https://www.kejiwanjia.com/wp-json/b2/v1/userMission'
        check_head = {
            'authorization': f'Bearer {token}',
            'origin': 'https://www.kejiwanjia.com',
            'referer': 'https://www.kejiwanjia.com/task',
            'user-agent': 'Mozilla/5.0 (Linux; Android 10; PBEM00) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/93.0.4577.52 Mobile Safari/537.36'

        }
        resp = session.post(check_url, headers=check_head)
        if resp.status_code == 200:
            info = resp.json()
            if type(info) == str:
                List.append(f"已经签到：{info}金币")
            else:
                List.append(f"签到成功：{info.get('credit')}金币")
    else:
        List.append('账号登陆失败: 账号或密码错误')


if __name__ == '__main__':
    i = 0
    if 'KJWJ_UP' in os.environ:
        users = os.environ['KJWJ_UP'].split('&')
        for x in users:
            i += 1
            name, pwd = x.split('-')
            List.append(f'===> [账号{str(i)}]Start <===')
            login(name, pwd)
            List.append(f'===> [账号{str(i)}]End <===\n')
            time.sleep(1)
        tt = '\n'.join(List)
        print(tt)
        send('科技玩家', tt)
    else:
        print('未配置环境变量')
        send('科技玩家', '未配置环境变量')