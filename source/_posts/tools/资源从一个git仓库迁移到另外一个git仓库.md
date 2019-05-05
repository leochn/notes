---
title: 资源从一个git仓库迁移到另外一个git仓库
date: 2017-06-27 16:35:19
tags: [git,tool]
---
本文主要告诉大家如何将git仓库迁移到另一个git仓库进行托管，并保留之前的所有提交记录
<!-- more -->

## 克隆裸版本库

1). 从原地址克隆一份裸版本库，比如原本托管于 GitHub
```
git clone --bare git://github.com/username/project.git
```
–bare 创建的克隆版本库都不包含工作区，直接就是版本库的内容，这样的版本库称为裸版本库。

## 镜像推送

2). 然后到新的服务器 GitCafe 上创建一个新项目newproject。

3). 以镜像推送的方式上传代码到 GitCafe 服务器上。

```
cd project.git
git push --mirror git@gitcafe.com/username/newproject.gi
```
— mirror 克隆出来的裸版本对上游版本库进行了注册，这样可以在裸版本库中使用git fetch命令和上游版本库进行持续同步。

4). 删除本地代码
```
cd ..
rm -rf project.git
```
5). 到新服务器 GitCafe 上找到 Clone 地址，直接 Clone 到本地就可以了。
```
git clone git@gitcafe.com/username/newproject.git
```
这种方式可以保留原版本库中的所有内容