---
title: zookeeper单机搭建
date: 2018-09-18 14:54:41
tags: [linux,zookeeper,bigdata]
---

## 下载zookeeper
```
https://archive.apache.org/dist/zookeeper/zookeeper-3.4.13/
```
<!-- more -->

## windows上安装
```
1.解压zookeeper-3.4.13.tar.gz

2.运行zkServer.cmd ，初次运行会报错，没有zoo.cfg配置文件
    D:\software\devlop_software\zookeeper-3.4.13\bin>zkServer.cmd
3.修改zoo.cfg配置文件
    将conf下的zoo_sample.cfg复制一份改名为zoo.cfg即可。
    注意几个重要位置：
    dataDir=./   临时数据存储的目录（可写相对路径）
    clientPort=2181   zookeeper的端口号
    修改完成后再次启动zookeeper

4.使用zkCli.cmd测试
    ls /：列出zookeeper根下保存的所有节点
    create –e /test 123：创建一个test节点，值为123
    get /test：获取/test节点的值
```
## linux上安装
### 解压zookeeper-3.4.13.tar.gz
```bash
[root@node-1 zk]# pwd
/data/zk
[root@node-1 zk]# tar -zxvf zookeeper-3.4.13.tar.gz
[root@node-1 zk]# ll
总用量 36328
drwxr-xr-x 11  501 games     4096 9月  19 06:31 zookeeper-3.4.13
-rw-r--r--  1 root root  37191810 9月  18 07:04 zookeeper-3.4.13.tar.gz
[root@node-1 zk]# cd zookeeper-3.4.13
[root@node-1 zookeeper-3.4.13]# ll
总用量 1628
drwxr-xr-x  2  501 games     223 9月  19 06:33 bin
-rw-r--r--  1  501 games   91400 6月  30 01:04 build.xml
drwxr-xr-x  2  501 games      92 9月  19 06:30 conf
drwxr-xr-x 10  501 games     130 9月  19 06:29 contrib
drwxr-xr-x  2  501 games    4096 9月  19 06:29 dist-maven
drwxr-xr-x  6  501 games    4096 9月  19 06:29 docs
-rw-r--r--  1  501 games    1709 6月  30 01:04 ivysettings.xml
-rw-r--r--  1  501 games    8502 6月  30 01:04 ivy.xml
drwxr-xr-x  4  501 games     308 9月  19 06:29 lib
-rw-r--r--  1  501 games   11938 6月  30 01:04 LICENSE.txt
-rw-r--r--  1  501 games    3132 6月  30 01:04 NOTICE.txt
-rw-r--r--  1  501 games    1585 6月  30 01:04 README.md
-rw-r--r--  1  501 games    1770 6月  30 01:04 README_packaging.txt
drwxr-xr-x  5  501 games      47 9月  19 06:29 recipes
drwxr-xr-x  8  501 games     211 6月  30 01:04 src
drwxr-xr-x  3 root root       23 9月  19 06:35 zkdata
-rw-r--r--  1  501 games 1508639 6月  30 01:05 zookeeper-3.4.13.jar
-rw-r--r--  1  501 games     833 7月   1 07:36 zookeeper-3.4.13.jar.asc
-rw-r--r--  1  501 games      33 6月  30 01:05 zookeeper-3.4.13.jar.md5
-rw-r--r--  1  501 games      41 6月  30 01:05 zookeeper-3.4.13.jar.sha1
[root@node-1 zookeeper-3.4.13]#
```

### 配置zookeeper
初始化zookeeper配置文件,启动zookeeper

```
[root@node-1 zookeeper-3.4.13]# cd conf/
[root@node-1 conf]# ll
总用量 12
-rw-r--r-- 1 501 games  535 6月  30 01:04 configuration.xsl
-rw-r--r-- 1 501 games 2161 6月  30 01:04 log4j.properties
-rw-r--r-- 1 501 games  922 6月  30 01:04 zoo_sample.cfg
[root@node-1 conf]# cp zoo_sample.cfg zoo.cfg
[root@node-1 conf]# ll
总用量 16
-rw-r--r-- 1  501 games  535 6月  30 01:04 configuration.xsl
-rw-r--r-- 1  501 games 2161 6月  30 01:04 log4j.properties
-rw-r--r-- 1 root root   922 9月  19 06:29 zoo.cfg
-rw-r--r-- 1  501 games  922 6月  30 01:04 zoo_sample.cfg
[root@node-1 conf]# vim zoo.cfg 
```

在conf的上一级目录创建 zkdata 文件夹, mkdir zkdata;修改 zoo.cfg 配置中的 dataDir=../zkdata

```
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
dataDir=../zkdata
# the port at which the clients will connect
clientPort=2181
```

### 启动zookeeper
```
[root@node-1 zookeeper-3.4.13]# cd bin/
[root@node-1 bin]# ll
总用量 44
-rwxr-xr-x 1 501 games  232 6月  30 01:04 README.txt
-rwxr-xr-x 1 501 games 1937 6月  30 01:04 zkCleanup.sh
-rwxr-xr-x 1 501 games 1056 6月  30 01:04 zkCli.cmd
-rwxr-xr-x 1 501 games 1534 6月  30 01:04 zkCli.sh
-rwxr-xr-x 1 501 games 1759 6月  30 01:04 zkEnv.cmd
-rwxr-xr-x 1 501 games 2696 6月  30 01:04 zkEnv.sh
-rwxr-xr-x 1 501 games 1089 6月  30 01:04 zkServer.cmd
-rwxr-xr-x 1 501 games 6773 6月  30 01:04 zkServer.sh
-rwxr-xr-x 1 501 games  996 6月  30 01:04 zkTxnLogToolkit.cmd
-rwxr-xr-x 1 501 games 1385 6月  30 01:04 zkTxnLogToolkit.sh
[root@node-1 bin]# ./zkServer.sh
ZooKeeper JMX enabled by default
Using config: /root/data/zk/zookeeper-3.4.13/bin/../conf/zoo.cfg
Usage: ./zkServer.sh {start|start-foreground|stop|restart|status|upgrade|print-cmd}
[root@node-1 bin]#
[root@node-1 bin]# ./zkServer.sh start
ZooKeeper JMX enabled by default
Using config: /data/zk/zookeeper-3.4.13/bin/../conf/zoo.cfg
Starting zookeeper ... STARTED
[root@node-1 bin]#
[root@node-1 bin]# ./zkServer.sh status
ZooKeeper JMX enabled by default
Using config: /data/zk/zookeeper-3.4.13/bin/../conf/zoo.cfg
Mode: standalone
[root@node-1 bin]# jps -l
2203 org.apache.zookeeper.server.quorum.QuorumPeerMain
2445 sun.tools.jps.Jps
[root@node-1 bin]# ./zkServer.sh stop
ZooKeeper JMX enabled by default
Using config: /data/zk/zookeeper-3.4.13/bin/../conf/zoo.cfg
Stopping zookeeper ... STOPPED
[root@node-1 bin]# ./zkServer.sh status
ZooKeeper JMX enabled by default
Using config: /data/zk/zookeeper-3.4.13/bin/../conf/zoo.cfg
Error contacting service. It is probably not running.
[root@node-1 bin]# jps -l
2594 sun.tools.jps.Jps
[root@node-1 bin]#
```

### zkCli测试
```
[root@node-1 bin]# ./zkCli.sh
Connecting to localhost:2181
2018-09-17 17:30:04,394 [myid:] - INFO  [main:Environment@100] - Client environment:zookeeper.version=3.4.13-2d71af4dbe22557fda74f9a9b4309b15a7487f03, built on 06/29/2018 04:05 GMT
2018-09-17 17:30:04,401 [myid:] - INFO  [main:Environment@100] - Client environment:host.name=master
2018-09-17 17:30:04,401 [myid:] - INFO  [main:Environment@100] - Client environment:java.version=1.8.0_131
2018-09-17 17:30:04,406 [myid:] - INFO  [main:Environment@100] - Client environment:java.vendor=Oracle Corporation
2018-09-17 17:30:04,406 [myid:] - INFO  [main:Environment@100] - Client environment:java.home=/usr/java/jdk1.8.0_131/jre
2018-09-17 17:30:04,407 [myid:] - INFO  [main:Environment@100] - Client environment:java.class.path=/root/data/zk/zookeeper-3.4.13/bin/../build/classes:/root/data/zk/zookeeper-3.4.13/bin/../build/lib/*.jar:/root/data/zk/zookeeper-3.4.13/bin/../lib/slf4j-log4j12-1.7.25.jar:/root/data/zk/zookeeper-3.4.13/bin/../lib/slf4j-api-1.7.25.jar:/root/data/zk/zookeeper-3.4.13/bin/../lib/netty-3.10.6.Final.jar:/root/data/zk/zookeeper-3.4.13/bin/../lib/log4j-1.2.17.jar:/root/data/zk/zookeeper-3.4.13/bin/../lib/jline-0.9.94.jar:/root/data/zk/zookeeper-3.4.13/bin/../lib/audience-annotations-0.5.0.jar:/root/data/zk/zookeeper-3.4.13/bin/../zookeeper-3.4.13.jar:/root/data/zk/zookeeper-3.4.13/bin/../src/java/lib/*.jar:/root/data/zk/zookeeper-3.4.13/bin/../conf:
2018-09-17 17:30:04,407 [myid:] - INFO  [main:Environment@100] - Client environment:java.library.path=/usr/java/packages/lib/amd64:/usr/lib64:/lib64:/lib:/usr/lib
2018-09-17 17:30:04,407 [myid:] - INFO  [main:Environment@100] - Client environment:java.io.tmpdir=/tmp
2018-09-17 17:30:04,407 [myid:] - INFO  [main:Environment@100] - Client environment:java.compiler=<NA>
2018-09-17 17:30:04,407 [myid:] - INFO  [main:Environment@100] - Client environment:os.name=Linux
2018-09-17 17:30:04,408 [myid:] - INFO  [main:Environment@100] - Client environment:os.arch=amd64
2018-09-17 17:30:04,408 [myid:] - INFO  [main:Environment@100] - Client environment:os.version=3.10.0-514.26.1.el7.x86_64
2018-09-17 17:30:04,408 [myid:] - INFO  [main:Environment@100] - Client environment:user.name=root
2018-09-17 17:30:04,408 [myid:] - INFO  [main:Environment@100] - Client environment:user.home=/root
2018-09-17 17:30:04,408 [myid:] - INFO  [main:Environment@100] - Client environment:user.dir=/root/data/zk/zookeeper-3.4.13/bin
2018-09-17 17:30:04,411 [myid:] - INFO  [main:ZooKeeper@442] - Initiating client connection, connectString=localhost:2181 sessionTimeout=30000 watcher=org.apache.zookeeper.ZooKeeperMain$MyWatcher@7aec35a
Welcome to ZooKeeper!
2018-09-17 17:30:04,454 [myid:] - INFO  [main-SendThread(localhost:2181):ClientCnxn$SendThread@1029] - Opening socket connection to server localhost/127.0.0.1:2181. Will not attempt to authenticate using SASL (unknown error)
JLine support is enabled
2018-09-17 17:30:04,540 [myid:] - INFO  [main-SendThread(localhost:2181):ClientCnxn$SendThread@879] - Socket connection established to localhost/127.0.0.1:2181, initiating session
2018-09-17 17:30:04,577 [myid:] - INFO  [main-SendThread(localhost:2181):ClientCnxn$SendThread@1303] - Session establishment complete on server localhost/127.0.0.1:2181, sessionid = 0x106a7b3a2c30000, negotiated timeout = 30000

WATCHER::

WatchedEvent state:SyncConnected type:None path:null
[zk: localhost:2181(CONNECTED) 0] create /hellozk 123
Created /hellozk
[zk: localhost:2181(CONNECTED) 1] ls /
[zookeeper, hellozk]
```

### 设置开机启动zookeeper
#### 查看配置
```
[root@node-1 bin]# cd /etc/init.d/
[root@node-1 init.d]# ll
总用量 40
lrwxrwxrwx. 1 root root    27 7月  21 2017 app -> /usr/local/src/apps/app.jar
-rw-r--r--. 1 root root 17500 5月   3 2017 functions
-rwxr-xr-x. 1 root root  4334 5月   3 2017 netconsole
-rwxr-xr-x. 1 root root  7293 5月   3 2017 network
-rw-r--r--. 1 root root  1160 9月   7 2017 README
[root@node-1 init.d]#
[root@node-1 init.d]# echo $JAVA_HOME
/usr/local/src/java/jdk1.8.0_141
[root@node-1 init.d]# 
```

#### 编辑zookeeper的脚本
```
[root@node-1 init.d]# vim zookeeper
[root@node-1 init.d]# ll
总用量 44
lrwxrwxrwx. 1 root root    27 7月  21 2017 app -> /usr/local/src/apps/app.jar
-rw-r--r--. 1 root root 17500 5月   3 2017 functions
-rwxr-xr-x. 1 root root  4334 5月   3 2017 netconsole
-rwxr-xr-x. 1 root root  7293 5月   3 2017 network
-rw-r--r--. 1 root root  1160 9月   7 2017 README
-rw-r--r--  1 root root   419 9月  19 06:42 zookeeper
[root@node-1 init.d]#
[root@node-1 init.d]# cat zookeeper 
#!/bin/bash
#chkconfig:2345 20 90
#description:zookeeper
#processname:zookeeper
ZK_PATH=/data/zk/zookeeper-3.4.13
export JAVA_HOME=/usr/local/src/java/jdk1.8.0_141
case $1 in
     start) sh  $ZK_PATH/bin/zkServer.sh start;;
     stop)  sh  $ZK_PATH/bin/zkServer.sh stop;;
     status) sh  $ZK_PATH/bin/zkServer.sh status;;
     restart) sh $ZK_PATH/bin/zkServer.sh restart;;
     *)  echo "require start|stop|status|restart"  ;;
esac
[root@node-1 init.d]#
```

#### 增加权限
```
[root@node-1 init.d]# chmod +x /etc/init.d/zookeeper 
[root@node-1 init.d]# ll
总用量 44
lrwxrwxrwx. 1 root root    27 7月  21 2017 app -> /usr/local/src/apps/app.jar
-rw-r--r--. 1 root root 17500 5月   3 2017 functions
-rwxr-xr-x. 1 root root  4334 5月   3 2017 netconsole
-rwxr-xr-x. 1 root root  7293 5月   3 2017 network
-rw-r--r--. 1 root root  1160 9月   7 2017 README
-rwxr-xr-x  1 root root   419 9月  19 06:42 zookeeper
[root@node-1 init.d]#
```

### 把脚本注册为service服务
#### 配置 
```
[root@node-1 init.d]# chkconfig --list

注：该输出结果只显示 SysV 服务，并不包含
原生 systemd 服务。SysV 配置数据
可能被原生 systemd 配置覆盖。 

      要列出 systemd 服务，请执行 'systemctl list-unit-files'。
      查看在具体 target 启用的服务请执行
      'systemctl list-dependencies [target]'。

netconsole      0:关 1:关 2:关 3:关 4:关 5:关 6:关
network         0:关 1:关 2:开 3:开 4:开 5:开 6:关
[root@node-1 init.d]# chkconfig --add zookeeper
[root@node-1 init.d]# chkconfig --list

注：该输出结果只显示 SysV 服务，并不包含
原生 systemd 服务。SysV 配置数据
可能被原生 systemd 配置覆盖。 

      要列出 systemd 服务，请执行 'systemctl list-unit-files'。
      查看在具体 target 启用的服务请执行
      'systemctl list-dependencies [target]'。

netconsole      0:关 1:关 2:关 3:关 4:关 5:关 6:关
network         0:关 1:关 2:开 3:开 4:开 5:开 6:关
zookeeper       0:关 1:关 2:开 3:开 4:开 5:开 6:关
[root@node-1 init.d]#
```

#### 测试service命令 
```
[root@node-1 init.d]# jps -l
4166 sun.tools.jps.Jps
[root@node-1 init.d]# service zookeeper start
ZooKeeper JMX enabled by default
Using config: /data/zk/zookeeper-3.4.13/bin/../conf/zoo.cfg
Starting zookeeper ... STARTED
[root@node-1 init.d]# jps -l
4296 sun.tools.jps.Jps
4233 org.apache.zookeeper.server.quorum.QuorumPeerMain
[root@node-1 init.d]#
[root@node-1 init.d]# service zookeeper stops
require start|stop|status|restart
[root@node-1 init.d]#
[root@node-1 init.d]# service zookeeper stop
ZooKeeper JMX enabled by default
Using config: /data/zk/zookeeper-3.4.13/bin/../conf/zoo.cfg
Stopping zookeeper ... STOPPED
[root@node-1 init.d]# jps -l
4458 sun.tools.jps.Jps
[root@node-1 init.d]#
```

#### 测试systemctl命令
```
[root@node-1 init.d]# systemctl start zookeeper
[root@node-1 init.d]# jps -l
4519 org.apache.zookeeper.server.quorum.QuorumPeerMain
4585 sun.tools.jps.Jps
[root@node-1 init.d]# service zookeeper status
ZooKeeper JMX enabled by default
Using config: /data/zk/zookeeper-3.4.13/bin/../conf/zoo.cfg
Mode: standalone
[root@node-1 init.d]# systemctl status zookeeper
● zookeeper.service - SYSV: zookeeper
   Loaded: loaded (/etc/rc.d/init.d/zookeeper; bad; vendor preset: disabled)
   Active: active (running) since 三 2018-09-19 06:50:50 CST; 51s ago
     Docs: man:systemd-sysv-generator(8)
  Process: 4509 ExecStart=/etc/rc.d/init.d/zookeeper start (code=exited, status=0/SUCCESS)
   CGroup: /system.slice/zookeeper.service
           └─4519 /usr/local/src/java/jdk1.8.0_141/bin/java -Dzookeeper.log.dir=. -Dzookeeper.root.logger=INFO,CONSOLE -cp /data/zk/zookeeper-3.4.13/bin/../build/cl...

9月 19 06:50:48 node-1 systemd[1]: Starting SYSV: zookeeper...
9月 19 06:50:49 node-1 zookeeper[4509]: ZooKeeper JMX enabled by default
9月 19 06:50:49 node-1 zookeeper[4509]: Using config: /data/zk/zookeeper-3.4.13/bin/../conf/zoo.cfg
9月 19 06:50:50 node-1 zookeeper[4509]: Starting zookeeper ... STARTED
9月 19 06:50:50 node-1 systemd[1]: Started SYSV: zookeeper.
[root@node-1 init.d]#
[root@node-1 init.d]# service zookeeper status
ZooKeeper JMX enabled by default
Using config: /data/zk/zookeeper-3.4.13/bin/../conf/zoo.cfg
Mode: standalone
[root@node-1 init.d]# 
```



