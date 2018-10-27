---
title: hadoop集群搭建
date: 2018-10-11 22:57:05
tags: [hadoop,bigdata]
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


## 完全分布式部署Hadoop
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





















