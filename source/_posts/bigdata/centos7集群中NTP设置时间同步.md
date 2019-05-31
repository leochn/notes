---
title: centos7集群中NTP设置时间同步
date: 2019-03-11 07:05:23
tags: [linux,ntp]
---
## 集群时间同步

时间同步的方法：找一台机器，作为时间服务器，所有的机器与这台集群时间进行定时的同步，比如，每隔10分钟同步一次时间。
<!-- more -- >

## 基础知识
```
#date      #查看或者设置当前系统的时间
#ntpdate   #手工临时同步系统时间
#ntpd      #作为守护进程，按照一定的算法进行时间同步，即使你启动了该进程，ntpd也不会立刻进行时间同步。

Linux里面用Asia/Shanghai表示东八区，等价于Windows中的 北京、重庆、香港特别行政区，乌鲁木齐的时区设置。
如果安装时选错了时区，或者使用了默认的纽约时区，可以通过以下命令进行修改：
#cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
```

## 操作步骤
### 准备工作
```
检查是否安装ntp
rpm -qa | grep ntp
两个节点都需要先安装ntp
yum -y install ntp
安装完毕之后，启动服务
systemctl start ntpd
查看状态
systemctl status ntpd
设置开机自启动
systemctl enable ntpd

[root@vm2 ~]# systemctl start ntpd
[root@vm2 ~]# systemctl enable ntpd
Created symlink from /etc/systemd/system/multi-user.target.wants/ntpd.service to /usr/lib/systemd/system/ntpd.service.
[root@vm1 ~]#
```
### 准备3台服务器
3台服务器：192.168.175.129 ; 192.168.175.130 ; 192.168.175.131

### 时间服务器配置,必须root用户
第一台服务器192.168.175.129，作为ntpserver，将他设置为同步外网时间（ntpd服务开启默认就同步了）。

1.修改本地网络的主机不受限制
restrict 192.168.175.0 mask 255.255.255.0 nomodify notrap

2.




### 其他服务器配置,必须root用户