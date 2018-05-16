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

#### who查看有谁在线(哪些人登录到了服务器)

1.who 查看当前在线

```bash
[root@localhost ~]# who
root     pts/0        2018-05-14 06:29 (192.168.17.1)
root     pts/1        2018-05-14 07:07 (192.168.17.130)
[root@localhost ~]#
```

2.在linux /var/log/wtmp 日志中以二进制的形式记录了用户登陆的时间和登陆IP，用who 命令可以查看
who /var/log/wtmp

```bash
[root@hadoop /]# who /var/log/wtmp
root     tty1         2017-05-01 15:33
root     pts/0        2017-05-01 15:36 (192.168.17.1)
root     pts/0        2017-05-01 15:39 (192.168.17.1)
root     tty1         2017-07-05 19:53
root     pts/0        2017-07-05 19:54 (192.168.17.1)
root     pts/0        2017-07-08 16:47 (192.168.17.1)
root     pts/1        2017-07-08 16:48 (192.168.17.1)
[root@hadoop /]# who /var/log/wtmp | grep 192.168.17.1 |wc -l
140
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

#### wc命令

Linux wc命令用于计算字数。

利用wc指令我们可以计算文件的Byte数、字数、或是列数，若不指定文件名称、或是所给予的文件名为"-"，则wc指令会从标准输入设备读取数据。

- -c或--bytes或--chars 只显示Bytes数。
- -l或--lines 只显示行数。
- -w或--words 只显示字数。

```bash
[root@hadoop ~]# cat test.txt 
123.0.0.1
1234.0.1
12356
12345
12
123.0.0.1
1234
567
5678
56
586
123.0.0.1

[root@hadoop ~]# cat test.txt | grep 123.0.0.1 | wc 
      3       3      30
[root@hadoop ~]# cat test.txt | grep 123.0.0.1 | wc -l
3
[root@hadoop ~]# cat test.txt | grep 123.0.0.1 | wc -c
30
[root@hadoop ~]# cat test.txt | grep 123.0.0.1 | wc -w
3
[root@hadoop ~]#
```

查看linux系统登录的ip信息：

```
[root@hadoop ~]# who /var/log/wtmp
root     tty1         2017-05-01 15:33
root     pts/0        2017-05-01 15:36 (192.168.17.1)
root     pts/0        2017-05-01 15:39 (192.168.17.1)
root     tty1         2017-07-05 19:53
root     pts/0        2017-07-05 19:54 (192.168.17.1)
root     pts/0        2017-07-08 16:47 (192.168.17.1)
root     pts/1        2017-07-08 16:48 (192.168.17.1)
root     pts/2        2017-07-08 17:26 (192.168.17.1)
[root@hadoop ~]# who /var/log/wtmp | grep 192.168.17.1 |wc -l
6
[root@hadoop ~]#
```

#### 进程管理

Centos7中systemctl命令详解:

LinuxSystemctl是一个系统管理守护进程、工具和库的集合，用于取代System V、service和chkconfig命令，初始进程主要负责控制systemd系统和服务管理器。通过Systemctl –help可以看到该命令主要分为：查询或发送控制命令给systemd服务，管理单元服务的命令，服务文件的相关命令，任务、环境、快照相关命令，systemd服务的配置重载，系统开机关机相关的命令。

```
系统中是否安装有systemd并确定当前安装的版本
# systemctl --version
检查systemctl的二进制文件和库文件的安装位置
# whereis systemctl
列出所有可用单元 
# systemctl list-unit-files
 列出所有运行中单元 
# systemctl list-units
 列出所有失败单元 
# systemctl –failed
检查某个单元（如 crond.service）是否启用 
# systemctl is-enabled crond.service
获取当前某个服务的CPU分配额（如nginx）
# systemctl show -p CPUShares nginx
检查某个服务的所有配置细节
# systemctl show nginx
```

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

##### 删除行: d 命令
```
1.删除行: d 命令
  sed '2d' example          # 删除example文件的第2行
  sed '2,$d' example        # 删除example文件的第2行到末尾所有行
  sed '$d' example          # 删除example文件的最后1行
  sed '/test/'d example     # 删除example文件中,所有包含test的行

[root@hadoop ~]# cat test.txt 
aaaaaaaaaaa1
bbbbbbbbbbb2
ccccc333333
dddd444444
eeeeee555555
fffff666666
gggggg777777
8888888888
9999999999999
[root@hadoop ~]# sed 2d test.txt 
aaaaaaaaaaa1
ccccc333333
dddd444444
eeeeee555555
fffff666666
gggggg777777
8888888888
9999999999999
```

##### 新增行：a 命令
```
2.新增行：a 命令
其中a命令表示在指定行的后面附加一行，1a则是在第一行的后面添加一行，添加的内容就是a后面的内容，如果a的前面没有地址限定则在所有行的后面都会添加指定的字符串.
[root@hadoop ~]# cat test.txt 
a
b
c
d
[root@hadoop ~]# sed '1a hello sed' test.txt 
a
hello sed
b
c
d
[root@hadoop ~]#
```

##### 替换行：c 命令
```
3.替换行：c 命令
命令c会替换指定的行的所有内容，替换成其后面的字符串，所有的新增，删除，替换行，这些命令前面的地址修饰都可以指定地址空间，也都可以使用正则表达式，命令会应用在选出的符合地址条件的所有行上面.例如：
[root@hadoop ~]# cat test.txt 
a
b
c
d
[root@hadoop ~]# sed '1c hello world' test.txt
hello world
b
c
d
[root@hadoop ~]# sed '/^b/c hello world' test.txt
a
hello world
c
d
[root@hadoop ~]#
替换以b开头的行，其内容是c命令后面的字符串
```

##### 替换部分字符串而不是整行：s 命令

```
4.替换部分字符串而不是整行：s 命令

## 我们这里说的就是s命令，执行的结果是我们文件中的 bc 被替换成 BC
[root@hadoop ~]# cat test.txt 
a
bcdefg
cgdsag
d
[root@hadoop ~]# sed 's/bc/BC/' test.txt
a
BCdefg
cgdsag
d

## 可以看到第6行的ccaa中的aa是没有被替换的，也就是说此时仅仅替换了每一行搜索到的第一个aa字符串进行操作，那么如果要对一行里面的所有的符合条件的字符串都做替换操作呢，我们可以使用参数g。在最后一个斜杠后面加上g选项之后，表示进行全局替换，也就是说一行中所有符合条件的旧字符串都会被替换成新字符串，而不仅仅是第一个。
[root@hadoop ~]# cat test.txt 
11 aa
22 bb
33 cc
23 dd
55 2e
66 aaff ccaa
zz ggaa
[root@hadoop ~]# sed 's/aa/AA/' test.txt
11 AA
22 bb
33 cc
23 dd
55 2e
66 AAff ccaa
zz ggAA
[root@hadoop ~]# sed 's/aa/AA/g' test.txt
11 AA
22 bb
33 cc
23 dd
55 2e
66 AAff ccAA
zz ggAA

## 可以看到仅仅对第一行进行了替换操作，1s 。
[root@hadoop ~]# sed '1s/aa/AA/g' test.txt
11 AA
22 bb
33 cc
23 dd
55 2e
66 aaff ccaa
zz ggaa

## 我们在s命令前面添加了 /^[0-9]/ 这个修饰，该正则表达式表示对所有以数字开头的行，执行s操作。
[root@hadoop ~]# sed '/^[0-9]/s/aa/AA/g' test.txt
11 AA
22 bb
33 cc
23 dd
55 2e
66 AAff ccAA
zz ggaa

## 另外一个要说明的是  s/待替换的字符串/新字符串/ 这种格式中 / 作为分隔符并不是一定的，当使用s命令时候，我们可以使用别的分隔符，实际上s后面紧接着的字符就是分隔符，所以不一定是 / 符号。例如：
echo 'aabbccaadd' | sed s#aa#AA#g
输出：
AAbbccAAdd
这里s命令后面跟着的#符号被当作分隔符了
```

##### 搜索并输出行内容

```
sed还提供一个p命令用于搜索符合条件的行，并输出该行的内容，而不做其他的任何修改，例如：
//test.txt
11 aa
22 bb
33 cc
23 dd

sed '2p' test.txt

输出：
11 aa
22 bb
22 bb
33 cc
23 dd

可以看到第二行被输出来了，但是sed好像将文件的所有内容输出了一遍，而第2行则多输出了一次，实际上sed默认情况下是会将所有标准输入的数据又重新输出到标准输出的，我们可以加上 -n 选项让sed仅仅是输出经过处理之后的那些行，而不是输出之前从标准输入中获取到的所有行内容，例如：

sed -n '2p' test.txt

输出：
22 bb

这样仅仅会输出p命令的处理结果了，-n 选项一般是与p命令联合使用的，其他的增加，删除，替换行的命令是不需要 -n 选项的
```

##### 将修改应用到文件中

```
我们之前做的所有实验，实际上都没有修改test.txt文件的内容，也就是说我们看到的修改结果仅仅输出到控制台上，而文件test.txt的内容是没有修改的，我们可以使用 -i 选项告诉sed直接修改文件的内容，而不是将修改结果输出到终端上，例如：
sed -i '2d' test.txt 
命令运行之后，我们发现test.txt的第2行没有了

[root@hadoop ~]# cat test.txt 
11 aa
22 bb
33 cc
23 dd
[root@hadoop ~]# sed -i '2d' test.txt
[root@hadoop ~]# cat test.txt 
11 aa
33 cc
23 dd
[root@hadoop ~]#
```

##### sed正则中的元字符

```
我们知道sed中的命令前面可以使用地址范围进行限制，表示对文件的某些符合条件的行执行相应的操作，其中我们可以使用正则表达式选出要操作的行，而sed中正则的语法可能与我们其他命令的正则语法有一些不同，这里我们有必要列出sed中常用的正则元字符：

$ 表示行尾 
^ 表示行首
[a-z0-9]表示字符范围
[^]表示除了字符集中的字符以外的字符 

sed的正则中  \(\)  和 \{m,n\} 需要转义 
. 表示任意字符  
* 表示零个或者多个  
\+ 一次或多次　　
\? 零次或一次    
\| 表示或语法

```

#### awk命令

##### 简介

awk是一个强大的文本分析工具，相对于grep的查找，sed的编辑，awk在其对数据分析并生成报告时，显得尤为强大。简单来说awk就是把文件逐行的读入，以空格为默认分隔符将每行切片，切开的部分再进行各种分析处理。

awk有3个不同版本: awk、nawk和gawk，未作特别说明，一般指gawk，gawk 是 AWK 的 GNU 版本。

awk其名称得自于它的创始人 Alfred Aho 、Peter Weinberger 和 Brian Kernighan 姓氏的首个字母。实际上 AWK 的确拥有自己的语言： AWK 程序设计语言 ， 三位创建者已将它正式定义为“样式扫描和处理语言”。它允许您创建简短的程序，这些程序读取输入文件、为数据排序、处理数据、对输入执行计算以及生成报表，还有无数其他的功能。

通常，awk是以文件的一行为处理单位的。awk每接收文件的一行，然后执行相应的命令，来处理文本。

##### 入门实例

```
## 假设last -n 5的输出如下:
[root@hadoop ~]# last -n 5
root     pts/0        192.168.17.1     Tue May 15 05:49   still logged in   
reboot   system boot  3.10.0-693.2.2.e Tue May 15 05:47 - 06:46 (2+00:58)   
root     pts/0        192.168.17.1     Tue May 15 05:45 - crash  (00:02)    
reboot   system boot  3.10.0-693.2.2.e Tue May 15 05:44 - 06:46 (2+01:02)   
root     pts/0        192.168.17.1     Mon May 14 21:50 - crash  (07:53)    

wtmp begins Mon May  1 15:32:50 2017
[root@hadoop ~]# 

## 如果只是显示最近登录的5个帐号
[root@hadoop ~]# last -n 5 | awk  '{print $1}'last -n 5 | awk  '{print $1}'
root
reboot
root
reboot
root

wtmp
[root@hadoop ~]#
awk工作流程是这样的：读入有’\n’换行符分割的一条记录，然后将记录按指定的域分隔符划分域，填充域，0则表示所有域,1表示第一个域,n表示第n个域。默认域分隔符是"空白键"或"[tab]键",所以1表示登录用户，$3表示登录用户ip,以此类推。


### 如果只是显示/etc/passwd的账户
#cat /etc/passwd |awk  -F ':'  '{print $1}'  
root
daemon
bin
sys
1
2
3
4
5
这种是awk+action的示例，每行都会执行action{print $1}。
-F指定域分隔符为":" 。
如果只是显示/etc/passwd的账户和账户对应的shell,而账户与shell之间以tab键分割
#cat /etc/passwd |awk  -F ':'  '{print \$1"\t"\$7}'
root    /bin/bash
daemon  /bin/sh
bin     /bin/sh
sys     /bin/sh
```

#####　print和printf

awk中同时提供了print和printf两种打印输出的函数。

其中print函数的参数可以是变量、数值或者字符串。字符串必须用双引号引用，参数用逗号分隔。如果没有逗号，参数就串联在一起而无法区分。这里，逗号的作用与输出文件的分隔符的作用是一样的，只是后者是空格而已。

printf函数，其用法和c语言中printf基本相似,可以格式化字符串,输出复杂时，printf更加好用，代码更易懂。

##### 实例:获取java应用的进程id

```
[root@izuf6ajbxrke67fngx1q5nz ~]# ps aux|grep service-data
root      9443  4.7  4.2 7852068 693936 ?      Sl   May16  51:32 java -jar service-data-0.0.1-SNAPSHOT.jar --server.port=8080 --spring.profiles.active=data-pro
root     12998  0.0  0.0 112660   980 pts/1    S+   06:40   0:00 grep --color=auto service-data
[root@izuf6ajbxrke67fngx1q5nz ~]# echo `ps aux|grep service-data|grep -v grep|awk '{print $2}'`
9443
[root@izuf6ajbxrke67fngx1q5nz ~]#
```

说明: grep -v grep 的含义

```
grep -v grep | grep -v tail 
1、第一部分 “grep -v grep" 在文档中过滤掉包含有grep字符的行
2、第二部分“grep -v tail” 在第一部分过滤掉之后再过滤掉剩余文档中包含有tail字符的行
3、总结一下就是：这条命令的意思就是过滤掉文档中包含字符“grep”和“tail”的行
```

##### awk编程变量和赋值

除了awk的内置变量，awk还可以自定义变量。

下面统计/etc/passwd的账户人数

```
#awk '{count++;print $0;} END{print "user count is ", count}' /etc/passwd
root:x:0:0:root:/root:/bin/bash
......
user count is  401234
```

count是自定义变量。之前的action{}里都是只有一个print,其实print只是一个语句，而action{}可以有多个语句，以;号隔开。

这里没有初始化count，虽然默认是0，但是妥当的做法还是初始化为0:

```
#awk 'BEGIN {count=0;print "[start]user count is ", count} {count=count+1;print $0;} END{print "[end]user count is ", count}' /etc/passwd

[start]user count is  0
root:x:0:0:root:/root:/bin/bash
...
[end]user count is  40
```

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









