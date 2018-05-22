---
title: zookeeper集群搭建
date: 2018-05-22 19:00:26
tags: [linux,ZooKeeper]
---
## zookeeper特性

<!-- more -->

## zookeeper下载
```
https://mirrors.tuna.tsinghua.edu.cn/apache/zookeeper/zookeeper-3.4.12/
```

## 搭建zookeeper集群
### zookeeper配置文件说明

### 简要步骤
    创建文件夹,检查jdk版本,上传zookeeper安装包
    [root@node-1 ~]# mkdir -p /export/server
    [root@node-1 /]# mkdir -p /export/data/zkdata
    检测集群时间是否同步:
        data
    关闭防火墙,centos7下关闭防火墙:
        [root@node-1 ~]# firewall-cmd --zone=public --add-port=2181/tcp --permanent
        [root@node-1 ~]# firewall-cmd --zone=public --add-port=2888/tcp --permanent
        [root@node-1 ~]# firewall-cmd --zone=public --add-port=3888/tcp --permanent
        [root@node-1 ~]# firewall-cmd --complete-reload
    检测主机ip映射有没有配置
    解压安装包: tar -zxvf zookeeper-3.4.12.tar.gz
    修改zookeeper配置文件:
        cp zoo_sample.cfg zoo.cfg
        vi zoo.cfg
        添加内容:
        dataDir=/tmp/zookeeper -> 数据存储位置,修改为 dataDir=/export/data/zkdata 
        server.1=192.168.17.130:2888:3888 (心跳端口,选举端口)
        server.2=192.168.17.131:2888:3888
        server.3=192.168.17.132:2888:3888
    在data文件夹下新建myid文件
        [root@node-1 home]# cd /export/data/zkdata/
        [root@node-1 zkdata]# echo 1 > myid
    其他机器创建文件夹
        mkdir -p /export/server
        mkdir -p /export/data/zkdata
    设置ssh免密码登录,分发安装包到其他机器
        scp -r /export/server/zookeeper root@192.168.17.131:/export/server    
    在其他机器的data文件夹下新建myid文件
        [root@node-2 home]# cd /export/data/zkdata/
        [root@node-2 zkdata]# echo 2 > myid
        [root@node-3 home]# cd /export/data/zkdata/
        [root@node-3 zkdata]# echo 3 > myid

### 实例
#### node-1节点
```
[root@node-1 ~]# mkdir -p /export/server
[root@node-1 ~]# cd /export/server/
[root@node-1 server]# ll
总用量 35812
-rw-r--r-- 1 root root 36667596 5月  22 19:13 zookeeper-3.4.12.tar.gz
[root@node-1 server]# java -version
java version "1.8.0_141"
Java(TM) SE Runtime Environment (build 1.8.0_141-b15)
Java HotSpot(TM) 64-Bit Server VM (build 25.141-b15, mixed mode)
[root@node-1 server]#
[root@node-1 server]# tar -zxvf zookeeper-3.4.12.tar.gz
[root@node-1 server]# ll
总用量 35816
drwxr-xr-x 10 docker docker     4096 3月  27 12:36 zookeeper-3.4.12
-rw-r--r--  1 root   root   36667596 5月  22 19:13 zookeeper-3.4.12.tar.gz
[root@node-1 server]# mv zookeeper-3.4.12 zookeeper
[root@node-1 conf]# pwd
/export/server/zookeeper/conf
[root@node-1 conf]# cp zoo_sample.cfg zoo.cfg
[root@node-1 conf]#
[root@node-1 conf]# cat zoo.cfg 
# The number of milliseconds of each tick
tickTime=2000
# The number of ticks that the initial 
# synchronization phase can take
initLimit=10
# The number of ticks that can pass between 
# sending a request and getting an acknowledgement
syncLimit=5
# the directory where the snapshot is stored.
# do not use /tmp for storage, /tmp here is just 
# example sakes.
dataDir=/export/data/zkdata 
# the port at which the clients will connect
clientPort=2181
# the maximum number of client connections.
# increase this if you need to handle more clients
#maxClientCnxns=60
#
# Be sure to read the maintenance section of the 
# administrator guide before turning on autopurge.
#
# http://zookeeper.apache.org/doc/current/zookeeperAdmin.html#sc_maintenance
#
# The number of snapshots to retain in dataDir
#autopurge.snapRetainCount=3
# Purge task interval in hours
# Set to "0" to disable auto purge feature
#autopurge.purgeInterval=1
server.1=192.168.17.130:2888:3888
server.2=192.168.17.131:2888:3888
server.3=192.168.17.132:2888:3888
[root@node-1 conf]#
[root@node-1 zkdata]# scp -r /export/server/zookeeper root@192.168.17.131:/export/server
[root@node-1 zkdata]# scp -r /export/server/zookeeper root@192.168.17.132:/export/server
```

#### node-2节点
```
[root@node-2 ~]# mkdir -p /export/server
[root@node-2 ~]# mkdir -p /export/data/zkdata
[root@node-2 ~]# cd /export/data/zkdata/
[root@node-2 zkdata]# echo 2 > myid
[root@node-2 zkdata]#
```

#### node-3节点
```
[root@node-3 ~]# mkdir -p /export/server
[root@node-3 ~]# mkdir -p /export/data/zkdata
[root@node-3 ~]# cd /export/data/zkdata/
[root@node-3 zkdata]# ll
总用量 0
[root@node-3 zkdata]# echo 3 > myid
[root@node-3 zkdata]# 
```

### 启动zookeeper(没有配置zookeeper的环境变量,可以用全路径启动)
#### node1节点启动及其状态
```
[root@node-1 ~]# /export/server/zookeeper/bin/zkServer.sh start
ZooKeeper JMX enabled by default
Using config: /export/server/zookeeper/bin/../conf/zoo.cfg
Starting zookeeper ... STARTED
[root@node-1 ~]# /export/server/zookeeper/bin/zkServer.sh status
ZooKeeper JMX enabled by default
Using config: /export/server/zookeeper/bin/../conf/zoo.cfg
Mode: follower
[root@node-1 ~]#
```

#### node2节点启动及其状态
```
[root@node-2 ~]# /export/server/zookeeper/bin/zkServer.sh start
ZooKeeper JMX enabled by default
Using config: /export/server/zookeeper/bin/../conf/zoo.cfg
Starting zookeeper ... STARTED
[root@node-2 ~]# /export/server/zookeeper/bin/zkServer.sh status
ZooKeeper JMX enabled by default
Using config: /export/server/zookeeper/bin/../conf/zoo.cfg
Mode: leader
[root@node-2 ~]#
```

#### node3节点启动及其状态
```
[root@node-3 ~]# /export/server/zookeeper/bin/zkServer.sh start
ZooKeeper JMX enabled by default
Using config: /export/server/zookeeper/bin/../conf/zoo.cfg
Starting zookeeper ... STARTED
[root@node-3 ~]# /export/server/zookeeper/bin/zkServer.sh status
ZooKeeper JMX enabled by default
Using config: /export/server/zookeeper/bin/../conf/zoo.cfg
Mode: follower
[root@node-3 ~]#
```

### zookeeper可能启动不成功的情况
#### 启动不成功出现的异常
```
[root@node-3 ~]# /export/server/zookeeper/bin/zkServer.sh status
ZooKeeper JMX enabled by default
Using config: /export/server/zookeeper/bin/../conf/zoo.cfg
Error contacting service. It is probably not running.
[root@node-3 ~]# ll
```

#### zookeeper启动不成功可能的原因
    1.防火墙没有关闭,三个端口(2181, 2888, 3888).
    2.集群中个myid没有设置,必须在zoo.cfg中指定的 dataDir=/export/data/zkdata 目录下,创建myid.
    3.删除 /export/data/zkdata 文件,重新创建myid文件,然后再启动zookeeper.

#### 实例及解决办法
```
[root@node-3 ~]# /export/server/zookeeper/bin/zkServer.sh start
ZooKeeper JMX enabled by default
Using config: /export/server/zookeeper/bin/../conf/zoo.cfg
Starting zookeeper ... STARTED
[root@node-3 ~]# /export/server/zookeeper/bin/zkServer.sh status
ZooKeeper JMX enabled by default
Using config: /export/server/zookeeper/bin/../conf/zoo.cfg
Error contacting service. It is probably not running.
[root@node-3 ~]# cd /export/data/
[root@node-3 data]# rm -rf zkdata/
[root@node-3 data]# ll
总用量 0
[root@node-3 data]# mkdir zkdata
[root@node-3 data]# ll
总用量 0
drwxr-xr-x. 2 root root 6 5月  23 06:21 zkdata
[root@node-3 data]# cd ..
[root@node-3 export]# ll
总用量 0
drwxr-xr-x. 3 root root 20 5月  23 06:21 data
drwxr-xr-x. 3 root root 23 5月  23 06:02 server
[root@node-3 export]# cd data/
[root@node-3 data]# ll
总用量 0
drwxr-xr-x. 2 root root 6 5月  23 06:21 zkdata
[root@node-3 data]# cd zkdata/
[root@node-3 zkdata]# ll
总用量 0
[root@node-3 zkdata]# echo 3 > myid
[root@node-3 zkdata]# cd
[root@node-3 ~]# /export/server/zookeeper/bin/zkServer.sh start
ZooKeeper JMX enabled by default
Using config: /export/server/zookeeper/bin/../conf/zoo.cfg
Starting zookeeper ... STARTED
[root@node-3 ~]# /export/server/zookeeper/bin/zkServer.sh status
ZooKeeper JMX enabled by default
Using config: /export/server/zookeeper/bin/../conf/zoo.cfg
Mode: follower
[root@node-3 ~]#
```

## zookeeper客户端连接
运行zkCli.sh -server ip 进入命令行工具
