---
title: hadoop集群搭建
date: 2018-10-11 22:57:05
tags: [linux,hadoop,bigdata]
---
## 本次测试所用软件及环境
    Centos7
    jdk-8u171-linux-x64.rpm
    VMware 12 Pro
    hadoop 3.1.1
<!-- more -->
## 环境配置(配置3台centos服务器)
### 配置主机名和hosts文件
```
[root@localhost etc]# hostnamectl set-hostname mini-1
[root@localhost etc]# hostname
mini-1
[root@localhost etc]# vi /etc/hosts
[root@localhost etc]# cat /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4 mini-1
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
[root@localhost etc]# reboot
[root@mini-1 /]# hostnamectl status
   Static hostname: mini-1
         Icon name: computer-vm
           Chassis: vm
        Machine ID: 8772e349b79f4733a7e389a4ff332d82
           Boot ID: bcb9f3facfac4d07be53a6848b4bb0a0
    Virtualization: vmware
  Operating System: CentOS Linux 7 (Core)
       CPE OS Name: cpe:/o:centos:centos:7
            Kernel: Linux 3.10.0-862.el7.x86_64
      Architecture: x86-64
[root@mini-1 /]#
[root@mini-1 /]# cat /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
192.168.17.133 mini1
192.168.17.134 mini2
192.168.17.135 mini3
192.168.17.136 mini4
[root@mini-1 /]#
```
### yum安装jdk
```
[root@mini-1 /]# java -version
java version "1.8.0_171"
Java(TM) SE Runtime Environment (build 1.8.0_171-b11)
Java HotSpot(TM) 64-Bit Server VM (build 25.171-b11, mixed mode)
[root@mini-1 /]# rpm -qa | grep jdk
jdk1.8-1.8.0_171-fcs.x86_64
[root@mini-1 /]# 
[root@mini-1 /]# rpm -e --nodeps jdk1.8-1.8.0_171-fcs.x86_64
[root@mini-1 /]# java -version
-bash: /usr/bin/java: No such file or directory
[root@mini-1 /]# rpm -qa | grep jdk
[root@mini-1 /]#
[root@mini-1 /]# cd /data/
[root@mini-1 data]# ll
total 171156
-rw-r--r--. 1 root root 175262413 Oct 12 20:01 jdk-8u171-linux-x64.rpm
[root@mini-1 data]# 
[root@mini-1 data]# yum install jdk-8u171-linux-x64.rpm
[root@mini-1 data]# 
[root@mini-1 data]# whereis java
java: /usr/bin/java /usr/share/man/man1/java.1
[root@mini-1 data]# ll /usr/bin/java
lrwxrwxrwx. 1 root root 22 Oct 12 20:02 /usr/bin/java -> /etc/alternatives/java
[root@mini-1 data]# ll /etc/alternatives/java
lrwxrwxrwx. 1 root root 41 Oct 12 20:02 /etc/alternatives/java -> /usr/java/jdk1.8.0_171-amd64/jre/bin/java
[root@mini-1 data]# cd /usr/java/
[root@mini-1 java]# ll
total 0
lrwxrwxrwx. 1 root root  16 Oct 12 20:02 default -> /usr/java/latest
drwxr-xr-x. 9 root root 268 Oct 12 20:02 jdk1.8.0_171-amd64
lrwxrwxrwx. 1 root root  28 Oct 12 20:02 latest -> /usr/java/jdk1.8.0_171-amd64
[root@mini-1 java]# cd jdk1.8.0_171-amd64/
[root@mini-1 jdk1.8.0_171-amd64]# pwd
/usr/java/jdk1.8.0_171-amd64
[root@mini-1 jdk1.8.0_171-amd64]# ll
total 25964
drwxr-xr-x. 2 root root     4096 Oct 12 20:02 bin
-rw-r--r--. 1 root root     3244 Mar 29  2018 COPYRIGHT
drwxr-xr-x. 4 root root      122 Oct 12 20:02 db
drwxr-xr-x. 3 root root      132 Oct 12 20:02 include
-rw-r--r--. 1 root root  5203779 Mar 29  2018 javafx-src.zip
drwxr-xr-x. 5 root root      185 Oct 12 20:02 jre
drwxr-xr-x. 5 root root      245 Oct 12 20:02 lib
-rw-r--r--. 1 root root       40 Mar 29  2018 LICENSE
drwxr-xr-x. 4 root root       47 Oct 12 20:02 man
-rw-r--r--. 1 root root      159 Mar 29  2018 README.html
-rw-r--r--. 1 root root      424 Mar 29  2018 release
-rw-r--r--. 1 root root 21098592 Mar 29  2018 src.zip
-rw-r--r--. 1 root root   106782 Mar 29  2018 THIRDPARTYLICENSEREADME-JAVAFX.txt
-rw-r--r--. 1 root root   145180 Mar 29  2018 THIRDPARTYLICENSEREADME.txt
[root@mini-1 jdk1.8.0_171-amd64]#
```
### 配置免密登录
```
1.在"192.168.17.130"服务器上使用"ssh-keygen -t rsa"命令来创建公钥
ssh-keygen -t rsa -C app@163.com, 然后回车
    代码参数含义： -t 指定密钥类型，默认是 rsa ，可以省略。 -C 设置注释文字，比如邮箱。

2.再将 192.168.17.133 服务器自己的公钥拷贝并追加到 192.168.17.134 服务器的授权列表文件 authorized_keys中。
    直接一条命令: ssh-copy-id 192.168.17.134 (推荐用这条命令)
```

## 下载安装hadoop
```
1.下载地址: 
https://www.apache.org/dyn/closer.cgi/hadoop/common/hadoop-3.1.1/hadoop-3.1.1.tar.gz

2.解压资源
新建hadoop文件： mkdir -p  /data/hadoop
并将hadoop-3.1.1.tar.gz放入 /data/hadoop 目录下
进入该目录 cd /data/hadoop
解压该文件 tar -zxvf hadoop-3.1.1.tar.gz
[root@mini-1 hadoop]# pwd
/data/hadoop
[root@mini-1 hadoop]# ll
total 326720
-rw-r--r--. 1 root root 334559382 Oct 17 06:19 hadoop-3.1.1.tar.gz
[root@mini-1 hadoop]# tar -zxvf hadoop-3.1.1.tar.gz
```


## 将hadoop添加到环境变量
```
vim /etc/profile
    export HADOOP_HOME=/data/hadoop/hadoop-3.1.1
    export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

source /etc/profile
```

## 关闭防火墙
```
systemctl stop firewalld
```

## 伪分布式运行Hadoop
### 启动HDFS并运行MapReduce程序
#### 配置hadoop资源
```
[root@mini-1 hadoop]# pwd
/data/hadoop/hadoop-3.1.1/etc/hadoop
```

##### 修改hadoop-env.sh
```
大约54行,替换本机的JAVA_HOME目录：
export JAVA_HOME=/usr/java/jdk1.8.0_171-amd64
```

##### 修改core-site.xml
```
1.文件最后<configuration> </configuration> 替换为：

<configuration>
  <!-- 指定HDFS的老大（NameNode）的地址 -->
  <property>
        <name>fs.defaultFS</name>
        <!-- mini-1为当前机器名或者ip号 -->
        <value>hdfs://mini-1:9000</value>
  </property>
  <!-- 指定hadoop运行时产生临时文件的存储目录 -->
  <!-- 配置的目录会自动创建 -->
  <property>
        <name>hadoop.tmp.dir</name>
        <value>/data/hadoop/hadoop-3.1.1/tmp</value>
  </property>
</configuration>
```

##### 修改hdfs-site.xml
```
文件最后<configuration> </configuration> 替换为:

<configuration>
  <!-- 指定 HDFS 副本的数量.不配置的话,默认值为3,根据情况设定 -->
  <!-- HDFS副本是存在不同的节点上的 -->
  <property>
      <name>dfs.replication</name>
      <value>1</value>
  </property>
</configuration>
```

#### 启动单机hadoop
##### 格式化namenode
第一次启动时格式化，以后就不要总格式化
```
[root@mini-1 hadoop-3.1.1]# pwd
/data/hadoop/hadoop-3.1.1
[root@mini-1 hadoop-3.1.1]# cd
[root@mini-1 ~]# pwd
/root
[root@mini-1 ~]# hadoop namenode -format
[root@mini-1 ~]# jps -l
20027 sun.tools.jps.Jps
[root@mini-1 ~]#
```

表示成功格式化
```
2018-10-17 12:21:23,333 INFO common.Storage: Storage directory /data/hadoop/hadoop-3.1.1/tmp/dfs/name has been successfully formatted.
```
##### 启动namenode
```
[root@mini-1 ~]# pwd
/root
[root@mini-1 ~]# hadoop-daemon.sh start namenode
WARNING: Use of this script to start HDFS daemons is deprecated.
WARNING: Attempting to execute replacement "hdfs --daemon start" instead.
[root@mini-1 ~]# jps -l
20273 org.apache.hadoop.hdfs.server.namenode.NameNode
20296 sun.tools.jps.Jps
[root@mini-1 ~]# 
```
##### 启动datanode
```
[root@mini-1 ~]# hadoop-daemon.sh start datanode
WARNING: Use of this script to start HDFS daemons is deprecated.
WARNING: Attempting to execute replacement "hdfs --daemon start" instead.
[root@mini-1 ~]# jps -l
20273 org.apache.hadoop.hdfs.server.namenode.NameNode
20625 org.apache.hadoop.hdfs.server.datanode.DataNode
20660 sun.tools.jps.Jps
[root@mini-1 ~]#
```

##### 停止的命令
```
停止datanode
[root@mini-1 ~]#  hadoop-daemon.sh stop datanode
停止namenode
[root@mini-1 ~]# hadoop-daemon.sh stop namenode
```

#### 查看Hadoop
##### 查看是否启动成功
```
[root@mini-1 ~]# jps -l
20273 org.apache.hadoop.hdfs.server.namenode.NameNode
20625 org.apache.hadoop.hdfs.server.datanode.DataNode
20660 sun.tools.jps.Jps
[root@mini-1 ~]#
```

##### 查看产生的log日志
```
/data/hadoop/hadoop-3.1.1/logs
[root@mini-1 logs]# ll
total 76
-rw-r--r--. 1 root root 30278 Oct 17 12:31 hadoop-root-datanode-mini-1.log
-rw-r--r--. 1 root root   690 Oct 17 12:30 hadoop-root-datanode-mini-1.out
-rw-r--r--. 1 root root 34506 Oct 17 12:31 hadoop-root-namenode-mini-1.log
-rw-r--r--. 1 root root   690 Oct 17 12:26 hadoop-root-namenode-mini-1.out
-rw-r--r--. 1 root root     0 Oct 17 12:18 SecurityAuth-root.audit
[root@mini-1 logs]#
```

##### web端查看HDFS文件系统
```
( 50070端口 -> 9870端口了)
http://192.168.17.133:9870/dfshealth.html#tab-overview
```

#### 操作hadoop
##### 在hdfs文件系统上创建一个/data/input文件夹 (创建)
hadoop fs -mkdir -p /data/input

```
[root@mini-1 ~]# hadoop fs -mkdir -p /data/input
[root@mini-1 ~]# hadoop fs -ls /
Found 1 items
drwxr-xr-x   - root supergroup          0 2018-10-17 17:34 /data
[root@mini-1 ~]# hadoop fs -ls /data/
Found 1 items
drwxr-xr-x   - root supergroup          0 2018-10-17 17:34 /data/input
[root@mini-1 ~]#
```

##### 将测试文件内容上传到文件系统上 (上传)
```
[root@mini-1 ~]# ll
total 8
-rw-------. 1 root root 1243 Jun 23 07:25 anaconda-ks.cfg
-rw-r--r--. 1 root root   32 Jul 22 10:19 device.log
[root@mini-1 ~]# hadoop fs -put device.log /data
[root@mini-1 ~]# hadoop fs -ls /data
Found 2 items
-rw-r--r--   3 root supergroup         32 2018-10-17 17:55 /data/device.log
drwxr-xr-x   - root supergroup          0 2018-10-17 17:34 /data/input
[root@mini-1 ~]#
```

##### 查看上传的文件是否正确
```
[root@mini-1 ~]# ll
total 8
-rw-------. 1 root root 1243 Jun 23 07:25 anaconda-ks.cfg
-rw-r--r--. 1 root root   32 Jul 22 10:19 device.log
[root@mini-1 ~]# cat device.log 
deviceqweqweqweqwqqwqewqweqwqew
[root@mini-1 ~]# hadoop fs -cat /data/device.log
deviceqweqweqweqwqqwqewqweqwqew
```
##### 运行mapreduce程序
```
[root@mini-1 ~]# hadoop fs -put tmp.log /data/input
[root@mini-1 ~]# hadoop fs -ls /data/input
Found 1 items
-rw-r--r--   3 root supergroup         55 2018-10-17 18:28 /data/input/tmp.log
[root@mini-1 ~]# hadoop fs -cat /data/input/tmp.log
tone tone
tingting
hongfu
jinjin liangliang liangliang
[root@mini-1 ~]#
[root@mini-1 hadoop-3.1.1]# pwd
/data/hadoop/hadoop-3.1.1
[root@mini-1 hadoop-3.1.1]# hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-3.1.1.jar wordcount /data/input data/output
```

##### 查看运行mapreduce程序的输出结果
```
[root@mini-1 hadoop-3.1.1]# hadoop fs -ls /
Found 2 items
drwxr-xr-x   - root supergroup          0 2018-10-17 17:55 /data
drwxr-xr-x   - root supergroup          0 2018-10-17 18:34 /user
[root@mini-1 hadoop-3.1.1]# hadoop fs -ls /user/root/data/output
Found 2 items
-rw-r--r--   3 root supergroup          0 2018-10-17 18:34 /user/root/data/output/_SUCCESS
-rw-r--r--   3 root supergroup         49 2018-10-17 18:34 /user/root/data/output/part-r-00000
[root@mini-1 hadoop-3.1.1]# hadoop fs -cat /user/root/data/output/part-r-00000
hongfu  1
jinjin  1
liangliang  2
tingting  1
tone  2
[root@mini-1 hadoop-3.1.1]#
```

### YARN上运行MapReduce程序
#### 配置hadoop资源
hadoop-env.sh,core-site.xml,hdfs-site.xml 的配置同上.
##### 配置yarn-env.sh
未做配置............

##### 配置yarn-site.xml
```
文件最后<configuration> </configuration> 替换为:

<configuration>
  <!-- 指定YARN的老大（ResourceManager）的地址 -->
  <property>
    <name>yarn.resourcemanager.hostname</name>
    <value>192.168.17.133</value>
  </property>
  <!-- reducer获取数据的方式 -->
  <property>
    <name>yarn.nodemanager.aux-services</name>
    <value>mapreduce_shuffle</value>
  </property>
</configuration>
```

##### 配置mapred-env.sh
未做配置............

##### 配置mapred-site.xml
```
文件最后<configuration> </configuration> 替换为:

<configuration>
  <!-- 指定mr运行在yarn上 -->
  <property>
    <name>mapreduce.framework.name</name>
    <value>yarn</value>
  </property>
</configuration>
```

#### 启动集群
启动resourcemanager, 启动nodemanager
```
[root@mini-1 sbin]# jps -l
4528 org.apache.hadoop.hdfs.server.namenode.NameNode
4624 org.apache.hadoop.hdfs.server.datanode.DataNode
4724 sun.tools.jps.Jps
[root@mini-1 sbin]# yarn-daemon.sh start resourcemanager
WARNING: Use of this script to start YARN daemons is deprecated.
WARNING: Attempting to execute replacement "yarn --daemon start" instead.
[root@mini-1 sbin]# jps -l
4528 org.apache.hadoop.hdfs.server.namenode.NameNode
4624 org.apache.hadoop.hdfs.server.datanode.DataNode
4816 org.apache.hadoop.yarn.server.resourcemanager.ResourceManager
4838 sun.tools.jps.Jps
[root@mini-1 sbin]# yarn-daemon.sh start nodemanager
WARNING: Use of this script to start YARN daemons is deprecated.
WARNING: Attempting to execute replacement "yarn --daemon start" instead.
[root@mini-1 sbin]# jps -l
4528 org.apache.hadoop.hdfs.server.namenode.NameNode
4624 org.apache.hadoop.hdfs.server.datanode.DataNode
4816 org.apache.hadoop.yarn.server.resourcemanager.ResourceManager
5281 sun.tools.jps.Jps
5260 org.apache.hadoop.yarn.server.nodemanager.NodeManager
[root@mini-1 sbin]#
```

#### 操作集群
##### yarn的浏览器页面查看
```
http://192.168.17.133:8088/cluster
```

#### 停止集群
```
[root@mini-1 hadoop-3.1.1]# pwd
/data/hadoop/hadoop-3.1.1
[root@mini-1 hadoop-3.1.1]#
[root@mini-1 hadoop-3.1.1]# sbin/yarn-daemon.sh stop nodemanager
WARNING: Use of this script to stop YARN daemons is deprecated.
WARNING: Attempting to execute replacement "yarn --daemon stop" instead.
[root@mini-1 hadoop-3.1.1]#
[root@mini-1 hadoop-3.1.1]# sbin/yarn-daemon.sh stop resourcemanager
WARNING: Use of this script to stop YARN daemons is deprecated.
WARNING: Attempting to execute replacement "yarn --daemon stop" instead.
[root@mini-1 hadoop-3.1.1]# hadoop-daemon.sh stop datanode
WARNING: Use of this script to stop HDFS daemons is deprecated.
WARNING: Attempting to execute replacement "hdfs --daemon stop" instead.
[root@mini-1 hadoop-3.1.1]# hadoop-daemon.sh stop namenode
WARNING: Use of this script to stop HDFS daemons is deprecated.
WARNING: Attempting to execute replacement "hdfs --daemon stop" instead.
[root@mini-1 hadoop-3.1.1]# jps -l
27550 sun.tools.jps.Jps
[root@mini-1 hadoop-3.1.1]#
```

#### 配置文件说明
```
Hadoop 配置文件分两类:
默认配置文件和自定义配置文件，只有用户想修改某一默认配置值时,才需要修改自定义配置文件, 更改相应属性值

(1).默认配置文件：存放在 hadoop 相应的 jar 包中
[core-default.xml]
hadoop-common-3.1.1.jar/ core-default.xml
[hdfs-default.xml]
hadoop-hdfs-3.1.1.jar/ hdfs-default.xml
[yarn-default.xml]
hadoop-yarn-common-3.1.1.jar/ yarn-default.xml
[core-default.xml]
hadoop-mapreduce-client-core-3.1.1.jar/ core-default.xml

(2).自定义配置文件： 存放在$HADOOP_HOME/etc/hadoop
core-site.xml
hdfs-site.xml
yarn-site.xml
mapred-site.xml
```

## 完全分布式部署Hadoop
### 虚拟机准备
```
准备3台虚拟机
配置主机名和hosts文件(同2.1)
安装jdk
配置SSH免密码登录
```
### scp
```
scp可以实现服务器与服务器之间的数据拷贝

实例
1.从本地复制到远程
命令格式：
  scp local_file remote_username@remote_ip:remote_folder 
或者 
  scp local_file remote_username@remote_ip:remote_file 
或者 
  scp local_file remote_ip:remote_folder 
或者 
  scp local_file remote_ip:remote_file 

第1,2个指定了用户名，命令执行后需要再输入密码，第1个仅指定了远程的目录，文件名字不变，第2个指定了文件名.

第3,4个没有指定用户名，命令执行后需要输入用户名和密码，第3个仅指定了远程的目录，文件名字不变，第4个指定了文件名.

应用实例：
scp /home/space/music/1.mp3 root@www.runoob.com:/home/root/others/music 
scp /home/space/music/1.mp3 root@www.runoob.com:/home/root/others/music/001.mp3 
scp /home/space/music/1.mp3 www.runoob.com:/home/root/others/music 
scp /home/space/music/1.mp3 www.runoob.com:/home/root/others/music/001.mp3 

复制目录命令格式：
  scp -r local_folder remote_username@remote_ip:remote_folder 
或者 
  scp -r local_folder remote_ip:remote_folder 
第1个指定了用户名，命令执行后需要再输入密码；
第2个没有指定用户名，命令执行后需要输入用户名和密码；

应用实例：
scp -r /home/space/music/ root@www.runoob.com:/home/root/others/ 
scp -r /home/space/music/ www.runoob.com:/home/root/others/ 
上面命令将本地 music 目录复制到远程 others 目录下。

2.从远程复制到本地

从远程复制到本地，只要将从本地复制到远程的命令的后2个参数调换顺序即可，如下实例

应用实例：
scp root@www.runoob.com:/home/root/others/music /home/space/music/1.mp3 
scp -r www.runoob.com:/home/root/others/ /home/space/music/

3.说明
(1).如果远程服务器防火墙有为scp命令设置了指定的端口，我们需要使用 -P 参数来设置命令的端口号，命令格式如下：

scp 命令使用端口号 4588
scp -P 4588 remote@www.runoob.com:/usr/local/sin.sh /home/administrator
(2).使用scp命令要确保使用的用户具有可读取远程服务器相应文件的权限，否则scp命令是无法起作用的。
```
### rsync
```
rsync 远程同步工具，主要用于备份和镜像。具有速度快、 避免复制相同内容和支持符
号链接的优点。

安装:
yum -y install rsync

rsync 和 scp 区别： 用 rsync 做文件的复制要比 scp 的速度快， rsync 只对差异文件做更
新。 scp 是把所有文件都复制过去。

基本语法
rsync  -rvl     $pdir/$fname          $user@hadoop$host:$pdir
命令  命令参数   要拷贝的文件路径/名称   目的用户@主机:目的路径
选项
-r 递归
-v 显示复制过程
-l 拷贝符号连接

案例实操
把本机/data/tmp 目录同步到 mini2 服务器的 root 用户下的/data/tmp 目录
[root@mini-1 data]# rsync -rvl /data/tmp/ root@mini2:/data
bash: rsync: command not found
rsync: connection unexpectedly closed (0 bytes received so far) [sender]
rsync error: remote command not found (code 127) at io.c(226) [sender=3.1.2]
[root@mini-1 data]#

报错原因：
线上的新服务器没有安装rsync导致。

解决办法：
新服务器（目标服务器）执行命令 yum install rsync -y 问题解决。

目标服务器安装rsync之后,重新执行:
[root@mini-1 data]# rsync -rvl /data/tmp root@mini3:/data
sending incremental file list
tmp/
tmp/test.txt

sent 138 bytes  received 39 bytes  118.00 bytes/sec
total size is 15  speedup is 0.08
[root@mini-1 data]#
```
### 编写集群分发脚本 xsync
```
1.需求分析：循环复制文件到所有节点的相同目录下
（1）原始拷贝：
  rsync -rvl /opt/module root@hadoop103:/opt/
（2）期望脚本：
  xsync 要同步的文件名称
（3）在/usr/local/bin 这个目录下存放的脚本，可以在系统任何地方直接执行。

2.案例实操：
（1）在/usr/local/bin 目录下创建 xsync 文件， 文件内容如下：
  [root@mini-1 tmp]# cd /usr/local/bin/
  [root@mini-1 bin]# ll
  total 0
  [root@mini-1 bin]# touch xsync
  [root@mini-1 bin]# vim xsync 

  -----------------------------------------------------------------------------
  #!/bin/bash
  #1 获取输入参数个数， 如果没有参数，直接退出
  pcount=$#
  if((pcount==0)); then
  echo no args;
  exit;
  fi
  #2 获取文件名称
  p1=$1
  fname=`basename $p1`
  echo fname=$fname
  #3 获取上级目录到绝对路径
  pdir=`cd -P $(dirname $p1); pwd`
  echo pdir=$pdir
  #4 获取当前用户名称
  user=`whoami`
  #5 循环
  for((host=1; host<3; host++)); do
  #echo $pdir/$fname $user@mini-$host:$pdir
  echo --------------- mini-$host ----------------
  rsync -rvl $pdir/$fname $user@mini$host:$pdir
  done
  -----------------------------------------------------------------------------

（2）修改脚本 xsync 具有执行权限
  [root@mini-1 bin]# chmod 777 xsync
  [root@mini-1 bin]# ll
  total 4
  -rwxrwxrwx. 1 root root 536 Dec  2 17:37 xsync
  [root@mini-1 bin]#
（3） 调用脚本形式： xsync 文件名称
  [root@mini-1 data]# pwd
  /data
  [root@mini-1 data]# ll
  total 171156
  drwxr-xr-x. 3 root root        53 Oct 17 06:39 hadoop
  -rw-r--r--. 1 root root 175262413 Oct 12 20:01 jdk-8u171-linux-x64.rpm
  drwxr-xr-x. 2 root root        22 Dec  2 17:34 tmp
  [root@mini-1 data]#
  [root@mini-1 data]# xsync tmp/
  fname=tmp
  pdir=/data
  --------------- mini2 ----------------
  sending incremental file list
  tmp/
  tmp/test.txt

  sent 138 bytes  received 39 bytes  118.00 bytes/sec
  total size is 15  speedup is 0.08
  --------------- mini3 ----------------
  sending incremental file list
  tmp/
  tmp/test.txt

  sent 138 bytes  received 39 bytes  354.00 bytes/sec
  total size is 15  speedup is 0.08
  [root@mini-1 data]#

  (4) 校验是否复制成功
  [root@mini-2 data]# ll
  total 0
  drwxr-xr-x. 3 root root 53 Dec  2 21:15 hadoop
  drwxr-xr-x. 2 root root 22 Dec  6 06:46 tmp
  [root@mini-2 data]# 
```
### 配置集群
#### 集群部署规划

|  | mini-1 | mini-2 | mini-3 |
| :------: | :------: | :------: |:------: |
| hdfs | NameNode, DataNode | DataNode |SecondaryNameNode,DataNode |
| yarn | NodeManager | ResourceManager,NodeManager |NodeManager |

#### 配置文件
##### core-site.xml
```
<configuration>
  <!-- 指定HADOOP所使用的文件系统schema（URI），HDFS的老大（NameNode）的地址 -->
  <property>
        <name>fs.defaultFS</name>
        <!-- mini-1为当前机器名或者ip号 -->
        <value>hdfs://mini1:9000</value>
  </property>
  <!-- 指定hadoop运行时产生临时文件的存储目录 -->
  <property>
        <name>hadoop.tmp.dir</name>
        <value>/data/hadoop/hadoop-3.1.1/tmp</value>
  </property>
</configuration>
```

##### hdfs

1 hadoop-env.sh
```
export JAVA_HOME=/usr/java/jdk1.8.0_171-amd64
```

2 hdfs-site.xml
```
<configuration>
  <property>
     <name>dfs.replication</name>
     <value>3</value>
  </property>
  <property>
     <name>dfs.namenode.secondary.http-address</name>
     <value>mini3:50090</value>
  </property>
</configuration>
```

3 slaves

vim slaves
```
mini1
mini2
mini3
```
##### yarn
1.yarn-env.sh
```
export JAVA_HOME=/usr/java/jdk1.8.0_171-amd64
```

2.yarn-site.xml
```
<configuration>
<!-- Site specific YARN configuration properties -->
  <!-- 指定YARN的老大（ResourceManager）的地址 -->
  <property>
    <name>yarn.resourcemanager.hostname</name>
    <value>mini2</value>
  </property>
  <!-- reducer获取数据的方式 -->
  <property>
    <name>yarn.nodemanager.aux-services</name>
    <value>mapreduce_shuffle</value>
  </property>
</configuration>
```

#####  mapreduce
1.mapred-env.sh
```
export JAVA_HOME=/usr/java/jdk1.8.0_171-amd64
```

2.mapred-site.xml
```
<configuration>
  <!-- 指定mr运行在yarn上 -->
  <property>
    <name>mapreduce.framework.name</name>
    <value>yarn</value>
  </property>
</configuration>
```
#### 在集群上分发以上所有文件
```
[root@mini-1 etc]# pwd
/data/hadoop/hadoop-3.1.1/etc
[root@mini-1 etc]# ll
total 4
drwxr-xr-x. 3 1000 1001 4096 Dec  6 06:41 hadoop
[root@mini-1 etc]#
[root@mini-1 etc]# xsync hadoop/
fname=hadoop
pdir=/data/hadoop/hadoop-3.1.1/etc
--------------- mini2 ----------------
sending incremental file list
hadoop/capacity-scheduler.xml
hadoop/configuration.xsl
hadoop/container-executor.cfg
hadoop/core-site.xml
hadoop/hadoop-env.cmd
hadoop/hadoop-env.sh
hadoop/hadoop-metrics2.properties
hadoop/hadoop-policy.xml
hadoop/hadoop-user-functions.sh.example
hadoop/hdfs-site.xml
hadoop/httpfs-env.sh
hadoop/httpfs-log4j.properties
hadoop/httpfs-signature.secret
hadoop/httpfs-site.xml
hadoop/kms-acls.xml
hadoop/kms-env.sh
hadoop/kms-log4j.properties
hadoop/kms-site.xml
hadoop/log4j.properties
hadoop/mapred-env.cmd
hadoop/mapred-env.sh
hadoop/mapred-queues.xml.template
hadoop/mapred-site.xml
hadoop/slaves
hadoop/ssl-client.xml.example
hadoop/ssl-server.xml.example
hadoop/user_ec_policies.xml.template
hadoop/workers
hadoop/yarn-env.cmd
hadoop/yarn-env.sh
hadoop/yarn-site.xml
hadoop/yarnservice-log4j.properties
hadoop/shellprofile.d/example.sh

sent 5,066 bytes  received 1,651 bytes  4,478.00 bytes/sec
total size is 106,896  speedup is 15.91
--------------- mini3 ----------------
sending incremental file list
hadoop/capacity-scheduler.xml
hadoop/configuration.xsl
hadoop/container-executor.cfg
hadoop/core-site.xml
hadoop/hadoop-env.cmd
hadoop/hadoop-env.sh
hadoop/hadoop-metrics2.properties
hadoop/hadoop-policy.xml
hadoop/hadoop-user-functions.sh.example
hadoop/hdfs-site.xml
hadoop/httpfs-env.sh
hadoop/httpfs-log4j.properties
hadoop/httpfs-signature.secret
hadoop/httpfs-site.xml
hadoop/kms-acls.xml
hadoop/kms-env.sh
hadoop/kms-log4j.properties
hadoop/kms-site.xml
hadoop/log4j.properties
hadoop/mapred-env.cmd
hadoop/mapred-env.sh
hadoop/mapred-queues.xml.template
hadoop/mapred-site.xml
hadoop/slaves
hadoop/ssl-client.xml.example
hadoop/ssl-server.xml.example
hadoop/user_ec_policies.xml.template
hadoop/workers
hadoop/yarn-env.cmd
hadoop/yarn-env.sh
hadoop/yarn-site.xml
hadoop/yarnservice-log4j.properties
hadoop/shellprofile.d/example.sh

sent 5,066 bytes  received 1,655 bytes  13,442.00 bytes/sec
total size is 106,896  speedup is 15.90
[root@mini-1 etc]#
```
#### 查看文件分发情况
```
[root@mini-2 hadoop]# pwd
/data/hadoop/hadoop-3.1.1/etc/hadoop
[root@mini-2 hadoop]# cat slaves 
mini1
mini2
mini3
[root@mini-2 hadoop]#

[root@mini-3 hadoop]# pwd
/data/hadoop/hadoop-3.1.1/etc/hadoop
[root@mini-3 hadoop]# cat slaves 
mini1
mini2
mini3
[root@mini-3 hadoop]#
```
### 集群启动及测试
#### 启动集群(NameNode节点)
1.如果集群是第一次启动,需要在格式化namenode,先删除集群节点的 /data/hadoop/hadoop-3.1.1/logs文件夹
```
[root@mini-1 hadoop-3.1.1]# pwd
/data/hadoop/hadoop-3.1.1
[root@mini-1 hadoop-3.1.1]# ll
total 184
drwxr-xr-x. 2 1000 1001    183 Aug  2 13:05 bin
drwxr-xr-x. 3 1000 1001     20 Aug  2 12:28 etc
drwxr-xr-x. 2 1000 1001    106 Aug  2 13:05 include
drwxr-xr-x. 3 1000 1001     20 Aug  2 13:05 lib
drwxr-xr-x. 4 1000 1001   4096 Aug  2 13:05 libexec
-rw-r--r--. 1 1000 1001 147144 Jul 29 07:13 LICENSE.txt
drwxr-xr-x. 3 root root   4096 Oct 20 10:32 logs
-rw-r--r--. 1 1000 1001  21867 Jul 29 07:13 NOTICE.txt
-rw-r--r--. 1 1000 1001   1366 Jul 29 04:41 README.txt
drwxr-xr-x. 3 1000 1001   4096 Aug  2 12:28 sbin
drwxr-xr-x. 4 1000 1001     31 Aug  2 13:17 share
drwxr-xr-x. 5 root root     51 Oct 20 10:32 tmp
[root@mini-1 hadoop-3.1.1]# rm -rf logs/
[root@mini-1 hadoop-3.1.1]# bin/hdfs namenode -format
```
2.启动HDFS
```
[root@mini-1 hadoop-3.1.1]# sbin/start-dfs.sh
[root@mini-1 hadoop-3.1.1]# sbin/start-dfs.sh
Starting namenodes on [mini1]
ERROR: Attempting to operate on hdfs namenode as root
ERROR: but there is no HDFS_NAMENODE_USER defined. Aborting operation.
Starting datanodes
ERROR: Attempting to operate on hdfs datanode as root
ERROR: but there is no HDFS_DATANODE_USER defined. Aborting operation.
Starting secondary namenodes [mini3]
ERROR: Attempting to operate on hdfs secondarynamenode as root
ERROR: but there is no HDFS_SECONDARYNAMENODE_USER defined. Aborting operation.
[root@mini-1 hadoop-3.1.1]# 
```

出现错误,解决办法:

是因为缺少用户定义造成的，所以分别编辑开始和关闭脚本
```
$ vim sbin/start-dfs.sh 
$ vim sbin/stop-dfs.sh 
在顶部空白处添加内容： 
HDFS_DATANODE_USER=root 
HADOOP_SECURE_DN_USER=hdfs 
HDFS_NAMENODE_USER=root 
HDFS_SECONDARYNAMENODE_USER=root
```

是因为缺少用户定义造成的，所以分别编辑开始和关闭脚本 
```
$ vim sbin/start-yarn.sh 
$ vim sbin/stop-yarn.sh
在顶部空白处添加内容：
YARN_RESOURCEMANGER_USER=root
HADOOP_SECURE_DN_USER=yarn
YARN_NODEMANGER_USER=root
```

修改后，同步到其他集群:
```
[root@mini-1 hadoop-3.1.1]# xsync sbin/
```

然后再次启动：
```
[root@mini-1 hadoop-3.1.1]# sbin/start-dfs.sh
WARNING: HADOOP_SECURE_DN_USER has been replaced by HDFS_DATANODE_SECURE_USER. Using value of HADOOP_SECURE_DN_USER.
Starting namenodes on [mini1]
Last login: Thu Dec  6 08:41:57 CST 2018 from 192.168.17.1 on pts/3
Starting datanodes
Last login: Thu Dec  6 08:47:28 CST 2018 on pts/2
localhost: Warning: Permanently added 'localhost' (ECDSA) to the list of known hosts.
Starting secondary namenodes [mini3]
Last login: Thu Dec  6 08:47:31 CST 2018 on pts/2
mini3: WARNING: /data/hadoop/hadoop-3.1.1/logs does not exist. Creating.
[root@mini-1 hadoop-3.1.1]#
```

3.启动yarn



#### 集群基本测试





### hadoop启动停止方式
### 集群时间同步
### 配置集群常见问题
















### 配置hadoop资源
```
[root@mini-1 hadoop]# pwd
/data/hadoop/hadoop-3.1.1/etc/hadoop
```

#### 修改hadoop-env.sh
```
大约54行,替换本机的JAVA_HOME目录：
export JAVA_HOME=/usr/java/jdk1.8.0_171-amd64
```

#### 修改core-site.xml
```
1.文件最后<configuration> </configuration> 替换为：

<configuration>
  <!-- 指定HDFS的老大（NameNode）的地址 -->
  <property>
        <name>fs.defaultFS</name>
        <!-- mini-1为当前机器名或者ip号 -->
        <value>hdfs://mini-1:9000</value>
  </property>
  <!-- 指定hadoop运行时产生临时文件的存储目录 -->
  <!-- 配置的目录会自动创建 -->
  <property>
        <name>hadoop.tmp.dir</name>
        <value>/data/hadoop/hadoop-3.1.1/tmp</value>
  </property>
</configuration>
```

#### 修改hdfs-site.xml
```
文件最后<configuration> </configuration> 替换为:

<configuration>
  <!-- 指定 HDFS 副本的数量.不配置的话,默认值为3,根据情况设定 -->
  <!-- HDFS副本是存在不同的节点上的 -->
  <property>
      <name>dfs.replication</name>
      <value>3</value>
  </property>
</configuration>
```
#### 修改mapred-site.xml
```
文件最后<configuration> </configuration> 替换为

<configuration>
    <!-- 指定mr运行在yarn上 -->
    <property>
        <name>mapreduce.framework.name</name>
        <value>yarn</value>
   </property>
</configuration>
```
#### 修改yarn-site.xml文件
```
文件最后<configuration> </configuration> 替换为：

<configuration>
<!-- Site specific YARN configuration properties -->
   <property>
        <name>yarn.resourcemanager.hostname</name>
        <!-- 你的机器号或者ip -->
        <value>192.168.17.133</value>
   </property>
   <!-- reducer获取数据的方式 -->
   <property>
        <name>yarn.nodemanager.aux-services</name>
        <value>mapreduce_shuffle</value>
   </property>
</configuration>
```



### 拷贝hadoop资源和环境变量到其他机器

### 启动hadoop集群





















