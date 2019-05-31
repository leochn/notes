---
title: 搭建hadoop集群
date: 2018-10-12 20:02:50
tags: [linux,hadoop,bigdata]
---
## 分布式集群hadoop搭建
目的：

本文描述了如何安装、配置和管理有实际意义的Hadoop集群

<!-- more -->

### 基础环境配置
#### 配置主机名
```bash
[root@192 ~]# hostname
192.168.175.129
[root@192 ~]# set-hostname vm1
-bash: set-hostname: command not found
[root@192 ~]# hostnamectl set-hostname vm1
[root@192 ~]# hostnamectl status
   Static hostname: vm1
         Icon name: computer-vm
           Chassis: vm
        Machine ID: 8d7786d147a9477cb9fe0aa0f4162439
           Boot ID: 6bafa600abca45ef8a0a58a4da8d9e43
    Virtualization: vmware
  Operating System: CentOS Linux 7 (Core)
       CPE OS Name: cpe:/o:centos:centos:7
            Kernel: Linux 3.10.0-862.el7.x86_64
      Architecture: x86-64
[root@192 ~]# reboot
Connection closing...Socket close.

Connection closed by foreign host.

Disconnected from remote host(VM3-192.168.175.131) at 19:17:38.

Type `help' to learn how to use Xshell prompt.
[C:\~]$ 

Connecting to 192.168.175.131:22...
Connection established.
To escape to local shell, press 'Ctrl+Alt+]'.

WARNING! The remote SSH server rejected X11 forwarding request.
Last login: Fri Mar 29 19:12:16 2019 from 192.168.175.1
[root@vm1 ~]#

```

#### 修改hosts文件
```bash
[root@vm1 ~]# cat /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
[root@vm1 ~]# vim /etc/hosts
[root@vm1 ~]# cat /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
192.168.175.129 vm1
192.168.175.130 vm2
192.168.175.131 vm3
[root@vm1 ~]#
```

#### 安装JDK

##### 查看实时已经安装JDK
```bash
[root@vm1 software]# java -version
-bash: java: command not found
[root@vm1 software]# rpm -qa | grep java
[root@vm1 software]#
```
##### 解压文件
在解压的时候 -C 是解压到指定目录中
```bash
[root@vm1 software]# pwd
/software
[root@vm1 software]# ll
total 514044
-rw-r--r--. 1 root root 334559382 Mar 29 20:35 hadoop-3.1.1.tar.gz
-rw-r--r--. 1 root root 191817140 Mar 29 20:35 jdk-8u201-linux-x64.tar.gz
[root@vm1 software]# tar -zxvf jdk-8u201-linux-x64.tar.gz -C /opt/
[root@vm1 software]# 
[root@vm1 software]# cd /opt/jdk1.8.0_201/
[root@vm1 jdk1.8.0_201]# pwd
/workspace/jdk1.8.0_201
[root@vm1 jdk1.8.0_201]#
[root@vm1 jdk1.8.0_201]# vim /etc/profile
[root@vm1 jdk1.8.0_201]# source /etc/profile
[root@vm1 jdk1.8.0_201]# java -version
java version "1.8.0_201"
Java(TM) SE Runtime Environment (build 1.8.0_201-b09)
Java HotSpot(TM) 64-Bit Server VM (build 25.201-b09, mixed mode)
[root@vm1 jdk1.8.0_201]#

```

##### 说明
```
配置环境变量:
#JAVA_HOME
export JAVA_HOME=/workspace/jdk1.8.0_201
export PATH=$PATH:$JAVA_HOME/bin

使更改的配置立即生效:
source /etc/profile
```

#### 配置免密登录
##### 免密登录原理
```
图片...................
```

##### 生成公钥和私钥
```
[root@vm1 ~]$ ssh-keygen 
然后敲（三个回车），就会生成两个文件id_rsa（私钥）、id_rsa.pub（公钥）
```

##### 实操过程
需要免密登录的服务器：
192.168.175.129
192.168.175.130
192.168.175.131

```bash
[root@vm1 ~]# ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/root/.ssh/id_rsa): 
Created directory '/root/.ssh'.
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /root/.ssh/id_rsa.
Your public key has been saved in /root/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:hPBvLatljYUDmRZp1/etKBgT8bxKrh4GklUfjqqWm5s root@vm1
The key's randomart image is:
+---[RSA 2048]----+
|    . o.oo       |
|     +oOo+. .    |
|    ..O.+.o. . . |
|   o o +oo .  . .|
|  o o   S++  . . |
|   + . +.O. . .  |
|  +   o B ..     |
| . + . *         |
|  E. .+          |
+----[SHA256]-----+
[root@vm1 ~]# ll -a
total 32
dr-xr-x---.  3 root root  163 Mar 29 19:33 .
dr-xr-xr-x. 17 root root  224 Nov  3 23:37 ..
-rw-------.  1 root root 1255 Nov  3 23:38 anaconda-ks.cfg
-rw-------.  1 root root   89 Mar 29 19:17 .bash_history
-rw-r--r--.  1 root root   18 Dec 29  2013 .bash_logout
-rw-r--r--.  1 root root  176 Dec 29  2013 .bash_profile
-rw-r--r--.  1 root root  176 Dec 29  2013 .bashrc
-rw-r--r--.  1 root root  100 Dec 29  2013 .cshrc
drwx------.  2 root root   38 Mar 29 19:33 .ssh
-rw-r--r--.  1 root root  129 Dec 29  2013 .tcshrc
-rw-------.  1 root root  621 Mar 29 19:23 .viminfo
[root@vm1 ~]# pwd
/root
[root@vm1 ~]# ssh-copy-id 192.168.175.130
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/root/.ssh/id_rsa.pub"
The authenticity of host '192.168.175.130 (192.168.175.130)' can't be established.
ECDSA key fingerprint is SHA256:YD0QLGEI9Bcy9hAdOB8AQqz0s4zATq4cYbW1d1d8enI.
ECDSA key fingerprint is MD5:b8:73:79:80:b2:b9:5c:0d:60:bf:e0:d6:20:d4:28:fe.
Are you sure you want to continue connecting (yes/no)? yes
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
root@192.168.175.130's password: 

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh '192.168.175.130'"
and check to make sure that only the key(s) you wanted were added.

[root@vm1 ~]# ssh vm2
The authenticity of host 'vm2 (192.168.175.130)' can't be established.
ECDSA key fingerprint is SHA256:YD0QLGEI9Bcy9hAdOB8AQqz0s4zATq4cYbW1d1d8enI.
ECDSA key fingerprint is MD5:b8:73:79:80:b2:b9:5c:0d:60:bf:e0:d6:20:d4:28:fe.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'vm2' (ECDSA) to the list of known hosts.
Last login: Fri Mar 29 19:18:51 2019 from 192.168.175.1
[root@vm2 ~]#
[root@vm2 ~]# exit
logout
Connection to vm2 closed.
[root@vm1 ~]# ssh 192.168.175.130
Last login: Fri Mar 29 19:38:53 2019 from 192.168.175.129
[root@vm2 ~]#
```

#### 编写集群分发脚本
##### scp可以实现服务器与服务器之间的数据拷贝
```
// 假设远程服务器IP地址为 192.168.1.100

1.从服务器复制文件到本地：
scp root@192.168.1.100:/data/test.txt /home/myfile/
root@192.168.1.100   root是目标服务器（有你需要拷贝文件的服务器）的用户名，192.168.1.100是IP地址，后面紧跟的 “:” 不要忘记，/data/test.txt 是目标服务器中你要拷贝文件的地址，接一个空格，后面的 /home/myfile/ 是本地接收文件的地址。

2.从服务器复制文件夹到本地：
scp -r root@192.168.1.100:/data/ /home/myfile/
只需在前面加 -r 即可，就可以拷贝整个文件夹。

3.从本地复制文件到服务器：
scp /home/myfile/test.txt root@192.168.1.100:/data/

4.从本地复制文件夹到服务器：
scp -r /home/myfile/ root@192.168.1.100:/data/
```
##### rsync远程同步工具
```
rsync远程同步工具,主要用于备份和镜像。具有速度快、 避免复制相同内容和支持符号链接的优点。

安装:
yum -y install rsync

rsync和scp区别:用rsync做文件的复制要比scp的速度快,rsync只对差异文件做更新.scp是把所有文件都复制过去。

基本语法
rsync  -rvl     $pdir/$fname          $user@hadoop$host:$pdir
命令  命令参数    要拷贝的文件路径/名称     目的用户@主机:目的路径
选项
-r 递归
-v 显示复制过程
-l 拷贝符号连接

案例实操
把本机/data/tmp 目录同步到 vm2 服务器的 root 用户下的/data/tmp 目录
[root@vm1 tmp]# rsync -rvl /data/tmp/ root@vm2:/data
bash: rsync: command not found
rsync: connection unexpectedly closed (0 bytes received so far) [sender]
rsync error: remote command not found (code 127) at io.c(226) [sender=3.1.2]
[root@vm1 tmp]#

报错原因：
线上的新服务器（目标服务器）,没有安装rsync导致。

解决办法：
新服务器（目标服务器）执行命令 yum install rsync -y 问题解决。

[root@vm1 tmp]# rsync -rvl /data/tmp/ root@vm2:/data
sending incremental file list
aaa.txt

sent 117 bytes  received 35 bytes  304.00 bytes/sec
total size is 6  speedup is 0.04
[root@vm1 tmp]#

[root@vm1 tmp]# ssh vm2
Last login: Fri Mar 29 19:39:48 2019 from 192.168.175.129
[root@vm2 ~]# ll /data/
total 4
-rw-r--r--. 1 root root 6 Mar 30 08:22 aaa.txt
[root@vm2 ~]#
```
##### 自动化批量安装JDK

在vm1服务器上准备自动化脚本
```bash
[root@vm1 bat]# pwd
/workspace/bat
[root@vm1 bat]# ll
total 8
-rwxrwxrwx. 1 root root 288 Mar 31 05:38 boot.sh
-rwxrwxrwx. 1 root root 334 Mar 31 05:38 install.sh
[root@vm1 bat]
```

**jdkboot.sh**

```bash
#!/bin/bash

SERVERS="vm2 vm3"

## 完成分发jdk压缩包和install.sh到各子机器的操作
## 并让子机器启动install.sh
for SERVER in $SERVERS
do
    scp /software/jdk-8u201-linux-x64.tar.gz root@$SERVER:/root
    scp install.sh root@$SERVER:/root
    ssh root@$SERVER source /root/install.sh
done
```

**jdkinstall.sh**

```bash
#!/bin/bash

## 进入/root目录下
cd /root
## 蒋下载的压缩包解压
tar -zxvf jdk-8u201-linux-x64.tar.gz -C /opt/
## 修改profile配置文件
cat >> /etc/profile << EOF
#JAVA_HOME
export JAVA_HOME=/opt/jdk1.8.0_201
export PATH=\$PATH:\$JAVA_HOME/bin
EOF

## 使更改的配置立即生效
source /etc/profile

java -version
```

#### 关闭防火墙
```
systemctl stop firewalld
```

### 配置hadoop集群
#### 下载hadoop
```
1.下载地址
https://www.apache.org/dyn/closer.cgi/hadoop/common/hadoop-3.1.1/hadoop-3.1.1.tar.gz

2.新建文件
mkdir -p /data/hadoop
-p 确保目录名称存在，如果目录不存在的就新创建一个
```
#### 安装hadoop
```bash
[root@vm1 software]# pwd
/software
[root@vm1 software]# ll
total 514044
-rw-r--r--. 1 root root 334559382 Mar 29 20:35 hadoop-3.1.1.tar.gz
-rw-r--r--. 1 root root 191817140 Mar 29 20:35 jdk-8u201-linux-x64.tar.gz
[root@vm1 software]# tar -zxvf hadoop-3.1.1.tar.gz -C /opt
[root@vm1 software]# 
[root@vm1 hadoop-3.1.1]# pwd
/opt/hadoop-3.1.1
[root@vm1 hadoop-3.1.1]# ll
total 176
drwxr-xr-x. 2 1000 1001    183 Aug  2  2018 bin
drwxr-xr-x. 3 1000 1001     20 Aug  2  2018 etc
drwxr-xr-x. 2 1000 1001    106 Aug  2  2018 include
drwxr-xr-x. 3 1000 1001     20 Aug  2  2018 lib
drwxr-xr-x. 4 1000 1001    288 Aug  2  2018 libexec
-rw-r--r--. 1 1000 1001 147144 Jul 29  2018 LICENSE.txt
-rw-r--r--. 1 1000 1001  21867 Jul 29  2018 NOTICE.txt
-rw-r--r--. 1 1000 1001   1366 Jul 29  2018 README.txt
drwxr-xr-x. 3 1000 1001   4096 Aug  2  2018 sbin
drwxr-xr-x. 4 1000 1001     31 Aug  2  2018 share
[root@vm1 hadoop-3.1.1]# 
```

#### 将hadoop添加到环境变量

```bash
[root@vm1 ~]# vim /etc/profile
[root@vm1 ~]# hadoop
-bash: hadoop: command not found
[root@vm1 ~]# source /etc/profile
[root@vm1 ~]# hadoop version
Hadoop 3.1.1
Source code repository https://github.com/apache/hadoop -r 2b9a8c1d3a2caf1e733d57f346af3ff0d5ba529c
Compiled by leftnoteasy on 2018-08-02T04:26Z
Compiled with protoc 2.5.0
From source with checksum f76ac55e5b5ff0382a9f7df36a3ca5a0
This command was run using /opt/hadoop-3.1.1/share/hadoop/common/hadoop-common-3.1.1.jar
[root@vm1 ~]#
```

```
配置环境变量:
#HADOOP_HOME
export HADOOP_HOME=/opt/hadoop-3.1.1
export PATH=$PATH:$HADOOP_HOME/bin
export PATH=$PATH:$HADOOP_HOME/sbin

使更改的配置立即生效:
source /etc/profile
```

#### 集群部署规划

| 集群 |        vm1         |             vm2             |            vm3             |
| :--: | :----------------: | :-------------------------: | :------------------------: |
| hdfs | NameNode, DataNode |          DataNode           | SecondaryNameNode,DataNode |
| yarn |    NodeManager     | ResourceManager,NodeManager |        NodeManager         |

#### 给vm2配置免密登录
因为vm服务器需要作为ResourceManager的主节点,需要免密登录到vm1,vm2,vm3这3台服务器

首先 ssh-keygen 生成公钥和私钥，然后执行脚本
```bash
[root@vm2 ~]# pwd
/root
[root@vm2 ~]# ll
total 187340
-rw-------. 1 root root      1255 Nov  3 23:38 anaconda-ks.cfg
-rwxrwxrwx. 1 root root       553 Apr  2 07:51 sshboot.sh
[root@vm2 ~]#
[root@vm2 ~]# ./sshboot.sh
```

脚本内容
```bash
#!/bin/bash

SERVERS="vm1 vm2 vm3"
PASSWORD=123qwe!@#
## 实现免密登录的函数
auto_ssh_copy_id() {
    expect -c "set timeout -1;
        spawn ssh-copy-id $1;
        expect {
            *(yes/no)* {send -- yes\r;exp_continue;}
            *assword:* {send -- $2\r;exp_continue;}
            eof        {exit 0;}
        }";
}
ssh_copy_id_to_all() {
    for SERVER in $SERVERS
    do
        auto_ssh_copy_id $SERVER $PASSWORD
    done
}
## 调用免密登录配置函数,实现母机器到子机器的免密登录配置
ssh_copy_id_to_all

```



#### 修改配置文件
**修改hadoop-3.1.1/etc/hadoop里面的文件**

##### core-site.xml
```
<configuration>
  <!-- 指定HADOOP所使用的文件系统schema（URI），HDFS的老大（NameNode）的地址 -->
  <property>
        <name>fs.defaultFS</name>
        <!-- vm1为当前机器名或者ip号 -->
        <value>hdfs://vm1:9000</value>
  </property>
  <!-- 指定hadoop运行时产生临时文件的存储目录,tmp目录会自动创建 -->
  <property>
        <name>hadoop.tmp.dir</name>
        <value>/opt/hadoop-3.1.1/tmp</value>
  </property>
</configuration>
```
##### [hdfs] hadoop-env.sh
```
export JAVA_HOME=/opt/jdk1.8.0_201
```
##### [hdfs] hdfs-site.xml
**hadoop-3.1.1 默认端口9870**

```
<configuration>
  <property>
     <name>dfs.replication</name>
     <value>3</value>
  </property>
  <property>
     <name>dfs.namenode.secondary.http-address</name>
     <value>vm3:9870</value>
  </property>
</configuration>
```
##### [hdfs] workers
hadoop-3.1.1将slaves文件更改为workers，删除localhost
```
vm1
vm2
vm3
```

##### [yarn] yarn-env.sh
```
export JAVA_HOME=/opt/jdk1.8.0_201
```

##### [yarn] yarn-site.xml
```
<configuration>
<!-- Site specific YARN configuration properties -->
  <!-- 指定YARN的老大（ResourceManager）的地址 -->
  <property>
    <name>yarn.resourcemanager.hostname</name>
    <value>vm2</value>
  </property>
  <!-- reducer获取数据的方式 -->
  <property>
    <name>yarn.nodemanager.aux-services</name>
    <value>mapreduce_shuffle</value>
  </property>
</configuration>
```

##### [mapreduce] mapred-env.sh
```
export JAVA_HOME=/opt/jdk1.8.0_201
```

##### [mapreduce] mapred-site.xml
```
<configuration>
  <!-- 指定mr运行在yarn上 -->
  <property>
    <name>mapreduce.framework.name</name>
    <value>yarn</value>
  </property>
</configuration>
```

#### hadoop同步到其他服务器
**hdboot.sh**

```bash
#!/bin/bash

SERVERS="vm2 vm3"

## 完成分发install.sh到各子机器的操作
## 并让子机器启动install.sh
for SERVER in $SERVERS
do
    scp -r /opt/hadoop-3.1.1/ root@$SERVER:/opt/
    scp hdinstall.sh root@$SERVER:/root
    ssh root@$SERVER /root/hdinstall.sh
done
```

**hdinstall.sh**

```bash
#!/bin/bash

## 修改profile配置文件
cat >> /etc/profile << EOF
#HADOOP_HOME
export HADOOP_HOME=/opt/hadoop-3.1.1
export PATH=\$PATH:\$HADOOP_HOME/bin
export PATH=\$PATH:\$HADOOP_HOME/sbin
EOF

## 使更改的配置立即生效
source /etc/profile
```

#### 集群启动
##### 启动NameNode节点，在vm1服务器上启动
**如果集群是第一次启动,需要在格式化namenode**

因为vm1是namenode，vm2、vm3都是datanode，所以只需要对vm1进行初始化操作，也就是对hdfs进行格式化。

 执行初始化脚本，也就是执行命令：hdfs namenode  -format

等待一会后，不报错返回 “Exiting with status 0” 为成功，“Exiting with status 1”为失败

```bash
[root@vm1 hadoop-3.1.1]# pwd
/opt/hadoop-3.1.1
[root@vm1 hadoop-3.1.1]# bin/hdfs namenode -format
```

##### 启动HDFS

**1.启动集群脚本**

在nameNode节点启动集群脚本

```bash
[root@vm1 hadoop-3.1.1]# pwd
/opt/hadoop-3.1.1
[root@vm1 hadoop-3.1.1]# ll
total 176
drwxr-xr-x. 2 1000 1001    183 Aug  2  2018 bin
drwxr-xr-x. 3 1000 1001     20 Aug  2  2018 etc
drwxr-xr-x. 2 1000 1001    106 Aug  2  2018 include
drwxr-xr-x. 3 1000 1001     20 Aug  2  2018 lib
drwxr-xr-x. 4 1000 1001    288 Aug  2  2018 libexec
-rw-r--r--. 1 1000 1001 147144 Jul 29  2018 LICENSE.txt
drwxr-xr-x. 2 root root     37 Mar 31 07:41 logs
-rw-r--r--. 1 1000 1001  21867 Jul 29  2018 NOTICE.txt
-rw-r--r--. 1 1000 1001   1366 Jul 29  2018 README.txt
drwxr-xr-x. 3 1000 1001   4096 Aug  2  2018 sbin
drwxr-xr-x. 4 1000 1001     31 Aug  2  2018 share
[root@vm1 hadoop-3.1.1]# sbin/start-dfs.sh
```

**2.启动是出现错误**

```bash
[root@vm1 hadoop-3.1.1]# pwd
/opt/hadoop-3.1.1
[root@vm1 hadoop-3.1.1]# ll
total 176
drwxr-xr-x. 2 1000 1001    183 Aug  2  2018 bin
drwxr-xr-x. 3 1000 1001     20 Aug  2  2018 etc
drwxr-xr-x. 2 1000 1001    106 Aug  2  2018 include
drwxr-xr-x. 3 1000 1001     20 Aug  2  2018 lib
drwxr-xr-x. 4 1000 1001    288 Aug  2  2018 libexec
-rw-r--r--. 1 1000 1001 147144 Jul 29  2018 LICENSE.txt
drwxr-xr-x. 2 root root     37 Mar 31 07:54 logs
-rw-r--r--. 1 1000 1001  21867 Jul 29  2018 NOTICE.txt
-rw-r--r--. 1 1000 1001   1366 Jul 29  2018 README.txt
drwxr-xr-x. 3 1000 1001   4096 Aug  2  2018 sbin
drwxr-xr-x. 4 1000 1001     31 Aug  2  2018 share
drwxr-xr-x. 3 root root     17 Mar 31 07:54 tmp
[root@vm1 hadoop-3.1.1]# sbin/start-dfs.sh
Starting namenodes on [vm1]
ERROR: Attempting to operate on hdfs namenode as root
ERROR: but there is no HDFS_NAMENODE_USER defined. Aborting operation.
Starting datanodes
ERROR: Attempting to operate on hdfs datanode as root
ERROR: but there is no HDFS_DATANODE_USER defined. Aborting operation.
Starting secondary namenodes [vm3]
ERROR: Attempting to operate on hdfs secondarynamenode as root
ERROR: but there is no HDFS_SECONDARYNAMENODE_USER defined. Aborting operation.
[root@vm1 hadoop-3.1.1]#
```

**3.出现错误,解决办法:**
**是因为缺少用户定义造成的，所以分别编辑开始和关闭脚本**

```
vim sbin/start-dfs.sh 
vim sbin/stop-dfs.sh 

# 在顶部空白处添加内容： 
HDFS_DATANODE_USER=root 
HADOOP_SECURE_DN_USER=hdfs 
HDFS_NAMENODE_USER=root 
HDFS_SECONDARYNAMENODE_USER=root

```

**4.编辑好之后,分发到其他服务器**

```bash
scp /opt/hadoop-3.1.1/sbin/start-dfs.sh root@vm2:/opt/hadoop-3.1.1/sbin/
scp /opt/hadoop-3.1.1/sbin/stop-dfs.sh root@vm2:/opt/hadoop-3.1.1/sbin/

scp /opt/hadoop-3.1.1/sbin/start-dfs.sh root@vm3:/opt/hadoop-3.1.1/sbin/
scp /opt/hadoop-3.1.1/sbin/stop-dfs.sh root@vm3:/opt/hadoop-3.1.1/sbin/
```

##### 检查启动的HDFS实时和规划部署的一致
```bash
[root@vm1 hadoop-3.1.1]# sbin/start-dfs.sh
WARNING: HADOOP_SECURE_DN_USER has been replaced by HDFS_DATANODE_SECURE_USER. Using value of HADOOP_SECURE_DN_USER.
Starting namenodes on [vm1]
Last login: Sun Mar 31 06:46:39 CST 2019 from 192.168.175.1 on pts/1
Starting datanodes
Last login: Sun Mar 31 08:04:50 CST 2019 on pts/0
vm3: WARNING: /opt/hadoop-3.1.1/logs does not exist. Creating.
vm2: WARNING: /opt/hadoop-3.1.1/logs does not exist. Creating.
Starting secondary namenodes [vm3]
Last login: Sun Mar 31 08:04:52 CST 2019 on pts/0
[root@vm1 hadoop-3.1.1]#
[root@vm1 hadoop-3.1.1]# jps -l
16772 sun.tools.jps.Jps
16501 org.apache.hadoop.hdfs.server.datanode.DataNode
16364 org.apache.hadoop.hdfs.server.namenode.NameNode
[root@vm1 hadoop-3.1.1]#

[root@vm2 hadoop]# jps -l
3483 org.apache.hadoop.hdfs.server.datanode.DataNode
3531 sun.tools.jps.Jps
[root@vm2 hadoop]# 

[root@vm3 hadoop-3.1.1]# jps -l
3255 sun.tools.jps.Jps
3224 org.apache.hadoop.hdfs.server.namenode.SecondaryNameNode
3131 org.apache.hadoop.hdfs.server.datanode.DataNode
[root@vm3 hadoop-3.1.1]#
```
##### 浏览器查看

关闭防火墙

```
systemctl stop firewalld
```

<http://192.168.175.129:9870/dfshealth.html#tab-overview>


##### 停止HDFS
```bash
[root@vm1 hadoop-3.1.1]# pwd
/opt/hadoop-3.1.1
[root@vm1 hadoop-3.1.1]# sbin/stop-dfs.sh
WARNING: HADOOP_SECURE_DN_USER has been replaced by HDFS_DATANODE_SECURE_USER. Using value of HADOOP_SECURE_DN_USER.
Stopping namenodes on [vm1]
Last login: Sun Mar 31 08:05:01 CST 2019 on pts/0
Stopping datanodes
Last login: Sun Mar 31 08:56:45 CST 2019 on pts/0
Stopping secondary namenodes [vm3]
Last login: Sun Mar 31 08:56:47 CST 2019 on pts/0
[root@vm1 hadoop-3.1.1]# jps -l
17405 sun.tools.jps.Jps
[root@vm1 hadoop-3.1.1]#
```

##### hadoop多次格式化导致节点不能启动问题

*遇到的问题：*

hadoop 多次格式化format namenode 导致节点不能启动，出现这个问题的原因是多次格式化会导致节点的clusterID不一致。

*解决办法：*

1.先停止所有启动的服务

 /opt/hadoop-3.1.1/sbin/stop-all.sh

2.删除core-site.xml 和hdfs-site.xml文件中配置的文件夹. **注意：这一步在三台机器上都要做**

rm -r /opt/hadoop-3.1.1/tmp,    rm -r /opt/hadoop-3.1.1/logs

##### 启动yarn(启动ResourceManager和NodeManager)

**1.启动脚本,在vm2服务器上启动**

```bash
[root@vm2 hadoop-3.1.1]# sbin/start-yarn.sh
Starting resourcemanager
ERROR: Attempting to operate on yarn resourcemanager as root
ERROR: but there is no YARN_RESOURCEMANAGER_USER defined. Aborting operation.
Starting nodemanagers
ERROR: Attempting to operate on yarn nodemanager as root
ERROR: but there is no YARN_NODEMANAGER_USER defined. Aborting operation.
[root@vm2 hadoop-3.1.1]#
```

**2.出错是因为缺少用户定义造成的，所以分别编辑开始和关闭脚本**

```
vim sbin/start-yarn.sh 
vim sbin/stop-yarn.sh
# 在顶部空白处添加内容：
YARN_RESOURCEMANAGER_USER=root
HADOOP_SECURE_DN_USER=yarn
YARN_NODEMANAGER_USER=root
```

**3.编辑好之后,分发到其他服务器**

```bash
scp /opt/hadoop-3.1.1/sbin/start-yarn.sh root@vm1:/opt/hadoop-3.1.1/sbin/
scp /opt/hadoop-3.1.1/sbin/stop-yarn.sh root@vm1:/opt/hadoop-3.1.1/sbin/

scp /opt/hadoop-3.1.1/sbin/start-yarn.sh root@vm3:/opt/hadoop-3.1.1/sbin/
scp /opt/hadoop-3.1.1/sbin/stop-yarn.sh root@vm3:/opt/hadoop-3.1.1/sbin/
```

**4.启动yarn**

```bash
[root@vm2 hadoop-3.1.1]# vim sbin/start-yarn.sh 
[root@vm2 hadoop-3.1.1]# vim sbin/stop-yarn.sh 
[root@vm2 hadoop-3.1.1]# sbin/start-yarn.sh 
Starting resourcemanager
Last login: Tue Apr  2 19:10:32 CST 2019 on pts/0
Starting nodemanagers
ERROR: Attempting to operate on yarn nodemanager as root
ERROR: but there is no YARN_NODEMANAGER_USER defined. Aborting operation.
[root@vm2 hadoop-3.1.1]# jps
3953 Jps
3171 DataNode
3687 ResourceManager
3407 NodeManager
[root@vm2 hadoop-3.1.1]# sbin/stop-yarn.sh 
Stopping nodemanagers
ERROR: Attempting to operate on yarn nodemanager as root
ERROR: but there is no YARN_NODEMANAGER_USER defined. Aborting operation.
Stopping resourcemanager
Last login: Tue Apr  2 19:12:20 CST 2019 on pts/0
[root@vm2 hadoop-3.1.1]# vim sbin/start-yarn.sh 
[root@vm2 hadoop-3.1.1]# vim sbin/stop-yarn.sh 
[root@vm2 hadoop-3.1.1]# sbin/start-yarn.sh 
Starting resourcemanager
Last login: Tue Apr  2 19:13:02 CST 2019 on pts/0
Starting nodemanagers
Last login: Tue Apr  2 19:14:03 CST 2019 on pts/0
vm1: nodemanager is running as process 7389.  Stop it first.
vm3: nodemanager is running as process 3268.  Stop it first.
vm2: nodemanager is running as process 3407.  Stop it first.
[root@vm2 hadoop-3.1.1]#

```

**5.启动验证**

```
[root@vm2 hadoop-3.1.1]# jps
3171 DataNode
4265 ResourceManager
4638 Jps
3407 NodeManager
[root@vm2 hadoop-3.1.1]#

[root@vm1 hadoop-3.1.1]# jps
7064 DataNode
7529 Jps
6924 NameNode
7389 NodeManager
[root@vm1 hadoop-3.1.1]#

[root@vm3 hadoop-3.1.1]# jps
3427 Jps
3268 NodeManager
3180 SecondaryNameNode
3087 DataNode
[root@vm3 hadoop-3.1.1]#
```

##### 同时启动HDFS和ResourceManager,NodeManager

*1.vm1服务器上启动*

```bash
[root@vm1 hadoop-3.1.1]# sbin/start-all.sh
WARNING: HADOOP_SECURE_DN_USER has been replaced by HDFS_DATANODE_SECURE_USER. Using value of HADOOP_SECURE_DN_USER.
Starting namenodes on [vm1]
Last login: Tue Apr  2 19:45:00 CST 2019 on pts/0
Starting datanodes
Last login: Tue Apr  2 19:47:17 CST 2019 on pts/0
Starting secondary namenodes [vm3]
Last login: Tue Apr  2 19:47:20 CST 2019 on pts/0
Starting resourcemanager
Last login: Tue Apr  2 19:47:28 CST 2019 on pts/0
Starting nodemanagers
Last login: Tue Apr  2 19:47:35 CST 2019 on pts/0
[root@vm1 hadoop-3.1.1]#
```

*2.启动验证*

```
[root@vm1 hadoop-3.1.1]# jps
8339 NameNode
9157 Jps
8478 DataNode
9006 NodeManager
[root@vm1 hadoop-3.1.1]#

[root@vm2 hadoop-3.1.1]# jps
5110 DataNode
5206 NodeManager
5335 Jps
[root@vm2 hadoop-3.1.1]#

[root@vm3 hadoop-3.1.1]# jps
3992 Jps
3881 NodeManager
3802 SecondaryNameNode
3708 DataNode
[root@vm3 hadoop-3.1.1]#
```

*3.停止服务*

```
[root@vm1 hadoop-3.1.1]# sbin/stop-all.sh 
```










