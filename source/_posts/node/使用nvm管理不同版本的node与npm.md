---
title: 使用nvm管理不同版本的node与npm
date: 2017-09-29 08:50:05
tags: [node,npm]
---
## nvm
Node Version Manager（Node版本管理器），用它可以方便的在机器上安装并维护多个Node的版本.
如果你已经单独安装了node，请先卸载。
<!-- more -->
## nvm 下载
nvm 的下载地址：https://github.com/coreybutler/nvm-windows/releases,
选择一个 nvm-setup.zip , 直接安装,安装路径 D:\develop\nvm , 安装过程会选择nodejs的路径,  D:\develop\nodejs .

## nvm 配置
安装过程中，会自动创建环境变量NVM_HOME 和 NVM_SYMLINK。
NVM_HOME = D:\develop\nvm
NVM_SYMLINK = D:\develop\nodejs
同时在PATH里会加上 ;%NVM_HOME%;%NVM_SYMLINK%;

## 检测安装结果

```
$ nvm version
1.1.5

```

## 使用node
控制台下载 => 输入：nvm install [版本号]，下载最新版的可以直接输nvm install latest

下载完成后，在控制台输入：nvm use [版本号]。即使用这个版本号的node了。在use后，上面所说的nodejs文件夹就自动生成了。（在use之前是没有的哦）

## 查看nvm所管理的node包
```
$ nvm ls

    8.1.0
  * 6.11.0 (Currently using 64-bit executable)
```