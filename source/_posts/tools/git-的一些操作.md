---
title: git 的一些操作
date: 2017-07-27 15:39:12
tags: [git,tool]
---
## git远程拉分支,并进行版本回退
```
git clone git@git.coding.net:leousst/jkflow.git

cd jkflow/

# 查看远程分支
git branch -a

# checkout远程的dev分支，在本地起名为dev分支，并切换到本地的dev分支
git checkout -b dev origin/dev

# 查看版本信息
git log

# 版本回退
git reset --hard ab89a31ef4712c74b1141bb94bd5d4770dbce3de


1.安装git

2.配置用户名和邮箱
git config --global user.name "myname"
git config --global user.email "test@gmail.com"

3.查看配置信息
git config --global  --list

4.git-ssh 永久保存密码
git config --global credential.helper store
```