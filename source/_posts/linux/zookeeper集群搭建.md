---
title: zookeeper集群搭建
date: 2018-05-22 19:00:26
tags: [linux,zookeeper]
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
### 客户端连接
    运行zkCli.sh -server ip 进入命令行工具,
    如果 ./zkCli.sh,则直接连接到本机的zookeeper服务端.
    如果 ./zkCli.sh -server 192.168.17.131,则直接连接到本机的zookeeper服务端.
    [root@node-3 bin]# ./zkCli.sh
    [root@node-2 bin]# ./zkCli.sh -server 192.168.17.132

```
[root@node-3 bin]# ll
总用量 36
-rwxr-xr-x. 1 root root  232 5月  23 06:02 README.txt
-rwxr-xr-x. 1 root root 1937 5月  23 06:02 zkCleanup.sh
-rwxr-xr-x. 1 root root 1056 5月  23 06:02 zkCli.cmd
-rwxr-xr-x. 1 root root 1534 5月  23 06:02 zkCli.sh
-rwxr-xr-x. 1 root root 1759 5月  23 06:02 zkEnv.cmd
-rwxr-xr-x. 1 root root 2696 5月  23 06:02 zkEnv.sh
-rwxr-xr-x. 1 root root 1089 5月  23 06:02 zkServer.cmd
-rwxr-xr-x. 1 root root 6773 5月  23 06:02 zkServer.sh
[root@node-3 bin]# ./zkCli.sh 
Connecting to localhost:2181
2018-05-23 21:40:17,225 [myid:] - INFO  [main:Environment@100] - Client environment:zookeeper.version=3.4.12-e5259e437540f349646870ea94dc2658c4e44b3b, built on 03/27/2018 03:55 GMT
2018-05-23 21:40:17,229 [myid:] - INFO  [main:Environment@100] - Client environment:host.name=node-3
2018-05-23 21:40:17,229 [myid:] - INFO  [main:Environment@100] - Client environment:java.version=1.8.0_141
2018-05-23 21:40:17,249 [myid:] - INFO  [main:Environment@100] - Client environment:java.vendor=Oracle Corporation
2018-05-23 21:40:17,249 [myid:] - INFO  [main:Environment@100] - Client environment:java.home=/usr/local/src/java/jdk1.8.0_141/jre
2018-05-23 21:40:17,249 [myid:] - INFO  [main:Environment@100] - Client environment:java.class.path=/export/server/zookeeper/bin/../build/classes:/export/server/zookeeper/bin/../build/lib/*.jar:/export/server/zookeeper/bin/../lib/slf4j-log4j12-1.7.25.jar:/export/server/zookeeper/bin/../lib/slf4j-api-1.7.25.jar:/export/server/zookeeper/bin/../lib/netty-3.10.6.Final.jar:/export/server/zookeeper/bin/../lib/log4j-1.2.17.jar:/export/server/zookeeper/bin/../lib/jline-0.9.94.jar:/export/server/zookeeper/bin/../lib/audience-annotations-0.5.0.jar:/export/server/zookeeper/bin/../zookeeper-3.4.12.jar:/export/server/zookeeper/bin/../src/java/lib/*.jar:/export/server/zookeeper/bin/../conf:.:/usr/local/src/java/jdk1.8.0_141/lib/dt.jar:/usr/local/src/java/jdk1.8.0_141/lib/tools.jar
2018-05-23 21:40:17,249 [myid:] - INFO  [main:Environment@100] - Client environment:java.library.path=/usr/java/packages/lib/amd64:/usr/lib64:/lib64:/lib:/usr/lib
2018-05-23 21:40:17,249 [myid:] - INFO  [main:Environment@100] - Client environment:java.io.tmpdir=/tmp
2018-05-23 21:40:17,250 [myid:] - INFO  [main:Environment@100] - Client environment:java.compiler=<NA>
2018-05-23 21:40:17,250 [myid:] - INFO  [main:Environment@100] - Client environment:os.name=Linux
2018-05-23 21:40:17,250 [myid:] - INFO  [main:Environment@100] - Client environment:os.arch=amd64
2018-05-23 21:40:17,250 [myid:] - INFO  [main:Environment@100] - Client environment:os.version=3.10.0-693.2.2.el7.x86_64
2018-05-23 21:40:17,250 [myid:] - INFO  [main:Environment@100] - Client environment:user.name=root
2018-05-23 21:40:17,250 [myid:] - INFO  [main:Environment@100] - Client environment:user.home=/root
2018-05-23 21:40:17,250 [myid:] - INFO  [main:Environment@100] - Client environment:user.dir=/export/server/zookeeper/bin
2018-05-23 21:40:17,251 [myid:] - INFO  [main:ZooKeeper@441] - Initiating client connection, connectString=localhost:2181 sessionTimeout=30000 watcher=org.apache.zookeeper.ZooKeeperMain$MyWatcher@255316f2
Welcome to ZooKeeper!
2018-05-23 21:40:17,393 [myid:] - INFO  [main-SendThread(localhost:2181):ClientCnxn$SendThread@1028] - Opening socket connection to server localhost/0:0:0:0:0:0:0:1:2181. Will not attempt to authenticate using SASL (unknown error)
JLine support is enabled
2018-05-23 21:40:17,669 [myid:] - INFO  [main-SendThread(localhost:2181):ClientCnxn$SendThread@878] - Socket connection established to localhost/0:0:0:0:0:0:0:1:2181, initiating session
[zk: localhost:2181(CONNECTING) 0] 2018-05-23 21:40:17,738 [myid:] - INFO  [main-SendThread(localhost:2181):ClientCnxn$SendThread@1302] - Session establishment complete on server localhost/0:0:0:0:0:0:0:1:2181, sessionid = 0x3000086aaf10000, negotiated timeout = 30000

WATCHER::

WatchedEvent state:SyncConnected type:None path:null
```

### 创建节点
```
create [-s] [-e] path data acl
-s表示序列化节点
-e表示临时节点，不加表示永久节点
acl用来进行权限控制
临时节点,客户端断开连接后,zookeeper会在一段时间后自动删除该临时节点
```

```
WatchedEvent state:SyncConnected type:None path:null
[zk: 192.168.17.132(CONNECTED) 0] create /hellozk 123 
Created /hellozk
[zk: 192.168.17.132(CONNECTED) 1] ls /
[zookeeper, hellozk]
[zk: 192.168.17.132(CONNECTED) 2] create -e /zktemp 123456
Created /zktemp
[zk: 192.168.17.132(CONNECTED) 3] ls /
[zookeeper, zktemp, hellozk]
[zk: 192.168.17.132(CONNECTED) 4] ls /
[zookeeper, zktemp, hellozk]
[zk: 192.168.17.132(CONNECTED) 5] create -s /a 12abcd
Created /a0000000002
[zk: 192.168.17.132(CONNECTED) 6] ls
[zk: 192.168.17.132(CONNECTED) 7] ls /
[a0000000002, zookeeper, zktemp, hellozk]
[zk: 192.168.17.132(CONNECTED) 8]
[zk: 192.168.17.132(CONNECTED) 9] create -s /hellozk/a 56789
Created /hellozk/a0000000000
[zk: 192.168.17.132(CONNECTED) 10] ls /
[a0000000002, zookeeper, zktemp, hellozk]
[zk: 192.168.17.132(CONNECTED) 11] ls /hellozk/
Command failed: java.lang.IllegalArgumentException: Path must not end with / character
[zk: 192.168.17.132(CONNECTED) 12] ls /hellozk/a
Node does not exist: /hellozk/a
[zk: 192.168.17.132(CONNECTED) 16] ls /hellozk  
[a0000000000]
[zk: 192.168.17.132(CONNECTED) 17]
```

### 读取节点
```
ls path [watch]
get path [watch]
ls2 path [watch]
```

```
[zk: 192.168.17.132(CONNECTED) 19] get /

cZxid = 0x0
ctime = Thu Jan 01 08:00:00 CST 1970
mZxid = 0x0
mtime = Thu Jan 01 08:00:00 CST 1970
pZxid = 0x4200000005
cversion = 2
dataVersion = 0
aclVersion = 0
ephemeralOwner = 0x0
dataLength = 0
numChildren = 4
[zk: 192.168.17.132(CONNECTED) 20] ls /
[a0000000002, zookeeper, zktemp, hellozk]
[zk: 192.168.17.132(CONNECTED) 21] ls2 /
[a0000000002, zookeeper, zktemp, hellozk]
cZxid = 0x0
ctime = Thu Jan 01 08:00:00 CST 1970
mZxid = 0x0
mtime = Thu Jan 01 08:00:00 CST 1970
pZxid = 0x4200000005
cversion = 2
dataVersion = 0
aclVersion = 0
ephemeralOwner = 0x0
dataLength = 0
numChildren = 4
[zk: 192.168.17.132(CONNECTED) 29] get /hellozk
123
cZxid = 0x4200000003
ctime = Wed May 23 21:49:05 CST 2018
mZxid = 0x4200000003
mtime = Wed May 23 21:49:05 CST 2018
pZxid = 0x4200000006
cversion = 1
dataVersion = 0
aclVersion = 0
ephemeralOwner = 0x0
dataLength = 3
numChildren = 1
[zk: 192.168.17.132(CONNECTED) 30]
```

### 更新节点
```
set path data [version]
data 就是要更新的内容，version表示数据版本.
```

```
[zk: 192.168.17.132(CONNECTED) 29] get /hellozk
123
cZxid = 0x4200000003
ctime = Wed May 23 21:49:05 CST 2018
mZxid = 0x4200000003
mtime = Wed May 23 21:49:05 CST 2018
pZxid = 0x4200000006
cversion = 1
dataVersion = 0
aclVersion = 0
ephemeralOwner = 0x0
dataLength = 3
numChildren = 1
[zk: 192.168.17.132(CONNECTED) 30] set /hellozk 123456
cZxid = 0x4200000003
ctime = Wed May 23 21:49:05 CST 2018
mZxid = 0x4200000007
mtime = Wed May 23 22:14:13 CST 2018
pZxid = 0x4200000006
cversion = 1
dataVersion = 1
aclVersion = 0
ephemeralOwner = 0x0
dataLength = 6
numChildren = 1
[zk: 192.168.17.132(CONNECTED) 31]
```

### 删除节点
```
dalete path [version]
若删除节点存在子节点，那么无法删除该节点，必须先删除子节点，再删除父节点.
rmr path : 可以递归删除节点
```

```
[zk: 192.168.17.132(CONNECTED) 31] delete /hellozk
Node not empty: /hellozk
[zk: 192.168.17.132(CONNECTED) 32] ls /hellozk
[a0000000000]
[zk: 192.168.17.132(CONNECTED) 34] rmr /hellozk
[zk: 192.168.17.132(CONNECTED) 35] ls /
[a0000000002, zookeeper, zktemp]
[zk: 192.168.17.132(CONNECTED) 36]
```

## ZooKeeper Watcher
ZooKeeper 提供了分布式数据的发布/订阅功能。一个典型的发布/订阅模型系统定义了一种一对多的订阅关系，能够让多个订阅者同时监听某一个主题对象，当这个主题自身状态变化时，会通知所有订阅者，试它们能够做出相应的处理。

在 ZooKeeper 中，引入了 Watcher 机制来实现这种分布式的通知功能。ZooKeeper 允许客户端向服务端注册一个 Watcher 监听，当服务器的一些特定事件触发了这个 Watcher，那么就会向指定客户端发送一个事件通知来实现分布式的通知功能。

总的来说watcher包括以下三个过程：客户端向

### Watcher工作机制
ZooKeeper的Watcher机制，总的来说可以分为三个过程：客户端向服务端注册 Watcher、服务器处理Watcher、客户端回调Watcher得到触发时间的情况。

### shell客户端设置watcher
#### 设置节点数据变动监听: get /a watch
```
[zk: 192.168.17.132(CONNECTED) 37] ls /
[a0000000002, zookeeper, zktemp, w]
[zk: 192.168.17.132(CONNECTED) 38] get /w
123
cZxid = 0x420000000b
ctime = Wed May 23 22:33:51 CST 2018
mZxid = 0x420000000b
mtime = Wed May 23 22:33:51 CST 2018
pZxid = 0x420000000b
cversion = 0
dataVersion = 0
aclVersion = 0
ephemeralOwner = 0x0
dataLength = 3
numChildren = 0
[zk: 192.168.17.132(CONNECTED) 39] get /w watch
123
cZxid = 0x420000000b
ctime = Wed May 23 22:33:51 CST 2018
mZxid = 0x420000000b
mtime = Wed May 23 22:33:51 CST 2018
pZxid = 0x420000000b
cversion = 0
dataVersion = 0
aclVersion = 0
ephemeralOwner = 0x0
dataLength = 3
numChildren = 0
[zk: 192.168.17.132(CONNECTED) 40]
```

#### 通过另一个客户端更改节点数据: set /a hello12222
```
[zk: localhost:2181(CONNECTED) 4] set /w abcdefg123456
cZxid = 0x420000000b
ctime = Wed May 23 22:33:51 CST 2018
mZxid = 0x420000000c
mtime = Wed May 23 22:34:40 CST 2018
pZxid = 0x420000000b
cversion = 0
dataVersion = 1
aclVersion = 0
ephemeralOwner = 0x0
dataLength = 13
numChildren = 0
[zk: localhost:2181(CONNECTED) 5]
```

#### 设置监听的节点会受到通知
注意：watch监听是一次性触发的,一旦生效后,下次有同样的事件发生,这里也得不到通知;

如果想要再次得到监听,需要再次进行注册.

```
[zk: 192.168.17.132(CONNECTED) 40] 
WATCHER::

WatchedEvent state:SyncConnected type:NodeDataChanged path:/w
```
