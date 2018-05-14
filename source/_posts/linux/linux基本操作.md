---
title: linux基本操作
date: 2018-05-14 06:05:08
tags:
---

## linux基础操作
### linux常用命令
#### 查看当前系统的时间：date

[root@localhost ~]# date +%Y-%m-%d --date="-1day"  # 加减也可以 month|year

设置时间:date -s "2018-05-14 06:50:51"  ## 修改时间

修改时间后，需要写入硬件bios才能在重启后依然生效。 hwclock -w

```bash
[root@localhost ~]# date
2018年 05月 14日 星期一 06:35:35 CST
[root@localhost ~]# date +%Y-%m-%d
2018-05-14
[root@localhost ~]# date +%Y-%m-%d --date="-1day"
2018-05-13
[root@localhost ~]# date +%Y-%m-%d --date="+1day"
2018-05-15
[root@localhost ~]# date +%Y-%m-%d --date="+1month"
2018-06-14
[root@localhost ~]# date +%Y-%m-%d --date="+1year"
2019-05-14
[root@localhost ~]# date -s "2018-05-14 06:50:51"
2018年 05月 14日 星期一 06:50:51 CST
[root@localhost ~]# hwclock -w
[root@localhost ~]#
```

#### 查看有谁在线(哪些人登录到了服务器)

who 查看当前在线

```bash
[root@localhost ~]# who
root     pts/0        2018-05-14 06:29 (192.168.17.1)
root     pts/1        2018-05-14 07:07 (192.168.17.130)
[root@localhost ~]#
```

#### 文件操作

1.vi 文本编辑器

```
基本用法
    vi somefile.txt
    首先会进入"一般模式"，此模式只接受各种命令快捷键，不能编辑文本内容。
    按 i 键，就会从一般模式进入"编辑模式"，此模式下，敲入的都是文件内容。
    编辑完成之后，按Esc键退出编辑模式，回到一般模式。
    在按 : ,进入"底行命令模式"，输入wq命令，回车即可保存退出。
常用快捷键(一些有用的快捷键，在一般模式下使用)
	a 在光标后一位开发插入
	A 在该行的最后插入
	I 在该行的最前面插入
	gg 直接跳到文件的首行
	GG 直接跳到文件的末行
	dd 删除一行
	3dd 删除3行
	yy 复制一行
	3yy 复制3行
	p 粘贴
	u undo
```






## linux增强操作
### 基本的用户管理

### 系统管理操作
#### 统计文件或文件夹

du -sh software/    ## 统计指定路径下所有的子目录和文件的大小

df -h 查看磁盘的剩余空间

```bash
[root@localhost ~]# ll
总用量 9164
-rw-------. 1 root root    1247 5月   1 2017 anaconda-ks.cfg
-rw-r--r--. 1 root root 9347946 7月  27 2017 apache-tomcat-9.0.0.M22.tar.gz
drwxr-xr-x. 2 root root       6 10月 16 2017 my_registry
-rw-r--r--. 1 root root   25680 7月  29 2017 mysql57-community-release-el7-11.noarch.rpm
drwxr-xr-x. 3 root root      51 12月 24 07:54 software
[root@localhost ~]# du -sh *
4.0K	anaconda-ks.cfg
9.0M	apache-tomcat-9.0.0.M22.tar.gz
0	my_registry
28K	mysql57-community-release-el7-11.noarch.rpm
69M	software
[root@localhost ~]# du -sh software/
69M	software/
[root@localhost ~]# df -h
文件系统              容量  已用  可用 已用% 挂载点
/dev/mapper/cl_-root   17G  3.9G   14G   23% /
devtmpfs              478M     0  478M    0% /dev
tmpfs                 489M     0  489M    0% /dev/shm
tmpfs                 489M  6.8M  482M    2% /run
tmpfs                 489M     0  489M    0% /sys/fs/cgroup
/dev/sda1            1014M  231M  784M   23% /boot
tmpfs                  98M     0   98M    0% /run/user/0
[root@localhost ~]#
```

#### 进程管理


### SSH免密码登录配置


### 网络管理
#### 主机名配置
查看主机名:hostname

在CentOS/RHEL 7中，有个叫hostnamectl的命令行工具，它允许你查看或修改与主机名相关的配置

centos修改主机名(立即生效，重启后也永久生效): hostnamectl set-hostname hadoop，然后在/etc/hosts中添加hadoop。

注意*：修改的主机名，带有任何的特殊字符或空白字符都将会被移除，并且提供的参数中任何大写字母都会自动转化成小写

一旦修改了静态主机名，/etc/hostname 将被自动更新。然而，/etc/hosts 不会更新以保存所做的修改，所以你需要手动更新/etc/hosts。

```
[root@localhost ~]# hostname
localhost.localdomain
[root@localhost etc]# hostnamectl set-hostname hadoop
[root@localhost etc]# hostname
hadoop
[root@localhost etc]# vi /etc/hosts
[root@localhost etc]# cat /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4 hadoop
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
[root@localhost etc]# reboot
Connection closing...Socket close.

Connection closed by foreign host.

Disconnected from remote host(vm-192.168.17.130) at 05:47:36.

Type `help' to learn how to use Xshell prompt.
[c:\~]$ 

Connecting to 192.168.17.130:22...
Connection established.
To escape to local shell, press 'Ctrl+Alt+]'.

Last login: Tue May 15 05:45:18 2018 from 192.168.17.1
[root@hadoop ~]# hostname
hadoop
[root@hadoop ~]# hostnamectl status
   Static hostname: hadoop
         Icon name: computer-vm
           Chassis: vm
        Machine ID: 950736a7a54044e9ad682443626422be
           Boot ID: bf5e3ffeae9843f6862cd3e5122020c6
    Virtualization: vmware
  Operating System: CentOS Linux 7 (Core)
       CPE OS Name: cpe:/o:centos:centos:7
            Kernel: Linux 3.10.0-693.2.2.el7.x86_64
      Architecture: x86-64
[root@hadoop ~]# cat /etc/hostname 
hadoop
[root@hadoop ~]#
```

#### IP地址配置
#####  临时修改IP

ifconfig eno16777736 192.168.1.101 

注意（eno16777736）是默认第一个网络接口名称，网卡名字

##### 永久修改IP

第一步：查看网络接口

ifconfig

第二步：去对应的网络接口配置文件修改配置，注意文件名称是（ifcfg-默认第一个网络接口名称），文件路径是/etc/sysconfig/network-scripts/

vim /etc/sysconfig/network-scripts/ifcfg-网络接口名称

修改以下配置

TYPE=Ethernet

BOOTPROTO=static

DEFROUTE=yes

IPV4_FAILURE_FATAL=no

IPV6INIT=yes

IPV6_AUTOCONF=yes

IPV6_DEFROUTE=yes

IPV6_FAILURE_FATAL=no

NAME=eno16777736

UUID=9e8d604f-d991-4aa2-88a3-4c679e6f139c

DEVICE=eno16777736

ONBOOT=yes

PEERDNS=yes

PEERROUTES=yes

IPV6_PEERDNS=yes

IPV6_PEERROUTES=yes

HWADDR=00:0c:29:ce:3f:3c  #MAC地址

IPADDR=192.168.1.104     #静态IP

GATEWAY=192.168.1.2     #默认网关

NETMASK=255.255.255.0    #子网掩码

DNS1=192.168.1.2         #DNS配置

第三步：重启网络服务

servicenetwork restart

##### 其他

```
DEVICE=物理设备名
IPADDR=IP地址
NETMASK=掩码值
NETWORK=网络地址
BROADCAST=广播地址
GATEWAY=网关地址
ONBOOT=[yes|no]（引导时是否激活设备）
USERCTL=[yes|no]（非root用户是否可以控制该设备）
BOOTPROTO=[none|static|bootp|dhcp]（引导时不使用协议|静态分配|BOOTP协议|DHCP协议）
HWADDR= 你的MAC地址
```

#### 网络服务管理

#### linux的网卡坏了怎么办

### 高级文本处理命令

#### cut命令

cut命令可以从一个文本文件或者文本流中提取文本列

cut -d'分割字符' -f fields   ## 用于有特定分割字符

cut -c 字符区间                  ## 用于有特定分割字符

选项与参数：

​	-d： 后面接分割字符，与 -f 一起使用；

​	-f ：依据 -d 的分割字符将一段信息分割成为数段，用 -f 取出第几段的意思；

​	-c ：以字符(characters) 的单位取出固定字符区间。 

```
echo $PATH | cut -d':' -f 6         #将PATH变量取出，找出第6个路径
echo $PATH | cut -d':' -f 3,6       #将PATH变量取出，找出第3个和第6个路径
echo $PATH | cut -d':' -f 1-3,6     #将PATH变量取出，找出第1-3个和第6个路径
echo $PATH | cut -d':' -f 3-        #将PATH变量取出，找出第3个到最后
```

示例：

```bash
[root@hadoop /]# echo $PATH
/usr/local/src/java/jdk1.8.0_141/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin
[root@hadoop /]# echo $PATH | cut -d':' -f 5
/usr/bin
[root@hadoop /]# echo $PATH | cut -d':' -f 6
/root/bin
[root@hadoop /]# echo $PATH | cut -d':' -f 3,6
/usr/local/bin:/root/bin
[root@hadoop /]# echo $PATH | cut -d':' -f 1-3,6
/usr/local/src/java/jdk1.8.0_141/bin:/usr/local/sbin:/usr/local/bin:/root/bin
[root@hadoop /]# echo $PATH | cut -d':' -f 3-
/usr/local/bin:/usr/sbin:/usr/bin:/root/bin
```

#### sed命令

```
1.删除: d 命令
  sed '2d' example          # 删除example文件的第2行
  sed '2,$d' example        # 删除example文件的第2行到末尾所有行
  sed '$d' example          # 删除example文件的最后1行
  sed '/test/'d example     # 删除example文件中,所有包含test的行
```



#### awk命令





## linux上软件安装

### linux系统软件安装方式

#### 二进制发布包

软件已经针对具体平台编译打包发布，重要解压，修改配置即可。

#### PRM发布包

软件已经安装redhat的包管理工具规范RPM进行打包发布，需要获取到相应的软件RPM发布包，然后用RPM命令进行安装。

#### Yum在线安装

软件已经以RPM规范打包，但发布在了网络上的一些服务器上，可以用yum在线安装服务器上存在的rpm软件，并且会自动解决软件安装过程中的库依赖问题。（注：类似maven）

#### 源码编译安装

软件以源码工程的形式发布，需要获取到源码工程后用相应及开发工具进行编译打包部署。

### YUM方式软件安装

#### 从网络源使用yum安装软件

yum install XXXX

#### 使用本地yum源安装软件

yum仓库服务器本质上就是一台http服务器，服务器的目录中放置了rpm包，及rpm包的索引信息文件，即可为yum客户端提供rpm文件下载。

#### 制作基于内网web服务器的yum源（虚拟机）

1.在一台机器上部署一个web服务器，确保web服务器运行成功。

2.将包含yum源的光盘镜像文件插入到虚拟机的光驱

3.将光驱挂载到web服务器的一个目录中

4修改yum的repo库配置文件，/etc/yum.repos.d/ 目录下，添加一个自己的配置文件。

5.接下来就可以用yum安装库中拥有的任何软件了。

yum install -y telnet

### C语言软件源码编译安装-redis服务安装

```
用源码工程来编译安装
1.到管网下载最新stable版
2.解压源码并进入目录 tar -zxvf redis-4.0.9.tar.gz -C ./redis-src/
3.make
    如果报错提示缺少gcc,则安装gcc, yum install -y gcc
4.安装redis,指定安装目录,如 /usr/local/redis
    make PREFIX=/usr/local/redis install
5.拷贝一份配置文件到安装目录下
    切换到源码目录。里面有一份配置文件redis.conf,然后将其拷贝到安装路径下
    cp redis.conf /usr/local/redis
6.启动redis
	cd /usr/local/redis
	bin/redis-server redis.conf




















  
```









